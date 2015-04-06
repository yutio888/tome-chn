-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2015 Nicolas Casalini
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

-- EDGE TODO: Particles, Timed Effect Particles

newTalent{
	name = "Cosmic Cycle",
	type = {"chronomancy/induced-phenomena", 1},
	require = chrono_req_high1,
	points = 5,
	sustain_paradox = 36,
	mode = "sustained",
	no_sustain_autoreset = true,
	cooldown = 12,
	tactical = { BUFF = 2},
	range = 0,
	radius = function(self, t) local p=self:isTalentActive(self.T_COSMIC_CYCLE) return p and p.radius or 0 end,
	target = function(self, t)
		return {type="ball", range=0, radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	iconOverlay = function(self, t, p)
		local val = p.radius or 0
		if val <= 0 then return "" end
		local fnt = "buff_font"
		return tostring(math.ceil(val)), fnt
	end,
	getWillMultiplier = function(self, t) return self:combatTalentLimit(t, 100, 17, 50)/100 end, --Limit < 100%
	getResistPen = function(self, t) return self:combatTalentLimit(t, 100, 17, 50) end, --Limit < 100%
	callbackOnActBase = function(self, t)
		local p = self:isTalentActive(self.T_COSMIC_CYCLE)
		if not p then return end
		p.old_tgts = p.new_tgts
		p.new_tgts = {}
		
		-- Update our target table
		self:project(self:getTalentTarget(t), self.x, self.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			p.new_tgts[#p.new_tgts+1] = target
		end)

		if self:knowTalent(self.T_REVERSE_CAUSALITY) then
			self:callTalent(self.T_REVERSE_CAUSALITY, "doReverseCausality")
		end
		
		if self:knowTalent(self.T_EPOCH) then
			if p.mode == "expansion" then
				self:callTalent(self.T_EPOCH, "doAging")
			else
				self:callTalent(self.T_EPOCH, "doRegression")
			end
		end
	end,
	doExpansion = function(self, t, radius)
		local p = self:isTalentActive(self.T_COSMIC_CYCLE)
		
		-- Update Radius
		p.radius = radius or p.radius
		self:removeParticles(p.particle)
		p.particle = self:addParticles(Particles.new("circle", 1, {shader=true, toback=true, a=55, appear=0, speed=0.2, img="cycle_expansion", radius=p.radius}))
		
		if p.mode ~= "expansion" then
			-- change mode
			p.mode = "expansion"
			
			-- Update temporary values
			self:removeTemporaryValue("paradox_will_multi", p.will)
			p.resist = self:addTemporaryValue("resists_pen", {[DamageType.TEMPORAL] = t.getResistPen(self, t)})
		end
		
		game.logPlayer(self, "#LIGHT_BLUE#Your cosmic cycle expands.")
		
	end,
	doContraction = function(self, t, radius)
		local p = self:isTalentActive(self.T_COSMIC_CYCLE)
		
		-- Change radius and particles
		p.radius = radius or p.radius
		self:removeParticles(p.particle)
		p.particle = self:addParticles(Particles.new("circle", 1, {shader=true, toback=true, a=55, appear=0, speed=-0.2, img="cycle_contraction", radius=p.radius}))
		
		if p.mode ~= "contraction" then
			p.mode = "contraction"

			-- Update temporary values
			self:removeTemporaryValue("resists_pen", p.resist)
			p.will = self:addTemporaryValue("paradox_will_multi", t.getWillMultiplier(self, t))
		end
		
		game.logPlayer(self, "#LIGHT_RED#Your cosmic cycle contracts.")
		
	end,
	doCosmicCycle = function(self, t)
		game:onTickEnd(function()
			local p = self:isTalentActive(self.T_COSMIC_CYCLE)
			if not p then return end
			local radius = math.floor(self:getParadox()/100)
			
			-- Cycle between expansion and contraction
			if radius > p.radius then
				t.doExpansion(self, t, radius)
			elseif radius < p.radius then
				t.doContraction(self, t, radius)
			end
		end)
	end,
	activate = function(self, t)
		local radius = math.floor(self:getParadox()/100)
		local will = self:addTemporaryValue("paradox_will_multi", 0)
		local resist =  self:addTemporaryValue("resists_pen", {[DamageType.TEMPORAL] = t.getResistPen(self, t)})
		
		local ret ={
			mode = "expansion", radius = radius, new_tgts ={}, old_tgts ={}, resist = resist, will = will,
			particle = self:addParticles(Particles.new("circle", 1, {shader=true, toback=true, a=55, appear=0, speed=0.2, img="cycle_expansion", radius=radius}))
		}
		game:playSoundNear(self, "talents/arcane")
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		self:removeTemporaryValue("resists_pen", p.resist)
		self:removeTemporaryValue("paradox_will_multi", p.will)
		return true	
	end,
	info = function(self, t)
		local paradox = t.getResistPen(self, t)
		local will = t.getWillMultiplier(self, t) * 100
		return ([[Tune yourself into the ebb and flow of spacetime.  When your Paradox crosses a 100 point threshold, your Cosmic Cycle gains or loses one radius.
		While Cosmic Cycle is expanding, your temporal resistance penetration will be increased by %d%%.  While it's contracting, your Willpower for Paradox calculations will be increased by %d%%.]]):
		format(paradox, will)
	end,
}

newTalent{
	name = "Polarity Shift",
	type = {"chronomancy/induced-phenomena",2},
	require = chrono_req_high2,
	points = 5,
	cooldown = 6,
	tactical = { BUFF = 2, ATTACKAREA = {TEMPORAL = 2} },
	direct_hit = true,
	requires_target = true,
	on_pre_use = function(self, t, silent) if not self:isTalentActive(self.T_COSMIC_CYCLE) then if not silent then game.logPlayer(self, "You must have Cosmic Cycle active to use this talent.") end return false end return true end,
	radius = function(self, t) local p=self:isTalentActive(self.T_COSMIC_CYCLE) return p and p.radius or 0 end,
	target = function(self, t)
		return {type="ball", range=0, radius=self:getTalentRadius(t), selffire=false, friendlyfire=false, talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 20, 100) end,
	getBraid = function(self, t) return self:combatTalentSpellDamage(t, 25, 50, getParadoxSpellpower(self, t)) end,
	getDuration = function(self, t) return getExtensionModifier(self, t, math.floor(self:combatTalentScale(t, 3, 7))) end,
	action = function(self, t)
		local p = self:isTalentActive(self.T_COSMIC_CYCLE)
		local tg = self:getTalentTarget(t)
		
		if p.mode == "contraction" then
			self:callTalent(self.T_COSMIC_CYCLE, "doExpansion")
			
			local dam = self:spellCrit(t.getDamage(self, t))
			self:project(tg, self.x, self.y, function(tx, ty)
				local target = game.level.map(tx, ty, engine.Map.ACTOR)
				if not target then return end

				local proj = require("mod.class.Projectile"):makeHoming(
						self,
						{particle="arrow", particle_args={tile=("particles_images/alt_temporal_bolt_0%d"):format(rng.range(1, 7)), proj_x=tx, proj_y=ty, src_x=self.x, src_y=self.y},  trail="trail_paradox"},
						{speed=1, name="Polarity Bolt", dam=dam, movedam=dam},
						target,
						self:getTalentRadius(t),
						function(self, src)
							local DT = require("engine.DamageType")
							DT:get(DT.TEMPORAL).projector(src, self.x, self.y, DT.TEMPORAL, self.def.movedam)
						end,
						function(self, src, target)
							local DT = require("engine.DamageType")
							DT:get(DT.TEMPORAL).projector(src, self.x, self.y, DT.TEMPORAL, self.def.movedam)
						end
					)
				game.zone:addEntity(game.level, proj, "projectile", self.x, self.y)
			end)

		else
			self:callTalent(self.T_COSMIC_CYCLE, "doContraction")

			-- Get our targets
			local braid_targets = {}
			self:project(tg, self.x, self.y, function(tx, ty)
				local target = game.level.map(tx, ty, engine.Map.ACTOR)
				if target then
					braid_targets[#braid_targets+1] = target
				end
			end)
			
			-- if we hit more than one, braid them
			if #braid_targets > 1 then
				for i = 1, #braid_targets do
					local target = braid_targets[i]
					target:setEffect(target.EFF_BRAIDED, t.getDuration(self, t), {power=t.getBraid(self, t), src=self, targets=braid_targets})
				end
			end
		end
		
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local braid = t.getBraid(self, t)
		local duration = t.getDuration(self, t)
		return ([[Reverses the polarity of your Cosmic Cycle.  If it's currently contracting, it will begin to expand, firing a homing missile at each target within the radius that deals %0.2f temporal damage.
		If it's currently expanding, it will begin to contract, braiding the lifelines of all targets within the radius for %d turns.  Braided targets take %d%% of all damage dealt to other braided targets.
		The damage will scale with your Spellpower.]]):format(damDesc(self, DamageType.TEMPORAL, damage), duration, braid)
	end,
}

newTalent{
	name = "Reverse Causality",
	type = {"chronomancy/induced-phenomena", 3},
	require = chrono_req_high3,
	points = 5,
	mode = "passive",
	getHeal = function(self, t) return self:combatTalentSpellDamage(t, 15, 70, getParadoxSpellpower(self, t)) end,
	getReduction= function(self, t) return math.floor(self:combatTalentScale(t, 1, 5)) end,
	doReverseCausality = function(self, t)
		local p = self:isTalentActive(self.T_COSMIC_CYCLE)
		if not p then return end
		
		local keys = table.compareKeys(p.new_tgts, p.old_tgts)
		if p.mode == "expansion" then
			local heal = self:spellCrit(t.getHeal(self, t))
			heal = heal * #keys.left
			if heal > 0 then
				self:heal(heal, self)
			end
		else
			local effs = {}
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.type ~= "other" and e.status == "detrimental" then
					effs[#effs+1] = p
				end
			end
			
			for i=1, #keys.right do
				local eff = effs[i]
				if not eff then break end
				eff.dur = eff.dur - t.getReduction(self, t)
				if eff.dur <= 0 then
					self:removeEffect(eff.effect_id)
					effs[i] = nil
				end
			end
		end
			
	end,
	info = function(self, t)
		local heal = t.getHeal(self, t)
		local reduction = t.getReduction(self, t)
		return ([[When a creature enters your expanding Cosmic Cycle, you heal %d life at the start of your next turn.
		When a creature leaves your contracting Cosmic Cycle, you reduce the duration of one detrimental effect on you by %d at the start of your next turn.
		The healing will scale with your Spellpower.]]):format(heal, reduction)
	end,
}

newTalent{
	name = "Epoch",
	type = {"chronomancy/induced-phenomena", 4},
	require = chrono_req_high4,
	points = 5,
	mode = "passive",
	radius = function(self, t) local p=self:isTalentActive(self.T_COSMIC_CYCLE) return p and p.radius or 0 end,
	target = function(self, t)
		return {type="ball", range=0, radius=self:getTalentRadius(t), selffire=false, friendlyfire=false, talent=t}
	end,
	getRegression = function(self, t) return self:combatTalentSpellDamage(t, 5, 25, getParadoxSpellpower(self, t)) end,
	getAgingChance = function(self, t) return paradoxTalentScale(self, t, 15, 50, 100) end,
	doAging = function(self, t)
		local tg = self:getTalentTarget(t)
		
		self:project(self:getTalentTarget(t), self.x, self.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			
			if rng.percent(t.getAgingChance(self, t)) then
				local effect = rng.range(1, 3)
				if effect == 1 then
					if target:canBe("blind") then
						target:setEffect(target.EFF_BLINDED, 3, {apply_power=getParadoxSpellpower(self, t), no_ct_effect=true})
					else
						game.logSeen(target, "%s resists the blindness!", target.name:capitalize())
					end
				elseif effect == 2 then
					if target:canBe("pin") then
						target:setEffect(target.EFF_PINNED, 3, {apply_power=getParadoxSpellpower(self, t), no_ct_effect=true})
					else
						game.logSeen(target, "%s resists the pin!", target.name:capitalize())
					end
				elseif effect == 3 then
					if target:canBe("confusion") then
						target:setEffect(target.EFF_CONFUSED, 3, {power=50, apply_power=getParadoxSpellpower(self, t), no_ct_effect=true})
					else
						game.logSeen(target, "%s resists the confusion!", target.name:capitalize())
					end
				end
			end
		end)
	end,
	doRegression = function(self, t)
		local tg = self:getTalentTarget(t)
		
		self:project(self:getTalentTarget(t), self.x, self.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			target:setEffect(target.EFF_REGRESSION, 1, {power=t.getRegression(self, t), apply_power=getParadoxSpellpower(self, t), no_ct_effect=true})		
		end)
	end,
	info = function(self, t)
		local regress = t.getRegression(self, t)
		local aging = t.getAgingChance(self, t)
		return ([[While your cosmic cycle is expanding, creatures in its radius have a %d%% chance to suffer the effects of aging; pinning, blinding, or confusing them for 3 turns.
		While your cosmic cycle is contracting, creatures in its radius suffer from age regression; reducing their three highest stats by %d.
		The chance and stat reduction will scale with your Spellpower.]]):format(aging, regress)
	end,
}