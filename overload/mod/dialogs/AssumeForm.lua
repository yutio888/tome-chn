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

function _M:init(actor, t, mode, params)
	self.params = params or {}
	self.actor = actor
	self.talent = t
	self.mode = mode
	local title, ok_button = "附身", "使用身体"
	local helptext = "#SLATE##{italic}#选择附身哪个身体。身体不能被治疗，死亡时永久摧毁。"
	if mode == "minion" then
		title, ok_button = "制造随从", "召唤"
		helptext = "#SLATE##{italic}#选择召唤哪个身体。效果结束后，身体将消失。"
	elseif mode == "cannibalize" then
		title, ok_button = "合并身体", "合并"
		helptext = "#SLATE##{italic}#选择合并哪个身体。所有克隆体将同时被摧毁。"
	elseif mode == "destroy" then
		title, ok_button = "摧毁身体", "摧毁身体"
		helptext = "#SLATE##{italic}#选择摧毁哪个身体。"
	end

	Dialog.init(self, title, 680, 500)

	self:generateList()
	if #self.list == 0 then game.logPlayer(actor, "你没有能使用的身体。") self.__refuse_dialog = true return end

	self.c_list = List.new{scrollbar=true, width=300, height=self.ih - 5, list=self.list, fct=function(item) self:use(item) end, select=function(item) self:select(item) end}
	local help = Textzone.new{width=math.floor(self.iw - self.c_list.w - 20), height=self.ih, no_color_leed=true, auto_height=true, text=helptext}
	self.actorframe = ActorFrame.new{actor=self.actor, w=64, h=64, tiles=game.level.map.tiles}
	self.c_ok = Button.new{text=ok_button, fct=function() self:use(self.c_list.list[self.c_list.sel]) end}
	self.c_destroy = Button.new{text="丢弃身体", fct=function() self:destroyBody(self.c_list.list[self.c_list.sel]) end}
	self.c_desc = TextzoneList.new{scrollbar=true, width=help.w, height=self.ih - help.h - 40 - self.actorframe.h - self.c_destroy.h}
	if mode == "destroy" then self.c_destroy.hide = true end

	self:loadUI{
		{left=0, top=0, ui=self.c_list},
		{right=0, top=0, ui=help},
		{right=(help.w - self.actorframe.w) / 2, top=help.h + 40, ui=self.actorframe},
		{right=0, top=self.actorframe, ui=self.c_desc},
		{left=0, bottom=0, ui=self.c_ok},
		{right=0, bottom=0, ui=self.c_destroy},
	}
	self:setupUI(false, false)

	self.key:addBinds{
		EXIT = function()
			game:unregisterDialog(self)
		end,
	}

	self:select(self.list[1])
end

-- Alternatively, could for exit from body when destroyed
function _M:destroyBody(item)
	if not item then end
	local function del(all)
		self.actor:talentDialogReturn(nil)
		self.actor:callTalent(self.actor.T_BODIES_RESERVE, "decreaseUse", item.body, all)
		game:unregisterDialog(self)
	end
	if self.actor:callTalent(self.actor.T_BODIES_RESERVE, "usesLeft", item.body) > 1 then
		self:yesnocancelPopup("摧毁: "..item.name, "摧毁受伤最严重的或者全部摧毁？", function(r, cancel) if not cancel then del(not r) end end, "受伤最严重的", "全部", "取消")
	else
		self:yesnoPopup("摧毁: "..item.name, "确认摧毁么?", function(r) if r then del(true) end end, "摧毁", "取消")
	end
end

function _M:hasEnoughTalentSlots(body)
	local available_talent_slots = self.actor:callTalent(self.actor.T_FULL_CONTROL, "getNbTalents")
	if body.__possessor_talent_slots_config then return #body.__possessor_talent_slots_config <= available_talent_slots end
	for tid, lev in pairs(body.talents) do
		local t = self.actor:getTalentFromId(tid)
		if self.actor:callTalent(self.actor.T_ASSUME_FORM, "isUsableTalent", t, true) then
			if available_talent_slots > 0 then
				available_talent_slots = available_talent_slots - 1
			else
				return false
			end
		end
	end
	return true
end

function _M:use(item)
	if not item then end
	if self.mode == "destroy" then
		if item.body._in_possession then
			game.log("#AQUAMARINE#你不能摧毁正在使用的身体。")
			return
		end
		self:destroyBody(item)
	elseif self.mode == "minion" and item.body._in_possession and item.uses <= 1 then
		game.log("#AQUAMARINE#你正在使用这个身体!")
		return
	elseif self.mode ~= "possess" or self:hasEnoughTalentSlots(item.body) then
		self.actor:talentDialogReturn(item.body)
		game:unregisterDialog(self)
	else
		package.loaded['mod.dialogs.AssumeFormSelectTalents'] = nil
		local AssumeFormSelectTalents = require "mod.dialogs.AssumeFormSelectTalents"
		game:registerDialog(AssumeFormSelectTalents.new(self, self.actor, item.body, function()
			self.actor:talentDialogReturn(item.body)
			game:unregisterDialog(self)
		end))
	end
end

function _M:select(item)
	if not self.actorframe or not item then return end
	self.actorframe:setActor(item.body)
	self.c_desc:switchItem(item.desc, item.desc)
end

function _M:generateList()
	local list = {}

	local function filter(body)
		if self.params.filter_rank and body.body.rank < self.params.filter_rank then return false end
		if self.params.exclude_body and body.body == self.params.exclude_body then return false end
		return true
	end

	for _, body in ipairs(self.actor.bodies_storage) do if filter(body) then
		local _, rankcolor = body.body:TextRank()
		local uses = body.uses
		local name = rankcolor..npcCHN:getName(body.body.name).." (等级 "..body.body.level..") [使用次数: "..uses.."]"
		local ts = name:toTString() -- ts:add(true)
		if body.body._in_possession then
			ts:add({"color", "GOLD"}, " **使用中**")
		end
		ts:add(true)
		ts:add({"color", 255, 0, 0}, "生命值： ", math.ceil(body.body.life).."/"..math.ceil(body.body.max_life), true)
		ts:add("#FFD700#命中#FFFFFF#: ", body.body:colorStats("combatAttack"), "  ")
		ts:add("#0080FF#闪避#FFFFFF#:  ", body.body:colorStats("combatDefense"), true)
		ts:add("#FFD700#物理强度#FFFFFF#: ", body.body:colorStats("combatPhysicalpower"), "  ")
		ts:add("#0080FF#物理豁免#FFFFFF#:  ", body.body:colorStats("combatPhysicalResist"), true)
		ts:add("#FFD700#法术强度#FFFFFF#: ", body.body:colorStats("combatSpellpower"), "  ")
		ts:add("#0080FF#法术豁免#FFFFFF#:  ", body.body:colorStats("combatSpellResist"), true)
		ts:add("#FFD700#精神强度#FFFFFF#: ", body.body:colorStats("combatMindpower"), "  ")
		ts:add("#0080FF#精神豁免#FFFFFF#:  ", body.body:colorStats("combatMentalResist"), true)
		ts:add({"color", "WHITE"})
		ts:add("#00FF80#力/敏/体#FFFFFF#:  ", body.body:getStr().."/"..body.body:getDex().."/"..body.body:getCon(), true)
		ts:add("#00FF80#魔/意/灵#FFFFFF#:  ", body.body:getMag().."/"..body.body:getWil().."/"..body.body:getCun(), true)
		ts:add({"color", "WHITE"})

		if body.body._cannibalize_penalty then
			ts:add({"color", "CRIMSON"}, ("合并惩罚: %d%%"):format(100 - body.body._cannibalize_penalty * 100), {"color", "WHITE"}, true)
		end

		local resists = tstring{}
		ts:add({"color", "ANTIQUE_WHITE"}, "抗性: ")
		local first = true
		for t, v in pairs(body.body.resists) do
			if t == "all" or t == "absolute" then
				if first then first = false else ts:add(", ") end
				ts:add({"color", "LIGHT_BLUE"}, tostring(math.floor(v)) .. "%", " ", {"color", "LAST"}, t)
			elseif type(t) == "string" and math.abs(v) >= 20 then
				local res = tostring ( math.floor(body.body:combatGetResist(t)) ) .. "%"
				if first then first = false else ts:add(", ") end
				if v > 0 then
					ts:add({"color", "LIGHT_GREEN"}, res, " ", {"color", "LAST"}, DamageType:get(t).name)
				else
					ts:add({"color", "LIGHT_RED"}, res, " ", {"color", "LAST"}, DamageType:get(t).name)
				end
			end
		end
		ts:add(true)

		ts:add("硬度/护甲: ", tostring(math.floor(body.body:combatArmorHardiness())), '% / ', tostring(math.floor(body.body:combatArmor())), true)
		ts:add("体型: ", {"color", "ANTIQUE_WHITE"}, body.body:TextSizeCategory(), {"color", "WHITE"}, true)
	
		if (150 + (body.body.combat_critical_power or 0) ) > 150 then
			ts:add("暴击伤害: ", ("%d%%"):format(150 + (body.body.combat_critical_power or 0) ), true )
		end

		ts:add({"color", "WHITE"})
		local retal = 0
		for k, v in pairs(body.body.on_melee_hit) do
			if type(v) == "number" then retal = retal + v
			elseif type(v) == "table" and type(v.dam) == "number" then retal = retal + v.dam
			end
		end
		if retal > 0 then ts:add("近战反击: ", {"color", "RED"}, tostring(math.floor(retal)), {"color", "WHITE"}, true ) end

		ts:add(true, {"color", "ORANGE"}, "被动技能: ",{"color", "WHITE"})
		for tid, lvl in pairs(body.body.talents) do
			local t = body.body:getTalentFromId(tid)
			if self.actor:callTalent(self.actor.T_ASSUME_FORM, "isUsableTalent", t, false) then
				ts:add(true, "- ", {"color", "LIGHT_GREEN"}, ("%s (%0.1f)"):format(t.name or "???",body.body:getTalentLevel(t) ), {"color", "WHITE"} )
			end
		end
		if ts[#ts-1] == "被动技能: " then table.remove(ts) table.remove(ts) table.remove(ts) table.remove(ts) end

		ts:add(true, {"color", "ORANGE"}, "主动技能: ",{"color", "WHITE"})
		for tid, lvl in pairs(body.body.talents) do
			local t = body.body:getTalentFromId(tid)
			if self.actor:callTalent(self.actor.T_ASSUME_FORM, "isUsableTalent", t, true) then
				ts:add(true, "- ", {"color", "LIGHT_GREEN"}, ("%s (%0.1f)"):format(t.name or "???",body.body:getTalentLevel(t) ), {"color", "WHITE"} )
			end
		end
		if ts[#ts-1] == "主动技能: " then table.remove(ts) table.remove(ts) table.remove(ts) table.remove(ts) end

		local d = {
			body = body.body,
			uses = uses,
			name = name,
			sortname = body.body.name,
			desc = ts,
		}
		list[#list+1] = d
	end end
	table.sort(list, "sortname")

	self.list = list
end
