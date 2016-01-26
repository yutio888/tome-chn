-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2016 Nicolas Casalini
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
local List = require "engine.ui.List"
local Faction = require "engine.Faction"
local GetQuantity = require "engine.dialogs.GetQuantity"

module(..., package.seeall, class.inherit(Dialog))

function _M:init()
	self:generateList()
	Dialog.init(self, "切换阵营友好度", 1, 1)

	local list = List.new{width=400, height=500, list=self.list, fct=function(item) self:use(item) end}

	self:loadUI{
		{left=0, top=0, ui=list},
	}
	self:setupUI(true, true)

	self.key:addCommands{ __TEXTINPUT = function(c)
		for i = list.sel + 1, #self.list do
			local v = self.list[i]
			if v.name:sub(1, 1):lower() == c:lower() then list:select(i) return end
		end
		for i = 1, list.sel do
			local v = self.list[i]
			if v.name:sub(1, 1):lower() == c:lower() then list:select(i) return end
		end
	end}
	self.key:addBinds{ EXIT = function() game:unregisterDialog(self) end, }
end

function _M:on_register()
	game:onTickEnd(function() self.key:unicodeInput(true) end)
end

function _M:use(item)
	if not item then return end
	game:unregisterDialog(self)

	Dialog:listPopup("切换: "..item.def.name, "切换到什么友好度？", {{name="友好"}, {name="中立"}, {name="敌对"}}, 300, 150, function(sel)
		if not sel then return end
		if sel.name == "友好" then Faction:setFactionReaction(game.player.faction, item.def.short_name, 100, true)
		elseif sel.name == "中立" then Faction:setFactionReaction(game.player.faction, item.def.short_name, 0, true)
		elseif sel.name == "敌对" then Faction:setFactionReaction(game.player.faction, item.def.short_name, -100, true)
		end
	end)
end

function _M:generateList()
	local list = {}

	for s, def in pairs(Faction.factions) do
		list[#list+1] = {name=def.name, def=def}
	end
	table.sort(list, function(a,b) return a.name < b.name end)

	local chars = {}
	for i, v in ipairs(list) do
		v.name = v.name
		chars[self:makeKeyChar(i)] = i
	end
	list.chars = chars

	self.list = list
end
