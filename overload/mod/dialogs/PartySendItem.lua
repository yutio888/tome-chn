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
require "engine.ui.Dialog"
local List = require "engine.ui.List"

module(..., package.seeall, class.inherit(engine.ui.Dialog))

function _M:init(source, o, inven, item, on_end)
	self:generateList()
	self.on_end = on_end
	self.source = source
	self.inven = inven
	self.item = item
	self.o = o
	engine.ui.Dialog.init(self, "将物品交给队友", 1, 1)

	local list = List.new{width=400, nb_items=#self.list, list=self.list, fct=function(item) self:use(item) end}

	self:loadUI{
		{left=0, top=0, ui=list},
	}
	self:setupUI(true, true)

	self.key:addCommands{ __TEXTINPUT = function(c) if self.list and self.list.chars[c] then self:use(self.list[self.list.chars[c]]) end end}
	self.key:addBinds{
		EXIT = function() game:unregisterDialog(self) end,
	}
end

function _M:on_register()
	game:onTickEnd(function() self.key:unicodeInput(true) end)
end

function _M:use(item)
	if not item then return end
	game:unregisterDialog(self)

	self.source:removeObject(self.inven, self.item, true)
	self.source:sortInven(self.inven)
	self.o.__transmo = nil
	item.actor:addObject(item.actor.INVEN_INVEN, self.o)
	item.actor:sortInven(item.actor.INVEN_INVEN)
	game.log("你将 %s 交给 %s.", self.o:getName{do_color=true}, item.actor.name)
	self.on_end()
end

function _M:generateList()
	local list = {}

	for i, act in ipairs(game.party.m_list) do
		if not act.no_inventory_access and act ~= game.player then
			list[#list+1] = {name=act.name, actor=act}
		end
	end

	local chars = {}
	for i, v in ipairs(list) do
		v.name = self:makeKeyChar(i)..") "..v.name
		chars[self:makeKeyChar(i)] = i
	end
	list.chars = chars

	self.list = list
end
