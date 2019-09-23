-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2019 Nicolas Casalini
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

setAuto("subclass", false)
setAuto("subrace", false)

setStepNames{
	world = "Campaign",
	race = "Race Category",
	subrace = "Race",
	class = "Class Category",
	subclass = "Class",
}

newBirthDescriptor{
	type = "base",
	name = "base",
	desc = {
	},
	descriptor_choices =
	{
		difficulty =
		{
			Tutorial = "disallow",
		},
		world =
		{
			["Maj'Eyal"] = "allow",
			Infinite = "allow",
			Arena = "allow",
		},
		class =
		{
			-- Specific to some races
			None = "disallow",
		},
	},
	talents = {},
	experience = 1.0,
	body = { INVEN = 1000, QS_MAINHAND = 1, QS_OFFHAND = 1, MAINHAND = 1, OFFHAND = 1, FINGER = 2, NECK = 1, LITE = 1, BODY = 1, HEAD = 1, CLOAK = 1, HANDS = 1, BELT = 1, FEET = 1, TOOL = 1, QUIVER = 1, QS_QUIVER = 1 },

	copy = {
		-- Some basic stuff
		move_others = true,
		no_auto_resists = true, no_auto_saves = true,
		no_auto_high_stats = true,
		resists_cap = {all=70},
		keep_inven_on_death = true,
		can_change_level = true,
		can_change_zone = true,
		save_hotkeys = true,

		-- Mages are unheard of at first, nobody but them regenerates mana
		mana_rating = 6,
		mana_regen = 0,

		max_level = 50,
		money = 15,
		resolvers.equip{ id=true,
			{type="lite", subtype="lite", name="brass lantern", ignore_material_restriction=true, ego_chance=-1000},
		},
		make_tile = function(e)
			if not e.image then e.image = "player/"..e.descriptor.subrace:lower():gsub("[^a-z0-9_]", "_").."_"..e.descriptor.sex:lower():gsub("[^a-z0-9_]", "_")..".png" end
		end,
	},
	game_state = {
		force_town_respec = 1,
		rare_minimum_level = 8,  -- Player level rare NPCs start appearing, handled by the actor generator defined by zones
		random_boss_minimum_level = 10,  -- Player level random bosses above rare start spawning, handled by the actor generator typically defined by zones
		fixedboss_class_minimum_level = 10,  -- Player level fixed bosses can gain levels in bonus classes, handled in Actor.levelupClass
		default_fixedboss_class_level_rate = 0.5,  -- Default level rate of classes applied to fixedbosses, handled in NPC.addedToLevel
		default_fixedboss_class_start_level_pct = 0.8, -- Default % of level to use as start level if not explicitly defined, handled in NPC.addedToLevel
		
		--random_boss_adjust_fct = function(act) act.testRAF = true end,  -- Function to be applied to all randbosses after they're fully resolved and added to level

	}
}


--------------- Difficulties
newBirthDescriptor{
	type = "difficulty",
	name = "Tutorial",
	never_show = true,
	desc =
	{
		"#GOLD##{bold}#Tutorial mode",
		"#WHITE#Start with a simplified character and discover the game in a simple quest.#{normal}#",
		"All damage done to the player reduced by 20%",
		"All healing for the player increased by 10%",
		"No main game achievements possible.",
	},
	descriptor_choices =
	{
		race =
		{
			__ALL__ = "forbid",
			["Tutorial Human"] = "allow",
		},
		subrace =
		{
			__ALL__ = "forbid",
			["Tutorial Human"] = "allow",
		},
		class =
		{
			__ALL__ = "forbid",
			["Tutorial Adventurer"] = "allow",
		},
		subclass =
		{
			__ALL__ = "forbid",
			["Tutorial Adventurer"] = "allow",
		},
	},
	copy = {
		auto_id = 2,
		no_birth_levelup = true,
		infinite_lifes = 1,
		__game_difficulty = 1,
		__allow_rod_recall = false,
		__allow_transmo_chest = false,
		instakill_immune = 1,
	},
	game_state = {
		grab_online_event_forbid = true,
		always_learn_birth_talents = true,
		force_town_respec = false,
	},
}
newBirthDescriptor{
	type = "difficulty",
	name = "Easy",
	display_name = "Easier",
	selection_default = config.settings.tome.default_birth and config.settings.tome.default_birth.difficulty == "Easy",
	desc =
	{
		"#GOLD##{bold}#Easier mode#WHITE##{normal}#",
		"Provides an easier game experience.",
		"Use it if you feel uneasy tackling the harder modes.",
		"All damage done to the player decreased by 30%",
		"All healing for the player increased by 30%",
		"All detrimental status effects durations reduced by 50%",
		"Achievements are not granted.",
	},
	descriptor_choices =
	{
		race = { ["Tutorial Human"] = "forbid", },
		class = { ["Tutorial Adventurer"] = "forbid", },
	},
	copy = {
		instakill_immune = 1,
		__game_difficulty = 1,
	},
}
newBirthDescriptor{
	type = "difficulty",
	name = "Normal",
	selection_default = (config.settings.tome.default_birth and config.settings.tome.default_birth.difficulty == "Normal") or (not config.settings.tome.default_birth) or (config.settings.tome.default_birth and not config.settings.tome.default_birth.difficulty),
	desc =
	{
		"#GOLD##{bold}#Normal mode#WHITE##{normal}#",
		"Provides the normal level of challenges.",
		"Stairs can not be used for 2 turns after a kill.",
	},
	descriptor_choices =
	{
		race = { ["Tutorial Human"] = "forbid", },
		class = { ["Tutorial Adventurer"] = "forbid", },
	},
	copy = {
		instakill_immune = 1,
		__game_difficulty = 2,
	},
}
newBirthDescriptor{
	type = "difficulty",
	name = "Nightmare",
	selection_default = config.settings.tome.default_birth and config.settings.tome.default_birth.difficulty == "Nightmare",
	desc =
	{
		"#GOLD##{bold}#Nightmare mode#WHITE##{normal}#",
		"Unfair game setting",
		"All zone levels increased by 50% by the time Player reaches level 10",
		"All creature talent levels increased by 30%",
		"Unique (fixed) bosses advance in bonus classes 30% faster",		
		"All enemies have 10% more life",
		"Rare creatures are slightly more frequent",
		"Stairs can not be used for 3 turns after a kill.",
		"Player can earn Nightmare version of achievements if also playing in Roguelike or Adventure permadeath mode.",
	},
	descriptor_choices =
	{
		race = { ["Tutorial Human"] = "forbid", },
		class = { ["Tutorial Adventurer"] = "forbid", },
	},
	copy = {
		instakill_immune = 1,
		__game_difficulty = 3,
	},
	game_state = {
		default_random_rare_chance = 15,
		
		difficulty_level_mult = 1.5,  -- Level multiplier for Zone.level_range, handled in Game.applyDifficulty
		difficulty_level_add = 0,  -- Flat value added to Zone.level_range, handled in Game.applyDifficulty 

		difficulty_talent_mult = 1.3,  -- Talent level multiplier for non-summoned NPC talents and base (non-autoclass) fixedboss talents, handled in NPC.addedToLevel
		difficulty_life_mult = 1.1,  -- Max life multiplier for hostile non-summoned NPCs, handled in NPC.addedToLevel
		fixedboss_class_level_rate_mult = 1.3,  -- Multiplier for auto_classes level rates, handled in Actor.levelupClass
	},
}
newBirthDescriptor{
	type = "difficulty",
	name = "Insane",
	locked = function() return profile.mod.allow_build.difficulty_insane end,
	locked_desc = "Easy is for the weak! Normal is for the weak! Nightmare is too easy! Bring on the true pain!",
	selection_default = config.settings.tome.default_birth and config.settings.tome.default_birth.difficulty == "Insane",
	desc =
	{
		"#GOLD##{bold}#Insane mode#WHITE##{normal}#",
		"Similar rules to Nightmare, but with more random bosses!",
		"All zone levels increased by 50% + 1 by the time Player reaches level 10",
		"All creature talent levels increased by 80%",
		"Unique (fixed) bosses advance in bonus classes 80% faster",
		"All enemies have 20% more life",
		"Rare creatures are far more frequent and random bosses start to appear",
		"Stairs can not be used for 5 turns after a kill.",
		"Player can earn Insane version of achievements if also playing in Roguelike or Adventure permadeath mode.",
	},
	descriptor_choices =
	{
		race = { ["Tutorial Human"] = "forbid", },
		class = { ["Tutorial Adventurer"] = "forbid", },
	},
	copy = {
		instakill_immune = 1,
		__game_difficulty = 4,
	},
	game_state = {
		default_random_rare_chance = 3,
		default_random_boss_chance = 20,

		difficulty_level_mult = 1.5,  -- Level multiplier for Zone.level_range, handled in Game.applyDifficulty
		difficulty_level_add = 1,  -- Flat value added to Zone.level_range, handled in Game.applyDifficulty 

		difficulty_talent_mult = 1.8,  -- Talent level multiplier for non-summoned NPC talents and base (non-autoclass) fixedboss talents, handled in NPC.addedToLevel
		difficulty_life_mult = 1.2,  -- Max life multiplier for hostile non-summoned NPCs, handled in NPC.addedToLevel
		fixedboss_class_level_rate_mult = 1.8,  -- Multiplier for auto_classes level rates, handled in Actor.levelupClass
	},
}
newBirthDescriptor{
	type = "difficulty",
	name = "Madness",
	locked = function() return profile.mod.allow_build.difficulty_madness end,
	locked_desc = "Insane is for the weak! Bring on the true mind-shattering experience!",
	selection_default = config.settings.tome.default_birth and config.settings.tome.default_birth.difficulty == "Madness",
	desc =
	{
		"#GOLD##{bold}#Madness mode#WHITE##{normal}#",
		"Absolutely unfair game setting.  You are really mentally ill and wish to get worse to play this mode!",
		"All zone levels increased by 150% + 2 by the time Player reaches level 10",
		"All creature talent levels increased by 170%",
		"Unique (fixed) bosses advance in bonus classes 170% faster",
		"All enemies have 200% more life",
		"Rare creatures are far more frequent and random bosses start to appear",
		"Stairs can not be used for 9 turns after a kill.",
		"Player is being hunted! Randomly all foes in a radius will get a feeling of where she/he is",
		"Player can earn Madness version of achievements if also playing in Roguelike or Adventure permadeath mode.",
	},
	descriptor_choices =
	{
		race = { ["Tutorial Human"] = "forbid", },
		class = { ["Tutorial Adventurer"] = "forbid", },
	},
	talents = {
		[ActorTalents.T_HUNTED_PLAYER] = 1,
	},
	copy = {
		instakill_immune = 1,
		__game_difficulty = 5,
	},
	game_state = {
		default_random_rare_chance = 3,
		default_random_boss_chance = 20,

		difficulty_level_mult = 2.5,  -- Level multiplier for Zone.level_range, handled in Game.applyDifficulty
		difficulty_level_add = 2,  -- Flat value added to Zone.level_range, handled in Game.applyDifficulty 

		difficulty_talent_mult = 2.7,  -- Talent level multiplier for non-summoned NPC talents and base (non-autoclass) fixedboss talents, handled in NPC.addedToLevel
		difficulty_life_mult = 3,  -- Max life multiplier for hostile non-summoned NPCs, handled in NPC.addedToLevel
		fixedboss_class_level_rate_mult = 2.7,  -- Multiplier for auto_classes level rates, handled in Actor.levelupClass
	},
}

--------------- Permadeath
newBirthDescriptor{
	type = "permadeath",
	name = "Exploration",
	locked = function(birther) return birther:isDonator() end,
	locked_desc = "Exploration mode: Infinite lives (donator feature)",
	locked_select = function(birther) birther:selectExplorationNoDonations() end,
	selection_default = config.settings.tome.default_birth and config.settings.tome.default_birth.permadeath == "Exploration",
	desc =
	{
		"#GOLD##{bold}#Exploration mode#WHITE#",
		"Provides you with infinite lives.#{normal}#",
		"This is not the way the game is meant to be played, but it allows you to have a more forgiving experience.",
		"Remember though that dying is an integral part of the game and helps you become a better player.",
		"Exploration version of achievements will be granted in this mode.",
		"Full talent respec is always available.",
	},
	game_state = {
		force_town_respec = false,
	},
	copy = {
		infinite_respec = 1,
		infinite_lifes = 1,
	},
}
newBirthDescriptor{
	type = "permadeath",
	name = "Adventure",
	selection_default = (not config.settings.tome.default_birth) or (config.settings.tome.default_birth and config.settings.tome.default_birth.permadeath == "Adventure"),
	desc =
	{
		"#GOLD##{bold}#Adventure mode#WHITE#",
		"Provides you with limited extra lives.",
		"Use it if you want normal playing conditions but do not feel ready for just one life.#{normal}#",
		"At level 1,2,5,7,14,24,35 get one more 'life' that allows you to resurrect at the start of the level.",
	},
	copy = {
		easy_mode_lifes = 1,
	},
}
newBirthDescriptor{
	type = "permadeath",
	name = "Roguelike",
	selection_default = config.settings.tome.default_birth and config.settings.tome.default_birth.permadeath == "Roguelike",
	desc =
	{
		"#GOLD##{bold}#Roguelike mode#WHITE#",
		"Provides the closer experience to 'classic' roguelike games.",
		"You will only have one life; you *ARE* your character.#{normal}#",
		"Only one life, unless ways to self-resurrect are found in-game.",
	},
}


-- Worlds
load("/data/birth/worlds.lua")

-- Races
load("/data/birth/races/tutorial.lua")
load("/data/birth/races/human.lua")
load("/data/birth/races/elf.lua")
load("/data/birth/races/halfling.lua")
load("/data/birth/races/dwarf.lua")
load("/data/birth/races/yeek.lua")
load("/data/birth/races/giant.lua")
load("/data/birth/races/undead.lua")
load("/data/birth/races/construct.lua")

-- Sexes
load("/data/birth/sexes.lua")

-- Classes
load("/data/birth/classes/tutorial.lua")
load("/data/birth/classes/warrior.lua")
load("/data/birth/classes/rogue.lua")
load("/data/birth/classes/mage.lua")
load("/data/birth/classes/wilder.lua")
load("/data/birth/classes/celestial.lua")
load("/data/birth/classes/corrupted.lua")
load("/data/birth/classes/afflicted.lua")
load("/data/birth/classes/chronomancer.lua")
load("/data/birth/classes/psionic.lua")
load("/data/birth/classes/adventurer.lua")
load("/data/birth/classes/none.lua")
