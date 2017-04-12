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
local Dialog = require "engine.ui.Dialog"
local Textzone = require "engine.ui.Textzone"
local TextzoneList = require "engine.ui.TextzoneList"
local ActorFrame = require "engine.ui.ActorFrame"
local List = require "engine.ui.List"
local Button = require "engine.ui.Button"
local DamageType = require "engine.DamageType"

module(..., package.seeall, class.inherit(Dialog))

function _M:init(assumeform, actor, body, on_end)
	self.assumeform = assumeform
	self.on_end = on_end
	self.actor = actor
	self.body = body
	self.max_talent_level = actor:callTalent(actor.T_IMPROVED_FORM, "getMaxTalentsLevel")

	Dialog.init(self, ("附身: 选择技能 (最大技能等级 %0.1f)"):format(self.max_talent_level) , 680, 500)

	self:generateList()

	self.c_ok = Button.new{text="附身", fct=function() self:ok() end}
	self.c_cancel = Button.new{text="取消", fct=function() self:cancel() end}
	self.c_list = List.new{scrollbar=true, width=300, height=self.ih - 5 - self.c_ok.h, list=self.list, fct=function(item) self:use(item) end, select=function(item) self:select(item) end}
	local help = Textzone.new{width=math.floor(self.iw - self.c_list.w - 20), height=self.ih, no_color_bleed=true, auto_height=true, text="#SLATE##{italic}#你的 #LIGHT_BLUE#完全控制#LAST# 技能 等级 不足，无法使用该身体的所有技能，选择需要保留的技能。 你的选择对该身体及其克隆永久生效。"}
	self.c_desc = TextzoneList.new{scrollbar=true, width=help.w, height=self.ih - help.h - 40 - self.c_cancel.h}

	self:loadUI{
		{left=0, top=0, ui=self.c_list},
		{right=0, top=0, ui=help},
		{right=0, top=help, ui=self.c_desc},
		{left=0, bottom=0, ui=self.c_ok},
		{right=0, bottom=0, ui=self.c_cancel},
	}
	self:setupUI(false, false)

	self.key:addBinds{
		EXIT = function()
			self:cancel()
		end,
	}

	self:select(self.list[1])
end

function _M:cancel()
	self.body.__possessor_talent_slots_config = nil
	game:unregisterDialog(self)
end

function _M:ok()
	if self.assumeform:hasEnoughTalentSlots(self.body) then
		game:unregisterDialog(self)
		self.on_end()
	end
end

function _M:use(item)
	if not item then return end
	item.used = not item.used
	item.color = item.used and colors.simple(colors.LIGHT_GREEN) or colors.simple(colors.LIGHT_RED)
	self.c_list:drawItem(item)

	table.removeFromList(self.body.__possessor_talent_slots_config, item.tid)
	if item.used then table.insert(self.body.__possessor_talent_slots_config, item.tid) end

	self.c_ok.hide = not self.assumeform:hasEnoughTalentSlots(self.body)
end

function _M:select(item)
	if not item or not self.c_desc then return end
	self.c_desc:switchItem(item.desc, item.desc)
end

function _M:generateList()
	local list = {}

	self.body.__possessor_talent_slots_config = {}
	local available_talent_slots = self.actor:callTalent(self.actor.T_FULL_CONTROL, "getNbTalents")
	for tid, lev in pairs(self.body.talents) do
		local t = self.actor:getTalentFromId(tid)
		if self.actor:callTalent(self.actor.T_ASSUME_FORM, "isUsableTalent", t, true) then
			local d = {
				tid = tid,
				name = ("%s (%0.1f)"):format(t.name, math.min(self.max_talent_level, self.body:getTalentLevel(t))),
				sortname = t.name,
				color = colors.simple(colors.LIGHT_GREEN),
				used = true,
			}
			if available_talent_slots <= 0 then
				d.color = colors.simple(colors.LIGHT_RED)
				d.used = false
			else
				table.insert(self.body.__possessor_talent_slots_config, tid)
			end
			available_talent_slots = available_talent_slots -1

			d.desc = self.body:getTalentFullDescription(t)
			list[#list+1] = d
		end
	end
	table.sort(list, "sortname")

	self.list = list
end
