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
local GetQuantity = require "engine.dialogs.GetQuantity"

module(..., package.seeall, class.inherit(engine.ui.Dialog))

function _M:init()
	self:generateList()
	engine.ui.Dialog.init(self, "调试/作弊! 你一定在想着做坏事吧!", 1, 1)

	local list = List.new{width=400, height=500, list=self.list, fct=function(item) self:use(item) end}

	self:loadUI{
		{left=0, top=0, ui=list},
	}
	self:setupUI(true, true)

	self.key:addCommands{ __TEXTINPUT = function(c) if self.list and self.list.chars[c] then self:use(self.list[self.list.chars[c]]) end end}
	self.key:addBinds{ EXIT = function() game:unregisterDialog(self) end, }
end

function _M:on_register()
	game:onTickEnd(function() self.key:unicodeInput(true) end)
end

function _M:use(item)
	if not item then return end
	game:unregisterDialog(self)

	if item.dialog then
		local d = require("mod.dialogs.debug."..item.dialog).new()
		game:registerDialog(d)
		return
	end

	local act = item.action

	local stop = false
	if act == "godmode" then
		game.player:forceLevelup(50)
		game.player.invulnerable = 1
		game.player.esp_all = 1
		game.player.esp_range = 50
		game.player.no_breath = 1
		game.player.money = 500
		game.player.auto_id = 100
		game.state.birth.ignore_prodigies_special_reqs = true
		game.player.inc_damage.all = 100000
		game.player:incStat("str", 100) game.player:incStat("dex", 100) game.player:incStat("mag", 100) game.player:incStat("wil", 100) game.player:incStat("cun", 100) game.player:incStat("con", 100)
	elseif act == "semigodmode" then
		game.player.invulnerable = 0
		game.player.no_breath = 0
		game.player:forceLevelup(50)
		game.player.life_regen = 2000
		game.player.esp_all = 1
		game.player.esp_range = 50
		game.player.money = 500
		game.player.auto_id = 100
		game.state.birth.ignore_prodigies_special_reqs = true
		game.player.inc_damage.all = 500
		game.player:incStat("str", 100) game.player:incStat("dex", 100) game.player:incStat("mag", 100) game.player:incStat("wil", 100) game.player:incStat("cun", 100) game.player:incStat("con", 100)
	elseif act == "weakdamage" then
		game.player.inc_damage.all = -90
	elseif act == "all_arts" then
		for i, e in ipairs(game.zone.object_list) do
			if e.unique and e.define_as ~= "VOICE_SARUMAN" and e.define_as ~= "ORB_MANY_WAYS_DEMON" then
				local a = game.zone:finishEntity(game.level, "object", e)
				a.no_unique_lore = true -- to not spam
				a:identify(true)
				if a.name == a.unided_name then print("=================", a.name) end
				game.zone:addEntity(game.level, a, "object", game.player.x, game.player.y)
			end
		end
	elseif act == "magic_map" then
		game.level.map:liteAll(0, 0, game.level.map.w, game.level.map.h)
		game.level.map:rememberAll(0, 0, game.level.map.w, game.level.map.h)
		for i = 0, game.level.map.w - 1 do
			for j = 0, game.level.map.h - 1 do
				local trap = game.level.map(i, j, game.level.map.TRAP)
				if trap then
					trap:setKnown(game.player, true)
					game.level.map:updateMap(i, j)
				end
			end
		end
	elseif act == "change_level" then
		game:registerDialog(GetQuantity.new("地图: "..game.zone.name, "楼层 1-"..game.zone.max_level, game.level.level, game.zone.max_level, function(qty)
			game:changeLevel(qty)
		end), 1)
	elseif act == "shertul-energy" then
		game.player:grantQuest("shertul-fortress")
		game.player:hasQuest("shertul-fortress"):gain_energy(1000)
	elseif act == "all_traps" then
		for _, file in ipairs(fs.list("/data/general/traps/")) do if file:find(".lua$") then
			local list = mod.class.Trap:loadList("/data/general/traps/"..file)
			for i, e in ipairs(list) do
				print("======",e.name,e.rarity)
				if e.rarity then
					local trap = game.zone:finishEntity(game.level, "trap", e)
					trap:setKnown(game.player, true)
					local x, y = util.findFreeGrid(game.player.x, game.player.y, 20, true, {[engine.Map.TRAP]=true})
					if x then
						game.zone:addEntity(game.level, trap, "trap", x, y)
					end
				end
			end
		end end
	elseif act == "remove-all" then
		local l = {}
		for uid, e in pairs(game.level.entities) do
			if not game.party:hasMember(e) then l[#l+1] = e end
		end
		for i, e in ipairs(l) do
			game.level:removeEntity(e)
		end
	elseif act == "all-ingredients" then
		game.party:giveAllIngredients(100)
		-- Gems count too
		for def, od in pairs(game.zone.object_list) do
			if type(def) == "string" and not od.unique and od.rarity and def:find("^GEM_") then
				local o = game.zone:finishEntity(game.level, "object", od)
				o:identify(true)
				game.player:addObject("INVEN", o)
				game.player:sortInven()
			end
		end
	elseif act == "test-dummy" then
		local m = mod.class.NPC.new{define_as="TRAINING_DUMMY",
			type = "training", subtype = "dummy",
			name = "Test Dummy", color=colors.GREY,
			desc = "Test dummy.", image = "npc/lure.png",
			level_range = {1, 1}, exp_worth = 0,
			rank = 3,
			max_life = 300000, life_rating = 0,
			life_regen = 300000,
			never_move = 1,
			training_dummy = 1,
		}
		local x, y = util.findFreeGrid(game.player.x, game.player.y, 20, true, {[engine.Map.ACTOR]=true})
		if not x then return end
		m:resolve()
		m:resolve(nil, true)
		game.zone:addEntity(game.level, m, "actor", x, y)
	else
		self:triggerHook{"DebugMain:use", act=act}
	end
end

function _M:generateList()
	local list = {}

	list[#list+1] = {name="切换地图", dialog="ChangeZone"}
	list[#list+1] = {name="切换楼层", action="change_level"}
	list[#list+1] = {name="地图全开", action="magic_map"}
	list[#list+1] = {name="无敌模式", action="godmode"}
	list[#list+1] = {name="制造所有神器", action="all_arts"}
	list[#list+1] = {name="接任务/重接任务", dialog="GrantQuest"}
	list[#list+1] = {name="召唤生物", dialog="SummonCreature"}
	list[#list+1] = {name="制造物品", dialog="CreateItem"}
	list[#list+1] = {name="调整阵营友好度", dialog="AlterFaction"}
	list[#list+1] = {name="获得夏·图尔堡垒能量", action="shertul-energy"}
	list[#list+1] = {name="制造陷阱", dialog="CreateTrap"}
	list[#list+1] = {name="清除所有生物", action="remove-all"}
	list[#list+1] = {name="半无敌模式", action="semigodmode"}
	list[#list+1] = {name="获得所有材料", action="all-ingredients"}
	list[#list+1] = {name="减少造成的伤害", action="weakdamage"}
	list[#list+1] = {name="测试傀儡", action="test-dummy"}
	self:triggerHook{"DebugMain:generate", menu=list}

	local chars = {}
	for i, v in ipairs(list) do
		v.name = self:makeKeyChar(i)..") "..v.name
		chars[self:makeKeyChar(i)] = i
	end
	list.chars = chars

	self.list = list
end
