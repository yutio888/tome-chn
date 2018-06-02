-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2017 Nicolas Casalini
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

require "engine.class"
local Actor = require "engine.Actor"
require "engine.Autolevel"
require "engine.interface.ActorInventory"
require "engine.interface.ActorTemporaryEffects"
require "mod.class.interface.ActorLife"
require "engine.interface.ActorProject"
require "engine.interface.ActorLevel"
require "engine.interface.ActorStats"
require "engine.interface.ActorTalents"
require "engine.interface.ActorResource"
require "engine.interface.BloodyDeath"
require "engine.interface.ActorFOV"
require "mod.class.interface.ActorPartyQuest"
require "mod.class.interface.Combat"
require "mod.class.interface.Archery"
require "mod.class.interface.ActorInscriptions"
require "mod.class.interface.ActorObjectUse"
local Faction = require "engine.Faction"
local Dialog = require "engine.ui.Dialog"
local Map = require "engine.Map"
local Chat = require "engine.Chat"
local DamageType = require "engine.DamageType"

module(..., package.seeall, class.inherit(
	-- a ToME actor is a complex beast it uses may interfaces
	engine.Actor,
	engine.interface.ActorInventory,
	engine.interface.ActorTemporaryEffects,
	mod.class.interface.ActorLife,
	engine.interface.ActorProject,
	engine.interface.ActorLevel,
	engine.interface.ActorStats,
	engine.interface.ActorTalents,
	engine.interface.ActorResource,
	engine.interface.BloodyDeath,
	engine.interface.ActorFOV,
	mod.class.interface.ActorPartyQuest,
	mod.class.interface.ActorInscriptions,
	mod.class.interface.ActorObjectUse,
	mod.class.interface.Combat,
	mod.class.interface.Archery
))

-- Dont save the can_see_cache
_M._no_save_fields.can_see_cache = true

-- Activate fast regen computing
_M._no_save_fields.regenResourcesFast = true

-- Dont store resting or running
_M._no_save_fields.running = true
_M._no_save_fields.resting = true

-- No need to save __project_source either, it's a turn by turn thing
_M._no_save_fields.__project_source = true

-- Use distance maps
_M.__do_distance_map = true

_M.__is_actor = true

_M.stats_per_level = 3

-- Speeds are multiplicative, not additive
_M.temporary_values_conf.global_speed_add = "newest"
_M.temporary_values_conf.movement_speed = "add" -- Prevent excessive movement speed compounding
_M.temporary_values_conf.combat_physspeed = "add" -- Prevent excessive attack speed compounding
_M.temporary_values_conf.combat_spellspeed = "add" -- Prevent excessive spell speed compounding
_M.temporary_values_conf.combat_mindspeed = "add" -- Prevent excessive mind speed compounding

-- Effect reductions are multiplicative, not additive
_M.temporary_values_conf.reduce_detrimental_status_effects_time = "perc_inv"  -- Prevent effect reduction from hitting 100%

-- Damage cap takes the lowest
_M.temporary_values_conf.flat_damage_cap = "lowest"

-- Projectile evasion uses highest
_M.temporary_values_conf.projectile_evasion = "highest"
_M.temporary_values_conf.projectile_evasion_spread = "highest"

-- Damage redirection takes last
_M.temporary_values_conf.force_use_resist = "last"
_M.temporary_values_conf.force_use_resist_percent = "last"
_M.temporary_values_conf.all_damage_convert = "last"
_M.temporary_values_conf.all_damage_convert_percent = "last"
_M.temporary_values_conf.force_melee_damtype = "last"

-- AI
_M.temporary_values_conf.ai_move = "last"

-- Misc
_M.temporary_values_conf.death_dialog = "last"

_M.projectile_class = "mod.class.Projectile"

function _M:init(t, no_default)
	-- Define some basic combat stats
	self.energyBase = 0

	self.combat_def = 0
	self.combat_armor = 0
	self.combat_armor_hardiness = 0
	self.combat_atk = 0
	self.combat_apr = 0
	self.combat_dam = 0
	self.global_speed = 1
	self.global_speed_base = 1
	self.global_speed_add = 0
	self.movement_speed = 1
	self.combat_physcrit = 0
	self.combat_physspeed = 1
	self.combat_spellspeed = 1
	self.combat_mindspeed = 1
	self.combat_spellcrit = 0
	self.combat_spellpower = 0
	self.combat_mindpower = 0
	self.combat_mindcrit = 0

	self.combat_physresist = 0
	self.combat_spellresist = 0
	self.combat_mentalresist = 0

	t.old_life = 0

	self.fatigue = 0

	self.spell_cooldown_reduction = 0

	self.unused_stats = self.unused_stats or 3
	self.unused_talents = self.unused_talents or 2
	self.unused_generics = self.unused_generics or 1
	self.unused_talents_types = self.unused_talents_types or 0
	self.unused_prodigies = self.unused_prodigies or 0

	t.healing_factor = t.healing_factor or 1

	t.sight = t.sight or 10

	t.resource_pool_refs = t.resource_pool_refs or {}

	t.lite = t.lite or 0

	t.size_category = t.size_category or 3
	t.rank = t.rank or 2

	t.life_rating = t.life_rating or 10
	t.mana_rating = t.mana_rating or 4
	t.vim_rating = t.vim_rating or 4
	t.stamina_rating = t.stamina_rating or 3
	t.positive_negative_rating = t.positive_negative_rating or 3
	t.psi_rating = t.psi_rating or 0
	t.inc_resource_multi = t.inc_resource_multi or {}

	t.esp = t.esp or {}
	t.esp_range = t.esp_range or 10

	t.talent_cd_reduction = t.talent_cd_reduction or {}

	t.on_melee_hit = t.on_melee_hit or {}
	t.melee_project = t.melee_project or {}
	t.ranged_project = t.ranged_project or {}
	t.can_pass = t.can_pass or {}
	t.move_project = t.move_project or {}
	t.can_breath = t.can_breath or {}

	t.ai_tactic = t.ai_tactic or {}

	-- Resistances
	t.resists = t.resists or {}
	t.resists_cap = t.resists_cap or { all = 100 }
	t.resists_pen = t.resists_pen or {}
	t.resists_self = t.resists_self or {}
	t.resists_actor_type = t.resists_actor_type or {}
	t.resists_cap_actor_type = 70

	-- Absorbs a percentage of damage
	t.damage_affinity = t.damage_affinity or {}

	-- % Increase damage
	t.inc_damage = t.inc_damage or {}
	t.inc_damage_actor_type = t.inc_damage_actor_type or {}

	t.flat_damage_armor = t.flat_damage_armor or {}
	t.flat_damage_cap = t.flat_damage_cap or {}

	-- Default regen
	t.air_regen = t.air_regen or 3
	t.mana_regen = t.mana_regen or 0.5
	t.stamina_regen = t.stamina_regen or 0.3 -- Stamina regens slower than mana
	t.life_regen = t.life_regen or 0.25 -- Life regen real slow
	t.equilibrium_regen = t.equilibrium_regen or 0 -- Equilibrium does not regen
	t.vim_regen = t.vim_regen or 0 -- Vim does not regen
	t.positive_regen = t.positive_regen or -0.2 -- Positive energy slowly decays
	t.negative_regen = t.negative_regen or -0.2 -- Positive energy slowly decays
	t.positive_regen_ref = t.positive_regen_ref or 0.2
	t.negative_regen_ref = t.negative_regen_ref or 0.2
	t.paradox_regen = t.paradox_regen or 0 -- Paradox does not regen
	t.psi_regen = t.psi_regen or 0.2 -- Energy regens slowly
	t.hate_regen = t.hate_regen or 0 -- Hate does not regen
	t.soul_regen = t.soul_regen or 0 -- Souls does not regen

	t.max_positive = t.max_positive or 50
	t.max_negative = t.max_negative or 50
	t.positive = t.positive or 0
	t.negative = t.negative or 0

	t.soul = t.soul or 1

	t.max_hate = t.max_hate or 100
	t.hate = t.hate or 100
	t.baseline_hate = t.baseline_hate or 50 -- below this level hate loss stops
	t.hate_per_kill = t.hate_per_kill or 8
	t.default_hate_per_kill = t.hate_per_kill

	t.equilibrium = t.equilibrium or 0

	t.paradox = t.paradox or 300

	t.money = t.money or 0

	self.turn_procs = {}

	engine.Actor.init(self, t, no_default)
	engine.interface.ActorInventory.init(self, t)
	engine.interface.ActorTemporaryEffects.init(self, t)
	mod.class.interface.ActorLife.init(self, t)
	engine.interface.ActorProject.init(self, t)
	engine.interface.ActorTalents.init(self, t)
	engine.interface.ActorResource.init(self, t)
	engine.interface.ActorStats.init(self, t)
	engine.interface.ActorLevel.init(self, t)
	engine.interface.ActorFOV.init(self, t)
	mod.class.interface.ActorInscriptions.init(self, t)
	mod.class.interface.ActorObjectUse.init(self, t)

	-- Default melee barehanded damage
	self.combat = self.combat or {
		dam=1,
		atk=1, apr=0,
		physcrit=0,
		physspeed =1,
		dammod = { str=1 },
		damrange=1.1,
	}
	-- Ensures we have certain values for gloves to modify
	self.combat.talented = self.combat.talented or "unarmed"
	self.combat.damrange = self.combat.damrange or 1.1
	self.combat.physspeed = self.combat.physspeed or 1
	self.combat.dammod = self.combat.dammod or {str=0.6}

	self.talents[self.T_ATTACK] = self.talents[self.T_ATTACK] or 1

	self:resetCanSeeCache()
	self:recomputeGlobalSpeed()
	self:recomputeRegenResources()
end

function _M:resolve(t, last, on_entity, key_change)
	engine.Actor.resolve(self, t, last, on_entity, key_change)

	-- Account for innate stats.
	if last and not self.__stats_resolved then
		self.__stats_resolved = true
		for id, stat in ipairs(self.stats_def) do
			local diff = self:getStat(id) - stat.def
			self:onStatChange(id, diff)
		end
	end
end

function _M:loaded()
	engine.Actor.loaded(self)
	self:recomputeRegenResources()
end

function _M:altered(t)
	if t then for k, v in pairs(t) do self[k] = v end end
	self.__SAVEINSTEAD = nil
	self.__nice_tile_base = nil
	self.nice_tiler = nil
end

function _M:onEntityMerge(a)
	-- Remove stats to make new stats work
	for i, s in ipairs(_M.stats_def) do
		if a.stats[i] then
			a.stats[s.short_name], a.stats[i] = a.stats[i], nil
		end
	end
end

--- Try to remove all "un-needed" effects, fields, ... for a clean export
function _M:stripForExport()
	self.distance_map = {}
	self.fov = {actors={}, actors_dist={}}
	self.running_fov = nil
	self.running_prev = nil
	self.killedBy = nil
	self.quests = {}
	self.dialog = nil
	self:setTarget(nil)

	-- Disable all sustains, remove all effects
	self:removeEffectsSustainsFilter()
end

-- Dummy
function _M:runStop() end
function _M:restStop() end

function _M:getSpeed(speed_type)
	if type(speed_type) == "number" then return speed_type end

	local speed

	if speed_type == "weapon" or speed_type == "mainhand" or
		speed_type == "offhand" or speed_type == "combat"
	then
		if (speed_type == "weapon" or speed_type == "mainhand") and
			self:getInven(self.INVEN_MAINHAND)
		then
			local o = self:getInven(self.INVEN_MAINHAND)[1]
			if o and self:getObjectCombat(o, "mainhand") then
				speed = self:combatSpeed(self:getObjectCombat(o, "mainhand"))
			end
		end

		if (speed_type == "weapon" or speed_type == "offhand") and
			self:getInven(self.INVEN_OFFHAND)
		then
			local o = self:getInven(self.INVEN_OFFHAND)[1]
			if o and self:getObjectCombat(o, "offhand") then
				speed = math.max(speed or 0, self:combatSpeed(self:getObjectCombat(o, "offhand")))
			end
		end

		if (speed_type == "combat" or speed_type == "weapon") and not speed then
			speed = self:combatSpeed()
		end

	elseif speed_type == "archery" then
		if self:getInven(self.INVEN_MAINHAND) then
			local o = self:getInven(self.INVEN_MAINHAND)[1]
			if o and o.archery then
				speed = self:combatSpeed(self:getObjectCombat(o, "mainhand"))
			end
		end

		if self:getInven(self.INVEN_OFFHAND) then
			local o = self:getInven(self.INVEN_OFFHAND)[1]
			if o and o.archery then
				speed = math.max(speed or 0, self:combatSpeed(self:getObjectCombat(o, "offhand")))
			end
		end

		if not speed then speed = self:combatSpeed() end

	elseif speed_type == "shield" then
		if self:getInven(self.INVEN_OFFHAND) then
			local o = self:getInven(self.INVEN_OFFHAND)[1]
			if o and o.special_combat then
				speed = self:combatSpeed(o.special_combat)
			end
		end

		if self:getInven(self.INVEN_MAINHAND) then
			local o = self:getInven(self.INVEN_MAINHAND)[1]
			if o and o.special_combat then
				speed = math.max(speed or 0, self:combatSpeed(o.special_combat))
			end
		end

		if not speed then speed = self:combatSpeed() end
	elseif speed_type == "throwing" then
		speed = 1
		if self:knowTalent(self.T_QUICKDRAW) then speed = speed/(1 + self:callTalent("T_QUICKDRAW", "getSpeed")) end
	elseif speed_type == "spell" then speed = self:combatSpellSpeed()
	elseif speed_type == "summon" then speed = self:combatSummonSpeed()
	elseif speed_type == "mind" then speed = self:combatMindSpeed()
	elseif speed_type == "movement" then speed = self:combatMovementSpeed()
	elseif speed_type == "standard" then speed = 1
	end

	local hd = {"Actor:getSpeed", speed_type = speed_type, speed = speed,}
	if self:triggerHook(hd) then speed = hd.speed end

	return speed or 1
end

function _M:useEnergy(val)
	engine.Actor.useEnergy(self, val)

	-- handle stalking
	local effStalker = self:hasEffect(self.EFF_STALKER)
	if effStalker then
		if effStalker.hit then
			-- consecutive hit on stalkee..add hate then bonus
			local t = self:getTalentFromId(self.T_STALK)
			self:incHate(t.getHitHateChange(self, t, effStalker.bonus))
			effStalker.bonus = math.min(3, (effStalker.bonus or 1) + 1)
			effStalker.hit = false
		else
			 -- no consecutive hit on stalkee..remove bonus
			effStalker.bonus = math.max(1, (effStalker.bonus or 1) - 1)
		end
	elseif self:isTalentActive(self.T_STALK) then
		local stalk = self:isTalentActive(self.T_STALK)
		if stalk.hit and stalk.hit_target and not stalk.hit_target.dead then
			stalk.hit_turns = (stalk.hit_turns or 0) + 1
			stalk.hit = false

			if stalk.hit_turns > 1 then
				-- multiple hits begin stalking
				local t = self:getTalentFromId(self.T_STALK)
				t.doStalk(self, t, stalk.hit_target)
				stalk.hit_turns = 0
				stalk.hit_target = nil
			end
		else
			stalk.hit = false
			stalk.hit_target = nil
			stalk.hit_turns = 0
		end
	end

	-- Curse of Shrouds: turn shroud of passing on or off
	local eff = self:hasEffect(self.EFF_CURSE_OF_SHROUDS)
	if eff then self.tempeffect_def[self.EFF_CURSE_OF_SHROUDS].doShroudOfPassing(self, eff) end

	-- Do not fire those talents if this is not turn's end
	if self:enoughEnergy() or game.zone.wilderness then return end
end

-- Called at the start of a turn before the actor chooses their action, energy is handled, etc
function _M:actBase()
	-- Stupid sanity check that is actualy useful
	if self.life ~= self.life then self.life = self.max_life end
	if self.life_regen ~= self.life_regen then self.life_regen = 1 end

	-- Solipsism speed effects; calculated before the actor gets energy
	local current_psi_percentage = self:getPsi() / self:getMaxPsi()
	local clarity
	if self:knowTalent(self.T_CLARITY) then
		clarity = self:callTalent(self.T_CLARITY,"getClarityThreshold")
	end
	local eff_solipsis = math.min(self:attr("solipsism_threshold") or 0,clarity or 1) -- effective solipsism_threshold
	if self:attr("solipsism_threshold") and current_psi_percentage < eff_solipsis then
		local solipsism_power = eff_solipsis - current_psi_percentage
		if self:hasEffect(self.EFF_CLARITY) then
			self:removeEffect(self.EFF_CLARITY)
		end
		local p = self:hasEffect(self.EFF_SOLIPSISM)
		if (p and p.power ~= solipsism_power) or not p then
			self:setEffect(self.EFF_SOLIPSISM, 1, {power = solipsism_power})
		end
	elseif clarity and current_psi_percentage > clarity then
		local clarity_power = math.min(1, current_psi_percentage - clarity)
		if self:hasEffect(self.EFF_SOLIPSISM) then
			self:removeEffect(self.EFF_SOLIPSISM)
		end
		local p = self:hasEffect(self.EFF_CLARITY)
		if (p and p.power ~= clarity_power) or not p then
			self:setEffect(self.EFF_CLARITY, 1, {power = math.min(1, current_psi_percentage - clarity)})
		end
	elseif self:hasEffect(self.EFF_SOLIPSISM) then
		self:removeEffect(self.EFF_SOLIPSISM)
	elseif self:hasEffect(self.EFF_CLARITY) then
		self:removeEffect(self.EFF_CLARITY)
	end

	self.energyBase = self.energyBase - game.energy_to_act

	if self:attr("no_timeflow") then
		-- Compute timed effects that can happen even in timeless mode
		self:timedEffects(function(e, p) if e.tick_on_timeless then return true end end)
		return
	end

	if self.__use_build_order then
		self:useBuildOrder()
	end

	-- Regen resources
	self:regenLife()
	self:regenAmmo()
	if self:knowTalent(self.T_UNNATURAL_BODY) then
		local t = self:getTalentFromId(self.T_UNNATURAL_BODY)
		t.do_regenLife(self, t)
	end

	if self.resting and self.reload then
		local reloaded = self:reload()
		if not reloaded and self.reloadQS then
			self:reloadQS()
		end
	end

	-- update hate regen based on calculated decay rate
	if self:knowTalent(self.T_HATE_POOL) then
		local t = self:getTalentFromId(self.T_HATE_POOL)
		t.updateRegen(self, t)
	end

	if self:attr("positive_at_rest") then
		local v = self.positive_at_rest * self.max_positive / 100
		if self:getPositive() > v or self:attr("positive_at_rest_disable") then self.positive_regen = -self.positive_regen_ref + (self.positive_regen_ref_mod or 0)
		elseif self:getPositive() < v then self.positive_regen = self.positive_regen_ref + (self.positive_regen_ref_mod or 0)
		end
	end
	if self:attr("negative_at_rest") then
		local v = self.negative_at_rest * self.max_negative / 100
		if self:getNegative() > v or self:attr("negative_at_rest_disable")  then self.negative_regen = -self.negative_regen_ref + (self.negative_regen_ref_mod or 0)
		elseif self:getNegative() < v then self.negative_regen = self.negative_regen_ref + (self.negative_regen_ref_mod or 0)
		end
	end

	self:regenResources()

	-- update psionic feedback
	if self:getFeedback() > 0 then
		local decay = self:getFeedbackDecay()
		if self:knowTalent(self.T_BIOFEEDBACK) then
			local t = self:getTalentFromId(self.T_BIOFEEDBACK)
			self:heal(decay * t.getHealRatio(self, t), self)
		end
		if self:hasEffect(self.EFF_FEEDBACK_LOOP) then
			self:incFeedback(decay)
		else
			self:incFeedback(-decay)
		end
	end

	-- Suffocate ?
	-- The idea here is that we suffocate (EFF_SUFFOCATING checks this flag) if a) something (including own effects) tries to suffocate us between our actBase calls, or
	-- b) we cannot breathe on the current terrain. The first is force_suffocate flag. It only works for one base turn, of course.
	-- These are all flags because there is no turn_base_procs. :(
	if not self.force_suffocate then                                                
		self.is_suffocating = nil
	else
		self.force_suffocate = nil
		self.is_suffocating = true
	end
	local air_level, air_condition = game.level.map:checkEntity(self.x, self.y, Map.TERRAIN, "air_level"), game.level.map:checkEntity(self.x, self.y, Map.TERRAIN, "air_condition")
	if air_level then
		if not air_condition or not self.can_breath[air_condition] or self.can_breath[air_condition] <= 0 then
			self.is_suffocating = true
			self:suffocate(-air_level, self, air_condition == "water" and "drowned to death" or nil)
			self.force_suffocate = nil
		end
	end

	if self:knowTalent(self.T_GESTURE_OF_GUARDING) then self:setEffect(self.EFF_GESTURE_OF_GUARDING,1,{}) end
	if self:knowTalent(self.T_COUNTER_ATTACK) then self:setEffect(self.EFF_COUNTER_ATTACKING,1,{}) end
	if self:knowTalent(self.T_DEFENSIVE_THROW) then self:setEffect(self.EFF_DEFENSIVE_GRAPPLING,1,{}) end
	
	self:timedEffects()

	-- Handle thunderstorm, even if the actor is stunned or incapacitated it still works
	if not game.zone.wilderness and not self.dead then
		self:triggerHook{"Actor:actBase:Effects"}
		self:fireTalentCheck("callbackOnActBase")
	end

	-- Cooldown talents after effects, because some of them involve breaking sustains.
	if not self:attr("no_talents_cooldown") then self:cooldownTalents() end

	self:checkStillInCombat()
end

function _M:act()
	if not engine.Actor.act(self) then return end

	self.changed = true
	self.turn_procs = {}

	-- Break some sustains if certain resources are too low
	-- Note: force_talent_ignore_ressources has no effect here
	-- consider replacing the minimum resource value of 1 with a number based on the talent and resource
	for tid, p in pairs(self.sustain_talents) do
		local deact, t = false, self.talents_def[tid]
		-- check each possible resource the talent uses
		for res, res_def in ipairs(_M.resources_def) do
			if (t.remove_on_zero == nil and res_def.depleted_unsustain) or (t.remove_on_zero ~= nil and util.getval(t.remove_on_zero, self, t)) then
				if t[res_def.sustain_prop] then
					if res == self.RS_STAMINA and self:hasEffect(self.EFF_ADRENALINE_SURGE) then
					else
						if res_def.invert_values then
							if self[res_def.maxname] and (self[res_def.maxname] - self[res_def.short_name]) < 1 then
								deact = true break
							end
						else
							if self[res_def.minname] and (self[res_def.short_name] - self[res_def.minname]) < 1 then
								deact = true break
							end
						end
					end
				end
			end
		end
		if deact then self:forceUseTalent(tid, {ignore_energy=true}) end
	end
	
	-- clear grappling
	if self:hasEffect(self.EFF_GRAPPLING) and self.stamina < 1 and not self:hasEffect(self.EFF_ADRENALINE_SURGE) then
		self:removeEffect(self.EFF_GRAPPLING)
	end

	-- disable spell sustains
	if self:attr("spell_failure") then
		for tid, _ in pairs(self.sustain_talents) do
			local t = self:getTalentFromId(tid)
			if t.is_spell and rng.percent(self:attr("spell_failure")/10)then
				self:forceUseTalent(tid, {ignore_energy=true})
				if not silent then game.logSeen(self, "%s has been disrupted by #ORCHID#anti-magic forces#LAST#!", t.name) end
			end
		end
	end

	if self:attr("paralyzed") then
		self.paralyzed_counter = (self.paralyzed_counter or 0) + (self:attr("stun_immune") or 0) * 100
		if self.paralyzed_counter < 100 then
			self.energy.value = 0
		else
			-- We are saved for this turn
			self.paralyzed_counter = self.paralyzed_counter - 100
			game.logSeen(self, "%s temporarily fights the paralyzation.", self.name:capitalize())
		end
	end
	if self:attr("stoned") then self.energy.value = 0 end
	if self:attr("dont_act") then self.energy.value = 0 end
	if self:attr("time_stun") then self.energy.value = 0 end
	if self:attr("time_prison") then self.energy.value = 0 end

	-- Regain natural balance?
	local equilibrium_level = game.level.map:checkEntity(self.x, self.y, Map.TERRAIN, "equilibrium_level")
	if equilibrium_level then self:incEquilibrium(equilibrium_level) end

	-- Do stuff to things standing in the fire
	game.level.map:checkEntity(self.x, self.y, Map.TERRAIN, "on_stand", self)

	-- Still enough energy to act ?
	if self.energy.value < game.energy_to_act then return false end

	-- Still not dead ?
	if self.dead then return false end

	-- Register life for this turn
	self.old_life = self.life

	-- Ok reset the seen cache
	self:resetCanSeeCache()

	if self.on_act then self:on_act() end

	if self:attr("never_act") then return false end

	if not game.zone.wilderness and not self:attr("confused") and not self:attr("terrified") then self:automaticTalents() end

	-- Compute bonuses based on actors in FOV
	if self:knowTalent(self.T_MILITANT_MIND) and not self:hasEffect(self.EFF_MILITANT_MIND) then
		local nb_foes = 0
		local act
		for i = 1, #self.fov.actors_dist do
			act = self.fov.actors_dist[i]
			if act and self:reactionToward(act) < 0 and self:canSee(act) then nb_foes = nb_foes + 1 end
		end
		if nb_foes > 1 then
			nb_foes = math.min(nb_foes, 5)
			self:setEffect(self.EFF_MILITANT_MIND, 4, {power=self:getTalentLevel(self.T_MILITANT_MIND) * nb_foes * 1.5})
		end
	end

	-- Beckon (chance to move actor and consume energy)
	if self:hasEffect(self.EFF_BECKONED) then
		self.tempeffect_def[self.EFF_BECKONED].do_act(self, self:hasEffect(self.EFF_BECKONED))
	end
	-- Paranoid (chance to attack anyone nearby)
	if self:hasEffect(self.EFF_PARANOID) then
		self.tempeffect_def[self.EFF_PARANOID].do_act(self, self:hasEffect(self.EFF_PARANOID))
	end
	-- Panicked (chance to run away)
	if self:hasEffect(self.EFF_PANICKED) then
		self.tempeffect_def[self.EFF_PANICKED].do_act(self, self:hasEffect(self.EFF_PANICKED))
	end

	self:fireTalentCheck("callbackOnAct")

	-- Still enough energy to act ?
	if self.energy.value < game.energy_to_act then return false end

	if self.sound_random and rng.chance(self.sound_random_chance or 15) then game:playSoundNear(self, self.sound_random) end

	-- Cauterize ?
	if self:hasEffect(self.EFF_CAUTERIZE) then
		local eff = self:hasEffect(self.EFF_CAUTERIZE)
		if eff.invulnerable then eff.invulnerable = nil end
	end

	return true
end

--- Follow a build order as possible
function _M:useBuildOrder()
	local b = self.__use_build_order

	if self.unused_stats > 0 then
		b.stats.i = b.stats.i or 1
		local nb = 0

		while self.unused_stats > 0 and nb < #b.stats+1 do
			local stat = b.stats[b.stats.i]

			if not (self:getStat(stat, nil, nil, true) >= self.level * 1.4 + 20) and
			   not (self:isStatMax(stat) or self:getStat(stat, nil, nil, true) >= 60 + math.max(0, (self.level - 50))) then
				self:incStat(stat, 1)
				self.unused_stats = self.unused_stats - 1
				nb = -1
				game.log("#VIOLET#Following build order %s; increasing %s by 1.", b.name, self.stats_def[stat].name)
			end
			b.stats.i = util.boundWrap(b.stats.i + 1, 1, #b.stats)
			nb = nb + 1
		end
	end

	if self.unused_talents_types > 0 then
		self.__increased_talent_types = self.__increased_talent_types or {}

		local learn = true
		while learn do
			learn = false
			for i, tt in ipairs(b.types) do
				if self.unused_talents_types > 0 and (self.__increased_talent_types[tt] or 0) == 0 then
					if not self:knowTalentType(tt) then
						self:learnTalentType(tt)
					else
						self.__increased_talent_types[tt] = (self.__increased_talent_types[tt] or 0) + 1
						self:setTalentTypeMastery(tt, self:getTalentTypeMastery(tt) + 0.2)
					end

					game.log("#VIOLET#Following build order %s; learning talent category %s.", b.name, tt)
					self.unused_talents_types = self.unused_talents_types - 1
					table.remove(b.types, i)
					learn = true
					break
				end
			end
		end
	end

	if self.unused_talents > 0 then
		local learn = true
		while learn do
			learn = false
			for i, td in ipairs(b.talents) do
				if td.kind == "class" then
					local t = self:getTalentFromId(td.tid)

					if self.unused_talents > 0 and self:canLearnTalent(t) and self:getTalentLevelRaw(t.id) < t.points then
						self:learnTalent(t.id, true)
						game.log("#VIOLET#Following build order %s; learning talent %s.", b.name, t.name)
						self.unused_talents = self.unused_talents - 1
						table.remove(b.talents, i)
						learn = true
						break
					end
				end
			end
		end
	end

	if self.unused_generics > 0 then
		local learn = true
		while learn do
			learn = false
			for i, td in ipairs(b.talents) do
				if td.kind == "generic" then
					local t = self:getTalentFromId(td.tid)

					if self.unused_generics > 0 and self:canLearnTalent(t) and self:getTalentLevelRaw(t.id) < t.points then
						self:learnTalent(t.id, true)
						game.log("#VIOLET#Following build order %s; learning talent %s.", b.name, t.name)
						self.unused_generics = self.unused_generics - 1
						table.remove(b.talents, i)
						learn = true
						break
					end
				end
			end
		end
	end
end

function _M:loadBuildOrder(file)
	local f = fs.open("/build-orders/"..file, "r")
	if not f then return end

	local b = {name="xxx", stats={}, talents={}, types={}}

	local cur = "name"
	while true do
		local line = f:readLine()
		if not line then break end
		line = line:gsub('[\r\n"]', '')
		local split = line:split(lpeg.S",; \t")

		if split[1] == "#Name" then cur = "name"
		elseif split[1] == "#Stats" then cur = "stats"
		elseif split[1] == "#Talents" then cur = "talents"
		elseif split[1] == "#Types" then cur = "types"
		else
			if cur == "name" then b.name = table.concat(split, " "):trim()
			elseif cur == "stats" then
				b.stats = {}
				for i, s in ipairs(split) do if s ~= "" then table.insert(b.stats, s) end end
			elseif cur == "talents" then
				table.insert(b.talents, {kind=split[2], tid=split[3]})
			elseif cur == "types" then
				table.insert(b.types, split[2])
			end
		end
	end

	if #b.stats > 0 and #b.talents > 0 then
		self.__use_build_order = b
	end
end

--- Setup minimap color for this entity
-- You may overload this method to customize your minimap
function _M:setupMinimapInfo(mo, map)
	if map.actor_player and not map.actor_player:canSee(self) then return end
	if self.rank > 3 then mo:minimap(0xC0, 0x00, 0xAF) return end
	local r = map.actor_player and map.actor_player:reactionToward(self) or -100
	if r < 0 then mo:minimap(240, 0, 0)
	elseif r > 0 then mo:minimap(0, 240, 0)
	else mo:minimap(0, 0, 240)
	end
end

function _M:alterMakeMapObject(tiles, mo, z, lastmo)
	local submo = core.map.newObject(self.uid, 1, self:check("display_on_seen"), self:check("display_on_remember"), self:check("display_on_unknown"), self:check("display_x") or 0, self:check("display_y") or 0, self:check("display_w") or 1, self:check("display_h") or 1, self:check("display_scale") or 1)
	local tex, texx, texy, w, h, pos_x, pos_y = tiles:get("", 0, 0, 0, 0, 0, 0, "invis.png", false, false, true)
	submo:texture(0, tex, false, texx, texy, pos_x, pos_y)
	submo:chain(mo)
	-- if lastmo == mo then lastmo = submo end
	mo = submo
	self._mo = mo

	return mo, z, lastmo
end

local f_self = nil
local f_danger2 = nil
local f_danger1 = nil
local f_powerful = nil
local f_friend = nil
local f_enemy = nil
local f_neutral = nil
local sf_self = nil
local sf_danger2 = nil
local sf_danger1 = nil
local sf_powerful = nil
local sf_friend = nil
local sf_enemy = nil
local sf_neutral = nil
local asf_self = nil
local asf_danger2 = nil
local asf_danger1 = nil
local asf_powerful = nil
local asf_friend = nil
local asf_enemy = nil
local asf_neutral = nil
local ssf_self = nil
local ssf_danger2 = nil
local ssf_danger1 = nil
local ssf_powerful = nil
local ssf_friend = nil
local ssf_enemy = nil
local ssf_neutral = nil
local assf_self = nil
local assf_danger2 = nil
local assf_danger1 = nil
local assf_powerful = nil
local assf_friend = nil
local assf_enemy = nil
local assf_neutral = nil
local ichat = nil

function _M:smallTacticalFrame(map, x, y, w, h, zoom, on_map, tlx, tly)
	if config.settings.tome.small_frame_side then
		local friend = -100
		if self.faction then
			if not map.actor_player then friend = Faction:factionReaction(map.view_faction, self.faction)
			else friend = map.actor_player:reactionToward(self) end
		end

		local sx = w * .015625
		local dx = w * .0625 - sx
		local sy = h * .03125
		local dy = h * .953125 - sy
		if friend < 0 then
			sx = w * .9375
		end
		local lp = math.max(0, self.life) / self.max_life + 0.0001
		if lp > .75 then -- green
			core.display.drawQuad(x + sx, y + sy, dx, dy, 129, 180, 57, 128)
			core.display.drawQuad(x + sx, y + sy + dy * (1-lp), dx, dy * lp, 50, 220, 77, 255)
		elseif lp > .5 then -- yellow
			core.display.drawQuad(x + sx, y + sy, dx, dy, 175, 175, 10, 128)
			core.display.drawQuad(x + sx, y + sy + dy * (1-lp), dx, dy * lp, 240, 252, 35, 255)
		elseif lp > .25 then -- orange
			core.display.drawQuad(x + sx, y + sy, dx, dy, 185, 88, 0, 128)
			core.display.drawQuad(x + sx, y + sy + dy * (1-lp), dx, dy * lp, 255, 156, 21, 255)
		else -- red
			core.display.drawQuad(x + sx, y + sy, dx, dy, 167, 55, 39, 128)
			core.display.drawQuad(x + sx, y + sy + dy * (1-lp), dx, dy * lp, 235, 0, 0, 255)
		end


		local b_self
		local b_powerful
		local b_danger2
		local b_danger1
		local b_friend
		local b_enemy
		local b_neutral
		if config.settings.tome.flagpost_tactical then
			if not assf_self then
				assf_self = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, "alt_side_"..map.faction_self)
				assf_powerful = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, "alt_side_"..map.faction_powerful)
				assf_danger2 = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, "alt_side_"..map.faction_danger2)
				assf_danger1 = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, "alt_side_"..map.faction_danger1)
				assf_friend = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, "alt_side_"..map.faction_friend)
				assf_enemy = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, "alt_side_"..map.faction_enemy)
				assf_neutral = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, "alt_side_"..map.faction_neutral)
			end
			b_self = assf_self
			b_powerful = assf_powerful
			b_danger2 = assf_danger2
			b_danger1 = assf_danger1
			b_friend = assf_friend
			b_enemy = assf_enemy
			b_neutral = assf_neutral
		else
			if not ssf_self then
				ssf_self = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, "side_"..map.faction_self)
				ssf_powerful = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, "side_"..map.faction_powerful)
				ssf_danger2 = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, "side_"..map.faction_danger2)
				ssf_danger1 = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, "side_"..map.faction_danger1)
				ssf_friend = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, "side_"..map.faction_friend)
				ssf_enemy = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, "side_"..map.faction_enemy)
				ssf_neutral = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, "side_"..map.faction_neutral)
			end
			b_self = ssf_self
			b_powerful = ssf_powerful
			b_danger2 = ssf_danger2
			b_danger1 = ssf_danger1
			b_friend = ssf_friend
			b_enemy = ssf_enemy
			b_neutral = ssf_neutral
		end

		if self.faction then
			if self == map.actor_player then
				b_self:toScreen(x, y, w, h)
			elseif map:faction_danger_check(self) then
				if friend >= 0 then b_powerful:toScreen(x, y, w, h)
				else
					if map:faction_danger_check(self, true) then
						b_danger2:toScreen(x, y, w, h)
					else
						b_danger1:toScreen(x, y, w, h)
					end
				end
			elseif friend > 0 then
				b_friend:toScreen(x, y, w, h)
			elseif friend < 0 then
				b_enemy:toScreen(x, y, w, h)
			else
				b_neutral:toScreen(x, y, w, h)
			end
		end
	else
		local sx = w * .078125
		local dx = w * .90625 - sx
		local sy = h * .9375
		local dy = h * .984375 - sy
		local lp = math.max(0, self.life) / self.max_life + 0.0001
		if lp > .75 then -- green
			core.display.drawQuad(x + sx, y + sy, dx, dy, 129, 180, 57, 128)
			core.display.drawQuad(x + sx, y + sy, dx * lp, dy, 50, 220, 77, 255)
		elseif lp > .5 then -- yellow
			core.display.drawQuad(x + sx, y + sy, dx, dy, 175, 175, 10, 128)
			core.display.drawQuad(x + sx, y + sy, dx * lp, dy, 240, 252, 35, 255)
		elseif lp > .25 then -- orange
			core.display.drawQuad(x + sx, y + sy, dx, dy, 185, 88, 0, 128)
			core.display.drawQuad(x + sx, y + sy, dx * lp, dy, 255, 156, 21, 255)
		else -- red
			core.display.drawQuad(x + sx, y + sy, dx, dy, 167, 55, 39, 128)
			core.display.drawQuad(x + sx, y + sy, dx * lp, dy, 235, 0, 0, 255)
		end

		local b_self
		local b_powerful
		local b_danger2
		local b_danger1
		local b_friend
		local b_enemy
		local b_neutral
		if config.settings.tome.flagpost_tactical then
			if not asf_self then
				asf_self = map.tilesTactic:get(nil, 0,0,0, 0,0,0, "alt_down_"..map.faction_self)
				asf_powerful = map.tilesTactic:get(nil, 0,0,0, 0,0,0, "alt_down_"..map.faction_powerful)
				asf_danger2 = map.tilesTactic:get(nil, 0,0,0, 0,0,0, "alt_down_"..map.faction_danger2)
				asf_danger1 = map.tilesTactic:get(nil, 0,0,0, 0,0,0, "alt_down_"..map.faction_danger1)
				asf_friend = map.tilesTactic:get(nil, 0,0,0, 0,0,0, "alt_down_"..map.faction_friend)
				asf_enemy = map.tilesTactic:get(nil, 0,0,0, 0,0,0, "alt_down_"..map.faction_enemy)
				asf_neutral = map.tilesTactic:get(nil, 0,0,0, 0,0,0, "alt_down_"..map.faction_neutral)
			end
			b_self = asf_self
			b_powerful = asf_powerful
			b_danger2 = asf_danger2
			b_danger1 = asf_danger1
			b_friend = asf_friend
			b_enemy = asf_enemy
			b_neutral = asf_neutral
		else
			if not sf_self then
				sf_self = map.tilesTactic:get(nil, 0,0,0, 0,0,0, "small_"..map.faction_self)
				sf_powerful = map.tilesTactic:get(nil, 0,0,0, 0,0,0, "small_"..map.faction_powerful)
				sf_danger2 = map.tilesTactic:get(nil, 0,0,0, 0,0,0, "small_"..map.faction_danger2)
				sf_danger1 = map.tilesTactic:get(nil, 0,0,0, 0,0,0, "small_"..map.faction_danger1)
				sf_friend = map.tilesTactic:get(nil, 0,0,0, 0,0,0, "small_"..map.faction_friend)
				sf_enemy = map.tilesTactic:get(nil, 0,0,0, 0,0,0, "small_"..map.faction_enemy)
				sf_neutral = map.tilesTactic:get(nil, 0,0,0, 0,0,0, "small_"..map.faction_neutral)
			end
			b_self = sf_self
			b_powerful = sf_powerful
			b_danger2 = sf_danger2
			b_danger1 = sf_danger1
			b_friend = sf_friend
			b_enemy = sf_enemy
			b_neutral = sf_neutral
		end

		if self.faction then
			local friend
			if not map.actor_player then friend = Faction:factionReaction(map.view_faction, self.faction)
			else friend = map.actor_player:reactionToward(self) end

			if self == map.actor_player then
				b_self:toScreen(x, y, w, h)
			elseif map:faction_danger_check(self) then
				if friend >= 0 then b_powerful:toScreen(x, y, w, h)
				else
					if map:faction_danger_check(self, true) then
						b_danger2:toScreen(x, y, w, h)
					else
						b_danger1:toScreen(x, y, w, h)
					end
				end
			elseif friend > 0 then
				b_friend:toScreen(x, y, w, h)
			elseif friend < 0 then
				b_enemy:toScreen(x, y, w, h)
			else
				b_neutral:toScreen(x, y, w, h)
			end
		end
	end
end

function _M:bigTacticalFrame(x, y, w, h, zoom, on_map, tlx, tly)
	-- Tactical info
	if game.level and game.always_target then
		-- Tactical life info
		if on_map then
			if config.settings.tome.small_frame_side then
				local dw = w * 0.1
				local lp = math.max(0, self.life) / self.max_life + 0.0001
				if lp > .75 then -- green
					core.display.drawQuad(x + 3, y + 3, dw, h - 6, 129, 180, 57, 128)
					core.display.drawQuad(x + 3, y + 3 + (h - 6) * (1 - lp), dw, (h - 6) * lp, 50, 220, 77, 255)
				elseif lp > .5 then -- yellow
					core.display.drawQuad(x + 3, y + 3, dw, h - 6, 175, 175, 10, 128)
					core.display.drawQuad(x + 3, y + 3 + (h - 6) * (1 - lp), dw, (h - 6) * lp, 240, 252, 35, 255)
				elseif lp > .25 then -- orange
					core.display.drawQuad(x + 3, y + 3, dw, h - 6, 185, 88, 0, 128)
					core.display.drawQuad(x + 3, y + 3 + (h - 6) * (1 - lp), dw, (h - 6) * lp, 255, 156, 21, 255)
				else -- red
					core.display.drawQuad(x + 3, y + 3, dw, h - 6, 167, 55, 39, 128)
					core.display.drawQuad(x + 3, y + 3 + (h - 6) * (1 - lp), dw, (h - 6) * lp, 235, 0, 0, 255)
				end
			else
				local dh = h * 0.1
				local lp = math.max(0, self.life) / self.max_life + 0.0001
				if lp > .75 then -- green
					core.display.drawQuad(x + 3, y + h - dh, w - 6, dh, 129, 180, 57, 128)
					core.display.drawQuad(x + 3, y + h - dh, (w - 6) * lp, dh, 50, 220, 77, 255)
				elseif lp > .5 then -- yellow
					core.display.drawQuad(x + 3, y + h - dh, w - 6, dh, 175, 175, 10, 128)
					core.display.drawQuad(x + 3, y + h - dh, (w - 6) * lp, dh, 240, 252, 35, 255)
				elseif lp > .25 then -- orange
					core.display.drawQuad(x + 3, y + h - dh, w - 6, dh, 185, 88, 0, 128)
					core.display.drawQuad(x + 3, y + h - dh, (w - 6) * lp, dh, 255, 156, 21, 255)
				else -- red
					core.display.drawQuad(x + 3, y + h - dh, w - 6, dh, 167, 55, 39, 128)
					core.display.drawQuad(x + 3, y + h - dh, (w - 6) * lp, dh, 235, 0, 0, 255)
				end
			end
		end
	end

	-- Tactical info
	if game.level and game.level.map.view_faction then
		local map = game.level.map
		if on_map then
			if not f_self then
				f_self = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, map.faction_self)
				f_powerful = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, map.faction_powerful)
				f_danger2 = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, map.faction_danger2)
				f_danger1 = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, map.faction_danger1)
				f_friend = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, map.faction_friend)
				f_enemy = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, map.faction_enemy)
				f_neutral = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, map.faction_neutral)
			end

			if self.faction then
				local friend
				if not map.actor_player then friend = Faction:factionReaction(map.view_faction, self.faction)
				else friend = map.actor_player:reactionToward(self) end

				if self == map.actor_player then
					f_self:toScreen(x, y, w, h)
				elseif map:faction_danger_check(self) then
					if friend >= 0 then f_powerful:toScreen(x, y, w, h)
					else
						if map:faction_danger_check(self, true) then
							f_danger2:toScreen(x, y, w, h)
						else
							f_danger1:toScreen(x, y, w, h)
						end
					end
				elseif friend > 0 then
					f_friend:toScreen(x, y, w, h)
				elseif friend < 0 then
					f_enemy:toScreen(x, y, w, h)
				else
					f_neutral:toScreen(x, y, w, h)
				end
			end
		end
	end
end

local boss_rank_circles = {
	[3.2] = { back="npc/boss_indicators/rare_circle_back.png", front="npc/boss_indicators/rare_circle_front.png" },
	[3.5] = { back="npc/boss_indicators/unique_circle_back.png", front="npc/boss_indicators/unique_circle_front.png" },
	[4]   = { back="npc/boss_indicators/boss_circle_back.png", front="npc/boss_indicators/boss_circle_front.png" },
	[5]   = { back="npc/boss_indicators/elite_boss_circle_back.png", front="npc/boss_indicators/elite_boss_circle_front.png" },
	[10]   = { back="npc/boss_indicators/god_circle_back.png", front="npc/boss_indicators/god_circle_front.png" },
}

--- Attach or remove a display callback
-- Defines particles to display
function _M:defineDisplayCallback()
	if not self._mo then return end

	-- Cunning trick here!
	-- the callback we give to mo:displayCallback is a function that references self
	-- but self contains mo so it would create a cyclic reference and prevent GC'ing
	-- thus we store a reference to a weak table and put self into it
	-- this way when self dies the weak reference dies and does not prevent GC'ing
	local weak = setmetatable({[1]=self}, {__mode="v"})

	local backps = self:getParticlesList(true)
	local ps = self:getParticlesList()

	local function tactical(x, y, w, h, zoom, on_map, tlx, tly)
		local self = weak[1]
		if not self then return end

		if game.level and game.level.map.view_faction and game.always_target and game.always_target ~= "old" then
			if on_map then
				self:smallTacticalFrame(game.level.map, x, y, w, h, zoom, on_map, tlx, tly)
			end
		else
			self:bigTacticalFrame(x, y, w, h, zoom, on_map, tlx, tly)
		end

		-- Chat
		if game.level and self.can_talk then
			local map = game.level.map
			if not ichat then
				ichat = game.level.map.tilesTactic:get('', 0,0,0, 0,0,0, "speak_bubble.png")
			end

			ichat:toScreen(x + w - 8, y, 8, 8)
		end
	end

	local function particles(x, y, w, h, zoom, on_map)
		local self = weak[1]
		if not self or not self._mo then return end

		local e
		local dy = 0
		if h > w then dy = (h - w) / 2 end
		for i = 1, #ps do
			e = ps[i]
			e:checkDisplay()
			if e.ps:isAlive() then
				if game.level and game.level.map then e:shift(game.level.map, self._mo) end
				e.ps:toScreen(x + w / 2 + (e.dx or 0) * w, y + dy + h / 2 + (e.dy or 0) * h, true, w / (game.level and game.level.map.tile_w or w))
			else self:removeParticles(e)
			end
		end

		if boss_rank_circles[self.rank or 1] then
			local b = boss_rank_circles[self.rank]
			if not b.ifront then b.ifront = game.level.map.tilesTactic:get('', 0,0,0, 0,0,0, b.front) end
			b.ifront:toScreen(x, y + h - w * (0.616 - 0.5), w, w / 2)
		end
	end

	local function backparticles(x, y, w, h, zoom, on_map)
		local self = weak[1]
		if not self then return end

		local e
		local dy = 0
		if h > w then dy = (h - w) / 2 end
		for i = 1, #backps do
			e = backps[i]
			e:checkDisplay()
			if e.ps:isAlive() then e.ps:toScreen(x + w / 2 + (e.dx or 0) * w, y + dy + h / 2 + (e.dy or 0) * h, true, w / (game.level and game.level.map.tile_w or w))
			else self:removeParticles(e)
			end
		end

		if boss_rank_circles[self.rank or 1] then
			local b = boss_rank_circles[self.rank]
			if not b.iback then b.iback = game.level.map.tilesTactic:get('', 0,0,0, 0,0,0, b.back) end
			b.iback:toScreen(x, y + h - w * 0.616, w, w / 2)
		end
	end

	if self._mo == self._last_mo or not self._last_mo then
		self._mo:displayCallback(function(x, y, w, h, zoom, on_map, tlx, tly)
			tactical(tlx or x, tly or y, w, h, zoom, on_map)
			backparticles(x, y, w, h, zoom, on_map)
			particles(x, y, w, h, zoom, on_map)
			return true
		end)
	else
		self._mo:displayCallback(function(x, y, w, h, zoom, on_map, tlx, tly)
			tactical(tlx or x, tly or y, w, h, zoom, on_map)
			backparticles(x, y, w, h, zoom, on_map)
			return true
		end)
		self._last_mo:displayCallback(function(x, y, w, h, zoom, on_map)
			particles(x, y, w, h, zoom, on_map)
			return true
		end)
	end
end

function _M:move(x, y, force)
	local moved = false
	local ox, oy = self.x, self.y

	if force or self:enoughEnergy() then

		-- Confused ?
		if not force and self:attr("confused") then
			if rng.percent(self:attr("confused")) then
				x, y = self.x + rng.range(-1, 1), self.y + rng.range(-1, 1)
			end
		end
		
		-- Sleeping?  Do nothing..
		if not force and self:attr("sleep") and not self:attr("lucid_dreamer") then
			game.logPlayer(self, "You are asleep and unable to move!")	
		-- Encased in ice, attack the ice
		elseif not force and self:attr("encased_in_ice") then
			self:attackTarget(self)
			moved = true
		-- Should we prob travel through walls ?
		elseif not force and self:attr("prob_travel") and not self:attr("prob_travel_deny") and game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move", self) then
			moved = self:probabilityTravel(x, y, self:attr("prob_travel"))
			if self:attr("prob_travel_penalty") then
				local d = core.fov.distance(ox, oy, self.x, self.y)
				self:setEffect(self.EFF_PROB_TRAVEL_UNSTABLE, d * self:attr("prob_travel_penalty"), {})
			end
		-- Never move but tries to attack ? ok
		elseif not force and self:attr("never_move") then
			-- A bit weird, but this simple asks the collision code to detect an attack
			if not game.level.map:checkAllEntities(x, y, "block_move", self, true) then
				game.logPlayer(self, "You are unable to move!")
			end
		else
			moved = engine.Actor.move(self, x, y, force)
		end
		if not force and moved and (self.x ~= ox or self.y ~= oy) and not self.did_energy then
			local eff = self:hasEffect(self.EFF_CURSE_OF_SHROUDS)
			if eff then eff.moved = true end

			if self:attr("move_stamina_instead_of_energy") and self:getStamina() > self:attr("move_stamina_instead_of_energy") then
				self:incStamina(-self:attr("move_stamina_instead_of_energy"))
			else
				local speed = self:combatMovementSpeed(x, y)
				local use_energy = true
				if self:attr("walk_sun_path") then
					for i, e in ipairs(game.level.map.effects) do if e.damtype == DamageType.SUN_PATH and e.grids[x] and e.grids[x][y] then use_energy = false break end end
				end

				if use_energy then
					self:useEnergy(game.energy_to_act * speed)

					if self.reload then
						local reloaded = self:reload()
						if not reloaded and self.reloadQS then
							self:reloadQS()
						end
					end
				end

				if speed <= 0.125 and self:knowTalent(self.T_FAST_AS_LIGHTNING) then
					local t = self:getTalentFromId(self.T_FAST_AS_LIGHTNING)
					t.trigger(self, t, ox, oy)
				end
			end
		end
	end
	self.did_energy = nil

	-- Try to detect traps
	if not force then
		local t_det = self:attr("see_traps")
		if t_det then
			local grids = core.fov.circle_grids(self.x, self.y, 1, true)
			for x, yy in pairs(grids) do for y, _ in pairs(yy) do
				local trap = game.level.map(x, y, Map.TRAP)
				if trap then self:detectTrap(trap, x, y, t_det) end
			end end
		end
	end

	-- knowing Unnatural Body allows you to get the Cursed Aura tree
	if moved and self:knowTalent(self.T_UNNATURAL_BODY) and not self:knowTalentType("cursed/cursed-aura") and self.chooseCursedAuraTree then
		if self.player then
			-- function placed in defiling touch where cursing logic exists
			local t = self:getTalentFromId(self.T_DEFILING_TOUCH)
			if t.chooseCursedAuraTree(self, t) then 
				self.chooseCursedAuraTree = nil
			end
		end
	end

	if moved and self:knowTalent(self.T_DEFILING_TOUCH) then
		local t = self:getTalentFromId(self.T_DEFILING_TOUCH)
		t.curseFloor(self, t, x, y)
	end

	if moved and self:isTalentActive(self.T_BODY_OF_STONE) and not self:attr("preserve_body_of_stone") then
		self:forceUseTalent(self.T_BODY_OF_STONE, {ignore_energy=true})
	end

	-- Break channels
	if moved then
		self:breakPsionicChannel()
		self:breakSpacetimeTuning()
	end

	if not force and moved and ox and oy and (ox ~= self.x or oy ~= self.y) and self:knowTalent(self.T_LIGHT_OF_FOOT) then
		self:incStamina(self:getTalentLevelRaw(self.T_LIGHT_OF_FOOT) * 0.2)
	end

	if moved and not force and ox and oy and (ox ~= self.x or oy ~= self.y) and config.settings.tome.smooth_move > 0 then
		local blur = 0
		if game.level.data.zero_gravity then blur = 2 end
		if self:attr("lightning_speed") or self:attr("step_up") or self:attr("wild_speed") or self:hasEffect(self.EFF_HASTE) then blur = 3 end
		if self:hasEffect(self.EFF_CELERITY) then local eff = self:hasEffect(self.EFF_CELERITY) blur = eff.charges end
		self:setMoveAnim(ox, oy, config.settings.tome.smooth_move, blur, 8, config.settings.tome.twitch_move and 0.15 or 0)
		if Map.tiles and Map.tiles.use_images then if self.x < ox then self:MOflipX(self:isTileFlipped()) elseif self.x > ox then self:MOflipX(not self:isTileFlipped()) end end
	end

	if moved and not force and ox and oy and (ox ~= self.x or oy ~= self.y) and self:hasEffect(self.EFF_RAMPAGE) then
		local eff = self:hasEffect(self.EFF_RAMPAGE)
		if not eff.moved and eff.actualDuration < eff.maxDuration then
			game.logPlayer(self, "#F53CBE#Your movements fuel your rampage! (+1 duration)")
			eff.moved = true
			eff.actualDuration = eff.actualDuration + 1
			eff.dur = eff.dur + 1
		end
	end

	self:fireTalentCheck("callbackOnMove", moved, force, ox, oy, x, y)

	self:triggerHook{"Actor:move", moved=moved, force=force, ox=ox, oy=oy}

	return moved
end

--- Just wait a turn
function _M:waitTurn()
	if self.reload then
		local reloaded = self:reload()
		if not reloaded and self.reloadQS then
			self:reloadQS()
		end
	end

	-- Tune paradox up or down
	if not self:hasEffect(self.EFF_SPACETIME_TUNING) and self:knowTalent(self.T_SPACETIME_TUNING) then
		self:callTalent(self.T_SPACETIME_TUNING, "startTuning")
	end
	
	if self:knowTalent(self.T_THROWING_KNIVES) then
		local reload = self:callTalent(self.T_THROWING_KNIVES, "getReload")
		local max = self:callTalent(self.T_THROWING_KNIVES, "getNb")
		self:setEffect(self.EFF_THROWING_KNIVES, 1, {stacks=reload, max_stacks=max })
	end

	self:useEnergy()
end

--- Knock back the actor
-- Overloaded to add move anim
function _M:knockback(srcx, srcy, dist, recursive, on_terrain)
	local ox, oy = self.x, self.y
	engine.Actor.knockback(self, srcx, srcy, dist, recursive, on_terrain)
	if config.settings.tome.smooth_move > 0 then
		self:resetMoveAnim()
		self:setMoveAnim(ox, oy, 9, 5)
	end

	self:attr("knockback_times", 1)
end

--- Pull in the actor
-- Overloaded to add move anim
function _M:pull(srcx, srcy, dist, recursive)
	local ox, oy = self.x, self.y
	engine.Actor.pull(self, srcx, srcy, dist, recursive)
	if config.settings.tome.smooth_move > 0 then
		self:resetMoveAnim()
		self:setMoveAnim(ox, oy, 9, 5)
	end
end

--- Get the "path string" for this actor
-- See Map:addPathString() for more info
function _M:getPathString()
	local ps = self.open_door and "return {open_door=true,can_pass={" or "return {can_pass={"
	for what, check in pairs(self.can_pass) do
		ps = ps .. what.."="..check..","
	end
	ps = ps.."}}"
--	print("[PATH STRING] for", self.name, " :=: ", ps)
	return ps
end

--- Drop no-teleport items
function _M:dropNoTeleportObjects()
	for inven_id, inven in pairs(self.inven) do
		for item = #inven, 1, -1 do
			local o = inven[item]
			if o.no_teleport then
				self:dropFloor(inven, item, false, true)
				game.logPlayer(self, "#LIGHT_RED#Your %s is immune to the teleportation and drops to the floor!", o:getName{do_color=true})
			end
		end
	end
end

--- Blink through walls
function _M:probabilityTravel(x, y, dist, checker, ignore_no_teleport)
	if game.zone.wilderness then return true end
	if self:attr("encased_in_ice") then return end

	local dirx, diry = x - self.x, y - self.y
	local tx, ty = x, y
	while game.level.map:isBound(tx, ty) and game.level.map:checkAllEntities(tx, ty, "block_move", self) and dist > 0 do
		if not ignore_no_teleport and game.level.map.attrs(tx, ty, "no_teleport") then break end
		if game.level.map:checkAllEntities(tx, ty, "no_prob_travel", self) then break end
		if checker and checker(tx, ty) then break end
		tx = tx + dirx
		ty = ty + diry
		dist = dist - 1
	end
	if game.level.map:isBound(tx, ty) and not game.level.map:checkAllEntities(tx, ty, "block_move", self) and (ignore_no_teleport or not game.level.map.attrs(tx, ty, "no_teleport")) then
		self:dropNoTeleportObjects()
		return engine.Actor.move(self, tx, ty, false)
	end
	return true
end

--- Teleports randomly to a passable grid
-- @param x the coord of the teleportation
-- @param y the coord of the teleportation
-- @param dist the radius of the random effect, if set to 0 it is a precise teleport
-- @param min_dist the minimum radius of of the effect, will never teleport closer. Defaults to 0 if not set
-- @return true if the teleport worked
function _M:teleportRandom(x, y, dist, min_dist)
	-- can we teleport?
	if self:attr("encased_in_ice") then return end
	if self:attr("cant_teleport") then return end
	if self:hasEffect(self.EFF_DIMENSIONAL_ANCHOR) then self:callEffect(self.EFF_DIMENSIONAL_ANCHOR, "onTeleport") return end
	
	-- Special teleport handlers
	if game.level.data.no_teleport_south and y + dist > self.y then
		y = self.y - math.ceil(dist)
	end
	
	-- For precise teleports look for a free grid first
	-- This helps the AI use precision teleporting more effectively and is a nice quality of life hack for the player
	if dist == 0 then
		x, y = util.findFreeGrid(x, y, 5, true, {[Map.ACTOR]=true})	
	end
	if not x or not y then return end
	
	-- Store our old x, y to pass to our callback
	local ox, oy = self.x, self.y

	-- Try to teleport
	local poss = {}
	local teleported
	dist = math.floor(dist)
	min_dist = math.floor(min_dist or 0)

	-- Find possible locations
	for i = x - dist, x + dist do
		for j = y - dist, y + dist do
			if game.level.map:isBound(i, j) and	core.fov.distance(x, y, i, j) <= dist and core.fov.distance(x, y, i, j) >= min_dist and	self:canMove(i, j) then
				-- Check for no_teleport and vaults
				if game.level.map.attrs(i, j, "no_teleport") then
					local vault = game.level.map.attrs(self.x, self.y, "vault_id")
					if vault and game.level.map.attrs(i, j, "vault_id") == vault then
						poss[#poss+1] = {i,j}
					end
				else
					poss[#poss+1] = {i,j}
				end
			end
		end
	end

	-- If we find valid locations, pick one at random
	if #poss > 0 then
		-- prior to moving
		self:dropNoTeleportObjects()
	
		-- Teleport
		local pos = poss[rng.range(1, #poss)]
		self:move(pos[1], pos[2], true)
		teleported = true
		
		if self.runStop then self:runStop("teleported") end
		if self.restStop then self:restStop("teleported") end
		
		-- after moving
		if self:attr("defense_on_teleport") or self:attr("resist_all_on_teleport") or self:attr("effect_reduction_on_teleport") then
			self:setEffect(self.EFF_OUT_OF_PHASE, 5, {defense=self:attr("defense_on_teleport") or 0, resists=self:attr("resist_all_on_teleport") or 0, effect_reduction=self:attr("effect_reduction_on_teleport") or 0})
		end
	end
	
	self:fireTalentCheck("callbackOnTeleport", teleported, ox, oy, self.x, self.y)

	return teleported
end

--- Quake a zone
-- Moves randomly each grid to an other grid
function _M:doQuake(tg, x, y)
	local typ = require("engine.Target"):getType(tg)
	return game.zone:doQuake(typ.ball or 1, x, y, function(tx, ty)
		return not game.level.map.attrs(tx, ty, "no_teleport") and not game.level.map:checkAllEntities(tx, ty, "change_level") and game.level.map(tx, ty, Map.TERRAIN) and (game.level.map(tx, ty, Map.TERRAIN).dig or game.level.map(tx, ty, Map.TERRAIN).grow)
	end)
end

--- Attempt to detect a trap at x, y
-- param (optional) trap the trap to be detected (defaults to trap at coords)
-- param (optional) x, y trap coordinates (defaults to trap.x, trap.y)
-- param (optional) power detection power
-- @return the trap @ x, y if present and detected
function _M:detectTrap(trap, x, y, power)
	trap = trap or game.level.map(x, y, Map.TRAP)
	if trap then
		power = power or self:attr("see_traps") or 0
		if power <= 0 then return end
		x, y = x or trap.x, y or trap.y
		local known = trap:knownBy(self)
		if not known then
			if self == trap.summoner and known == nil then trap:setKnown(self, true, x, y) return end
			known = self:canSee(trap) and self:checkHit(power, trap.detect_power)
			if known then 
				trap:setKnown(self, true, x, y)
				if self.player then
					game.level.map:updateMap(x, y)
					game.logPlayer(self, "#CADET_BLUE#You notice a trap (%s)!", trap:getName())
				end
			end
		end
		return known and trap
	end
end

--- Reveals location surrounding the actor
function _M:magicMap(radius, x, y, checker)
	x = x or self.x
	y = y or self.y
	radius = math.floor(radius)

	local ox, oy

	self.x, self.y, ox, oy = x, y, self.x, self.y
	self:computeFOV(radius, "block_sense", function(x, y)
		if not checker or checker(x, y) then
			game.level.map.remembers(x, y, true)
		end
	end, true, true, true)

	self.x, self.y = ox, oy
end

--- What is our reaction toward the target
-- This can modify faction reaction using specific actor to actor reactions
function _M:reactionToward(target, no_reflection)
	local rsrc, rtarget = self, target
	while rsrc.summoner do rsrc = rsrc.summoner end
	while rtarget.summoner do rtarget = rtarget.summoner end
	if rsrc == target and self ~= target and target:attr("encased_in_ice") then return -50 end  -- summons shouldn't hate each other and shouldn't hate summoner more than enemies

	-- Neverending hatred
	if rtarget.attr and rtarget:attr("hated_by_everybody") and rtarget ~= rsrc then return -100 end
	if rsrc.attr and rsrc:attr("hates_everybody") and rtarget ~= rsrc then return -100 end
	if rsrc.attr and rtarget.attr and rsrc:attr("hates_arcane") and rtarget:attr("has_arcane_knowledge") and not rtarget:attr("forbid_arcane") then return -100 end
	if rsrc.attr and rtarget.attr and rsrc:attr("hates_antimagic") and rtarget:attr("forbid_arcane") then return -100 end

	local v = engine.Actor.reactionToward(rsrc, rtarget)

	if rsrc.reaction_actor and rsrc.reaction_actor[rtarget.unique or rtarget.name] then v = v + rsrc.reaction_actor[rtarget.unique or rtarget.name] end

	-- Take the lowest of the two just in case
	if not no_reflection and target.reactionToward then v = math.min(v, target:reactionToward(self, true)) end

	return util.bound(v, -100, 100)
end

function _M:incMoney(v)
	if self.summoner then self = self.summoner end
	self.money = self.money + v
	if self.money < 0 then self.money = 0 end
	self.changed = true

	if self.player then
		world:gainAchievement("TREASURE_HUNTER", self)
		world:gainAchievement("TREASURE_HOARDER", self)
		world:gainAchievement("DRAGON_GREED", self)
		if v >= 0 then game:playSound("actions/coins")
		else game:playSound("actions/coins_less") end
	end
end

function _M:getRankStatAdjust()
	if self.rank == 1 then return -1
	elseif self.rank == 2 then return -0.5
	elseif self.rank == 3 then return 0
	elseif self.rank == 3.2 then return 0.5
	elseif self.rank == 3.5 then return 1
	elseif self.rank == 4 then return 1
	elseif self.rank == 5 then return 1
	elseif self.rank >= 10 then return 2.5
	else return 0
	end
end

function _M:getRankLevelAdjust()
	if self.rank == 1 then return -1
	elseif self.rank == 2 then return 0
	elseif self.rank == 3 then return 1
	elseif self.rank == 3.2 then return 1
	elseif self.rank == 3.5 then return 2
	elseif self.rank == 4 then return 3
	elseif self.rank == 5 then return 4
	elseif self.rank >= 10 then return 8
	else return 0
	end
end

function _M:getRankVimAdjust()
	if self.rank == 1 then return 0.7
	elseif self.rank == 2 then return 1
	elseif self.rank == 3 then return 1.2
	elseif self.rank == 3.2 then return 1.2
	elseif self.rank == 3.5 then return 2.2
	elseif self.rank == 4 then return 2.6
	elseif self.rank == 5 then return 2.8
	elseif self.rank >= 10 then return 6
	else return 0
	end
end

function _M:getRankLifeAdjust(value)
	local level_adjust = 1 + self.level / 40
	if self.rank == 1 then return value * (level_adjust - 0.2)
	elseif self.rank == 2 then return value * (level_adjust - 0.1)
	elseif self.rank == 3 then return value * (level_adjust + 0.1)
	elseif self.rank == 3.2 then return value * (level_adjust + 0.15)
	elseif self.rank == 3.5 then return value * (level_adjust + 1)
	elseif self.rank == 4 then return value * (level_adjust + 2)
	elseif self.rank == 5 then return value * (level_adjust + 3)
	elseif self.rank >= 10 then return value * (level_adjust + 6)
	else return 0
	end
end

function _M:getRankResistAdjust()
	if self.rank == 1 then return 0.4, 0.9
	elseif self.rank == 2 then return 0.5, 1.5
	elseif self.rank == 3 then return 0.8, 1.5
	elseif self.rank == 3.2 then return 0.8, 1.5
	elseif self.rank == 3.5 then return 0.9, 1.5
	elseif self.rank == 4 then return 0.9, 1.5
	elseif self.rank == 5 then return 0.9, 1.5
	elseif self.rank >= 10 then return 2.5, 3.5
	else return 0
	end
end

function _M:getRankSaveAdjust()
	if self.rank == 1 then return 0.6, 0.9
	elseif self.rank == 2 then return 1, 1.5
	elseif self.rank == 3 then return 1.3, 1.8
	elseif self.rank == 3.2 then return 1.3, 1.8
	elseif self.rank == 3.5 then return 1.5, 2
	elseif self.rank == 4 then return 1.7, 2.1
	elseif self.rank == 5 then return 1.9, 2.3
	elseif self.rank >= 10 then return 2.8, 3.5
	else return 0
	end
end

function _M:allowedRanks()
	return { 1, 2, 3, 3.2, 3.5, 4, 5, 10 }
end

function _M:TextRank()
	local rank, color = "normal", "#ANTIQUE_WHITE#"
	if self.rank == 1 then rank, color = "critter", "#C0C0C0#"
	elseif self.rank == 2 then rank, color = "normal", "#ANTIQUE_WHITE#"
	elseif self.rank == 3 then rank, color = "elite", "#YELLOW#"
	elseif self.rank == 3.2 then rank, color = "rare", "#SALMON#"
	elseif self.rank == 3.5 then rank, color = "unique", "#SANDY_BROWN#"
	elseif self.rank == 4 then rank, color = "boss", "#ORANGE#"
	elseif self.rank == 5 then rank, color = "elite boss", "#GOLD#"
	elseif self.rank >= 10 then rank, color = "god", "#FF4000#"
	end
	return rank, color
end

function _M:TextSizeCategory()
	local sizecat = "medium"
	if self.size_category <= 1 then sizecat = "tiny"
	elseif self.size_category == 2 then sizecat = "small"
	elseif self.size_category == 3 then sizecat = "medium"
	elseif self.size_category == 4 then sizecat = "big"
	elseif self.size_category == 5 then sizecat = "huge"
	elseif self.size_category >= 6 then sizecat = "gargantuan"
	end
	return sizecat
end

function _M:colorStats(stat)
	local score = 0
	if stat == "combatDefense" or stat == "combatPhysicalResist" or stat == "combatSpellResist" or stat == "combatMentalResist" then
		score = math.floor(self[stat](self, true))
	else
		score = math.floor(self[stat](self))
	end

	if score <= 9 then
		return "#B4B4B4# "..score
	elseif score <= 20 then
		return "#B4B4B4#"..score
	elseif score <= 40 then
		return "#FFFFFF#"..score
	elseif score <= 60 then
		return "#00FF80#"..score
	elseif score <= 80 then
		return "#0080FF#"..score
	elseif score <= 99 then
		return "#8d55ff#"..score
	elseif score >= 100 then
		return "#8d55ff#"..score  -- Enable longer numbers
	end
end

function _M:tooltip(x, y, seen_by)
	if seen_by and not seen_by:canSee(self) then return end
	local factcolor, factstate, factlevel = "#ANTIQUE_WHITE#", "neutral", Faction:factionReaction(self.faction, game.player.faction)
	if factlevel < 0 then factcolor, factstate = "#LIGHT_RED#", "hostile"
	elseif factlevel > 0 then factcolor, factstate = "#LIGHT_GREEN#", "friendly"
	end

	-- Debug feature, mousing over with ctrl pressed will give detailed FOV info
	if config.settings.cheat and core.key.modState("ctrl") then
		print("============================================== SEEING from", self.name)
		for i, a in ipairs(self.fov.actors_dist) do
			local d = self.fov.actors[a]
			if d then
				print(("%3d : %-40s at %3dx%3d (see at %3dx%3d), diff %3dx%3d"):format(d.sqdist, a.name, a.x, a.y, d.x, d.y,d.dx,d.dy))
			end
		end
		print("==============================================")
	end

	local pfactcolor, pfactstate, pfactlevel = "#ANTIQUE_WHITE#", "neutral", self:reactionToward(game.player)
	if pfactlevel < 0 then pfactcolor, pfactstate = "#LIGHT_RED#", "hostile"
	elseif pfactlevel > 0 then pfactcolor, pfactstate = "#LIGHT_GREEN#", "friendly"
	end

	local rank, rank_color = self:TextRank()

	local ts = tstring{}
	ts:add({"uid",self.uid}) ts:merge(rank_color:toTString()) ts:add(npcCHN:getName(self.name), {"color", "WHITE"})
	if self.type == "humanoid" or self.type == "giant" then ts:add({"font","italic"}, "(", self.female and "female" or "male", ")", {"font","normal"}, true) else ts:add(true) end
	ts:add(self.type:capitalize(), " / ", self.subtype:capitalize(), true)
	ts:add("Rank: ") ts:merge(rank_color:toTString()) ts:add(rank, {"color", "WHITE"}, true)
	if self.hide_level_tooltip then ts:add({"color", 0, 255, 255}, "Level: unknown", {"color", "WHITE"}, true)
	else ts:add({"color", 0, 255, 255}, ("Level: %d"):format(self.level), {"color", "WHITE"}, true) end
	if self:attr("invulnerable") then ts:add({"color", "PURPLE"}, "INVULNERABLE!", true) end
	ts:add({"color", 255, 0, 0}, ("HP: %d (%d%%)"):format(self.life, self.life * 100 / self.max_life), {"color", "WHITE"})

	if self:knowTalent(self.T_SOLIPSISM) then
		local psi_percent = 100*self.psi/self.max_psi
		ts:add((("#7fffd4# / %d")):format(self.psi), (" (%d%%)"):format(psi_percent),{"color", "WHITE"})
	end
	ts:add(true)
	if self:attr("encased_in_ice") then
		local eff = self:hasEffect(self.EFF_FROZEN)
		ts:add({"color", 0, 255, 128}, ("Iceblock: %d"):format(eff.hp), {"color", "WHITE"}, true)
	end
	--ts:add(("Stats: %d / %d / %d / %d / %d / %d"):format(self:getStr(), self:getDex(), self:getCon(), self:getMag(), self:getWil(), self:getCun()), true)
	--if #resists > 0 then ts:add("Resists: ", table.concat(resists, ','), true) end

	local resists = tstring{}
	local first = true
	ts:add({"color", "ANTIQUE_WHITE"}, "Resists: ")
	for t, v in pairs(self.resists) do
		if t == "all" or t == "absolute" then
			if first then first = false else ts:add(", ") end
			ts:add({"color", "LIGHT_BLUE"}, tostring(math.floor(v)) .. "%", " ", {"color", "LAST"}, t..", ")
		elseif type(t) == "string" and math.abs(v) >= 20 then
			local res = tostring ( math.floor(self:combatGetResist(t)) ) .. "%"
			if first then first = false else ts:add(", ") end
			if v > 0 then
				ts:add({"color", "LIGHT_GREEN"}, res, " ", {"color", "LAST"}, DamageType:get(t).name, ", ")
			else
				ts:add({"color", "LIGHT_RED"}, res, " ", {"color", "LAST"}, DamageType:get(t).name, ", ")
			end
		end
	end
	if self:attr("speed_resist") then
		local res = 100 - (util.bound(self.global_speed * self.movement_speed, (100-(self.speed_resist_cap or 70))/100, 1)) * 100
		if res > 0 then
			ts:add({"color", "LIGHT_GREEN"}, tostring(math.floor(res)).."%", " ", {"color", "SALMON"}, "from speed", {"color", "LAST"})
		end
	end
	if ts[#ts] == ", " then table.remove(ts) end
	ts:add(true)

	ts:add("Hardiness/Armour: ", tostring(math.floor(self:combatArmorHardiness())), '% / ', tostring(math.floor(self:combatArmor())), true)
	ts:add("Size: ", {"color", "ANTIQUE_WHITE"}, self:TextSizeCategory(), {"color", "WHITE"}, true)

	ts:add("#FFD700#Accuracy#FFFFFF#: ", self:colorStats("combatAttack"), "  ")
	ts:add("#0080FF#Defense#FFFFFF#:  ", self:colorStats("combatDefense"), true)
	ts:add("#FFD700#P. power#FFFFFF#: ", self:colorStats("combatPhysicalpower"), "  ")
	ts:add("#0080FF#P. save#FFFFFF#:  ", self:colorStats("combatPhysicalResist"), true)
	ts:add("#FFD700#S. power#FFFFFF#: ", self:colorStats("combatSpellpower"), "  ")
	ts:add("#0080FF#S. save#FFFFFF#:  ", self:colorStats("combatSpellResist"), true)
	ts:add("#FFD700#M. power#FFFFFF#: ", self:colorStats("combatMindpower"), "  ")
	ts:add("#0080FF#M. save#FFFFFF#:  ", self:colorStats("combatMentalResist"), true)
	ts:add({"color", "WHITE"})

	if (150 + (self.combat_critical_power or 0) ) > 150 then
		ts:add("Critical Mult: ", ("%d%%"):format(150 + (self.combat_critical_power or 0) ), true )
	end

	if self.summon_time then
		ts:add("Time left: ", {"color", "ANTIQUE_WHITE"}, ("%d"):format(self.summon_time), {"color", "WHITE"}, true)
	end

	if self:getInven("MAINHAND") and self:getInven("MAINHAND").worn and self:getInven("MAINHAND")[1] and self:getInven("MAINHAND")[1].keywords then
		ts:add("武器关键字: ", {"color", "RED"})
		local keywords = tstring{}
		local archery = self:getInven("MAINHAND")[1].archery or false


		for k, v in pairs(self:getInven("MAINHAND")[1].keywords) do
			local key=tostring(k)
			key=keyCHN[key] or key
			ts:add(key, ", " )
		end

		if self:getInven("OFFHAND") and self:getInven("OFFHAND").worn and self:getInven("OFFHAND")[1] and self:getInven("OFFHAND")[1].keywords then
			for k, v in pairs(self:getInven("OFFHAND")[1].keywords) do
				local key=tostring(k)
				key=keyCHN[key] or key
				ts:add(key, ", " )
			end
		end

		if archery and self:getInven("QUIVER") and self:getInven("QUIVER").worn and self:getInven("QUIVER")[1] and self:getInven("QUIVER")[1].keywords then
			for k, v in pairs(self:getInven("QUIVER")[1].keywords) do
				local key=tostring(k)
				key=keyCHN[key] or key
				ts:add(key, ", " )
			end
		end

		if ts[#ts] == ", " then table.remove(ts) end
		ts:add({"color", "LAST"}, true)
	end

	ts:add({"color", "WHITE"})
	local retal = 0
	for k, v in pairs(self.on_melee_hit) do
		if type(v) == "number" then retal = retal + v
		elseif type(v) == "table" and type(v.dam) == "number" then retal = retal + v.dam
		end
	end

	if retal > 0 then ts:add("Melee Retaliation: ", {"color", "RED"}, tostring(math.floor(retal)), {"color", "WHITE"}, true ) end

	--if self.desc then ts:add(self.desc, true) end
	if self.desc then
		if npcCHN:getDesc(self.name, self.desc) then
			ts:add(cutChrCHN(npcCHN:getDesc(self.name, self.desc),19), true)
		else	ts:add(self.desc, true)
		end
	end
	if config.settings.cheat and self.descriptor and self.descriptor.classes then
		ts:add("Classes:", table.concat(self.descriptor.classes or {}, ","), true)
	end

	if self.custom_tooltip then
		local cts = self:custom_tooltip():toTString()
		if cts then
			ts:merge(cts)
			ts:add(true)
		end
	end

	if self.faction and Faction.factions[self.faction] then ts:add("Faction: ") ts:merge(factcolor:toTString()) ts:add(("%s (%s, %d)"):format(Faction.factions[self.faction].name, factstate, factlevel), {"color", "WHITE"}, true) end
	if game.player ~= self then ts:add("Personal reaction: ") ts:merge(pfactcolor:toTString()) ts:add(("%s, %d"):format(pfactstate, pfactlevel), {"color", "WHITE"} ) end

	ts:add(true, {"color", "ORANGE"}, "Sustained Talents: ",{"color", "WHITE"})
	for tid, act in pairs(self.sustain_talents) do
		if act then ts:add(true, "- ", {"color", "LIGHT_GREEN"}, self:getTalentFromId(tid) and self:getTalentFromId(tid).name or "???", {"color", "WHITE"} ) end
	end
	if ts[#ts-1] == "Sustained Talents: " then table.remove(ts) table.remove(ts) table.remove(ts) table.remove(ts) end

	ts:add(true, {"color", "ORANGE"}, "Temporary Status Effects: ",{"color", "WHITE"})

	local effmental = tstring{}
	local effphysical = tstring{}
	local effmagical = tstring{}
	local effother = tstring{}
	local effbeneficial = tstring{}

	local desceffect = function(e, p, dur)
		local dur = e.decrease > 0 and dur or nil
		local charges = nil
		if e.charges then charges = e.charges and tostring(e.charges(self, p)) end
		
		--汉化
		local desc
			if effCHN[e.name] then 
				desc = effCHN[e.name].chName
			else desc = e.desc
		end
		
		if dur and charges then return ("%s(%d, %s)"):format(desc, dur, charges)
		elseif dur and not charges then return ("%s(%d)"):format(desc, dur)
		elseif not dur and charges then return ("%s(%s)"):format(desc, charges)
		else return desc end
	end

	for eff_id, p in pairs(self.tmp) do
		local e = self.tempeffect_def[eff_id]
		local dur = p.dur + 1
		if e.status == "detrimental" then
			if e.type == "physical" then
				effphysical:add(true, "- ", {"color", "LIGHT_RED"}, desceffect(e, p, dur), {"color", "WHITE"} )
			elseif e.type == "magical" then
				effmagical:add(true, "- ", {"color", "DARK_ORCHID"}, desceffect(e, p, dur), {"color", "WHITE"} )
			elseif e.type == "mental" then
				effmental:add(true, "- ", {"color", "YELLOW"}, desceffect(e, p, dur), {"color", "WHITE"} )
			elseif e.type == "other" then
				effother:add(true, "- ", {"color", "ORCHID"}, desceffect(e, p, dur), {"color", "WHITE"} )
			else
				ts:add(true, "- ", {"color", "LIGHT_RED"}, desceffect(e, p, dur), {"color", "WHITE"} )
			end
		else
			effbeneficial:add(true, "- ", {"color", "LIGHT_GREEN"}, desceffect(e, p, dur), {"color", "WHITE"} )
		end
	end

	ts:merge(effphysical)
	ts:merge(effmental)
	ts:merge(effmagical)
	ts:merge(effother)
	ts:merge(effbeneficial)

	if ts[#ts-1] == "Temporary Status Effects: " then table.remove(ts) table.remove(ts) table.remove(ts) table.remove(ts) end

	return getTooltipActorCHN(ts)
end

--- Regenerate life, call it from your actor class act() method
function _M:regenLife()
	if self.life_regen then
		local regen = self.life_regen * util.bound((self.healing_factor or 1), 0, 2.5)

		-- Solipsism
		if self:knowTalent(self.T_SOLIPSISM) then
			local t = self:getTalentFromId(self.T_SOLIPSISM)
			local ratio = t.getConversionRatio(self, t)
			local psi_increase = regen * ratio
			self:incPsi(psi_increase)
			-- Quality of life hack, doesn't decrease life regen while resting..  was way to painful
			if not self.resting then
				regen = regen - psi_increase
			end
		end

		if not self:attr("no_life_regen") then
			self.life = util.bound(self.life + regen, self.die_at, self.max_life)

			-- Blood Lock
			if self:attr("blood_lock") then
				self.life = util.bound(self.life, self.die_at, self:attr("blood_lock"))
			end
		end
	end
end

function _M:regenAmmo()
	local ammo = self:hasAmmo()
	local r = (ammo and ammo.combat and ammo.combat.ammo_every)
	if not r then return end
	if ammo.combat.shots_left >= ammo.combat.capacity then ammo.combat.shots_left = ammo.combat.capacity return end
	ammo.combat.reload_counter = (ammo.combat.reload_counter or 0) + 1
	if ammo.combat.reload_counter >= r then
		ammo.combat.reload_counter = 0
		ammo.combat.shots_left = util.bound(ammo.combat.shots_left + 1, 0, ammo.combat.capacity)
	end
end

--- Called before healing
function _M:onHeal(value, src)
	local raw_value = value
	value = value * util.bound((self.healing_factor or 1), 0, 2.5)
	
	for cb in self:iterCallbacks("callbackOnHeal") do
		local ret = cb(value, src, raw_value)
		if ret then
			raw_value = ret.raw_value or raw_value*ret.value/value
			value = ret.value
		end
	end

	-- Solipsism: divert some healing to psi
	local psi_heal = 0
	if self:knowTalent(self.T_SOLIPSISM) then
		local ratio = self:callTalent(self.T_SOLIPSISM, "getConversionRatio")
		psi_heal = value * ratio
		self:incPsi(psi_heal)
		value = value - psi_heal
		raw_value = raw_value*(1 - ratio)
	end

	if self:attr("no_healing") or self:hasEffect(self.EFF_UNSTOPPABLE) then return 0 end

	if self:attr("arcane_shield") and self:attr("allow_on_heal") and value > 0 then
		self:setEffect(self.EFF_DAMAGE_SHIELD, 3, {power=value * self.arcane_shield / 100})
	end

	if self:attr("fungal_growth") and self:attr("allow_on_heal") and value > 0 and not self:hasEffect(self.EFF_REGENERATION) then
		self:setEffect(self.EFF_REGENERATION, 6, {power=(value * self.fungal_growth / 100) / 6, no_wild_growth=true})
	end

	-- Must be last!
	if self:attr("blood_lock") then
		if self.life + value > self:attr("blood_lock") then
			value = math.max(0, self:attr("blood_lock") - self.life)
		end
	end
	
--	print("[HEALING]", self.uid, self.name, "for", value)
	if (not self.resting and (not game.party:hasMember(self) or not game:getPlayer(true).resting)) and value + psi_heal >= 1 and not self:attr("silent_heal") then
		if game.level.map.seens(self.x, self.y) then
			local sx, sy = game.level.map:getTileToScreen(self.x, self.y, true)
			game.flyers:add(sx, sy, 30, rng.float(-3, -2), (rng.range(0,2)-1) * 0.5, tostring(math.ceil(value)), {255,255,0})
		end
		if psi_heal > 0 then
			game:delayedLogDamage(src or self, self, -value-psi_heal, ("#LIGHT_GREEN#%d healing #LAST##AQUAMARINE#(%d psi heal)#LAST#"):format(value, psi_heal), false)
		else
			game:delayedLogDamage(src or self, self, -value, ("#LIGHT_GREEN#%d healing#LAST#"):format(value), false)
		end
	end
	return value
end

--- Called before taking a hit, it's the chance to check for shields
function _M:onTakeHit(value, src, death_note)
	src = src or {}
	if value <=0 then return 0 end
	local tal
	-- update hate_baseline
	if self.knowTalent and self:knowTalent(self.T_HATE_POOL) then
		local t = self:getTalentFromId(self.T_HATE_POOL)
		t.updateBaseline(self, t)
	end
	if src and src.knowTalent and src:knowTalent(src.T_HATE_POOL) then
		local t = src:getTalentFromId(src.T_HATE_POOL)
		t.updateBaseline(src, t)
	end

	-- Un-daze
	if self:hasEffect(self.EFF_DAZED) and not self:attr("damage_dont_undaze") then
		self:removeEffect(self.EFF_DAZED)
	end

	if self:isTalentActive(self.T_SUSPENDED) then
		self:forceUseTalent(self.T_SUSPENDED, {ignore_energy=true})
	end

	-- Remove domination hex
	if self:hasEffect(self.EFF_DOMINATION_HEX) and src and src == self:hasEffect(self.EFF_DOMINATION_HEX).src then
		self:removeEffect(self.EFF_DOMINATION_HEX)
	end

	if self:attr("invulnerable") then
		return 0
	end
	if self:attr("invulnerable_others") and src ~= self then
		return 0
	end

	if self:attr("cancel_damage_chance") and rng.percent(self.cancel_damage_chance) then
		if self:knowTalent(self.T_TEMPO) then
			local t = self:getTalentFromId(self.T_TEMPO)
			t.do_tempo(self, t)
		end
		return 0
	end

	if self:attr("phase_shift") and rng.percent(self:attr("phase_shift") * 100) and not self.turn_procs.phase_shift then
		self.turn_procs.phase_shift = true
		local nx, ny = util.findFreeGrid(self.x, self.y, 1, true, {[Map.ACTOR]=true})
		if nx then
			local ox, oy = self.x, self.y
			self:move(nx, ny, true)
			game.level.map:particleEmitter(ox, oy, math.max(math.abs(nx-ox), math.abs(ny-oy)), "lightning", {tx=nx-ox, ty=ny-oy})
			game:delayedLogDamage(src or {}, self, 0, ("#STEEL_BLUE#(%d shifted)#LAST#"):format(value), nil)
			return 0
		end
	end

	if self:attr("retribution") then
	-- Absorb damage into the retribution
		local absorb = math.min(value/2, self.retribution_absorb)
		game:delayedLogDamage(src, self, 0, ("#SLATE#(%d absorbed)#LAST#"):format(absorb), false)
		if absorb < self.retribution_absorb then
			self.retribution_absorb = self.retribution_absorb - absorb
			value = value - absorb
		else
			value = value - self.retribution_absorb
			self.retribution_absorb = 0
			local dam = self.retribution_strike

			-- Deactivate without loosing energy
			self:forceUseTalent(self.T_RETRIBUTION, {ignore_energy=true, ignore_cd=true})
			self:startTalentCooldown(self.T_RETRIBUTION)

			-- Explode!
			game.logSeen(self, "%s unleashes the stored damage in retribution!", self.name:capitalize())
			local tg = {type="ball", range=0, radius=self:getTalentRange(self:getTalentFromId(self.T_RETRIBUTION)), selffire=false, talent=t}
			local grids = self:project(tg, self.x, self.y, DamageType.LIGHT, dam)
			game.level.map:particleEmitter(self.x, self.y, tg.radius, "sunburst", {radius=tg.radius, grids=grids, tx=self.x, ty=self.y})
		end
	end

	--Special Flag (for older versions of Terrasca)
	if value > 0 and self:attr("speed_resist") then
		value = value * (util.bound(self.global_speed * self.movement_speed, 0.3, 1))
	end

	-- General percent damage reduction
	if self:attr("incoming_reduce") then
		value = value * (100-self:attr("incoming_reduce")) / 100
		print("[onTakeHit] After Trained Reactions effect reduction ", value)
	end

	if self:knowTalent(self.T_SKIRMISHER_TRAINED_REACTIONS) then
		local t = self:getTalentFromId(self.T_SKIRMISHER_TRAINED_REACTIONS)
		if self:isTalentActive(t.id) then
			value = t.onHit(self, t, value)
			print("[onTakeHit] After Trained Reactions life% trigger ", value)
		end
	end

	if value > 0 and self:knowTalent(self.T_MITOSIS) and self:isTalentActive(self.T_MITOSIS) then
		local t = self:getTalentFromId(self.T_MITOSIS)
		local chance = t.getChance(self, t)
		local perc = math.min(1, 3 * value / self.life)
		if rng.percent(chance * perc) then
			t.spawn(self, t, value * 2)
		end

		local acts = {}
		if game.party:hasMember(self) then
			for act, def in pairs(game.party.members) do
				if act.summoner and act.summoner == self and act.wild_gift_summon and act.bloated_ooze then acts[#acts+1] = act end
			end
		else
			for _, act in pairs(game.level.entities) do
				if act.summoner and act.summoner == self and act.wild_gift_summon and act.bloated_ooze then acts[#acts+1] = act end
			end
		end
		if #acts > 0 then
			game:delayedLogMessage(self, nil, "mitosis_damage", "#DARK_GREEN##Source# shares damage with %s oozes!", string.his_her(self))
			value = value / (#acts+1)
			for _, act in ipairs(acts) do
				act:takeHit(value, src)
			end
		end
	end

	if value > 0 and self:attr("displacement_shield") then
		-- Absorb damage into the displacement shield
		if rng.percent(self.displacement_shield_chance) then
			game:delayedLogMessage(self, src,  "displacement_shield"..(self.displacement_shield_target.uid or ""), "#CRIMSON##Source# teleports some damage to #Target#!")
			local displaced = math.min(value, self.displacement_shield)
			self.displacement_shield_target:takeHit(displaced, src)
			game:delayedLogDamage(src, self, 0, ("#CRIMSON#(%d teleported)#LAST#"):format(displaced), false)
			game:delayedLogDamage(src, self.displacement_shield_target, displaced, ("#CRIMSON#%d teleported#LAST#"):format(displaced), false)
			if self.displacement_shield and displaced < self.displacement_shield then
				self.displacement_shield = self.displacement_shield - displaced
				value = 0
			else
				self:removeEffect(self.EFF_DISPLACEMENT_SHIELD)
				value = value - displaced
			end
		end
	end

	if value > 0 and self:attr("time_shield") then
		-- Absorb damage into the time shield
		self.time_shield_absorb = self.time_shield_absorb or 0
		game:delayedLogDamage(src, self, 0, ("#STEEL_BLUE#(%d to time)#LAST#"):format(math.min(value, self.time_shield_absorb)), false)
		if value < self.time_shield_absorb then
			self.time_shield_absorb = self.time_shield_absorb - value
			value = 0
		else
			value = value - self.time_shield_absorb
			self.time_shield_absorb = 0
		end

		-- If we are at the end of the capacity, release the time shield damage
		if self.time_shield_absorb <= 0 then
			game.logPlayer(self, "Your time shield crumbles under the damage!")
			self:removeEffect(self.EFF_TIME_SHIELD)
		end
	end

	if value > 0 and self:attr("damage_shield") then
		-- Phased attack?
		local adjusted_value = value
		if src and src.attr and src:attr("damage_shield_penetrate") then
			adjusted_value = value * (1 - (util.bound(src.damage_shield_penetrate, 0, 100) / 100))
		end
		-- Shield Reflect?
		local reflection, reflect_damage = 0
		if self:attr("damage_shield_reflect") then
			reflection = self:attr("damage_shield_reflect")/100
		end
		-- Absorb damage into the shield
		self.damage_shield_absorb = self.damage_shield_absorb or 0
		if adjusted_value <= self.damage_shield_absorb then
			self.damage_shield_absorb = self.damage_shield_absorb - adjusted_value
			if reflection > 0 then reflect_damage = adjusted_value end
			value = value - adjusted_value
		else
			if reflection > 0 then reflect_damage = self.damage_shield_absorb end
			value = adjusted_value - self.damage_shield_absorb
			adjusted_value = self.damage_shield_absorb
			self.damage_shield_absorb = 0
		end
		game:delayedLogDamage(src, self, 0, ("#SLATE#(%d absorbed)#LAST#"):format(adjusted_value), false)
		if reflection and reflect_damage and reflection > 0 and reflect_damage > 0 and src.y and src.x and not src.dead then
			local a = game.level.map(src.x, src.y, Map.ACTOR)
			if a and self:reactionToward(a) < 0 then
				local reflected = reflect_damage * reflection
				a:takeHit(reflected, self)
				game:delayedLogDamage(self, src, reflected, ("#SLATE#%d reflected#LAST#"):format(reflected), false)
				game:delayedLogMessage(self, src, "reflection" ,"#CRIMSON##Source# reflects damage back to #Target#!#LAST#")
			end
		end

		local eff = self:hasEffect(self.EFF_DAMAGE_SHIELD)
		if adjusted_value > 0 and eff and eff.on_absorb then
			eff.on_absorb(self, eff, src, adjusted_value)
		end

		-- If we are at the end of the capacity, release the time shield damage
		if not self.damage_shield_absorb or self.damage_shield_absorb <= 0 then
			game.logPlayer(self, "Your shield crumbles under the damage!")
			self:removeEffect(self.EFF_DAMAGE_SHIELD)
			self:removeEffect(self.EFF_PSI_DAMAGE_SHIELD)
		end
	end

	if value > 0 and self:attr("shadow_empathy") then
		-- Absorb damage into a random shadow
		local shadow = self:callTalent(self.T_SHADOW_EMPATHY, "getRandomShadow")
		if shadow then
			game:delayedLogMessage(self, src,  "displacement_shield"..(shadow.uid or ""), "#CRIMSON##Source# shares some damage with a shadow!")
			local displaced = math.min(value * self.shadow_empathy / 100, shadow.life)
			shadow:takeHit(displaced, src)
			game:delayedLogDamage(src, self, 0, ("#PINK#(%d linked)#LAST#"):format(displaced), false)
			game:delayedLogDamage(src, shadow, displaced, ("#PINK#%d linked#LAST#"):format(displaced), false)
			value = value - displaced
		end
	end

	if value > 0 and self:isTalentActive(self.T_DISRUPTION_SHIELD) then
		local mana = math.max(0, self:getMaxMana() - self:getMana())
		local mana_val = value * self:attr("disruption_shield")
		local converted = math.min(value, mana / self:attr("disruption_shield"))
		game:delayedLogMessage(self, nil,  "disruption_shield", "#LIGHT_BLUE##Source# converts damage to mana!")
		game:delayedLogDamage(src, self, 0, ("#LIGHT_BLUE#(%d converted)#LAST#"):format(converted), false)

		-- We have enough to absorb the full hit
		if mana_val <= mana then
			self:incMana(mana_val)
			self.disruption_shield_absorb = self.disruption_shield_absorb + value
			return 0
		-- Or the shield collapses in a deadly arcane explosion
		else
			self:incMana(mana)
			self.disruption_shield_absorb = self.disruption_shield_absorb + mana / self:attr("disruption_shield")
			value = value - mana / self:attr("disruption_shield")

			local dam = self.disruption_shield_absorb

			-- Deactivate without loosing energy
			self:forceUseTalent(self.T_DISRUPTION_SHIELD, {ignore_energy=true})

			-- Explode!
			local t = self:getTalentFromId(self.T_DISRUPTION_SHIELD)
			t.explode(self, t, dam)
		end
	end

	if value > 0 and self:isTalentActive(self.T_BONE_SHIELD) then
		local t = self:getTalentFromId(self.T_BONE_SHIELD)
		if t.absorb(self, t, self:isTalentActive(self.T_BONE_SHIELD)) then
			game:delayedLogDamage(src, self, 0, ("#SLATE#(%d to bones)#LAST#"):format(value), false)
			value = 0
		end
	end

	if value <=0 then return 0 end
	if self.knowTalent and (self:knowTalent(self.T_SEETHE) or self:knowTalent(self.T_GRIM_RESOLVE)) then
		if not self:hasEffect(self.EFF_CURSED_FORM) then
			self:setEffect(self.EFF_CURSED_FORM, 1, { increase=0 })
		end
		local eff = self:hasEffect(self.EFF_CURSED_FORM)
		self.tempeffect_def[self.EFF_CURSED_FORM].do_onTakeHit(self, eff, value)
	end

	if value > 0 then
		tal = self:isTalentActive(self.T_DEFLECTION)
		if tal then
			local oldval = value
			value = self:callTalent(self.T_DEFLECTION, "do_onTakeHit", tal, value)
			if value ~= oldval then
				game:delayedLogDamage(src, self, 0, ("#SLATE#(%d deflected)#LAST#"):format(oldval - value), false)
			end
		end
	end

	if value > 0 and self:hasEffect(self.EFF_RAMPAGE) then
		local eff = self:hasEffect(self.EFF_RAMPAGE)
		value = self.tempeffect_def[self.EFF_RAMPAGE].do_onTakeHit(self, eff, value)
	end

	if value > 0 and self:hasEffect(self.EFF_BECKONED) then
		local eff = self:hasEffect(self.EFF_BECKONED)
		value = self.tempeffect_def[self.EFF_BECKONED].do_onTakeHit(self, eff, value)
	end

	-- Achievements
	if not self.no_take_hit_achievements and src and src.resolveSource and src:resolveSource().player and value >= 600 then
		local rsrc = src:resolveSource()
		world:gainAchievement("SIZE_MATTERS", rsrc)
		if value >= 1500 then world:gainAchievement("DAMAGE_1500", rsrc) end
		if value >= 3000 then world:gainAchievement("DAMAGE_3000", rsrc) end
		if value >= 6000 then world:gainAchievement("DAMAGE_6000", rsrc) end
	end

	-- Frozen: absorb some damage into the iceblock
	if value > 0 and self:attr("encased_in_ice") then
		local eff = self:hasEffect(self.EFF_FROZEN)
		local absorb = 0.4
		if src and src.attr then
			absorb = absorb - absorb * (util.bound(src:attr("iceblock_pierce") or 0, 0, 100)) / 100
		end
		eff.hp = eff.hp - value * absorb
		game:delayedLogDamage(src or {}, self, 0, ("#STEEL_BLUE#(%d to ice)#LAST#"):format(value*absorb), nil)
		value = value * (1 - absorb)
		if eff.hp < 0 and not eff.begone then
			game:onTickEnd(function() self:removeEffect(self.EFF_FROZEN) end)
			eff.begone = game.turn
		end
	end

	-- Mind save to reduce damage to zero
	if self:knowTalent(self.T_DISMISSAL) and value > 0 then
		local t = self:getTalentFromId(self.T_DISMISSAL)
		value = t.doDismissalOnHit(self, value, src, t)
	end

	if value <= 0 then return 0 end
	-- Feedback pool: Stores damage as energy to use later
	if self:getMaxFeedback() > 0 and src ~= self and src ~= self.summoner then
		local ratio = self:callTalent(self.T_FEEDBACK_POOL, "getFeedbackRatio")
		local feedback_gain = value * ratio
		self:incFeedback(feedback_gain)
		-- Give feedback to summoner
		if self.summoner and self.summoner:getTalentLevel(self.summoner.T_OVER_MIND) >=1 and self.summoner:getMaxFeedback() > 0 then
			self.summoner:incFeedback(feedback_gain)
		end
		-- Trigger backlash retribution damage
		if src and src.turn_procs and self:knowTalent(self.T_BACKLASH) and not src.no_backlash_loops and not src.turn_procs.backlash then
			if src.y and src.x and not src.dead then
				local t = self:getTalentFromId(self.T_BACKLASH)
				t.doBacklash(self, src, feedback_gain, t)
				src.turn_procs.backlash = true
			end
		end
	end

	-- Resonance Field, must be called after Feedback gains
	if self:attr("resonance_field") then
		local absorb = math.min(value/2, self.resonance_field_absorb)
		game:delayedLogDamage(src, self, 0, ("#SLATE#(%d resonance)#LAST#"):format(absorb), false)
		if absorb < self.resonance_field_absorb then
			self.resonance_field_absorb = self.resonance_field_absorb - absorb
		else
			game.logPlayer(self, "Your resonance field crumbles under the damage!")
			self:removeEffect(self.EFF_RESONANCE_FIELD)
		end
		value = value - absorb
	end

	if self:hasEffect(self.EFF_CAUTERIZE) then
		local eff = self:hasEffect(self.EFF_CAUTERIZE)
		if eff.invulnerable then
			eff.dam = eff.dam + value / 10
			return 0
		end
	end

	-- Reduce sleep durations
	if value > 0 and self:attr("sleep") then
		local effs = {}
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.subtype.sleep then
				effs[#effs+1] = {"effect", eff_id}
			end
		end
		for i = 1, #effs do
			if #effs == 0 then break end
			local eff = rng.tableRemove(effs)
			if eff[1] == "effect" then
				local e = self:hasEffect(eff[2])
				-- Reduce the duration by 1 for every full incriment of the effect power
				-- We add a temp_power parameter to track total damage over multiple turns
				e.temp_power = (e.temp_power or e.power) - value
				while e.temp_power <= 0 do
					e.dur = e.dur - 1
					e.temp_power = e.temp_power + e.power
					if e.dur <=0 then
						game:onTickEnd(function() self:removeEffect(eff[2]) end) -- Happens on tick end so Night Terror can work properly
						break
					end
				end
			end
		end
	end

	-- Solipsism damage; set it up here but apply it after on_take_hit
	local damage_to_psi = 0
	if self:knowTalent(self.T_SOLIPSISM) and value > 0 and self:getPsi() > 0 then
		local t = self:getTalentFromId(self.T_SOLIPSISM)
		damage_to_psi = value * t.getConversionRatio(self, t)
	end

	-- Stoned ? SHATTER !
	if self:attr("stoned") and value >= self.max_life * 0.3 then
		-- Make the damage high enough to kill it
		value = self.max_life + 1
		game.logSeen(self, "%s shatters into pieces!", self.name:capitalize())
	end

	-- Adds hate
	if value > 0 and self:knowTalent(self.T_HATE_POOL) then
		local hateGain = 0
		local hateMessage

		if value / self.max_life >= 0.15 then
			-- you take a big hit..adds 2 + 2 for each 5% over 15%
			hateGain = hateGain + 2 + (((value / self.max_life) - 0.15) * 100 * 0.5)
			hateMessage = "#F53CBE#You fight through the pain!"
		end

		if value / self.max_life >= 0.05 and (self.life - value) / self.max_life < 0.25 then
			-- you take a hit with low health
			hateGain = hateGain + 4
			hateMessage = "#F53CBE#Your hatred grows even as your life fades!"
		end

		if hateGain >= 1 then
			self:incHate(hateGain)
			if hateMessage then
				game.logPlayer(self, hateMessage.." (+%d hate)", hateGain)
			end
		end
	end

	if value > 0 and src and (src.hate_per_powerful_hit or 0) > 0 and src.knowTalent and src:knowTalent(src.T_HATE_POOL) then
		local hateGain = 0
		local hateMessage

		if value / src.max_life > 0.33 then
			-- you deliver a big hit
			hateGain = hateGain + src.hate_per_powerful_hit
			hateMessage = "#F53CBE#Your powerful attack feeds your madness!"
		end

		if hateGain >= 0.1 then
			src.hate = math.min(src.max_hate, src.hate + hateGain)
			if hateMessage then
				game.logPlayer(src, hateMessage.." (+%d hate)", hateGain)
			end
		end
	end

	-- Bloodlust!
	if value > 0 and src and src.knowTalent and src:knowTalent(src.T_BLOODLUST) then
		src:setEffect(src.EFF_BLOODLUST, 1, {})
	end

	if value > 0 and self:knowTalent(self.T_RAMPAGE) then
		local t = self:getTalentFromId(self.T_RAMPAGE)
		t:onTakeHit(self, value / self.max_life)
	end

	-- Split ?
	if self.clone_on_hit and value >= self.clone_on_hit.min_dam_pct * self.max_life / 100 and rng.percent(self.clone_on_hit.chance) then
		-- Find space
		local x, y = util.findFreeGrid(self.x, self.y, 1, true, {[Map.ACTOR]=true})
		if x then
			-- Find a place around to clone
			local a
			if self.clone_base then a = self.clone_base:clone() else a = self:clone() end
			a.life = math.max(1, self.life - value / 2)
			a.clone_on_hit.chance = math.ceil(self.clone_on_hit.chance / 2)
			a.energy.value = 0
			a.exp_worth = 0.1
			a.inven = {}
			a:removeAllMOs()
			a.x, a.y = nil, nil
			game.zone:addEntity(game.level, a, "actor", x, y)
			game.logSeen(self, "%s splits in two!", self.name:capitalize())
			value = value / 2
		end
	end

	-- Apply Solipsism hit
	if damage_to_psi > 0 then
		local t = self:getTalentFromId(self.T_SOLIPSISM)
		local psi_damage_resist = 1 - t.getPsiDamageResist(self, t)/100
	--	print("Psi Damage Resist", psi_damage_resist, "Damage", damage_to_psi, "Final", damage_to_psi*psi_damage_resist)
		if self:getPsi() > damage_to_psi*psi_damage_resist then
			self:incPsi(-damage_to_psi*psi_damage_resist)
		else
			damage_to_psi = self:getPsi()
			self:incPsi(-damage_to_psi)
		end
		local mindcolor = DamageType:get(DamageType.MIND).text_color or "#aaaaaa#"
		game:delayedLogMessage(self, nil, "Solipsism hit", mindcolor.."#Source# converts some damage to Psi!")
		game:delayedLogDamage(src, self, damage_to_psi*psi_damage_resist, ("%s%d %s#LAST#"):format(mindcolor, damage_to_psi*psi_damage_resist, "to psi"), false)

		value = value - damage_to_psi
	end

	if value <= 0 then return 0 end
	-- VITALITY?
	if self:knowTalent(self.T_VITALITY) and self.life > self.max_life /2 and self.life - value <= self.max_life/2 then
		local t = self:getTalentFromId(self.T_VITALITY)
		t.do_vitality_recovery(self, t)
	end

	-- Daunting Presence?
	if value > (self.max_life / 20) and self:isTalentActive(self.T_DAUNTING_PRESENCE) then
		local t = self:getTalentFromId(self.T_DAUNTING_PRESENCE)
		t.do_daunting_presence(self, t)
	end

	-- Shield of Light
	tal = self:isTalentActive(self.T_SHIELD_OF_LIGHT)
	if tal then
		if value <= 2 then
			drain = value
		else
			drain = 2
		end
		if self:getPositive() >= drain then
			self:incPositive(- drain)

			-- Only calculate crit once per turn to avoid log spam
			if not self.turn_procs.shield_of_light_heal then
				local t = self:getTalentFromId(self.T_SHIELD_OF_LIGHT)
				self.turn_procs.shield_of_light_heal = true
				self.shield_of_light_heal = self:spellCrit(t.getHeal(self, t))
			end

			self:heal(self.shield_of_light_heal, tal)
		end
	end
	
	if self:attr("unstoppable") then
		if value > self.life - 1 then
			game:delayedLogDamage(src, self, 0, ("#RED#(%d refused)#LAST#"):format(value - (self.life - 1)), false)
			value = self.life - 1
			if self.life <= 1 then value = 0 end
			game:delayedLogMessage(self, nil, "unstoppable", "#RED##Source# is unstoppable!")
		end
	end

	if value >= self.life then
		local tal = self:isTalentActive(self.T_SECOND_LIFE)
		if tal then
			local sl = self:callTalent(self.T_SECOND_LIFE,"getLife")
			value = 0
			self.life = 1
			self:forceUseTalent(self.T_SECOND_LIFE, {ignore_energy=true})
			local value = self:heal(sl, self)
			game.logSeen(self, "#YELLOW#%s has been healed by a blast of positive energy!#LAST#", self.name:capitalize())
			if value > 0 then
				if self.player then world:gainAchievement("AVOID_DEATH", self) end
			end
		end

		local tal = self:isTalentActive(self.T_HEARTSTART)
		if tal then
			self:forceUseTalent(self.T_HEARTSTART, {ignore_energy=true})
		end
	end

	-- Shade's reform
	if value >= self.life and self.ai_state and self.ai_state.can_reform then
		local t = self:getTalentFromId(self.T_SHADOW_REFORM)
		if rng.percent(t.getChance(self, t)) then
			value = 0
			self.life = self.max_life
			game.logSeen(self, "%s fades for a moment and then reforms whole again!", self.name:capitalize())
			game.level.map:particleEmitter(self.x, self.y, 1, "teleport_out")
			game:playSoundNear(self, "talents/heal")
			game.level.map:particleEmitter(self.x, self.y, 1, "teleport_in")
		end
	end

	-- Shadow decoy
	if value >= self.life and self:isTalentActive(self.T_SHADOW_DECOY) then
		local t = self:getTalentFromId(self.T_SHADOW_DECOY)
		if t.onDie(self, t, value, src) then
			value = 0
		end
	end

	if value <= 0 then return 0 end
	-- Vim leech
	if self:knowTalent(self.T_LEECH) and src.hasEffect and src:hasEffect(src.EFF_VIMSENSE) then
		local vt = self:getTalentFromId(self.T_LEECH)
		self:incVim(vt.getVim(self, vt))
		self:heal(vt.getHeal(self, vt), src)
		if self.player then src:logCombat(src, "#AQUAMARINE#You leech a part of #Target#'s vim.") end
	end

	-- Invisible on hit
	if value >= self.max_life * 0.10 and self:attr("invis_on_hit") and rng.percent(self:attr("invis_on_hit")) then
		self:setEffect(self.EFF_INVISIBILITY, 5, {power=self:attr("invis_on_hit_power")})
		for tid, _ in pairs(self.invis_on_hit_disable) do self:forceUseTalent(tid, {ignore_energy=true}) end
	end

	-- Bloodspring
	if value >= self.max_life * 0.15 and self:knowTalent(self.T_BLOODSPRING) then
		self:triggerTalent(self.T_BLOODSPRING)
	end

	if self:knowTalent(self.T_DUCK_AND_DODGE) then
		local t = self:getTalentFromId(self.T_DUCK_AND_DODGE)
		if value >= self.max_life * t.getThreshold(self, t) then
			self:setEffect(self.EFF_EVASION, t.getDuration(self, t), {chance=t.getEvasionChance(self, t), defense = t.getDefense(self)})
		end
	end

	-- Damage shield on hit
	if self:attr("contingency") and value >= self.max_life * self:attr("contingency") / 100 and not self:hasEffect(self.EFF_DAMAGE_SHIELD) then
		self:setEffect(self.EFF_DAMAGE_SHIELD, 3, {power=value * self:attr("contingency_shield") / 100})
		for tid, _ in pairs(self.contingency_disable) do self:forceUseTalent(tid, {ignore_energy=true}) end
	end

	-- Spell cooldowns on hit
	if self:attr("reduce_spell_cooldown_on_hit") and value >= self.max_life * self:attr("reduce_spell_cooldown_on_hit") / 100 then
		local alt = {}
		for tid, cd in pairs(self.talents_cd) do
			if rng.percent(self:attr("reduce_spell_cooldown_on_hit_chance")) then alt[tid] = true end
		end
		for tid, cd in pairs(alt) do
			self:alterTalentCoolingdown(tid, -1)
		end
	end

	-- Life leech
	if value > 0 and src and not src.dead and src.attr and src:attr("life_leech_chance") and rng.percent(src.life_leech_chance) then
		local leech = math.min(value, self.life) * src.life_leech_value / 100
		if leech > 0 then
			src:heal(leech, self)
			game:delayedLogMessage(src, self, "life_leech"..self.uid, "#CRIMSON##Source# leeches life from #Target#!")
		end
	end

	-- Life steal from weapon
	if value > 0 and src and not src.dead and src.attr and src:attr("lifesteal") then
		local leech = math.min(value, self.life) * src.lifesteal / 100
		if leech > 0 then
			src:heal(leech, self)
			game:delayedLogMessage(src, self, "lifesteal"..self.uid, "#CRIMSON##Source# steals life from #Target#!")
		end
	end

	-- Flat damage cap
	if self.flat_damage_cap and self.max_life and death_note and death_note.damtype then
		local cap = nil
		if self.flat_damage_cap.all then cap = self.flat_damage_cap.all end
		if self.flat_damage_cap[death_note.damtype] then cap = self.flat_damage_cap[death_note.damtype] end
		if cap and cap > 0 then
			local ignored = math.max(0, value - cap * self.max_life / 100)
			if ignored > 0 then game:delayedLogDamage(src, self, 0, ("#LIGHT_GREY#(%d resilience)#LAST#"):format(ignored), false) end
			value = value - ignored
			print("[TAKE HIT] after flat damage cap", value)
		end
	end

	if self.on_takehit then value = self:check("on_takehit", value, src, death_note) end

	local eff = self:hasEffect(self.EFF_ELDRITCH_STONE)
	if eff then
		local abs = math.min(value, eff.power)
		self:incEquilibrium(abs * 2)
		if eff.power > abs then
			eff.power = eff.power - abs
			value = 0
		else
			value = value - abs
			self:removeEffect(self.EFF_ELDRITCH_STONE)
		end
		game:delayedLogDamage(src, self, 0, ("#SLATE#(%d to stone)#LAST#"):format(abs), false)
	end

	if self:knowTalent(self.T_STONESHIELD) and not self.turn_procs.stoneshield then
		local t = self:getTalentFromId(self.T_STONESHIELD)
		local m, mm, e, em = t.getValues(self, t)
		self:incMana(math.min(mm, value * m))
		self:incEquilibrium(-math.min(em, value * e))
		self.turn_procs.stoneshield = true
	end

	local eff = self:hasEffect(self.EFF_STONE_LINK)
	if eff then
		if eff.src:attr("dead") then
			self:removeEffect(self.EFF_STONE_LINK)
		else
			game:delayedLogMessage(eff.src, self, "stone_link"..(self.uid or ""), "#OLIVE_DRAB##Source# redirects damage from #Target# to %s!#LAST#", string.his_her_self(eff.src))
			game:delayedLogDamage(src, self, 0, ("#OLIVE_DRAB#(%d redirected)#LAST#"):format(value), false)
			eff.src:takeHit(value, src)
			game:delayedLogDamage(src, eff.src, value, ("#OLIVE_DRAB#%d redirected#LAST#"):format(value), false)
			value = 0
		end
	end

	local cb = {value=value}
	if self:fireTalentCheck("callbackOnHit", cb, src, death_note) then
		value = cb.value
	end

	local hd = {"Actor:takeHit", value=value, src=src, death_note=death_note}
	if self:triggerHook(hd) then value = hd.value end

	-- Resource leech
	if value > 0 and src and src.attr and src:attr("resource_leech_chance") and rng.percent(src.resource_leech_chance) then
		local leech = src.resource_leech_value
		src:incMana(leech)
		src:incVim(leech * 0.5)
		src:incPositive(leech * 0.25)
		src:incNegative(leech * 0.25)
		src:incEquilibrium(-leech * 0.35)
		src:incStamina(leech * 0.65)
		src:incHate(leech * 0.2)
		src:incPsi(leech * 0.2)
		game:delayedLogMessage(src, self, "resource_leech", "#CRIMSON##Source# leeches energies from #Target#!")
	end

	if self:knowTalent(self.T_DRACONIC_BODY) then
		local t = self:getTalentFromId(self.T_DRACONIC_BODY)
		t.trigger(self, t, value)
	end

	return value
end

function _M:takeHit(value, src, death_note)
	self:enterCombatStatus(src)
	if src and src.enterCombatStatus then src:enterCombatStatus(self) end

	for eid, p in pairs(self.tmp) do
		local e = self.tempeffect_def[eid]
		if e.damage_feedback then
			e.damage_feedback(self, p, src, value)
		end
	end
	for tid, p in pairs(self.sustain_talents) do
		local t = self:getTalentFromId(tid)
		if t.damage_feedback then
			t.damage_feedback(self, t, p, src, value)
		end
	end

	local dead, val = mod.class.interface.ActorLife.takeHit(self, value, src, death_note)

	if src and src.fireTalentCheck then src:fireTalentCheck("callbackOnDealDamage", val, self, dead, death_note) end

	if dead and src and src.attr and src:attr("overkill") and src.project and not src.turn_procs.overkill then
		src.turn_procs.overkill = true
		local dam = (self.die_at - self.life) * src:attr("overkill") / 100
		local incdam = self.inc_damage
		self.inc_damage = {}
		src:project({type="ball", radius=2, selffire=false, x=self.x, y=self.y}, self.x, self.y, DamageType.BLIGHT, dam, {type="acid"})
		self.inc_damage = incdam
	end

	return dead, val
end

function _M:removeTimedEffectsOnClone()
	local todel = {}
	for eff, p in pairs(self.tmp) do
		if _M.tempeffect_def[eff].remove_on_clone then
			todel[#todel+1] = eff
		end
	end
	while #todel > 0 do self:removeEffect(table.remove(todel)) end
end

function _M:resolveSource()
	if self.summoner_gain_exp and self.summoner then
		return self.summoner:resolveSource()
	else
		return self
	end
end

function _M:isMySummoner(act)
	local me = self
	while me.summoner do
		if me.summoner == act then return true end
		me = me.summoner
	end
	return false
end

function _M:emptyDrops()
	local inven = self:getInven(self.INVEN_INVEN)
	for i = #inven, 1, -1 do
		local o = inven[i]
		self:removeObject(inven, i, true)
		o:removed()
	end
	self._empty_drops_escort = true
end

function _M:die(src, death_note)
	if self.dead then self:disappear(src) self:deleteFromMap(game.level.map) if game.level:hasEntity(self) then game.level:removeEntity(self, true) end return true end

	-- Self resurrect, mouhaha!
	if self:attr("self_resurrect") and not self.no_resurrect then
		self:attr("self_resurrect", -1)
		game.logSeen(self, self.self_resurrect_msg or "#LIGHT_RED#%s rises from the dead!", self.name:capitalize()) -- src, not self as the source, to make sure the player knows his doom ;>
		local sx, sy = game.level.map:getTileToScreen(self.x, self.y, true)
		game.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, -3, "RESURRECT!", {255,120,0})

		local effs = {}

		self:removeEffectsSustainsFilter()

		self.life = self.max_life
		self.mana = self.max_mana
		self.stamina = self.max_stamina
		self.equilibrium = 0
		self.air = self.max_air

		self.dead = false
		self.died = (self.died or 0) + 1
		self:move(self.x, self.y, true)
		self:check("on_resurrect", "basic_resurrect")

		if self:attr("self_resurrect_chat") then
			local chat = Chat.new(self.self_resurrect_chat, self, game.player)
			chat:invoke()
			self.self_resurrect_chat = nil
		end

		return
	end

	if self:fireTalentCheck("callbackOnDeath", src, death_note) then return end
	if self.summoner and self.summoner.fireTalentCheck and self.summoner:fireTalentCheck("callbackOnSummonDeath", self, src, death_note) then return end

	mod.class.interface.ActorLife.die(self, src, death_note)

	-- Trigegr on_die effects if any
	for eff_id, p in pairs(self.tmp) do
		local e = self.tempeffect_def[eff_id]
		if e.on_die then e.on_die(self, p) end
	end

	-- Gives the killer some exp for the kill
	local killer = nil
	if src and src.resolveSource and src:resolveSource().gainExp then
		killer = src:resolveSource()
		killer:gainExp(self:worthExp(killer))
	end

	-- Hack: even if the boss dies from something else, give the player exp
	if (not killer or not killer.player) and self.rank > 3 and not game.party:hasMember(self) then
		game.logPlayer(game.player, "You feel a surge of power as a powerful creature falls nearby.")
		killer = game.player:resolveSource()
		killer:gainExp(self:worthExp(killer))
	end

	-- Register bosses deaths
	if self.rank > 3 then
		game.state:bossKilled(self.rank)
	end
	if self.unique then game.state:registerUniqueDeath(self) end

	if self.tier1 then game.state:tier1Kill() end

	if self.on_death_lore then game.party:learnLore(self.on_death_lore) end

	-- Do we get a blooooooody death ?
	if rng.percent(33) then self:bloodyDeath() end

	-- Drop stuff
	if not self.keep_inven_on_death then
		if not self.no_drops then
			local dropx, dropy = self.x, self.y
			if game.level.map:checkAllEntities(dropx, dropy, "block_move") then
				local dist = 7
				local poss = {}
				for i = self.x - dist, self.x + dist do
					for j = self.y - dist, self.y + dist do
						local d = core.fov.distance(self.x, self.y, i, j)
						if game.level.map:isBound(i, j) and
						   d <= dist and
						   not game.level.map:checkAllEntities(i, j, "block_move") and
						   not game.level.map.attrs(i, j, "no_drop") then
							poss[#poss+1] = {i,j,d}
						end
					end
				end

				if #poss > 0 then
					table.sort(poss, function(a,b) return a[3] < b[3] end)
					local pos = rng.table(poss)
					dropx, dropy = pos[1], pos[2]
				end
			end

			local invens = {}
			for inven_id, inven in pairs(self.inven) do invens[#invens+1] = inven end
			table.sort(invens, function(a,b) if a.id == 1 then return false elseif b.id == 1 then return true else return a.id < b.id end end)
			for _, inven in ipairs(invens) do
				for i = #inven, 1, -1 do
					local o = inven[i]

					-- Handle boss wielding artifacts
					if o.__special_boss_drop and rng.percent(o.__special_boss_drop.chance) then
						print("Refusing to drop "..self.name.." artifact "..o.name.." with chance "..o.__special_boss_drop.chance)

						-- Do not drop
						o.no_drop = true

						-- Drop a replacement by filter or random artifact instead
						local ro = game.zone:makeEntity(game.level, "object", o.__special_boss_drop.filter or {no_tome_drops=true, unique=true, not_properties={"lore"}}, nil, true)
						if ro then game.zone:addEntity(game.level, ro, "object", dropx, dropy) end
					end

					if not o.no_drop then
						o.droppedBy = self.name
						self:removeObject(inven, i, true)
						game.level.map:addObject(dropx, dropy, o)
						if game.level.map.attrs(dropx, dropy, "obj_seen") then game.level.map.attrs(dropx, dropy, "obj_seen", false) end
					else
						o:removed()
					end
				end
			end
		else
			local invens = {}
			for inven_id, inven in pairs(self.inven) do invens[#invens+1] = inven end
			table.sort(invens, function(a,b) if a.id == 1 then return false elseif b.id == 1 then return true else return a.id < b.id end end)
			for _, inven in ipairs(invens) do
				for i = #inven, 1, -1 do
					local o = inven[i]
					if game:hasEntity(o) then game:removeEntity(o) end
				end
			end
		end
		self.inven = {}
	end

	-- Give stamina back
	if src and src.knowTalent and src:knowTalent(src.T_UNENDING_FRENZY) then
		src:incStamina(src:callTalent(src.T_UNENDING_FRENZY, "getStamRecover"))
	end

	-- Regain Psi
	if src and src.attr and src:attr("psi_per_kill") then
		src:incPsi(src:attr("psi_per_kill"))
	end

	-- Increases blood frenzy
	if src and src.knowTalent and src:knowTalent(src.T_BLOOD_FRENZY) and src:isTalentActive(src.T_BLOOD_FRENZY) then
		src.blood_frenzy = src.blood_frenzy + src:callTalent(src.T_BLOOD_FRENZY,"bonuspower")
	end

	-- Increases necrotic aura count
	if src and src.resolveSource and src:resolveSource().isTalentActive and src:resolveSource():isTalentActive(src.T_NECROTIC_AURA) and not self.necrotic_minion and not self.no_necrotic_soul then
		local rsrc = src:resolveSource()
		local p = rsrc:isTalentActive(src.T_NECROTIC_AURA)
		if self.x and self.y and src.x and src.y and core.fov.distance(self.x, self.y, rsrc.x, rsrc.y) <= rsrc.necrotic_aura_radius then
			rsrc:callTalent(rsrc.T_NECROTIC_AURA, "absorbSoul", self)
		end
	end

	-- handle hate changes on kill
	if src and src.knowTalent and src:knowTalent(src.T_HATE_POOL) then
		local t = src:getTalentFromId(src.T_HATE_POOL)
		t.updateBaseline(src, t)
		t.on_kill(src, t, self)
	end

	if src and src.summoner and src.summoner_hate_per_kill then
		if src.summoner.knowTalent and src.summoner:knowTalent(src.summoner.T_HATE_POOL) then
			src.summoner.hate = math.min(src.summoner.max_hate, src.summoner.hate + src.summoner_hate_per_kill)
			game.logPlayer(src.summoner, "%s feeds you hate from its latest victim. (+%d hate)", src.name:capitalize(), src.summoner_hate_per_kill)
		end
	end

	if src and src.knowTalent and src:knowTalent(src.T_UNNATURAL_BODY) then
		local t = src:getTalentFromId(src.T_UNNATURAL_BODY)
		t.on_kill(src, t, self)
	end

	local effStalked = self:hasEffect(self.EFF_STALKED)
	if effStalked and not effStalked.src.dead and effStalked.src:hasEffect(self.EFF_STALKER) then
		local t = effStalked.src:getTalentFromId(effStalked.src.T_STALK)
		t.on_targetDied(effStalked.src, t, self)
	end

	if src and src.hasEffect and src:hasEffect(self.EFF_PREDATOR) then
		local eff = src:hasEffect(self.EFF_PREDATOR)
		if self.type == eff.type then
			local e = self.tempeffect_def[self.EFF_PREDATOR]
			e.addKill(src, self, e, eff)
		end
	end

	if src and src.knowTalent and src:knowTalent(src.T_BLOODRAGE) then
		local t = src:getTalentFromId(src.T_BLOODRAGE)
		t.on_kill(src, t)
	end

	if src and src.isTalentActive and src:isTalentActive(src.T_FORAGE) then
		local t = src:getTalentFromId(src.T_FORAGE)
		t.on_kill(src, t, self)
	end

	if src and src.knowTalent and src:knowTalent(src.T_TOXIC_DEATH) then
		local t = src:getTalentFromId(src.T_TOXIC_DEATH)
		t.on_kill(src, t, self)
	end

	if src and src.hasEffect and src:hasEffect(self.EFF_UNSTOPPABLE) then
		local p = src:hasEffect(self.EFF_UNSTOPPABLE)
		p.kills = p.kills + 1
	end

	if src and src.knowTalent and src:knowTalent(src.T_STEP_UP) and rng.percent(src:getTalentLevelRaw(src.T_STEP_UP) * 20) then
		game:onTickEnd(function() src:setEffect(self.EFF_STEP_UP, 1, {}) end)
	end

	if src and self.reset_rush_on_death and self.reset_rush_on_death == src then
		game:onTickEnd(function()
			src:alterTalentCoolingdown(src.T_RUSH, -1000)
		end)
	end

	-- Chronomancy stuff
	if self:hasEffect(self.EFF_TEMPORAL_DESTABILIZATION) then
		local p = self:hasEffect(self.EFF_TEMPORAL_DESTABILIZATION)
		if self:hasEffect(self.EFF_CONTINUUM_DESTABILIZATION) then
			p.src:project({type="ball", radius=4, x=self.x, y=self.y}, self.x, self.y, DamageType.TEMPORAL, p.explosion, nil)
			game.level.map:particleEmitter(self.x, self.y, 4, "ball_temporal", {radius=4})
		else
			p.src:project({type="ball", radius=4, x=self.x, y=self.y}, self.x, self.y, DamageType.WARP, p.explosion, nil)
			game.level.map:particleEmitter(self.x, self.y, 4, "ball_matter", {radius=4})
		end
		game:playSoundNear(self, "talents/breath")
	end

	if self:hasEffect(self.EFF_CEASE_TO_EXIST) then
		local kill = true
		game:onTickEnd(function()
			if game._chronoworlds == nil then
				game.logPlayer(game.player, "#LIGHT_RED#The cease to exist spell fizzles and cancels, leaving the timeline intact.")
				kill = false
				return
			end
			game:chronoRestore("cease_to_exist", true)
			-- check that the kill condition still applies
			if kill == true then
				local t = game.player:getTalentFromId(game.player.T_CEASE_TO_EXIST)
				t.do_instakill(game.player, t)
			end
		end)
	end

	if self:hasEffect(self.EFF_GHOUL_ROT) then
		local p = self:hasEffect(self.EFF_GHOUL_ROT)
		if p.make_ghoul > 0 then
			local t = p.src:getTalentFromId(p.src.T_GNAW)
			t.spawn_ghoul(p.src, self, t)
		end
	end

	if src and self:attr("sleep") and src.isTalentActive and src:isTalentActive(src.T_NIGHT_TERROR) then
		local t = src:getTalentFromId(src.T_NIGHT_TERROR)
		t.summonNightTerror(src, self, t)
	end

	-- Curse of Corpses: Corpselight
	-- Curse of Corpses: Reprieve from Death
	if src and src.hasEffect and src:hasEffect(src.EFF_CURSE_OF_CORPSES) then
		local eff = src:hasEffect(src.EFF_CURSE_OF_CORPSES)
		local def = src.tempeffect_def[src.EFF_CURSE_OF_CORPSES]
		if not def.doReprieveFromDeath(src, eff, self) then
			def.doCorpselight(src, eff, self)
		end
	end

	-- Curse of Shrouds: Shroud of Death
	if src and src.hasEffect and src:hasEffect(src.EFF_CURSE_OF_SHROUDS) then
		local eff = src:hasEffect(src.EFF_CURSE_OF_SHROUDS)
		local def = src.tempeffect_def[src.EFF_CURSE_OF_SHROUDS]
		def.doShroudOfDeath(src, eff)
	end

	-- Increase vim
	if src and src.knowTalent and src:knowTalent(src.T_VIM_POOL) then src:incVim(1 + src:getWil() / 10) end
	if src and src.attr and src:attr("vim_on_death") and not self:attr("undead") then src:incVim(src:attr("vim_on_death")) end
	if src and death_note and death_note.source_talent and death_note.source_talent.vim and src.last_vim_turn ~= game.turn then
		src.last_vim_turn = game.turn
		game:onTickEnd(function() -- Do it on tick end to make sure Vim is spent by the talent code before being refunded
			src:incVim(util.getval(death_note.source_talent.vim, self, death_note.source_talent))
		end)
	end

	if src and ((src.resolveSource and src:resolveSource().player) or src.player) then
		-- Achievements
		local p = game.party:findMember{main=true}
		if math.floor(p.life) <= 1 and not p.dead then p:attr("barely_survived", 1) world:gainAchievement("THAT_WAS_CLOSE", p) end
		world:gainAchievement("BOSS_REVENGE", p, self)
		world:gainAchievement("EMANCIPATION", p, self)
		world:gainAchievement("EXTERMINATOR", p, self)
		world:gainAchievement("PEST_CONTROL", p, self)
		world:gainAchievement("REAVER", p, self)

		if self.unique and not self.randboss then
			game.player:registerUniqueKilled(self)
		end

		-- Record kills
		p.all_kills = p.all_kills or {}
		p.all_kills[self.name] = p.all_kills[self.name] or 0
		p.all_kills[self.name] = p.all_kills[self.name] + 1
		p.all_kills_kind = p.all_kills_kind or {}
		p.all_kills_kind.creature = (p.all_kills_kind.creature or 0) + 1

		if self.rank == 3 then p.all_kills_kind.elite = (p.all_kills_kind.elite or 0) + 1
		elseif self.rank >= 3.2 and self.rank < 3.5 then p.all_kills_kind.rare = (p.all_kills_kind.rare or 0) + 1
		elseif self.rank >= 3.5 then p.all_kills_kind.boss = (p.all_kills_kind.boss or 0) + 1
		end

		if game.level and game.level.data.record_player_kills then
			game.level.data.record_player_kills = game.level.data.record_player_kills + 1
		end

		if p:reactionToward(self) < 0 then p.last_kill_turn = game.turn end
	end

	-- Ingredients
	if src and self.ingredient_on_death then
		local rsrc = src.resolveSource and src:resolveSource() or src
		if game.party:hasMember(rsrc) then 
			if type(self.ingredient_on_death) == "table" then
				for _, ingredient in ipairs(self.ingredient_on_death) do
					game.party:collectIngredient(ingredient)
				end
			else
				game.party:collectIngredient(self.ingredient_on_death)
			end
		end
	end

	if self.sound_die and (self.unique or rng.chance(5)) then game:playSoundNear(self, self.sound_die) end

	if src and src.fireTalentCheck then src:fireTalentCheck("callbackOnKill", self, death_note) end

	return true
end

function _M:learnStats(statorder)
	self.auto_stat_cnt = self.auto_stat_cnt or 1
	local nb = 0
	local max = 60

	-- Allow to go over a natural 60, up to 80 at level 50
	if not self.no_auto_high_stats then max = 60 + (self.level * 20 / 50) end

	while self.unused_stats > 0 do
		if self:getStat(statorder[self.auto_stat_cnt]) < max then
			self:incIncStat(statorder[self.auto_stat_cnt], 1)
			self.unused_stats = self.unused_stats - 1
		end
		self.auto_stat_cnt = util.boundWrap(self.auto_stat_cnt + 1, 1, #statorder)
		nb = nb + 1
		if nb >= #statorder then break end
	end
end

function _M:resetToFull()
	if self.dead then return end
	self.life = self.max_life
	
	-- go through all resources
	for res, res_def in ipairs(_M.resources_def) do
		if res_def.short_name == "paradox" then
			self.paradox = self.preferred_paradox or 300
		elseif res_def.short_name == "mana" then
			-- Special handling of Disruption Shield to avoid penalizing Archmages on levelup
			if not (self.isTalentActive and self:isTalentActive(self.T_DISRUPTION_SHIELD)) then
				self.mana = self:getMaxMana()
			end
		else
			if res_def.invert_values or res_def.switch_direction then
				self[res_def.short_name] = self:check(res_def.getMinFunction) or self[res_def.short_name] or res_def.min
			else
				self[res_def.short_name] = self:check(res_def.getMaxFunction) or self[res_def.short_name] or res_def.max
			end
		end
	end
end

-- Level up talents to match actor level
function _M:resolveLevelTalents()
	if not self.start_level or not self._levelup_talents then return end

	local maxfact = 1  -- Balancing parameter for levels > 50: maxtalent level = actorlevel/50*maxfact * normal max talent level
	maxfact=math.max(maxfact,self.level/50)

	for tid, info in pairs(self._levelup_talents) do
		if not info.max or (self.talents[tid] or 0) < math.floor(info.max*maxfact) then
			local last = info.last or self.start_level
			if self.level - last >= info.every then
				self:learnTalent(tid, true)
				info.last = self.level
			end
		end
	end
end

function _M:levelup()
	engine.interface.ActorLevel.levelup(self)
	self:resolveLevelTalents()

	if not self.no_points_on_levelup then
		self.unused_stats = self.unused_stats + (self.stats_per_level or 3) + self:getRankStatAdjust()
		self.unused_talents = self.unused_talents + 1
		self.unused_generics = self.unused_generics + 1
		if self.level % 5 == 0 then self.unused_talents = self.unused_talents + 1 end
		if self.level % 5 == 0 then self.unused_generics = self.unused_generics - 1 end

		if self.extra_talent_point_every and self.level % self.extra_talent_point_every == 0 then self.unused_talents = self.unused_talents + 1 end
		if self.extra_generic_point_every and self.level % self.extra_generic_point_every == 0 then self.unused_generics = self.unused_generics + 1 end

		-- At levels 10, 20 and 36 and then every 30 levels, we gain a new talent type
		if self.level == 10 or self.level == 20 or self.level == 36 or (self.level > 50 and (self.level - 6) % 30 == 0) then
			self.unused_talents_types = self.unused_talents_types + 1
		end
		if self.level == 30 or self.level == 42 then
			self.unused_prodigies = self.unused_prodigies + 1
		end
		if self.level == 50 then
			self.unused_stats = self.unused_stats + 10
			self.unused_talents = self.unused_talents + 3
			self.unused_generics = self.unused_generics + 3
			if self.player and not config.settings.cheat and not self.silent_levelup then
				Dialog:simpleLongPopup("Level 50!", "You have achieved #LIGHT_GREEN#level 50#WHITE#, congratulations!\n\nThis level is special, it granted you #LIGHT_GREEN#10#WHITE# more stat points, #LIGHT_GREEN#3#WHITE# more class talent points and #LIGHT_GREEN#3#WHITE# more generic talent points.\nNow go forward boldly and triumph!", 400)
			end
		end
	elseif type(self.no_points_on_levelup) == "function" then
		self:no_points_on_levelup()
	end

	-- Gain some basic resistances
	if not self.no_auto_resists then
		-- Make up a random list of resists the first time
		if not self.auto_resists_list then
			local list = {
				DamageType.PHYSICAL,
				DamageType.FIRE, DamageType.COLD, DamageType.ACID, DamageType.LIGHTNING,
				DamageType.LIGHT, DamageType.DARKNESS,
				DamageType.NATURE, DamageType.BLIGHT,
				DamageType.TEMPORAL,
				DamageType.MIND,
			}
			self.auto_resists_list = {}
			for t in rng.tableSampleIterator(list, rng.range(1, self.auto_resists_nb or 2)) do
				-- Double the chance so that resist is more likely to happen
				if rng.percent(30) then self.auto_resists_list[#self.auto_resists_list+1] = t end
				self.auto_resists_list[#self.auto_resists_list+1] = t
			end
		end
		-- Provide one of our resists
		local t = rng.table(self.auto_resists_list)
		if (self.resists[t] or 0) < 50 then
			self.resists[t] = (self.resists[t] or 0) + rng.float(self:getRankResistAdjust())
		end

		-- Bosses have a right to get a general damage reduction
		if self.rank >= 4 then
			self.resists.all = (self.resists.all or 0) + rng.float(self:getRankResistAdjust()) / (self.rank == 4 and 3 or 2.5)
		end
	end

	-- Gain some saves
	if not self.no_auto_saves then
		self.combat_spellresist = self.combat_spellresist + rng.float(self:getRankSaveAdjust()) * (self:getMag() + self:getWil()) / 200
		self.combat_mentalresist = self.combat_mentalresist + rng.float(self:getRankSaveAdjust()) * (self:getCun() + self:getWil()) / 200
		self.combat_physresist = self.combat_physresist + rng.float(self:getRankSaveAdjust()) * (self:getStr() + self:getCon()) / 200
	end

	-- Gain life and resources and saves
	local rating = self.life_rating
	if not self.fixed_rating then
		rating = rng.range(math.floor(self.life_rating * 0.5), math.floor(self.life_rating * 1.5))
	end
	self.max_life = self.max_life + math.max(self:getRankLifeAdjust(rating), 1)

	self:incMaxVim(self.vim_rating)
	self:incMaxMana(self.mana_rating)
	self:incMaxStamina(self.stamina_rating)
	self:incMaxPositive(self.positive_negative_rating)
	self:incMaxNegative(self.positive_negative_rating)
	self:incMaxPsi(self.psi_rating)

	-- Heal up on new level
	self:resetToFull()

	-- Auto levelup ?
	if self.autolevel then
		engine.Autolevel:autoLevel(self)
	end

	self:fireTalentCheck("callbackOnLevelup", self.level)

	-- Notify party levelups
	if self.x and self.y and game.party:hasMember(self) and not self.silent_levelup then
		local x, y = game.level.map:getTileToScreen(self.x, self.y, true)
		game.flyers:add(x, y, 80, 0.5, -2, "LEVEL UP!", {0,255,255})
		game.log("#00ffff#Welcome to level %d [%s].", self.level, self.name:capitalize())
		local more = "Press p to use them."
		if game.player ~= self then more = "Select "..self.name.. " in the party list and press G to use them." end
		local points = {}
		if self.unused_stats > 0 then points[#points+1] = ("%d stat point(s)"):format(self.unused_stats) end
		if self.unused_talents > 0 then points[#points+1] = ("%d class talent point(s)"):format(self.unused_talents) end
		if self.unused_generics > 0 then points[#points+1] = ("%d generic talent point(s)"):format(self.unused_generics) end
		if self.unused_talents_types > 0 then points[#points+1] = ("%d category point(s)"):format(self.unused_talents_types) end
		if self.unused_prodigies > 0 then points[#points+1] = ("#VIOLET#%d prodigies point(s)#WHITE#"):format(self.unused_prodigies) end
		if #points > 0 then game.log("%s has %s to spend. %s", self.name:capitalize(), table.concat(points, ", "), more) end

		if self.level == 10 then world:gainAchievement("LEVEL_10", self) end
		if self.level == 20 then world:gainAchievement("LEVEL_20", self) end
		if self.level == 30 then world:gainAchievement("LEVEL_30", self) end
		if self.level == 40 then world:gainAchievement("LEVEL_40", self) end
		if self.level == 50 then world:gainAchievement("LEVEL_50", self) end

		if game.permadeath == game.PERMADEATH_MANY and (
			self.level == 2 or
			self.level == 5 or
			self.level == 7 or
			self.level == 14 or
			self.level == 24 or
			self.level == 35
			) then
			self.easy_mode_lifes = (self.easy_mode_lifes or 0) + 1
			game.logPlayer(self, "#AQUAMARINE#You have gained one more life (%d remaining).", self.easy_mode_lifes)
		end
		game:updateCurrentChar()

		if self == game.player then game:onTickEnd(function() game:playSound("actions/levelup") end, "levelupsound") end
	end
end

--- Notifies a change of stat value
-- Note inc_resource_multi does not auto-update and talents that use it should manually adjust the pools
function _M:onStatChange(stat, v)
	if stat == self.STAT_CON then
		-- life
		local multi_life = 4 + (self.inc_resource_multi.life or 0)
		self.max_life = math.max(1, self.max_life + multi_life * v)  -- no negative max life

		-- heal mod
		if self.stats.hf_id then self:removeTemporaryValue("healing_factor", self.stats.hf_id) end
		self.stats.hf_id = self:addTemporaryValue("healing_factor", self:combatStatLimit("con", 1.5, 0, 0.5)) -- +0 @ 10, +0.50 @ 100
	elseif stat == self.STAT_DEX then
		self.ignore_direct_crits = (self.ignore_direct_crits or 0) + 0.3 * v
	elseif stat == self.STAT_WIL then
		-- mana
		local multi_mana = 5 + (self.inc_resource_multi.mana or 0)
		self:incMaxMana(multi_mana * v)
		-- stamina
		local multi_stamina = 2.5 + (self.inc_resource_multi.stamina or 0)
		self:incMaxStamina(multi_stamina * v)
		-- psi
		local multi_psi = 1 + (self.inc_resource_multi.psi or 0)
		self:incMaxPsi(multi_psi * v)
	elseif stat == self.STAT_STR then
		self:checkEncumbrance()
	end

	self:fireTalentCheck("callbackOnStatChange", stat, v)
end

function _M:recomputeGlobalSpeed()
	if self.global_speed_add >= 0 then self.global_speed = self.global_speed_base + self.global_speed_add
	else self.global_speed = self.global_speed_base / (1 + math.abs(self.global_speed_add)) -- Symmetric scaling
	end
	self.global_speed = math.max(self.global_speed, 0.1)
end

--- Called when a temporary value changes (added or deleted)
-- Takes care to call onStatChange when needed
-- @param prop the property changing
-- @param v the value of the change
-- @param base the base table of prop
function _M:onTemporaryValueChange(prop, v, base)
	if base == self.inc_stats then
		self:onStatChange(prop, v)
	elseif prop == "global_speed_add" then
		self:recomputeGlobalSpeed()
	elseif base == self.talents_types_mastery then
		self:updateTalentTypeMastery(prop)
	elseif prop == "disarmed" then
		self:updateModdableTile()
	end
end

--- Actor attacks target
-- @param target the actor being attacked
-- @param x, y coordinates of target grid
function _M:attack(target, x, y)
	return self:bumpInto(target, x, y)
end

function _M:getMaxEncumbrance()
	local add = 0
	return math.floor(40 + self:getStr() * 1.8 + (self.max_encumber or 0) + add)
end

function _M:getEncumbrance()
	local enc = 0

	local fct = function(so) enc = enc + so.encumber end

	-- Compute encumbrance
	for inven_id, inven in pairs(self.inven) do
		for item, o in ipairs(inven) do
			if not o.__transmo and not o.__transmo_pre then
				o:forAllStack(fct)
			end
		end
	end
--	print("Total encumbrance", enc)
	return math.floor(enc)
end

function _M:checkEncumbrance()
	-- Compute encumbrance
	local enc, max = self:getEncumbrance(), self:getMaxEncumbrance()

	-- We are pinned to the ground if we carry too much
	if not self.encumbered and enc > max then
		game.logPlayer(self, "#FF0000#You carry too much--you are encumbered!")
		game.logPlayer(self, "#FF0000#Drop some of your items.")
		self.encumbered = self:addTemporaryValue("never_move", 1)

		if self.x and self.y then
			local sx, sy = game.level.map:getTileToScreen(self.x, self.y, true)
			game.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, rng.float(-2.5, -1.5), "+ENCUMBERED!", {255,0,0}, true)
		end
	elseif self.encumbered and enc <= max then
		self:removeTemporaryValue("never_move", self.encumbered)
		self.encumbered = nil
		game.logPlayer(self, "#00FF00#You are no longer encumbered.")

		if self.x and self.y then
			local sx, sy = game.level.map:getTileToScreen(self.x, self.y, true)
			game.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, rng.float(-2.5, -1.5), "-ENCUMBERED!", {255,0,0}, true)
		end
	end
end

--- Return attachement coords
function _M:attachementSpot(kind, particle)
	local as = self.attachement_spots or self.image
	if not as then return end
	if not game.tiles_attachements or not game.tiles_attachements[as] or not game.tiles_attachements[as][kind] then return end
	local x, y = 0, 0
	if particle then x, y = -0.5, -0.5 end
	return game.tiles_attachements[as][kind].x + x, game.tiles_attachements[as][kind].y + y
end

--- Return tile flip mode
function _M:isTileFlipped()
	local as = self.attachement_spots or self.image
	if not as then return false end
	if not game.tiles_facing or not game.tiles_facing[as] then return false end
	return game.tiles_facing[as].flipx
end

function _M:addShaderAura(kind, shader, shader_args, ...)
	if not core.shader.active(4) then return false end
	self.shader_auras = self.shader_auras or {}
	if self.shader_auras[kind] then return false end

	local textures = {...}
	for i = 1, #textures do
		if type(textures[i]) == "string" then textures[i] = {"image", textures[i]} end
	end
	self.shader_auras[kind] = {shader=shader, shader_args=shader_args, textures=textures}
	self:updateModdableTile()
	return true
end

function _M:removeShaderAura(kind)
	self.shader_auras = self.shader_auras or {}
	if not self.shader_auras[kind] then return end
	self.shader_auras[kind] = nil
	self:updateModdableTile()
end

function _M:getObjectModdableTile(slot)
	local i = self.inven[slot]
	if not i or not i[1] then return nil end
	local o = i[1]	
	if o.shimmer_moddable then return o.shimmer_moddable end
	return o
end

--- Update tile for races that can handle it
function _M:updateModdableTile()
	local selfbase = self.replace_display or self
	if not selfbase.moddable_tile or Map.tiles.no_moddable_tiles then
		local add = selfbase.add_mos or {}
		if self.shader_auras and next(self.shader_auras) then
			local base, baseh, basey, base1 = nil
			if selfbase.image == "invis.png" and add[1] and add[1].image then
				base = add[1].image
				base1 = true
				baseh, basey = add[1].display_h, add[1].display_y
			elseif not selfbase.add_mos then
				base = selfbase.image
				base1 = false
				baseh, basey = selfbase.display_h, selfbase.display_y
			end

			if base then
				selfbase.add_mos = add
				for _, def in pairs(self.shader_auras) do
					table.insert(add, 1, {_isshaderaura=true, image_alter="sdm", sdm_double=not baseh or baseh < 2, image=base, shader=def.shader, shader_args=def.shader_args, textures=def.textures, display_h=2, display_y=-1})
				end
				if not base1 then add[#add+1] = {_isshaderaura=true, image=base, display_y=basey, display_h=baseh} end

				self:removeAllMOs()
				if self.x and game.level then game.level.map:updateMap(self.x, self.y) end
			end
		elseif selfbase.add_mos then
			for i = #add, 1, -1 do
				if add[i]._isshaderaura then table.remove(add, i) end
			end
			if not next(selfbase.add_mos) then selfbase.add_mos = nil end

			self:removeAllMOs()
			if self.x and game.level then game.level.map:updateMap(self.x, self.y) end
		end
		return
	end
	self:removeAllMOs()

	local base = "player/"..self.moddable_tile:gsub("#sex#", self.female and "female" or "male").."/"

	self.image = base..(self.moddable_tile_shadow or "base_shadow_01.png")
	self.add_mos = {}
	local add = self.add_mos
	local i

	self:triggerHook{"Actor:updateModdableTile:back", base=base, add=add}

	i = self:getObjectModdableTile(self.INVEN_CLOAK); if i and i.moddable_tile then add[#add+1] = {image = base..(i.moddable_tile):format("behind")..".png", auto_tall=1} end

	if self.shader_auras and next(self.shader_auras) then
		for _, def in pairs(self.shader_auras) do
			add[#add+1] = {image_alter="sdm", sdm_double="dynamic", image=base..(self.moddable_tile_base or "base_01.png"), shader=def.shader, shader_args=def.shader_args, textures=def.textures, display_h=2, display_y=-1}
		end
	end

	local basebody = self.moddable_tile_base or "base_01.png"
	if self.moddable_tile_base_alter then basebody = self:moddable_tile_base_alter(basebody) end
	add[#add+1] = {image = base..basebody, auto_tall=1}

	if not self:attr("disarmed") then
		i = self:getObjectModdableTile(self.INVEN_MAINHAND); if i and i.moddable_tile_back then
			add[#add+1] = {image = base..(i.moddable_tile_back):format("right")..".png", auto_tall=1}
		end
		i = self:getObjectModdableTile(self.INVEN_OFFHAND); if i and i.moddable_tile_back then
			add[#add+1] = {image = base..(i.moddable_tile_back):format("left")..".png", auto_tall=1}
		end
	end

	i = self:getObjectModdableTile(self.INVEN_FEET); if i and i.moddable_tile then add[#add+1] = {image = base..(i.moddable_tile)..".png", auto_tall=1} end
	i = self:getObjectModdableTile(self.INVEN_BODY); if i and i.moddable_tile2 then add[#add+1] = {image = base..(i.moddable_tile2)..".png", auto_tall=1}
	elseif not self:attr("moddable_tile_nude") then add[#add+1] = {image = base..(self:attr("moddable_tile_lower_underwear") or "lower_body_01.png"), auto_tall=1} end
	i = self:getObjectModdableTile(self.INVEN_BODY); if i and i.moddable_tile then add[#add+1] = {image = base..(i.moddable_tile)..".png", auto_tall=1}
	elseif not self:attr("moddable_tile_nude") then add[#add+1] = {image = base..(self:attr("moddable_tile_higher_underwear") or "upper_body_01.png"), auto_tall=1} end
	i = self:getObjectModdableTile(self.INVEN_CLOAK); if i and i.moddable_tile then add[#add+1] = {image = base..(i.moddable_tile):format("shoulder")..".png", auto_tall=1} end
	local done_head = false
	i = self:getObjectModdableTile(self.INVEN_CLOAK); if config.settings.tome.show_cloak_hoods and i and i.moddable_tile_hood then add[#add+1] = {image = base..(i.moddable_tile):format("hood")..".png", auto_tall=1} done_head = true end
	i = self:getObjectModdableTile(self.INVEN_HEAD); if not done_head and i and i.moddable_tile then add[#add+1] = {image = base..(i.moddable_tile)..".png", auto_tall=1} done_head = true end
	if not done_head and self:attr("moddable_tile_head_underwear") then add[#add+1] = {image = base..self:attr("moddable_tile_head_underwear"), auto_tall=1} end
	self:triggerHook{"Actor:updateModdableTile:middle", base=base, add=add}
	i = self:getObjectModdableTile(self.INVEN_HANDS); if i and i.moddable_tile then add[#add+1] = {image = base..(i.moddable_tile)..".png", auto_tall=1} end
	i = self:getObjectModdableTile(self.INVEN_QUIVER); if i and i.moddable_tile then add[#add+1] = {image = base..(i.moddable_tile)..".png", auto_tall=1} end
	if not self:attr("disarmed") then
		i = self:getObjectModdableTile(self.INVEN_MAINHAND); if i and i.moddable_tile then
			add[#add+1] = {image = base..(i.moddable_tile):format("right")..".png", auto_tall=1}
			if i.moddable_tile_particle then
				add[#add].particle = i.moddable_tile_particle[1]
				add[#add].particle_args = i.moddable_tile_particle[2]
			end
			if i.moddable_tile_ornament then add[#add+1] = {image = base..(i.moddable_tile_ornament):format("right")..".png", auto_tall=1} end
		end
		i = self:getObjectModdableTile(self.INVEN_OFFHAND); if i and i.moddable_tile then
			add[#add+1] = {image = base..(i.moddable_tile):format("left")..".png", auto_tall=1}
			if i.moddable_tile_ornament then add[#add+1] = {image = base..(i.moddable_tile_ornament):format("left")..".png", auto_tall=1} end
		end
	end

	self:triggerHook{"Actor:updateModdableTile:front", base=base, add=add}

	if self.moddable_tile_ornament and self.moddable_tile_ornament[self.female and "female" or "male"] then add[#add+1] = {image = base..self.moddable_tile_ornament[self.female and "female" or "male"]..".png", auto_tall=1, shader=self.moddable_tile_ornament_shader} end
	if self.moddable_tile_ornament2 and self.moddable_tile_ornament2[self.female and "female" or "male"] then add[#add+1] = {image = base..self.moddable_tile_ornament2[self.female and "female" or "male"]..".png", auto_tall=1, shader=self.moddable_tile_ornament_shader2} end

	if self.x and game.level then game.level.map:updateMap(self.x, self.y) end
end

-- Go through all sustained talents and turn them off if pre_use fails
function _M:actorCheckSustains(silent, fake)
	for tid, _ in pairs(self.talents) do
		local t = self:getTalentFromId(tid)
		if t and t.mode == "sustained" and self:isTalentActive(t.id) then
			-- handles unarmed
			if t.is_unarmed and (self:hasMassiveArmor() or not self:isUnarmed()) then
				self:forceUseTalent(tid, {ignore_energy=true})
			end
			-- handles pre_use checks
			if t.on_pre_use and not t.on_pre_use(self, t, silent, fake) then
				self:forceUseTalent(tid, {ignore_energy=true})
			end
		end
	end
end

-- Quick Switch Weapons
function _M:quickSwitchWeapons(free_swap, message, silent)
	if self.no_inventory_access then return end
	if self:attr("sleep") and not self:attr("lucid_dreamer") then
		game.logPlayer(self, "You cannot switch equipment while sleeping!")
		return
	end

	local mh1, mh2 = self.inven[self.INVEN_MAINHAND], self.inven[self.INVEN_QS_MAINHAND]
	local oh1, oh2 = self.inven[self.INVEN_OFFHAND], self.inven[self.INVEN_QS_OFFHAND]
	local pf1, pf2 = self.inven[self.INVEN_PSIONIC_FOCUS], self.inven[self.INVEN_QS_PSIONIC_FOCUS]
	local qv1, qv2 = self.inven[self.INVEN_QUIVER], self.inven[self.INVEN_QS_QUIVER]

	if not mh1 or not mh2 or not oh1 or not oh2 then return end

	-- Do not reset power of switched items
	self.no_power_reset_on_wear = true

	-- Check for free weapon swaps
	local free_swap = free_swap or false
	if self:attr("quick_weapon_swap") then free_swap = true end

	local mhset1, mhset2 = {}, {}
	local ohset1, ohset2 = {}, {}
	local pfset1, pfset2 = {}, {}
	local qvset1, qvset2 = {}, {}
	-- Remove them all
	for i = #mh1, 1, -1 do mhset1[#mhset1+1] = self:removeObject(mh1, i, true) end
	for i = #mh2, 1, -1 do mhset2[#mhset2+1] = self:removeObject(mh2, i, true) end
	for i = #oh1, 1, -1 do ohset1[#ohset1+1] = self:removeObject(oh1, i, true) end
	for i = #oh2, 1, -1 do ohset2[#ohset2+1] = self:removeObject(oh2, i, true) end
	if pf1 and pf2 then
		for i = #pf1, 1, -1 do pfset1[#pfset1+1] = self:removeObject(pf1, i, true) end
		for i = #pf2, 1, -1 do pfset2[#pfset2+1] = self:removeObject(pf2, i, true) end
	end
	if qv1 and qv2 then
		for i = #qv1, 1, -1 do qvset1[#qvset1+1] = self:removeObject(qv1, i, true) end
		for i = #qv2, 1, -1 do qvset2[#qvset2+1] = self:removeObject(qv2, i, true) end
	end
	-- Put them all back
	for i = 1, #mhset1 do self:addObject(mh2, mhset1[i]) end
	for i = 1, #mhset2 do self:addObject(mh1, mhset2[i]) end
	for i = 1, #ohset1 do self:addObject(oh2, ohset1[i]) end
	for i = 1, #ohset2 do self:addObject(oh1, ohset2[i]) end
	if pf1 and pf2 then
		for i = 1, #pfset1 do self:addObject(pf2, pfset1[i]) end
		for i = 1, #pfset2 do self:addObject(pf1, pfset2[i]) end
	end
	if qv1 and qv2 then
		for i = 1, #qvset1 do self:addObject(qv2, qvset1[i]) end
		for i = 1, #qvset2 do self:addObject(qv1, qvset2[i]) end
	end
	if free_swap == false then self:useEnergy() end

	self.no_power_reset_on_wear = nil

	if not silent then
		local names = tstring{}
		if mh1 and mh2 then
			for i = 1, #mh1 do
				if #names > 0 then names:add(true) end
				names:add(mh1[i]:getName({do_color=true, no_add_name=true}))
			end
		end
		if oh1 and oh2 then
			for i = 1, #oh1 do
				if #names > 0 then names:add(true) end
				names:add(oh1[i]:getName({do_color=true, no_add_name=true}))
			end
		end
		if pf1 and pf2 then
			for i = 1, #pf1 do
				if #names > 0 then names:add(true) end
				names:add(pf1[i]:getName({do_color=true, no_add_name=true}))
			end
		end
		if qv1 and qv2 then
			for i = 1, #qv1 do
				if #names > 0 then names:add(true) end
				names:add(qv1[i]:getName({do_color=true, no_add_name=true}))
			end
		end
		-- Special Messages
		if #names == 0 then names = "unarmed" end
		if message == "warden" then
			game.logSeen(self, "%s warps space-time to equip: %s.", self.name:capitalize(), names)
		else
			game.logSeen(self, "%s switches %s weapons to: %s.", self.name:capitalize(), self:his_her(), names)
		end
	end
	-- Make sure sustains are still active
	self:actorCheckSustains()
	self:breakLightningSpeed()
	self:breakReloading()
	self:breakStepUp()

	self.off_weapon_slots = not self.off_weapon_slots
	self.changed = true

	self:fireTalentCheck("callbackOnQuickSwitchWeapons")
end

--- Call when an object is worn
-- This doesnt call the base interface onWear, it copies the code because we need some tricky stuff
function _M:onWear(o, inven_id, bypass_set, silent)
	o.wielded = {}

	if self.player then o:forAllStack(function(so) so.__transmo = false end) end

	local set_list_list = o.set_list
	if type(set_list_list) == 'function' then
		set_list_list = set_list_list(o, self, inven_id)
	end
	if set_list_list and not bypass_set then
		if not set_list_list.multiple then set_list_list = {single = set_list_list} end
		set_list_list = table.clone(set_list_list)
		set_list_list.multiple = nil
		for set_id, set_list in pairs(set_list_list) do
			local set_objects = {}
			for _, conditions in ipairs(set_list) do
				-- Find the object in the inventory.
				local object, index, object_inven_id
				if conditions.inven_id then
					object_inven_id = util.getval(conditions.inven_id, o, self, inven_id)
					local object_inven = self:getInven(object_inven_id)
					if object_inven then
						object, index = self:findInInventoryBy(
							object_inven, conditions[1], conditions[2])
					end
				else
					object, index, object_inven_id =
						self:findInAllInventoriesBy(conditions[1], conditions[2])
				end
				-- If we're wearing it, add it to the list.
				if object and self:getInven(object_inven_id).worn and
					(not object.set_complete or not object.set_complete[set_id])
				then
					table.insert(set_objects, {
												 object = object,
												 index = index,
												 inven_id = object_inven_id,
												 data = conditions.data,})
				end
			end
			-- If we found all the objects.
			if #set_objects == #set_list then
				-- Add self to set objects.
				table.insert(set_objects, {
											 object = o,
											 inven_id = inven_id,
											 data = set_list.self_data,})
				-- Apply set bonuses.
				for _, d in pairs(set_objects) do
					if d.object ~= o then self:onTakeoff(d.object, d.inven_id, true) end
					local complete = d.object.on_set_complete
					if type(complete) == "table" then complete = complete[set_id] end
					if complete then complete(d.object, self, d.inven_id, set_objects) end
					if d.object ~= o then self:onWear(d.object, d.inven_id, true) end
						self:useObjectDisable(d.object)
						self:useObjectEnable(d.object)

					d.object.set_complete = d.object.set_complete or {}
					d.object.set_complete[set_id] = set_objects
				end
			end
		end
	end

	self:checkMindstar(o)

	o:check("on_wear", self, inven_id)

	if o.wielder then
		for k, e in pairs(o.wielder) do
			o.wielded[k] = self:addTemporaryValue(k, e)
		end
		-- o.wielder.wielded = true
	end

	if o.talent_on_spell then
		self.talent_on_spell = self.talent_on_spell or {}
		for i = 1, #o.talent_on_spell do
			local id = util.uuid()
			self.talent_on_spell[id] = o.talent_on_spell[i]
			o.talent_on_spell[i]._id = id
		end
	end

	if o.talent_on_wild_gift then
		self.talent_on_wild_gift = self.talent_on_wild_gift or {}
		for i = 1, #o.talent_on_wild_gift do
			local id = util.uuid()
			self.talent_on_wild_gift[id] = o.talent_on_wild_gift[i]
			o.talent_on_wild_gift[i]._id = id
		end
	end

	if o.talent_on_mind then
		self.talent_on_mind = self.talent_on_mind or {}
		for i = 1, #o.talent_on_mind do
			local id = util.uuid()
			self.talent_on_mind[id] = o.talent_on_mind[i]
			o.talent_on_mind[i]._id = id
		end
	end

	-- Apply any special cursed logic
	if self:knowTalent(self.T_DEFILING_TOUCH) then
		local t = self:getTalentFromId(self.T_DEFILING_TOUCH)
		t.on_onWear(self, t, o)
	end

	-- Apply antimagic
	if o.power_source and o.power_source.antimagic then
		self:attr("spellpower_reduction", 1)
		self:attr("spell_failure", (o.material_level or 1) * 10)
		if self:attr("has_arcane_knowledge") then
			self:setEffect(self.EFF_ANTIMAGIC_DISRUPTION, 1, {})
		end
	end

	-- Apply Psychometry
	if self:knowTalent(self.T_PSYCHOMETRY) then
		local t = self:getTalentFromId(self.T_PSYCHOMETRY)
		t.updatePsychometryCount(self, t)
	end

	-- Learn Talent
	if o.wielder and o.wielder.learn_talent then
		for tid, level in pairs(o.wielder.learn_talent) do
			self:learnItemTalent(o, tid, level)
		end
	end

	-- Callbacks!
	if not o.carrier_callbacks then self:registerCallbacks(o, o, "object") end

	self:breakReloading()

	self:fireTalentCheck("callbackOnWear", o, bypass_set)

	self:checkTwoHandedPenalty()

	self:updateModdableTile()
	if self == game.player and not bypass_set and not self:attr("no_sound") then game:playSound("actions/wear") end
end

--- Call when an object is taken off
function _M:onTakeoff(o, inven_id, bypass_set, silent)
	engine.interface.ActorInventory.onTakeoff(self, o, inven_id)

	if o.talent_on_spell then
		self.talent_on_spell = self.talent_on_spell or {}
		for i = 1, #o.talent_on_spell do
			local id = o.talent_on_spell[i]._id
			self.talent_on_spell[id] = nil
		end
	end

	if o.talent_on_wild_gift then
		self.talent_on_wild_gift = self.talent_on_wild_gift or {}
		for i = 1, #o.talent_on_wild_gift do
			local id = o.talent_on_wild_gift[i]._id
			self.talent_on_wild_gift[id] = nil
		end
	end


	if o.talent_on_mind then
		self.talent_on_mind = self.talent_on_mind or {}
		for i = 1, #o.talent_on_mind do
			local id = o.talent_on_mind[i]._id
			self.talent_on_mind[id] = nil
		end
	end

	if o.set_complete and not bypass_set then
		for set_id, set_objects in pairs(o.set_complete) do
			for _, d in ipairs(set_objects) do
				if d.object ~= o then self:onTakeoff(d.object, d.inven_id, true) end
				local broken = d.object.on_set_broken
				if type(broken) == "table" then broken = broken[set_id] end
				if broken then broken(d.object, self, d.inven_id, set_objects) end
				if d.object._special_set then
					for k, id in pairs(d.object._special_set) do
						d.object:removeTemporaryValue(k, id)
					end
					d.object._special_set = nil
				end
				if d.object ~= o then self:onWear(d.object, d.inven_id, true) end
				self:useObjectDisable(d.object)
				self:useObjectEnable(d.object)
				d.object.set_complete[set_id] = nil
				-- Remove if empty.
				local empty = true
				for k, v in pairs(d.object.set_complete) do empty = false break end
				if empty then d.object.set_complete = nil end
			end
		end
	end

	if o._special_wear then
		for k, id in pairs(o._special_wear) do o:removeTemporaryValue(k, id) end
		o._special_wear = nil
	end


	-- apply any special cursed logic
	if self:knowTalent(self.T_DEFILING_TOUCH) then
		local t = self:getTalentFromId(self.T_DEFILING_TOUCH)
		t.on_onTakeOff(self, t, o)
	end

	-- Apply antimagic
	if o.power_source and o.power_source.antimagic then
		self:attr("spellpower_reduction", -1)
		self:attr("spell_failure", -(o.material_level or 1) * 10)
	end

	-- Apply Psychometry
	if self:knowTalent(self.T_PSYCHOMETRY) then
		local t = self:getTalentFromId(self.T_PSYCHOMETRY)
		t.updatePsychometryCount(self, t)
	end

	if o.wielder then
		-- To fix a fucking bug in 1.4; in some time we can remove that line
		o.wielder.wielded = nil
	end

	if o.wielder and o.wielder.learn_talent then
		for tid, level in pairs(o.wielder.learn_talent) do
			self:unlearnItemTalent(o, tid, level)
		end
	end

	-- Callbacks
	if not o.carrier_callbacks then self:unregisterCallbacks(o, o) end

	self:checkMindstar(o)

	self:breakReloading()
	self:fireTalentCheck("callbackOnTakeoff", o, bypass_set)

	-- If objected buffed us, remove
	local todel = {}
	for eff_id, p in pairs(self.tmp) do
		if p.__object_source == o then todel[#todel+1] = eff_id end
	end
	if #todel > 0 then for _, eff_id in ipairs(todel) do self:removeEffect(eff_id) end end

	self:checkTwoHandedPenalty()

	self:updateModdableTile()
	if self == game.player and not bypass_set and not self:attr("no_sound") then game:playSound("actions/takeoff") end
end

function _M:checkTwoHandedPenalty()
	self:removeEffect(self.EFF_2H_PENALTY, true, true)
	if not self:attr("allow_mainhand_2h_in_1h") then return end
	local mi, oi = self:getInven(self.INVEN_MAINHAND), self:getInven(self.INVEN_OFFHAND)
	if not mi or not oi then return end
	local mh, oh = mi[1], oi[1]
	if not mh or not oh then return end
	if mh.slot_forbid ~= "OFFHAND" then return end

	self:setEffect(self.EFF_2H_PENALTY, 1, {})
end

function _M:checkMindstar(o)
	if not o.psiblade_tile or not o.combat then return end

	local new
	local old
	local psb = self:getTalentFromId(self.T_PSIBLADES) --I5

	if o.wielded then
		new = self:attr("psiblades_active")
		old = o.psiblade_active
	else
		new = false
		old = o.psiblade_active
	end

	if new and not old then
		local pv = new
		o.moddable_tile_ornament = o.psiblade_tile
		o.psiblade_active = new

		o.__psiblade_data = {}

		local nm = {}
		for s, v in pairs(o.combat.dammod) do nm[s] = v * (psb.getStatmult(self, psb)-1) end --I5
		o:tableTemporaryValue(o.__psiblade_data, {"combat", "dammod"}, nm)
		o:tableTemporaryValue(o.__psiblade_data, {"combat", "apr"}, o.combat.apr * (psb.getAPRmult(self,psb) - 1))

		if o.wielder and o.wielder.combat_mindpower then
			o:tableTemporaryValue(o.__psiblade_data, {"wielder", "combat_mindpower"}, o.wielder.combat_mindpower * (psb.getPowermult(self, psb) - 1))
		end
		if o.wielder and o.wielder.inc_stats and o.wielder.inc_stats[self.STAT_WIL] then
			o:tableTemporaryValue(o.__psiblade_data, {"wielder", "inc_stats"}, {[self.STAT_WIL] = o.wielder.inc_stats[self.STAT_WIL] * (psb.getPowermult(self, psb) - 1)})
		end
		if o.wielder and o.wielder.inc_stats and o.wielder.inc_stats[self.STAT_CUN] then
			o:tableTemporaryValue(o.__psiblade_data, {"wielder", "inc_stats"}, {[self.STAT_CUN] = o.wielder.inc_stats[self.STAT_CUN] * (psb.getPowermult(self, psb) - 1)})
		end

		print("Activating psiblade", o.name)
	elseif not new and old then
		local pv = o.psiblade_active

		if o.__psiblade_data then
			o:tableTemporaryValuesRemove(o.__psiblade_data)
		end

		o.moddable_tile_ornament = nil
		o.psiblade_active = false
		print("Disabling psiblade", o.name)
	end
end

--- Call when an object is added
function _M:onAddObject(o, inven_id, slot)
	-- curse the item
	if self:knowTalent(self.T_DEFILING_TOUCH) then
		local t = self:getTalentFromId(self.T_DEFILING_TOUCH)
		t.curseItem(self, t, o)
	end

	engine.interface.ActorInventory.onAddObject(self, o, inven_id, slot)

	-- Learn Talent
	if o.carrier and o.carrier.learn_talent then
		for tid, level in pairs(o.carrier.learn_talent) do
			self:learnItemTalent(o, tid, level)
		end
	end

	if o:canUseObject() then -- set up object use talents
		self:useObjectEnable(o, inven_id, slot)
	end

	-- Callbacks!
	if o.carrier_callbacks then self:registerCallbacks(o, o, "object") end

	self:checkEncumbrance()

	-- Achievement checks
	if self.player then
		if o.unique and not o.lore and not o.randart then
			game.player:registerArtifactsPicked(o)
		end
		world:gainAchievement("DEUS_EX_MACHINA", self, o)
	end
end

--- Call when an object is removed
function _M:onRemoveObject(o, inven_id, slot)
	engine.interface.ActorInventory.onRemoveObject(self, o, inven_id, slot)

	if o.carrier and o.carrier.learn_talent then
		for tid, level in pairs(o.carrier.learn_talent) do
			self:unlearnItemTalent(o, tid, level)
		end
	end

	if o:canUseObject() then -- remove object use talents (for NPC's)
		self:useObjectDisable(o, inven_id, slot)
	end
	-- Callbacks
	if o.carrier_callbacks then self:unregisterCallbacks(o, o) end

	self:checkEncumbrance()
end

--- Returns the possible offslot
function _M:getObjectOffslot(o)
	if o.type == "armor" and o.subtype == "shield" and self:knowTalent(self.T_STONESHIELD) then return "MAINHAND" end
	if o.dual_wieldable and self:attr("allow_any_dual_weapons") then
		return "OFFHAND"
	else
		return o.offslot
	end
end

--- Checks if the given item should respect its slot_forbid value
-- @param o the item to check
-- @param in_inven the inventory id in which the item is worn or tries to be worn
function _M:slotForbidCheck(o, in_inven_id)
	in_inven_id = self:getInven(in_inven_id).id
	if self:attr("allow_mainhand_2h_in_1h") and in_inven_id == self.INVEN_MAINHAND and o.slot_forbid == "OFFHAND" then
		return false
	end
	return true
end

--- Can we wear this item?
function _M:canWearObject(o, try_slot)
	if self:attr("forbid_arcane") and o.power_source and o.power_source.arcane then
		return nil, "antimagic"
	end
--	if o.power_source and o.power_source.antimagic and not self:attr("forbid_arcane") then
--		return nil, "requires antimagic"
--	end

	local oldreq = nil
	if o.subtype == "shield" and self:knowTalent(self.T_SKIRMISHER_BUCKLER_EXPERTISE) then
		oldreq = rawget(o, "require")
		o.require = table.clone(oldreq or {}, true)
		if o.require.stat and o.require.stat.str then
			o.require.stat.cun, o.require.stat.str = o.require.stat.str, nil
		end
		if o.require.talent then for i, tr in ipairs(o.require.talent) do
			if tr[1] == self.T_ARMOUR_TRAINING then
				o.require.talent[i] = {self.T_SKIRMISHER_BUCKLER_EXPERTISE, 1}
				break
			end
		end end
	end
	if o.subtype == "shield" and self:knowTalent(self.T_AGILE_DEFENSE) then
		oldreq = rawget(o, "require")
		o.require = table.clone(oldreq or {}, true)
		if o.require.stat and o.require.stat.str then
			o.require.stat.dex, o.require.stat.str = o.require.stat.str, nil
		end
		if o.require.talent then for i, tr in ipairs(o.require.talent) do
			if tr[1] == self.T_ARMOUR_TRAINING then
				o.require.talent[i] = {self.T_AGILE_DEFENSE, 1}
				break
			end
		end end
	end
	if (o.type == "weapon" or o.type == "ammo") and self:knowTalent(self.T_STRENGTH_OF_PURPOSE) then
		oldreq = rawget(o, "require")
		o.require = table.clone(oldreq or {}, true)
		if o.require.stat and o.require.stat.str then
			o.require.stat.mag, o.require.stat.str = o.require.stat.str, nil
		end
	end

	local ok, reason = engine.interface.ActorInventory.canWearObject(self, o, try_slot)

	if oldreq then
		o.require = oldreq
	end

	return ok, reason
end

function _M:lastLearntTalentsMax(what)
	if self:attr("infinite_respec") then return 99999 end
	return what == "generic" and 3 or 4
end

function _M:capLastLearntTalents(what)
	if self.no_last_learnt_talents_cap then return end
	local list = self.last_learnt_talents[what]
	local max = self:lastLearntTalentsMax(what)
	while #list > max do table.remove(list, 1) end
end

--- Actor learns a talent
-- @param t_id the id of the talent to learn
-- @return true if the talent was learnt, nil and an error message otherwise
function _M:learnTalent(t_id, force, nb, extra)
	local just_learnt = not self:knowTalent(t_id)
	local old_lvl = self:getTalentLevel(t_id)
	local old_lvl_raw = self:getTalentLevelRaw(t_id)
	if not engine.interface.ActorTalents.learnTalent(self, t_id, force, nb) then return false end

	-- If we learned a spell, get mana, if you learned a technique get stamina, if we learned a wild gift, get power
	local t = _M.talents_def[t_id]

	if just_learnt and (t.mode ~= "sustained" or t.passive_callbacks) then
		self:registerCallbacks(t, t_id, "talent")
	end

	extra = extra or {}

	if not t.no_unlearn_last and self.last_learnt_talents and not extra.no_unlearn then
		local list = t.generic and self.last_learnt_talents.generic or self.last_learnt_talents.class
		table.insert(list, t_id)
		self:capLastLearntTalents(t.generic and "generic" or "class")
	end

	if t.is_spell then self:attr("has_arcane_knowledge", nb or 1) end
	if t.is_antimagic then self:attr("forbid_arcane", nb or 1) end
	if t.type[1]:find("^chronomancy/bow") or t.type[1]:find("^chronomancy/blade") then self:attr("warden_swap", nb or 1) end

	if t.dont_provide_pool then return true end

	self:learnPool(t)

	-- If we learn mindslayer things we learn telekinetic grasp & beyond the flesh
	if t.autolearn_mindslayer then
		if not self:attr("autolearn_mindslayer_done") then
			self:learnTalent(self.T_TELEKINETIC_GRASP, true)
			self:learnTalent(self.T_BEYOND_THE_FLESH, true)
			if self.body then
				self.body.PSIONIC_FOCUS = 1
				self.body.QS_PSIONIC_FOCUS = 1
			else
				self.body = { PSIONIC_FOCUS = 1, QS_PSIONIC_FOCUS = 1 }
				self:initBody()
			end
		end
		self:attr("autolearn_mindslayer_done", 1)
	end

	-- Simulate calling the talent's close method if we were not learnt from the levelup dialog
	if t.on_levelup_close and not self.is_dialog_talent_leveling then
		local lvl = self:getTalentLevel(t_id)
		local lvl_raw = self:getTalentLevelRaw(t_id)
		t.on_levelup_close(self, t, lvl, old_lvl, lvl_raw, old_lvl_raw, false)
	end

	return true
end

-- Learn item talents; right now this code has no sanity checks so use it wisely
-- For example you can give the player talent levels in talents they know, which they can then unlearn for free talent points
-- Freshly learned talents also do not start on cooldown; which is fine for now but should be changed if we start using this code to teach more general talents to prevent swap abuse
-- For now we'll use it to teach talents the player couldn't learn at all otherwise rather then talents that they could possibly know
-- Make sure such talents are always flagged as unlearnable (see Command Staff for an example)
function _M:learnItemTalent(o, tid, level)
	local t = self:getTalentFromId(tid)
	local max = t.hard_cap or (t.points and t.points + 2) or 5
	if not self.item_talent_surplus_levels then self.item_talent_surplus_levels = {} end
	--local item_talent_surplus_levels = self.item_talent_surplus_levels or {}
	if not self.item_talent_surplus_levels[tid] then self.item_talent_surplus_levels[tid] = 0 end
	--item_talent_levels[tid] = item_talent_levels[tid] + level
	for i = 1, level do
		if self:getTalentLevelRaw(t) >= max then
			self.item_talent_surplus_levels[tid] = self.item_talent_surplus_levels[tid] + 1
		else
			self:learnTalent(tid, true, 1, {no_unlearn = true})
		end
	end

	if not self.talents_cd[tid] and not self:attr("no_learn_talent_item_cd") then
		local cd = math.ceil((self:getTalentCooldown(t) or 6) / 1.5)
		self.talents_cd[tid] = cd
	end
end

function _M:unlearnItemTalent(o, tid, level)
	local t = self:getTalentFromId(tid)
	local max = (t.points and t.points + 2) or 5
	if not self.item_talent_surplus_levels then self.item_talent_surplus_levels = {} end
	--local item_talent_surplus_levels = self.item_talent_surplus_levels or {}
	if not self.item_talent_surplus_levels[tid] then self.item_talent_surplus_levels[tid] = 0 end

	if self:isTalentActive(t) then self:forceUseTalent(t, {ignore_energy=true}) end

	for i = 1, level do
		if self.item_talent_surplus_levels[tid] > 0 then
			self.item_talent_surplus_levels[tid] = self.item_talent_surplus_levels[tid] - 1
		else
			self:unlearnTalent(tid, nil, nil, {no_unlearn = true})
		end
	end
end

-- learn a talent associated with another talent, usually a resource pool
function _M:checkPool(tid, pid)
	if tid == pid or not self.talents_def[pid] then return end
	if not self:knowTalent(pid) then
		self:learnTalent(pid, true)
	else
		if not self.resource_pool_refs[pid] or not next(self.resource_pool_refs[pid]) then
			self.resource_pool_refs[pid] = self.resource_pool_refs[pid] or {}
			self.resource_pool_refs[pid][pid] = 1 -- Make it never unlearnable
		end
	end
	self.resource_pool_refs[pid] = self.resource_pool_refs[pid] or {}
	self.resource_pool_refs[pid][tid] = self.talents[tid]
	return true
end

--- Actor learns a resource pool or associated talent
-- @param talent a talent definition table
function _M:learnPool(t)
	local tt = self:getTalentTypeFrom(t.type[1])

	if t.type[1]:find("^psionic/feedback") or t.type[1]:find("^psionic/discharge") or t.feedback or t.sustain_feedback then
		self:checkPool(t.id, self.T_FEEDBACK_POOL)
	end
	
	--go through all resources looking for talent references in the definition
	for res, res_def in ipairs(_M.resources_def) do
		if util.getval(t[res_def.short_name], self, t) or util.getval(t[res_def.sustain_prop], self, t) or util.getval(t[res_def.drain_prop], self, t) then
			self:checkPool(t.id, res_def.talent)
			if res_def.short_name == "paradox" then self:checkPool(t.id, self.T_SPACETIME_TUNING) end -- extra for paradox
		end
	end

	-- If we learn an archery talent, also learn to shoot
	if t.type[1]:find("^technique/archery") then
		self:checkPool(t.id, self.T_SHOOT)
	end
	-- If we learn an unharmed talent, learn to use it too
	if tt.is_unarmed then
		self:checkPool(t.id, self.T_EMPTY_HAND)
	end

	-- Generic
	if t.autolearn_talent then
		if type(t.autolearn_talent) == "table" then
			for i, auto_tid in ipairs(t.autolearn_talent) do
				self:checkPool(t.id, auto_tid)
			end
		else
			self:checkPool(t.id, t.autolearn_talent)
		end
	end
	
	self:recomputeRegenResources()

	return true
end

--- Actor forgets a talent
-- @param t_id the id of the talent to learn
-- @return true if the talent was unlearnt, nil and an error message otherwise
function _M:unlearnTalent(t_id, nb, no_unsustain, extra)
	if not engine.interface.ActorTalents.unlearnTalent(self, t_id, nb) then return false end

	nb = nb or 1

	local t = _M.talents_def[t_id]

	if not self:knowTalent(t_id) and (t.mode ~= "sustained" or t.passive_callbacks) then
		self:unregisterCallbacks(t, t_id)
	end

	extra = extra or {}

	if not t.no_unlearn_last and self.last_learnt_talents and not extra.no_unlearn then
		local list = t.generic and self.last_learnt_talents.generic or self.last_learnt_talents.class
		for i = #list, 1, -1 do
			if list[i] == t_id then table.remove(list, i) break end
		end
	end
	-- Check the various pools
	for pid, refs in pairs(self.resource_pool_refs) do
		if refs[t_id] then
			refs[t_id] = self.talents[t_id]
			if (refs[t_id] or 0) <= 0 then refs[t_id] = nil end
			if not next(refs) then self:unlearnTalent(pid, 1) end
		end
	end

	-- Unsustain ?
	if not no_unsustain and not self:knowTalent(t_id) and t.mode == "sustained" and self:isTalentActive(t_id) then self:forceUseTalent(t_id, {ignore_energy=true, save_cleanup=true}) end

	-- Remove buffs ?
	local todel = {}
	for eff_id, p in pairs(self.tmp) do
		if p.__talent_source == t_id then todel[#todel+1] = eff_id end
	end
	if #todel > 0 then for _, eff_id in ipairs(todel) do self:removeEffect(eff_id) end end

	self:recomputeRegenResources()

	if t.is_spell then self:attr("has_arcane_knowledge", -nb) end
	if t.is_antimagic then self:attr("forbid_arcane", -nb) end
	if t.type[1]:find("^chronomancy/bow") or t.type[1]:find("^chronomancy/blade") then self:attr("warden_swap", -nb) end

	-- If we learn mindslayer things we learn telekinetic grasp & beyond the flesh
	if t.autolearn_mindslayer then
		self:attr("autolearn_mindslayer_done", -1)
		if not self:attr("autolearn_mindslayer_done") then
			self:unlearnTalent(self.T_TELEKINETIC_GRASP)
			self:unlearnTalent(self.T_BEYOND_THE_FLESH)
			function focusremove(invenid)
				local focus = self:getInven(invenid)
				for i = #focus, 1, -1 do
					self:doTakeoff(focus, i, focus[i], true, nil, true)
				end
				self.inven[invenid] = nil
			end
			focusremove(self.INVEN_PSIONIC_FOCUS)
			focusremove(self.INVEN_QS_PSIONIC_FOCUS)
		end
	end

	return true
end

--- Recompute things that need recomputing
function _M:updateTalentTypeMastery(tt)
	local ll = self.last_learnt_talents
	self.last_learnt_talents = nil
	engine.interface.ActorTalents.updateTalentTypeMastery(self, tt)
	self.last_learnt_talents = ll
end

--- Equilibrium check
function _M:equilibriumChance(eq)
	eq = self:getEquilibrium()
	local wil = self:getWil()
	-- Do not fail if below willpower
	if eq < wil then return true, 100 end
	eq = eq - wil
	local chance = math.sqrt(eq) / 60
	--print("[Equilibrium] Use chance: ", 100 - chance * 100, "::", self:getEquilibrium())
	chance = util.bound(chance, 0, 1)
	return rng.percent(100 - chance * 100), 100 - chance * 100
end

--- Paradox checks
function _M:getModifiedParadox()
	local will_modifier = 2
	will_modifier = (self:getWil() + (self:attr("paradox_reduce_anomalies") or 0)) * will_modifier
	local sustain_modifier = self:getMinParadox()
	local modified_paradox = math.max(0, self:getParadox() - will_modifier + sustain_modifier)
	return modified_paradox, will_modifier, sustain_modifier
end

-- Anomaly stuff
function _M:paradoxFailChance()
	local chance = 0
	local fatigue_modifier = (100 + 2 * self:combatFatigue()) / 100
	if self:getModifiedParadox() > 300 then
		chance = fatigue_modifier * math.pow(self:getModifiedParadox() / 300, 6)
	end
	-- If there's any chance, round it down
	chance = util.bound(math.floor(chance), 0, 100)
	return chance, chance -- return this twice so we're compatable with older UIs
end

-- This handles anomalies
-- chance, generally paradoxFailChance, set to 100 to force an anomly
-- paradox recovered
-- def.anomaly_type to set a type, def.allow_target to allow targeting, def.target to set a target
function _M:paradoxDoAnomaly(chance, paradox, def)
	local def = def or {}
	local anomaly_type = def.anomaly_type or "random"
	
	-- Anomaly biases can be set manually for monsters or classes
	-- Use the following format anomaly_bias = { type = "warp", chance=50}
	local function check_bias(major)
		if self.anomaly_bias then
			local bias_chance = self.anomaly_bias.chance
			if rng.percent(bias_chance) then 
				anomaly_type = self.anomaly_bias.type
				return true
			end
		end
	end
	
	-- See if we create an anomaly
	if not game.zone.no_anomalies and not self:attr("no_paradox_fail") then
		-- This is so players can't chain cancel out of targeting to trigger anomalies on purpose, we clear it out in postUse
		if chance ~= 100 and self.turn_procs.anomalies_checked then return false end  
		if chance ~= 100 then self.turn_procs.anomalies_checked = true end

		if rng.percent(chance) then
			local anomaly_triggered = true
			
			-- If our Paradox is over 600 do a major anomaly
			if anomaly_type ~= "no-major" and (anomaly_type == "major" or self:getModifiedParadox() >= 600) then
				anomaly_type = "major"
			else
				-- Check for Bias?
				if not check_bias(true) then anomaly_type ="random" end
			end

			-- Now pick anomalies filtered by type
			local ts = {}
			for id, t in pairs(self.talents_def) do
				if anomaly_type ~= "random" then
					if t.type[1] == "chronomancy/anomalies" and t.anomaly_type and t.anomaly_type == anomaly_type and not self:isTalentCoolingDown(t) then ts[#ts+1] = id end
				else
					if t.type[1] == "chronomancy/anomalies" and t.anomaly_type and t.anomaly_type ~= "major" and not self:isTalentCoolingDown(t) then ts[#ts+1] = id end
				end
			end

			-- Be sure we found an anomly first
			if ts[1] then
				local anom = rng.table(ts)
				
				if anomaly_type ~= "major" then
					if self:attr("no_minor_anomalies") then
						anomaly_triggered = false
					elseif def.allow_target then
						anom = self:getTalentFromId(anom)
						-- make it real obvious for the player
						game.logPlayer(self, "#STEEL_BLUE#Casts %s.", anom.name)
						if self == game.player then
							game.bignews:saySimple(180, "#STEEL_BLUE#Targeting %s", anom.name)
						end
					
						-- targeted talents don't work well with no_energy, so we call the action directly
						anom.action(self, anom)
					elseif def.ignore_energy then
						self:forceUseTalent(anom, {force_target=def.target or self, ignore_energy=true})
					elseif self:knowTalent(self.T_TWIST_FATE) and not self:isTalentCoolingDown(self.T_TWIST_FATE) then
						if self:hasEffect(self.EFF_TWIST_FATE) then
							self:callTalent(self.T_TWIST_FATE, "doTwistFate")
							self:callTalent(self.T_TWIST_FATE, "setEffect", anom, paradox)
						else
							self:callTalent(self.T_TWIST_FATE, "setEffect", anom, paradox)
						end
						anomaly_triggered = false
					else
						self:forceUseTalent(anom, {force_target=def.target or self})
					end
				else
					-- Major anomalies pick targets at random
					self:forceUseTalent(anom, {force_target=self})
				end
			end

			-- reduce paradox and handle messages
			if anomaly_triggered then
				if not silent then
					if chance == 100 then
						game.logPlayer(self, "#STEEL_BLUE#You've moved to another time thread.")
					else
						game.logPlayer(self, "#LIGHT_RED#You lose control and unleash an anomaly!")
					end
				end
				-- Reduce Paradox
				if paradox and paradox > 0 then
					-- Double the paradox from major anomalies, mostly so NPCs don't become more dangerous when they run out of Paradox
					if anomaly_type == "major" then paradox = paradox * 2 end
					
					self:incParadox(-paradox)
				end
			end

			return anomaly_triggered
		end
	end
end

-- Overwrite incParadox to set up threshold log messages
local previous_incParadox = _M.incParadox

function _M:incParadox(paradox)
	-- Anomaly checks
	if self:getModifiedParadox() < 300 and self:getModifiedParadox() + paradox >= 300 then
		game.logPlayer(self, "#LIGHT_RED#You feel the edges of spacetime begin to ripple and bend!")
	end
	if self:getModifiedParadox() > 300 and self:getModifiedParadox() + paradox <= 300 then
		game.logPlayer(self, "#LIGHT_BLUE#Spacetime feels more stable.")
	end
	-- Greater anomalies
	if self:getModifiedParadox() < 600 and self:getModifiedParadox() + paradox >= 600 then
		game.logPlayer(self, "#LIGHT_RED#Spacetime fights against your control!")
	end
	if self:getModifiedParadox() > 600 and self:getModifiedParadox() + paradox <= 600 then
		game.logPlayer(self, "#LIGHT_BLUE#Spacetime has calmed...  somewhat.")
	end

	-- Cosmic Cycle
	if self:isTalentActive(self.T_COSMIC_CYCLE) then
		self:callTalent(self.T_COSMIC_CYCLE, "doCosmicCycle")
	end

	return previous_incParadox(self, paradox)
end

-- Overwrite incStamina to set up Adrenaline Surge
local previous_incStamina = _M.incStamina
function _M:incStamina(stamina)

	if self:knowTalent(self.T_SKIRMISHER_THE_ETERNAL_WARRIOR) then
		local t = self:getTalentFromId(self.T_SKIRMISHER_THE_ETERNAL_WARRIOR)
		t.onIncStamina(self, t, stamina)
	end

	if stamina < 0 and self:hasEffect(self.EFF_ADRENALINE_SURGE) then
		local stamina_cost = math.abs(stamina)
		if self.stamina - stamina_cost < 0 then
			local damage = stamina_cost - (self.stamina or 0)
			self:incStamina(-self.stamina or 0)
			self.life = self.life - damage
		else
			return previous_incStamina(self, stamina)
		end
	else
		return previous_incStamina(self, stamina)
	end
end

-- Overwrite incVim to set up Bloodcasting
local previous_incVim = _M.incVim
function _M:incVim(v)
	if v < 0 and self:attr("bloodcasting") then
		local cost = math.abs(v)
		if self.vim - cost < 0 then
			local damage = cost - (self.vim or 0)
			self:incVim(-self.vim or 0)
			self.life = self.life - damage
		else
			return previous_incVim(self, v)
		end
	else
		return previous_incVim(self, v)
	end
end

-- Overwrite getVim to set up Bloodcasting
local previous_getVim = _M.getVim
function _M:getVim()
	if self:attr("bloodcasting") and self.on_preuse_checking_resources then
		return self.life
	else
		return previous_getVim(self)
	end
end

-- Feedback Pseudo-Resource Functions
function _M:getFeedback()
	if self.psionic_feedback then
		return self.psionic_feedback
	else
		return 0
	end
end

function _M:getMaxFeedback()
	if self.psionic_feedback_max then
		return self.psionic_feedback_max
	else
		return 0
	end
end

function _M:incFeedback(v, set)
	if not set then
		local p = self:isTalentActive(self.T_MIND_STORM)
		if p then
			local t = self:getTalentFromId(self.T_MIND_STORM)
			local overcharge_gain = math.floor((v + self:getFeedback() - self:getMaxFeedback()) / t.getOverchargeRatio(self, t))
			if overcharge_gain > 0 then
				p.overcharge = p.overcharge + overcharge_gain
			end
		end
		self.psionic_feedback = util.bound(self.psionic_feedback + v, 0, self:getMaxFeedback())
	else
		self.psionic_feedback = math.min(v, self:getMaxFeedback())
	end
end

function _M:incMaxFeedback(v, set)
	-- give the actor base feedback if it doesn't have any
	if not self.psionic_feedback then
		self.psionic_feedback = 0
	end

	if not set then
		self.psionic_feedback_max = (self.psionic_feedback_max or 0) + v
	else
		self.psionic_feedback_max = v
	end

	-- auto unlearn feedback if below 0
	if self.psionic_feedback_max <= 0 then
		self.psionic_feedback = nil
		self.psionic_feedback_max = nil
	end
end

function _M:getFeedbackDecay(mult)
	local mult = self:callTalent(self.T_BIOFEEDBACK, "getDecaySpeed") or 1
	if self.psionic_feedback and self.psionic_feedback > 0 then
		local feedback_decay = math.max(1, self.psionic_feedback*mult / 10)
		return feedback_decay
	else
		return 0
	end
end

function _M:alterTalentCost(t, rname, cost)
	return cost
end

--- Called before a talent is used
-- Check the actor can cast it
-- @param ab the talent (not the id, the table)
-- @return true to continue, false to stop
function _M:preUseTalent(ab, silent, fake)
	if self.forbid_talents and self.forbid_talents[ab.id] then
		if not silent then game.logSeen(self, self.forbid_talents[ab.id] or "%s can not use %s.", self.name:capitalize(), ab.name) end
		return false
	end

	if not self:attr("no_talent_fail") then
	if not ab.never_fail and self:attr("feared") and (ab.mode ~= "sustained" or not self:isTalentActive(ab.id)) then
		if not silent then game.logSeen(self, "%s is too afraid to use %s.", self.name:capitalize(), ab.name) end
		return false
	end
	-- When silenced you can deactivate spells but not activate them
	if ab.no_silence and self:attr("silence") and (ab.mode ~= "sustained" or not self:isTalentActive(ab.id)) then
		if not silent then game.logSeen(self, "%s is silenced and cannot use %s.", self.name:capitalize(), ab.name) end
		return false
	end
	if ab.is_spell and self:attr("forbid_arcane") and (ab.mode ~= "sustained" or not self:isTalentActive(ab.id)) then
		if not silent then game.logSeen(self, "The spell fizzles.") end
		return false
	end
	-- Nature is forbidden to undead (just wild-gifts for now)
	if ab.is_nature and self:attr("forbid_nature") and (ab.mode ~= "sustained" or not self:isTalentActive(ab.id)) then
		if not silent then game.logSeen(self, "%s is too disconnected from Nature to use %s.", self.name:capitalize(), ab.name) end
		return false
	end

	if ab.is_inscription and self.inscription_restrictions and not self.inscription_restrictions[ab.type[1]] then
		if not silent then game.logSeen(self, "%s is unable to use this kind of inscription.", self.name:capitalize()) end
		return false
	end
	if ab.is_inscription and self.inscription_forbids and self.inscription_forbids[ab.type[1]] then
		if not silent then game.logSeen(self, "%s is unable to use this kind of inscription.", self.name:capitalize()) end
		return false
	end

	-- when using unarmed techniques check for weapons and heavy armor
	if ab.is_unarmed and not (ab.mode == "sustained" and self:isTalentActive(ab.id)) then
		-- first check for heavy and massive armor
		if self:hasMassiveArmor() then
			if not silent then game.logSeen(self, "%s is too heavily armoured to use this talent.", self.name:capitalize()) end
			return false
		-- next make sure we're unarmed
		elseif not self:isUnarmed() then
			if not silent then game.logSeen(self, "%s can't use this talent while holding a weapon or shield.", self.name:capitalize()) end
			return false
		end
	end
	
	-- Sleeping prevents the use of all non-instant talents
	if self:attr("sleep") and not self:attr("lucid_dreamer") and (ab.mode ~= "sustained" or not self:isTalentActive(ab.id)) and util.getval(ab.no_energy, self, ab) ~= (true or "fake") then
		if not silent then game.logPlayer(self, "%s is sleeping and unable to do this.", self.name:capitalize(), ab.name) end
		return false
	end
	
	if not self:enoughEnergy() and not fake then return false end

	if ab.mode == "sustained" then
		if not self:isTalentActive(ab.id) then
			local cost
			-- check sustained costs
			for res, res_def in ipairs(_M.resources_def) do
				cost = ab[res_def.sustain_prop]
				if cost then
					cost = util.getval(cost, self, ab) or 0
					cost = self:alterTalentCost(ab, res_def.sustain_prop, cost)
					rmin, rmax = self[res_def.getMinFunction](self), self[res_def.getMaxFunction](self)
					if cost ~= 0 and self[res_def.minname] and self[res_def.maxname] and self[res_def.minname] + cost > self[res_def.maxname] then
						if not silent then game.logPlayer(self, "You %s %s to activate %s.", res_def.invert_values and "have too much committed" or "do not have enough uncommitted", res_def.name, ab.name) end
						return false
					end
				end
			end
		end
	elseif not self:attr("force_talent_ignore_ressources") then
		if ab.feedback and self:getFeedback() < util.getval(ab.feedback, self, ab) * (100 + 2 * self:combatFatigue()) / 100 then
			if not silent then game.logPlayer(self, "You do not have enough feedback to use %s.", ab.name) end
			return false
		end
		if ab.fortress_energy and game:getPlayer(true):hasQuest("shertul-fortress") and game:getPlayer(true):hasQuest("shertul-fortress").shertul_energy < ab.fortress_energy then
			if not silent then game.logPlayer(self, "You do not have enough fortress energy to use %s.", ab.name) end
			return false
		end
	end
	
	-- check resource costs (sustains can always be deactivated at no cost)
	if not self:attr("force_talent_ignore_ressources") and not self:isTalentActive(ab.id) and (not self.talent_no_resources or not self.talent_no_resources[ab.id]) then
		local rname, cost, rmin, rmax
		-- check for sustained resources
		self.on_preuse_checking_resources = true
		for res, res_def in ipairs(_M.resources_def) do
			rname = res_def.short_name
			cost = ab[rname]
			if cost then
				cost = (util.getval(cost, self, ab) or 0) * (util.getval(res_def.cost_factor, self, ab, true) or 1)
				cost = self:alterTalentCost(ab, rname, cost)
				if cost ~= 0 then
					rmin, rmax = self[res_def.getMinFunction](self), self[res_def.getMaxFunction](self)
					if res_def.invert_values then
						if not res_def.ignore_max_use and rmax and self[res_def.getFunction](self) + cost > rmax then -- too much
							if not silent then game.logPlayer(self, "You have too much %s to use %s.", res_def.name, ab.name) end
							self.on_preuse_checking_resources = nil
							return false
						end
					else
						if rmin and self[res_def.getFunction](self) - cost < rmin then -- not enough
							if not silent then game.logPlayer(self, "You do not have enough %s to use %s.", res_def.name, ab.name) end
							self.on_preuse_checking_resources = nil
							return false
						end
					end
				end
			end
		end
		self.on_preuse_checking_resources = nil
	end
	if not ab.never_fail then
		-- Equilibrium is special, it has no max, but the higher it is the higher the chance of failure (and loss of the turn)
		-- But it is not affected by fatigue
		if (ab.equilibrium or (ab.sustain_equilibrium and not self:isTalentActive(ab.id))) and not fake and not self:attr("force_talent_ignore_ressources") then
			-- Fail ? lose energy and 1/10 more equilibrium
			if (not self:attr("no_equilibrium_fail") and (not self:attr("no_equilibrium_summon_fail") or not ab.is_summon)) and not self:equilibriumChance(ab.equilibrium or ab.sustain_equilibrium) then
				if not silent then game.logPlayer(self, "You fail to use %s due to your equilibrium!", ab.name) end
				self:incEquilibrium((ab.equilibrium or ab.sustain_equilibrium) / 10)
				self:useEnergy()
				return false
			end
		end

		-- Spells can fail
		if (ab.is_spell and not self:isTalentActive(ab.id)) and not fake and self:attr("spell_failure") then
			if rng.percent(self:attr("spell_failure")) then
				if not silent then game.logSeen(self, "%s's %s has been disrupted by #ORCHID#anti-magic forces#LAST#!", self.name:capitalize(), ab.name) end
				self:useEnergy()
				self:fireTalentCheck("callbackOnTalentDisturbed", ab)
				return false
			end
		end

		-- Nature can fail
		if (ab.is_nature and not self:isTalentActive(ab.id)) and not fake and self:attr("nature_failure") then
			if rng.percent(self:attr("nature_failure")) then
				if not silent then game.logSeen(self, "%s's %s has been disrupted by #ORCHID#anti-nature forces#LAST#!", self.name:capitalize(), ab.name) end
				self:useEnergy()
				self:fireTalentCheck("callbackOnTalentDisturbed", ab)
				return false
			end
		end

		-- Chronomancy can fail, causing an anomaly but returning Paradox
		if (ab.paradox or (ab.sustain_paradox and not self:isTalentActive(ab.id))) and not fake and not self:attr("force_talent_ignore_ressources") then
			-- Random anomalies reduce paradox by twice the talent's paradox cost
			local cost = util.getval(ab.paradox or ab.sustain_paradox, self, ab)
			if cost > 0 then
				if self:paradoxDoAnomaly(self:paradoxFailChance(), cost * 2, {anomaly_type=ab.anomaly_type or nil, silent=silent}) then
					game:playSoundNear(self, "talents/dispel")
					return false
				end
			end
		end
	end
	if self:triggerHook{"Actor:preUseTalent", t=ab, silent=silent, fake=fake} then
		return false
	end

	if not ab.never_fail then
		-- Confused ? lose a turn!
		if self:attr("confused") and (ab.mode ~= "sustained" or not self:isTalentActive(ab.id)) and util.getval(ab.no_energy, self, ab) ~= true and not fake and not self:attr("force_talent_ignore_ressources") then
			if rng.percent(self:attr("confused")) then
				if not silent then game.logSeen(self, "%s is confused and fails to use %s.", self.name:capitalize(), ab.name) end
				self:useEnergy()
				return false
			end
		end
		
		-- Failure chance?
		if self:attr("talent_fail_chance") and (ab.mode ~= "sustained" or not self:isTalentActive(ab.id)) and util.getval(ab.no_energy, self, ab) ~= true and not fake and not self:attr("force_talent_ignore_ressources") and not ab.innate then
			if rng.percent(self:attr("talent_fail_chance")) then
				if not silent then game.logSeen(self, "%s fails to use %s.", self.name:capitalize(), ab.name) end
				self:useEnergy()
				return false
			end
		end

		-- terrified effect
		if self:attr("terrified") and (ab.mode ~= "sustained" or not self:isTalentActive(ab.id)) and util.getval(ab.no_energy, self, ab) ~= true and not fake and not self:attr("force_talent_ignore_ressources") then
			local eff = self:hasEffect(self.EFF_TERRIFIED)
			if rng.percent(self:attr("terrified")) then
				if not silent then game.logSeen(self, "%s is too terrified to use %s.", self.name:capitalize(), ab.name) end
				self:useEnergy()
				return false
			end
		end
		
		-- Fumble
		if self:attr("scoundrel_failure") and (ab.mode ~= "sustained" or not self:isTalentActive(ab.id)) and util.getval(ab.no_energy, self, ab) ~= true and not fake and not self:attr("force_talent_ignore_ressources") then
			local eff = self:hasEffect(self.EFF_FUMBLE)
			if rng.percent(self:attr("scoundrel_failure")) then
				if not silent then game.logSeen(self, "%s fumbles and fails to use %s, injuring %s!", self.name:capitalize(), ab.name, self:his_her_self()) end
				self:useEnergy()
				self:fireTalentCheck("callbackOnTalentDisturbed", ab)
				return false
			end
		end
		
		if self:hasEffect(self.EFF_SENTINEL) and (ab.mode ~= "sustained" or not self:isTalentActive(ab.id)) and util.getval(ab.no_energy, self, ab) ~= true and not fake and not self:attr("force_talent_ignore_ressources") then
			if not silent then game.logSeen(self, "%s's %s is interrupted by the shot!", self.name:capitalize(), ab.name) end
			self.tempeffect_def[self.EFF_SENTINEL].do_proc(self, self:hasEffect(self.EFF_SENTINEL))
			self:useEnergy()
			self:fireTalentCheck("callbackOnTalentDisturbed", t)
			return false
		end

	end
	-- Special checks
	if ab.on_pre_use and not (ab.mode == "sustained" and self:isTalentActive(ab.id)) and not ab.on_pre_use(self, ab, silent, fake) then return false end

	if self:attr("use_only_arcane") then
		if not ab.use_only_arcane then return false end
		if self:attr("use_only_arcane") < ab.use_only_arcane then return false end
	end

	-- Cant heal
	if ab.is_heal and (self:attr("no_healing") or ((self.healing_factor or 1) <= 0)) then return false end
	if ab.is_teleport and self:attr("encased_in_ice") then return false end

	end

	-- Special checks -- AI
	if not self.player and ab.on_pre_use_ai and not (ab.mode == "sustained" and self:isTalentActive(ab.id)) and not ab.on_pre_use_ai(self, ab, silent, fake) then return false end

	return true
end

--- Display the talent use message in the game log
-- called when the talent is used after successful preUseTalent check
-- @param ab the talent (not the id, the table)
function _M:logTalentMessage(ab)
	if ab.message ~= false and not util.getval(ab.no_message, self, ab) then
		if ab.message then
			game.logSeen(self,  self:useTalentMessage(ab))--不要更改
		elseif ab.mode == "sustained" and not self:isTalentActive(ab.id) then
			game.logSeen(self, "%s activates %s.", self.name:capitalize(), ab.name)
		elseif ab.mode == "sustained" and self:isTalentActive(ab.id) then
			game.logSeen(self, "%s deactivates %s.", self.name:capitalize(), ab.name)	
		elseif ab.is_spell then
			game.logSeen(self, "%s casts %s.", self.name:capitalize(), ab.name)
		else
			game.logSeen(self, "%s uses %s.", self.name:capitalize(), ab.name)
		end
	end
end

--- List of callbacks that can be registered
--	The index is the callback name, matching fields in "object" definitions (ActorTalent, ActorTemporaryEffects, Object)
--  values correspond to the Actor table containing the associated callback info
local sustainCallbackCheck = {
	callbackOnTeleport = "talents_on_teleport",
	callbackOnDealDamage = "talents_on_deal_damage",
	callbackOnHit = "talents_on_hit",
	callbackOnAct = "talents_on_act",
	callbackOnActBase = "talents_on_act_base",
	callbackOnMove = "talents_on_move",
	callbackOnRest = "talents_on_rest",
	callbackOnCombat = "talents_on_combat",
	callbackOnRun = "talents_on_run",
	callbackOnLevelup = "talents_on_levelup",
	callbackOnDeath = "talents_on_death",
	callbackOnDeathbox = "talents_on_deathbox",
	callbackOnSummonDeath = "talents_on_summon_death",
	callbackOnDie = "talents_on_die",
	callbackOnKill = "talents_on_kill",
	callbackOMeleeAttackBonuses = "talents_on_melee_attack_bonus",
	callbackOnMeleeAttack = "talents_on_melee_attack",
	callbackOnMeleeHit = "talents_on_melee_hit",
	callbackOnMeleeMiss = "talents_on_melee_miss",
	callbackOnArcheryAttack = "talents_on_archery_attack",
	callbackOnArcheryHit = "talents_on_archery_hit",
	callbackOnArcheryMiss = "talents_on_archery_miss",
	callbackOnCrit = "talents_on_crit",
	callbackOnStatChange = "talents_on_stat_change",
	callbackOnTakeDamage = "talents_on_take_damage",
	callbackOnTakeDamageBeforeResists = "talents_on_take_damage_before_resists",
	callbackOnHeal = "talents_on_heal",
	callbackOnQuickSwitchWeapons = "talents_on_quick_switch_weapon",
	callbackOnWearTinker = "talents_on_wear_tinker",
	callbackOnTakeoffTinker = "talents_on_takeoff_tinker",
	callbackOnWear = "talents_on_wear",
	callbackOnTakeoff = "talents_on_takeoff",
	callbackOnTalentPost = "talents_on_talent_post",
	callbackOnTemporaryEffect = "talents_on_tmp",
	callbackOnTemporaryEffectRemove = "talents_on_tmp_remove",
	callbackOnTemporaryEffectAdd = "talents_on_tmp_add",
	callbackOnTalentDisturbed = "talents_on_talent_disturbed",
	callbackOnBlock = "talents_on_block",
	callbackOnChangeLevel = "talents_on_change_level",
	callbackOnEffectSave = "talents_on_effect_save",
	callbackOnPartyAdd = "talents_on_party_add",
	callbackOnPartyRemove = "talents_on_party_remove",
	callbackOnTargeted = "talents_on_targeted",
}
_M.sustainCallbackCheck = sustainCallbackCheck

local function convertToString(id)
	if _G.type(id) == "table" then return id.name or tostring(id) end
	return tostring(id)
end

local function callbackKeyLess(x, y)
	local ap, bp = x[1], y[1]
	-- edge case: equal priorities
	if ap == bp then
		if x[2] < y[2] or
			(x[2] == y[2] and x[3] < y[3]) then return true end
		return false
	else return ap < bp end
end

--- Update and sort registered callback information for a callback class
--  callbacks are ordered in ascending priority (default 0)
--  object definitions may contain the field callbackPriorities{event_name1 = priority1, event_name2 = priority2, ...) containing specific priority values to override the default
local function upgradeStore(store, storename)
	if store.__priorities then return end
	print("[CALLBACK] upgrading to prioritized", storename)
	local priorities = {}
	for k,_ in pairs(store) do priorities[k] = 0 end
	store.__priorities = priorities
	local sorted = {}
	for id, _ in pairs(store.__priorities) do
		sorted[#sorted + 1] = {store.__priorities[id], store[id], convertToString(id), id}
	end
	table.sort(sorted, callbackKeyLess)
	store.__sorted = sorted
end

--- Register an object's callbacks to be invoked later with _M:fireTalentCheck or _M:iterCallbacks
--	@param objdef -- an "object" definition (ActorTalent, ActorTemporaryEffects, Object) containing callback functions
--		Allowable callback types are stored in the _MsustainCallbackCheck table
--  @param[string] -- the object id
--  @param objtyp[string, default="talent"] -- the object type ("talent", "effect", "object", ...)
function _M:registerCallbacks(objdef, objid, objtype)
	for event, store in pairs(sustainCallbackCheck) do
		if objdef[event] then
			local cb = self[store] or {}
			upgradeStore(cb, store)
			if not cb[objid] then
				cb[objid] = objtype
				-- extract a priority, 0 by default, lower values evaluate first
				cb.__priorities[objid] = (objdef.callbackPriorities and objdef.callbackPriorities[event]) or 0
				self[store] = cb
				-- insert into priorities
				local sortedkey = {cb.__priorities[objid], objtype, convertToString(objid), objid}
				local idx = #cb.__sorted + 1
				for i, key in ipairs(cb.__sorted) do
					if callbackKeyLess(sortedkey, key) then
						idx = i
						break
					end
				end
				table.insert(cb.__sorted, idx, sortedkey)
			end
		end
	end
end

--- Unregister an object's callbacks
--	@param objdef -- an object definition (ActorTalent, ActorTemporaryEffects, Object) containing callback functions
--		indexed in the sustainCallbackCheck table
--  @param objid -- the object id
function _M:unregisterCallbacks(objdef, objid)
	for event, store in pairs(sustainCallbackCheck) do
		if self[store] and self[store][objid] then
			upgradeStore(self[store], store)
			self[store][objid] = nil
			self[store].__priorities[objid] = nil
			local idx = nil
			for i, key in ipairs(self[store].__sorted) do
				if key[4] == objid then
					idx = i
					break
				end
			end
			if idx then table.remove(self[store].__sorted, idx) end
			if not next(self[store].__priorities) then self[store] = nil end
		end
	end
end

--- Trigger all registered callbacks for an event
--  @param event[string] = event name (index in the _M.sustainCallbackCheck table)
--  @return ret[table or false] returned from the last callback to return a value[table]
--  callbacks are called as follows:
--  effects:  self:callEffect(effect_id, event, ...)
--  objects:  object:check(event, self, ...)
--  others (incl. talents): self:callTalent(tid, event, ...)
--  (refer to specific invocations of this function for additional function arguments)
function _M:fireTalentCheck(event, ...)
	local store = sustainCallbackCheck[event]
	local ret = false
	if self[store] then upgradeStore(self[store], store) end
	if self[store] and next(self[store].__priorities) then
		local old_ps = self.__project_source
		for _, info in ipairs(self[store].__sorted) do
			local priority, kind, stringId, tid = unpack(info)
			if kind == "effect" then
				self.__project_source = self.tmp[tid]
				ret = self:callEffect(tid, event, ...) or ret
			elseif kind == "object" then
				self.__project_source = tid
				self.__object_use_running = tid
				ret = tid:check(event, self, ...) or ret
				self.__object_use_running = nil
			else
				self.__project_source = self.sustain_talents[tid]
				ret = self:callTalent(tid, event, ...) or ret
			end
			self.__project_source = old_ps
		end
	end
	return ret
end

--- Generate an iterator to invoke all registered callbacks for an event
--  @param event[string] = event name (index in the _M.sustainCallbackCheck table)
--  @return a function (lua iterator) that will return wrapper functions that each invoke a registered callback for the event
--  Each wrapper function executes as follows:
--  effects:  return self:callEffect(effect_id, event, ...)
--  objects:  return object:check(event, self, ...)
--  others (incl. talents):  return self:callTalent(tid, event, ...)
--  Additional arguments should be passed to the wrapper function when it is called.
function _M:iterCallbacks(event)
	local store = sustainCallbackCheck[event]
	local cbs = {}
	if self[store] then upgradeStore(self[store], store) end
	if self[store] and next(self[store].__priorities) then
		local iter = 1
		return function()
			if not self[store] or not self[store].__sorted then return end
			local info = self[store].__sorted[iter]
			if not info then return end
			iter = iter + 1
			local priority, kind, stringId, tid = unpack(info)
			if kind == "effect" then
				return function(...)
					local old_ps = self.__project_source
					self.__project_source = self.tmp[tid]
					local ret = self:callEffect(tid, event, ...)
					self.__project_source = old_ps
					return ret
				end, priority, kind
			elseif kind == "object" then
				return function(...)
					local old_ps = self.__project_source
					self.__project_source = tid
					local ret = tid:check(event, self, ...)
					self.__project_source = old_ps
					return ret
				end, priority, kind
			else
				return function(...)
					local old_ps = self.__project_source
					self.__project_source = self.sustain_talents[tid]
					local ret = self:callTalent(tid, event, ...)
					self.__project_source = old_ps
					return ret
				end, priority, kind
			end
		end
	end
	return function() return end
end

function _M:getTalentSpeedType(t)
	if t.speed then
		return util.getval(t.speed, self, t)
	elseif t.is_spell then
		return "spell"
	elseif t.is_summon then
		return "summon"
	elseif t.type[1]:find("^technique/archery") then
		return "archery"
	elseif t.type[1]:find("^technique/") then
		return "weapon"
	elseif t.is_mind then
		return "mind"
	else
		return "standard"
	end
end

function _M:getTalentSpeed(t)
	local speed_type = self:getTalentSpeedType(t)
	local speed = self:getSpeed(speed_type)

	-- Quicken
	local p = self:isTalentActive(self.T_QUICKEN)
	if p and p.talent == t.id then
		speed = math.max(0.1, speed - self:callTalent(self.T_QUICKEN, "getPower"))
	end

	local hd = {"Actor:getTalentSpeed", talent = t, speed_type = speed_type, speed = speed,}
	if self:triggerHook(hd) then speed = hd.speed end

	return speed
end

--- Called after a talent is used
-- Check if it must use a turn, mana, stamina, ...
-- @param ab the talent (not the id, the table)
-- @param ret the return of the talent action
-- @return true to continue, false to stop
function _M:postUseTalent(ab, ret, silent)
	if not ret then return end

	self.changed = true

	if self.talent_kind_log then
		if ab.is_spell then self.talent_kind_log.spell = (self.talent_kind_log.spell or 0) + 1 end
		if ab.is_summon then self.talent_kind_log.summon = (self.talent_kind_log.summon or 0) + 1 end
		if ab.is_mind then self.talent_kind_log.mind = (self.talent_kind_log.mind or 0) + 1 end
		if ab.is_nature then self.talent_kind_log.nature = (self.talent_kind_log.nature or 0) + 1 end
	end

	-- Handle inscriptions (delay it so it does not affect current inscription)
	game:onTickEnd(function()
		if ab.type[1] == "inscriptions/infusions" then
			self:setEffect(self.EFF_INFUSION_COOLDOWN, 10, {power=1})
			if self:knowTalent(self.T_FUNGAL_BLOOD) then self:triggerTalent(self.T_FUNGAL_BLOOD) end
		elseif ab.type[1] == "inscriptions/runes" then
			self:setEffect(self.EFF_RUNE_COOLDOWN, 10, {power=1})
		elseif ab.type[1] == "inscriptions/taints" then
			self:setEffect(self.EFF_TAINT_COOLDOWN, 10, {power=1})
		end
	end)

	if not util.getval(ab.no_energy, self, ab) then
		self:useEnergy(self:getTalentSpeed(ab) * game.energy_to_act)

		-- Free melee blow
		if ab.is_spell and ab.mode ~= "sustained" and self:knowTalent(self.T_CORRUPTED_STRENGTH) and not self:attr("forbid_corrupted_strength_blow") and not self.turn_procs.corrupted_strength then
			local tgts = {}
			for _, c in pairs(util.adjacentCoords(self.x, self.y)) do
				local target = game.level.map(c[1], c[2], Map.ACTOR)
				if target and self:reactionToward(target) < 0 then tgts[#tgts+1] = target end
			end
			if #tgts > 0 then
				self.turn_procs.corrupted_strength = true
				DamageType:projectingFor(self, {project_type={talent=self:getTalentFromId(self.T_CORRUPTED_STRENGTH)}})
				self:attackTarget(rng.table(tgts), DamageType.BLIGHT, self:combatTalentWeaponDamage(self.T_CORRUPTED_STRENGTH, 0.5, 1.1), true)
				DamageType:projectingFor(self, nil)
			end
		end
	end

	local trigger = false
	if ab.mode == "sustained" then
		local is_active = self:isTalentActive(ab.id)
		if not is_active then -- check resources
			if ab.sustain_feedback then -- pseudo resource
				trigger = true; self:incMaxFeedback(-util.getval(ab.sustain_feedback, self, ab))
			end
			local cost
			ret._applied_costs,	ret._applied_drains = {}, {} -- to store the resource effects
			for res, res_def in ipairs(_M.resources_def) do
				-- apply sustain costs
				cost = ab[res_def.sustain_prop]
				if cost then
					cost = (util.getval(cost, self, ab) or 0)
					cost = self:alterTalentCost(ab, res_def.sustain_prop, cost)
					if cost ~= 0 then
						trigger = true
						ret._applied_costs[res_def.short_name] = cost
						if res_def.invert_values then
							self[res_def.incMinFunction](self, cost)
						else
							self[res_def.incMaxFunction](self, -cost)
						end
					end
				end
				-- apply drain costs
				cost = ab[res_def.drain_prop]
				if cost then
					cost = util.getval(cost, self, ab) or 0
					cost = self:alterTalentCost(ab, res_def.drain_prop, cost)
					if cost ~= 0 then
						trigger = true
						ret._applied_drains[res_def.short_name] = cost
						if res_def.invert_values then
							self:attr(res_def.regen_prop, cost)
						else
							self:attr(res_def.regen_prop, -cost)
						end
					end
				end
			end
			if ab.sustain_slots then
				if not self.sustain_slots then self.sustain_slots = {} end
				local slots = ab.sustain_slots
				if 'string' == type(slots) then slots = {slots} end
				for _, slot in pairs(slots) do
					local t = self.sustain_slots[slot]
					if t and self:isTalentActive(t) then self:forceUseTalent(t, {ignore_energy=true}) end
					self.sustain_slots[slot] = ab.id
				end
			end
			if not ab.passive_callbacks then self:registerCallbacks(ab, ab.id, "talent") end
		else
			ret = is_active
			if ab.sustain_feedback then -- pseudo resource
				self:incMaxFeedback(util.getval(ab.sustain_feedback, self, ab))
			end
			-- reverse the resource effects  (assumes resource functions are reversible)
			-- release sustain costs
			if ret._applied_costs then
				local res_def
				for res, cost in pairs(ret._applied_costs) do
					res_def = _M.resources_def[res]
					if res_def.invert_values then
						self[res_def.incMinFunction](self, -cost)
					else
						self[res_def.incMaxFunction](self, cost)
					end
				end
			end
			-- reverse resource drains
			if ret._applied_drains then
				local res_def
				for res, cost in pairs(ret._applied_drains) do
					res_def = _M.resources_def[res]
					if res_def.invert_values then
						self:attr(res_def.regen_prop, -cost)
					else
						self:attr(res_def.regen_prop, cost)
					end
				end
			end
			if ab.sustain_slots then
				local slots = ab.sustain_slots
				if 'string' == type(slots) then slots = {slots} end
				for _, slot in pairs(slots) do
					if self.sustain_slots[slot] == ab.id then
						self.sustain_slots[slot] = nil
					end
				end
			end
			if not ab.passive_callbacks then self:unregisterCallbacks(ab, ab.id) end
		end
	end
	-- deduct resource costs
	if not self:attr("force_talent_ignore_ressources") and not ab.fake_ressource and not self:attr("zero_resource_cost") and (not self.talent_no_resources or not self.talent_no_resources[ab.id]) and not self:isTalentActive(ab.id) then
		local rname, cost
		
		if ab.feedback then -- pseudo resource
			trigger = true; self:incFeedback(-util.getval(ab.feedback, self, ab) * (100 + 2 * self:combatFatigue()) / 100)
		end
		if ab.fortress_energy then -- special
			local q = game:getPlayer(true):hasQuest("shertul-fortress")
			if q then
				trigger = true; q.shertul_energy = q.shertul_energy - util.getval(ab.fortress_energy, self, ab)
			end
		end
		-- Vim increases equilibrium
		if ab.vim then
			self:incEquilibrium(util.getval(ab.vim, self, ab) * 5)
		end
		for res, res_def in ipairs(_M.resources_def) do
			rname = res_def.short_name
			cost = ab[rname] and util.getval(ab[rname], self, ab) or 0
			cost = self:alterTalentCost(ab, rname, cost)
			if cost ~= 0 then
				trigger = true
				cost = cost * (util.getval(res_def.cost_factor, self, ab) or 1)
				if res_def.invert_values then
					self[res_def.incFunction](self, cost)
				else
					self[res_def.incFunction](self, -cost)
				end
			end
		end
	end

	local hd = {"Actor:postUseTalent", t=ab, ret=ret, trigger=trigger}
	if self:triggerHook(hd) then
		trigger = hd.trigger
	end
	
	self:fireTalentCheck("callbackOnTalentPost", ab, ret, silent)

	if trigger and self:hasEffect(self.EFF_BURNING_HEX) and not self:attr("talent_reuse") then
		local p = self:hasEffect(self.EFF_BURNING_HEX)
		DamageType:get(DamageType.FIRE).projector(p.src, self.x, self.y, DamageType.FIRE, p.dam)
	end

	-- break stealth, channels, etc...
	if not self.turn_procs.resetting_talents then
		-- Cancel stealth!
		if not util.getval(ab.no_break_stealth, self, ab) and util.getval(ab.no_energy, self, ab) ~= true then self:breakStealth() end
		
		if ab.id ~= self.T_LIGHTNING_SPEED then self:breakLightningSpeed() end
		if ab.id ~= self.T_GATHER_THE_THREADS and ab.is_spell then self:breakChronoSpells() end
		if not ab.no_reload_break then self:breakReloading() end
		self:breakStepUp()
		self:breakSpacetimeTuning()
		--if not (util.getval(ab.no_energy, self, ab) or ab.no_break_channel) and not (ab.mode == "sustained" and self:isTalentActive(ab.id)) then self:breakPsionicChannel(ab.id) end

		for tid, _ in pairs(self.sustain_talents) do
			local t = self:getTalentFromId(tid)
			if t and t.callbackBreakOnTalent then
				-- Break things at the end, only if they are still on
				game:onTickEnd(function()
					if self.sustain_talents[t.id] then self:callTalent(tid, "callbackBreakOnTalent", ab) end
				end)
			end
		end
	end

	if not ab.innate and self:hasEffect(self.EFF_RAMPAGE) and ab.id ~= self.T_RAMPAGE and ab.id ~= self.T_SLAM then
		local eff = self:hasEffect(self.EFF_RAMPAGE)
		value = self.tempeffect_def[self.EFF_RAMPAGE].do_postUseTalent(self, eff, value)
	end

	if ab.is_summon and ab.is_nature and self:attr("heal_on_nature_summon") then
		local tg = {type="ball", range=0, radius=3,}
		self:project(tg, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and self:reactionToward(target) >= 0 then
				target:heal(self:attr("heal_on_nature_summon"), self)
			end
		end)
	end

	if not ab.innate and self:attr("random_talent_cooldown_on_use") and rng.percent(self:attr("random_talent_cooldown_on_use")) then
		local tids = {}
		for tid, lev in pairs(self.talents) do
			local t = self:getTalentFromId(tid)
			if tid ~= ab.id and t and not self.talents_cd[tid] and t.mode == "activated" and not t.innate then tids[#tids+1] = t end
		end
		for t in rng.tableSampleIterator(tids, self:attr("random_talent_cooldown_on_use_nb")) do
			self:startTalentCooldown(t.id, self:attr("random_talent_cooldown_on_use_turns"))
			game.logSeen(self, "%s talent '%s%s' is disrupted by the mind parasite.", self.name:capitalize(), (t.display_entity and t.display_entity:getDisplayString() or ""), t.name)
		end
	end

	if self.turn_procs.anomalies_checked then self.turn_procs.anomalies_checked = nil end  -- clears out anomaly checks

	if config.settings.tome.talents_flyers and not self:attr("save_cleanup") and self.x and self.y and game.level.map.seens(self.x, self.y) then
		local name = (ab.display_entity and ab.display_entity:getDisplayString() or "")..ab.name
		local sx, sy = game.level.map:getTileToScreen(self.x, self.y, true)
		game.flyers:add(sx, sy - game.level.map.tile_h / 2, 20, rng.float(-0.1, 0.1), rng.float(-0.5,-0.8), name, colors.simple(colors.OLIVE_DRAB))
	end

	return true
end

-- Return the talent currently taking up a given sustain slot.
function _M:getSustainSlot(slot)
	if not self.sustain_slots then return end
	return self.sustain_slots[slot]
end

-- Get the sustain which a talent will replace.
function _M:getReplacedSustains(talent)
	if 'string' == type(talent) then talent = self:getTalentFromId(talent) end
	local slots = talent.sustain_slots or {}
	if 'string' == type(slots) then slots = {slots} end
	local ret = {}
	for _, slot in pairs(slots) do
		local t = self:getSustainSlot(slot)
		if t ~= talent.id then table.insert(ret, t) end
	end
	return ret
end

--- Force a talent to activate without using energy or such
function _M:forceUseTalent(t, def)
	if def.no_talent_fail then self:attr("no_talent_fail", 1) end
	if def.no_equilibrium_fail then self:attr("no_equilibrium_fail", 1) end
	if def.no_paradox_fail then self:attr("no_paradox_fail", 1) end
	if def.talent_reuse then self:attr("talent_reuse", 1) end
	if def.save_cleanup then self:attr("save_cleanup", 1) end
	local ret = {engine.interface.ActorTalents.forceUseTalent(self, t, def)}
	if def.no_talent_fail then self:attr("no_talent_fail", -1) end
	if def.no_equilibrium_fail then self:attr("no_equilibrium_fail", -1) end
	if def.no_paradox_fail then self:attr("no_paradox_fail", -1) end
	if def.talent_reuse then self:attr("talent_reuse", -1) end
	if def.save_cleanup then self:attr("save_cleanup", -1) end
	return unpack(ret)
end

-- Remove an effect or sustain.
function _M:removeModifier(id)
	if 'T_' == id:sub(1, 2) then
		self:forceUseTalent(id, {ignore_energy=true})
	elseif 'EFF_' == id:sub(1, 4) then
		self:removeEffect(id)
	end
end

-- Remove a list of effects or sustains.
function _M:removeModifierList(list)
	if not list then return end
	for _, id in ipairs(list) do
		self:removeModifier(id)
	end
end

function _M:breakReloading()
	if self:hasEffect(self.EFF_RELOADING) then
		self:removeEffect(self.EFF_RELOADING)
	end
end

--- Breaks stealth if active
function _M:breakStealth()
	local breaks = self.break_with_stealth
	if breaks and #breaks > 0 then
		if self:hasEffect(self.EFF_SHADOW_DANCE) then return nil end
		local chance = 0
		if self:knowTalent(self.T_UNSEEN_ACTIONS) then
			chance = self:callTalent(self.T_UNSEEN_ACTIONS,"getChance")
		end
		-- Do not break stealth
		if rng.percent(chance) then return end
		
		if self._breaking_stealth then return end
		self._breaking_stealth = true
		self:removeModifierList(breaks)
		self._breaking_stealth = nil
		self.changed = true
	end
end

--- Breaks step up if active
function _M:breakStepUp()
	if self._breaking_step_up then return end
	self._breaking_step_up = true
	local breaks = self.break_with_step_up
	if breaks and #breaks > 0 then self:removeModifierList(breaks) end
	self._breaking_step_up = nil
end

--- Breaks lightning speed if active
function _M:breakLightningSpeed()
	if self:hasEffect(self.EFF_LIGHTNING_SPEED) then
		self:removeEffect(self.EFF_LIGHTNING_SPEED)
	end
end

--- Breaks some chrono spells if active
function _M:breakChronoSpells()
	if self:hasEffect(self.EFF_GATHER_THE_THREADS) then
		self:removeEffect(self.EFF_GATHER_THE_THREADS)
	end
end

function _M:breakSpacetimeTuning()
	if self:hasEffect(self.EFF_SPACETIME_TUNING) then
		self:removeEffect(self.EFF_SPACETIME_TUNING)
	end
end

--- Break Psionic Channels
function _M:breakPsionicChannel(talent)
	if self:isTalentActive(self.T_MIND_STORM) and talent ~= self.T_MIND_STORM then
		self:forceUseTalent(self.T_MIND_STORM, {ignore_energy=true})
	end
	if self:isTalentActive(self.T_DREAM_PRISON) and talent ~= self.T_DREAM_PRISON then
		self:forceUseTalent(self.T_DREAM_PRISON, {ignore_energy=true})
	end
end

--- Return the full description of a talent
-- You may overload it to add more data (like power usage, ...)
function _M:getTalentFullDescription(t, addlevel, config, fake_mastery)
	if not t then return tstring{"no talent"} end

	config = config or {}
	local old = self.talents[t.id]
	if config.force_level then
		self.talents[t.id] = config.force_level
	else
		self.talents[t.id] = (self.talents[t.id] or 0) + (addlevel or 0)
	end

	local oldmastery = nil
	if fake_mastery then
		self.talents_types_mastery[t.type[1]] = fake_mastery - 1
	end

	local d = tstring{}
	d:add({"color",0x6f,0xff,0x83}, "当前技能等级：", {"color",0x00,0xFF,0x00}, ("%.1f"):format(self:getTalentLevel(t)), true)

	if not config.ignore_mode then
		if t.mode == "passive" then d:add({"color",0x6f,0xff,0x83}, "使用模式：", {"color",0x00,0xFF,0x00}, "被动", true)
		elseif t.mode == "sustained" then d:add({"color",0x6f,0xff,0x83}, "使用模式：", {"color",0x00,0xFF,0x00}, "持续", true)
		else d:add({"color",0x6f,0xff,0x83}, "使用模式：", {"color",0x00,0xFF,0x00}, "主动", true)
		end
	end

	if config.custom then
		d:merge(config.custom)
		d:add(true)
	end
	local function getCHNresourcename(name)
			name=name:gsub("Stamina","体力"):gsub("Mana","法力"):gsub("Souls","灵魂"):gsub("Soul","灵魂"):gsub("Equilibrium","失衡")
				 :gsub("Vim","活力"):gsub("Positive","正"):gsub("Negative","负"):gsub("energy","能量"):gsub("Hate","仇恨")
				 :gsub("Paradox","紊乱"):gsub("Psi","意念力"):gsub("Feedback","反馈"):gsub("Steam","蒸汽"):gsub("Insanity","疯狂")
			return name
		end
	if not config.ignore_ressources then
		if t.feedback then d:add({"color",0x6f,0xff,0x83}, "反馈值消耗：", {"color",0xFF, 0xFF, 0x00}, ""..math.round(util.getval(t.feedback, self, t) * (100 + 2 * self:combatFatigue()) / 100, 0.1), true) end
		if t.fortress_energy then d:add({"color",0x6f,0xff,0x83}, "堡垒能量值消耗：", {"color",0x00,0xff,0xa0}, ""..math.round(t.fortress_energy, 0.1), true) end
		if t.sustain_feedback then d:add({"color",0x6f,0xff,0x83}, "持续反馈值消耗：", {"color",0xFF, 0xFF, 0x00}, ""..(util.getval(t.sustain_feedback, self, t)), true) end
		
		-- resource costs?
		for res, res_def in ipairs(_M.resources_def) do
			if not res_def.hidden_resource then
				-- list resource cost
				local cost = t[res_def.short_name] and util.getval(t[res_def.short_name], self, t) or 0
				cost = self:alterTalentCost(t, res_def.short_name, cost)
				if cost ~= 0 then
					cost = cost * (util.getval(res_def.cost_factor, self, t) or 1)
					d:add({"color",0x6f,0xff,0x83}, ("%s 消耗："):format(getCHNresourcename(res_def.name:capitalize())), res_def.color or {"color",0xff,0xa8,0xa8}, ""..math.round(cost, .1), true)
				end
				-- list sustain cost
				cost = t[res_def.sustain_prop] and util.getval(t[res_def.sustain_prop], self, t) or 0
				cost = self:alterTalentCost(t, res_def.sustain_prop, cost)
				if cost ~= 0 then
					d:add({"color",0x6f,0xff,0x83}, ("持续 %s 消耗："):format(getCHNresourcename(res_def.name:capitalize())), res_def.color or {"color",0xff,0xa8,0xa8}, ""..math.round(cost, .1), true)
				end
				-- list drain cost
				cost = t[res_def.drain_prop] and util.getval(t[res_def.drain_prop], self, t) or 0
				cost = self:alterTalentCost(t, res_def.drain_prop, cost)
				if cost ~= 0 then
					if res_def.invert_values then
						d:add({"color",0x6f,0xff,0x83}, ("%s %s: "):format(cost > 0 and "产生" or "消耗", getCHNresourcename(res_def.name:capitalize())), res_def.color or {"color",0xff,0xa8,0xa8}, ""..math.round(math.abs(cost), .1), true)
					else
						d:add({"color",0x6f,0xff,0x83}, ("%s %s: "):format(cost > 0 and "吸收" or "补充", getCHNresourcename(res_def.name:capitalize())), res_def.color or {"color",0xff,0xa8,0xa8}, ""..math.round(math.abs(cost), .1), true)
					end
				end
			end
		end
		self:triggerHook{"Actor:getTalentFullDescription:ressources", str=d, t=t, addlevel=addlevel, config=config, fake_mastery=fake_mastery}
	end
	if t.mode ~= "passive" then
		if self:getTalentRange(t) > 1 then d:add({"color",0x6f,0xff,0x83}, "作用范围：", {"color",0xFF,0xFF,0xFF}, ("%0.1f"):format(self:getTalentRange(t)), true)
		else d:add({"color",0x6f,0xff,0x83}, "作用范围：", {"color",0xFF,0xFF,0xFF}, "近身/单体", true)
		end
		if not config.ignore_ressources then
			if self:getTalentCooldown(t) then d:add({"color",0x6f,0xff,0x83}, ("%s冷却时间："):format(t.fixed_cooldown and "固定 " or ""), {"color",0xFF,0xFF,0xFF}, ""..self:getTalentCooldown(t), true) end
		end
		local speed = self:getTalentProjectileSpeed(t)
		if speed then d:add({"color",0x6f,0xff,0x83}, "飞行时间：", {"color",0xFF,0xFF,0xFF}, ""..(speed * 100).."% 基础速度", true)
		else d:add({"color",0x6f,0xff,0x83}, "飞行时间：", {"color",0xFF,0xFF,0xFF}, "瞬间", true)
		end
		if not config.ignore_use_time then
			local uspeed = " 完整回合"
			local no_energy = util.getval(t.no_energy, self, t)
			local display_speed = util.getval(t.display_speed, self, t)
			if display_speed then
				uspeed = display_speed:gsub("Double","双倍"):gsub("Archery","弓箭"):gsub("of a turn","回合"):gsub("steamtech","蒸汽科技")
			elseif no_energy and type(no_energy) == "boolean" and no_energy == true then
				uspeed = "瞬间 (#LIGHT_GREEN#0%#LAST# 回合)"
			else
				local speed = self:getTalentSpeed(t)
				local speed_type = self:getTalentSpeedType(t)
				if type(speed_type) == "string" then
					speed_type = speed_type:gsub("mind","精神"):gsub("spell","法术"):gsub("weapon","武器"):gsub("archery","弓箭"):gsub("steamtech","蒸汽科技")
																 :gsub("combat","战斗"):gsub("standard","标准"):gsub("movement","移动")
																 :gsub("Double","双倍"):gsub("Archery","弓箭"):gsub("summon","召唤"):gsub("shield","盾牌"):gsub("throwing","投掷")
				else
					speed_type = '特殊'
				end
				uspeed = ("%s (#LIGHT_GREEN#%d%%#LAST# 回合)"):format(speed_type, speed * 100)
			end
			d:add({"color",0x6f,0xff,0x83}, "使用速度：", {"color",0xFF,0xFF,0xFF}, uspeed, true)
			if t.no_break_stealth ~= nil and no_energy ~= true and self:knowTalent(self.T_STEALTH) then
				local nbs, chance = t.no_break_stealth
				if type(t.no_break_stealth) == "function" then
					nbs, chance = t.no_break_stealth(self, t)
					if type(chance) ~= "number" then
						chance = nbs and 100 or 0
					end
				else chance = nbs and 100 or 0
				end
				if chance > 0 then
					d:add({"color",0x6f,0xff,0x83}, "不会破坏潜行:  ", {"color",0xFF,0xFF,0xFF}, ("%d%%"):format(chance), true)
				end
			end
		end
		local is_a = {}

		if t.is_spell then is_a[#is_a+1] = "法术" end
		if t.is_mind then is_a[#is_a+1] = "精神力量" end
		if t.is_nature then is_a[#is_a+1] = "自然之赐" end
		if t.is_antimagic then is_a[#is_a+1] = "反魔法力量" end
		if t.is_summon then is_a[#is_a+1] = "召唤力量" end
		if t.is_steam then is_a[#is_a+1] = "蒸汽力量" end
		if #is_a > 0 then
			d:add({"color",0x6f,0xff,0x83}, "这是：", {"color",0xFF,0xFF,0xFF}, table.concatNice(is_a, ", ", " 和 "), true)
		end
	else
		if not config.ignore_ressources then
			if self:getTalentCooldown(t) then d:add({"color",0x6f,0xff,0x83}, ("%s冷却时间: "):format(t.fixed_cooldown and "固定 " or ""), {"color",0xFF,0xFF,0xFF}, ""..self:getTalentCooldown(t), true) end
		end
	end

	if t.mode == 'sustained' then
		local replaces = self:getReplacedSustains(t)
		if #replaces > 0 then
			for k, v in pairs(replaces) do replaces[k] = self:getTalentFromId(v).name end
			d:add({"color",0x6f,0xff,0x83}, "将关闭: ", {"color",0xFF,0xFF,0xFF}, table.concat(replaces, ', '), true)
		end
	end

	self:triggerHook{"Actor:getTalentFullDescription", str=d, t=t, addlevel=addlevel, config=config, fake_mastery=fake_mastery}

	d:add({"color",0x6f,0xff,0x83}, "描述: ", {"color",0xFF,0xFF,0xFF})
	d:merge(t.info(self, t):toTString():tokenize(" ()[]"))

	self.talents[t.id] = old

	if fake_mastery then
		self.talents_types_mastery[t.type[1]] = oldmastery
	end

	return d
end

--- Get the talent cooldown
-- @param t the talent definition table
-- @param[opt=boolean] base, if true, return the talent defined cooldown, unmodified by other effects
function _M:getTalentCooldown(t, base)
	if not t.cooldown then return end
	local cd = t.cooldown
	if type(cd) == "function" then cd = cd(self, t) end
	if not cd then return end

	-- Can not touch this cooldown
	if t.fixed_cooldown or base then return cd end

	if t.type[1] == "inscriptions/infusions" then
		local eff = self:hasEffect(self.EFF_INFUSION_COOLDOWN)
		if eff and eff.power then cd = cd + eff.power end
	elseif t.type[1] == "inscriptions/runes" then
		local eff = self:hasEffect(self.EFF_RUNE_COOLDOWN)
		if eff and eff.power then cd = cd + eff.power end
	elseif t.type[1] == "inscriptions/taints" then
		local eff = self:hasEffect(self.EFF_TAINT_COOLDOWN)
		if eff and eff.power then cd = cd + eff.power end
	elseif self:attr("arcane_cooldown_divide") and (t.type[1] == "spell/arcane" or t.type[1] == "spell/aether") then
		cd = math.ceil(cd / self.arcane_cooldown_divide)
	end

	if self.talent_cd_reduction[t.id] then cd = cd - self.talent_cd_reduction[t.id] end
	if self.talent_cd_reduction.all then cd = cd - self.talent_cd_reduction.all end
	if self.talent_cd_reduction.allpct then cd = cd - math.ceil(self.talent_cd_reduction.allpct * cd) end

	local eff = self:hasEffect(self.EFF_BURNING_HEX)
	if eff and not self:attr("talent_reuse") then
		cd = 1 + cd * eff.power
	end

	local p = self:isTalentActive(self.T_MATRIX)
	if p and p.talent == t.id then
		cd = math.floor(cd * (1 - self:callTalent(self.T_MATRIX, "getPower")))
	end

	if t.is_spell then
		return math.ceil(cd * (1 - (self.spell_cooldown_reduction or 0)))
	elseif t.is_summon then
		return math.ceil(cd * (1 - (self.summon_cooldown_reduction or 0)))
	else
		return math.ceil(cd)
	end
end

--- Starts a talent cooldown; overloaded from the default to handle talent cooldown reduction
-- @param t the talent to cooldown
-- @param v override the normal cooldown that that, nil to get the normal effect
function _M:startTalentCooldown(t, v)
	t = self:getTalentFromId(t)
	if t.cooldown_override then t = self:getTalentFromId(t.cooldown_override) end
	if v then
		self.talents_cd[t.id] = math.max(v, self.talents_cd[t.id] or 0)
	else
		if not t.cooldown then return end
		local cd = self:getTalentCooldown(t)

		local hd = {"Actor:startTalentCooldown", t=t, cd=cd}
		if self:triggerHook(hd) then cd = hd.cd end

		self.talents_cd[t.id] = cd

		if t.id ~= self.T_REDUX and self:hasEffect(self.EFF_REDUX) then
			local eff = self:hasEffect(self.EFF_REDUX)
			if self:getTalentCooldown(t) <= eff.max_cd and t.mode == "activated" and not t.fixed_cooldown then
				self.talents_cd[t.id] = 0
				self:removeEffect(self.EFF_REDUX)
			end
		end
	end
	if self.talents_cd[t.id] <= 0 then self.talents_cd[t.id] = nil end
	self.changed = true
	if t.cooldownStart then t.cooldownStart(self, t) end
end

--- Alter the remanining cooldown of a talent
-- @param t the talent affect cooldown
-- @param v the value to add/remove to the cooldown
function _M:alterTalentCoolingdown(t, v)
	t = self:getTalentFromId(t)
	if t.cooldown_override then t = self:getTalentFromId(t.cooldown_override) end
	if not self.talents_cd[t.id] then return nil end
	self.talents_cd[t.id] = self.talents_cd[t.id] + v
	if self.talents_cd[t.id] <= 0 then self.talents_cd[t.id] = nil end
	return self.talents_cd[t.id]
end

--- Setup the talent as autocast
function _M:setTalentAuto(tid, v, opt)
	if type(tid) == "table" then tid = tid.id end
	if v then self.talents_auto[tid] = opt
	else self.talents_auto[tid] = nil
	end
end

--- Setups a talent automatic use
function _M:checkSetTalentAuto(tid, v, opt)
	local t = self:getTalentFromId(tid)
	if v then
		local doit = function()
			self:setTalentAuto(tid, true, opt)
			Dialog:simplePopup("Automatic use enabled", t.name:capitalize().." will now be used as often as possible automatically.")
		end

		local list = {}
		if util.getval(t.no_energy, self, t) ~= true then list[#list+1] = "- requires a turn to use" end
		if self:getTalentRequiresTarget(t) then list[#list+1] = "- requires a target, your last hostile one will be automatically used" end
		if t.auto_use_warning then list[#list+1] = t.auto_use_warning end
		if opt == 2 then
			list[#list+1] = "- will only trigger if no enemies are visible"
			list[#list+1] = "- will automatically target you if a target is required"
		end
		if opt == 3 then list[#list+1] = "- will only trigger if enemies are visible" end
		if opt == 4 then list[#list+1] = "- will only trigger if enemies are visible and adjacent" end

		if #list == 0 then
			doit()
		else
			Dialog:yesnoLongPopup("Automatic use", t.name:capitalize()..":\n"..table.concat(list, "\n").."\n Are you sure?", 500, function(ret)
				if ret then doit() end
			end)
		end
	else
		self:setTalentAuto(tid, false)
		Dialog:simplePopup("Automatic use disabled", t.name:capitalize().." will not be automatically used.")
	end
end



-- Classifications for actor resist/damage
-- Thanks to grayswandir for this really neat code structure
_M.classifications = {
	unliving = {undead = true, construct = true, crystal = true},
	unnatural = {demon = true, elemental = true, horror = true, construct = true, undead = true},
	living = function(self) return not self:checkClassification('unliving') end,
	natural = function(self) return not self:checkClassification('unnatural') end,
	summoned = function(self) return (self.summoner ~= nil) end
,}

--- Check if the actor is a certain type or in an arbitrary set of classifications
-- @param string representing the classification to check
-- @return whether the actor is in this classification
function _M:checkClassification(type_str)
	-- Living and Natural are defined as not being Unliving or not Unnatural
	-- Thus, all actors are in one category or the other
	if not self.type or not type_str then return end
	if (tostring(self.type).."/"..tostring(self.subtype) == type_str) or self.type == type_str then return true end
	local class = _M.classifications[type_str]
	if not class then return false end
	if type(class) == 'function' then return class(self) end
	return class[self.type or "unknown"]
end

--- Gains some experience
-- If a levelup happens it calls self:levelup(), modules are encouraged to rewrite it to do whatever is needed.
function _M:gainExp(value)
	if game.state.birth.exp_multiplier then
		value = value * game.state.birth.exp_multiplier
	end
	return engine.interface.ActorLevel.gainExp(self, value)
end

--- How much experience is this actor worth
-- @param target to whom is the exp rewarded
-- @return the experience rewarded
function _M:worthExp(target)
	if not target.level or self.level < target.level - 7 then return 0 end

	local level_mult = game.level.data.exp_worth_mult or 1

	-- HHHHAACKKK ! Use a normal scheme for the game except in the infinite dungeon
	if not game.zone.infinite_dungeon then
		local mult = 0.6
		if self.rank == 1 then mult = 0.6
		elseif self.rank == 2 then mult = 0.8
		elseif self.rank == 3 then mult = 3
		elseif self.rank == 3.2 then mult = 3
		elseif self.rank == 3.5 then mult = 11
		elseif self.rank == 4 then mult = 25
		elseif self.rank >= 5 then mult = 60
		end

		return self.level * mult * self.exp_worth * (target.exp_kill_multiplier or 1) * level_mult
	else
		local mult = 2 + (self.exp_kill_multiplier or 0)
		if self.rank == 1 then mult = 2
		elseif self.rank == 2 then mult = 2
		elseif self.rank == 3 then mult = 3.5
		elseif self.rank == 3.2 then mult = 3.5
		elseif self.rank == 3.5 then mult = 5
		elseif self.rank == 4 then mult = 6
		elseif self.rank >= 5 then mult = 6.5
		end

		return self.level * mult * self.exp_worth * (target.exp_kill_multiplier or 1) * level_mult
	end
end

--- Burn arcane resources
-- @param damage how much to burn
-- @return how much have been burned
function _M:burnArcaneResources(damage)
	local mana = math.min(self:getMana(), damage)
	local vim = math.min(self:getVim(), damage/2)
	local pos = math.min(self:getPositive(), damage/4)
	local neg = math.min(self:getNegative(), damage/4)
	self:incMana(-mana)
	self:incVim(-vim)
	self:incPositive(-pos)
	self:incNegative(-neg)

	return math.max(mana, vim * 2, pos * 4, neg * 4)
end

--- Find effects based on a filter, up to nb.
function _M:effectsFilter(t, nb)
	local effs = {}

	for eff_id, p in pairs(self.tmp) do
		local e = self.tempeffect_def[eff_id]
		if type(t) == "function" then
			if t(e) then effs[#effs+1] = eff_id end
		else
			local test = true
			local include_other = (t.type and t.type=="other") or (t.types and t.types.other)
			test = (not t.ignore_crosstier or not e.subtype["cross tier"])
			test = test and (include_other or e.type ~= "other")  -- only remove other explicitly
			test = test and (not t.type or t.type == e.type)
			test = test and (not t.types or t.types[e.type])
			if t.subtype then
				local valid = false
				for k, _ in pairs(t.subtype) do valid = valid or e.subtype[k] end
				test = test and valid
			end
			test = test and (not t.status or e.status == t.status)
			if test then effs[#effs+1] = eff_id end
		end
	end

	return rng.tableSample(effs, nb)
end

function _M:removeEffectsFilter(t, nb, silent, force, check_remove)
	t = t or {}
	local eff_ids = self:effectsFilter(t, nb)
	for _, eff_id in ipairs(eff_ids) do
		if not check_remove or check_remove(self, eff_id) then
			self:removeEffect(eff_id, silent, force)
		end
	end
	return #eff_ids
end

-- Mix in sustains
local function getSustainType(talent_def)
	if talent_def.is_mind then return "mental"
	elseif talent_def.is_spell then return "spell"
	else return "sustain_generic" end
end

function _M:sustainsFilter(t, nb)
	local ids = {}
	for tid, active in pairs(self.sustain_talents) do
		if active then
			local talent = self:getTalentFromId(tid)
			local ttype = getSustainType(talent)
			local test
			if type(t) == "function" then test = t(talent)
			else
				test = (not t.type or t.type == ttype) and (not t.types or t.types[ttype])
			end
			if test then ids[#ids + 1] = tid end
		end
	end
	return rng.tableSample(ids, nb)
end

function _M:removeSustainsFilter(t, nb, check_remove)
	t = t or {}
	local found = self:sustainsFilter(t, nb)
	for _, tid in ipairs(found) do
		if not check_remove or check_remove(self, tid) then
			self:forceUseTalent(tid, {ignore_energy=true})
		end
	end
	return #found
end

function _M:removeEffectsSustainsFilter(t, nb, check_remove, silent, force)
	t = t or {}
	local objects = {}
	for _, eff_id in ipairs(self:effectsFilter(t)) do
		objects[#objects + 1] = {"effect", eff_id}
	end
	for _, tid in ipairs(self:sustainsFilter(t)) do
		objects[#objects + 1] = {"talent", tid}
	end
	local nbr = 0
	for obj in rng.tableSampleIterator(objects, nb) do
		if not check_remove or check_remove(self, obj) then
			if obj[1] == "effect" then
				self:removeEffect(obj[2], silent, force)
			else
				self:forceUseTalent(obj[2], {ignore_energy=true, silent=silent})
			end
			nbr = nbr + 1
		end
	end
	return nbr
end

function _M:removeEffectsSustainsTable(effs, susts, nb, check_remove, silent, force)
	t = t or {}
	local objects = {}
	for _, eff_id in ipairs(effs) do
		objects[#objects + 1] = {"effect", eff_id}
	end
	for _, tid in ipairs(susts) do
		objects[#objects + 1] = {"talent", tid}
	end
	local nbr = 0
	for obj in rng.tableSampleIterator(objects, nb) do
		if not check_remove or check_remove(self, obj) then
			if obj[1] == "effect" then
				self:removeEffect(obj[2], silent, force)
			else
				self:forceUseTalent(obj[2], {ignore_energy=true, silent=silent})
			end
			nbr = nbr + 1
		end
	end
	return nbr
end

--- Randomly reduce talent cooldowns based on a filter
-- @param t the function to use as a filter on the talent definition or nil to apply to all talents on cooldown
-- @param change the amount to change the cooldown by
-- @param nb the number of times to reduce a talent cooldown
-- @param duplicate boolean representing whether the same talent can be reduced more than once
-- @return the number of times a talent cooldown was reduced
function _M:talentCooldownFilter(t, change, nb, duplicate)
	nb = nb or 100000
	change = change or 1

	local changed = 0
	local talents = {}

	-- For each talent currently on cooldown find its definition (e) and add it to another table if the filter (t) applies
	for tid, cd in pairs(self.talents_cd) do
		if type(t) == "function" then
			local e = self:getTalentFromId(tid)
			if t(e) then talents[#talents+1] = {tid, cd} end
		else -- Apply to all talents on cooldown the filter isn't a function
			talents[#talents+1] = {tid, cd}
		end
	end

	-- Pick random talents in the new table and apply the cooldown change to them
	while #talents > 0 and nb > 0 do
		local i = rng.range(1, #talents)
		local t = talents[i]
		local removed = false

		self:alterTalentCoolingdown(t[1], -change)

		if not duplicate then
			if not removed then table.remove(talents, i) end -- only remove if it hasn't already been removed
		end

		nb = nb - 1
		changed = changed + 1
	end

	return changed
end

--- Suffocate a bit, lose air
function _M:suffocate(value, src, death_message)
	if self:attr("no_breath") then return false, false end
	if self:attr("invulnerable") then return false, false end
	self.air = self.air - value
	local ae = game.level.map(self.x, self.y, Map.ACTOR)
	self.force_suffocate = true
	if self.air <= 0 then
		self.air = 0
		if not self:hasEffect(self.EFF_SUFFOCATING) then
			game.logSeen(self, "#LIGHT_RED#%s starts suffocating to death!", self.name:capitalize())
			self:setEffect(self.EFF_SUFFOCATING, 1, {dam=20})
		end
		return false, true
--		return self:die(src, {special_death_msg=death_message or "suffocated to death"}), true
	end
	return false, true
end

-- Can the actor see the target (Actor or other Entity), recomputes results (does not use can_see_cache)
-- This does not check LOS or such, only the actual ability to see it.<br/>
-- Checks for telepathy, invisibility, stealth, ...
-- @param[type=Entity] actor the target Entity (usually Actor) to be seen
-- @param[type=boolean] def the default result
-- @param[type=number] def_pct the default percent chance
-- @return[1] true or false
-- @return[2] a number from 0 to 100 representing the percent "chance" to be seen
function _M:canSeeNoCache(actor, def, def_pct)
	if not actor then return false, 0 end

	if actor.__is_actor then -- check ESP against actors
		if self.esp_all and self.esp_all > 0 then return true, 100 end -- Full ESP

		-- ESP, see all, or only types/subtypes
		if self.esp then
			local esp = self.esp
			local t, st = tostring(rawget(actor, "type") or "???"), tostring(rawget(actor, "subtype") or "???")
			-- Type based ESP
			if esp[t] and esp[t] > 0 then
				return true, 100
			end
			if esp[t.."/"..st] and esp[t.."/"..st] > 0 then
				return true, 100
			end
		end
	end

	-- Blindness means can't see anything
	if self:attr("blind") then
		return false, 0
	end
	
	-- Concealment
	if actor ~= self and actor.attr and actor:attr("concealment") then
		local dist = core.fov.distance(self.x, self.y, actor.x, actor.y)
		if dist > actor:attr("concealment") then
			return false, 0
		end
	end

	local chance, hit = 100
	-- Check for invisibility. This is a "simple" checkHit between invisible and see_invisible attrs
	if actor ~= self and actor.attr and actor:attr("invisible") then
		-- Special case, 0 see invisible, can NEVER see invisible things
		local def = self:combatSeeInvisible()
		if def <= 0 then return false, 0 end
		hit, chance = self:checkHitOld(def, actor:attr("invisible"), 0, 100)
		end
	-- Check for stealth. Applies cunning and level vs target's stealth attributes
	if actor ~= self and actor.attr and actor:attr("stealth") then
		local def, st_chance = self:combatSeeStealth()
		hit, st_chance = self:checkHitOld(def, actor:attr("stealth") + (actor:attr("inc_stealth") or 0), 0, 100)
		chance = chance*st_chance/100
	end
	if chance < 100 then hit = rng.percent(chance) else hit = true end

	if def ~= nil then
		return def, def_pct
	else
		return hit, chance
	end
end

--- Can the actor see the target (Actor or other Entity)?
-- This does not check LOS or such, only the actual ability to see it.<br/>
-- Checks for telepathy, invisibility, stealth, ...
-- Stores results in self.can_see_cache for later calls
-- @param[type=Actor] actor the target actor to check
-- @param[type=boolean] def the default result
-- @param[type=number] def_pct the default percent chance
-- @return[1] true or false
-- @return[2] a number from 0 to 100 representing the "chance" to be seen
function _M:canSee(actor, def, def_pct)
	if not actor then return false, 0 end

	self.can_see_cache = self.can_see_cache or setmetatable({}, {__mode="k"})
	local s = tostring(def).."/"..tostring(def_pct)

	if self.can_see_cache[actor] and self.can_see_cache[actor][s] then return self.can_see_cache[actor][s][1], self.can_see_cache[actor][s][2] end
	self.can_see_cache[actor] = self.can_see_cache[actor] or {}
	self.can_see_cache[actor][s] = self.can_see_cache[actor][s] or {}

	local res, chance = self:canSeeNoCache(actor, def, def_pct)
	self.can_see_cache[actor][s] = {res,chance}

	-- Make sure the display updates
	if self.player and type(def) == "nil" and actor._mo then actor._mo:onSeen(res) end

	return res, chance
end

--- Reset our own seeing cache
function _M:resetCanSeeCache()
	self.can_see_cache = setmetatable({}, {__mode="k"})
end

--- Reset the cache of everything else that had seen us on the level
function _M:resetCanSeeCacheOf()
	if not game.level then return end
	for uid, e in pairs(game.level.entities) do
		if e.can_see_cache and e.can_see_cache[self] then e.can_see_cache[self] = nil end
	end
	game.level.map:updateMap(self.x, self.y)
end

--- Does the actor have LOS to the target
function _M:hasLOS(x, y, what, range, source_x, source_y)
	source_x = source_x or self.x
	source_y = source_y or self.y
	if not x or not y or not source_x or not source_y then return false, source_x, source_y end
	what = what or "block_sight"
	range = range or self.sight

	-- Is within range, so no need to check every iteration
	if range and core.fov.distance(source_x, source_y, x, y) <= range then range = nil end
	local lx, ly, is_corner_blocked
	local last_x, last_y = source_x, source_y
	if what == "block_sight" then
		local darkVisionRange
		if self:knowTalent(self.T_DARK_VISION) then
			local t = self:getTalentFromId(self.T_DARK_VISION)
			darkVisionRange = self:getTalentRange(t)
		end

		local l = core.fov.line(source_x, source_y, x, y, "block_sight")
		local inCreepingDark = false
		lx, ly, is_corner_blocked = l:step()
		while lx and ly and not is_corner_blocked do
			-- Check for the range
			if range and core.fov.distance(source_x, source_y, lx, ly) > range then
				break
			end
			last_x, last_y = lx, ly
			if game.level.map:checkAllEntities(lx, ly, "block_sight") then
				if darkVisionRange and game.level.map:checkAllEntities(lx, ly, "creepingDark") then
					inCreepingDark = true
				else
					break
				end
			end
			if inCreepingDark and darkVisionRange and core.fov.distance(source_x, source_y, lx, ly) > darkVisionRange then
				break
			end

			lx, ly, is_corner_blocked = l:step()
		end
	else
		local l = core.fov.line(source_x, source_y, x, y, what)
		lx, ly, is_corner_blocked = l:step()
		while lx and ly and not is_corner_blocked do
			-- Check for the range
			if range and core.fov.distance(source_x, source_y, lx, ly) > range then
				break
			end
			last_x, last_y = lx, ly
			if game.level.map:checkAllEntities(lx, ly, what) then break end

			lx, ly, is_corner_blocked = l:step()
		end
	end

	if last_x == x and last_y == y then return true, last_x, last_y end

	return false, last_x, last_y
end

--- Can the target be applied some effects
-- @param what a string describing what is being tried
function _M:canBe(what)
	if what == "poison" and rng.percent(100 * (self:attr("poison_immune") or 0)) then return false end
	if what == "disease" and rng.percent(100 * (self:attr("disease_immune") or 0)) then return false end
	if what == "cut" and rng.percent(100 * (self:attr("cut_immune") or 0)) then return false end
	if what == "confusion" and rng.percent(100 * (self:attr("confusion_immune") or 0)) then return false end
	if what == "blind" and rng.percent(100 * (self:attr("blind_immune") or 0)) then return false end
	if what == "silence" and rng.percent(100 * (self:attr("silence_immune") or 0)) then return false end
	if what == "disarm" and rng.percent(100 * (self:attr("disarm_immune") or 0)) then return false end
	if what == "pin" and (rng.percent(100 * (self:attr("pin_immune") or 0)) or self:attr("levitation") or self:attr("fly")) then return false end
	if what == "stun" and rng.percent(100 * (self:attr("stun_immune") or 0)) then return false end
	if what == "sleep" and rng.percent(100 * (self:attr("sleep_immune") or 0)) then return false end
	if what == "fear" and rng.percent(100 * (self:attr("fear_immune") or 0)) then return false end
	if what == "knockback" and (rng.percent(100 * (self:attr("knockback_immune") or 0)) or self:attr("never_move")) then return false end
	if what == "stone" and rng.percent(100 * (self:attr("stone_immune") or 0)) then return false end
	if what == "instakill" and rng.percent(100 * (self:attr("instakill_immune") or 0)) then return false end
	if what == "anomaly" and rng.percent(100 * (self:attr("anomaly_immune") or 0)) then return false end
	if what == "teleport" and (rng.percent(100 * (self:attr("teleport_immune") or 0)) or self:attr("encased_in_ice")) then return false end
	if what == "worldport" and game.level and game.level.data and game.level.data.no_worldport then return false end
	if what == "planechange" and game.level and game.level.data and game.level.data.no_planechange then return false end
	if what == "summon" and self:attr("suppress_summon") then return false end
	return true
end

-- Tells on_set_temporary_effect() what save to use for a given effect type
local save_for_effects = {
	magical = "combatSpellResist",
	mental = "combatMentalResist",
	physical = "combatPhysicalResist",
}
_M.save_for_effects = save_for_effects

--- Adjust temporary effects
function _M:on_set_temporary_effect(eff_id, e, p)
	p.getName = self.tempeffect_def[eff_id].getName
	p.resolveSource = self.tempeffect_def[eff_id].resolveSource
	if p.apply_power and (save_for_effects[e.type] or p.apply_save) then
		local save = 0
		p.maximum = p.dur
		p.minimum = p.min_dur or 0 --Default minimum duration is 0. Can specify something else by putting min_dur=foo in p when calling setEffect()
		save = self[p.apply_save or save_for_effects[e.type]](self)
		--local duration = p.maximum - math.max(0, math.floor((save - p.apply_power) / 5))
		--local duration = p.maximum - math.max(0, (math.floor(save/5) - math.floor(p.apply_power/5)))
		local percentage = 1 - ((save - p.apply_power)/20)
		local desired = p.maximum * percentage
		local fraction = desired % 1
		desired = math.floor(desired) + (rng.percent(100*fraction) and 1 or 0)
		local duration = math.min(p.maximum, desired)
		p.dur = util.bound(duration, p.minimum or 0, p.maximum)
		p.amount_decreased = p.maximum - p.dur
		local save_type = nil

		if p.apply_save then save_type = p.apply_save else save_type = save_for_effects[e.type] end
		if save_type == "combatPhysicalResist" then p.save_string = "Physical save"
		elseif save_type == "combatMentalResist" then p.save_string = "Mental save"
		elseif save_type == "combatSpellResist" then p.save_string = "Spell save"
		end

		if not p.no_ct_effect and not e.no_ct_effect and e.status == "detrimental" then self:crossTierEffect(eff_id, p.apply_power, p.apply_save or save_for_effects[e.type]) end
		p.total_dur = p.dur

		if p.dur > 0 and e.status == "detrimental" then
			local saved = self:checkHit(save, p.apply_power, 0, 95)
			local hd = {"Actor:effectSave", saved=saved, save=save, save_type=save_type, eff_id=eff_id, e=e, p=p,}
			self:triggerHook(hd)
			self:fireTalentCheck("callbackOnEffectSave", hd)
			saved, eff_id, e, p = hd.saved, hd.eff_id, hd.e, hd.p
			if saved then
				game.logSeen(self, "#ORANGE#%s shrugs off the effect '%s'!", self.name:capitalize(), e.desc)
				return true
			end
		end
	end

	if e.status == "detrimental" and self:knowTalent(self.T_RESILIENT_BONES) then
		p.dur = math.ceil(p.dur * (1 - self:callTalent(self.T_RESILIENT_BONES,"durresist")))
	end
	if e.status == "detrimental" and e.type ~= "other" and self:attr("reduce_detrimental_status_effects_time") then
		local power = util.bound(self.reduce_detrimental_status_effects_time, 0, 100)
		p.dur = math.ceil(p.dur * (1 - (power/100)))
	end
	if self:knowTalent(self.T_VITALITY) and e.status == "detrimental" and (e.subtype.wound or e.subtype.poison or e.subtype.disease) then
		local t = self:getTalentFromId(self.T_VITALITY)
		p.dur = math.ceil(p.dur * (1 - util.bound(t.getWoundReduction(self, t), 0, 1)))
	end
	if self:hasEffect(self.EFF_HAUNTED) and e.subtype and e.subtype.fear then
		local e = self.tempeffect_def[self.EFF_HAUNTED]
		e.on_setFearEffect(self, e)
	end
	if e.status == "detrimental" and e.type ~= "other" and self:attr("negative_status_effect_immune") then
		p.dur = 0
	end
	if e.status == "detrimental" and e.type == "mental" and self:attr("clear_mind_immune") and not e.subtype["cross tier"] then
		p.dur = 0
		self:attr("clear_mind_immune", -1)
		if not self:attr("clear_mind_immune") then self:removeEffect(self.EFF_CLEAR_MIND) end
	end
	if e.status == "detrimental" and e.type == "mental" and self:knowTalent(self.T_UNBREAKABLE_WILL) and not e.subtype["cross tier"] then
		if self:triggerTalent(self.T_UNBREAKABLE_WILL) then p.dur = 0 end
	end
	if e.status == "detrimental" and e.type == "mental" and self:attr("mental_negative_status_effect_immune") and not e.subtype["cross tier"] then
		p.dur = 0
	end
	if e.status == "detrimental" and e.type == "physical" and self:attr("physical_negative_status_effect_immune") and not e.subtype["cross tier"] then
		p.dur = 0
	end
	if e.status == "detrimental" and e.type == "magical" and self:attr("spell_negative_status_effect_immune") and not e.subtype["cross tier"] then
		p.dur = 0
	end
	if self:attr("status_effect_immune") then
		p.dur = 0
	end

	if game.difficulty == game.DIFFICULTY_EASY and self.player and e.status == "detrimental" then
		p.dur = math.ceil(p.dur / 2)
	end

	if p.dur > 0 and not e.subtype["cross tier"] and e.status == "detrimental" and e.type == "physical" and self:knowTalent(self.T_SPINE_OF_THE_WORLD) then
		self:triggerTalent(self.T_SPINE_OF_THE_WORLD)
	end

	if self:fireTalentCheck("callbackOnTemporaryEffect", eff_id, e, p) then return true end

	if self.player and not self.tmp[eff_id] then
		p.__set_time = core.game.getTime()
	end
end

function _M:on_temporary_effect_added(eff_id, e, p)
	self:registerCallbacks(e, eff_id, "effect")
	self:fireTalentCheck("callbackOnTemporaryEffectAdd", eff_id, e, p)
	if e.status == "detrimental" then self:enterCombatStatus() end

	-- Register talent source if any
	if (e.status == "beneficial" or e.status == "neutral") then
		if self.__talent_running then
			p.__talent_source = self.__talent_running.id
		end
		if self.__object_use_running then
			p.__object_source = self.__object_use_running
		end
	end
end

function _M:on_temporary_effect_removed(eff_id, e, p)
	self:unregisterCallbacks(e, eff_id)
	self:fireTalentCheck("callbackOnTemporaryEffectRemove", eff_id, e, p)
	if e.status == "detrimental" then self:enterCombatStatus() end
end

--- Called when we are initiating a projection
function _M:on_project_init(t, x, y, damtype, dam, particles)
	if self:attr("nullify_all_friendlyfire") and not t.ignore_nullify_all_friendlyfire then
		local dt = DamageType:exists(damtype)
		if not dt or not dt.ignore_nullify_all_friendlyfire then
			t.friendlyfire = false
			t.selffire = false
		end
	end
end

--- Called when we are the target of a projection
function _M:on_project_acquire(tx, ty, who, t, x, y, damtype, dam, particles, is_projectile, mods)
	if is_projectile and self:attr("projectile_evasion") and rng.percent(self.projectile_evasion) then
		local spread = self.projectile_evasion_spread or 1
		mods.x = x + rng.range(-spread, spread)
		mods.y = y + rng.range(-spread, spread)

		local dir = game.level.map:compassDirection(mods.x-x, mods.y-y)
		if not dir then
			dir = "but fumbles!"
		else
			dir = "to the "..dir.."!"
		end
		self:logCombat(who, "#Source# deflects the projectile from #Target# %s", dir)
		return true
	end
end

--- Called when we are projected upon
-- This is used to do spell reflection, antimagic, ...
function _M:on_project(tx, ty, who, t, x, y, damtype, dam, particles)
	-- Spell reflect
	if self:attr("spell_reflect") and (t.talent and t.talent.reflectable and t.talent.is_spell) and rng.percent(self:attr("spell_reflect")) then
		game.logSeen(self, "%s reflects the spell!", self.name:capitalize())
		-- Setup the bypass so it does not eternally reflect between two actors
		t.bypass = true
		who:project(t, x, y, damtype, dam, particles)
		return true
	end

	-- Spell absorb
	if self:attr("spell_absorb") and (t.talent and t.talent.is_spell) and rng.percent(self:attr("spell_absorb")) then
		game.logSeen(self, "%s ignores the spell!", self.name:capitalize())
		return true
	end

	return false
end

--- Called when we have been projected upon and the DamageType is about to be called
function _M:projected(tx, ty, who, t, x, y, damtype, dam, particles)
	return false
end

--- Called when we fire a projectile
function _M:on_projectile_fired(proj, typ, x, y, damtype, dam, particles)
	if self:attr("slow_projectiles_outgoing") then
		print("Projectile slowing down from", proj.energy.mod)
		proj.energy.mod = proj.energy.mod * (100 - math.min(90, self.slow_projectiles_outgoing)) / 100
		print("Projectile slowing down to", proj.energy.mod)
	end
end

--- Called when we are targeted by a projectile
function _M:on_projectile_target(x, y, p)
	if self:attr("slow_projectiles") then
		print("Projectile slowing down from", p.energy.mod)
		p.energy.mod = p.energy.mod * (100 - math.min(90, self.slow_projectiles)) / 100
		print("Projectile slowing down to", p.energy.mod)
	end
	if self:knowTalent(self.T_HEIGHTENED_REFLEXES) then
		local t = self:getTalentFromId(self.T_HEIGHTENED_REFLEXES)
		t.do_reflexes(self, t)
	end
	if self:isTalentActive(self.T_GLOOM) and self:knowTalent(self.T_SANCTUARY) then
		-- mark temp table with the sanctuary damage change (to lower using tmp from DamageType:project)
		local t = self:getTalentFromId(self.T_GLOOM)
		if core.fov.distance(self.x, self.y, p.start_x, p.start_y) > self:getTalentRange(t) then
			t = self:getTalentFromId(self.T_SANCTUARY)
			p.tmp_proj.sanctuaryDamageChange = t.getDamageChange(self, t)
			print("Sanctuary marking reduced damage on projectile:", p.tmp_proj.sanctuaryDamageChange)
		end
	end
end

--- Called when we have acquired grids
function _M:on_project_grids(grids)
	if self:attr("encased_in_ice") then
		-- Only hit yourself
		while next(grids) do grids[next(grids)] = nil end
		grids[self.x] = {[self.y]=true}
	end
end

--- Call when added to a level
-- Used to make escorts and such
function _M:addedToLevel(level, x, y)
	if not self._rst_full then self:resetToFull() self._rst_full = true end -- Only do it once, the first time we come into being
	local summoner = self.summoner
	if summoner and summoner:knowTalent(summoner.T_BLIGHTED_SUMMONING) then -- apply blighted summoning
		summoner:callTalent(summoner.T_BLIGHTED_SUMMONING, "doBlightedSummon", self)
	end

	self:updateModdableTile()
	self:recomputeGlobalSpeed()
	if self.make_escort then -- add escorts last, after all other actors have been placed on the level
		game:onTickEnd(function()
			for _, filter in ipairs(self.make_escort) do
				for i = 1, filter.number do
					if not filter.chance or rng.percent(filter.chance) then
					
						-- Find space
						local x, y = util.findFreeGrid(self.x, self.y, 10, true, {[Map.ACTOR]=true})
						if not x then break end

						-- Find an actor with that filter
						local m
						if filter.define_as then m = game.zone:makeEntityByName(game.level, "actor", filter.define_as, true)
						else m = game.zone:makeEntity(game.level, "actor", filter, nil, true) end
						if m and m:canMove(x, y) then
							if filter.no_subescort then m.make_escort = nil end
							if self._empty_drops_escort then m:emptyDrops() end
							game.zone:addEntity(game.level, m, "actor", x, y)
							if filter.post then filter.post(self, m) end
						elseif m then m:removed() end
					end
				end
			end
			self.make_escort = nil
		end, self.uid)
	end

	if game.level.data.zero_gravity then self:setEffect(self.EFF_ZERO_GRAVITY, 1, {})
	else self:removeEffect(self.EFF_ZERO_GRAVITY, nil, true) end

	if game.level.data.effects and game.level.data.effects_allow then
		for _, effid in ipairs(game.level.data.effects) do
			self:setEffect(effid, 1, {})
		end
	end

	self:check("on_added_to_level", level, x, y)
end

--- Called upon dropping an object
function _M:onDropObject(o)
	if self:attr("has_transmo") then o.__transmo = false end
	if self.player then game.level.map.attrs(self.x, self.y, "obj_seen", true)
	elseif game.level.map.attrs(self.x, self.y, "obj_seen") then game.level.map.attrs(self.x, self.y, "obj_seen", false) end
end

function _M:doDrop(inven, item, on_done, nb)
	if self.no_inventory_access then return end
	if self:attr("sleep") and not self:attr("lucid_dreamer") then
		game.logPlayer(self, "You can not drop items while sleeping.")
		return
	end
	local o = self:getInven(inven) and self:getInven(inven)[item]
	if o and o.plot then
		game.logPlayer(self, "You can not drop %s (plot item).", o:getName{do_colour=true})
		return
	end

	if o and o.__tagged then
		game.logPlayer(self, "You can not drop %s (tagged).", o:getName{do_colour=true})
		return
	end

	if game.zone.wilderness then
		Dialog:yesnoLongPopup("Warning", "Any item dropped on the world map will be lost forever.", 300, function(ret)
			-- The test is reversed because the buttons are reversed, to prevent mistakes
			if not ret then
				local o = self:getInven(inven) and self:getInven(inven)[item]
				if o and not o.plot then
					if o:check("on_drop", self) then return end
					local o = self:removeObject(inven, item, true)
					game.logPlayer(self, "You destroy %s.", o:getName{do_colour=true, do_count=true})
					self:sortInven()
					self:useEnergy()
					if on_done then on_done() end
				elseif o then
					game.logPlayer(self, "You can not destroy %s.", o:getName{do_colour=true})
				end
			end
		end, "Cancel", "Destroy", true)
		return
	end
	if nb == nil or nb >= self:getInven(inven)[item]:getNumber() then
		self:dropFloor(inven, item, true, true)
	else
		local stack = self:removeObject(inven, item, nb)
		game.logSeen(self, "%s drops on the floor: %s.", self.name:capitalize(), stack:getName{do_color=true, do_count=true})
		game.level.map:addObject(self.x, self.y, stack)
	end
	self:sortInven(inven)
	self:useEnergy()
	self.changed = true
	game:playSound("actions/drop")
	if on_done then on_done() end
end

--- wear an object from an inventory
--	@param inven = inventory id to take object from
--	@param item = inventory slot to take from
--	@param o = object to wear
--	@param dst = actor holding object to be worn <self>
--  @param force_inven = force wear to this inventory
--  @param force_item = force wear to this inventory slot #
function _M:doWear(inven, item, o, dst, force_inven, force_item)
	if self.no_inventory_access then return end
	dst = dst or self
	if self:attr("sleep") and not self:attr("lucid_dreamer") then
		game.logPlayer(self, "You cannot change your equipment while sleeping!")
		return
	end
	if self:attr("no_equipment_changes") then
		game.logPlayer(self, "You cannot change your equipment!")
		return
	end

	dst:removeObject(inven, item, true)
	local ro, rs = self:wearObject(o, true, true, force_inven, force_item) -- removed object and remaining stack if any
	local added, slot
	if ro then
		if not self:attr("quick_wear_takeoff") or self:attr("quick_wear_takeoff_disable") then self:useEnergy() end
		if self:attr("quick_wear_takeoff") then self:setEffect(self.EFF_SWIFT_HANDS_CD, 1, {}) self.tmp[self.EFF_SWIFT_HANDS_CD].dur = 0 end
		if type(ro) == "table" then dst:addObject(inven, ro, true) end -- always give full stack back
	else -- failed, add object back
		dst:addObject(inven, o, true)
	end
	if type(rs) == "table" then
		local rrs
		repeat -- handles a case of stacking limits causing part of a stack to be discarded
			rrs = rs
			added, slot, rs = dst:addObject(inven, rs)
		until not added or not rs
		if not added then
			game.logPlayer(self, "You had to drop %s due to lack of space.", rrs:getName{do_color = true})
			if rrs and not game.zone.wilderness then game.level.map:addObject(self.x, self.y, rrs) end -- extra stack discarded in wilderness
		end
	end

	-- Tinkers switch
	local removed_o = type(ro) == "table" and ro or nil
	if removed_o and removed_o.tinker and config.settings.tome.tinker_auto_switch then
		local had_tinker = removed_o.tinker
		if not dst:doTakeoffTinker(removed_o, had_tinker, true) then had_tinker = nil end

		if had_tinker then
			local found, titem, tinven = dst:findInAllInventoriesByObject(o)
			local ok = false
			if found and dst:getInven(tinven) then
				ok = dst:doWearTinker(nil, nil, had_tinker, dst:getInven(tinven), titem, found, false)
			end
			if not ok then
				dst:addObject(dst.INVEN_INVEN, had_tinker)
			end
		end
	end

	dst:sortInven()
	self:actorCheckSustains(true)
	self:breakLightningSpeed()
	self:breakReloading()
	self:breakStepUp()
	self.changed = true
end

---	Take off an item
--	@param inven = inven id
--	@param item = slot to remove from
--	@param o = object to remove
--	@param simple set true to skip equipment takeoff checks and energy use
--	@param dst = actor to receive object (in dst.INVEN_INVEN)
--	@param force = set to true to skip sleep & such checks
function _M:doTakeoff(inven, item, o, simple, dst, force)
	dst = dst or self
	if self.no_inventory_access or not dst:canAddToInven(dst.INVEN_INVEN) then return end
	if not force and self:attr("sleep") and not self:attr("lucid_dreamer") then
		game.logPlayer(self, "You cannot change your equipment while sleeping!")
		return
	end
	if self:attr("no_equipment_changes") then
		game.logPlayer(self, "You cannot change your equipment!")
		return
	end

	if self:takeoffObject(inven, item) then
		dst:addObject(dst.INVEN_INVEN, o, true) --note: moves a whole stack
	end
	if not simple then
		dst:sortInven()
		if not self:attr("quick_wear_takeoff") or self:attr("quick_wear_takeoff_disable") then self:useEnergy() end
		if self:attr("quick_wear_takeoff") then self:setEffect(self.EFF_SWIFT_HANDS_CD, 1, {}) self.tmp[self.EFF_SWIFT_HANDS_CD].dur = 0 end
	end
	self:actorCheckSustains(true)
	self:breakLightningSpeed()
	self:breakReloading()
	self:breakStepUp()
	self.changed = true
end

function _M:getEncumberTitleUpdator(title)
	return function()
		local enc, max = self:getEncumbrance(), self:getMaxEncumbrance()
		local color = "#00ff00#"
		if enc > max then color = "#ff0000#"
		elseif enc > max * 0.9 then color = "#ff8a00#"
		elseif enc > max * 0.75 then color = "#fcff00#"
		end
		local str = ("%s - %sEncumbrance %d/%d"):format(title, color, enc, max)
		str = str:gsub(self:transmoGetName(), "转化之盒")
		:gsub("Inventory", "背包")
		:gsub("Pickup", "捡拾物品")
		:gsub("Drop object", "丢弃物品")
		:gsub("Wield/wear object", "穿戴物品")
		:gsub("Take off object", "脱下物品")
		:gsub("Use object", "使用物品")
		:gsub("Equipment", "装备")
		:gsub("Encumbrance", "负重")
		return str
	end
end

function _M:transmoPricemod(o) if o.type == "gem" then return 0.40 else return 0.05 end end
function _M:transmoFilter(o) if o:getPrice() <= 0 or o.quest then return false end return true end
function _M:transmoInven(inven, idx, o, transmo_source)
	local price = 0 
	o:forAllStack(function(so) price = price + math.min(so:getPrice() * self:transmoPricemod(so), 25) end)  -- handle stacked objects individually
	price = math.floor(price * 100) / 100 -- Make sure we get at most 2 digit precision
	if price ~= price or not tostring(price):find("^[0-9]") then price = 1 end -- NaN is the only value that does not equals itself, this is the way to check it since we do not have a math.isnan method
	if inven and idx then self:removeObject(inven, idx, true) end

	if self.hasQuest and self:hasQuest("shertul-fortress") and self:isQuestStatus("shertul-fortress", engine.Quest.COMPLETED, "transmo-chest-extract-gems") and self:knowTalent(self.T_EXTRACT_GEMS) and self:callTalent(self.T_EXTRACT_GEMS, "filterGem", o) then
		local gem = self:callTalent(self.T_EXTRACT_GEMS, "getGem", o)

		if gem then
			local gprice = math.min(gem:getPrice() * self:transmoPricemod(gem), 25) * gem:getNumber()
			gprice = math.floor(gprice * 100) / 100 -- Make sure we get at most 2 digit precision
			if gprice ~= gprice or not tostring(gprice):find("^[0-9]") then gprice = 1 end -- NaN is the only value that does not equals itself, this is the way to check it since we do not have a math.isnan method

			if gprice > price then
				price = gprice
				game.logPlayer(self, "You extract %s from %s", gem:getName{do_color=true, do_count=true}, o:getName{do_color=true, do_count=true})
				o = gem
			end
		end
	end

	self:sortInven()
	self:incMoney(price)
	if self.hasQuest and self:hasQuest("shertul-fortress") and self:isQuestStatus("shertul-fortress", engine.Quest.COMPLETED, "transmo-chest") then self:hasQuest("shertul-fortress"):gain_energy(price/10) end
	game.log("You gain %0.2f gold from the transmogrification of %s.", price, o:getName{do_count=true, do_color=true})
end

function _M:transmoGetNumberItems()
	local inven = self:getInven("INVEN")
	local nb = 0
	for i, o in ipairs(inven) do if o.__transmo then nb = nb + 1 end end
	return nb
end

function _M:transmoHelpPopup()
	Dialog:simplePopup("Transmogrification Chest", "When you close the inventory window, all items in the chest will be transmogrified.")
end

function _M:transmoGetName()
	return "Transmogrification Chest"
end

function _M:transmoGetWord()
	return "transmogrify"
end

function _M:canUseTinker(tinker)
	if not tinker.is_tinker then return nil, "not an attachable item" end
	if not self.can_tinker then return nil, "can not use attachements" end
	if not self.can_tinker[tinker.is_tinker] then return nil, "can not use attachements of this type" end
	if tinker.tinker_allow_attach and tinker:tinker_allow_attach() then return nil, tinker:tinker_allow_attach() end
	return true
end

function _M:doTakeoffTinker(base_o, oldo, only_remove)
	if self:attr("no_equipment_changes") then
		game.logPlayer(self, "You cannot change your equipment!")
		return
	end
	if base_o.tinker ~= oldo then return end

	local _, base_inven
	local mustwear = base_o.wielded
	if mustwear then
		_, _, base_inven = self:findInAllInventoriesByObject(base_o)
		self:onTakeoff(base_o, base_inven, true)
	end
	base_o.tinker = nil
	local forbid = oldo:check("on_untinker", base_o, self)
	if oldo.tinkered then
		for k, id in pairs(oldo.tinkered) do
			if type(id) == "table" then base_o:removeTemporaryValue(id[1], id[2])
			else base_o:removeTemporaryValue(k, id)
			end
		end
	end
	oldo.tinkered = nil
	if mustwear then
		self:onWear(base_o, base_inven, true)
	end

	if not only_remove then self:addObject(self.INVEN_INVEN, oldo) end

	self:fireTalentCheck("callbackOnTakeoffTinker", oldo, base_o)

	game.logPlayer(self, "You detach %s from your %s.", oldo:getName{do_color=true}, base_o:getName{do_color=true})

	return true
end

function _M:doWearTinker(wear_inven, wear_item, wear_o, base_inven, base_item, base_o, can_remove)
	if self:attr("no_equipment_changes") then
		game.logPlayer(self, "You cannot change your equipment!")
		return
	end

	if not base_o and base_inven and base_item then base_o = base_inven[base_item] end
	if not base_o then
		game.logPlayer(self, "You can not use a tinker without the corresponding item.")
		return
	end
	local ok, err = self:canUseTinker(wear_o)
	if not ok then
		game.logPlayer(self, "This item is not usable: %s.", err)
		return
	end
	if wear_o.on_type and wear_o.on_type ~= rawget(base_o, "type") then
		game.logPlayer(self, "This tinker can not be applied to this item.")
		return
	end
	if wear_o.on_subtype and wear_o.on_subtype ~= rawget(base_o, "subtype") then
		game.logPlayer(self, "This tinker can not be applied to this item.")
		return
	end
	if wear_o.on_special and not wear_o.on_special(wear_o, base_o, self) then
		game.logPlayer(self, "This tinker can not be applied to this item.")
		return
	end
	if wear_o.on_slot and wear_o.on_slot ~= base_o.slot then
		game.logPlayer(self, "This tinker can not be applied to this item.")
		return
	end
	if base_o.tinker then
		if not can_remove then
			game.logPlayer(self, "You already have a tinker on this item.")
			return
		else
			self:doTakeoffTinker(base_o, base_o.tinker)
		end
	end

	local mustwear = base_o.wielded
	if mustwear then self:onTakeoff(base_o, base_inven, true) end

	wear_o.tinkered = {}
	local forbid = wear_o:check("on_tinker", base_o, self)
	if wear_o.object_tinker then
		for k, e in pairs(wear_o.object_tinker) do
			wear_o.tinkered[k] = base_o:addTemporaryValue(k, e)
		end
	end

	if mustwear then self:onWear(base_o, base_inven, true) end

	if not forbid then
		base_o.tinker = wear_o
		game.logPlayer(self, "You attach %s to your %s.", wear_o:getName{do_color=true}, base_o:getName{do_color=true})

		if wear_inven and wear_item then self:removeObject(wear_inven, wear_item) end

		self:fireTalentCheck("callbackOnWearTinker", wear_o, base_o)

		return true, base_o
	else
		game.logPlayer(self, "You fail to attach %s to %s.", wear_o:getName{do_color=true}, base_o:getName{do_color=true})
	end
end

function _M:findTinkerSpot(tinker)
	local possible = {}
	self:inventoryApplyAll(function(inven, item, o)
		if not inven.worn then return end
		if self.tinker_restrict_slots and (not self.tinker_restrict_slots[inven.name] or self.tinker_restrict_slots[inven.name] < item) then return end
		if o:canAttachTinker(tinker, true) then
			possible[#possible+1] = {inven=inven, item=item, free=o.tinker and 1 or 0}
		end
	end)
	if #possible == 0 then return end

	-- Find one that has no atatchement if possible, if not replace one
	table.sort(possible, function(a, b)
		if a.free ~= b.free then return a.free < b.free
		elseif a.inven.id ~= b.inven.id then return a.inven.id < b.inven.id
		else return a.item < b.item
		end
	end)
	return possible[1].inven, possible[1].item, possible[1].free == 0
end

function _M:postFOVCombatCheck()
	if self.fov and self.fov.actors_dist then
		for i = 1, #self.fov.actors_dist do
			local act = self.fov.actors_dist[i]
			if act and act.x and not act.dead and not act.ignore_from_combat_compute and self:reactionToward(act) < 0 then
				self:enterCombatStatus(act)
				break
			end
		end
	end
end

function _M:enterCombatStatus(src)
	if src and src.ignore_from_combat_compute then return end
	
	if not self.in_combat then -- Start combat mode
		self.in_combat = game.turn
		self:updateInCombatStatus()
	else -- Update last turn we started combat mode
		self.in_combat = game.turn
	end
end

function _M:checkStillInCombat()
	if not self.in_combat then return end -- Not in combat anyway
	if game.turn - self.in_combat < 50 then return end -- In combat for less than 5 turns, nothing to do

	-- FOV needs no recheck, it's always updating

	-- Damage taken needs no recheck, it's always updating

	-- Damage done needs no recheck, it's always updating

	-- Status effects need rechecking
	for eff_id, p in pairs(self.tmp) do
		local e = self:getEffectFromId(eff_id)
		if e.status == "detrimental" and e.decrease > 0 then self:enterCombatStatus() break end
	end

	if game.turn - self.in_combat < 50 then return end -- Still good?

	-- Ok no more in combat!
	self.in_combat = nil
	self:updateInCombatStatus()
end

function _M:updateInCombatStatus()
	-- if config.settings.cheat then
	-- 	if self.in_combat then
	-- 		game.log("#CRIMSON#--- %s IN COMBAT since %d turns", self.name, (game.turn - self.in_combat) / 10)
	-- 	else
	-- 		game.log("#YELLOW#--- %s OUT OF COMBAT", self.name)
	-- 	end
	-- end

	if self.in_combat then
		self:fireTalentCheck("callbackOnCombat", true)
	else
		self:fireTalentCheck("callbackOnCombat", false)
	end
end
