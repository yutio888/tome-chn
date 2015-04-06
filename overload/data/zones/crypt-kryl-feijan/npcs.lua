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

load("/data/general/npcs/elven-caster.lua", rarity(0))
load("/data/general/npcs/elven-warrior.lua", rarity(0))
load("/data/general/npcs/minor-demon.lua", rarity(5))
load("/data/general/npcs/major-demon.lua", function(e) e.rarity = nil end)
load("/data/general/npcs/ogre.lua", function(e) e.faction = "rhalore" if e.rarity then e.rarity = e.rarity + 4 end end)

local Talents = require("engine.interface.ActorTalents")

newEntity{ base="BASE_NPC_MAJOR_DEMON", define_as = "KRYL_FEIJAN",
	allow_infinite_dungeon = true,
	name = "Kryl-Feijan", color=colors.VIOLET, unique = true,
	resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/demon_major_kryl_feijan.png", display_h=2, display_y=-1}}},
	desc = [[This huge demon is covered in darkness. The ripped flesh of its "mother" still hangs from its sharp claws.]],
	killer_message = "and devoured as a demonic breakfast",
	level_range = {29, nil}, exp_worth = 2,
	faction = "fearscape",
	rank = 4,
	size_category = 4,
	max_life = 250, life_rating = 27, fixed_rating = true,
	infravision = 10,
	stats = { str=15, dex=10, cun=42, mag=16, con=14 },
	move_others=true,
	vim_regen = 20,

	instakill_immune = 1,
	poison_immune = 1,
	blind_immune = 1,
	combat_armor = 0, combat_def = 15,

	open_door = true,

	autolevel = "warriormage",
	ai = "tactical", ai_state = { talent_in=2, ai_move="move_astar", },
	ai_tactic = resolvers.tactic"melee",
	resolvers.inscriptions(3, {}),
	resolvers.inscriptions(1, {"manasurge rune"}),

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },

	combat = { dam=resolvers.levelup(resolvers.mbonus(86, 20), 1, 1.4), atk=50, apr=30, dammod={str=1.1} },

	resolvers.drops{chance=100, nb=5, {tome_drops="boss"} },

	resolvers.talents{
		[Talents.T_DARKFIRE]={base=4, every=5, max=7},
		[Talents.T_FLAME_OF_URH_ROK]={base=5, every=5, max=8},
		[Talents.T_SOUL_ROT]={base=5, every=5, max=8},
		[Talents.T_BLOOD_BOIL]={base=5, every=5, max=8},
		[Talents.T_FLAME]={base=5, every=5, max=8},
		[Talents.T_BURNING_WAKE]={base=5, every=5, max=8},
		[Talents.T_WILDFIRE]={base=5, every=5, max=8},
		[Talents.T_BLOOD_GRASP]={base=5, every=5, max=8},
		[Talents.T_DARKNESS]={base=3, every=5, max=6},
		[Talents.T_EVASION]={base=5, every=5, max=8},
		[Talents.T_VIRULENT_DISEASE]={base=3, every=5, max=6},
		[Talents.T_PACIFICATION_HEX]={base=5, every=5, max=8},
		[Talents.T_BURNING_HEX]={base=5, every=5, max=8},
		[Talents.T_BLOOD_LOCK]={base=5, every=5, max=8},
	},
	resolvers.sustains_at_birth(),
}

newEntity{ define_as = "MELINDA",
	name = "Melinda",
	type = "humanoid", subtype = "human", female=true,
	display = "@", color=colors.LIGHT_BLUE,
	image = "terrain/woman_naked_altar.png",
	resolvers.generic(function(e) if engine.Map.tiles.nicer_tiles then e.display_w = 2 end end),
	desc = [[一位赤裸并且全身刻有扭曲符文的女人。
她的四肢被镣铐绑在了祭台上。
尽管她的皮肤上满是鲜血，你仍然能发现她的美丽。]],
	autolevel = "tank",
	ai = "summoned", ai_real = "move_complex", ai_state = { ai_target="target_player", talent_in=4, },
	stats = { str=8, dex=7, mag=8, con=12 },
	faction = "victim", hard_faction = "victim",
	never_anger = true,

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
	lite = 4,
	rank = 2,
	exp_worth = 0,

	max_life = 100, life_regen = 0,
	life_rating = 12,
	combat_armor = 3, combat_def = 3,
	inc_damage = {all=-50},

	on_added_to_level = function(self)
		self:setEffect(self.EFF_TIME_PRISON, 100, {})
	end,

	on_die = function(self)
		game.player:hasQuest("kryl-feijan-escape").not_saved = true
		game.player:setQuestStatus("kryl-feijan-escape", engine.Quest.FAILED)
	end,
}

newEntity{ define_as = "ACOLYTE",
	name = "Acolyte of the Sect of Kryl-Feijan",
	type = "humanoid", subtype = "elf", image = "npc/humanoid_shalore_elven_corruptor.png",
	display = "p", color=colors.LIGHT_RED,
	desc = [[Black-robed Elves with a mad look in their eyes.]],
	autolevel = "caster",
	stats = { str=12, dex=17, mag=18, wil=22, con=12 },

	infravision = 10,
	move_others = true,

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
	rank = 3,
	exp_worth = 2,

	max_life = 200, life_regen = 10,
	life_rating = 14,

	resolvers.talents{
		[Talents.T_SOUL_ROT]=4,
		[Talents.T_FLAME]=5,
		[Talents.T_MANATHRUST]=3,
	},
	resolvers.sustains_at_birth(),

	ai = "tactical", ai_state = { talent_in=2, ai_move="move_astar", },
	ai_tactic = resolvers.tactic"ranged",
	resolvers.inscriptions(1, "rune"),
	resolvers.inscriptions(1, {"manasurge rune"}),

	on_die = function(self)
		if not game.level.turn_counter then return end
		game.level.turn_counter = game.level.turn_counter + 6 * 10

		local nb = 0
		local melinda
		for uid, e in pairs(game.level.entities) do
			if e.define_as and e.define_as == "ACOLYTE" and not e.dead then nb = nb + 1 end
			if e.define_as and e.define_as == "MELINDA" then melinda = e end
		end
		if nb == 0 then
			game.level.turn_counter = nil

			local spot = game.level:pickSpot{type="locked-door", subtype="locked-door"}
			local g = game.zone:makeEntityByName(game.level, "terrain", "FLOOR")
			game.zone:addEntity(game.level, g, "terrain", spot.x, spot.y)

			if melinda then
				melinda:removeEffect(melinda.EFF_TIME_PRISON)
				melinda.display_w = nil
				melinda.image = "npc/woman_redhair_naked.png"
				melinda:removeAllMOs()
				game.level.map:updateMap(melinda.x, melinda.y)
				require("engine.ui.Dialog"):simpleLongPopup("Melinda", "The woman seems to be freed from her bonds.\nShe stumbles on her feet, her naked body still dripping in blood. 'Please get me out of here!'", 400)
			end
		end
	end,
}
