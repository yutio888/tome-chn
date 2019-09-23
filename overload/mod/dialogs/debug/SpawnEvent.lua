-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2019 Nicolas Casalini
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
local GetQuantity = require "engine.dialogs.GetQuantity"

module(..., package.seeall, class.inherit(engine.ui.Dialog))

function _M:init()
	self:generateList()
	engine.ui.Dialog.init(self, "DEBUG -- Spawn Event", 1, 1)

	local list = List.new{width=400, height=500, scrollbar=true, list=self.list, fct=function(item) self:use(item) end}

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
	self.key:addBinds{ EXIT = function() game:unregisterDialog(self) end,
		LUA_CONSOLE = function()
			if config.settings.cheat then
				local DebugConsole = require "engine.DebugConsole"
				game:registerDialog(DebugConsole.new())
			end
		end,}
end

function _M:on_register()
	game:onTickEnd(function() self.key:unicodeInput(true) end)
end

function _M:use(item)
	if not item then return end
	game:unregisterDialog(self)


	local f, err = loadfile(item.path)
	if not f then error(err) end
	setfenv(f, setmetatable({level=game.level, zone=game.zone, event_id="test-event-"..rng.range(1, 9999999), params={}, Map=engine.Map}, {__index=_G}))
	f()
end

function _M:generateList()
	local list = {}

	local function parse(base, add, add_simple)
		for i, file in ipairs(fs.list(base.."/general/events/")) do
			local f = loadfile(base.."/general/events/"..file)
			if f then
				list[#list+1] = {name=file..(add_simple and " ["..add_simple.."]" or ""), path=base.."/general/events/"..file}
			end
		end
	end

	parse("/data", "")
	for i, dir in ipairs(fs.list("/")) do
		local _, _, addon = dir:find("^data%-(.+)$")
		if addon then
			parse("/"..dir, addon.."+", addon)
		end
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
