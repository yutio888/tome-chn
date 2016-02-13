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
local TextzoneList = require "engine.ui.TextzoneList"
local Separator = require "engine.ui.Separator"

--- Show Quests
-- @classmod engine.dialogs.ShowQuests
module(..., package.seeall, class.inherit(Dialog))

function _M:init(actor, select_id)
	self.actor = actor
	Dialog.init(self, actor.name.."的任务列表", game.w * 0.8, game.h * 0.8)

	self.c_desc = TextzoneList.new{scrollbar=true, width=math.floor(self.iw / 2 - 10), height=self.ih}

	self:generateList()

	self.c_list = ListColumns.new{width=math.floor(self.iw / 2 - 10), height=self.ih - 10, scrollbar=true, sortable=true, columns={
		{name="任务", width=70, display_prop="name", sort="name"},
		{name="状态", width=30, display_prop="status", sort="status_order"},
	}, list=self.list, fct=function(item) end, select=function(item, sel) self:select(item) end}

	self:loadUI{
		{left=0, top=0, ui=self.c_list},
		{right=0, top=0, ui=self.c_desc},
		{hcenter=0, top=5, ui=Separator.new{dir="horizontal", size=self.ih - 10}},
	}
	self:setFocus(self.c_list)
	self:setupUI()
	self.c_list:selectColumn(2)

	self.key:addBinds{
		EXIT = function() game:unregisterDialog(self) end,
	}

	local none_selected = true

	if select_id then
		for i, q in ipairs(self.list) do
			if q.quest.id == select_id then
				none_selected = false
				self:select(q, true)
				break
			end
		end
	end

	if none_selected then self:select(self.list[1], true) end
end

function _M:select(item, force)
	if item then
		self.c_desc:switchItem(item, item.desc)
		if self.c_list and force then self.c_list.sel = item.list_id end
	end
end

function _M:generateList()
	-- Makes up the list
	local list = {}
	for id, q in pairs(self.actor.quests or {}) do
		if true then
			local color = nil
			if q:isStatus(q.COMPLETED) then color = colors.simple(colors.LIGHT_GREEN)
			elseif q:isStatus(q.DONE) then color = colors.simple(colors.GREEN)
			elseif q:isStatus(q.FAILED) then color = colors.simple(colors.RED)
			end

			--list[#list+1] = { name=q.name, quest=q, color = color, status=q.status_text[q.status], status_order=q.status, desc=q:desc(self.actor), list_id=#list+1 }

			--local quest_CHN = getQuestCHN(q.name,q:desc(self.actor))
			local qname = q.name
			local qdesc = q:desc(self.actor)
			if questCHN[q.name] then
				qname = questCHN[q.name].name
				qdesc = questCHN[q.name].description(q:desc(self.actor))
			elseif q.name:find("Escort") then
				qname = questCHN["Escort"].name(q.name)
				qdesc = questCHN["Escort"].description(q:desc(self.actor))
			end
			list[#list+1] = {  name=qname, quest=q, color = color, status=getQuestStat(q.status_text[q.status]), status_order=q.status, desc=qdesc, list_id=#list+1  }
		end
	end
	if game.turn then
		table.sort(list, function(a, b) return a.quest.gained_turn < b.quest.gained_turn end)
	else
		table.sort(list, function(a, b) return a.quest.name < b.quest.name end)
	end
	self.list = list
end
