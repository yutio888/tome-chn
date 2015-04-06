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

load("/data/general/npcs/minor-demon.lua", rarity(0))
load("/data/general/npcs/major-demon.lua", rarity(3))

local Talents = require("engine.interface.ActorTalents")

newEntity{ define_as = "CORRUPTED_DAELACH",
	type = "demon", subtype = "major", unique = true,
	name = "Corrupted Daelach",
	display = "U", color=colors.VIOLET,
	resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/demon_major_corrupted_daelach.png", display_h=2, display_y=-1}}},
	desc = [[Shadow and flames. The huge beast of fire moves speedily toward you, its huge shadowy wings deployed.]],
	level_range = {40, nil}, exp_worth = 2,
	max_life = 250, life_rating = 25, fixed_rating = true,
	rank = 4,
	size_category = 5,
	infravision = 10,
	stats = { str=16, dex=12, cun=14, mag=25, con=16 },
	instakill_immune = 1,
	stun_immune = 1,
	no_breath = 1,
	move_others=true,
	demon = 1,
	invisible = 40,

	on_melee_hit = { [DamageType.FIRE] = 50, [DamageType.LIGHT] = 30, },

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },
	resolvers.equip{
		{type="weapon", subtype="whip", defined="WHIP_URH_ROK", random_art_replace={chance=75}, autoreq=true},
	},
	resolvers.drops{chance=100, nb=5, {tome_drops="boss"} },

	resolvers.talents{
		[Talents.T_FIREBEAM]={base=5, every=7, max=7},
		[Talents.T_DARKNESS]=3,
		[Talents.T_FLAME]={base=5, every=7, max=7},
		[Talents.T_POISON_BREATH]={base=5, every=7, max=7},
		[Talents.T_FIRE_BREATH]={base=5, every=7, max=7},
		[Talents.T_GLOOM]={base=5, every=7, max=7},
		[Talents.T_RUSH]=5,
		[Talents.T_WEAPON_COMBAT]=5,
		[Talents.T_EXOTIC_WEAPONS_MASTERY]={base=3, every=10, max=6},
	},
	resolvers.sustains_at_birth(),

	autolevel = "dexmage",
	ai = "tactical", ai_state = { talent_in=2, ai_move="move_astar", },
	ai_tactic = resolvers.tactic"melee",
	resolvers.inscriptions(3, {}),
	resolvers.inscriptions(1, {"manasurge rune"}),

	on_die = function(self, who)
	end,
}

newEntity{ define_as = "LIMMIR",
	type = "humanoid", subtype = "elf",
	display = "p",
	faction = "sunwall",
	name = "Limmir the Jeweler", color=colors.RED, unique = true,
	desc = [[An Elven Anorithil, specializing in the art of jewelry.]],
	level_range = {50, 50}, exp_worth = 2,
	rank = 3,
	size_category = 3,
	max_life = 150, life_rating = 17, fixed_rating = true,
	infravision = 10,
	stats = { str=15, dex=10, cun=12, mag=16, con=14 },
	move_others=true,
	knockback_immune = 1,
	teleport_immune = 1,

	open_door = true,

	resists = { all = 40 },

	autolevel = "caster",
	ai = "move_quest_limmir", ai_state = { },

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },

	resolvers.talents{
		[Talents.T_CHANT_OF_LIGHT]=5,
		[Talents.T_HYMN_OF_SHADOWS]=5,
	},
	resolvers.sustains_at_birth(),

	can_talk = "limmir-valley-moon",
	never_anger = true,
	can_craft = true,
	on_die = function(self, who)
		game.level.turn_counter = nil
		game.player:hasQuest("master-jeweler"):ritual_end()
	end,

	on_takehit = function(self, value, who)
		if (self.last_took_hit_cry and game.turn < self.last_took_hit_cry + 100 and (not who or who.type ~= "demon")) or not game.level.turn_counter then return value end
		self.last_took_hit_cry = game.turn

		game.bignews:say(90, "#VIOLET#利米尔受到攻击！保护他！")

		return value
	end,
}
