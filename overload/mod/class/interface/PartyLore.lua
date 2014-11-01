-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2014 Nicolas Casalini
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
local Dialog = require "engine.ui.Dialog"
local LorePopup = require "mod.dialogs.LorePopup"
local slt2 = require "slt2"

module(..., package.seeall, class.make)

_M.lore_defs = {}

--- Loads lore
function _M:loadDefinition(file, env)
	local f, err = loadfile(file)
	if not f and err then error(err) end
	setfenv(f, setmetatable(env or {
		newLore = function(t) self:newLore(t) end,
		load = function(f) self:loadDefinition(f, getfenv(2)) end
	}, {__index=_G}))
	f()
end

--- Make a new lore with a name and desc
function _M:newLore(t)
	assert(t.id, "no lore name")
	assert(t.category, "no lore category")
	assert(t.name, "no lore name")
	assert(t.lore, "no lore lore")

	t.order = #self.lore_defs+1

	self.lore_defs[t.id] = t
	self.lore_defs[#self.lore_defs+1] = t
--	print("[LORE] defined", t.order, t.id)
end

function _M:init(t)
	self.additional_lore = self.additional_lore or {}
	self.additional_lore_nb = self.additional_lore_nb or 0
	self.lore_known = self.lore_known or {}
end

function _M:knownLore(lore)
	self.lore_known = self.lore_known or {}
	return self.lore_known[lore] and true or false
end

function _M:getLore(lore, silent)
	self.lore_known = self.lore_known or {}
	self.additional_lore = self.additional_lore or {}
	if not silent then assert(self.lore_defs[lore] or self.additional_lore[lore], "bad lore id "..lore) end
	local l = self.lore_defs[lore] or self.additional_lore[lore]
	if not l then return end
	l = table.clone(l)

	if l.template then
		local tpl = slt2.loadstring(l.lore)
		l.lore = slt2.render(tpl, {player=self:findMember{main=true}, self=self})
	end

	return l
end

function _M:additionalLore(id, name, category, lore)
	self.additional_lore = self.additional_lore or {}
	if self.additional_lore[id] then return end
	self.additional_lore_nb = (self.additional_lore_nb or 0) + 1
	self.additional_lore[id] = {id=id, name=name, category=category, lore=lore, order=self.additional_lore_nb + #self.lore_defs}
end

function _M:learnLore(lore, nopopup, silent, nostop)
	local l = self:getLore(lore, silent)
	if not l then return end
	local learnt = false

	self.lore_known = self.lore_known or {}

	if not config.settings.tome.lore_popup and profile.mod.lore and profile.mod.lore.lore and profile.mod.lore.lore[lore] and not l.always_pop then nopopup = true end

	if not self:knownLore(lore) or l.always_pop then
		game.logPlayer(self, "Lore found: #0080FF#%s", l.name)
		if not nopopup then
			LorePopup.new(l, game.w * 0.6, 0.8)
			game.logPlayer(self, "You can read all your collected lore in the game menu, by pressing Escape.")
		end
		learnt = true
	end

	self.lore_known[lore] = true
	if learnt and not self.additional_lore[lore] then game.player:registerLoreFound(lore) end
	print("[LORE] learnt", lore)
	if learnt then if l.on_learn then l.on_learn(self:findMember{main=true}) end end

	if game.player.runStop and not nostop then
		game.player:runStop("learnt lore")
		game.player:restStop("learnt lore")
	end
end
