-- ToME - Tales of Maj'Eyal:
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

local base_newEntity = newEntity
function newEntity(t) t.tinker_category = "mechanical" return base_newEntity(t) end

local Talents = require "engine.interface.ActorTalents"
local Stats = require "engine.interface.ActorStats"
local DamageType = require "engine.DamageType"

local metals = {"iron", "steel", "dwarven steel", "stralite", "voratun"}

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_ROCKET_BOOTS"..i,
	name = metals[i].." rocket boots", image = "object/tinkers_rocket_boots_t5.png",
	on_slot = "FEET",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_ROCKET_BOOTS] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_HAND_CANNON"..i,
	name = metals[i].." hand cannon", image = "object/tinkers_hand_cannon_t5.png",
	on_slot = "HANDS",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_HAND_CANNON] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_WEAPON_AUTOMATON_1H"..i,
	name = metals[i].." 1H weapon automaton", image = "object/tinkers_weapon_automaton_t5.png",
	on_slot = "HANDS",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_WEAPON_AUTOMATON_1H] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_FATAL_ATTRACTOR"..i,
	name = metals[i].." fatal attractor", image = "object/tinkers_fatal_attractor_t5.png",
	on_slot = "HANDS",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_FATAL_ATTRACTOR] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_IRON_GRIP"..i,
	name = metals[i].." grip", image = "object/tinkers_iron_grip_t5.png",
	on_slot = "HANDS",
	material_level = i,
	object_tinker = {
		wielder = {
			disarm_immune = 0.5 + 0.1 * i,
			learn_talent = {[Talents.T_TINKER_IRON_GRIP] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_SPRING_GRAPPLE"..i,
	name = metals[i].." grapple", image = "object/tinkers_spring_grapple_t5.png",
	on_slot = "HANDS",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_SPRING_GRAPPLE] = i},
			show_gloves_combat=1,
		},
	},
}
end

newEntity{ base = "BASE_TINKER", define_as = "TINKER_POWER_ARMOUR5",
	slot = "BODY",
	power_source = {steam=true}, is_tinker = false,
	type = "armor", subtype="massive",
	add_name = " (#ARMOR#)",
	name = "Steam Powered Armour", unique = true,
	display = "[", color=colors.SLATE, image = "object/artifact/voratun_power_armour.png",
	moddable_tile = "special/upperbody_voratun_powerarmour",
	moddable_tile2 = "special/lowerbody_voratun_powerarmour",
	require = { stat = { str=60 }, talent = { {Talents.T_ARMOUR_TRAINING,3} }, },
	encumber = 22,
	metallic = true,
	desc = [[Using small steam engines and the miracles of the latest automation discoveries you are able to create Steam Powered Armour. A full plate armour that helps your movement and has intrinsic protection mechanisms.]],
	cost = 1200,
	material_level = 5,
	wielder = {
		suppress_steam_generator_straps = 1,
		inc_stats = { [Stats.STAT_STR] = 9, [Stats.STAT_DEX] = 6, },
		resists = {
			[DamageType.LIGHTNING] = 25,
		},
		max_steam = 10,
		combat_def = 23,
		combat_armor = 25,
		stun_immune = 0.5,
		combat_physresist = 55,
		fatigue = 12,
		learn_talent = {[Talents.T_TINKER_POWERED_ARMOUR] = 5},
	},

	set_list = { {"define_as", "STEAM_POWERED_BOOTS"}, {"define_as", "STEAM_POWERED_HELM"}, {"define_as", "STEAM_POWERED_GAUNTLETS"} },
	set_desc = { steamarmor =  "The more steam the better!" },
	on_set_complete = function(self, who)
		self:specialSetAdd({"wielder","combat_dam"}, 22)
		self:specialSetAdd({"wielder","combat_steampower"}, 22)
		self:specialSetAdd({"wielder","max_steam"}, 5)
		game.logSeen(who, "#GOLD#Your steam-powered boots, helm and gauntlets automatically connect to your steam-powered armour, enabling new functions.")
	end,
	on_set_broken = function(self, who)
		game.logPlayer(who, "#GOLD#Your steam-powered armor disconnects from the other pieces.")
	end,
}

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_SAW_PROJECTOR"..i,
	name = metals[i].." saw projector", image = "object/tinkers_saw_projector_t5.png",
	on_slot = "HANDS",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_PROJECT_SAW] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_KINETIC_STABILISER"..i,
	name = metals[i].." kinetic stabiliser", image = "object/tinkers_kinetic_stabiliser_t5.png",
	on_slot = "FEET",
	material_level = i,
	object_tinker = {
		wielder = {
			combat_physresist = 3*i,
			knockback_immune = 0.05*i,
			pin_immune = 0.05*i,
			teleport_immune = 1,
		},
	},
}
end
