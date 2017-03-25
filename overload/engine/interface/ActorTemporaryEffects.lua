-- TE4 - T-Engine 4
-- Copyright (C) 2009 - 2017 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

require "engine.class"

--- Handles actors temporary effects (temporary boost of a stat, ...)
-- @classmod engine.generator.interface.ActorTemporaryEffects
module(..., package.seeall, class.make)

_M.tempeffect_def = {}

--- Defines actor temporary effects
-- @static
function _M:loadDefinition(file, env)
	env = env or setmetatable({
		DamageType = require "engine.DamageType",
		TemporaryEffects = self,
		newEffect = function(t) self:newEffect(t) end,
		load = function(f) self:loadDefinition(f, env) end
	}, {__index=getfenv(2)})
	local f, err = util.loadfilemods(file, env)
	if not f and err then error(err) end
	f()
end

--- Defines one effect
-- @static
function _M:newEffect(t)
	assert(t.name, "no effect name")
	assert(t.desc, "no effect desc")
	assert(t.type, "no effect type")
	t.name = t.name:upper()
	t.activation = t.activation or function() end
	t.deactivation = t.deactivation or function() end
	t.parameters = t.parameters or {}
	t.type = t.type or "physical"
	t.status = t.status or "detrimental"
	t.decrease = t.decrease or 1

	self.tempeffect_def["EFF_"..t.name] = t
	t.id = "EFF_"..t.name
	self["EFF_"..t.name] = "EFF_"..t.name
end

--- init
function _M:init(t)
	self.tmp = self.tmp or {}
end

--- Returns the effect definition
function _M:getEffectFromId(id)
	if type(id) == "table" then return id end
	return _M.tempeffect_def[id]
end

--- Counts down timed effects, call from your actors "act" method
-- @param filter if not nil a function that gets passed the effect and its parameters, must return true to handle the effect
function _M:timedEffects(filter)
	local todel = {}
	local def
	for eff, p in pairs(self.tmp) do
		def = _M.tempeffect_def[eff]
		if not filter or filter(def, p) then
			if p.dur <= 0 then
				todel[#todel+1] = eff
			else
				if def.on_timeout then
					if p.src then p.src.__project_source = p end -- intermediate projector source
					if def.on_timeout(self, p, def) then
						todel[#todel+1] = eff
					end
					if p.src then p.src.__project_source = nil end
				end
			end
			p.dur = p.dur - def.decrease
		end
	end

	while #todel > 0 do
		self:removeEffect(table.remove(todel))
	end
end

--- Sets a timed effect on the actor
-- @param eff_id the effect to set
-- @param dur the number of turns to go on
-- @param p a table containing the effects parameters
-- @param silent true to suppress messages
function _M:setEffect(eff_id, dur, p, silent)
	local had = self.tmp[eff_id]

	-- Beware, setting to 0 means removing
	if dur <= 0 then return self:removeEffect(eff_id) end
	dur = math.floor(dur)

	local ed = _M.tempeffect_def[eff_id]
	for k, e in pairs(ed.parameters) do
		if not p[k] then p[k] = e end
	end
	p.dur = dur
	p.effect_id = eff_id
	if self:check("on_set_temporary_effect", eff_id, ed, p) then return end
	if p.dur <= 0 then return self:removeEffect(eff_id) end

	-- If we already have it, we check if it knows how to "merge", or else we remove it and re-add it
	if self:hasEffect(eff_id) then
		if ed.on_merge then
			self.tmp[eff_id] = ed.on_merge(self, self.tmp[eff_id], p, ed)
			self.changed = true
			return
		else
			self:removeEffect(eff_id, true, true)
		end
	end

	self.tmp[eff_id] = p
	p.__setting_up = true
	if ed.on_gain then
		local ret, fly = ed.on_gain(self, p)
		if not silent and not had then
			if ret then
				--game.logSeen(self, ret:gsub("#Target#", self.name:capitalize()):gsub("#target#", self.name))
				game.logSeen(self, ret,self.name)
			end
			if fly and game.flyers and self.x and self.y and game.level.map.seens(self.x, self.y) then
				if fly == true then fly = "+"..ed.desc end
				local sx, sy = game.level.map:getTileToScreen(self.x, self.y, true)
				if game.level.map.seens(self.x, self.y) then game.flyers:add(sx, sy, 20, (rng.range(0,2)-1) * 0.5, -3, fly, {255,100,80}) end
			end
		end
	end
	if ed.activate then ed.activate(self, p, ed) end

	if ed.lists then
		local lists = ed.lists
		if 'table' ~= type(lists) then lists = {lists} end
		for _, list in ipairs(lists) do
			if 'table' == type(list) then
				list = table.getTable(self, unpack(list))
			else
				list = table.getTable(self, list)
			end
			table.insert(list, eff_id)
		end
	end

	self.changed = true
	self:check("on_temporary_effect_added", eff_id, ed, p)
	p.__setting_up = nil
end

--- Check timed effect
-- @param eff_id the effect to check for
-- @return[1] nil
-- @return[2] the parameters table for the effect
function _M:hasEffect(eff_id)
	return self.tmp[eff_id]
end

--- Removes the effect
function _M:removeEffect(eff, silent, force)
	local p = self.tmp[eff]
	if not p then return end

	-- Make sure we're not trying to remove an effect currently being setup, if so we delay that order til the end of the tick (and recheck)
	if p.__setting_up then
		game:onTickEnd(function()
			local p = self.tmp[eff]
			if not p then return end
			if p.__setting_up then return end --- WHUT ??
			self:removeEffect(eff, silent, force)
		end)
		return
	end

	if _M.tempeffect_def[eff].no_remove and not force then return end
	self.tmp[eff] = nil
	self.changed = true
	local ed = _M.tempeffect_def[eff]
	if ed.on_lose then
		local ret, fly = ed.on_lose(self, p)
		if not silent then
			if ret then
				--game.logSeen(self, ret:gsub("#Target#", self.name:capitalize()):gsub("#target#", self.name))
				game.logSeen(self, ret,self.name)
			end
			if fly and game.flyers and self.x and self.y then
				if fly == true then fly = "-"..ed.desc end
				local sx, sy = game.level.map:getTileToScreen(self.x, self.y, true)
				if game.level.map.seens(self.x, self.y) then game.flyers:add(sx, sy, 20, (rng.range(0,2)-1) * 0.5, -3, fly, {255,100,80}) end
			end
		end
	end
	if p.__tmpvals then
		for i = 1, #p.__tmpvals do
			self:removeTemporaryValue(p.__tmpvals[i][1], p.__tmpvals[i][2])
		end
	end
	if p.__tmpparticles then
		for i = 1, #p.__tmpparticles do
			self:removeParticles(p.__tmpparticles[i])
		end
	end
	if ed.deactivate then ed.deactivate(self, p, ed) end
	if ed.lists then
		local lists = ed.lists
		if 'table' ~= type(lists) then lists = {lists} end
		for _, list in ipairs(lists) do
			if 'table' == type(list) then
				list = table.getTable(self, unpack(list))
			else
				list = table.getTable(self, list)
			end
			table.removeFromList(list, eff_id)
		end
	end

	self:check("on_temporary_effect_removed", eff, ed, p)
end

--- Copy an effect ensuring temporary values are managed properly
-- @param eff_id the effect to copy
-- @return[1] nil
-- @return[2] the parameters table for the effect
function _M:copyEffect(eff_id)
	if not self then return nil end
	local param = table.clone( self:hasEffect(eff_id) )
	param.__tmpvals = nil

	return param
end

--- Reduces time remaining
function _M:alterEffectDuration(eff_id, v)
	local e = self.tmp[eff_id]
	if not e then return end
	e.dur = e.dur + v
	if e.dur <= 0 then self:removeEffect(eff_id) return true end
end

--- Removes the effect
function _M:removeAllEffects()
	local todel = {}
	for eff, p in pairs(self.tmp) do
		todel[#todel+1] = eff
	end

	while #todel > 0 do
		self:removeEffect(table.remove(todel))
	end
end

--- Helper function to add temporary values and not have to remove them manualy
function _M:effectTemporaryValue(eff, k, v)
	if not eff.__tmpvals then eff.__tmpvals = {} end
	eff.__tmpvals[#eff.__tmpvals+1] = {k, self:addTemporaryValue(k, v)}
end

--- Helper function to add particles and not have to remove them manualy
function _M:effectParticles(eff, ...)
	local Particles = require "engine.Particles"
	if not eff.__tmpparticles then eff.__tmpparticles = {} end
	for _, p in ipairs{...} do
		eff.__tmpparticles[#eff.__tmpparticles+1] = self:addParticles(Particles.new(p.type, 1, p.args, p.shader))
	end
end

--- Trigger an effect method
function _M:callEffect(eff_id, name, ...)
	local e = _M.tempeffect_def[eff_id]
	local p = self.tmp[eff_id]
	name = name or "trigger"
	if e[name] and p then return e[name](self, p, ...) end
end
