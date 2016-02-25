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
function newEntity(t) t.tinker_category = "explosive" return base_newEntity(t) end

local Talents = require "engine.interface.ActorTalents"
local Stats = require "engine.interface.ActorStats"
local DamageType = require "engine.DamageType"

local simple = {"crude", "good", "well-made", "mastercraft", "perfect"}

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_THUNDERCLAP_COATING"..i,
	name = simple[i].." thunderclap coating", image = "object/tinkers_thunderclap_coating_t5.png",
	on_type = "weapon",
	material_level = i,
	special_desc = function(self) return "Strikes can trigger a thunderclap that damages and repel foes." end,
	object_tinker = {
		combat = {
			burst_on_hit = {
				[DamageType.THUNDERCLAP_COATING] = (i+1)*i*(8-i),
			},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_HEADLAMP"..i,
	name = simple[i].." head lamp", image = "object/tinkers_headlamp_t5.png",
	on_slot = "HEAD",
	material_level = i,
	object_tinker = {
		wielder = {
			lite = 2+i,
			combat_atk = i * i,
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_ABLATIVE_ARMOUR"..i,
	name = simple[i].." ablative armour", image = "object/tinkers_ablative_armour_t5.png",
	on_slot = "BODY",
	material_level = i,
	object_tinker = {
		wielder = {
			combat_armor = 3*i,
			ignore_direct_crits = 7*i,
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_INCENDIARY_GROOVE"..i,
	name = simple[i].." incendiary groove", image = "object/tinkers_incendiary_groove_t5.png",
	on_type = "weapon",
	material_level = i,
	special_desc = function(self) return "Deals fire damage and ignites the ground." end,
	on_tinker = function(self, o, who)
		local DamageType = require "engine.DamageType"
	
		if not o.combat then return true end
		o.combat.incendiary_groove_ml = self.material_level
		o.combat.incendiary_groove_damage = function(self, o, who)
			return math.ceil( who:combatMLSteamDamage(o.combat.incendiary_groove_ml, 15, 90) )
		end
		o.combat.tinker_uid = "incendiary_groove" .. self.uid
		
		o:orcsWeaponAddOnEffect("special_on_hit", "incendiary_groove", {desc="burn your foe dealing " .. o.combat.incendiary_groove_damage(self, o, who) .. " damage and igniting the ground for 4 turns" , fct=function(combat, who, target)
			if who.turn_procs[combat.tinker_uid or "incendiary_groove"] then return end
			local DamageType = require "engine.DamageType"
			local tg = {type="hit", start_x=target.x, start_y=target.y}
			local dam = who:steamCrit(who:combatMLSteamDamage(combat.incendiary_groove_ml, 15, 90))
			
			who:project(tg, target.x, target.y, DamageType.FIRE, dam)
			game.level.map:addEffect(who, target.x, target.y, 4, engine.DamageType.FIRE, dam/4, 2, 5, nil, {type="inferno"}, nil, true)
			who.turn_procs[combat.tinker_uid or "incendiary_groove"] = true
		end})
	end,
	on_untinker = function(self, o, who)
		if not o.combat then return true end
		o:orcsWeaponRemoveOnEffect("special_on_hit", "incendiary_groove")
		o.combat.incendiary_groove_ml = nil
		o.combat.incendiary_groove_damage = nil
		o.combat.tinker_uid = nil
	end,
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_THUNDER_GRENADE"..i,
	name = simple[i].." thunder grenade", image = "object/tinkers_thunder_grenade_t5.png",
	on_slot = "BELT",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_THUNDER_GRENADE] = i},
		},
	},
}
end

newEntity{ base = "BASE_TINKER", define_as = "TINKER_GUN_PAYLOAD5", --Explosives Capstone Item
	slot = "MAINHAND", offslot = "OFFHAND",
	type = "weapon", subtype="steamgun",
	display = "}", color=colors.UMBER, image = "object/artifact/payload.png",
	moddable_tile = "%s_steamgun_05",
	moddable_tile_back = "%s_steamgun_back",
	power_source = {steam=true}, is_tinker = false,
	name = "Payload",
	unided_name = "absurdly large gun", unique = true,
	desc = [["I never really liked that village anyway." - Charlta, Mad Inventor]],
	require = { stat = { dex=32 }, },
	encumber = 6,
	cost = 900,
	rarity = false,
	material_level = 5,

	archery_kind = "steamgun",
	archery = "sling", -- Same ammunition as slings
	require = { talent = { Talents.T_SHOOT, Talents.T_STEAM_POOL}, },
	proj_image = resolvers.image_material("shot_s", "metal"),

	combat = {
		talented = "steamgun", travel_speed=6, physspeed = 1, accuracy_effect="mace", sound = "actions/dual-steamgun", sound_miss = "actions/dual-steamgun", use_resources={steam = 2},
		range = 7,
		apr = 15,
		dam_mult = 1.2,
		special_on_crit = {desc="Boom.", on_kill=1, fct=function(combat, who, target)
			local tg = {type="ball", range=0, radius=5, friendlyfire=false, start_x=target.x, start_y=target.y}
			local damage = 100 + who:getCun() * 2
			local grids = who:project(tg, target.x, target.y, engine.DamageType.FIREBURN, damage)
			game.level.map:particleEmitter(target.x, target.y, tg.radius, "ball_fire", {radius=2})
			game.level.map:particleEmitter(target.x, target.y, tg.radius, "ball_fire", {radius=3})
			game.level.map:particleEmitter(target.x, target.y, tg.radius, "ball_fire", {radius=4})
			game.level.map:particleEmitter(target.x, target.y, tg.radius, "ball_fire", {radius=5})
			game.level.map:addEffect(who,
				target.x, target.y, 5,
				engine.DamageType.FIRE, damage/10,
				5,
				5, nil,
				{type="inferno"},
				nil, false
			)
		end},
	},
}

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_EXPLOSIVE_SHELL"..i,
	name = simple[i].." explosive shell", image = "object/tinkers_spring_grapple_t5.png",
	on_slot = "QUIVER",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_EXPLOSIVE_SHELL] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_FLARE_SHELL"..i,
	name = simple[i].." flare shell", image = "object/tinkers_spring_grapple_t5.png",
	on_slot = "QUIVER",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_FLARE_SHELL] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_INCENDIARY_SHELL"..i,
	name = simple[i].." incendiary shell", image = "object/tinkers_spring_grapple_t5.png",
	on_slot = "QUIVER",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_INCENDIARY_SHELL] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_SOLID_SHELL"..i,
	name = simple[i].." solid shell", image = "object/tinkers_solid_shell_t5.png",
	on_slot = "QUIVER",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_SOLID_SHELL] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_IMPALER_SHELL"..i,
	name = simple[i].." impaler shell", image = "object/tinkers_spring_grapple_t5.png",
	on_slot = "QUIVER",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_IMPALER_SHELL] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_SAW_SHELL"..i,
	name = simple[i].." saw shell", image = "object/tinkers_saw_shell_t5.png",
	on_slot = "QUIVER",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_SAW_SHELL] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_HOOK_SHELL"..i,
	name = simple[i].." hook shell", image = "object/tinkers_hook_shell_t5.png",
	on_slot = "QUIVER",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_HOOK_SHELL] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_MAGNETIC_SHELL"..i,
	name = simple[i].." magnetic shell", image = "object/tinkers_magnetic_shell_t5.png",
	on_slot = "QUIVER",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_MAGNETIC_SHELL] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_VOLTAIC_SHELL"..i,
	name = simple[i].." voltaic shell", image = "object/tinkers_voltaic_shell_t5.png",
	on_slot = "QUIVER",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_VOLTAIC_SHELL] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_ANTIMAGIC_SHELL"..i,
	name = simple[i].." antimagic shell", image = "object/tinkers_antimagic_shell_t5.png",
	on_slot = "QUIVER",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_ANTIMAGIC_SHELL] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_BOTANICAL_SHELL"..i,
	name = simple[i].." botanical shell", image = "object/tinkers_botanical_shell_t5.png",
	on_slot = "QUIVER",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_BOTANICAL_SHELL] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_CORROSIVE_SHELL"..i,
	name = simple[i].." corrosive shell", image = "object/tinkers_corrosive_shell_t5.png",
	on_slot = "QUIVER",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_CORROSIVE_SHELL] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_TOXIC_SHELL"..i,
	name = simple[i].." toxic shell", image = "object/tinkers_toxic_shell_t5.png",
	on_slot = "QUIVER",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_TOXIC_SHELL] = i},
		},
	},
}
end

