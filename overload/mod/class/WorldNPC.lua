-- ToME - Tales of Maj'Eyal
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
local ActorAI = require "engine.interface.ActorAI"
local Faction = require "engine.Faction"
local Emote = require("engine.Emote")
local Map = require("engine.Map")
local Chat = require("engine.Chat")
require "mod.class.Actor"

module(..., package.seeall, class.inherit(mod.class.Actor, engine.interface.ActorAI))

function _M:init(t, no_default)
	if type(t.cant_be_moved) == "nil" then t.cant_be_moved = true end
	mod.class.Actor.init(self, t, no_default)
	ActorAI.init(self, t)

	-- Grab default image name if none is set
	if not self.image and self.name ~= "unknown actor" then self.image = "npc/"..tostring(self.type or "unknown").."_"..tostring(self.subtype or "unknown"):lower():gsub("[^a-z0-9]", "_").."_"..(self.name or "unknown"):lower():gsub("[^a-z0-9]", "_")..".png" end

	self.unit_power = self.unit_power or 0
	self.max_unit_power = self.max_unit_power or self.unit_power
end

--- Checks what to do with the target
-- Talk ? attack ? displace ?
function _M:bumpInto(target, x, y)
	local reaction = self:reactionToward(target)
	if reaction < 0 then
		return self:encounterAttack(target, x, y)
	elseif reaction >= 0 then
		-- Talk ?
		if target.player and self.can_talk then
			local chat = Chat.new(self.can_talk, self, target)
			chat:invoke()
			if self.can_talk_only_once then self.can_talk = nil end
		elseif target.cant_be_moved and self.cant_be_moved and target.x and target.y and self.x and self.y then
			-- Displace
			local tx, ty, sx, sy = target.x, target.y, self.x, self.y
			target:move(sx, sy, true)
			self:move(tx, ty, true)
		end
	end
end

function _M:takeHit()
	return nil, 0
end

--- Attach or remove a display callback
-- Defines particles to display
function _M:defineDisplayCallback()
	if not self._mo then return end

	-- Cunning trick here!
	-- the callback we give to mo:displayCallback is a function that references self
	-- but self contains mo so it would create a cyclic reference and prevent GC'ing
	-- thus we store a reference to a weak table and put self into it
	-- this way when self dies the weak reference dies and does not prevent GC'ing
	local weak = setmetatable({[1]=self}, {__mode="v"})

	local ps = self:getParticlesList()

	self._mo:displayCallback(function(x, y, w, h, zoom, on_map)
		local self = weak[1]
		if not self then return end

		if game.level and game.level.map.view_faction and game.always_target and game.always_target ~= "old" then
			local map = game.level.map
			if on_map then
				self:smallTacticalFrame(game.level.map, x, y, w, h, zoom, on_map, tlx, tly)
			end
		else
			self:bigTacticalFrame(x, y, w, h, zoom, on_map, tlx, tly)
		end

		local e
		local dy = 0
		if h > w then dy = (h - w) / 2 end
		for i = 1, #ps do
			e = ps[i]
			e:checkDisplay()
			if e.ps:isAlive() then
				if game.level and game.level.map then e:shift(game.level.map, self._mo) end
				e.ps:toScreen(x + w / 2, y + dy + h / 2, true, w / (game.level and game.level.map.tile_w or w))
			else self:removeParticles(e)
			end
		end

		return true
	end)
end

function _M:takePowerHit(val, src)
	self.unit_power = (self.unit_power or 0) - val
	if self.unit_power <= 0 then
		self.logCombat(src, self, "#Source# kills #Target#.")
		self:die(src)
	end
end

function _M:encounterAttack(target, x, y)
	if target.player then target:onWorldEncounter(self, self.x, self.y) return end

	self.unit_power = self.unit_power or 0
	target.unit_power = target.unit_power or 0

	if self.unit_power > target.unit_power then
		self.unit_power = self.unit_power - target.unit_power
		target.unit_power = 0
	elseif self.unit_power < target.unit_power then
		target.unit_power = target.unit_power - self.unit_power
		self.unit_power = 0
	else
		self.unit_power, target.unit_power = self.unit_power - target.unit_power, target.unit_power - self.unit_power
	end

	if self.unit_power <= 0 then
		self:logCombat(target, "#Target# kills #Source#.")
		self:die(target)
	end
	if target.unit_power <= 0 then
		self:logCombat(target, "#Source# kills #Target#.")
		target:die(src)
	end
end

function _M:act()
	while self:enoughEnergy() and not self.dead do
		-- Do basic actor stuff
		if not mod.class.Actor.act(self) then return end

		-- Compute FOV, if needed
		self:doFOV()

		-- Let the AI think .... beware of Shub !
		-- If AI did nothing, use energy anyway
		self:doAI()

		if not self.energy.used then self:useEnergy() end
	end
end

function _M:doFOV()
	self:computeFOV(self.sight or 4, "block_sight", nil, nil, nil, true)
end

function _M:tooltip(x, y, seen_by)
	if seen_by and not seen_by:canSee(self) then return end
	local factcolor, factstate, factlevel = "#ANTIQUE_WHITE#", "neutral", self:reactionToward(game.player)
	if factlevel < 0 then factcolor, factstate = "#LIGHT_RED#", "hostile"
	elseif factlevel > 0 then factcolor, factstate = "#LIGHT_GREEN#", "friendly"
	end

	local rank, rank_color = self:TextRank()

	local ts = tstring{}
	local name=self.name
	name = name:gsub("adventurers party","冒险家分队"):gsub("ziguranth patrol","伊格巡逻队"):gsub("Allied Kingdoms human patrol","联合王国人类巡逻队"):gsub("Allied Kingdoms halfling patrol","联合王国半身人巡逻队"):gsub("Sun Paladins patrol","太阳骑士巡逻队"):gsub("Anorithil patrol","星月术士巡逻队"):gsub("Orcs patrol","兽人巡逻队")
	ts:add({"uid",self.uid}) ts:merge(rank_color:toTString()) ts:add(name, {"color", "WHITE"}, true)
	ts:add(self.type:capitalize(), " / ", self.subtype:capitalize(), true)
	ts:add("Rank: ") ts:merge(rank_color:toTString()) ts:add(rank, {"color", "WHITE"}, true)
	ts:add(self.desc, true)
	ts:add("Faction: ") ts:merge(factcolor:toTString()) ts:add(("%s (%s, %d)"):format(Faction.factions[self.faction].name, factstate, factlevel), {"color", "WHITE"}, true)
	ts:add(
		("Killed by you: "):format(killed), true,
		"Target: ", self.ai_target.actor and self.ai_target.actor.name or "none", true,
		"UID: "..self.uid
	)

	return ts
end

function _M:die(src)
	engine.interface.ActorLife.die(self, src)
end
