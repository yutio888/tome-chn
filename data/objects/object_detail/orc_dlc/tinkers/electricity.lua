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
function newEntity(t) t.tinker_category = "electricity" return base_newEntity(t) end

local Talents = require "engine.interface.ActorTalents"
local Stats = require "engine.interface.ActorStats"
local DamageType = require "engine.DamageType"

local simple = {"crude", "good", "well-made", "mastercraft", "perfect"}
local metals = {"iron", "steel", "dwarven steel", "stralite", "voratun"}

-- On crit, no proc limit
for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_LIGHTNING_COIL"..i,
	name = simple[i].." lightning coil", image = "object/tinkers_lightning_coil_t5.png",
	on_type = "weapon",
	material_level = i,
	special_desc = function(self) return "On critical strikes generates a 3 tiles lightning beam." end,
	on_tinker = function(self, o, who)
		if not o.combat then return true end
		o.combat.lightning_coil_ml = self.material_level
		o:orcsWeaponAddOnEffect("special_on_crit", "lightning_coil", {desc="project a beam of lightning", fct=function(combat, who, target)
			local tg = {type="beam", range=3}
			local dam = who:steamCrit(who:combatMLSteamDamage(combat.lightning_coil_ml, 15, 90))

			local l = who:lineFOV(target.x, target.y)
			l:set_corner_block()
			local lx, ly, is_corner_blocked = l:step(true)
			local target_x, target_y = lx, ly
			-- Check for terrain and friendly actors
			while lx and ly and not is_corner_blocked and core.fov.distance(who.x, who.y, lx, ly) <= 4 do
				local actor = game.level.map(lx, ly, engine.Map.ACTOR)
				if actor and (who:reactionToward(actor) >= 0) then
					break
				elseif game.level.map:checkEntity(lx, ly, engine.Map.TERRAIN, "block_move") then
					target_x, target_y = lx, ly
					break
				end
				target_x, target_y = lx, ly
				lx, ly = l:step(true)
			end

			who:project(tg, target.x, target.y, engine.DamageType.LIGHTNING, rng.avg(dam / 3, dam, 3))
			if target_x and target_y then
				if core.shader.active() then game.level.map:particleEmitter(who.x, who.y, math.max(math.abs(target_x-who.x), math.abs(target_y-who.y)), "lightning_beam", {tx=target_x-who.x, ty=target_y-who.y}, {type="lightning"})
				else game.level.map:particleEmitter(who.x, who.y, math.max(math.abs(target_x-who.x), math.abs(target_y-who.y)), "lightning_beam", {tx=target_x-who.x, ty=target_y-who.y})
				end
			end
			game:playSoundNear(who, "talents/lightning")
		end})
	end,
	on_untinker = function(self, o, who)
		if not o.combat then return true end
		o:orcsWeaponRemoveOnEffect("special_on_crit", "lightning_coil")
		o.combat.lightning_coil_ml = nil
	end,
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_MANA_COIL"..i,
	name = simple[i].." mana coil", image = "object/tinkers_mana_coil_t5.png",
	on_type = "weapon", on_subtype = "staff",
	material_level = i,
	special_desc = function(self) return "Mana regeneration, on spell hit 25%% chances to cast lightning." end,
	object_tinker = {
		wielder = {
			mana_regen = i,
		},
	},
	on_tinker = function(self, o, who)
		o.talent_on_spell = o.talent_on_spell or {}
		table.insert(o.talent_on_spell, {chance=25, talent=who.T_LIGHTNING, level=self.material_level, is_manacoil=true})
	end,
	on_untinker = function(self, o, who)
		for i, s in ipairs(o.talent_on_spell) do if s.is_manacoil then table.remove(o.talent_on_spell, i) break end end
	end,
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_SHOCKING_TOUCH"..i,
	name = metals[i].." shocking touch", image = "object/tinkers_shocking_touch_t5.png",
	on_slot = "HANDS",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_SHOCKING_TOUCH] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_DEFLECTION_FIELD"..i,
	name = metals[i].." deflection field", image = "object/tinkers_deflection_field_t5.png",
	on_slot = "BELT",
	material_level = i,
	object_tinker = {
		wielder = {
			combat_def = 2*i,
			slow_projectiles = 5*i,
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_GALVANIC_RETRIBUTOR"..i,
	name = metals[i].." galvanic retributor", image = "object/tinkers_galvanic_retribution_t5.png",
	on_type = "armor", on_subtype = "shield",
	material_level = i,
	object_tinker = {
		galvanic_retributor_ml = i,
		wielder = {
			on_melee_hit={[DamageType.LIGHTNING] = 5*i},
		},
	},
	on_tinker = function(self, o, who)
		if o.on_block then return true end
		o.on_block = {desc = "Unleash a lightning nova of radius equal to the tinker tier.", fct = function(self, who, target, type, dam, eff)
			if not target or target:attr("dead") or not target.x or not target.y then return end
			if who.turn_procs and who.turn_procs.galvanic_retributor then return end

			-- Set this *before* damage or reflect/martyr avoids the limit
			if not who.turn_procs.galvanic_retributor then who.turn_procs.galvanic_retributor = {} end
			
			local tg = {type="ball", range=0, radius=self.galvanic_retributor_ml, selffire=false, talent=t}
			local damage = who:steamCrit(who:combatMLSteamDamage(self.galvanic_retributor_ml, 20, 150))

			who:project(tg, target.x, target.y, engine.DamageType.LIGHTNING, damage)
			who:logCombat(target, "#Source# unleashes GALVANIC RETRIBUTION!")
			end,
		}
	end,
	on_untinker = function(self, o, who)
		if not o.on_block then return true end
		o.on_block = nil
	end,
}
end

-- for i = 1, 5 do
-- newEntity{ base = "BASE_TINKER", define_as = "TINKER_GAUSS_ACCELERATOR"..i,
-- 	name = metals[i].." gauss accelerator", image = "object/tinkers_viral_needlegun_t5.png",
-- 	on_type = "weapon", on_subtype = "steamgun",
-- 	material_level = i,
-- 	object_tinker = {
-- 		combat = {
-- 			range = i/2,
-- 			travel_speed = i/2,
-- 			ranged_project={[DamageType.LIGHTNING] = 5*i},
-- 		},
-- 	},
-- }
-- end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_SHOCKING_EDGE"..i,
	name = metals[i].." shocking edge", image = "object/tinkers_shocking_edge_t5.png",
	on_type = "weapon",
	material_level = i,
	special_desc = function(self) return "Deals lightning damage and drains resources." end,
	on_tinker = function(self, o, who)
		local DamageType = require "engine.DamageType"
		if not o.combat then return true end
		
		o.combat.shocking_edge_ml = self.material_level
		o.combat.shocking_edge_damage = function(self, o, who)
			return math.ceil( who:combatMLSteamDamage(o.combat.shocking_edge_ml, 15, 50) )
		end
		o.combat.tinker_uid = "shocking_edge" .. self.uid
		
		o:orcsWeaponAddOnEffect("special_on_hit", "shocking_edge", {desc="shock your foe dealing " .. o.combat.shocking_edge_damage(self, o, who) .. " damage and draining some of their resources" , fct=function(combat, who, target)
			if who.turn_procs[combat.tinker_uid or "shocking_edge"] then return end
			local DamageType = require "engine.DamageType"
			local tg = {type="hit", start_x=target.x, start_y=target.y}
			local dam = who:steamCrit(who:combatMLSteamDamage(combat.shocking_edge_ml, 15, 50))
			
			who:project(tg, target.x, target.y, DamageType.LIGHTNING, dam)
			who:project(tg, target.x, target.y, DamageType.RESOURCE_SHOCK, dam/10)

			who.turn_procs[combat.tinker_uid or "shocking_edge"] = true
		end})
	end,
	on_untinker = function(self, o, who)
		if not o.combat then return true end
		o:orcsWeaponRemoveOnEffect("special_on_hit", "shocking_edge")
		o.combat.shocking_edge_ml = nil
		o.combat.shocking_edge_damage = nil
		o.combat.tinker_uid = nil
	end,
}
end

newEntity{ base = "BASE_TINKER", define_as = "TINKER_SAW_STORM5",--Electricity Capstone
	slot = "MAINHAND", offslot = "OFFHAND", dual_wieldable = true,
	type = "weapon", subtype="steamsaw",
	add_name = " (#COMBAT#)",
	display = "/", color=colors.SLATE, image = "shockbolt/object/artifact/stormcutter.png",
	moddable_tile = "%s_steamsaw_front",
	moddable_tile_back = "%s_steamsaw_back",
	encumber = 3,
	metallic = true,
	require = { talent = {Talents.T_STEAM_POOL} },
	shield_normal_combat = true,
	power_source = {steam=true}, is_tinker = false,
	name = "Stormcutter",
	unided_name = "electrified steamsaw", unique = true,
	desc = [["Great for combat, cooking, and shaving! We accept no responsibility for ruined follicles."]],
	require = { stat = { str=48 }, },
	cost = 900,
	material_level = 5,
	rarity = false,
	combat = {
		talented = "steamsaw", accuracy_effect="axe", damtype=DamageType.PHYSICALBLEED, damrange = 1.5, physspeed = 1, sound = {"actions/melee", pitch=0.6, vol=1.2}, sound_miss = {"actions/melee", pitch=0.6, vol=1.2}, use_resources={steam = 1},
		dam = 45,
		apr = 16,
		physcrit = 3,
		dammod = {str=1},
		block = 100,
		special_on_hit = {desc="deal lightning damage to the target based on cunning with a 25% chance to daze, and arc to up to 3 targets.", fct=function(combat, who, target)
			local tg = {type="bolt", range=10}
			local fx, fy = who:getTarget(tg)
			if not fx or not fy then return nil end

			local nb = 3
			local affected = {}
			local first = nil

			who:project(tg, fx, fy, function(dx, dy)
				local actor = game.level.map(dx, dy, engine.Map.ACTOR)
				if actor and not affected[actor] then
					affected[actor] = true
					first = actor
					who:project({type="ball", whofire=false, x=dx, y=dy, radius=10, range=0}, dx, dy, function(bx, by)
						local actor = game.level.map(bx, by, engine.Map.ACTOR)
						if actor and not affected[actor] and who:reactionToward(actor) < 0 then
							affected[actor] = true
						end
					end)
					return true
				end
			end)

			if not first then return end
			local targets = { first }
			affected[first] = nil
			local possible_targets = table.listify(affected)
			for i = 2, nb do
				if #possible_targets == 0 then break end
				local act = rng.tableRemove(possible_targets)
				targets[#targets+1] = act[1]
			end

			local sx, sy = who.x, who.y
			for i, actor in ipairs(targets) do
				local tgr = {type="beam", range=10, whofire=false,friendlyfire=false, x=sx, y=sy}
				local dam = who:steamCrit(who:getCun())
				who:project(tgr, actor.x, actor.y, engine.DamageType.LIGHTNING_DAZE, {dam=rng.avg(rng.avg(dam / 3, dam, 3), dam, 5), daze=25})
				if core.shader.active() then game.level.map:particleEmitter(sx, sy, math.max(math.abs(actor.x-sx), math.abs(actor.y-sy)), "lightning_beam", {tx=actor.x-sx, ty=actor.y-sy}, {type="lightning"})
				else game.level.map:particleEmitter(sx, sy, math.max(math.abs(actor.x-sx), math.abs(actor.y-sy)), "lightning_beam", {tx=actor.x-sx, ty=actor.y-sy})
				end

				sx, sy = actor.x, actor.y
			end

			game:playSoundNear(who, "talents/lightning")
		end},
	},
	wielder = {
		combat_armor = 6,
		combat_def = 10,
		fatigue = 12,
		inc_damage={
			[DamageType.LIGHTNING] = 20,
		},
		resists={
			[DamageType.LIGHTNING] = 20,
		},
		learn_talent = { [Talents.T_BLOCK] = 3, },
	},
}

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_VOLTAIC_SENTRY"..i,
	name = metals[i].." voltaic sentry", image = "object/tinkers_voltaic_sentry_t5.png",
	on_slot = "HANDS",
	material_level = i,
	object_tinker = {
		wielder = {
			learn_talent = {[Talents.T_TINKER_VOLTAIC_SENTRY] = i},
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_MENTAL_STIMULATOR"..i,
	name = metals[i].." mental stimulator", image = "object/tinkers_mental_stimulator_t5.png",
	on_slot = "HEAD",
	material_level = i,
	object_tinker = {
		wielder = {
			inc_stats = { [Stats.STAT_CUN] = i*2,},
			combat_mentalresist = i*3,
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_POWER_DISTRIBUTOR"..i,
	name = metals[i].." power distributor", image = "object/tinkers_power_distributor_t5.png",
	on_slot = "BELT",
	material_level = i,
	object_tinker = {
		wielder = {
			stamina_regen = i*0.1,
			mana_regen = i*0.1,
			psi_regen = i*0.1,
		},
	},
}
end

for i = 1, 5 do
newEntity{ base = "BASE_TINKER", define_as = "TINKER_WHITE_LIGHT_EMITTER"..i,
	name = metals[i].." white light emitter", image = "object/tinkers_white_light_emitter_t5.png",
	on_slot = "LITE",
	material_level = i,
	object_tinker = {	
		wielder = {
			lite = i,
			see_stealth = i*2,
			inc_damage = {[DamageType.LIGHT] = 4*i,},
		},
	},
}
end
