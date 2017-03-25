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
--local Base = require "engine.ui.Base"
local Dialog = require "engine.ui.Dialog"
local Textzone = require "engine.ui.Textzone"
local List = require "engine.ui.List"
local Talents = require"engine.interface.ActorTalents"

module(..., package.seeall, class.inherit(Dialog))

--- Dialog to pick traps to prepare
-- @param title -- dialog title
-- @param text -- text to display in dialog
-- @param actor -- talent user (player)
-- @param dialog_talent -- talent invoking this dialog
-- @param max_traps -- maximum number of traps to select
-- @param trap_tids -- list {tid=level,...} of tids and level required to choose from
-- returns traps_selected (table), starting_traps (table) when called with :talentDialog(<this dialog>)
function _M:init(title, actor, text, dialog_talent, max_traps, trap_tids)
	self.actor = actor
	self.text = text
	self.talent = dialog_talent
	self.mastery_level = actor:getTalentLevelRaw(dialog_talent)
	self.max_traps = max_traps or 1
	self.trap_tids = {}
	for tid, level in pairs(trap_tids or Talents.trap_mastery_tids) do
		if game.state:unlockTalentCheck(tid, actor) or actor:knowTalent(tid) then self.trap_tids[tid] = level end
	end
	Dialog.init(self, title or "选择陷阱", math.max(900, game.w * 0.8), math.max(700, game.h * 0.8))
	
	-- keep track of traps selected
	self.traps_selected = {}
	self.num_sel = 0
	for tid, level in pairs(self.trap_tids) do
		if actor:knowTalent(tid) and tid ~= actor.trap_primed then self.traps_selected[tid] = true self.num_sel = self.num_sel + 1 end
	end
	self.starting_traps = table.clone(self.traps_selected)
--table.set(game, "debug", "TrapsSelect", self) -- debugging
	self:generateList()
	local text_w, text_h = self.font:size(text)
	local c_desc = Textzone.new{width=400, auto_height=true, text=self.text or "选择需要准备的陷阱:"}
	local c_list = List.new{width=400, height=math.min(game.h*.75, (text_h+5)*(#self.list+1)), nb_items=#self.list, list=self.list, scrollbar=true, fct=function(item) self:use(item) end}
	-- tooltips
	c_list.on_select = function(item)
		if item.talent then
			actor.turn_procs.trap_mastery_tid = dialog_talent.id
			game:tooltipDisplayAtMap(game.w, game.h, "#GOLD#"..item.talent.name.."#LAST#\n"..tostring(actor:getTalentFullDescription(item.talent, 1, {force_level=1})))
			actor.turn_procs.trap_mastery_tid = nil
		end
	end
	self.c_list = c_list
	
	self:loadUI{
		{left=0, top=0, ui=c_desc},
		{left=0, bottom=0, ui=c_list},
	}
	self:setFocus(c_list)
	self:setupUI(true, true)

	self.key:addCommands{ __TEXTINPUT = function(c) if self.list and self.list.chars[c] then self:use(self.list[self.list.chars[c]]) end end}
	self.key:addBinds{ EXIT = function()
			game:unregisterDialog(self)
		end,
		LUA_CONSOLE = function()
			if config.settings.cheat then
				local DebugConsole = require "engine.DebugConsole"
				game:registerDialog(DebugConsole.new())
			end
		end,}
end

function _M:on_register()
--game.log("开启陷阱选择对话")
	game:onTickEnd(function() self.key:unicodeInput(true) end)
end

-- generate text and select color to display item
function _M:formatItem(item)
	if item.label then
		item.name = ("%s) %s"):format(item.char or "  ", item.label)
	elseif item.tid and item.tier then
		local add_text = ""
		item.color = nil
		if self.actor.trap_primed == item.tid then
			if self.traps_selected[item.tid] then
				item.color = colors_simple.AQUAMARINE
				add_text = " (替换瞬间启动机关)"
			else
				item.color = colors_simple.SALMON
				add_text = " (特殊启动机关)"
			end
		elseif self.traps_selected[item.tid] then
			if self.starting_traps[item.tid] then
				item.color = colors_simple.LIGHT_BLUE
				add_text = " (准备完毕)"
			else
				item.color = colors_simple.LIGHT_GREEN
				add_text = " (准备中)"
			end
		else
			if self.starting_traps[item.tid] then
				item.color = colors_simple.LIGHT_RED
				add_text = " (分解中)"
			elseif item.tier > self.mastery_level then
				item.color = colors_simple.GREY
				add_text = " (需要更多技能)"
			elseif item.unlearnable then
				item.color = colors_simple.GREY
				add_text = (" (%s)"):format(item.unlearnable)
			end
		end
		item.name = ("%s) 材质等级 %d: %s%s"):format(item.char or "  ", item.tier, item.talent.name, add_text)
	end
end

-- item selected
function _M:use(item)
	if not item then return end
	if item.action then item.action(self) end
	if item.tid and item.tier then -- toggle trap selection
		local tid = item.tid
		if item.unlearnable and not self.traps_selected[tid] then
			game.logPlayer(self.actor, "#LIGHT_BLUE#你不能准备这个陷阱: %s.", item.unlearnable)
		elseif item.tier > self.mastery_level and not self.traps_selected[tid] then
			game.logPlayer(self.actor, "#LIGHT_BLUE#你需要更多技能才能准备这个陷阱。")
		else
			if tid == self.actor.trap_primed then
				game.logPlayer(self.actor, "#LIGHT_BLUE#准备了这个陷阱（装有常规触发机关）。")
			end
			self.traps_selected[tid] = not self.traps_selected[tid]
			self.num_sel = self.num_sel + (self.traps_selected[tid] and 1 or -1)
			item.color = self.traps_selected[tid] and colors_simple.LIGHT_GREEN or colors_simple.LIGHT_RED
			self:formatItem(item)
			self.c_list:drawItem(item)
		end
	end
end

function _M:generateList()
	local list = {{label="接受这些选择", tier=0, color = colors_simple.GOLD,
		action=function()
			if self.num_sel <= self.max_traps then
				self.actor:talentDialogReturn(self.traps_selected, self.starting_traps)
				game:unregisterDialog(self)
			else
				game.logPlayer(self.actor, "#LIGHT_BLUE#你不能同时准备超过 %d 个陷阱。", self.max_traps)
			end
		end}}
	for tid, tier in pairs(self.trap_tids) do
		local t = self.actor:getTalentFromId(tid)
		local canlearn, unlearnable = self.actor:canLearnTalent(t)
		list[#list+1] = {talent=t, tid=tid, tier=tier, unlearnable=unlearnable}
	end
	table.sort(list, function(a, b) return a.tier < b.tier end)

	local chars = {}
	for i, item in ipairs(list) do
		local char = self:makeKeyChar(i)
		item.char = char
		self:formatItem(item)
		chars[char] = i
	end
	list.chars = chars
	
	self.list = list
end
