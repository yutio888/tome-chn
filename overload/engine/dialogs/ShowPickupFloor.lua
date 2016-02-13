-- TE4 - T-Engine 4
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
local ListColumns = require "engine.ui.ListColumns"
local Button = require "engine.ui.Button"
local Textzone = require "engine.ui.Textzone"
local TextzoneList = require "engine.ui.TextzoneList"
local Separator = require "engine.ui.Separator"

--- ShowPickupFloor
-- @classmod engine.dialogs.ShowPickupFloor
module(..., package.seeall, class.inherit(Dialog))

function _M:init(title, x, y, filter, action, takeall, actor)
	self.x, self.y = x, y
	self.filter = filter
	self.action = action
	self.actor = actor
	Dialog.init(self, "拾取物品", math.max(800, game.w * 0.8), math.max(600, game.h * 0.8))

	local takeall = Button.new{text=takeall or "(*) 全部拾取", width=self.iw - 40, fct=function() self:takeAll() end}

	self.c_desc = TextzoneList.new{width=math.floor(self.iw / 2 - 10), height=self.ih - takeall.h, no_color_bleed=true}

	self.c_list = ListColumns.new{width=math.floor(self.iw / 2 - 10), height=self.ih - 10 - takeall.h, scrollbar=true, columns={
		{name="", width={20,"fixed"}, display_prop="char"},
		{name="", width={24,"fixed"}, display_prop="object", sort="sortname", direct_draw=function(item, x, y) item.object:toScreen(nil, x+4, y, 16, 16) end},
		{name="物品", width=70, display_prop="sortname"},
		{name="分类", width=20, display_prop="cat"},
		{name="负重", width=10, display_prop="encumberance"},
	}, list={}, fct=function(item) self:use(item) end, select=function(item, sel) self:select(item) end}

	self:generateList()

	self:loadUI{
		{left=0, top=takeall.h, ui=self.c_list},
		{right=0, top=takeall.h, ui=self.c_desc},
		{hcenter=0, top=0, ui=takeall},
		{hcenter=0, top=takeall.h + 5, ui=Separator.new{dir="horizontal", size=self.ih - takeall.h - 10}},
	}
	self:setFocus(self.c_list)
	self:setupUI()

	self.key:addCommands{
		__TEXTINPUT = function(c)
			if c == '*' then self:takeAll() return end
			if self.list and self.list.chars[c] then
				self:use(self.list[self.list.chars[c]])
			end
		end,
	}
	self.key:addBinds{
		ACCEPT = function()
			self:use(self.c_list.list[self.c_list.sel])
		end,
		EXIT = function() game:unregisterDialog(self) end,
	}
end

function _M:on_register()
	game:onTickEnd(function() self.key:unicodeInput(true) end)
end

function _M:used()
	if self.taking_all then return end
	self:generateList()
	if #self.list == 0 then
		game:unregisterDialog(self)
		return false
	end
	self:select(self.c_list.list[self.c_list.sel])
	return true
end

function _M:select(item)
	if item then
		self.c_desc:switchItem(item, item.desc)
	end
end

function _M:takeAll()
	self.taking_all = true
	for i = #self.list, 1, -1 do self.action(self.list[i].object, self.list[i].item) end
	game:unregisterDialog(self)
end

function _M:use(item)
	if item and item.object then
		self.action(item.object, item.item)
	end
	return self:used()
end

function _M:generateList()
	-- Makes up the list
	local list = {}
	list.chars = {}
	local idx = 1
	local i = 1
	while true do
		local o = game.level.map:getObject(self.x, self.y, idx)
		if not o then break end
		if not self.filter or self.filter(o) then
			local char = self:makeKeyChar(i)
			list.chars[char] = i

			local enc = 0
			o:forAllStack(function(o) enc=enc+o.encumber end)

			--汉化
			local name = o:getName()
			name = objects:getObjectsChnName(name)
			
			list[#list+1] = { char=char,name = name, sortname=name:toString():removeColorCodes(), color=o:getDisplayColor(), object=o, item=idx, cat=objectSType[o.subtype] or o.subtype, encumberance=enc, desc=o:getDesc() }
			i = i + 1
		end
		idx = idx + 1
	end
	self.list = list

	self.c_list:setList(self.list)
end
