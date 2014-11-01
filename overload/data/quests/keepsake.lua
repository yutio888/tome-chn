-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011 Nicolas Casalini
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

-- Keepsake
name = "Keepsake"
id = "keepsake"

desc = function(self, who)
	local desc = {}
	desc[#desc+1] = "You have begun to look for a way to overcome the curse that afflicts you."
	if self:isCompleted("berethh-killed-good") then
		desc[#desc+1] = "You have found a small iron acorn which you keep as a reminder of your past."
		desc[#desc+1] = "You have destroyed the merchant caravan that you once considered family."
		desc[#desc+1] = "Kyless, the one who brought the curse, is dead by your hand."
		desc[#desc+1] = "Berethh is dead, may he rest in peace."
		desc[#desc+1] = "Your curse has changed the iron acorn which now serves as a cruel reminder of your past and present."
	elseif self:isCompleted("berethh-killed-evil") then
		desc[#desc+1] = "You have found a small iron acorn which you keep as a reminder of your past"
		desc[#desc+1] = "You have destroyed the merchant caravan that you once considered family."
		desc[#desc+1] = "Kyless, the one who brought the curse, is dead by your hand."
		desc[#desc+1] = "Berethh is dead, may he rest in peace."
		desc[#desc+1] = "Your curse has defiled the iron acorn which now serves as a reminder of your vile nature."
	elseif self:isCompleted("kyless-killed") then
		desc[#desc+1] = "You have found a small iron acorn which you keep as a reminder of your past."
		desc[#desc+1] = "You have destroyed the merchant caravan that you once considered family."
		desc[#desc+1] = "Kyless, the one who brought the curse, is dead by your hand."
		desc[#desc+1] = "#LIGHT_GREEN#You need to find Berethh, the last person who may be able to help you."
	elseif self:isCompleted("caravan-destroyed") then
		desc[#desc+1] = "You have found a small iron acorn which you keep as a reminder of your past."
		desc[#desc+1] = "You have destroyed the merchant caravan that you once considered family."
		desc[#desc+1] = "#LIGHT_GREEN#Seek out Kyless' cave in the northern part of the meadow and end him. Perhaps the curse will end with him."
	elseif self:isCompleted("acorn-found") then
		desc[#desc+1] = "You have found a small iron acorn which you keep as a reminder of your past."
		desc[#desc+1] = "#LIGHT_GREEN#Discover the meaning of the acorn and the dream."
	else
		desc[#desc+1] = "#LIGHT_GREEN#You may have to revist your past to unlock some secret buried there."
	end
	return table.concat(desc, "\n")
end

on_grant = function(self, who)
	game.logPlayer(who, "#VIOLET#The time has come to learn the true nature of your curse.")
	game.player:incHate(-100)
	
	if who:knowTalent(who.T_DEFILING_TOUCH) then
		self.balance = -1
	else
		self.balance = 0
	end
end

on_enter_meadow = function(self, who)
	if self.return_from_dream then
		self:on_return_from_dream(who)
	elseif self.spawn_companions then
		self:on_spawn_companions(who)
	end
end

on_enter_cave_entrance = function(self, who)
	if self.spawn_berethh then
		self:on_spawn_berethh(who)
	end
end

on_start_dream = function(self, who)
	game.party:learnLore("keepsake-dream")
	game.logPlayer(who, "#VIOLET#You find yourself in a dream.")
	
	-- make sure waking up returns to the same spot
	game.level.default_down.x = who.x
	game.level.default_down.y = who.y
	
	-- move to dream
	game:changeLevel(2, nil, {direct_switch=true})
	game:playSound("ambient/forest/wind1")
	
	-- make yourself immortal
	who.old_die = who.die
	who.die = function(self)
		local old_heal_factor = healing_factor
		self.healing_factor = 1
		self:heal(math.max(0, self.life) + self.max_life * 0.5)
		self.healing_factor = old_heal_factor
		
		self:incHate(25)
		
		self.dead = false
		game.logPlayer(who, "#VIOLET#Your hate surges. You refuse to succumb to death!")
	end
end

on_pickup_acorn = function(self, who)
	game.party:learnLore("keepsake-acorn")
	game.logPlayer(who, "#VIOLET#You have discovered a small iron acorn, a link to your past.")
	
	who:setQuestStatus("keepsake", engine.Quest.COMPLETED, "acorn-found")
end

on_find_caravan = function(self, who)
	game.party:learnLore("keepsake-caravan")
	game.logPlayer(who, "#VIOLET#The merchant caravan from the past has appeared in your dream.")
	
	-- turn the caravaneers hostile
	engine.Faction:setFactionReaction(who.faction, "merchant-caravan", -100, true)
end

on_caravan_destroyed = function(self, who)
	local Chat = require "engine.Chat"
	local chat = Chat.new("keepsake-caravan-destroyed", {name="Last of the Caravan"}, game.player)
	chat:invoke()
end

on_caravan_destroyed_chat_over = function(self, who)
	who:setQuestStatus("keepsake", engine.Quest.COMPLETED, "caravan-destroyed")
	
	-- return to the meadow and create the cave exit
	game:changeLevel(1, nil, {direct_switch=true})
	local g = mod.class.Grid.new{
		show_tooltip=true, always_remember = true,
		type="floor", subtype="grass",
		name="secret path to the cave",
		image = "terrain/grass.png", add_mos = {{image="terrain/way_next_8.png"}},
		display = '>', color_r=255, color_g=255, color_b=0,
		notice = true, always_remember = true,
		change_level=2
	}
	g:resolve() g:resolve(nil, true)
	local spot = game.level:pickSpot{type="level", subtype="down"}
	game.zone:addEntity(game.level, g, "terrain", spot.x, spot.y)
	-- move location where you appear from dream wakeup spot to the new stairs
	game.level.default_down.x = spot.x
	game.level.default_down.y = spot.y
	
	-- make yourself mortal again
	game.player:heal(game.player.max_life)
	game.player:incHate(game.player.max_hate)
	who.die = who.old_die
	who.old_die = nil
	
	game.party:learnLore("keepsake-dreams-end")
	game.logPlayer(who, "#VIOLET#You have begun your hunt for Kyless!")
end

on_cave_marker = function(self, who)
	game.party:learnLore("keepsake-cave-marker")
	game.logPlayer(who, "#VIOLET#You have a marker to the entrance of Kyless' cave!")
end

on_cave_entrance = function(self, who)
	game.party:learnLore("keepsake-cave-entrance")
	game.logPlayer(who, "#VIOLET#You have found the entrance to Kyless' cave!")
end

on_cave_description = function(self, who)
	game.party:learnLore("keepsake-cave-description")
	
	-- spawn the guards
	spot = game.level:pickSpot{type="guards", subtype="wardog"}
	x, y = util.findFreeGrid(spot.x, spot.y, 2, true, {[engine.Map.ACTOR]=true})
	m = game.zone:makeEntityByName(game.level, "actor", "CORRUPTED_WAR_DOG")
	if m and x and y then game.zone:addEntity(game.level, m, "actor", x, y) end
	
	for i = 1, 2 do
		spot = game.level:pickSpot{type="guards", subtype="claw"}
		x, y = util.findFreeGrid(spot.x, spot.y, 2, true, {[engine.Map.ACTOR]=true})
		m = game.zone:makeEntityByName(game.level, "actor", "SHADOW_CLAW")
		if m and x and y then game.zone:addEntity(game.level, m, "actor", x, y) end
	end
end

on_vault_entrance = function(self, who)
	game.party:learnLore("keepsake-vault-entrance")
	game.logPlayer(who, "#VIOLET#You have found the entrance to a vault!")
end

on_vault_trigger = function(self, who)
	for i = 1, 7 do
		spot = game.level:pickSpot{type="vault1", subtype="encounter"}
		x, y = util.findFreeGrid(spot.x, spot.y, 2, true, {[engine.Map.ACTOR]=true})
		m = game.zone:makeEntity(game.level, "actor", {special_rarity="vault_rarity"}, nil, true)
		if m and x and y then game.zone:addEntity(game.level, m, "actor", x, y) end
	end
	game.logPlayer(who, "#VIOLET#The shadows have noticed you!")
end

on_dog_vault = function(self, who)
	require("engine.ui.Dialog"):simplePopup("A Second Vault", "You recoginize this door as the entrance to a second vault. There are some scuffling noises and heavy breathing coming from the other side of the door.")
end

on_kyless_encounter = function(self, who)
	game.party:learnLore("keepsake-kyless-encounter")
	game.logPlayer(who, "#VIOLET#You have found Kyless. You must destroy him.")
end

on_kyless_death = function(self, who, kyless)
	local Chat = require "engine.Chat"
	local chat = Chat.new("keepsake-kyless-death", {name="Death of Kyless"}, game.player)
	chat:invoke()

	who:setQuestStatus("keepsake", engine.Quest.COMPLETED, "kyless-killed")
	game.logPlayer(who, "#VIOLET#Kyless is dead.")
	self.spawn_berethh = true
end

on_keep_book = function(self, who)
	local o = game.zone:makeEntityByName(game.level, "object", "KYLESS_BOOK")
	if o then
		game.zone:addEntity(game.level, o, "object")
		who:addObject(who.INVEN_INVEN, o)
		o:added()
		who:sortInven()
	end
end

on_spawn_berethh = function(self, who)
	spot = game.level:pickSpot{type="berethh", subtype="encounter"}
	x, y = util.findFreeGrid(spot.x, spot.y, 5, true, {[engine.Map.ACTOR]=true})
	m = game.zone:makeEntityByName(game.level, "actor", "BERETHH")
	if m and x and y then
		game.zone:addEntity(game.level, m, "actor", x, y)
		self.spawn_berethh = nil
	end
end

on_berethh_encounter = function(self, who, berethh)
	local Chat = require "engine.Chat"
	local chat = Chat.new("keepsake-berethh-encounter", {name="Berethh"}, game.player)
	chat:invoke()
end

on_berethh_death = function(self, who, berethh)
	game.logPlayer(who, "#VIOLET#Berethh lies dead.")
	
	if self.balance > 0 then
		who:setQuestStatus("keepsake", engine.Quest.COMPLETED, "berethh-killed-good")
		game.party:learnLore("keepsake-berethh-death-good")
	else
		who:setQuestStatus("keepsake", engine.Quest.COMPLETED, "berethh-killed-evil")
		game.party:learnLore("keepsake-berethh-death-evil")
	end
	self.spawn_companions = true
	
	who:setQuestStatus("keepsake", engine.Quest.DONE)
	
	local carry, o, item, inven_id = game.party:findInAllInventoriesBy("define_as", "IRON_ACORN_BASIC")
	if carry and o then
		carry:removeObject(inven_id, item, true)
		o:removed()
		
		local o
		if self.balance > 0 then
			o = game.zone:makeEntityByName(game.level, "object", "IRON_ACORN_GOOD")
		else
			o = game.zone:makeEntityByName(game.level, "object", "IRON_ACORN_EVIL")
		end
		if o then
			game.zone:addEntity(game.level, o, "object")
			carry:addObject(carry.INVEN_INVEN, o)
			o:added()
			carry:sortInven()
		end
	end
end

on_spawn_companions = function(self, who)
	self.spawn_companions = nil
	for i = 1, 2 do
		spot = game.level:pickSpot{type="companions", subtype="wardog"}
		x, y = util.findFreeGrid(spot.x, spot.y, 2, true, {[engine.Map.ACTOR]=true})
		m = game.zone:makeEntityByName(game.level, "actor", "WAR_DOG")
		if m and x and y then game.zone:addEntity(game.level, m, "actor", x, y) end
	end
	for i = 1, 2 do
		spot = game.level:pickSpot{type="companions", subtype="warrior"}
		x, y = util.findFreeGrid(spot.x, spot.y, 2, true, {[engine.Map.ACTOR]=true})
		m = game.zone:makeEntityByName(game.level, "actor", "BERETHH_WARRIOR")
		if m and x and y then game.zone:addEntity(game.level, m, "actor", x, y) end
	end
	for i = 1, 2 do
		spot = game.level:pickSpot{type="companions", subtype="archer"}
		x, y = util.findFreeGrid(spot.x, spot.y, 2, true, {[engine.Map.ACTOR]=true})
		m = game.zone:makeEntityByName(game.level, "actor", "BERETHH_ARCHER")
		if m and x and y then game.zone:addEntity(game.level, m, "actor", x, y) end
	end
end

on_good_choice = function(self, who)
	self.balance = (self.balance or 0) + 1
end

on_evil_choice = function(self, who)
	self.balance = (self.balance or 0) - 1
end
