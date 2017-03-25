-- TE4 - T-Engine 4
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
local TreeList = require "engine.ui.TreeList"
local ListColumns = require "engine.ui.ListColumns"
local Textzone = require "engine.ui.Textzone"
local TextzoneList = require "engine.ui.TextzoneList"
local Separator = require "engine.ui.Separator"

module(..., package.seeall, class.inherit(Dialog))
-- Could use better icons when available
local confirmMark = require("engine.Entity").new({image="ui/chat-icon.png"})
local autoMark = require("engine.Entity").new({image = "ui/hotkeys/mainmenu.png"})

-- generate talent status separately to enable quicker refresh of Dialog
local function TalentStatus(who,t) 
	local status = tstring{{"color", "LIGHT_GREEN"}, "Active"} 
	if who:isTalentCoolingDown(t) then
		status = tstring{{"color", "LIGHT_RED"}, who:isTalentCoolingDown(t).." turns"}
	elseif not who:preUseTalent(t, true, true) then
		status = tstring{{"color", "GREY"}, "Unavailable"}
	elseif t.is_object_use then
		status = tstring{{"color", "SALMON"}, "Object"}
	elseif t.mode == "sustained" then
		status = who:isTalentActive(t.id) and tstring{{"color", "YELLOW"}, "Sustaining"} or tstring{{"color", "LIGHT_GREEN"}, "Sustain"}
	elseif t.mode == "passive" then
		status = tstring{{"color", "LIGHT_BLUE"}, "Passive"}
	end
	if who:isTalentAuto(t.id) then 
		status:add(autoMark:getDisplayString())
	end
	if who:isTalentConfirmable(t.id) then 
		status:add(confirmMark:getDisplayString())
	end
	return tostring(status) 
end

function _M:init(actor)
	self.actor = actor
	actor.hotkey = actor.hotkey or {}
	Dialog.init(self, "技能设定： "..actor.name, game.w * 0.8, game.h * 0.8)

	local vsep = Separator.new{dir="horizontal", size=self.ih - 10}
	self.c_tut = Textzone.new{width=math.floor(self.iw / 2 - vsep.w / 2), height=1, auto_height=true, no_color_bleed=true, text=[[
你可以将一个非被动技能绑定至相应的快捷键，通过右键点击技能来进行设置。
仔细检查一下游戏菜单中关于快捷键绑定的设置（默认情况下的快捷键是0～9以
及Ctrl、Shift与数字组合键）。
点击右键或者'*'键来设置。
]]}
	self.c_desc = TextzoneList.new{width=math.floor(self.iw / 2 - 10), height=self.ih - self.c_tut.h - 20, scrollbar=true, no_color_bleed=true}

	self:generateList()

	local cols = {
		{name="", width={40,"fixed"}, display_prop="char"},
		{name="技能", width=80, display_prop="name"},
		{name="状态", width=20, display_prop=function(item)
			if item.talent then return TalentStatus(actor, actor:getTalentFromId(item.talent)) else return "" end
		end},
		{name="快捷键", width={75,"fixed"}, display_prop="hotkey"},
		{name="鼠标点击", width={60,"fixed"}, display_prop=function(item)
			if item.talent and item.talent == self.actor.auto_shoot_talent then return "左键"
			elseif item.talent and item.talent == self.actor.auto_shoot_midclick_talent then return "中键"
			else return "" end
		end},
	}
	self.c_list = TreeList.new{width=math.floor(self.iw / 2 - vsep.w / 2), height=self.ih - 10, all_clicks=true, scrollbar=true, columns=cols, tree=self.list, fct=function(item, sel, button) self:use(item, button) end, select=function(item, sel) self:select(item) end, on_drag=function(item, sel) self:onDrag(item) end}
	self.c_list.cur_col = 2

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
			if c == '~' then
				self:use(self.cur_item, "right")
			end
			if self.list and self.list.chars[c] then
				self:use(self.list.chars[c])
			end
		end,
	}
	engine.interface.PlayerHotkeys:bindAllHotkeys(self.key, function(i) self:defineHotkey(i) end)
	self.key:addBinds{
		EXIT = function() game:unregisterDialog(self) end,
	}
end

function _M:on_register()
	game:onTickEnd(function() self.key:unicodeInput(true) end)
end

function _M:defineHotkey(id)
	if not self.actor.hotkey then return end
	local item = self.cur_item
	if not item or not item.talent then return end

	local t = self.actor:getTalentFromId(item.talent)
	if t.mode == "passive" then return end

	for i = 1, 12 * self.actor.nb_hotkey_pages do
		if self.actor.hotkey[i] and self.actor.hotkey[i][1] == "talent" and self.actor.hotkey[i][2] == item.talent then self.actor.hotkey[i] = nil end
	end

	self.actor.hotkey[id] = {"talent", item.talent}
	self:simplePopup("快捷键 "..id.." 设置", t.name:capitalize().." 设置至快捷键 "..id)
	self.c_list:drawTree()
	self.actor.changed = true
end

function _M:onDrag(item)
	if item and item.talent then
		local t = self.actor:getTalentFromId(item.talent)
--		if t.mode == "passive" then return end
		local s = t.display_entity:getEntityFinalSurface(nil, 64, 64)
		local x, y = core.mouse.get()
		game.mouse:startDrag(x, y, s, {kind="talent", id=t.id}, function(drag, used)
			local x, y = core.mouse.get()
			game.mouse:receiveMouse("drag-end", x, y, true, nil, {drag=drag})
			if drag.used then self.c_list:drawTree() end
		end)
	end
end

function _M:select(item)
	if item then
		self.c_desc:switchItem(item, item.desc)
		self.cur_item = item
	end
end

function _M:use(item, button)
	if not item or not item.talent then return end
	local t = self.actor:getTalentFromId(item.talent)
	if t.mode == "passive" then return end
	if button == "right" then
		local list = {
			{name="解除绑定", what="unbind"},
			{name="绑定至鼠标左键", what="left"},
			{name="绑定至鼠标中键", what="middle"},
		}

		if self.actor:isTalentConfirmable(t) then
			table.insert(list, 1, {name="#YELLOW#停用自动使用技能确认", what="unset-confirm"})
		else
			table.insert(list, 1, {name=confirmMark:getDisplayString().."使用技能前确认", what="set-confirm"})
		end
		local automode = self.actor:isTalentAuto(t)
		local ds = "#YELLOW#停止 "
		table.insert(list, 2, {name=autoMark:getDisplayString()..(automode==1 and ds or "").."启用自动使用", what=(automode==1 and "auto-dis" or "auto-en-1")})
		table.insert(list, 2, {name=autoMark:getDisplayString()..(automode==2 and ds or "").."当无可见敌人时自动使用", what=(automode==2 and "auto-dis" or "auto-en-2")})
		table.insert(list, 2, {name=autoMark:getDisplayString()..(automode==3 and ds or "").."当敌人可见时自动使用", what=(automode==3 and "auto-dis" or "auto-en-3")})
		table.insert(list, 2, {name=autoMark:getDisplayString()..(automode==4 and ds or "").."附近有可见敌人时自动使用", what=(automode==4 and "auto-dis" or "auto-en-4")})
		self:triggerHook{"UseTalents:generate", actor=self.actor, talent=t, menu=list}

		for i = 1, 12 * self.actor.nb_hotkey_pages do list[#list+1] = {name="快捷键 "..i, what=i} end
		Dialog:listPopup("绑定技能： "..item.name:toString(), "如何绑定技能？", list, 400, 500, function(b)
			if not b then return end
			if type(b.what) == "number" then
				for i = 1, 12 * self.actor.nb_hotkey_pages do
					if self.actor.hotkey[i] and self.actor.hotkey[i][1] == "talent" and self.actor.hotkey[i][2] == item.talent then self.actor.hotkey[i] = nil end
				end
				self.actor.hotkey[b.what] = {"talent", item.talent}
				self:simplePopup("快捷键 "..b.what.." 设置", self.actor:getTalentFromId(item.talent).name:capitalize().." 设置为快捷键 "..b.what)
			elseif b.what == "middle" then
				self.actor.auto_shoot_midclick_talent = item.talent
				self:simplePopup("鼠标中键设置", self.actor:getTalentFromId(item.talent).name:capitalize().." 设置至鼠标中键点击敌对目标时")
			elseif b.what == "left" then
				self.actor.auto_shoot_talent = item.talent
				self:simplePopup("鼠标左键设置", self.actor:getTalentFromId(item.talent).name:capitalize().." 设置至鼠标左键点击敌对目标时")
			elseif b.what == "unbind" then
				if self.actor.auto_shoot_talent == item.talent then self.actor.auto_shoot_talent = nil end
				if self.actor.auto_shoot_midclick_talent == item.talent then self.actor.auto_shoot_midclick_talent = nil end
				for i = 1, 12 * self.actor.nb_hotkey_pages do
					if self.actor.hotkey[i] and self.actor.hotkey[i][1] == "talent" and self.actor.hotkey[i][2] == item.talent then self.actor.hotkey[i] = nil end
				end
			elseif b.what == "set-confirm" then
				self.actor:setTalentConfirmable(item.talent, true)
			elseif b.what == "unset-confirm" then
				self.actor:setTalentConfirmable(item.talent, false)
			elseif b.what == "auto-en-1" then
				self.actor:checkSetTalentAuto(item.talent, true, 1)
			elseif b.what == "auto-en-2" then
				self.actor:checkSetTalentAuto(item.talent, true, 2)
			elseif b.what == "auto-en-3" then
				self.actor:checkSetTalentAuto(item.talent, true, 3)
			elseif b.what == "auto-en-4" then
				self.actor:checkSetTalentAuto(item.talent, true, 4)
			elseif b.what == "auto-dis" then
				self.actor:checkSetTalentAuto(item.talent, false)
			else
				self:triggerHook{"UseTalents:use", what=b.what, actor=self.actor, talent=t, item=item}
			end
			self.c_list:drawTree()
			self.actor.changed = true
		end)
		self.c_list:drawTree()
		return
	end

	game:unregisterDialog(self)
	self.actor:useTalent(item.talent)
end

-- Display the player tile
function _M:innerDisplay(x, y, nb_keyframes)
	if self.cur_item and self.cur_item.entity then
		self.cur_item.entity:toScreen(game.uiset.hotkeys_display_icons.tiles, x + self.iw - 64, y + self.iy + self.c_tut.h - 32 + 10, 64, 64)
	end
end

function _M:generateList()
	-- Makes up the list
	local list = {}
	local letter = 1

--[[
	for i, tt in ipairs(self.actor.talents_types_def) do
		local cat = tt.type:gsub("/.*", "")
		local where = #list
		local added = false
		local nodes = {}

		-- Find all talents of this school
		for j, t in ipairs(tt.talents) do
			if self.actor:knowTalent(t.id) and t.mode ~= "passive" then
				local typename = "talent"
				local status = tstring{{"color", "LIGHT_GREEN"}, "Active"}
				if self.actor:isTalentCoolingDown(t) then status = tstring{{"color", "LIGHT_RED"}, self.actor:isTalentCoolingDown(t).." turns"}
				elseif t.mode == "sustained" then status = self.actor:isTalentActive(t.id) and tstring{{"color", "YELLOW"}, "Sustaining"} or tstring{{"color", "LIGHT_GREEN"}, "Sustain"} end
				nodes[#nodes+1] = {
					char=self:makeKeyChar(letter),
					name=t.name.." ("..typename..")",
					status=status,
					talent=t.id,
					desc=self.actor:getTalentFullDescription(t),
					color=function() return {0xFF, 0xFF, 0xFF} end,
					hotkey=function(item)
						for i = 1, 12 * self.actor.nb_hotkey_pages do if self.actor.hotkey[i] and self.actor.hotkey[i][1] == "talent" and self.actor.hotkey[i][2] == item.talent then
							return "H.Key "..i..""
						end end
						return ""
					end,
				}
				list.chars[self:makeKeyChar(letter)] = nodes[#nodes]
				added = true
				letter = letter + 1
			end
		end

		if added then
			table.insert(list, where+1, {
				char="",
				name=tstring{{"font","bold"}, cat:capitalize().." / "..tt.name:capitalize(), {"font","normal"}},
				type=tt.type,
				color=function() return {0x80, 0x80, 0x80} end,
				status="",
				desc=tt.description,
				nodes=nodes,
				hotkey="",
				shown=true,
			})
		end
	end
]]

	local actives, sustains, sustained, objects, unavailables, cooldowns, passives = {}, {}, {}, {}, {}, {}, {}
	local chars = {}

	-- Generate lists of all talents by category
	for j, t in pairs(self.actor.talents_def) do
		if self.actor:knowTalent(t.id) and not (t.hide and t.mode == "passive") then
			local nodes = (t.mode == "sustained" and sustains) or (t.mode =="passive" and passives) or (t.is_object_use and objects) or actives
			if self.actor:isTalentCoolingDown(t) then
				nodes = cooldowns
			elseif not self.actor:preUseTalent(t, true, true) then
				nodes = unavailables
			elseif t.mode == "sustained" then
				if self.actor:isTalentActive(t.id) then nodes = sustained end
			elseif t.mode == "passive" then
				nodes = passives
			end
			local status = TalentStatus(self.actor,t)
			
			-- Pregenerate icon with the Tiles instance that allows images
			if t.display_entity then t.display_entity:getMapObjects(game.uiset.hotkeys_display_icons.tiles, {}, 1) end
			local tname = t.is_object_use and tostring(self.actor:getTalentDisplayName(t)) or t.name
			nodes[#nodes+1] = {
				name=((t.display_entity and t.display_entity:getDisplayString() or "")..tname):toTString(),
				cname=tname,
				status=status,
				entity=t.display_entity,
				talent=t.id,
				desc=self.actor:getTalentFullDescription(t),
				color=function() return {0xFF, 0xFF, 0xFF} end,
				hotkey=function(item)
					if t.mode == "passive" then return "" end
					for i = 1, 12 * self.actor.nb_hotkey_pages do if self.actor.hotkey[i] and self.actor.hotkey[i][1] == "talent" and self.actor.hotkey[i][2] == item.talent then
						return "H.Key "..i..""
					end end
					return ""
				end,
			}
		end
	end
	table.sort(actives, function(a,b) return a.cname < b.cname end)
	table.sort(sustains, function(a,b) return a.cname < b.cname end)
	table.sort(sustained, function(a,b) return a.cname < b.cname end)
	table.sort(objects, function(a,b) return a.cname < b.cname end)
	table.sort(cooldowns, function(a,b) return a.cname < b.cname end)
	table.sort(unavailables, function(a,b) return a.cname < b.cname end)
	table.sort(passives, function(a,b) return a.cname < b.cname end)
	for i, node in ipairs(actives) do node.char = self:makeKeyChar(letter) chars[node.char] = node letter = letter + 1 end
	for i, node in ipairs(sustains) do node.char = self:makeKeyChar(letter) chars[node.char] = node letter = letter + 1 end
	for i, node in ipairs(sustained) do node.char = self:makeKeyChar(letter) chars[node.char] = node letter = letter + 1 end
	for i, node in ipairs(objects) do node.char = self:makeKeyChar(letter) chars[node.char] = node letter = letter + 1 end
	for i, node in ipairs(cooldowns) do node.char = self:makeKeyChar(letter) chars[node.char] = node letter = letter + 1 end
	for i, node in ipairs(unavailables) do node.char = self:makeKeyChar(letter) chars[node.char] = node letter = letter + 1 end
	for i, node in ipairs(passives) do node.char = "" end

	list = {
		{ char='', name=('#{bold}#主动技能#{normal}#'):toTString(), status='', hotkey='', desc="当前你可以使用的所有主动技能。", color=function() return colors.simple(colors.LIGHT_GREEN) end, nodes=actives, shown=true },
		{ char='', name=('#{bold}#物品技能#{normal}#'):toTString(), status='', hotkey='', desc="Object powers that can be activated automatically.  Most usable objects will appear here unless they are on cooldown or have ai restrictions.", color=function() return colors.simple(colors.SALMON) end, nodes=objects, shown=true },
		{ char='', name=('#{bold}#持续技能#{normal}#'):toTString(), status='', hotkey='', desc="当前你可以使用的所有持续技能。", color=function() return colors.simple(colors.LIGHT_GREEN) end, nodes=sustains, shown=true },
		{ char='', name=('#{bold}#已开启持续技能#{normal}#'):toTString(), status='', hotkey='', desc="当前所有你已经开启的持续技能，再次使用即取消其持续状态。", color=function() return colors.simple(colors.YELLOW) end, nodes=sustained, shown=true },
		{ char='', name=('#{bold}#冷却中技能#{normal}#'):toTString(), status='', hotkey='', desc="所有你正在冷却中的技能。", color=function() return colors.simple(colors.LIGHT_RED) end, nodes=cooldowns, shown=true },
		{ char='', name=('#{bold}#无法使用的技能#{normal}#'):toTString(), status='', hotkey='', desc="所有当前你暂时无法使用的技能（能量不足、未满足使用条件等等）。", color=function() return colors.simple(colors.GREY) end, nodes=unavailables, shown=true },
		{ char='', name=('#{bold}#被动技能#{normal}#'):toTString(), status='', hotkey='', desc="你所有的被动技能，它们会持续生效。", color=function() return colors.simple(colors.WHITE) end, nodes=passives, shown=true },
		chars = chars,
	}
	self.list = list
end
