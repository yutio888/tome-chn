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
function newEntity(t) t.tinker_category = "chemistry" return base_newEntity(t) end

local Talents = require "engine.interface.ActorTalents"
local Stats = require "engine.interface.ActorStats"
local DamageType = require "engine.DamageType"

local simple = {"crude", "good", "well-made", "mastercraft", "perfect"}

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_POISON_GROOVE"..i,
	name = simple[i].." poison groove", image = "object/tinkers_poison_groove_t"..i..".png",
	on_type = "weapon",
	material_level = i,
	special_desc = function(self) return "Deals stacking poison damage." end,
	on_tinker = function(self, o, who)
		local DamageType = require "engine.DamageType"
	
		if not o.combat then return true end
		o.combat.poison_groove_ml = self.material_level
		o.combat.poison_groove_damage = function(self, o, who)
			return math.ceil( who:combatMLSteamDamage(o.combat.poison_groove_ml, 15, 60) )
		end
		
		o:orcsWeaponAddOnEffect("special_on_hit", "poison_groove", {desc="applies a stacking poison dealing " .. o.combat.poison_groove_damage(self, o, who) .. " damage per turn" , fct=function(combat, who, target)
			local DamageType = require "engine.DamageType"
			local tg = {type="hit", start_x=target.x, start_y=target.y}
			local dam = who:steamCrit(who:combatMLSteamDamage(combat.poison_groove_ml, 15, 60))
			who:project(tg, target.x, target.y, DamageType.POISON, dam)
		end})
	end,
	on_untinker = function(self, o, who)
		if not o.combat then return true end
		o:orcsWeaponRemoveOnEffect("special_on_hit", "poison_groove")
		o.combat.poison_groove_ml = nil
		o.combat.poison_groove_damage = nil
	end,
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_VIRAL_INJECTOR"..i,
	name = simple[i].." viral injector", image = "object/tinkers_viral_injector_t"..i..".png",
	on_type = "weapon",
	material_level = i,
	special_desc = function(self) return "Infects targets with a stat reducing disease." end,
	on_tinker = function(self, o, who)
		local DamageType = require "engine.DamageType"
	
		if not o.combat then return true end
		o.combat.viral_injector_ml = self.material_level
		o.combat.viral_injector_damage = function(self, o, who)
			return math.ceil(who:combatMLSteamDamage(o.combat.viral_injector_ml, 30, 120) )
		end
		o.combat.tinker_uid = "viral_injector" .. self.uid
		
		o:orcsWeaponAddOnEffect("special_on_hit", "viral_injector", {desc="injects a simple virus dealing " .. o.combat.viral_injector_damage(self, o, who) .. " blight damage on hit and lowering the victims highest stat", fct=function(combat, who, target)
			if who.turn_procs[combat.tinker_uid or "viral_injector"] then return end
			local DamageType = require "engine.DamageType"
			local tg = {type="hit", start_x=target.x, start_y=target.y}
			local dam = who:steamCrit(who:combatMLSteamDamage(combat.viral_injector_ml, 30, 120)) / 6
			local check = math.max(who:combatAttack(), who:combatSpellpower(), who:combatMindpower(), who:combatSteampower())
			local stat_reduction = combat.viral_injector_ml * 5
			
			who:project(tg, target.x, target.y, DamageType.BLIGHT, dam)
			target:setEffect(target.EFF_TINKER_VIRAL, 6, {src = who, num_stats = 1, power = stat_reduction, dam = dam, no_ct_effect = true, apply_power = check })
			who.turn_procs[combat.tinker_uid or "viral_injector"] = true
		end})

	end,
	on_untinker = function(self, o, who)
		if not o.combat then return true end
		o:orcsWeaponRemoveOnEffect("special_on_hit", "viral_injector")
		o.combat.viral_injector_ml = nil
		o.combat.viral_injector_damage = nil
		o.combat.tinker_uid = nil
	end,
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_WINTERCHILL_EDGE"..i,
	name = simple[i].." winterchill edge", image = "object/tinkers_winterchill_edge_t"..i..".png",
	on_type = "weapon",
	material_level = i,
	special_desc = function(self) return "Deals cold damage and slows." end,
	on_tinker = function(self, o, who)
		local DamageType = require "engine.DamageType"
	
		if not o.combat then return true end
		o.combat.winterchill_edge_ml = self.material_level
		o.combat.winterchill_edge_damage = function(self, o, who)
			return math.ceil( who:combatMLSteamDamage(o.combat.winterchill_edge_ml, 10, 50) )
		end
		o.combat.tinker_uid = "winterchill_edge" .. self.uid
		
		o:orcsWeaponAddOnEffect("special_on_hit", "winterchill_edge", {desc="chills your foe dealing " .. o.combat.winterchill_edge_damage(self, o, who) .. " damage and slowing them by one tenth of a turn" , fct=function(combat, who, target)
			if who.turn_procs[combat.tinker_uid or "winterchill_edge"] then return end
			local DamageType = require "engine.DamageType"
			local tg = {type="hit", start_x=target.x, start_y=target.y}
			local dam = who:steamCrit(who:combatMLSteamDamage(combat.winterchill_edge_ml, 10, 50))

			local energyDrain = (game.energy_to_act * 0.1)	
			target.energy.value = target.energy.value - energyDrain

			who:project(tg, target.x, target.y, DamageType.COLD, dam)
			who.turn_procs[combat.tinker_uid or "winterchill_edge"] = true
		end})

	end,
	on_untinker = function(self, o, who)
		if not o.combat then return true end
		o:orcsWeaponRemoveOnEffect("special_on_hit", "winterchill_edge")
		o.combat.winterchill_edge_ml = nil
		o.combat.winterchill_edge_damage = nil
		o.combat.tinker_uid = nil
	end,
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_ACID_GROOVE"..i,
	name = simple[i].." acid groove", image = "object/tinkers_acid_groove_t"..i..".png",
	on_type = "weapon",
	material_level = i,
	special_desc = function(self) return "Deals acid damage that also reduces armour." end,
	on_tinker = function(self, o, who)
		local DamageType = require "engine.DamageType"
		if not o.combat then return true end
		
		o.combat.acid_groove_ml = self.material_level
		o.combat.acid_groove_damage = function(self, o, who)
			return math.ceil( who:combatMLSteamDamage(o.combat.acid_groove_ml, 15, 90) )
		end
		o.combat.tinker_uid = "acid_groove" .. self.uid

		o:orcsWeaponAddOnEffect("special_on_hit", "acid_groove", {desc="splashes acid on your target dealing " .. o.combat.acid_groove_damage(self, o, who) .. " damage and reducing their armor" , fct=function(combat, who, target)
			if who.turn_procs[combat.tinker_uid or "acid_groove"] then return end

			local DamageType = require "engine.DamageType"
			local tg = {type="hit", start_x=target.x, start_y=target.y}
			local dam = who:steamCrit(who:combatMLSteamDamage(combat.acid_groove_ml, 15, 90))
			local armor = combat.acid_groove_ml*5
			local check = math.max(who:combatAttack(), who:combatSpellpower(), who:combatMindpower(), who:combatSteampower())
			who.turn_procs[combat.tinker_uid or "acid_groove"] = true

			target:setEffect(target.EFF_CORRODE, 5, {atk=0, armor=armor, defense=0, apply_power=check, no_ct_effect = true})
			who:project(tg, target.x, target.y, DamageType.ACID, dam)
				end})
	end,
	on_untinker = function(self, o, who)
		if not o.combat then return true end
		o:orcsWeaponRemoveOnEffect("special_on_hit", "acid_groove")
		o.combat.acid_groove_ml = nil
		o.combat.acid_groove_damage = nil
		o.combat.tinker_uid = nil
	end,
}
end

newEntity{ base = "BASE_TINKER", define_as = "TINKER_BRAIN_CAP4",
	name = "Brain Cap", unique = true, iamge = "object/tinkers_mind_cap_t5.png",
	on_slot = "HEAD",
	material_level = 4,
	object_tinker = {
		wielder = {
			combat_mentalresist = 20,
			resists = {[DamageType.MIND] = 35},
			learn_talent = {[Talents.T_TINKER_ARCANE_DISRUPTION_WAVE] = 4},
		},
	},
}

newEntity{ base = "BASE_TINKER", define_as = "TINKER_BRAIN_FLARE4",
	name = "Brain Flare", unique = true, image = "object/tinkers_mind_flare_t5.png",
	on_slot = "HEAD",
	material_level = 4,
	object_tinker = {
		wielder = {
			combat_mentalresist = 20,
			resists = {[DamageType.MIND] = 35},
			learn_talent = {[Talents.T_TINKER_YEEK_WILL] = 4},
		},
	},
}

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_WATERPROOF_COATING"..i,
	name = simple[i].." waterproof coating", image = "object/tinkers_waterproof_coating_t5.png",
	on_slot = "CLOAK",
	material_level = i,
	object_tinker = {
		wielder = {
			resists = {[DamageType.COLD] = 5*i, [DamageType.NATURE] = 5*i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_FIREPROOF_COATING"..i,
	name = simple[i].." fireproof coating", image = "object/tinkers_fireproof_coating_t5.png",
	on_slot = "CLOAK",
	material_level = i,
	object_tinker = {
		wielder = {
			resists = {[DamageType.FIRE] = 5*i, [DamageType.LIGHT] = 5*i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_FLASH_POWDER"..i,
	name = simple[i].." flash powder", image = "object/tinkers_flash_powder_t5.png",
	on_slot = "HANDS",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_FLASH_POWDER] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_ITCHING_POWDER"..i,
	name = simple[i].." itching powder", image = "object/tinkers_itching_powder_t5.png",
	on_slot = "HANDS",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_ITCHING_POWDER] = i},
		},
	},
}
end

newEntity{
	slot = "CLOAK", define_as = "TINKER_ROGUE_GALLERY5",
	type = "armor", subtype="cloak",
	add_name = " (#ARMOR#)",
	display = "(", color=colors.UMBER, image = "object/artifact/rogues_gallery.png",
	moddable_tile = resolvers.moddable_tile("cloak"),
	encumber = 2, unique=true,
	power_source = {steam=true},
	unided_name = "action packed cloak",
	name = "Rogue's Gallery",
	desc = [[Lined with reactive mechanisms, this cloak is equipped for any situation you might possibly encounter, and several you couldn't possibly encounter!]],
	color = colors.GREEN,
	smoke_recharge=0, poison_charge = 0,
	material_level = 5,
	level_range = {40, 50},
	sentient=true,
	use_no_energy=true,
	special_desc = function(self) return "On falling below 20% of your max life, releases a cloud of smoke, confusing nearby enemies and giving you stealth and a chance to avoid incoming damage for 5 turns." end,
	wielder = {
		inc_stats = { [Stats.STAT_CUN] = 10},
		resists = {
			[DamageType.NATURE] = 20,
		},
		combat_def=12,
	},
	max_power = 12, power_regen = 1,
	use_power = {
		name = function(self, who) return "cause the next damage you deal to inflict crippling poison (does not recharge until used), dealing minor poison damage and causing your target to have a 10% chance to fail all talents" end,
		power = 12,
		use = function(self, who)
			self.poison_charge = 1
			return {id=true, used=true}
		end,
	},
	callbackOnTakeDamage = function(self, who, src, x, y, type, dam, state)
		if not self.worn_by or self.smoke_recharge > 0 then return end
		if (who.life - dam)/who.max_life >=0.2 then return end
		game:onTickEnd(function() -- make sure all damage has been resolved
			if who.life/who.max_life < 0.2 then
				local Talents = require "engine.interface.ActorTalents"
				game.level.map:addEffect(who,
				who.x, who.y, 5,
				engine.DamageType.SMOKE_CLOUD, {dam=50,chance=10,stealth=who:combatSteampower()},
				3,
				5, nil,
				{type="creeping_dark"},
				nil, true
				)
				self.smoke_recharge = 15
				end
			end
		)
	end,
	on_wear = function(self, who)
		self.worn_by = who
	end,
	on_takeoff = function(self, who)
		self.worn_by = nil
	end,
	act = function(self)
		self:useEnergy()
		if self.poison_charge == 0 then
		self:regenPower()
		end
		
		local who=self.worn_by --Make sure you can actually act!
		if not self.worn_by then return end
		if game.level and not game.level:hasEntity(self.worn_by) and not self.worn_by.player then self.worn_by = nil return end
		if self.worn_by:attr("dead") then return end
		if self.smoke_recharge > 0 then
		self.smoke_recharge = self.smoke_recharge - 1
		end
		return
	end,
	callbackOnDealDamage = function(self, who, value, target, dead, death_node)
		if dead or self.poison_charge ==0 then return end
		self.poison_charge = 0
		target:setEffect(target.EFF_CRIPPLING_POISON, 5, {src=who, apply_power = who:combatSteampower(), power= who:combatSteampower()/10, fail = 10, no_ct_effect=true})
	end,
}

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_RUSTPROOF_COATING"..i,
	name = simple[i].." rustproof coating", image = "object/tinkers_rustproof_coating_t5.png",
	on_slot = "BODY",
	special_desc = function(self) return ("%d%% chance to avoid a detrimental acid subtype effect."):format(self.object_tinker.wielder.corrode_resist) end,
	material_level = i,
	object_tinker = {
		wielder = {
			resists = {[DamageType.ACID] = 10*i,},
			corrode_resist = 10*i,
		},
	},
	on_tinker = function(self, o, who)
		if o.callbackOnTemporaryEffect then return true end
		o.callbackOnTemporaryEffect = function(self, who, eff_id, e, p)
			if e.subtype.acid and e.status == "detrimental" and rng.percent(who.corrode_resist) then
				p.dur = 0
			end
		end
	end,
	on_untinker = function(self, o, who)
		if not o.callbackOnTemporaryEffect then return true end
		o.callbackOnTemporaryEffect = nil
	end,
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_ALCHEMISTS_HELPER"..i,
	name = simple[i].." alchemist's helper", image = "object/tinkers_alchemists_helper_t5.png",
	on_slot = "BELT",
	material_level = i,
	object_tinker = {
		wielder = {
			inc_damage = {[DamageType.ACID] = 5*i, [DamageType.FIRE] = 5*i, [DamageType.NATURE] = 5*i, [DamageType.BLIGHT] = 5*i,},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_BLACK_LIGHT_EMITTER"..i,
	name = simple[i].." black light emitter", image = "object/tinkers_black_light_emitter_t5.png",
	on_slot = "LITE",
	material_level = i,
	object_tinker = {
		wielder = {
			lite = -i,
			infravision = 2*i,
			see_invisible = i*2,
			inc_damage = {[DamageType.DARKNESS] = 5*i,},
		},
	},
}
end
