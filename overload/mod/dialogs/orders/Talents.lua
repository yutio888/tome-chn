-- TE4 - T-Engine 4
-- Copyright (C) 2009 - 2015 Nicolas Casalini
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
local Textzone = require "engine.ui.Textzone"
local TextzoneList = require "engine.ui.TextzoneList"
local Separator = require "engine.ui.Separator"
local GetQuantity = require "engine.dialogs.GetQuantity"

module(..., package.seeall, class.inherit(Dialog))

function _M:init(actor, def)
	self.actor = actor
	self.def = def
	Dialog.init(self, "Define tactical talents usage", math.max(800, game.w * 0.8), math.max(600, game.h * 0.8))

	local vsep = Separator.new{dir="horizontal", size=self.ih - 10}
	local halfwidth = math.floor((self.iw - vsep.w)/2)
	self.c_tut = Textzone.new{width=halfwidth, height=1, auto_height=true, no_color_bleed=true, text=([[
%s is listening attentively, and wants to know what talents to use.
You can modify the tactical weights of various talents to increase or decrease their use.  The weights are multiplicative (zero will turn the talent off) and relative (changing everything to a weight of 2 will not alter how talents are used relative to each other).
Word travels fast in Maj'Eyal, and if %s is a summon all future summons of the same type will remember your preferences.
]]):format(actor.name:capitalize(), actor.name)}
	self.c_desc = TextzoneList.new{width=halfwidth, height=self.ih, no_color_bleed=true}

	self.c_list = ListColumns.new{width=halfwidth, height=self.ih - 10, sortable=true, scrollbar=true, columns={
		{name="", width={20,"fixed"}, display_prop="char", sort="id"},
		{name="Talent Name", width=72, display_prop="name", sort="name"},
		{name="Weight", width=20, display_prop="multiplier", sort="multiplier"},
	}, list={}, fct=function(item) self:use(item) end, select=function(item, sel) self:select(item) end}

	self:generateList()

	self:loadUI{
		{left=0, top=0, ui=self.c_list},
		{right=0, top=self.c_tut.h + 20, ui=self.c_desc},
		{right=0, top=0, ui=self.c_tut},
		{hcenter=0, top=5, ui=vsep},
	}
	self:setFocus(self.c_list)
	self:setupUI()

	self.key:addCommands{
		__TEXTINPUT = function(c)
			if self.list and self.list.chars[c] then
				self:use(self.list[self.list.chars[c]])
			end
		end,
	}
	self.key:addBinds{
		EXIT = function()
			-- Store the ai_talents in the summoner
			if self.actor.summoner then
				self.actor.summoner.stored_ai_talents = self.actor.summoner.stored_ai_talents or {}
				self.actor.summoner.stored_ai_talents[self.actor.name] = self.actor.ai_talents
			end
			game:unregisterDialog(self)
		end,
	}
end

function _M:on_register()
	game:onTickEnd(function() self.key:unicodeInput(true) end)
end

function _M:use(item)
	if not item then return end

	-- Update the multiplier
	if not self.actor.ai_talents then
		self.actor.ai_talents = {}
	end
	game:registerDialog(GetQuantity.new("Enter the talent weight multiplier", "0 is off, 1 is normal", item.multiplier, nil, function(qty)
			self.actor.ai_talents[item.tid] = qty
			self:generateList()
	end), 1)
end

function _M:select(item)
	if item then
		self.c_desc:switchItem(item, item.desc)
	end
end

function _M:generateList()
	local list = {}
	for tid, lvl in pairs(self.actor.talents) do
		local t = self.actor:getTalentFromId(tid)
		if t.mode ~= "passive" and t.hide ~= "true" then
			local multiplier = self.actor.ai_talents and self.actor.ai_talents[tid] or 1
			list[#list+1] = {id=#list+1, name=t.name:capitalize(), multiplier=multiplier, tid=tid, desc=self.actor:getTalentFullDescription(t)}
		end
	end

	local chars = {}
	for i, v in ipairs(list) do
		v.char = self:makeKeyChar(i)
		chars[self:makeKeyChar(i)] = i
	end
	list.chars = chars

	self.list = list
	self.c_list:setList(list)
end
