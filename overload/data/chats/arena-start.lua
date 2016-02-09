-- ToME - Tales of Maj'Eyal
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

--[[
local give_boots_rush = function(self, player)
	local o = game.zone:makeEntityByName(game.level, "object", "ARENA_BOOTS_RUSH")
	if o then
		o:identify(true)
		player:addObject(player.INVEN_INVEN, o)
		game.zone:addEntity(game.level, o, "object")
		game.level.arena.perk = "Rush"..game.level.arena.modeString
	end
end

local give_boots_phas = function(self, player)
	local o = game.zone:makeEntityByName(game.level, "object", "ARENA_BOOTS_PHAS")
	if o then
		o:identify(true)
		player:addObject(player.INVEN_INVEN, o)
		game.zone:addEntity(game.level, o, "object")
		game.level.arena.perk = "Phasing"..game.level.arena.modeString
	end
end

local give_boots_dise = function(self, player)
	local o = game.zone:makeEntityByName(game.level, "object", "ARENA_BOOTS_DISE")
	if o then
		o:identify(true)
		player:addObject(player.INVEN_INVEN, o)
		game.zone:addEntity(game.level, o, "object")
		game.level.arena.perk = "Disengage"..game.level.arena.modeString
	end
end

local give_boots_lspeed = function(self, player)
	local o = game.zone:makeEntityByName(game.level, "object", "ARENA_BOOTS_LSPEED")
	if o then
		o:identify(true)
		player:addObject(player.INVEN_INVEN, o)
		game.zone:addEntity(game.level, o, "object")
		game.level.arena.perk = "LSpeed"..game.level.arena.modeString
	end
end

local give_bow = function(self, player)
	local o = game.zone:makeEntityByName(game.level, "object", "ARENA_BOW")
	if o then
		o:identify(true)
		player:addObject(player.INVEN_INVEN, o)
		game.zone:addEntity(game.level, o, "object")
		game.level.arena.perk = "Bow"..game.level.arena.modeString
	end
end

local give_sling = function(self, player)
	local o = game.zone:makeEntityByName(game.level, "object", "ARENA_SLING")
	if o then
		o:identify(true)
		player:addObject(player.INVEN_INVEN, o)
		game.zone:addEntity(game.level, o, "object")
		game.level.arena.perk = "Sling"..game.level.arena.modeString
	end
end

local give_healinfu = function(self, player)
	local o = game.zone:makeEntity(game.level, "object", {name="healing infusion"}, 1, true)
	if o then
		o:identify(true)
		o.inscription_data.heal = 350
		o.inscription_data.cooldown = o.inscription_data.cooldown + 5
		player:addObject(player.INVEN_INVEN, o)
		game.zone:addEntity(game.level, o, "object")
		game.level.arena.perk = "Heal"..game.level.arena.modeString
	end
end

local give_moveinfu = function(self, player)
	local o = game.zone:makeEntity(game.level, "object", {name="movement infusion"}, 1, true)
	if o then
		o:identify(true)
		player:addObject(player.INVEN_INVEN, o)
		o.inscription_data.dur = o.inscription_data.dur + 2
		game.zone:addEntity(game.level, o, "object")
		game.level.arena.perk = "Move"..game.level.arena.modeString
	end
end

local give_imbue = function(self, player)
	player:learnTalent(player.T_IMBUE_ITEM, true, 4, {no_unlearn=true})
	player.changed = true
	game.level.arena.perk = "Imbue"..game.level.arena.modeString
end

local give_debugarms = function(self, player)
	local debugarms = { "ARENA_DEBUG_CANNON", "ARENA_DEBUG_ARMOR", "BARRAGE", "RAPTOR", "ARENA_BOOTS_JUMPING", "WARDING", "HEATEATER", "PRISM" }
	local o
	for i = 0, #debugarms do
	o = game.zone:makeEntityByName(game.level, "object", debugarms[i])
		if o then
			o:identify(true)
			player:addObject(player.INVEN_INVEN, o)
			game.zone:addEntity(game.level, o, "object")
		end
	end

	game.level.arena.perk = "Debug"..game.level.arena.modeString
end
]]--
local arena_3 = function(self, player)
	game.level.arena.eventWave = 2
	game.level.arena.finalWave = 3
	game.level.arena.modeString = "3"
	local arenashop = game:getStore("ARENA_SHOP")
	arenashop:loadup(game.level, game.zone)
	arenashop:interact(game.player, "Gladiator's wares")
	arenashop = nil
end

local arena_30 = function(self, player)
	game.level.arena.eventWave = 5
	game.level.arena.finalWave = 31
	game.level.arena.modeString = "30"
	local arenashop = game:getStore("ARENA_SHOP")
	arenashop:loadup(game.level, game.zone)
	arenashop:interact(game.player, "Gladiator's wares")
	arenashop = nil
end

local arena_60 = function(self, player)
	game.level.arena.eventWave = 5
	game.level.arena.finalWave = 61
	game.level.arena.modeString = "60"
	local arenashop = game:getStore("ARENA_SHOP")
	arenashop:loadup(game.level, game.zone)
	arenashop:interact(game.player, "Gladiator's wares")
	arenashop = nil
end

local give_bonus = function(self, player)
	game.level.arena.bonusMin = 1.1
	game.level.arena.bonusMultiplier = 1.1
	game.level.arena.perk = "None"..game.level.arena.modeString
end

local save_clear = function(self, player)
	world.arena = nil
	if not world.arena then
		local emptyScore = {name = nil, score = 0, perk = nil, wave = 1, sex = nil, race = nil, class = nil}
		world.arena = {
			master30 = nil,
			master60 = nil,
			lastScore = emptyScore,
			bestWave = 1,
			ver = 1
		}
		world.arena.scores = {[1] = emptyScore}
	end
	local o = game.zone:makeEntityByName(game.level, "object", "ARENA_SCORING")
	if o then game.zone:addEntity(game.level, o, "object", 7, 3) end

	local arenashop = game:getStore("ARENA_SHOP")
	arenashop:loadup(game.level, game.zone)
	arenashop:interact(game.player, "Gladiator's wares")
	arenashop = nil
end

newChat{ id="welcome",
	text = "#LIGHT_GREEN#在进入之前，你看了一下排行榜。\n"..text,
	answers = {
		--{"Enter the arena for 3 rounds[DEBUG]", action=arena_3, jump="perks"},
		{"竞技场（60波）", action=arena_60},
		{"竞技场（30波）", action=arena_30},
		--{"Enter the arena for as long as you can last", action=arena_inf, jump="perks"},
		{"#LIGHT_RED#[重置竞技场数据]", action=save_clear},
	}
}

newChat{ id="welcome2",
	text = "你选择什么？",
	answers = {
		{"进入60波竞技场", action=arena_60},
		{"进入30波竞技场", action=arena_30},
		--{"Enter the arena for as long as you can last", action=arena_inf, jump="perks"},
	}
}

return "welcome"
