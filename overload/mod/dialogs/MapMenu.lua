-- ToME - Tales of Maj'Eyal
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
require "engine.ui.Dialog"
local List = require "engine.ui.List"
local Map = require "engine.Map"

module(..., package.seeall, class.inherit(engine.ui.Dialog))

function _M:init(mx, my, tmx, tmy, extra)
	self.tmx, self.tmy = util.bound(tmx, 0, game.level.map.w - 1), util.bound(tmy, 0, game.level.map.h - 1)
	if tmx == game.player.x and tmy == game.player.y then self.on_player = true end
	self.extra = extra

	self:generateList()
	self.__showup = false

	local name = "行 动"
	local w = self.font_bold:size(name)
	engine.ui.Dialog.init(self, name, 1, 100, mx, my)

	local list = List.new{width=math.max(w, self.max) + 10, nb_items=math.min(15, #self.list), scrollbar=#self.list>15, list=self.list, fct=function(item) self:use(item) end, select=function(item) self:select(item) end}

	self:loadUI{
		{left=0, top=0, ui=list},
	}

	self:setupUI(true, true, function(w, h)
		self.force_x = mx - w / 2
		self.force_y = my - self.h + (self.ih + list.fh / 3)
		if self.force_y + h > game.h then self.force_y = game.h - h end
	end)

	self.mouse:reset()
	self.mouse:registerZone(0, 0, game.w, game.h, function(button, x, y, xrel, yrel, bx, by, event) if (button == "left" or button == "right") and event == "button" then self.key:triggerVirtual("EXIT") end end)
	self.mouse:registerZone(self.display_x, self.display_y, self.w, self.h, function(button, x, y, xrel, yrel, bx, by, event) if button == "right" and event == "button" then self.key:triggerVirtual("EXIT") else self:mouseEvent(button, x, y, xrel, yrel, bx, by, event) end end)
	self.key:addBinds{ EXIT = function() game:unregisterDialog(self) end, }
end

function _M:unload()
	engine.ui.Dialog.unload(self)
	game:targetMode(false, false)
	self.exited = true
end

function _M:use(item)
	if not item then return end
	game:unregisterDialog(self)
	game:targetMode(false, false)

	local act = item.action

	if act == "extra" then item.action_fct()
	elseif act == "move_to" then game.player:mouseMove(self.tmx, self.tmy, true)
	elseif act == "control" then game.party:setPlayer(item.actor)
	elseif act == "target-player" then item.actor:setTarget(game.player)
	elseif act == "order" then game.party:giveOrders(item.actor)
	elseif act == "change_level" then game.key:triggerVirtual("CHANGE_LEVEL")
	elseif act == "pickup" then game.key:triggerVirtual("PICKUP_FLOOR")
	elseif act == "character_sheet" then game:registerDialog(require("mod.dialogs.CharacterSheet").new(item.actor))
	elseif act == "quests" then game.key:triggerVirtual("SHOW_QUESTS")
	elseif act == "levelup" then game.key:triggerVirtual("LEVELUP")
	elseif act == "inventory" then game.key:triggerVirtual("SHOW_INVENTORY")
	elseif act == "rest" then game.key:triggerVirtual("REST")
	elseif act == "autoexplore" then game.key:triggerVirtual("RUN_AUTO")
	elseif act == "chat-link" then profile.chat.uc_ext:sendActorLink(game.level.map(self.tmx, self.tmy, Map.ACTOR))
	elseif act == "talent" then
		local d = item
		if d.set_target then
			local a = game.level.map(self.tmx, self.tmy, Map.ACTOR)
			if not a then a = {x=self.tmx, y=self.tmy, __no_self=true} end
			game.player:useTalent(d.talent.id, nil, nil, nil, a)
		else
			game.player:useTalent(d.talent.id)
		end
	elseif act == "debug-inspect" then
		local DebugConsole = require"engine.DebugConsole"
		local d = DebugConsole.new()
		game:registerDialog(d)
		DebugConsole.line = "=__uids["..item.actor.uid.."]"
		DebugConsole.line_pos = #DebugConsole.line
		d.changed = true
	elseif act == "debug-inventory" then
		local d
		local actor = item.actor
		d = item.actor:showEquipInven(item.actor.name..": Inventory", nil, function(o, inven, item, button, event)
			if not o then return end
			local ud = require("mod.dialogs.UseItemDialog").new(event == "button", actor, o, item, inven, function(_, _, _, stop)
				d:generate()
				d:generateList()
				if stop then game:unregisterDialog(d) end
			end)
			game:registerDialog(ud)
		end)
	end
end

local olditem = nil
function _M:select(item)
	if self.exited then return end
	if not item then return end
	if olditem and olditem == item then return end
	if not item.set_target then game:targetMode(false, false) return end

	game:targetMode(true, nil, nil, item.set_target)
	game.target:setSpot(self.tmx, self.tmy, "forced")
end

function _M:generateList()
	local list = {}
	local player = game.player

	local g = game.level.map(self.tmx, self.tmy, Map.TERRAIN)
	local t = game.level.map(self.tmx, self.tmy, Map.TRAP)
	local o = game.level.map(self.tmx, self.tmy, Map.OBJECT)
	local a = game.level.map(self.tmx, self.tmy, Map.ACTOR)
	local p = game.level.map(self.tmx, self.tmy, Map.PROJECTILE)

	-- Generic actions
	if g and g.change_level and self.on_player then list[#list+1] = {name="切换地图", action="change_level", color=colors.simple(colors.VIOLET)} end
	if o and self.on_player then list[#list+1] = {name="拾取物品", action="pickup", color=colors.simple(colors.ANTIQUE_WHITE)} end
	if g and not self.on_player then list[#list+1] = {name="移动", action="move_to", color=colors.simple(colors.ANTIQUE_WHITE)} end
	if a and not self.on_player and game.party:canControl(a, false) then list[#list+1] = {name="控制", action="control", color=colors.simple(colors.TEAL), actor=a} end
	if a and not self.on_player and game.party:canOrder(a, false) then list[#list+1] = {name="发布指令", action="order", color=colors.simple(colors.TEAL), actor=a} end
	if a and not self.on_player and config.settings.cheat then list[#list+1] = {name="设为目标", action="target-player", color=colors.simple(colors.RED), actor=a} end
	if a and config.settings.cheat then list[#list+1] = {name="在Lua中调查 [角色]", action="debug-inspect", color=colors.simple(colors.LIGHT_BLUE), actor=a} end
	if g and config.settings.cheat then list[#list+1] = {name="在Lua中调查 [地形]", action="debug-inspect", color=colors.simple(colors.LIGHT_BLUE), actor=g} end
	if t and config.settings.cheat then list[#list+1] = {name="在Lua中调查 [陷阱]", action="debug-inspect", color=colors.simple(colors.LIGHT_BLUE), actor=t} end
	if p and config.settings.cheat then list[#list+1] = {name="在Lua中调查 [抛射物]", action="debug-inspect", color=colors.simple(colors.LIGHT_BLUE), actor=p} end
	if a and config.settings.cheat then list[#list+1] = {name="显示装备", action="debug-inventory", color=colors.simple(colors.YELLOW), actor=a} end
	if self.on_player then list[#list+1] = {name="休息", action="rest", color=colors.simple(colors.ANTIQUE_WHITE)} end
	if self.on_player then list[#list+1] = {name="自动探索", action="autoexplore", color=colors.simple(colors.ANTIQUE_WHITE)} end
	if self.on_player then list[#list+1] = {name="查看物品", action="inventory", color=colors.simple(colors.ANTIQUE_WHITE)} end
	if self.on_player then list[#list+1] = {name="查看任务", action="quests", color=colors.simple(colors.ANTIQUE_WHITE)} end
	if a then list[#list+1] = {name="查看生物", action="character_sheet", color=colors.simple(colors.ANTIQUE_WHITE), actor=a} end
	if not self.on_player and a and profile.auth and profile.hash_valid then list[#list+1] = {name="链接生物至聊天栏", action="chat-link"} end
	if self.on_player and (player.unused_stats > 0 or player.unused_talents > 0 or player.unused_generics > 0 or player.unused_talents_types > 0) then list[#list+1] = {name="升级！", action="levelup", color=colors.simple(colors.YELLOW)} end

	-- Talents
	if game.zone and not game.zone.wilderness then
		local canHit = function(tg, x, y) do return true end
			local hit = false
			player:project(tg, x, y, function(px, py)
				if px == x and py == y then
					hit = true
				end
			end)
			return hit
		end
		local tals = {}
		for tid, _ in pairs(player.talents) do
			local t = player:getTalentFromId(tid)
			local t_avail = false
			local tg = player:getTalentTarget(t)
			local total_range = player:getTalentRange(t) + player:getTalentRadius(t)
			local default_tg = {type=util.getval(t.direct_hit, player, t) and "hit" or "bolt", range=total_range}
			if t.mode == "activated" and not player:isTalentCoolingDown(t) and
			  player:preUseTalent(t, true, true) and
			  (not player:getTalentRequiresTarget(t) or
			   canHit(tg or default_tg, self.tmx, self.tmy))
			  then
			   	t_avail = true
			elseif t.mode == "sustained" and not t.no_npc_use and
			  not player:isTalentCoolingDown(t) and player:preUseTalent(t, true, true) then
				t_avail = true
			end
			if t_avail then
				local rt = util.getval(t.requires_target, player, t)
				local e = t.display_entity
				-- Pregenenerate icon with the Tiles instance that allows images
				if t.display_entity and game.uiset.hotkeys_display_icons then t.display_entity:getMapObjects(game.uiset.hotkeys_display_icons.tiles, {}, 1) end
				if self.on_player and not rt then
					tals[#tals+1] = {name=e:getDisplayString()..t.name, dname=t.name, talent=t, action="talent", color=colors.simple(colors.GOLD)}
				elseif not self.on_player and rt then
					tals[#tals+1] = {name=e:getDisplayString()..t.name, dname=t.name, talent=t, action="talent", set_target=tg or default_tg, color=colors.simple(colors.GOLD)}
				end
			end
		end
		table.sort(tals, function(a, b)
			local ha, hb
			for i = 1, 12 * player.nb_hotkey_pages do if player.hotkey[i] and player.hotkey[i][1] == "talent" and player.hotkey[i][2] == a.talent.id then ha = i end end
			for i = 1, 12 * player.nb_hotkey_pages do if player.hotkey[i] and player.hotkey[i][1] == "talent" and player.hotkey[i][2] == b.talent.id then hb = i end end

			if ha and hb then return ha < hb
			elseif ha and not hb then return ha < 999999
			elseif hb and not ha then return hb > 999999
			else return a.talent.name < b.talent.name
			end
		end)
		for i = 1, #tals do list[#list+1] = tals[i] end
	end

	if self.extra then 
		if self.extra.name then
			table.insert(list, 1, {name=self.extra.name, action="extra", action_fct=self.extra.fct, color=self.extra.color}) 
		else
			for i, extra in ipairs(self.extra) do
				table.insert(list, i, {name=extra.name, action="extra", action_fct=extra.fct, color=extra.color}) 
			end
		end
	end

	self.max = 0
	self.maxh = 0
	for i, v in ipairs(list) do
		local w, h = self.font:size(v.name)
		self.max = math.max(self.max, w)
		self.maxh = self.maxh + h
	end

	self.list = list
end
