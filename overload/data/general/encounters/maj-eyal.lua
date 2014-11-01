-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2014 Nicolas Casalini
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

newEntity{
	name = "Novice mage",
	type = "harmless", subtype = "special", unique = true,
	immediate = {"world-encounter", "angolwen"},
	-- Spawn the novice mage near the player
	on_encounter = function(self, who)
		local x, y = self:findSpot(who)
		if not x then return end

		local g = mod.class.WorldNPC.new{
			name="Novice mage",
			type="humanoid", subtype="human", faction="angolwen",
			display='@', color=colors.RED,
			image = "npc/humanoid_human_apprentice_mage.png",
			can_talk = "mage-apprentice-quest",
			cant_be_moved = false,
			unit_power = 3000,
		}
		g:resolve() g:resolve(nil, true)
		game.zone:addEntity(game.level, g, "actor", x, y)
		return true
	end,
}

newEntity{
	name = "Lost merchant",
	type = "hostile", subtype = "special", unique = true,
	level_range = {10, 20},
	rarity = 7,
	min_level = 6,
	on_world_encounter = "merchant-quest",
	on_encounter = function(self, who)
		who.energy.value = game.energy_to_act
		game.paused = true
		who:runStop()
		engine.ui.Dialog:yesnoPopup("遭遇", "你发现了一个隐藏地下室的入口，你听到从里面传来了呼救声...", function(ok)
			if not ok then
				game.logPlayer(who, "#LIGHT_BLUE#You carefully get away without making a sound.")
			else
				game:changeLevel(1, "thieves-tunnels")
				game.logPlayer(who, "#LIGHT_RED#You carefully open the trap door and enter the underground tunnels...")
				game.logPlayer(who, "#LIGHT_RED#As you enter you notice the trap door has no visible handle on the inside. You are stuck here!")
				who:grantQuest("lost-merchant")
			end
		end, "进入通道", "悄悄离开", true)
		return true
	end,
}

newEntity{
	name = "Sect of Kryl-Faijan",
	type = "hostile", subtype = "special", unique = true,
	level_range = {24, 35},
	rarity = 7,
	min_level = 24,
	coords = {{ x=0, y=0, w=100, h=100}},
	on_encounter = function(self, who)
		who.energy.value = game.energy_to_act
		game.paused = true
		who:runStop()
		engine.ui.Dialog:yesnoLongPopup("遭遇", "你发现了一个古老地窖的入口，里面笼罩着恐怖的恶魔气息，仅仅站在门口你就已经感受到了它的威胁。\n你听到里面传来了模糊的女人的哭声。", 400, function(ok)
			if not ok then
				game.logPlayer(who, "#LIGHT_BLUE#You carefully get away without making a sound.")
			else
				game:changeLevel(1, "crypt-kryl-feijan")
				game.logPlayer(who, "#LIGHT_RED#You carefully open the door and enter the underground crypt...")
				game.logPlayer(who, "#LIGHT_RED#As you enter you notice the door has no visible handle on the inside. You are stuck here!")
			end
		end, "进入地窖", "悄悄离开", true)
		return true
	end,
}

newEntity{
	name = "Lost kitten",
	type = "harmless", subtype = "special", unique = true,
	level_range = {15, 35},
	rarity = 100,
	min_level = 15,
	on_world_encounter = "merchant-quest",
	on_encounter = function(self, who)
		who.energy.value = game.energy_to_act
		game.paused = true
		who:runStop()
		local Chat = require "engine.Chat"
		local chat = Chat.new("sage-kitty", mod.class.NPC.new{name="迷路的猫咪", image="npc/sage_kitty.png"}, who)
		chat:invoke()
		return true
	end,
}

newEntity{
	name = "Ancient Elven Ruins",
	type = "harmless", subtype = "special", unique = true,
	immediate = {"world-encounter", "maj-eyal"},
	on_encounter = function(self, who)
		local x, y = self:findSpot(who)
		if not x then return end

		local g = game.level.map(x, y, engine.Map.TERRAIN):cloneFull()
		g.name = "Entrance to some ancient elven ruins"
		g.display='>' g.color_r=0 g.color_g=255 g.color_b=255 g.notice = true
		g.change_level=1 g.change_zone="ancient-elven-ruins" g.glow=true
		g.add_displays = g.add_displays or {}
		g.add_displays[#g.add_displays+1] = mod.class.Grid.new{image="terrain/dungeon_entrance_closed02.png", z=5}
		g:altered()
		g:initGlow()
		game.zone:addEntity(game.level, g, "terrain", x, y)
		print("[WORLDMAP] Elven ruins at", x, y)
		return true
	end,
}

newEntity{
	name = "Cursed Village",
	type = "harmless", subtype = "special", unique = true,
	level_range = {5, 15},
	rarity = 8,
	on_world_encounter = "lumberjack-cursed",
	on_encounter = function(self, who)
		who.energy.value = game.energy_to_act
		game.paused = true
		who:runStop()
		local Chat = require "engine.Chat"
		local chat = Chat.new("lumberjack-quest", {name="Half-dead lumberjack"}, who)
		chat:invoke()
		return true
	end,
}

newEntity{
	name = "Ruined Dungeon",
	type = "harmless", subtype = "special", unique = true,
	immediate = {"world-encounter", "maj-eyal"},
	on_encounter = function(self, who)
		local x, y = self:findSpot(who)
		if not x then return end

		local g = game.level.map(x, y, engine.Map.TERRAIN):cloneFull()
		g.name = "Entrance to a ruined dungeon"
		g.display='>' g.color_r=255 g.color_g=0 g.color_b=0 g.notice = true
		g.change_level=1 g.change_zone="ruined-dungeon" g.glow=true
		g.add_displays = g.add_displays or {}
		g.add_displays[#g.add_displays+1] = mod.class.Grid.new{image="terrain/ruin_entrance_closed01.png", z=5}
		g:altered()
		g:initGlow()
		game.zone:addEntity(game.level, g, "terrain", x, y)
		print("[WORLDMAP] Ruined dungeon at", x, y)
		return true
	end,
}

newEntity{
	name = "Mark of the Spellblaze",
	type = "harmless", subtype = "special", unique = true,
	immediate = {"world-encounter", "mark-spellblaze"},
	on_encounter = function(self, who)
		local x, y = self:findSpot(who)
		if not x then return end

		local g = game.level.map(x, y, engine.Map.TERRAIN):cloneFull()
		g.name = "Mark of the Spellblaze"
		g.display='>' g.color_r=0 g.color_g=200 g.color_b=0 g.notice = true
		g.change_level=1 g.change_zone="mark-spellblaze" g.glow=true
		g.add_displays = g.add_displays or {}
		g.add_displays[#g.add_displays+1] = mod.class.Grid.new{image="terrain/floor_pentagram.png", z=8}
		g:altered()
		g:initGlow()
		game.zone:addEntity(game.level, g, "terrain", x, y)
		print("[WORLDMAP] Mark of the spellblaze at", x, y)
		return true
	end,
}

newEntity{
	name = "Golem Graveyard",
	type = "harmless", subtype = "special", unique = true,
	immediate = {"world-encounter", "maj-eyal"},
	on_encounter = function(self, who)
		local x, y = self:findSpot(who)
		if not x then return end

		local g = game.level.map(x, y, engine.Map.TERRAIN):cloneFull()
		g.name = "Golem Graveyard"
		g.display='>' g.color_r=0 g.color_g=200 g.color_b=0 g.notice = true
		g.change_level=1 g.change_zone="golem-graveyard" g.glow=true
		g.add_displays = g.add_displays or {}
		g.add_displays[#g.add_displays+1] = mod.class.Grid.new{image="npc/alchemist_golem.png", z=5}
		g:altered()
		g:initGlow()
		game.zone:addEntity(game.level, g, "terrain", x, y)
		print("[WORLDMAP] Golem Graveyard at", x, y)
		return true
	end,
}

newEntity{
	name = "Agrimley the Hermit",
	type = "harmless", subtype = "special", unique = true,
	immediate = {"world-encounter", "brotherhood-alchemist"},
	-- Spawn the hermit
	on_encounter = function(self, who)
		local x, y = self:findSpot(who)
		if not x then return end

		local g = mod.class.WorldNPC.new{
			name="Agrimley the Hermit",
			type="humanoid", subtype="human", faction="neutral",
			display='@', color=colors.BLUE,
			can_talk = "alchemist-hermit",
			cant_be_moved = false,
			unit_power = 3000,
		}
		g:resolve() g:resolve(nil, true)
		game.zone:addEntity(game.level, g, "actor", x, y)
		print("[WORLDMAP] Agrimley at", x, y)
		return true
	end,
}

newEntity{
	name = "Ring of Blood",
	type = "harmless", subtype = "special", unique = true,
	immediate = {"world-encounter", "maj-eyal"},
	on_encounter = function(self, who)
		local x, y = self:findSpot(who)
		if not x then return end

		local g = game.level.map(x, y, engine.Map.TERRAIN):cloneFull()
		g.name = "Hidden compound"
		g.display='>' g.color_r=200 g.color_g=0 g.color_b=0 g.notice = true
		g.change_level=1 g.change_zone="ring-of-blood" g.glow=true
		g.add_displays = g.add_displays or {}
		g.add_displays[#g.add_displays+1] = mod.class.Grid.new{image="terrain/cave_entrance_closed02.png", z=5}
		g:altered()
		g:initGlow()
		game.zone:addEntity(game.level, g, "terrain", x, y)
		print("[WORLDMAP] Hidden compound at", x, y)
		return true
	end,
}

newEntity{
	name = "Tranquil Meadow",
	type = "harmless", subtype = "special", unique = true,
	immediate = {"world-encounter", "angolwen"},
	on_encounter = function(self, where)
		-- where contains x, y of random location based on .immediate as defined in eyal map
		if not where then return end
		if not game:getPlayer(true).descriptor or game:getPlayer(true).descriptor.subclass ~= "Cursed" then return end
		
		-- make sure "where" is ok
		local x, y = self:findSpot(where)
		if not x then return end

		local g = game.level.map(x, y, engine.Map.TERRAIN):cloneFull()
		g.name = "tranquil meadow"
		g.display='>' g.color_r=0 g.color_g=255 g.color_b=128 g.notice = true
		g.change_level=1 g.change_zone="keepsake-meadow" g.glow=true
		g.add_displays = g.add_displays or {}
		g.add_displays[#g.add_displays+1] = mod.class.Grid.new{image="terrain/meadow.png", z=5}
		g:altered()
		g:initGlow()
		game.zone:addEntity(game.level, g, "terrain", x, y)
		print("[WORLDMAP] Keepsake: Tranquil Meadow at", x, y)
		return true
	end,
}
