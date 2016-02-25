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
function newEntity(t) t.tinker_category = "smith" return base_newEntity(t) end

local Talents = require "engine.interface.ActorTalents"
local Stats = require "engine.interface.ActorStats"
local DamageType = require "engine.DamageType"

local metals = {"iron", "steel", "dwarven steel", "stralite", "voratun"}
local simple = {"crude", "good", "well-made", "mastercraft", "perfect"}

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_FOCUS_LEN"..i,
	name = simple[i].." focus lens", image = "object/tinkers_focus_len_t5.png",
	on_slot = "HEAD",
	material_level = i,
	object_tinker = {
		wielder = {
			sight = math.ceil(i/2),
			infravision = 4 + i,
			see_stealth = i * 5,
			see_invisible = i * 5,
			blind_fight = i >= 4 and 1 or nil,
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_TOXIC_CANNISTER_LAUNCHER"..i,
	name = metals[i].." toxic cannister launcher", image = "object/tinkers_toxic_cannister_launcher_t5.png",
	on_slot = "HANDS",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_TOXIC_CANNISTER_LAUNCHER] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_VIRAL_NEEDLEGUN"..i,
	name = metals[i].." viral needlegun", image = "object/tinkers_viral_needlegun_t5.png",
	on_slot = "HANDS",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_VIRAL_NEEDLEGUN] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_RAZOR_EDGE"..i,
	name = metals[i].." razor edge", image = "object/tinkers_razor_edge_t5.png",
	on_type = "weapon",
	material_level = i,
	object_tinker = {
		combat = {
			apr = i*4,
			physcrit = i * 4,
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_ARMOUR_REINFORCEMENT"..i,
	name = metals[i].." armour reinforcement", image = "object/tinkers_armour_reinforcement_t5.png",
	on_slot = "BODY",
	material_level = i,
	object_tinker = {
		wielder = {
			combat_armor = 2*i,
			combat_armor_hardiness = 20, -- Doesn't need to scale
			fatigue = 6-i,
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_CRYSTAL_EDGE"..i,
	name = metals[i].." crystal edge", image = "object/tinkers_crystal_edge_t5.png",
	on_type = "weapon",
	material_level = i,
	special_desc = function(self) return "Deals high light damage and increases critical multiplier." end,
	object_tinker = {
		wielder = {
			combat_critical_power = i*3,
		},
	},
	on_tinker = function(self, o, who)
		local DamageType = require "engine.DamageType"
	
		if not o.combat then return true end
		o.combat.crystal_edge_ml = self.material_level
		o.combat.crystal_edge_damage = function(self, o, who)
			return math.ceil( who:combatMLSteamDamage(o.combat.crystal_edge_ml, 20, 140) )
		end
		o.combat.tinker_uid = "crystal_edge" .. self.uid
		
		o:orcsWeaponAddOnEffect("special_on_hit", "crystal_edge", {desc="flashes light on your target dealing " .. o.combat.crystal_edge_damage(self, o, who) .. " damage" , fct=function(combat, who, target)
			if who.turn_procs[combat.tinker_uid or "crystal_edge"] then return end
			local DamageType = require "engine.DamageType"
			local tg = {type="hit", start_x=target.x, start_y=target.y}
			local dam = who:steamCrit(who:combatMLSteamDamage(combat.crystal_edge_ml, 20, 140))
			
			who:project(tg, target.x, target.y, DamageType.LIGHT, dam)
			who.turn_procs[combat.tinker_uid or "crystal_edge"] = true
		end})
	end,
	on_untinker = function(self, o, who)
		if not o.combat then return true end
		o:orcsWeaponRemoveOnEffect("special_on_hit", "crystal_edge")
		o.combat.crystal_edge_ml = nil
		o.combat.crystal_edge_damage = nil
		o.combat.tinker_uid = nil
	end,
}
end

-- Note, this makes stat swapping very easy.  Probably for the best as its less annoying than Heroism.
for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_CRYSTAL_PLATING"..i,
	name = metals[i].." crystal plating", image = "object/tinkers_crystal_plating_t5.png",
	on_slot = "BODY",
	material_level = i,
	object_tinker = {
		wielder = {
			inc_stats = { [Stats.STAT_STR] = 2*i, [Stats.STAT_MAG] = 2*i, [Stats.STAT_DEX] = 2*i, [Stats.STAT_CUN] = 2*i, [Stats.STAT_CON] = 2*i },
		},
	},
}
end

newEntity{
	define_as = "TINKER_HANDS_CREATION5",
	slot = "HANDS",
	type = "armor", subtype="hands",
	add_name = " (#ARMOR#)",
	display = "[", color=colors.SLATE,
	image = "object/artifact/hands_of_creation.png",
	moddable_tile = resolvers.moddable_tile("gauntlets"),
	power_source = {steam=true}, is_tinker = false,
	name = "Hands of Creation",
	unided_name = "plated gauntlets", unique = true,
	desc = [[From your hands have been wrought incredible works. Your works have been forged in fire, and so have you.]],
	--require = { talent = { Talents.T_ARMOUR_TRAINING }, },
	encumber = 1.5,
	cost = 900,
	material_level=5,
	metallic = true,
	special_desc = function(self) return "On landing any melee attack, release a fiery shockwave, dealing fire and physical damage each equal to your steampower in a cone from the target of radius 3." end,
	wielder={
		max_encumber = 20,
		inc_stats = { [Stats.STAT_STR] = 7,[Stats.STAT_CON] = 7, },
		combat_dam=20,
		combat_steampower=20,
		combat_armor = 10,
		resists_pen = {
			[DamageType.FIRE] = 20,
			[DamageType.PHYSICAL] = 20,
		},
		combat = {
			accuracy_effect = "mace",
			dam = 35,
			apr = 10,
			physcrit = 10,
			physspeed = 0.1,
			dammod = {dex=0.4, str=-0.6, cun=0.4 },
			melee_project={[DamageType.FIRE] = 20},
			damrange = 0.3,
		},
	},
	callbackOnMeleeAttack = function(self, who, target, hitted, crit, weapon)
		if not hitted then return end
		who.turn_procs.hands_creation = (who.turn_procs.hands_creation or 0) + 1
		local a = math.atan2(target.y - who.y, target.x - who.x)
		local dx, dy = target.x + math.cos(a) * 100, target.y + math.sin(a) * 100
		local tg = {type="cone", range=0, radius=3, friendlyfire=false, start_x=target.x, start_y=target.y}
		local damage = who:combatSteampower() / who.turn_procs.hands_creation
		local grids = who:project(tg, target.x, target.y, engine.DamageType.PHYSICAL, damage)
		local grids = who:project(tg, target.x, target.y, engine.DamageType.FIRE, damage)
		game.level.map:particleEmitter(who.x, who.y, tg.radius, "breath_fire", {radius=3, tx=target.x-who.x, ty=target.y-who.y})
		return
	end,
}

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_SPIKE_ATTACHMENT"..i,
	name = metals[i].." spike attachment", image = "object/tinkers_spike_attachment_t5.png",
	on_slot = "BODY",
	material_level = i,
	object_tinker = {
		wielder = {
			fatigue = 1,
			combat_armor = 3*i,
			on_melee_hit={[DamageType.PHYSICAL] = 7*i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_SILVER_FILIGREE"..i,
	name = metals[i].." silver filigree", image = "object/tinkers_silver_filigree_t5.png",
	on_type = "weapon",
	material_level = i,
	object_tinker = {
		combat = {
			inc_damage_type = {horror=7*i, undead=7*i, demon=7*i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_BACK_SUPPORT"..i,
	name = metals[i].." back support", image = "object/tinkers_back_support_t5.png",
	on_slot = "BELT",
	material_level = i,
	object_tinker = {
		wielder = {
			fatigue = -4*i,
			max_encumber = 10*i,
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_GROUNDING_STRAP"..i,
	name = metals[i].." grounding strap", image = "object/tinkers_grounding_strap_t5.png",
	on_slot = "CLOAK",
	material_level = i,
	object_tinker = {
		wielder = {
			stun_immune = 0.1*i,
			resists = {[DamageType.LIGHTNING] = 6*i},
		},
	},
}
end
