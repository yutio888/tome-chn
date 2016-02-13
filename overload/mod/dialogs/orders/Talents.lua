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
local Textzone = require "engine.ui.Textzone"
local TextzoneList = require "engine.ui.TextzoneList"
local Separator = require "engine.ui.Separator"
local GetQuantity = require "engine.dialogs.GetQuantity"

module(..., package.seeall, class.inherit(Dialog))

function _M:init(actor, def)
	self.actor = actor
	self.def = def
	Dialog.init(self, "设置技能使用策略", math.max(800, game.w * 0.8), math.max(600, game.h * 0.8))

	local vsep = Separator.new{dir="horizontal", size=self.ih - 10}
	local halfwidth = math.floor((self.iw - vsep.w)/2)
	self.c_tut = Textzone.new{width=halfwidth, height=1, auto_height=true, no_color_bleed=true, text=([[
%s 正 在 仔 细 地 听 着 你 ， 向 你 询 问 该 怎 么 使 用 它 的 技 能 。
你 可 以 修 改 他 的 技 能 使 用 策 略 中 每 个 技 能 的 权 重 ， 增 加 或 减 少 某 些 技 能 使 用 的 概 率 。 这 些 权 重 是 乘 法 性 的 （ 权 重 为 零 表 示 这 个 技 能 永 远 不 会 被 使 用 ） 和 相 关 性 的 （ 把 所 有 技 能 的 权 重 调 整 为 二 和 全 部 调 整 为 一 没 有 区 别 ） 
在 马 基 · 埃 亚 尔 消 息 传 播 得 很 快 。 如 果 %s 是 一 个 召 唤 生 物 ， 所 有 同 类 的 召 唤 生 物 都 会 记 住 你 的 设 置 。 
]]):format(npcCHN:getName(actor.name), npcCHN:getName(actor.name) )}
	self.c_desc = TextzoneList.new{width=halfwidth, height=self.ih, no_color_bleed=true}

	self.c_list = ListColumns.new{width=halfwidth, height=self.ih - 10, sortable=true, scrollbar=true, columns={
		{name="", width={20,"fixed"}, display_prop="char", sort="id"},
		{name="技能名", width=72, display_prop="name", sort="name"},
		{name="权重", width=20, display_prop="multiplier", sort="multiplier"},
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
	game:registerDialog(GetQuantity.new("输入技能使用权重", "0 表示不使用这个技能, 1 为默认", item.multiplier, nil, function(qty)
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
