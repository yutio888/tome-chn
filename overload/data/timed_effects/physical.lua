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

local Stats = require "engine.interface.ActorStats"
local Particles = require "engine.Particles"
local Entity = require "engine.Entity"
local Chat = require "engine.Chat"
local Map = require "engine.Map"
local Level = require "engine.Level"

-- Item specific
newEffect{
	name = "ITEM_ANTIMAGIC_SCOURED", image = "talents/acidic_skin.png",
	desc = "Scoured",
	long_desc = function(self, eff) return ("被自然酸液冲  刷，降低攻击强度 %d%%."):format(eff.pct*100 or 0) end,
	type = "physical",
	subtype = { acid=true },
	status = "detrimental",
	parameters = {pct = 0.3, spell = 0, mind = 0, phys = 0, power_str = ""},
	on_gain = function(self, err) return "#Target#'s power is greatly reduced!" end,
	on_lose = function(self, err) return "#Target# power has recovered." end,
	on_timeout = function(self, eff)
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "scoured", 1)
	end,
	deactivate = function(self, eff)

	end,
}

newEffect{
	name = "RELENTLESS_TEMPO", image = "talents/sunder_mind.png",
	desc = "Relentless Tempo",
	long_desc = function(self, eff) return ("进入战斗节奏。增  加以下数据：\n闪避:  %d\n全体伤害:  %d%%\n体力回复:  %d\n%s"):
		format( eff.cur_defense or 0, eff.cur_damage or 0, eff.cur_stamina or 0, eff.stacks >= 5 and "全体抗性:  20%" or "") end,
	charges = function(self, eff) return eff.stacks end,
	type = "physical",
	subtype = { tempo=true },
	status = "beneficial",
	on_gain = function(self, err) return "#Target# is gaining tempo.", "+Tempo" end,
	on_lose = function(self, err) return "#Target# loses their tempo.", "-Tempo" end,
	parameters = { stamina = 0, defense = 0, damage = 0, stacks = 0, resists = 0 },
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur =3

		if old_eff.stacks >= 5 then
			if old_eff.resists ~= 20 then
				old_eff.resists = 20
				old_eff.resid = self:addTemporaryValue("resists", {all=old_eff.resists})
			end
			return old_eff
		end

		old_eff.stacks = old_eff.stacks + 1

		self:removeTemporaryValue("stamina_regen", old_eff.staminaid)
		self:removeTemporaryValue("combat_def", old_eff.defenseid)
		self:removeTemporaryValue("inc_damage", old_eff.damageid)

		old_eff.cur_stamina = old_eff.cur_stamina + new_eff.stamina
		old_eff.cur_defense = old_eff.cur_defense + new_eff.defense
		old_eff.cur_damage = old_eff.cur_damage + new_eff.damage

		old_eff.staminaid = self:addTemporaryValue("stamina_regen", old_eff.cur_stamina)
		old_eff.defenseid = self:addTemporaryValue("combat_def", old_eff.cur_defense)
		old_eff.damageid = self:addTemporaryValue("inc_damage", {all = old_eff.cur_damage})

		return old_eff
	end,
	activate = function(self, eff)
		eff.stacks = 1
		eff.cur_stamina = eff.stamina
		eff.cur_defense = eff.defense
		eff.cur_damage = eff.damage

		eff.staminaid = self:addTemporaryValue("stamina_regen", eff.cur_stamina)
		eff.defenseid = self:addTemporaryValue("combat_def", eff.cur_defense)
		eff.damageid = self:addTemporaryValue("inc_damage", {all = eff.cur_damage})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("stamina_regen", eff.staminaid)
		self:removeTemporaryValue("combat_def", eff.defenseid)
		self:removeTemporaryValue("inc_damage", eff.damageid)
		if eff.resid then self:removeTemporaryValue("resists", eff.resid) end
	end,
}

newEffect{
	name = "DELIRIOUS_CONCUSSION", image = "talents/slippery_moss.png",
	desc = "Concussion",
	long_desc = function(self, eff) return ("目标不能正常思考，使用技能会失败。"):format() end,
	type = "physical",
	subtype = { concussion=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target#'s brain isn't quite working right!", "+Concussion" end,
	on_lose = function(self, err) return "#Target# regains their concentration.", "-Concussion" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("talent_fail_chance", 100)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("talent_fail_chance", eff.tmpid)
	end,
}

newEffect{
	name = "CUT", image = "effects/cut.png",
	desc = "Bleeding",
	long_desc = function(self, eff) return ("巨大的伤口使你流失血液，造成每回合 %0.2f 物理伤害。"):format(eff.power) end,
	charges = function(self, eff) return (math.floor(eff.power)) end,
	type = "physical",
	subtype = { wound=true, cut=true, bleed=true },
	status = "detrimental",
	parameters = { power=1 },
	on_gain = function(self, err) return "#Target# starts to bleed.", "+Bleeds" end,
	on_lose = function(self, err) return "#Target# stops bleeding.", "-Bleeds" end,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the flames!
		local olddam = old_eff.power * old_eff.dur
		local newdam = new_eff.power * new_eff.dur
		local dur = math.ceil((old_eff.dur + new_eff.dur) / 2)
		old_eff.dur = dur
		old_eff.power = (olddam + newdam) / dur
		return old_eff
	end,
	activate = function(self, eff)
		if eff.src and eff.src:knowTalent(self.T_BLOODY_BUTCHER) then
			local t = eff.src:getTalentFromId(eff.src.T_BLOODY_BUTCHER)
			local resist = math.min(t.getResist(eff.src, t), math.max(0, self:combatGetResist(DamageType.PHYSICAL)))
			self:effectTemporaryValue(eff, "resists", {[DamageType.PHYSICAL] = -resist})
		end
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.PHYSICAL).projector(eff.src or self, self.x, self.y, DamageType.PHYSICAL, eff.power)
	end,
}

newEffect{
	name = "DEEP_WOUND", image = "talents/bleeding_edge.png",
	desc = "Deep Wound",
	long_desc = function(self, eff) return ("巨大的伤口使你流失血液，造成每回合 %0.2f 物理伤害并降低 %d%% 所有治疗效果。"):format(eff.power, eff.heal_factor) end,
	charges = function(self, eff) return (math.floor(eff.power)) end,	
	type = "physical",
	subtype = { wound=true, cut=true, bleed=true },
	status = "detrimental",
	parameters = {power=10, heal_factor=30},
	on_gain = function(self, err) return "#Target# is cut deeply.", "+Deep Wounds" end,
	on_lose = function(self, err) return "#Target#'s deep wound closes.", "-Deep Wounds" end,
	activate = function(self, eff)
		eff.healid = self:addTemporaryValue("healing_factor", -eff.heal_factor / 100)
		if eff.src and eff.src:knowTalent(self.T_BLOODY_BUTCHER) then
			local t = eff.src:getTalentFromId(eff.src.T_BLOODY_BUTCHER)
			local resist = math.min(t.getResist(eff.src, t), math.max(0, self:combatGetResist(DamageType.PHYSICAL)))
			self:effectTemporaryValue(eff, "resists", {[DamageType.PHYSICAL] = -resist})
		end
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.PHYSICAL).projector(eff.src or self, self.x, self.y, DamageType.PHYSICAL, eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("healing_factor", eff.healid)
	end,
}

newEffect{
	name = "REGENERATION", image = "talents/infusion__regeneration.png",
	desc = "Regeneration",
	long_desc = function(self, eff) return ("生命之流环绕目标，每回合回复 %0.2f 生命值。"):format(eff.power) end,
	type = "physical",
	subtype = { nature=true, healing=true, regeneration=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# starts regenerating health quickly.", "+Regen" end,
	on_lose = function(self, err) return "#Target# stops regenerating health quickly.", "-Regen" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("life_regen", eff.power)

		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1.5, y=-0.3, img="healarcane"}, {type="healing", time_factor=4000, noup=2.0, circleColor={0,0,0,0}, beamsCount=9}))
			eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1.5, y=-0.3, img="healarcane"}, {type="healing", time_factor=4000, noup=1.0, circleColor={0,0,0,0}, beamsCount=9}))
		end

	end,
	on_timeout = function(self, eff)
		if self:knowTalent(self.T_ANCESTRAL_LIFE) then
			local t = self:getTalentFromId(self.T_ANCESTRAL_LIFE)
			self:incEquilibrium(-t.getEq(self, t))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
		self:removeTemporaryValue("life_regen", eff.tmpid)
	end,
}

newEffect{
	name = "POISONED", image = "effects/poisoned.png",
	desc = "Poison",
	long_desc = function(self, eff) return ("目标中毒，每回合受到 %0.2f 自然伤害。"):format(eff.power) end,
	charges = function(self, eff) return (math.floor(eff.power)) end,
	type = "physical",
	subtype = { poison=true, nature=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is poisoned!", "+Poison" end,
	on_lose = function(self, err) return "#Target# stops being poisoned.", "-Poison" end,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the poison
		local olddam = old_eff.power * old_eff.dur
		local newdam = new_eff.power * new_eff.dur
		local dur = math.ceil((old_eff.dur + new_eff.dur) / 2)
		old_eff.dur = dur
		old_eff.power = (olddam + newdam) / dur
		-- by default, can stack up to 5x power
		old_eff.max_power = math.max(old_eff.max_power or old_eff.power, new_eff.max_power or new_eff.power*5)
		old_eff.power = math.min(old_eff.power, old_eff.max_power)
		return old_eff
	end,
	on_timeout = function(self, eff)
		if self:attr("purify_poison") then self:heal(eff.power, eff.src)
		else DamageType:get(DamageType.NATURE).projector(eff.src, self.x, self.y, DamageType.NATURE, eff.power)
		end
	end,
}

newEffect{
	name = "SPYDRIC_POISON", image = "effects/spydric_poison.png",
	desc = "Spydric Poison",
	long_desc = function(self, eff) return ("目标中毒，每回合受到 %0.2f 自然伤害并不能移动（但其他动作不受影响）。"):format(eff.power) end,
	type = "physical",
	subtype = { poison=true, pin=true, nature=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10},
	on_gain = function(self, err) return "#Target# is poisoned and cannot move!", "+Spydric Poison" end,
	on_lose = function(self, err) return "#Target# is no longer poisoned.", "-Spydric Poison" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "never_move", 1)
	end,
	-- There are situations this matters, such as copyEffect
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = math.max(old_eff.dur, new_eff.dur)
		return old_eff
	end,
	on_timeout = function(self, eff)
		if self:attr("purify_poison") then self:heal(eff.power, eff.src)
		else DamageType:get(DamageType.NATURE).projector(eff.src, self.x, self.y, DamageType.NATURE, eff.power)
		end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "INSIDIOUS_POISON", image = "effects/insidious_poison.png",
	desc = "Insidious Poison",
	long_desc = function(self, eff) return ("目标中毒，每回合受到 %0.2f 自然伤害并降低所有治疗效果 %d%%。"):format(eff.power, eff.heal_factor) end,
	charges = function(self, eff) return (math.floor(eff.heal_factor).."%") end,
	type = "physical",
	subtype = { poison=true, nature=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10, heal_factor=30},
	on_gain = function(self, err) return "#Target# is poisoned!", "+Insidious Poison" end,
	on_lose = function(self, err) return "#Target# is no longer poisoned.", "-Insidious Poison" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "healing_factor", -eff.heal_factor / 100)
	end,
	-- There are situations this matters, such as copyEffect
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = math.max(old_eff.dur, new_eff.dur)
		return old_eff
	end,
	on_timeout = function(self, eff)
		if self:attr("purify_poison") then self:heal(eff.power, eff.src)
		else DamageType:get(DamageType.NATURE).projector(eff.src, self.x, self.y, DamageType.NATURE, eff.power)
		end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "CRIPPLING_POISON", image = "talents/crippling_poison.png",
	desc = "Crippling Poison",
	long_desc = function(self, eff) return ("目标中毒，每回合受到 %0.2f 自然伤害，每次使用技能时有 %d%% 概率失败。"):format(eff.power, eff.fail) end,
	charges = function(self, eff) return (math.floor(eff.fail).."%") end,
	type = "physical",
	subtype = { poison=true, nature=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10, fail=5},
	on_gain = function(self, err) return "#Target# is poisoned!", "+Crippling Poison" end,
	on_lose = function(self, err) return "#Target# is no longer poisoned.", "-Crippling Poison" end,
	-- Damage each turn
	on_timeout = function(self, eff)
		if self:attr("purify_poison") then self:heal(eff.power, eff.src)
		else DamageType:get(DamageType.NATURE).projector(eff.src, self.x, self.y, DamageType.NATURE, eff.power)
		end
	end,
	-- There are situations this matters, such as copyEffect
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = math.max(old_eff.dur, new_eff.dur)
		return old_eff
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "talent_fail_chance", eff.fail)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "NUMBING_POISON", image = "effects/numbing_poison.png",
	desc = "Numbing Poison",
	long_desc = function(self, eff) return ("目标中毒，每回合受到 %0.2f 自然伤害并减少其造成伤害 %d%%。"):format(eff.power, eff.reduce) end,
	type = "physical",
	subtype = { poison=true, nature=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10, reduce=5},
	on_gain = function(self, err) return "#Target# is poisoned!", "+Numbing Poison" end,
	on_lose = function(self, err) return "#Target# is no longer poisoned.", "-Numbing Poison" end,
	-- Damage each turn
	on_timeout = function(self, eff)
		if self:attr("purify_poison") then self:heal(eff.power, eff.src)
		else DamageType:get(DamageType.NATURE).projector(eff.src, self.x, self.y, DamageType.NATURE, eff.power)
		end
	end,
	-- There are situations this matters, such as copyEffect
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = math.max(old_eff.dur, new_eff.dur)
		return old_eff
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "numbed", eff.reduce)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "STONE_POISON", image = "talents/stoning_poison.png",
	desc = "Stoning Poison",
	long_desc = function(self, eff)
		local chance = util.bound((eff.turn_count + eff.dur)*100/eff.time_to_stone, 0, 100)
		return ("目标每回合受到 %0.2f 自然伤害。在 %d 回合后, 或者毒药生效时 (%d%% 几率), 目标将被石化 %d 回合."):format(eff.power, eff.time_to_stone - eff.turn_count, chance, eff.stone)
	end,
	type = "physical",
	subtype = { poison=true, earth=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10, stone=1, time_to_stone=10, turn_count=0},
	on_gain = function(self, err) return "#Target# is infused with stone poison!", "+Stoning Poison" end,
	on_lose = function(self, err) return "#Target# is free of the stone poison!", "-Stoning Poison" end,
	on_timeout = function(self, eff) -- Damage each turn, stone after enough time
		if self:attr("purify_poison") then self:heal(eff.power, eff.src)
		else DamageType:get(DamageType.NATURE).projector(eff.src, self.x, self.y, DamageType.NATURE, eff.power)
		end
		eff.turn_count = eff.turn_count + 1
		if eff.turn_count >= eff.time_to_stone and not self.dead then
			eff.turn_count = 0
			self:callEffect(eff.effect_id, "doStone")
		end
	end,
	charges = function(self, eff)
		return eff.time_to_stone - eff.turn_count
	end,
	doStone = function(self, eff, chance) -- turn to stone
		chance = chance or 100
		if self:canBe("stun") and self:canBe("instakill") and self:canBe("stone") and rng.percent(chance) then
			self:removeEffect(eff.effect_id)
			self:setEffect(self.EFF_STONED, math.floor(eff.stone*chance/100), {})
		else
			game.logSeen(self, "#GREY#%s looks stony for a moment, but resists the transformation.", self.name:capitalize())
		end
	end,
	-- There are situations this matters, such as copyEffect
	on_merge = function(self, old_eff, new_eff)
		local new_fct = new_eff.dur/(new_eff.dur + old_eff.dur)
		local dam = old_eff.power*old_eff.dur + new_eff.power*new_eff.dur
		old_eff.stone = math.floor(new_eff.stone*new_fct + old_eff.stone*(1-new_fct))
		old_eff.time_to_stone = math.ceil(new_eff.time_to_stone*new_fct + old_eff.time_to_stone*(1-new_fct))
		old_eff.dur = math.max(old_eff.dur, new_eff.dur)
		old_eff.power = dam/old_eff.dur
		-- by default, can stack up to 5x power
		old_eff.max_power = math.max(old_eff.max_power or old_eff.power, new_eff.max_power or new_eff.power*5)
		old_eff.power = math.min(old_eff.power, old_eff.max_power)
--		old_eff._from_toxic_death = nil
		return old_eff
	end,
	activate = function(self, eff)
		if eff._from_toxic_death then -- reset turn counter if spread from Toxic Death
			eff.turn_count = 0
--			eff._from_toxic_death = nil
		end
	end,
	deactivate = function(self, eff) -- chance to stone when deactivated
		local chance = eff.dur <= 0 and eff.turn_count*100/eff.time_to_stone or 0
		if chance > 0 then self:callEffect(eff.effect_id, "doStone", chance) end
	end,
}

newEffect{
	name = "BURNING", image = "talents/flame.png",
	desc = "Burning",
	long_desc = function(self, eff) return ("目标受到灼烧效果，每回合受到 %0.2f 火焰伤害。"):format(eff.power) end,
	charges = function(self, eff) return (math.floor(eff.power)) end,
	type = "physical",
	subtype = { fire=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is on fire!", "+Burn" end,
	on_lose = function(self, err) return "#Target# stops burning.", "-Burn" end,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the flames!
		local olddam = old_eff.power * old_eff.dur
		local newdam = new_eff.power * new_eff.dur
		local dur = math.ceil((old_eff.dur + new_eff.dur) / 2)
		old_eff.dur = dur
		old_eff.power = (olddam + newdam) / dur
		return old_eff
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.FIRE).projector(eff.src, self.x, self.y, DamageType.FIRE, eff.power)
	end,
}

newEffect{
	name = "BURNING_SHOCK", image = "talents/flameshock.png",
	desc = "Burning Shock",
	long_desc = function(self, eff) return ("目标起火，每回合受到 %0.2f 火焰伤害，造成的伤害降低 50%%，随机 4 个技能进入 CD 并降低移动速度 50%%。受火焰震慑影响，技能冷却速度减半。"):format(eff.power) end,
	charges = function(self, eff) return (math.floor(eff.power)) end,
	type = "physical",
	subtype = { fire=true, stun=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is stunned by the burning flame!", "+Burning Shock" end,
	on_lose = function(self, err) return "#Target# is not stunned anymore.", "-Burning Shock" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("stunned", 1)
		eff.speedid = self:addTemporaryValue("movement_speed", -0.5)
		eff.lockid = self:addTemporaryValue("half_talents_cooldown", 1)

		local tids = {}
		for tid, lev in pairs(self.talents) do
			local t = self:getTalentFromId(tid)
			if t and not self.talents_cd[tid] and t.mode == "activated" and not t.innate and util.getval(t.no_energy, self, t) ~= true then tids[#tids+1] = t end
		end
		for i = 1, 4 do
			local t = rng.tableRemove(tids)
			if not t then break end
			self:startTalentCooldown(t.id, 1)
		end
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.FIRE).projector(eff.src, self.x, self.y, DamageType.FIRE, eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("stunned", eff.tmpid)
		self:removeTemporaryValue("movement_speed", eff.speedid)
		self:removeTemporaryValue("half_talents_cooldown", eff.lockid)
	end,
}

newEffect{
	name = "STUNNED", image = "effects/stunned.png",
	desc = "Stunned",
	long_desc = function(self, eff) return ("目标被震慑，减少造成伤害 50%%, 随机 3 个技能进入 CD 并降低移动速度 50%% 。  震慑时技能冷却时间加倍。"):format() end,
	type = "physical",
	subtype = { stun=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is stunned!", "+Stunned" end,
	on_lose = function(self, err) return "#Target# is not stunned anymore.", "-Stunned" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("stunned", 1)
		eff.speedid = self:addTemporaryValue("movement_speed", -0.5)
		eff.lockid = self:addTemporaryValue("half_talents_cooldown", 1)
		local tids = {}
		for tid, lev in pairs(self.talents) do
			local t = self:getTalentFromId(tid)
			if t and not self.talents_cd[tid] and t.mode == "activated" and not t.innate and util.getval(t.no_energy, self, t) ~= true then tids[#tids+1] = t end
		end
		for i = 1, 3 do
			local t = rng.tableRemove(tids)
			if not t then break end
			self:startTalentCooldown(t.id, 1) -- Just set cooldown to 1 since cooldown does not decrease while stunned
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("stunned", eff.tmpid)
		self:removeTemporaryValue("movement_speed", eff.speedid)
		self:removeTemporaryValue("half_talents_cooldown", eff.lockid)
	end,
}

newEffect{
	name = "DISARMED", image = "talents/disarm.png",
	desc = "Disarmed",
	long_desc = function(self, eff) return "目标受伤，不能使用武器。" end,
	type = "physical",
	subtype = { disarm=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is disarmed!", "+Disarmed" end,
	on_lose = function(self, err) return "#Target# rearms.", "-Disarmed" end,
	activate = function(self, eff)
		self:removeEffect(self.EFF_COUNTER_ATTACKING) -- Cannot parry or counterattack while disarmed
		self:removeEffect(self.EFF_DUAL_WEAPON_DEFENSE) 
		self:removeEffect(self.EFF_PARRY) 
		eff.tmpid = self:addTemporaryValue("disarmed", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("disarmed", eff.tmpid)
	end,
}

newEffect{
	name = "CONSTRICTED", image = "talents/constrict.png",
	desc = "Constricted",
	long_desc = function(self, eff) return ("目标被扼制，不能移动且使其窒息（每回合丢失 %0.2f 空气）。"):format(eff.power) end,
	type = "physical",
	subtype = { grapple=true, pin=true },
	status = "detrimental",
	parameters = {power=10},
	on_gain = function(self, err) return "#Target# is constricted!", "+Constricted" end,
	on_lose = function(self, err) return "#Target# is free to breathe.", "-Constricted" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("never_move", 1)
	end,
	on_timeout = function(self, eff)
		if core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) > 1 or eff.src.dead or not game.level:hasEntity(eff.src) then
			return true
		end
		self:suffocate(eff.power, eff.src, (" was constricted to death by %s."):format(eff.src.unique and eff.src.name or eff.src.name:a_an()))
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("never_move", eff.tmpid)
	end,
}

newEffect{
	name = "DAZED", image = "effects/dazed.png",
	desc = "Dazed",
	long_desc = function(self, eff) return "目标被眩晕，无法移动，所有攻击伤害、闪避、豁免、命中、法术、精神和物理强度减半。任何伤害均会打断眩晕效果。" end,
	type = "physical",
	subtype = { stun=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is dazed!", "+Dazed" end,
	on_lose = function(self, err) return "#Target# is not dazed anymore.", "-Dazed" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "dazed", 1)
		self:effectTemporaryValue(eff, "never_move", 1)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "EVASION", image = "talents/evasion.png",
	desc = "Evasion",
	long_desc = function(self, eff)
		return ("目标有 %d%% 概率躲避近战和远程攻击 "):format(eff.chance) .. ((eff.defense>0 and (" 并增加 %d 点闪避。"):format(eff.defense)) or "") .. "." 
	end,
	type = "physical",
	charges = function(self, eff)
		if self:attr("no_evasion") then return 0 end
		return math.floor(eff.chance).."%"
	end,
	subtype = { evade=true },
	status = "beneficial",
	parameters = { chance=10, defense=0 },
	on_gain = function(self, err) return "#Target# tries to evade attacks.", "+Evasion" end,
	on_lose = function(self, err) return "#Target# is no longer evading attacks.", "-Evasion" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("evasion", eff.chance)
		eff.pid = self:addTemporaryValue("projectile_evasion", eff.chance)
		eff.defid = self:addTemporaryValue("combat_def", eff.defense)
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={size_factor=1.5, img="evasion_tentacles2"}, shader={type="tentacles", wobblingType=0, appearTime=0.8, time_factor=700, noup=0.0}})
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("evasion", eff.tmpid)
		self:removeTemporaryValue("projectile_evasion", eff.pid)
		self:removeTemporaryValue("combat_def", eff.defid)
	end,
}

newEffect{
	name = "SPEED", image = "talents/shaloren_speed.png",
	desc = "Speed",
	long_desc = function(self, eff) return (" 整体速度提升 %d%%。"):format(eff.power * 100) end,
	type = "physical",
	subtype = { speed=true },
	status = "beneficial",
	parameters = { power=0.1 },
	on_gain = function(self, err) return "#Target# speeds up.", "+Fast" end,
	on_lose = function(self, err) return "#Target# slows down.", "-Fast" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
	end,
}

newEffect{
	name = "SLOW", image = "talents/slow.png",
	desc = "Slow",
	long_desc = function(self, eff) return ("整体速度下降 %d%% 。"):format(math.floor(eff.power * 100)) end,
	charges = function(self, eff) return (math.floor(eff.power * 100).."%") end,
	type = "physical",
	subtype = { slow=true },
	status = "detrimental",
	parameters = { power=0.1 },
	on_gain = function(self, err) return "#Target# slows down.", "+Slow" end,
	on_lose = function(self, err) return "#Target# speeds up.", "-Slow" end,
	on_merge = function(self, old_eff, new_eff)
		if new_eff.power > old_eff.power then
			old_eff.power = new_eff.power
			old_eff.dur = new_eff.dur
		end 
		return old_eff
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
	end,
}

newEffect{
	name = "BLINDED", image = "effects/blinded.png",
	desc = "Blinded",
	long_desc = function(self, eff) return "目标被致盲，看不见任何东西。" end,
	type = "physical",
	subtype = { blind=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# loses sight!", "+Blind" end,
	on_lose = function(self, err) return "#Target# recovers sight.", "-Blind" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("blind", 1)
		if game.level then
			self:resetCanSeeCache()
			if self.player then for uid, e in pairs(game.level.entities) do if e.x then game.level.map:updateMap(e.x, e.y) end end game.level.map.changed = true end
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("blind", eff.tmpid)
		if game.level then
			self:resetCanSeeCache()
			if self.player then for uid, e in pairs(game.level.entities) do if e.x then game.level.map:updateMap(e.x, e.y) end end game.level.map.changed = true end
		end
	end,
}

newEffect{
	name = "DWARVEN_RESILIENCE", image = "talents/dwarf_resilience.png",
	desc = "Dwarven Resilience",
	long_desc = function(self, eff) return (" 目标皮肤石化，提升 %d 护甲值，提升 %d 物理豁免和 %d 法术豁免。"):format(eff.armor, eff.physical, eff.spell) end,
	type = "physical",
	subtype = { earth=true },
	status = "beneficial",
	parameters = { armor=10, spell=10, physical=10 },
	on_gain = function(self, err) return "#Target#'s skin turns to stone." end,
	on_lose = function(self, err) return "#Target#'s skin returns to normal." end,
	activate = function(self, eff)
		eff.aid = self:addTemporaryValue("combat_armor", eff.armor)
		eff.pid = self:addTemporaryValue("combat_physresist", eff.physical)
		eff.sid = self:addTemporaryValue("combat_spellresist", eff.spell)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_armor", eff.aid)
		self:removeTemporaryValue("combat_physresist", eff.pid)
		self:removeTemporaryValue("combat_spellresist", eff.sid)
	end,
}

newEffect{
	name = "STONE_SKIN", image = "talents/stoneskin.png",
	desc = "Stoneskin",
	long_desc = function(self, eff) return ("目标皮肤抵抗伤害，提升 %d 护甲值。"):format(eff.power) end,
	type = "physical",
	subtype = { earth=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		eff.aid = self:addTemporaryValue("combat_armor", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_armor", eff.aid)
	end,
}

newEffect{
	name = "THORNY_SKIN", image = "talents/stoneskin.png",
	desc = "Thorny Skin",
	long_desc = function(self, eff) return ("目标的皮肤可以削弱伤害，提升 %d 护甲值和 %d%% 护甲硬度。"):format(eff.ac, eff.hard) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { ac=10, hard=10 },
	on_gain = function(self, err) return "#Target#'s skin looks a bit thorny.", "+Thorny Skin" end,
	on_lose = function(self, err) return "#Target# is less thorny now.", "-Thorny Skin" end,
	activate = function(self, eff)
		eff.aid = self:addTemporaryValue("combat_armor", eff.ac)
		eff.hid = self:addTemporaryValue("combat_armor_hardiness", eff.hard)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_armor", eff.aid)
		self:removeTemporaryValue("combat_armor_hardiness", eff.hid)
	end,
}

newEffect{
	name = "FROZEN_FEET", image = "talents/frozen_ground.png",
	desc = "Frozen Feet",
	long_desc = function(self, eff) return "目标被冻结在原地，可以做其他任何动作但无法移动。" end,
	type = "physical",
	subtype = { cold=true, pin=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is frozen to the ground!", "+Frozen" end,
	on_lose = function(self, err) return "#Target# warms up.", "-Frozen" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("never_move", 1)
		eff.frozid = self:addTemporaryValue("frozen", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("never_move", eff.tmpid)
		self:removeTemporaryValue("frozen", eff.frozid)
	end,
}

newEffect{
	name = "FROZEN", image = "talents/freeze.png",
	desc = "Frozen",
	long_desc = function(self, eff) return ("目标被冻结在冰块中，对其造成的所有伤害有 40％被冰块吸收，目标则受到余下的 60％伤害。冰冻状态下你的闪避无效，你只能攻击冰块，但同时你也不会受到其他负面状态影响（潮湿和冻结双脚除外）。目标被冻结时无法传送也不能回复生命。冰块剩余 %d HP。"):format(eff.hp) end,
	type = "physical", -- Frozen has some serious effects beyond just being frozen, no healing, no teleport, etc.  But it can be applied by clearly non-magical sources i.e. Ice Breath
	charges = function(self, eff) return math.floor(eff.hp) end,	
	subtype = { cold=true, stun=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is encased in ice!", "+Frozen" end,
	on_lose = function(self, err) return "#Target# is free from the ice.", "-Frozen" end,
	activate = function(self, eff)
		-- Change color
		eff.old_r = self.color_r
		eff.old_g = self.color_g
		eff.old_b = self.color_b
		self.color_r = 0
		self.color_g = 255
		self.color_b = 155
		if not self.add_displays then
			self.add_displays = { Entity.new{image='npc/iceblock.png', display=' ', display_on_seen=true } }
			eff.added_display = true
		end
		eff.ice = mod.class.Object.new{name = "Iceblock", type = "wall", image='npc/iceblock.png', display = ' '} -- use type Object to facilitate the combat log
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)

		eff.hp = eff.hp or 100
		eff.tmpid = self:addTemporaryValue("encased_in_ice", 1)
		eff.healid = self:addTemporaryValue("no_healing", 1)
		eff.moveid = self:addTemporaryValue("never_move", 1)
		eff.frozid = self:addTemporaryValue("frozen", 1)
		eff.defid = self:addTemporaryValue("combat_def", -self:combatDefenseBase()-10)
		eff.rdefid = self:addTemporaryValue("combat_def_ranged", -self:combatDefenseBase()-10)
		eff.sefid = self:addTemporaryValue("negative_status_effect_immune", 1)
		eff.seffid = self:addTemporaryValue("negative_status_effect_immune_frozen", 1)

		self:setTarget(self)
	end,
	on_timeout = function(self, eff)
		self:setTarget(self)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("encased_in_ice", eff.tmpid)
		self:removeTemporaryValue("no_healing", eff.healid)
		self:removeTemporaryValue("never_move", eff.moveid)
		self:removeTemporaryValue("frozen", eff.frozid)
		self:removeTemporaryValue("combat_def", eff.defid)
		self:removeTemporaryValue("combat_def_ranged", eff.rdefid)
		self:removeTemporaryValue("negative_status_effect_immune", eff.sefid)
		if eff.seffid then self:removeTemporaryValue("negative_status_effect_immune_frozen", eff.seffid) end
		self.color_r = eff.old_r
		self.color_g = eff.old_g
		self.color_b = eff.old_b
		if eff.added_display then self.add_displays = nil end
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)
		self:setTarget(nil)
	end,
}

newEffect{
	name = "ETERNAL_WRATH", image = "talents/thaloren_wrath.png",
	desc = "Wrath of the Woods",
	long_desc = function(self, eff) return ("The target calls upon its inner resources, improving all damage by %d%% and reducing all damage taken by %d%%."):format(eff.power, eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# radiates power." end,
	on_lose = function(self, err) return "#Target#'s aura of power vanishes." end,
	activate = function(self, eff)
		eff.pid1 = self:addTemporaryValue("inc_damage", {all=eff.power})
		eff.pid2 = self:addTemporaryValue("resists", {all=eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.pid1)
		self:removeTemporaryValue("resists", eff.pid2)
	end,
}

newEffect{
	name = "HIGHBORN_WRATH", image = "talents/higher_heal.png",
	desc = "Wrath of the Highborn",
	long_desc = function(self, eff) return ("The target calls upon its inner resources, improving all damage by %d%% and reducing all damage taken by %d%%."):format(eff.power, eff.power) end,
	type = "physical",
	subtype = { },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# radiates power." end,
	on_lose = function(self, err) return "#Target#'s aura of power vanishes." end,
	activate = function(self, eff)
		eff.pid1 = self:addTemporaryValue("inc_damage", {all=eff.power})
		eff.pid2 = self:addTemporaryValue("resists", {all=eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.pid1)
		self:removeTemporaryValue("resists", eff.pid2)
	end,
}

newEffect{
	name = "SHELL_SHIELD", image = "talents/shell_shield.png",
	desc = "Shell Shield",
	long_desc = function(self, eff) return ("目标被甲壳覆盖，全体伤害抗性增加%d%%。"):format(eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power=50 },
	on_gain = function(self, err) return "#Target# takes cover under its shell.", "+Shell Shield" end,
	on_lose = function(self, err) return "#Target# leaves the cover of its shell.", "-Shell Shield" end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("resists", {all=eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.pid)
	end,
}

newEffect{
	name = "SERPENTINE_NATURE", image = "talents/hydra.png",
	desc = "Serpentine Nature",
	long_desc = function(self, eff) return ("The target takes on the properties of the hydra, gaining %d%% affinity to lightning, acid, and nature damage and regenerating %d life per turn."):format(eff.power, eff.regen) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power=15, regen=10 },
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("damage_affinity", {NATURE=eff.power, ACID=eff.power, LIGHTNING=eff.power})
		eff.regenid = self:addTemporaryValue("life_regen", eff.regen)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("damage_affinity", eff.pid)
		self:removeTemporaryValue("life_regen", eff.regenid)
	end,
}

newEffect{
	name = "PAIN_SUPPRESSION", image = "talents/infusion__wild.png",
	desc = "Pain Suppression",
	long_desc = function(self, eff) return ("目标忽视疼痛，减少所受伤害 %d%%。"):format(eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power=20 },
	on_gain = function(self, err) return "#Target# lessens the pain.", "+Pain Suppression" end,
	on_lose = function(self, err) return "#Target# feels pain again.", "-Pain Suppression" end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("resists", {all=eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.pid)
	end,
}

newEffect{
	name = "PRIMAL_ATTUNEMENT", image = "talents/infusion__wild.png",
	desc = "Primal Attunement",
	long_desc = function(self, eff) return ("目标和自然协调 , 增加全体伤害吸收 %d%% ，每回合随机减少一个负面状态 %d 回合持续时间 。"):format(eff.power, eff.reduce) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power=20, reduce = 3 },
	on_gain = function(self, err) return "#Target# attunes to the wild.", "+Primal" end,
	on_lose = function(self, err) return "#Target# is no longer one with nature.", "-Primal" end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("damage_affinity", {all=eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("damage_affinity", eff.pid)
	end,
	on_timeout = function(self, eff)
		local effs = self:effectsFilter({status = "detrimental", ignore_crosstier = true}, 1)
		local eff2 = self:hasEffect(effs[1])
		if eff2 then 
			eff2.dur = eff2.dur - eff.reduce
			if eff2.dur <= 0 then self:removeEffect(eff2) end
		end
	end,
}

newEffect{
	name = "PURGE_BLIGHT", image = "talents/infusion__wild.png",
	desc = "Purge Blight",
	long_desc = function(self, eff) return ("目标得到了自然的力量，减少所有枯萎伤害 %d%% ，提升法术豁免 %d ，并使其对疾病免疫。"):format(eff.power, eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power=20 },
	on_gain = function(self, err) return "#Target# rejects blight!", "+Purge" end,
	on_lose = function(self, err) return "#Target# is susceptible to blight again.", "-Purge" end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("resists", {[DamageType.BLIGHT]=eff.power})
		eff.spell_save = self:addTemporaryValue("combat_spellresist", eff.power)
		eff.disease = self:addTemporaryValue("disease_immune", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_spellresist", eff.spell_save)
		self:removeTemporaryValue("disease_immune", eff.disease)
		self:removeTemporaryValue("resists", eff.pid)
	end,
}

newEffect{
	name = "SENSE", image = "talents/track.png",
	desc = "Sensing",
	long_desc = function(self, eff) return "提升感知力，可以发现看不见的目标。" end,
	type = "physical",
	subtype = { sense=true },
	status = "beneficial",
	parameters = { range=10, actor=1, object=0, trap=0 },
	activate = function(self, eff)
		eff.rid = self:addTemporaryValue("detect_range", eff.range)
		eff.aid = self:addTemporaryValue("detect_actor", eff.actor)
		eff.oid = self:addTemporaryValue("detect_object", eff.object)
		eff.tid = self:addTemporaryValue("detect_trap", eff.trap)
		self.detect_function = eff.on_detect
		game.level.map.changed = true
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("detect_range", eff.rid)
		self:removeTemporaryValue("detect_actor", eff.aid)
		self:removeTemporaryValue("detect_object", eff.oid)
		self:removeTemporaryValue("detect_trap", eff.tid)
		self.detect_function = nil
	end,
}

newEffect{
	name = "HEROISM", image = "talents/infusion__heroism.png",
	desc = "Heroism",
	long_desc = function(self, eff)
		local xs = eff.die_at > 0 and ("使你直到生命降至 %+d 时才会死去"):format(-eff.die_at) or ""
		return xs
	end,
	type = "physical",
	subtype = { nature=true },
	no_player_remove = true,
	status = "beneficial",
	parameters = { die_at = 0 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "die_at", -eff.die_at)
	end,
}

newEffect{
	name = "SUNDER_ARMOUR", image = "talents/sunder_armour.png",
	desc = "Sunder Armour",
	long_desc = function(self, eff) return ("目标护甲破损，护甲值和豁免降低 %d。"):format(eff.power) end,
	type = "physical",
	subtype = { sunder=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target#'s armour is damaged!", "+Sunder Armor" end,
	on_lose = function(self, err) return "#Target#'s armour is more intact.", "-Sunder Armor" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_armor", -eff.power)
		self:effectTemporaryValue(eff, "combat_physresist", -eff.power)
		self:effectTemporaryValue(eff, "combat_spellresist", -eff.power)
		self:effectTemporaryValue(eff, "combat_mentalresist", -eff.power)
	end,
}

newEffect{
	name = "SUNDER_ARMS", image = "talents/sunder_arms.png",
	desc = "Sunder Arms",
	long_desc = function(self, eff) return ("目标战斗能力下降，降低 %d 点命中。"):format(eff.power) end,
	type = "physical",
	subtype = { sunder=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target#'s fighting ability is impaired!", "+Sunder Arms" end,
	on_lose = function(self, err) return "#Target#'s ability to fight has recovered.", "-Sunder Arms" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("combat_atk", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_atk", eff.tmpid)
	end,
}

newEffect{
	name = "PINNED", image = "effects/pinned.png",
	desc = "Pinned to the ground",
	long_desc = function(self, eff) return "目标被钉在地上，无法移动。" end,
	type = "physical",
	subtype = { pin=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is pinned to the ground.", "+Pinned" end,
	on_lose = function(self, err) return "#Target# is no longer pinned.", "-Pinned" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("never_move", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("never_move", eff.tmpid)
	end,
}

newEffect{
	name = "BONE_GRAB", image = "talents/bone_grab.png",
	desc = "Pinned to the ground",
	long_desc = function(self, eff) return "目标被定身，不能移动。" end,
	type = "physical",
	subtype = { pin=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is pinned to the ground.", "+Bone Grab" end,
	on_lose = function(self, err) return "#Target# is no longer pinned.", "-Bone Grab" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("never_move", 1)

		if not self.add_displays then
			self.add_displays = { Entity.new{image='npc/bone_grab_pin.png', display=' ', display_on_seen=true } }
			eff.added_display = true
		end
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)
	end,
	deactivate = function(self, eff)
		if eff.added_display then self.add_displays = nil end
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)

		self:removeTemporaryValue("never_move", eff.tmpid)
	end,
}

newEffect{
	name = "MIGHTY_BLOWS", image = "effects/mighty_blows.png",
	desc = "Mighty Blows",
	long_desc = function(self, eff) return ("目标战斗伤害值提高 %d。"):format(eff.power) end,
	type = "physical",
	subtype = { golem=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# looks menacing." end,
	on_lose = function(self, err) return "#Target# looks less menacing." end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("combat_dam", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_dam", eff.tmpid)
	end,
}

newEffect{
	name = "CRIPPLE", image = "talents/cripple.png",
	desc = "Cripple",
	long_desc = function(self, eff) return ("目标被致残，降低 %d%% 近战、施法和精神速度。"):format(eff.speed*100) end,
	type = "physical",
	subtype = { wound=true, cripple=true },
	status = "detrimental",
	parameters = { speed=0.3 },
	on_gain = function(self, err) return "#Target# is crippled." end,
	on_lose = function(self, err) return "#Target# is not crippled anymore." end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_physspeed", -eff.speed)
		self:effectTemporaryValue(eff, "combat_spellspeed", -eff.speed)
		self:effectTemporaryValue(eff, "combat_mindspeed", -eff.speed)
	end,
}

newEffect{
	name = "BURROW", image = "talents/burrow.png",
	desc = "Burrow",
	long_desc = function(self, eff) return ("目标可以挖入墙中，获得%d护甲穿透，%d%%物理抗性穿透。"):format(eff.power, eff.power / 2) end,
	type = "physical",
	subtype = { earth=true },
	status = "beneficial",
	parameters = { },
	activate = function(self, eff)
		eff.pass = self:addTemporaryValue("can_pass", {pass_wall=1})
		eff.dig = self:addTemporaryValue("move_project", {[DamageType.DIG]=1})
		self:effectTemporaryValue(eff, "combat_apr", eff.power)
		self:effectTemporaryValue(eff, "resists_pen", {[DamageType.PHYSICAL]=eff.power / 2 })
		self:effectTemporaryValue(eff, "ai_spread_add", 5)  -- Reduce accuracy of AI position guesses so we don't track straight to players that moved out of LOS
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("can_pass", eff.pass)
		self:removeTemporaryValue("move_project", eff.dig)
	end,
}

newEffect{
	name = "DIM_VISION", image = "talents/sticky_smoke.png",
	desc = "Reduced Vision",
	long_desc = function(self, eff) return ("目标的视觉范围减少 %d。"):format(eff.sight) end,
	type = "physical",
	subtype = { sense=true },
	status = "detrimental",
	parameters = { sight=5 },
	on_gain = function(self, err) return "#Target# is surrounded by a thick smoke.", "+Dim Vision" end,
	on_lose = function(self, err) return "The smoke around #target# dissipates.", "-Dim Vision" end,
	charges = function(self, eff) return -eff.sight end,
	activate = function(self, eff)
		if self.sight - eff.sight < 1 then eff.sight = self.sight - 1 end
		eff.tmpid = self:addTemporaryValue("sight", -eff.sight)
--		self:setTarget(nil) -- Loose target!
		self:doFOV()
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("sight", eff.tmpid)
		self:doFOV()
	end,
}

newEffect{
	name = "RESOLVE", image = "talents/resolve.png",
	desc = "Resolve",
	long_desc = function(self, eff)
		local list = table.keys(eff.types)
		for i = 1, #list do if DamageType.dam_def[list[i]] then
			list[i] = DamageType.dam_def[list[i]].name
		end end
		local type_str
		if #list >= 1 then type_str = table.concatNice(list, ", ", " and ") else type_str = "" end
		return ("你获得 %d%% %s 抵抗。"):format(eff.res, type_str) 
	end,
	charges = function(self, eff) return table.count(eff.types) end,
	type = "physical",
	subtype = { antimagic=true, nature=true },
	status = "beneficial",
	parameters = { res=10, damtype=DamageType.ARCANE,  max_types = 1},
	on_gain = function(self, err) return "#Target# attunes to the damage.", "+Resolve" end,
	on_lose = function(self, err) return "#Target# is no longer attuned.", "-Resolve" end,
	activate = function(self, eff)
		eff.types = {}
		self:effectTemporaryValue(eff, "resists", {[eff.damtype] = eff.res})
		eff.types[eff.damtype] = true
	end,
	on_merge = function(self, old_eff, new_eff)
		if old_eff.types[new_eff.damtype] then return old_eff end
		if table.count(old_eff.types) >= new_eff.max_types then
			return old_eff
		end

		self:effectTemporaryValue(old_eff, "resists", {[new_eff.damtype] = new_eff.res})
		old_eff.types[new_eff.damtype] = true
		old_eff.dur = new_eff.dur
		return old_eff
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "WILD_SPEED", image = "talents/infusion__movement.png",
	desc = "Wild Speed",
	long_desc = function(self, eff) return ("以极快的速度移动 (加速 %d%%) 并获得 100%% 震慑、眩晕和定身免疫。任何非移动动作都会取消这一效果。")
		:format(eff.power) end,
	type = "physical",
	subtype = { nature=true, speed=true },
	status = "beneficial",
	parameters = {power=100, no_talents=1},
	on_gain = function(self, err) return "#Target# is moving at extreme speed!", "+Wild Speed" end,
	on_lose = function(self, err) return "#Target# slows down.", "-Wild Speed" end,
	get_fractional_percent = function(self, eff)
		local d = game.turn - eff.start_turn
		return util.bound(360 - d / eff.possible_end_turns * 360, 0, 360)
	end,
	lists = 'break_with_step_up',
	activate = function(self, eff)
		eff.start_turn = game.turn
		eff.possible_end_turns = 10 * (eff.dur+1)
		eff.tmpid = self:addTemporaryValue("wild_speed", 1)
		eff.moveid = self:addTemporaryValue("movement_speed", eff.power/100)

		self:effectTemporaryValue(eff, "ai_spread_add", 5)  -- Reduce accuracy of AI position guesses so we don't track straight to players that moved out of LOS
		
		-- should change priorities rather than forbid all talents
		if self.ai_state and eff.no_talents ~= 0 then eff.aiid = self:addTemporaryValue("ai_state", {no_talents=eff.no_talents}) end -- Makes the AI not use talents while active
		eff.stun = self:addTemporaryValue("stun_immune", 1)
		eff.daze = self:addTemporaryValue("daze_immune", 1)
		eff.pin = self:addTemporaryValue("pin_immune", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("wild_speed", eff.tmpid)
		if eff.aiid then self:removeTemporaryValue("ai_state", eff.aiid) end
		self:removeTemporaryValue("movement_speed", eff.moveid)
		self:removeTemporaryValue("stun_immune", eff.stun)
		self:removeTemporaryValue("daze_immune", eff.daze)
		self:removeTemporaryValue("pin_immune", eff.pin)
	end,
}

newEffect{
	name = "HUNTER_SPEED", image = "talents/infusion__movement.png",
	desc = "Hunter",
	long_desc = function(self, eff) return ("你正在寻找下一个目标，  移动速度增加 %d%%。"):format(eff.power) end,
	type = "physical",
	subtype = { nature=true, speed=true },
	status = "beneficial",
	parameters = {power=1000},
	on_gain = function(self, err) return ("#Target# prepares %s!"):format(not self.player and self.ai_state.tactic == "escape" and "to escape" or "for the next kill"), "+Hunter" end,
	on_lose = function(self, err) return "#Target# slows down.", "-Hunter" end,
	
	on_timeout = function(self, eff)--make sure that NPC's that catch their target (or can't get away) can fight
		if eff.aiid then
			local turns = (game.turn - eff.start_turn)*game.energy_per_tick/game.energy_to_act
			if turns >= 1 then
				local target = self.ai_target and self.ai_target.actor
				if (target and core.fov.distance(self.x, self.y, target.x, target.y) <= 1) or not rng.chance(turns) then
					self:removeTemporaryValue("ai_state", eff.aiid); eff.aiid = nil
					print("---HUNTER_SPEED", self.name, "ai free to act after", turns, "turns")
				end
			end
		end
	end,
	get_fractional_percent = function(self, eff)
		local d = game.turn - eff.start_turn
		return util.bound(360 - d / eff.possible_end_turns * 360, 0, 360)
	end,
	lists = 'break_with_step_up',
	activate = function(self, eff)
		eff.start_turn = game.turn
		eff.possible_end_turns = (eff.dur+1)*game.energy_to_act/game.energy_per_tick
		eff.tmpid = self:addTemporaryValue("wild_speed", 1)
		eff.moveid = self:addTemporaryValue("movement_speed", eff.power/100)
-- should change priorities rather than forbid all talents
		if self.ai_state then eff.aiid = self:addTemporaryValue("ai_state", {no_talents=1}) end -- Make AI not use talents while using it
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("wild_speed", eff.tmpid)
		if eff.aiid then self:removeTemporaryValue("ai_state", eff.aiid) end
		self:removeTemporaryValue("movement_speed", eff.moveid)
	end,
}

newEffect{
	name = "STEP_UP", image = "talents/step_up.png",
	desc = "Step Up",
	long_desc = function(self, eff) return ("移动速度提高 %d%%。"):format(eff.power) end,
	type = "physical",
	subtype = { speed=true, tactic=true },
	status = "beneficial",
	parameters = {power=1000},
	on_gain = function(self, err) return "#Target# prepares for the next kill!.", "+Step Up" end,
	on_lose = function(self, err) return "#Target# slows down.", "-Step Up" end,
	get_fractional_percent = function(self, eff)
		local d = game.turn - eff.start_turn
		return util.bound(360 - d / eff.possible_end_turns * 360, 0, 360)
	end,
	lists = 'break_with_step_up',
	activate = function(self, eff)
		eff.start_turn = game.turn
		eff.possible_end_turns = 10 * (eff.dur+1)
		eff.tmpid = self:addTemporaryValue("step_up", 1)
		eff.moveid = self:addTemporaryValue("movement_speed", eff.power/100)
-- should change priorities rather than forbid all talents
		if self.ai_state then eff.aiid = self:addTemporaryValue("ai_state", {no_talents=1}) end -- Make AI not use talents while using it
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("step_up", eff.tmpid)
		if eff.aiid then self:removeTemporaryValue("ai_state", eff.aiid) end
		self:removeTemporaryValue("movement_speed", eff.moveid)
	end,
}

newEffect{
	name = "LIGHTNING_SPEED", image = "talents/lightning_speed.png",
	desc = "Lightning Speed",
	long_desc = function(self, eff) return ("成为一道闪电，提高 %d%% 移动速度。并提高 100％闪电抵抗和 30％物理抵抗。"):format(eff.power) end,
	type = "physical",
	subtype = { lightning=true, speed=true },
	status = "beneficial",
	parameters = {},
	on_gain = function(self, err) return "#Target# turns into pure lightning!.", "+Lightning Speed" end,
	on_lose = function(self, err) return "#Target# is back to normal.", "-Lightning Speed" end,
	get_fractional_percent = function(self, eff)
		local d = game.turn - eff.start_turn
		return util.bound(360 - d / eff.possible_end_turns * 360, 0, 360)
	end,
	activate = function(self, eff)
		eff.start_turn = game.turn
		eff.possible_end_turns = 10 * (eff.dur+1)
		eff.tmpid = self:addTemporaryValue("lightning_speed", 1)
		eff.moveid = self:addTemporaryValue("movement_speed", eff.power/100)
		eff.resistsid = self:addTemporaryValue("resists", {
			[DamageType.PHYSICAL]=30,
			[DamageType.LIGHTNING]=100,
		})
		eff.capresistsid = self:addTemporaryValue("resists_cap", {
			[DamageType.LIGHTNING]=100,
		})
-- should change priorities rather than forbid all talents
		if self.ai_state then eff.aiid = self:addTemporaryValue("ai_state", {no_talents=1}) end -- Make AI not use talents while using it
		eff.particle = self:addParticles(Particles.new("bolt_lightning", 1))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("lightning_speed", eff.tmpid)
		self:removeTemporaryValue("resists", eff.resistsid)
		self:removeTemporaryValue("resists_cap", eff.capresistsid)
		if eff.aiid then self:removeTemporaryValue("ai_state", eff.aiid) end
		self:removeTemporaryValue("movement_speed", eff.moveid)
	end,
}

newEffect{
	name = "DRAGONS_FIRE", image = "talents/fire_breath.png",
	desc = "Dragon's Fire",
	long_desc = function(self, eff) return ("你流淌着龙的血液，你能吐出火焰或者提升火焰吐息的威力。"):format() end,
	type = "physical",
	subtype = { fire=true },
	status = "beneficial",
	parameters = {power=1},
	on_gain = function(self, err) return "#Target#'s throat seems to be burning.", "+Dragon's fire" end,
	on_lose = function(self, err) return "#Target#'s throat seems to cool down.", "-Dragon's fire" end,
	activate = function(self, eff)
		local t_id = self.T_FIRE_BREATH
		if not self.talents[t_id] then
			-- Auto assign to hotkey
			if self.hotkey then
				for i = 1, 36 do
					if not self.hotkey[i] then
						self.hotkey[i] = {"talent", t_id}
						break
					end
				end
			end
		end

		eff.tmpid = self:addTemporaryValue("talents", {[t_id] = eff.power})
	end,
	deactivate = function(self, eff)
		local t_id = self.T_FIRE_BREATH
		self:removeTemporaryValue("talents", eff.tmpid)
		if self.talents[t_id] == 0 then
			self.talents[t_id] = nil
			if self.hotkey then
				for i, known_t_id in pairs(self.hotkey) do
					if known_t_id[1] == "talent" and known_t_id[2] == t_id then self.hotkey[i] = nil end
				end
			end
		end
	end,
}

newEffect{
	name = "GREATER_WEAPON_FOCUS", image = "talents/greater_weapon_focus.png",
	desc = "Greater Weapon Focus",
	long_desc = function(self, eff) return ("%d%% 几率造成额外一击（每回合每武器至多触发一次）。"):format(eff.chance) end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = { chance=25 },
	callbackOnMeleeAttack = function(self, eff, target, hitted, crit, weapon, damtype, mult, dam, hd)
	-- trigger up to once per turn for each weapon
	-- checks self.turn_procs._no_melee_recursion to limit possible compounded recursion or other needed special cases
		if hitted and weapon and not (self.turn_procs._gwf_active or self.turn_procs._no_melee_recursion or target.dead) then
			local gwf = self.turn_procs._gwf or {}
			self.turn_procs._gwf = gwf
			if not gwf[weapon] and rng.percent(eff.chance) then
				gwf[weapon] = true
				print("[ATTACK]", eff.effect_id, "callbackOnMeleeAttack triggered with weapon", weapon)
				self.turn_procs._gwf_active = true -- safety net to prevent recursive recursion
				self:attackTargetWith(target, weapon, damtype, mult)
				self.turn_procs._gwf_active = nil
			end
		end
	end,
	activate = function(self, eff)
		eff.src = self
	end,
	deactivate = function(self, eff)
		--self:removeTemporaryValue("additional_melee_chance", eff.extra_blow_chance) -- backwards compatibility
	end,
}

-- Grappling stuff
newEffect{
	name = "GRAPPLING", image = "talents/clinch.png",
	desc = "Grappling",
	long_desc = function(self, eff) return ("目标进入抓取状态，每回合吸取 %d 体力，同时将 %d%% 伤害转移到 %s ,任何移动或者其他一些徒手技能会取消这个状态。"):format(eff.drain, eff.sharePct*100, eff.trgt.name or "unknown") end,
	type = "physical",
	subtype = { grapple=true, },
	status = "beneficial",
	parameters = {trgt, sharePct = 0.1, drain = 0},
	on_gain = function(self, err) return "#Target# is engaged in a grapple!", "+Grappling" end,
	on_lose = function(self, err) return "#Target# has released the hold.", "-Grappling" end,
	on_timeout = function(self, eff)
		local p = eff.trgt:hasEffect(eff.trgt.EFF_GRAPPLED)
		if not p or p.src ~= self or core.fov.distance(self.x, self.y, eff.trgt.x, eff.trgt.y) > 1 or eff.trgt.dead or not game.level:hasEntity(eff.trgt) then
			self:removeEffect(self.EFF_GRAPPLING)
		else
			self:incStamina(-eff.drain)
		end
	end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
	callbackOnHit = function(self, eff, cb, src)
		if not src then return cb.value end
		local share = cb.value * eff.sharePct

		-- deal the redirected damage as physical because I don't know how to preserve the damage type in a callback
		if not self.__grapling_feedback_damage then
			self.__grapling_feedback_damage = true
			DamageType:get(DamageType.PHYSICAL).projector(self or eff.src, eff.trgt.x, eff.trgt.y, DamageType.PHYSICAL, share)
			self.__grapling_feedback_damage = nil
		end

		return cb.value - share
	end,
}

newEffect{
	name = "GRAPPLED", image = "talents/grab.png",
	desc = "Grappled",
	long_desc = function(self, eff) return ("目标被抓取，不能移动，并限制他的攻击能力。\n#RED#%s定身\n%s\n%s\n%s#LAST#"):format(eff.silence > 0 and "沉默\n" or "", "物理强度降低 " .. math.ceil(eff.reduce), "减速 " .. math.floor(eff.slow * 100).."%", "每回合受到 " .. math.ceil(eff.power) .. " 伤害 " ) end,
	type = "physical",
	subtype = { grapple=true, pin=true },
	status = "detrimental",
	parameters = {silence = 0, slow = 0, reduce = 1, power = 1},
	remove_on_clone = true,
	on_gain = function(self, err) return "#Target# is grappled!", "+Grappled" end,
	on_lose = function(self, err) return "#Target# is free from the grapple.", "-Grappled" end,
	activate = function(self, eff)
		if self:attr("never_move") then self:effectTemporaryValue(eff, "never_move_before_grapple", 1) end  -- Flag for Hurricane Throw
		self:effectTemporaryValue(eff, "never_move", 1)
		self:effectTemporaryValue(eff, "combat_dam", -eff.reduce)
		if (eff.silence > 0) then
			self:effectTemporaryValue(eff, "silence", 1)
		end
		if (eff.slow > 0) then
			self:effectTemporaryValue(eff, "global_speed_add", -eff.slow)
		end
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={toback=false, size_factor=1.5, img="grappled_debuff_tentacles"}, shader={type="tentacles", backgroundLayersCount=-4, appearTime=0.3, time_factor=1000, noup=0.0}})
		end
	end,
	on_timeout = function(self, eff)
		if not self.x or not eff.src or not eff.src.x or core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) > 1 or eff.src.dead or not game.level:hasEntity(eff.src) then
			self:removeEffect(self.EFF_GRAPPLED)
		else
			DamageType:get(DamageType.PHYSICAL).projector(eff.src or self, self.x, self.y, DamageType.PHYSICAL, eff.power)
		end
	end,
	deactivate = function(self, eff)

	end, 
}

newEffect{
	name = "CRUSHING_HOLD", image = "talents/crushing_hold.png",
	desc = "Crushing Hold",
	long_desc = function(self, eff) return ("目标被折颈，每回合受到 %d 伤害。"):format(eff.power) end,
	type = "physical",
	subtype = { grapple=true, pin=true },
	status = "detrimental",
	parameters = { power=1 },
	on_gain = function(self, err) return "#Target# is being crushed.", "+Crushing Hold" end,
	on_lose = function(self, err) return "#Target# has escaped the crushing hold.", "-Crushing Hold" end,
	on_timeout = function(self, eff)
		if core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) > 1 or eff.src.dead or not game.level:hasEntity(eff.src) then
			self:removeEffect(self.EFF_CRUSHING_HOLD)
		elseif eff.damtype then
			local type = eff.damtype
			DamageType:get(DamageType[type]).projector(eff.src or self, self.x, self.y, DamageType[type], eff.power)
		else
			DamageType:get(DamageType.PHYSICAL).projector(eff.src or self, self.x, self.y, DamageType.PHYSICAL, eff.power)
		end
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "never_move", 1)
	end,
}

newEffect{
	name = "STRANGLE_HOLD", image = "talents/clinch.png",
	desc = "Strangle Hold",
	long_desc = function(self, eff) return ("目标被扼住喉咙，不能施法且每回合受到 %d 伤害。"):format(eff.power) end,
	type = "physical",
	subtype = { grapple=true, pin=true, silence=true },
	status = "detrimental",
	parameters = { power=1 },
	on_gain = function(self, err) return "#Target# is being strangled.", "+Strangle Hold" end,
	on_lose = function(self, err) return "#Target# has escaped the strangle hold.", "-Strangle Hold" end,
	on_timeout = function(self, eff)
		if core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) > 1 or eff.src.dead or not game.level:hasEntity(eff.src) then
			self:removeEffect(self.EFF_STRANGLE_HOLD)
		elseif eff.damtype then
			local type = eff.damtype
			DamageType:get(DamageType[type]).projector(eff.src or self, self.x, self.y, DamageType[type], eff.power)
		else
			DamageType:get(DamageType.PHYSICAL).projector(eff.src or self, self.x, self.y, DamageType.PHYSICAL, eff.power)
		end
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "silence", 1)
		self:effectTemporaryValue(eff, "never_move", 1)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "MAIMED", image = "talents/maim.png",
	desc = "Maimed",
	long_desc = function(self, eff) return ("目标被致残，伤害减少 %d 并且整体速度下降 30％。"):format(eff.power) end,
	type = "physical",
	subtype = { wound=true, slow=true },
	status = "detrimental",
	parameters = { atk=10, dam=10 },
	on_gain = function(self, err) return "#Target# is maimed.", "+Maimed" end,
	on_lose = function(self, err) return "#Target# has recovered from the maiming.", "-Maimed" end,
	activate = function(self, eff)
		eff.damid = self:addTemporaryValue("combat_dam", -eff.dam)
		eff.tmpid = self:addTemporaryValue("global_speed_add", -0.3)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_dam", eff.damid)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
	end,
}

newEffect{
	name = "EXPOSE_WEAKNESS", image = "talents/expose_weakness.png",
	desc = "Expose Weakness",
	long_desc = function(self, eff) return ("The target is focused on penetrating defenses, increasing armor penetration by %d, accuracy by %d, and all damage penetration by %d%%."):format(eff.apr, eff.accuracy, eff.penetration) end,
	type = "physical",
	subtype = { },
	status = "beneficial",
	parameters = { accuracy=0, apr=0, penetration=0 },
	on_gain = function(self, err) return "#Target# is focusing on penetrating defenses.", "+Expose Weakness" end,
	on_lose = function(self, err) return "#Target# is no longer focused on penetrating defenses.", "-Expose Weakness" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_apr", eff.apr)
		self:effectTemporaryValue(eff, "combat_atk", eff.accuracy)
		self:effectTemporaryValue(eff, "resists_pen", {all=eff.penetration})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "COMBO", image = "talents/combo_string.png",
	desc = "Combo",
	display_desc = function(self, eff) return eff.cur_power.." Combo" end,
	long_desc = function(self, eff) return ("目标正在连击中，并获得了 %d 连击点数。"):format(eff.cur_power) end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = { power=1, max=5 },
	charges = function(self, eff) return eff.cur_power end,
	on_merge = function(self, old_eff, new_eff)
		self:removeTemporaryValue("combo", old_eff.tmpid)
		old_eff.cur_power = math.min(old_eff.cur_power + new_eff.power, new_eff.max)
		old_eff.tmpid = self:addTemporaryValue("combo", {power = old_eff.cur_power})

		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		eff.cur_power = eff.power
		eff.tmpid = self:addTemporaryValue("combo", {eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combo", eff.tmpid)
	end,
}

newEffect{
	name = "DEFENSIVE_MANEUVER", image = "talents/set_up.png",
	desc = "Defensive Maneuver",
	long_desc = function(self, eff) return ("目标闪避值增加 %d。"):format(eff.power) end,
	type = "physical",
	subtype = { evade=true },
	status = "beneficial",
	parameters = {power = 1},
	on_gain = function(self, err) return "#Target# is moving defensively!", "+Defensive Maneuver" end,
	on_lose = function(self, err) return "#Target# isn't moving as defensively anymore.", "-Defensive Maneuver" end,
	activate = function(self, eff)
		eff.defense = self:addTemporaryValue("combat_def", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_def", eff.defense)
	end,
}

newEffect{
	name = "SET_UP", image = "talents/set_up.png",
	desc = "Set Up",
	long_desc = function(self, eff) return ("目标失去平衡，提高 %d%% 受到暴击的概率，另外所有抵抗值下降 %d。"):format(eff.power, eff.power) end,
	type = "physical",
	subtype = { tactic=true },
	status = "detrimental",
	parameters = {power = 1},
	on_gain = function(self, err) return "#Target# has been set up!", "+Set Up" end,
	on_lose = function(self, err) return "#Target# has survived the set up.", "-Set Up" end,
	activate = function(self, eff)
		eff.mental = self:addTemporaryValue("combat_mentalresist", -eff.power)
		eff.spell = self:addTemporaryValue("combat_spellresist", -eff.power)
		eff.physical = self:addTemporaryValue("combat_physresist", -eff.power)
		self:effectParticles(eff, {type="circle", args={oversize=1, a=220, base_rot=180, shader=true, appear=12, img="set_up_debuff_aura", speed=0, radius=0}})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_mentalresist", eff.mental)
		self:removeTemporaryValue("combat_spellresist", eff.spell)
		self:removeTemporaryValue("combat_physresist", eff.physical)
	end,
}

newEffect{
	name = "Recovery",
	desc = "Recovery",
	long_desc = function(self, eff) return ("目标增加 %d 生命回复。"):format(eff.regen) end,
	type = "physical",
	subtype = { heal=true, regeneration=true },
	status = "beneficial",
	parameters = { regen=10 },
	on_gain = function(self, err) return "#Target# is recovering from the damage!", "+Recovery" end,
	on_lose = function(self, err) return "#Target# has finished recovering.", "-Recovery" end,
	activate = function(self, eff)
		eff.regenid = self:addTemporaryValue("life_regen", eff.regen)
		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1.5, y=-0.3, img="healarcane"}, {type="healing", time_factor=4000, noup=2.0, beamColor1={0xff/255, 0x22/255, 0x22/255, 1}, beamColor2={0xff/255, 0x60/255, 0x60/255, 1}, circleColor={0,0,0,0}, beamsCount=8}))
			eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1.5, y=-0.3, img="healarcane"}, {type="healing", time_factor=4000, noup=1.0, beamColor1={0xff/255, 0x22/255, 0x22/255, 1}, beamColor2={0xff/255, 0x60/255, 0x60/255, 1}, circleColor={0,0,0,0}, beamsCount=8}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
		self:removeTemporaryValue("life_regen", eff.regenid)
	end,
}

newEffect{
	name = "REFLEXIVE_DODGING", image = "talents/heightened_reflexes.png",
	desc = "Reflexive Dodging",
	long_desc = function(self, eff) return ("提高 %d%% 整体速度。"):format(eff.power * 100) end,
	type = "physical",
	subtype = { evade=true, speed=true },
	status = "beneficial",
	parameters = { power=0.1 },
	on_gain = function(self, err) return "#Target# speeds up.", "+Reflexive Dodging" end,
	on_lose = function(self, err) return "#Target# slows down.", "-Reflexive Dodging" end,
	lists = 'break_with_step_up',
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
	end,
}

newEffect{
	name = "WEAKENED_DEFENSES", image = "talents/exploit_weakness.png",
	desc = "Weakened Defenses",
	long_desc = function(self, eff) return ("目标物理抵抗下降 %d%%。"):format(eff.inc) end,
	type = "physical",
	subtype = { sunder=true },
	status = "detrimental",
	parameters = { inc=1, max=5 },
	on_merge = function(self, old_eff, new_eff)
		self:removeTemporaryValue("resists", old_eff.tmpid)
		old_eff.cur_inc = math.max(old_eff.cur_inc + new_eff.inc, new_eff.max)
		old_eff.tmpid = self:addTemporaryValue("resists", {[DamageType.PHYSICAL] = old_eff.cur_inc})

		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		eff.cur_inc = eff.inc
		eff.tmpid = self:addTemporaryValue("resists", {
			[DamageType.PHYSICAL] = eff.inc,
		})
		self:effectParticles(eff, {type="circle", args={oversize=1, a=220, base_rot=180, shader=true, appear=12, img="exploit_weakness_debuff_aura", speed=0, radius=0}})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.tmpid)
	end,
}

newEffect{
	name = "WATERS_OF_LIFE", image = "talents/waters_of_life.png",
	desc = "Waters of Life",
	long_desc = function(self, eff) return ("目标净化所有毒素和疾病效果，并将它们转化为治疗。") end,
	type = "physical",
	subtype = { nature=true, heal=true },
	status = "beneficial",
	parameters = { },
	activate = function(self, eff)
		eff.poisid = self:addTemporaryValue("purify_poison", 1)
		eff.diseid = self:addTemporaryValue("purify_disease", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("purify_poison", eff.poisid)
		self:removeTemporaryValue("purify_disease", eff.diseid)
	end,
}

newEffect{
	name = "ELEMENTAL_HARMONY", image = "effects/elemental_harmony.png",
	desc = "Elemental Harmony",
	long_desc = function(self, eff)
		if eff.type == DamageType.FIRE then return ("增加整体速度 %d%% 。"):format(100 * self:callTalent(self.T_ELEMENTAL_HARMONY, "fireSpeed"))
		elseif eff.type == DamageType.COLD then return ("增加护甲值 %d 。"):format(self:callTalent(self.T_ELEMENTAL_HARMONY, "coldArmor"))
		elseif eff.type == DamageType.LIGHTNING then return ("增加所有属性 %d 。"):format(self:callTalent(self.T_ELEMENTAL_HARMONY, "lightningStats"))
		elseif eff.type == DamageType.ACID then return ("增加生命回复 %0.2f 。"):format(self:callTalent(self.T_ELEMENTAL_HARMONY, "acidRegen"))
		elseif eff.type == DamageType.NATURE then return ("增加所有抵抗 %d%% 。"):format(self:callTalent(self.T_ELEMENTAL_HARMONY, "natureRes"))
		end
	end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { },
	no_player_remove = true,
	activate = function(self, eff)
		if eff.type == DamageType.FIRE then
			eff.tmpid = self:addTemporaryValue("global_speed_add", self:callTalent(self.T_ELEMENTAL_HARMONY, "fireSpeed"))
		elseif eff.type == DamageType.COLD then
			eff.tmpid = self:addTemporaryValue("combat_armor", self:callTalent(self.T_ELEMENTAL_HARMONY, "coldArmor"))
		elseif eff.type == DamageType.LIGHTNING then
			local stats = self:callTalent(self.T_ELEMENTAL_HARMONY, "lightningStats")
			eff.tmpid = self:addTemporaryValue("inc_stats",
			{
				[Stats.STAT_STR] = stats,
				[Stats.STAT_DEX] = stats,
				[Stats.STAT_MAG] = stats,
				[Stats.STAT_WIL] = stats,
				[Stats.STAT_CUN] = stats,
				[Stats.STAT_CON] = stats,
			})
		elseif eff.type == DamageType.ACID then
			eff.tmpid = self:addTemporaryValue("life_regen", self:callTalent(self.T_ELEMENTAL_HARMONY, "coldArmor"))
		elseif eff.type == DamageType.NATURE then
			eff.tmpid = self:addTemporaryValue("resists", {all=self:callTalent(self.T_ELEMENTAL_HARMONY, "natureRes")})
		end
	end,
	deactivate = function(self, eff)
		if eff.type == DamageType.FIRE then
			self:removeTemporaryValue("global_speed_add", eff.tmpid)
		elseif eff.type == DamageType.COLD then
			self:removeTemporaryValue("combat_armor", eff.tmpid)
		elseif eff.type == DamageType.LIGHTNING then
			self:removeTemporaryValue("inc_stats", eff.tmpid)
		elseif eff.type == DamageType.ACID then
			self:removeTemporaryValue("life_regen", eff.tmpid)
		elseif eff.type == DamageType.NATURE then
			self:removeTemporaryValue("resists", eff.tmpid)
		end
	end,
}

newEffect{
	name = "HEALING_NEXUS", image = "talents/healing_nexus.png",
	desc = "Healing Nexus Redirection",
	long_desc = function(self, eff)
		return ("目标受到的直接治疗将被转移至 %s ( %d%% 效率)."):format(eff.src.name, eff.pct * 100, eff.src.name)
	end,
	type = "physical",
	subtype = { nature=true, heal=true },
	status = "detrimental",
	parameters = { pct = 1 },
	callbackPriorities={callbackOnHeal = -5},
	callbackOnHeal = function(self, eff, value, src, raw_value)
		if raw_value > 0 and eff.src and not eff.src.__healing_nexus_running then
			game:delayedLogMessage(eff.src, self, "healing_nexus"..(eff.src.uid or ""), "#YELLOW_GREEN##Source# steals healing from #Target#!")
			eff.src.__healing_nexus_running = true
			eff.src:heal(raw_value*eff.pct, src) -- use raw healing value to avoid compounding healing_factor
			eff.src.__healing_nexus_running = nil
			return {value = 0}
		end
	end,
	activate = function(self, eff)
		if self == eff.src then
			self:setEffect(self.EFF_HEALING_NEXUS_BUFF, eff.dur, {pct=eff.pct})
			self:removeEffect(eff.effect_id)
		end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "HEALING_NEXUS_BUFF", image = "talents/healing_nexus.png",
	desc = "Healing Nexus",
	long_desc = function(self, eff)
		return ("All direct healing done to the target is increased by %d%% and each heal restores %0.1f equilibrium."):format(eff.pct * 100, eff.eq)
	end,
	type = "physical",
	subtype = { nature=true, heal=true },
	status = "beneficial",
	parameters = { pct = 1, eq = 0 },
	callbackOnHeal = function(self, eff, value, src, raw_value)
		if value > 0 then
			game:delayedLogMessage(self, self, "healing_nexus_buff", "#YELLOW_GREEN##Source#'s healing is amplified!")
			self:incEquilibrium(-eff.eq)
			return {value=value*(1 + eff.pct)}
		end
	end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "PSIONIC_BIND", image = "effects/psionic_bind.png",
	desc = "Immobilized",
	long_desc = function(self, eff) return "Immobilized by telekinetic forces." end,
	type = "physical",
	subtype = { telekinesis=true, pin=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#F53CBE##Target# is bound by telekinetic forces!", "+Paralyzed" end,
	on_lose = function(self, err) return "#Target# shakes free of the telekinetic binding", "-Paralyzed" end,
	activate = function(self, eff)
		--eff.particle = self:addParticles(Particles.new("gloom_stunned", 1))
		eff.tmpid = self:addTemporaryValue("never_move", 1)
	end,
	deactivate = function(self, eff)
		--self:removeParticles(eff.particle)
		self:removeTemporaryValue("never_move", eff.tmpid)
	end,
}

newEffect{
	name = "IMPLODING", image = "talents/implode.png",
	desc = "Imploding (slow)",
	long_desc = function(self, eff) return (" 整体速度下降 50％ , 每回合受到 %d 碾压伤害。"):format( eff.power) end,
	type = "physical",
	subtype = { telekinesis=true, slow=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is being crushed.", "+Imploding" end,
	on_lose = function(self, err) return "#Target# shakes off the crushing forces.", "-Imploding" end,
	activate = function(self, eff)
		if core.shader.allow("distort") then eff.particle = self:addParticles(Particles.new("gravity_well2", 1, {radius=1})) end
		eff.tmpid = self:addTemporaryValue("global_speed_add", -0.5)
	end,
	deactivate = function(self, eff)
		if eff.particle then self:removeParticles(eff.particle) end
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.PHYSICAL).projector(eff.src, self.x, self.y, DamageType.PHYSICAL, eff.power)
	end,
}

newEffect{
	name = "FREE_ACTION", image = "effects/free_action.png",
	desc = "Free Action",
	long_desc = function(self, eff) return ("目标获得 %d%% 震慑、眩晕、定身免疫。"):format(eff.power * 100) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power=1 },
	on_gain = function(self, err) return "#Target# is moving freely.", "+Free Action" end,
	on_lose = function(self, err) return "#Target# is moving less freely.", "-Free Action" end,
	activate = function(self, eff)
		eff.stun = self:addTemporaryValue("stun_immune", eff.power)
		eff.daze = self:addTemporaryValue("daze_immune", eff.power)
		eff.pin = self:addTemporaryValue("pin_immune", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("stun_immune", eff.stun)
		self:removeTemporaryValue("daze_immune", eff.daze)
		self:removeTemporaryValue("pin_immune", eff.pin)
	end,
}

newEffect{
	name = "ADRENALINE_SURGE", image = "talents/adrenaline_surge.png",
	desc = "Adrenaline Surge",
	long_desc = function(self, eff) return ("目标战斗伤害提高 %d 能量枯竭时消耗生命值代替体力值继续战斗。"):format(eff.power) end,
	type = "physical",
	subtype = { frenzy=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# feels a surge of adrenaline." end,
	on_lose = function(self, err) return "#Target#'s adrenaline surge has come to an end." end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("combat_dam", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_dam", eff.tmpid)
	end,
}

newEffect{
	name = "BLINDSIDE_BONUS", image = "talents/blindside.png",
	desc = "Blindside Bonus",
	long_desc = function(self, eff) return ("目标不知从哪里冒出来！闪避值增加 %d。"):format(eff.defenseChange) end,
	type = "physical",
	subtype = { evade=true },
	status = "beneficial",
	parameters = { defenseChange=10 },
	activate = function(self, eff)
		eff.defenseChangeId = self:addTemporaryValue("combat_def", eff.defenseChange)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_def", eff.defenseChangeId)
	end,
}

newEffect{
	name = "OFFBALANCE",
	desc = "Off-balance",
	long_desc = function(self, eff) return ("严重失去平衡，降低整体伤害 15％。") end,
	type = "physical",
	subtype = { ["cross tier"]=true },
	status = "detrimental",
	parameters = {power = 1},
	on_gain = function(self, err) return nil, "+Off-balance" end,
	on_lose = function(self, err) return nil, "-Off-balance" end,
	activate = function(self, eff)
		eff.speedid = self:addTemporaryValue("numbed", 15)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("numbed", eff.speedid)
	end,
}

newEffect{
	name = "OFFGUARD",
	desc = "Off-guard", image = "talents/precise_strikes.png",
	long_desc = function(self, eff) return ("目标失去防备，攻击者获得 10％额外物理暴击概率和暴击加成。") end,
	type = "physical",
	subtype = { ["cross tier"]=true },
	status = "detrimental",
	parameters = {power = 1},
	on_gain = function(self, err) return nil, "+Off-guard" end,
	on_lose = function(self, err) return nil, "-Off-guard" end,
	activate = function(self, eff)
		eff.crit_vuln = self:addTemporaryValue("combat_crit_vulnerable", 10) -- increases chance to be crit
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_crit_vulnerable", eff.crit_vuln)
	end,
}

newEffect{
	name = "SLOW_MOVE",
	desc = "Slow movement", image = "talents/slow.png",
	long_desc = function(self, eff) return ("移动速度下降 %d%%。"):format(eff.power*100) end,
	type = "physical",
	subtype = { nature=true },
	status = "detrimental",
	parameters = {power = 1},
	on_gain = function(self, err) return nil, "+Slow movement" end,
	on_lose = function(self, err) return nil, "-Slow movement" end,
	activate = function(self, eff)
		eff.speedid = self:addTemporaryValue("movement_speed", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("movement_speed", eff.speedid)
	end,
}

newEffect{
	name = "WEAKENED",
	desc = "Weakened", image = "talents/ruined_earth.png",
	long_desc = function(self, eff) return ("目标被弱化，降低 %d%% 所有伤害。"):format(eff.power) end,
	charges = function(self, eff) return (math.floor(eff.power)).."%" end,
	type = "physical",
	subtype = { curse=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# has been weakened." end,
	on_lose = function(self, err) return "#Target#'s is no longer weakened." end,
	activate = function(self, eff)
		eff.incDamageId = self:addTemporaryValue("inc_damage", {all=-eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.incDamageId)
	end,
}

newEffect{
	name = "LOWER_FIRE_RESIST",
	desc = "Lowered fire resistance",
	long_desc = function(self, eff) return ("目标火焰抗性降低 %d%%。"):format(eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "detrimental",
	parameters = { power=20 },
	on_gain = function(self, err) return "#Target# becomes more vulnerable to fire.", "+Low. fire resist" end,
	on_lose = function(self, err) return "#Target# is less vulnerable to fire.", "-Low. fire resist" end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("resists", {[DamageType.FIRE]=-eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.pid)
	end,
}
newEffect{
	name = "LOWER_COLD_RESIST",
	desc = "Lowered cold resistance",
	long_desc = function(self, eff) return ("目标冰抗性抗下降 %d%%。"):format(eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "detrimental",
	parameters = { power=20 },
	on_gain = function(self, err) return "#Target# becomes more vulnerable to cold.", "+Low. cold resist" end,
	on_lose = function(self, err) return "#Target# is less vulnerable to cold.", "-Low. cold resist" end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("resists", {[DamageType.COLD]=-eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.pid)
	end,
}
newEffect{
	name = "LOWER_NATURE_RESIST",
	desc = "Lowered nature resistance",
	long_desc = function(self, eff) return ("目标自然抗性降低 %d%%。"):format(eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "detrimental",
	parameters = { power=20 },
	on_gain = function(self, err) return "#Target# becomes more vulnerable to nature.", "+Low. nature resist" end,
	on_lose = function(self, err) return "#Target# is less vulnerable to nature.", "-Low. nature resist" end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("resists", {[DamageType.NATURE]=-eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.pid)
	end,
}
newEffect{
	name = "LOWER_PHYSICAL_RESIST",
	desc = "Lowered physical resistance",
	long_desc = function(self, eff) return ("目标物理抗性降低 %d%%。"):format(eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "detrimental",
	parameters = { power=20 },
	on_gain = function(self, err) return "#Target# becomes more vulnerable to physical.", "+Low. physical resist" end,
	on_lose = function(self, err) return "#Target# is less vulnerable to physical.", "-Low. physical resist" end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("resists", {[DamageType.PHYSICAL]=-eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.pid)
	end,
}

newEffect{
	name = "CURSED_WOUND", image = "talents/slash.png",
	desc = "Cursed Wound",
	long_desc = function(self, eff) return ("目标受到被诅咒的创伤，降低治疗效果 %d%%。"):format(-eff.healFactorChange * 100) end,
	type = "physical",
	subtype = { wound=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = { healFactorChange=-0.1 },
	on_gain = function(self, err) return "#Target# has a cursed wound!", "+Cursed Wound" end,
	on_lose = function(self, err) return "#Target# no longer has a cursed wound.", "-Cursed Wound" end,
	activate = function(self, eff)
		eff.healFactorId = self:addTemporaryValue("healing_factor", eff.healFactorChange)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("healing_factor", eff.healFactorId)
	end,
	on_merge = function(self, old_eff, new_eff)
		-- add the remaining healing reduction spread out over the new duration
		old_eff.healFactorChange = math.max(-0.75, (old_eff.healFactorChange / old_eff.totalDuration) * old_eff.dur + new_eff.healFactorChange)
		old_eff.dur = math.max(old_eff.dur, new_eff.dur)

		self:removeTemporaryValue("healing_factor", old_eff.healFactorId)
		old_eff.healFactorId = self:addTemporaryValue("healing_factor", old_eff.healFactorChange)
		game.logSeen(self, "%s has re-opened a cursed wound!", self.name:capitalize())

		return old_eff
	end,
}

newEffect{
	name = "LUMINESCENCE",
	desc = "Luminescence ", image = "talents/infusion__sun.png",
	long_desc = function(self, eff) return ("目标被显形，降低潜行等级 %d。"):format(eff.power) end,
	type = "physical",
	subtype = { nature=true, light=true },
	status = "detrimental",
	parameters = { power=20 },
	on_gain = function(self, err) return "#Target# has been illuminated.", "+Luminescence" end,
	on_lose = function(self, err) return "#Target# is no longer illuminated.", "-Luminescence" end,
	activate = function(self, eff)
		eff.stealthid = self:addTemporaryValue("inc_stealth", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_stealth", eff.stealthid)
	end,
}

newEffect{
	name = "SPELL_DISRUPTION", image = "talents/mana_clash.png",
	desc = "Spell Disruption",
	long_desc = function(self, eff) return ("目标有 %d%% 几率法术失败并且每回合有几率中断持续性法术技能。"):format(eff.cur_power) end,
	charges = function(self, eff) return eff.cur_power end,	
	type = "physical",
	subtype = { antimagic=true, nature=true },
	status = "detrimental",
	parameters = { power=10, max=50 },
	on_gain = function(self, err) return "#Target#'s magic has been disrupted." end,
	on_lose = function(self, err) return "#Target#'s is no longer disrupted." end,
	on_merge = function(self, old_eff, new_eff)
		self:removeTemporaryValue("spell_failure", old_eff.tmpid)
		old_eff.cur_power = math.min(old_eff.cur_power + new_eff.power, new_eff.max)
		old_eff.tmpid = self:addTemporaryValue("spell_failure", old_eff.cur_power)

		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		eff.cur_power = eff.power
		eff.tmpid = self:addTemporaryValue("spell_failure", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("spell_failure", eff.tmpid)
	end,
}

newEffect{
	name = "RESONANCE", image = "talents/alchemist_protection.png",
	desc = "Resonance",
	long_desc = function(self, eff) return ("+%d%% %s 伤害。"):format(eff.dam, DamageType:get(eff.damtype).name) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { dam=10, damtype=DamageType.ARCANE },
	on_gain = function(self, err) return "#Target# resonates with the damage.", "+Resonance" end,
	on_lose = function(self, err) return "#Target# is no longer resonating.", "-Resonance" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("inc_damage", {[eff.damtype]=eff.dam})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.tmpid)
	end,
}

newEffect{
	name = "THORN_GRAB", image = "talents/thorn_grab.png",
	desc = "Thorn Grab",
	long_desc = function(self, eff) return ("目标被荆棘包裹，每回合造成 %d 自然伤害并使其减速 %d%%。"):format(eff.dam, eff.speed*100) end,
	type = "physical",
	subtype = { nature=true },
	status = "detrimental",
	parameters = { dam=10, speed=20 },
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", -eff.speed)
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.NATURE).projector(eff.src or self, self.x, self.y, DamageType.NATURE, eff.dam)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
	end,
}

newEffect{
	name = "LEAVES_COVER", image = "talents/leaves_tide.png",
	desc = "Leaves Cover",
	long_desc = function(self, eff) return ("%d%% 几率完全吸收任何伤害。"):format(eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is protected by a layer of thick leaves.", "+Leaves Cover" end,
	on_lose = function(self, err) return "#Target# cover of leaves falls apart.", "-Leaves Cover" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("cancel_damage_chance", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("cancel_damage_chance", eff.tmpid)
	end,
}

-- left in for backwards compatibility
newEffect{ -- Note: This effect is cancelled by EFF_DISARMED
	name = "DUAL_WEAPON_DEFENSE", image = "talents/dual_weapon_defense.png",
	desc = "Parrying",
	deflectchance = function(self, eff) -- The last partial deflect has a reduced chance to happen
		if self:attr("encased_in_ice") or self:attr("disarmed") then return 0 end
		return util.bound(eff.deflects>=1 and eff.chance or eff.chance*math.mod(eff.deflects,1),0,100)
	end,
	long_desc = function(self, eff)
		return (" 阻挡近战攻击：面对近战攻击时有 %d%% 几率阻挡至多 %d 伤害， ( 剩余次数 %0.1f ) "):format(self.tempeffect_def.EFF_DUAL_WEAPON_DEFENSE.deflectchance(self, eff),eff.dam, math.max(eff.deflects,1))
	end,
	charges = function(self, eff) return math.ceil(eff.deflects) end,
	type = "physical",
	subtype = {tactic=true},
	status = "beneficial",
	decrease = 0,
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = {chance=10, dam = 1, deflects = 1},
	activate = function(self, eff)
		if self:attr("disarmed") or not self:hasDualWeapon() then
			eff.dur = 0 self:removeEffect(self.EFF_DUAL_WEAPON_DEFENSE) return
			end
		eff.dam = self:callTalent(self.T_DUAL_WEAPON_DEFENSE,"getDamageChange")
		eff.deflects = self:callTalent(self.T_DUAL_WEAPON_DEFENSE,"getDeflects")
		eff.chance = self:callTalent(self.T_DUAL_WEAPON_DEFENSE,"getDeflectChance")
		if eff.dam <= 0 or eff.deflects <= 0 then eff.dur = 0 end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{ -- Note: This effect is cancelled by EFF_DISARMED
	name = "PARRY", image = "talents/dual_weapon_mastery.png",
	desc = "Parrying",
	deflectchance = function(self, eff, adj) -- The last partial deflect has a reduced chance to happen
		adj = adj or 1
		if self:attr("encased_in_ice") or self:attr("disarmed") then return 0 end
		return util.bound(adj*(eff.deflects >=1 and eff.chance or eff.chance*math.mod(eff.deflects, 1)), 0, 100)
	end,
	long_desc = function(self, eff)
		return ("阻挡近战%s 攻击：面对近战攻击时有 %d%% 几率阻挡至多 %d 伤害， ( 剩余次数 %0.1f )。被阻挡的攻击不会暴击。"):format(eff.parry_ranged and " 和远程 " or "", math.floor(self:callEffect(self.EFF_PARRY, "deflectchance")), eff.dam, math.max(eff.deflects, 1))
	end,
	charges = function(self, eff) return math.ceil(eff.deflects) end,
	type = "physical",
	subtype = {tactic=true},
	status = "beneficial",
	decrease = 0,
	on_timeout = function(self, eff) -- always remove before refreshing each turn
		self:removeEffect(self.EFF_PARRY)
	end,
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = {chance=10, dam = 1, deflects = 1, parry_ranged=false},
	doDeflect = function(self, eff, src) -- determine how much damage is deflected from src
		if not eff then return 0 end
		local deflected = 0
		local s = src.__project_source or src
		local adj = (self:canSee(s) or self:attr("blind_fight")) and 1 or 1/3 -- 1/3 chance to parry attack from unseen source
		if rng.percent(self:callEffect(eff.effect_id, "deflectchance", adj)) then
			deflected = eff.dam
			if self:knowTalent(self.T_TEMPO) then
				self:callTalent(self.T_TEMPO, "do_tempo", src)
			end
		end

		eff.deflects = eff.deflects - 1
		if eff.deflects <= 0 then self:removeEffect(self.EFF_PARRY) end
		return deflected
	end,
	on_merge = function(self, old_eff, new_eff)
		new_eff.chance = 100 - (100 - old_eff.chance)*(100 - new_eff.chance)/100
		new_eff.dam = math.max(old_eff.dam, new_eff.dam)
		new_eff.deflects = math.max(old_eff.deflects, new_eff.deflects) + math.min(old_eff.deflects, new_eff.deflects)*.5
		new_eff.parry_ranged = old_eff.parry_ranged or new_eff.parry_ranged
		return new_eff
	end,
	activate = function(self, eff)
		if self:attr("disarmed") or not self:hasDualWeapon() then
			eff.dur = 0 self:removeEffect(self.EFF_PARRY) return
		end
		if eff.dam <= 0 or eff.deflects <= 0 then eff.dur = 0 end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "BLOCKING", image = "talents/block.png",
	desc = "Blocking",
	long_desc = function(self, eff) return ("减少受到的所有伤害 %d 点。"):format(eff.power) end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = { nb=1 },
	on_gain = function(self, eff) return nil, nil end,
	on_lose = function(self, eff) return nil, nil end,
	do_block = function(type, dam, eff, self, src)
		local dur_inc = 0
		local crit_inc = 0
		local nb = 1
		if self:knowTalent(self.T_RIPOSTE) then
			local t = self:getTalentFromId(self.T_RIPOSTE)
			dur_inc = t.getDurInc(self, t)
			crit_inc = t.getCritInc(self, t)
			nb = nb + dur_inc
		end
		local b = false
		if eff.d_types[type] then b = true end
		if not b then return dam end
		local amt = util.bound(dam - eff.power, 0, dam)
		if eff.bonus_block_pct and eff.bonus_block_pct[type] then amt = amt * eff.bonus_block_pct[type] end
		local blocked = dam - amt
		local shield1, combat1, shield2, combat2 = self:hasShield()

		-- on_block can have two structures, an older single table, and a newer list of on_block functions used by randomly generated items
		if shield1 and shield1.on_block and shield1.on_block.fct then shield1.on_block.fct(shield1, self, src, type, dam, eff) end
		if shield2 and shield2.on_block and shield2.on_block.fct then shield2.on_block.fct(shield2, self, src, type, dam, eff) end

		if shield1 and shield1.on_block and shield1.on_block[1] then
			for _, on_block in pairs(shield1.on_block) do
				on_block.fct(shield1, self, src, type, dam, eff, on_block)
			end
		end
		if shield2 and shield2.on_block and shield2.on_block[1] then
			for _, on_block in pairs(shield2.on_block) do
				on_block.fct(shield2, self, src, type, dam, eff, on_block)
			end
		end

		if eff.properties.br then
			self:heal(blocked, src)
			game:delayedLogMessage(self, src, "block_heal", "#CRIMSON##Source# heals from blocking with %s shield!", string.his_her(self))
		end
		if eff.properties.ref and src.life then DamageType.defaultProjector(src, src.x, src.y, type, blocked, tmp, true) end
		local full = false
		if (self:attr("allow_incomplete_blocks") or amt == 0) and not eff.did_counterstrike and src.life then
			full = true
			if not self.__counterstrike_recurse then
				self.__counterstrike_recurse = true
				if not self:knowTalent(self.T_ETERNAL_GUARD) then eff.did_counterstrike = true end
				src:setEffect(src.EFF_COUNTERSTRIKE, 2, {power=eff.power, no_ct_effect=true, src=self, crit_inc=crit_inc, nb=nb})
				if eff.properties.sb then
					if src:canBe("disarm") then
						src:setEffect(src.EFF_DISARMED, 3, {apply_power=self:combatPhysicalpower()})
					else
						game.logSeen(src, "%s resists the disarming attempt!", src.name:capitalize())
					end
				end
				if eff.properties.on_cs then
					eff.properties.on_cs(self, eff, dam, type, src)
				end
				self.__counterstrike_recurse = nil
			end
		end
		eff.did_block = true
		self:fireTalentCheck("callbackOnBlock", eff, dam, type, src, blocked)

		return amt
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("block", eff.power)
		if eff.properties.sp then eff.spell = self:addTemporaryValue("combat_spellresist", eff.power) end
		self:effectParticles(eff, {type="block"})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("block", eff.tmpid)
		if eff.properties.sp then self:removeTemporaryValue("combat_spellresist", eff.spell) end
	end,
}

newEffect{
	name = "COUNTERSTRIKE", image = "effects/counterstrike.png",
	desc = "Counterstrike",
	long_desc = function(self, eff) return "容易受到致命的反击。下一次近战攻击将造成双倍伤害。" end,
	type = "physical",
	subtype = { tactic=true },
	status = "detrimental",
	parameters = { nb=1 },
	on_gain = function(self, eff) return nil, "+Counter" end,
	on_lose = function(self, eff) return nil, "-Counter" end,
	onStrike = function(self, eff, dam, src)
		eff.nb = eff.nb - 1
		if eff.nb <= 0 then self:removeEffect(self.EFF_COUNTERSTRIKE) end

		if self.x and src.x and core.fov.distance(self.x, self.y, src.x, src.y) >= 5 then
			game:setAllowedBuild("rogue_skirmisher", true)
		end

		return dam * 2
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("counterstrike", 1)
		eff.def = self:addTemporaryValue("combat_def", -eff.power)
		eff.crit = self:addTemporaryValue("combat_crit_vulnerable", eff.crit_inc or 0)
		local hx, hy = self:attachementSpot("head", true)
		if not hx then hx, hy = -0.4, -0.4
		else hx = hx - 0.4
		end
		self:effectParticles(eff, {type="circle", args={x=hx, y=hy, oversize=0.3, a=220, appear=12, img="counterstrike", speed=0, radius=0, base_rot=0}})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("counterstrike", eff.tmpid)
		self:removeTemporaryValue("combat_def", eff.def)
		self:removeTemporaryValue("combat_crit_vulnerable", eff.crit)
	end,
}

newEffect{
	name = "COUNTER_ATTACKING", image = "talents/counter_attack.png",
	desc = "Counter Attacking",
	counterchance = function(self, eff) --The last partial counter attack has a reduced chance to happen
		if self:attr("encased_in_ice") or self:attr("disarmed") then return 0 end
		return util.bound(eff.counterattacks>=1 and eff.chance or eff.chance*math.mod(eff.counterattacks,1),0,100)
	end,
	long_desc = function(self, eff)
		return (" 反击近战攻击：有 %d%% 几率在闪避近战攻击后反击对方。（剩余次数 %0.1f ） "):format(self.tempeffect_def.EFF_COUNTER_ATTACKING.counterchance(self, eff), math.max(eff.counterattacks,1))
	end,
	charges = function(self, eff) return math.ceil(eff.counterattacks) end,
	type = "physical",
	subtype = {tactic=true},
	status = "beneficial",
	decrease = 0,
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = {chance=10, counterattacks = 1},
	activate = function(self, eff)
		if self:attr("disarmed") then eff.dur = 0 return end
		eff.counterattacks = self:callTalent(self.T_COUNTER_ATTACK,"getCounterAttacks")
		eff.chance = self:callTalent(self.T_COUNTER_ATTACK,"counterchance")
		if eff.counterattacks <= 0 or eff.chance <= 0 then eff.dur = 0 end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "BRAWLER_BLOCK", image = "talents/block.png",
	desc = "Blocking",
	long_desc = function(self, eff)
		return ("格挡至多%d 伤害。"):
			format(self.brawler_block or 0)
	end,
	type = "physical",
	subtype = {tactic=true},
	status = "beneficial",
	parameters = {block = 0},
	activate = function(self, eff)
		self.brawler_block = eff.block
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={toback=false, size_factor=2, img="open_palm_block_tentacles2"}, shader={type="tentacles", backgroundLayersCount=-4, appearTime=0.3, time_factor=500, noup=0.0}})
		end
	end,
	deactivate = function(self, eff)
		self.brawler_block = nil
	end,
	callbackOnTakeDamage = function(self, eff, src, x, y, type, value, tmp)
		if not (self:attr("brawler_block") ) or value <= 0 then return end
		print("[PALM CALLBACK] dam start", value)

		local dam = value
		game:delayedLogDamage(src, self, 0, ("#STEEL_BLUE#(%d blocked)#LAST#"):format(math.min(dam, self.brawler_block)), false)
		if dam < self.brawler_block then
			self.brawler_block = self.brawler_block - dam
			dam = 0
		else
			dam = dam - self.brawler_block
			self.brawler_block = 0
		end

		-- If we are at the end of the capacity, release the time shield damage
		if self.brawler_block <= 0 then
			game.logPlayer(self, "#ORCHID#You cannot block any more attacks!#LAST#")
			self:removeEffect(self.EFF_BRAWLER_BLOCK)
		end

		print("[PALM CALLBACK] dam end", dam)

		return {dam = dam}
	end,
}

newEffect{
	name = "DEFENSIVE_GRAPPLING", image = "talents/defensive_throw.png",
	desc = "Grappling Defensively",
	throwchance = function(self, eff) -- the last partial defensive throw has a reduced chance to happen
		if not self:isUnarmed() or self:attr("encased_in_ice") then return 0 end	-- Must be unarmed
		return util.bound(eff.throws>=1 and eff.chance or eff.chance*math.mod(eff.throws,1),0,100)
	end,
	long_desc = function(self, eff)
		return (" 在闪避近战攻击后有 %d%% 几率反击对方，可能将对方掀翻在地并震慑之（剩余次数 %0.1f  ）"):format(self.tempeffect_def.EFF_DEFENSIVE_GRAPPLING.throwchance(self, eff), math.max(eff.throws,1))
	end,
	charges = function(self, eff) return math.ceil(eff.throws) end,
	type = "physical",
	subtype = {tactic=true},
	status = "beneficial",
	decrease = 0,
	no_stop_enter_worlmap = true, no_stop_resting = true,
	parameters = {chance=10, throws = 1},
	activate = function(self, eff)
		if not self:isUnarmed() then eff.dur = 0 self:removeEffect(self.EFF_DEFENSIVE_GRAPPLING) return end
--		if not self:isUnarmed() then eff.dur = 0 return end
		eff.throws = self:callTalent(self.T_DEFENSIVE_THROW,"getThrows")
		eff.chance = self:callTalent(self.T_DEFENSIVE_THROW,"getchance")
		if eff.throws <= 0 or eff.chance <= 0 then eff.dur = 0 end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "RAVAGE", image = "talents/ravage.png",
	desc = "Ravage",
	long_desc = function(self, eff)
		local ravaged = ""
		if eff.ravage then ravaged = "同时丢失一项物理效果 " end
		return ("目标被疯狂扭曲，每回合受到 %0.2f 物理伤害 %s 。"):format(eff.dam, ravaged)
	end,
	type = "physical",
	subtype = { distortion=true },
	status = "detrimental",
	parameters = {dam=1, distort=0},
	on_gain = function(self, err) return  nil, "+Ravage" end,
	on_lose = function(self, err) return "#Target# is no longer being ravaged." or nil, "-Ravage" end,
	on_timeout = function(self, eff)
		if eff.ravage then
			-- Go through all physical effects
			local effs = {}
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.type == "physical" and e.status == "beneficial" then
					effs[#effs+1] = {"effect", eff_id}
				end
			end

			-- Go through all sustained techniques
			for tid, act in pairs(self.sustain_talents) do
				if act then
					local talent = self:getTalentFromId(tid)
					if talent.type[1]:find("^technique/") then effs[#effs+1] = {"talent", tid} end
				end
			end

			if #effs > 0 then
				local eff = rng.tableRemove(effs)
				if eff[1] == "effect" then
					self:removeEffect(eff[2])
				else
					self:forceUseTalent(eff[2], {ignore_energy=true})
				end
			end
		end
		self:setEffect(self.EFF_DISTORTION, 2, {power=eff.distort})
		DamageType:get(DamageType.PHYSICAL).projector(eff.src or self, self.x, self.y, DamageType.PHYSICAL, eff.dam)
	end,
	activate = function(self, eff)
		self:setEffect(self.EFF_DISTORTION, 2, {power=eff.distort})
		if eff.ravage then
			game.logSeen(self, "#LIGHT_RED#%s is being ravaged by distortion!", self.name:capitalize())
			eff.dam = eff.dam * 1.5
		end
		local particle = Particles.new("ultrashield", 1, {rm=255, rM=255, gm=180, gM=255, bm=220, bM=255, am=35, aM=90, radius=0.2, density=15, life=28, instop=40})
		if core.shader.allow("distort") then particle:setSub("gravity_well2", 1, {radius=1}) end
		eff.particle = self:addParticles(particle)
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "DISTORTION", image = "talents/maelstrom.png",
	desc = "Distortion",
	long_desc = function(self, eff) return (" 目标最近承受了扭曲伤害，对扭曲效果更敏感，同时物理抗性下降 %d%%。"):format(eff.power) end,
	type = "physical",
	subtype = { distortion=true },
	status = "detrimental",
	parameters = {power=0},
	on_gain = function(self, err) return  nil, "+Distortion" end,
	on_lose = function(self, err) return "#Target# is no longer distorted." or nil, "-Distortion" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.PHYSICAL]=-eff.power})
	end,

}

newEffect{
	name = "DISABLE", image = "talents/cripple.png",
	desc = "Disable",
	long_desc = function(self, eff) return ("目标生活不能自理，降低 %d%% 移动速度，降低 %d 物理强度。"):format(eff.speed * 100, eff.atk) end,
	type = "physical",
	subtype = { wound=true },
	status = "detrimental",
	parameters = { speed=0.15, atk=10 },
	on_gain = function(self, err) return "#Target# is disabled.", "+Disabled" end,
	on_lose = function(self, err) return "#Target# is not disabled anymore.", "-Disabled" end,
	activate = function(self, eff)
		eff.speedid = self:addTemporaryValue("movement_speed", -eff.speed)
		eff.atkid = self:addTemporaryValue("combat_atk", -eff.atk)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("movement_speed", eff.speedid)
		self:removeTemporaryValue("combat_atk", eff.atkid)
	end,
}

newEffect{
	name = "ANGUISH", image = "talents/agony.png",
	desc = "Anguish",
	long_desc = function(self, eff) return ("极度痛苦，不能使用战术，同时降低 %d 意志和 %d 灵巧。"):format(eff.will, eff.cun) end,
	type = "physical",
	subtype = { wound=true },
	status = "detrimental",
	parameters = { will=5, cun=5 },
	on_gain = function(self, err) return "#Target# is in anguish.", "+Anguish" end,
	on_lose = function(self, err) return "#Target# is no longer in anguish.", "-Anguish" end,
	activate = function(self, eff)
		eff.sid = self:addTemporaryValue("inc_stats", {[Stats.STAT_WIL]=-eff.will, [Stats.STAT_CUN]=-eff.cun})
--		if self.ai_state then eff.ai = self:addTemporaryValue("ai_state", {forbid_tactical=1}) end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_stats", eff.sid)
--		if eff.ai then self:removeTemporaryValue("ai_state", eff.ai) end
	end,
}

newEffect{
	name = "FAST_AS_LIGHTNING", image = "talents/fast_as_lightning.png",
	desc = "Fast As Lightning",
	long_desc = function(self, eff) return ("目标速度极快，下两个回合如果向相同方向移动可闪过障碍物。"):format() end,
	type = "physical",
	subtype = { speed=true },
	status = "beneficial",
	parameters = { },
	on_merge = function(self, old_eff, new_eff)
		return old_eff
	end,
	on_gain = function(self, err) return "#Target# is speeding up.", "+Fast As Lightning" end,
	on_lose = function(self, err) return "#Target# is slowing down.", "-Fast As Lightning" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "phase_shift", 0.5)
	end,
	deactivate = function(self, eff)
		if eff.particle then
			self:removeParticles(eff.particle)
		end
	end,
}

newEffect{
	name = "STEAMROLLER", image = "talents/steamroller.png",
	desc = "Steamroller",
	long_desc = function(self, eff) return ("被杀时重置冲锋冷却时间。") end,
	type = "physical",
	subtype = { status=true },
	status = "detrimental",
	parameters = { },
	activate = function(self, eff)
		self.reset_rush_on_death = eff.src
	end,
	deactivate = function(self, eff)
		self.reset_rush_on_death = nil
	end,
}


newEffect{
	name = "STEAMROLLER_USER", image = "talents/steamroller.png",
	desc = "Steamroller",
	long_desc = function(self, eff) return ("获得 +%d%% 伤害加成。"):format(eff.buff) end,
	type = "physical",
	subtype = { status=true },
	status = "beneficial",
	parameters = { buff=20 },
	on_merge = function(self, old_eff, new_eff)
		new_eff.buff = math.min(100, old_eff.buff + new_eff.buff)
		self:removeTemporaryValue("inc_damage", old_eff.buffid)
		new_eff.buffid = self:addTemporaryValue("inc_damage", {all=new_eff.buff})
		return new_eff
	end,
	activate = function(self, eff)
		eff.buffid = self:addTemporaryValue("inc_damage", {all=eff.buff})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.buffid)
	end,
}

newEffect{
	name = "SPINE_OF_THE_WORLD", image = "talents/spine_of_the_world.png",
	desc = "Spine of the World",
	long_desc = function(self, eff) return ("对物理效果免疫。") end,
	type = "physical",
	subtype = { status=true },
	status = "beneficial",
	parameters = { },
	on_gain = function(self, err) return "#Target# become impervious to physical effects.", "+Spine of the World" end,
	on_lose = function(self, err) return "#Target# is less impervious to physical effects.", "-Spine of the World" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "physical_negative_status_effect_immune", 1)
	end,
}

newEffect{
	name = "FUNGAL_BLOOD", image = "talents/fungal_blood.png",
	desc = "Fungal Blood",
	long_desc = function(self, eff) return ("已储存 %d 真菌能量。使用真菌血液天赋来释放能量治疗。"):format(eff.power) end,
	type = "physical",
	subtype = { heal=true },
	status = "beneficial",
	parameters = { power = 10 },
	on_gain = function(self, err) return nil, "+Fungal Blood" end,
	on_lose = function(self, err) return nil, "-Fungal Blood" end,
	on_merge = function(self, old_eff, new_eff)
		new_eff.power = new_eff.power + old_eff.power
		return new_eff
	end,
	on_timeout = function(self, eff)
		eff.power = util.bound(eff.power * 0.9, 0, eff.power - 10)
	end,
}

newEffect{
	name = "MUCUS", image = "talents/mucus.png",
	desc = "Mucus",
	long_desc = function(self, eff) return ("在你行走过的地方留下粘液。"):format() end,
	type = "physical",
	subtype = { mucus=true },
	status = "beneficial",
	parameters = {},
	on_gain = function(self, err) return nil, "+Mucus" end,
	on_lose = function(self, err) return nil, "-Mucus" end,
	on_timeout = function(self, eff)
		self:callTalent(self.T_MUCUS, nil, self.x, self.y, self:getTalentLevel(self.T_MUCUS) >=4 and 1 or 0, eff)
	end,
}

newEffect{
	name = "CORROSIVE_NATURE", image = "talents/corrosive_nature.png",
	desc = "Corrosive Nature",
	long_desc = function(self, eff) return ("酸性伤害增加 %d%%."):format(eff.power) end,
	type = "physical",
	subtype = { nature=true, acid=true },
	status = "beneficial",
	parameters = { power=1, bonus_level=1},
	charges = function(self, eff) return math.round(eff.power) end,
	on_gain = function(self, err) return "#Target#'s acid damage is more potent.", "+Corrosive Nature" end,
	on_lose = function(self, err) return "#Target#'s acid damage is no longer so potent.", "-Corrosive Nature" end,
	on_merge = function(self, eff, new_eff)
		if game.turn < eff.last_update + 10 then return eff end -- update once a turn
		local t = self:getTalentFromId(self.T_CORROSIVE_NATURE)
		eff.dur = t.getDuration(self, t)
		if eff.bonus_level >=5 then return eff end
		game.logSeen(self, "%s's corrosive nature intensifies!",self.name:capitalize())
		eff.last_update = game.turn
		eff.bonus_level = eff.bonus_level + 1
		eff.power = t.getAcidDamage(self, t, eff.bonus_level)
		self:removeTemporaryValue("inc_damage", eff.dam_id)
		eff.dam_id = self:addTemporaryValue("inc_damage", {[DamageType.ACID]=eff.power})
		return eff
	end,
	activate = function(self, eff)
		eff.power = self:callTalent(self.T_CORROSIVE_NATURE, "getAcidDamage")
		eff.dam_id = self:addTemporaryValue("inc_damage", {[DamageType.ACID]=eff.power})
		eff.last_update = game.turn
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.dam_id)
	end,
}

newEffect{
	name = "NATURAL_ACID", image = "talents/natural_acid.png",
	desc = "Natural Acid",
	long_desc = function(self, eff) return ("自然伤害增加 %d%%."):format(eff.power) end,
	type = "physical",
	subtype = { nature=true, acid=true },
	status = "beneficial",
	parameters = { power=1, bonus_level=1},
	charges = function(self, eff) return math.round(eff.power) end,
	on_gain = function(self, err) return "#Target#'s nature damage is more potent.", "+Natural Acid" end,
	on_lose = function(self, err) return "#Target#'s nature damage is no longer so potent.", "-Nature Acid" end,
	on_merge = function(self, eff, new_eff)
		if game.turn < eff.last_update + 10 then return eff end -- update once a turn
		local t = self:getTalentFromId(self.T_NATURAL_ACID)
		eff.dur = t.getDuration(self, t)
		if eff.bonus_level >=5 then return eff end
		game.logSeen(self, "%s's natural acid becomes more concentrated!",self.name:capitalize())
		eff.last_update = game.turn
		eff.bonus_level = eff.bonus_level + 1
		eff.power = t.getNatureDamage(self, t, eff.bonus_level)
		self:removeTemporaryValue("inc_damage", eff.dam_id)
		eff.dam_id = self:addTemporaryValue("inc_damage", {[DamageType.NATURE]=eff.power})
		return eff
	end,
	activate = function(self, eff)
		eff.power = self:callTalent(self.T_NATURAL_ACID, "getNatureDamage")
		eff.dam_id = self:addTemporaryValue("inc_damage", {[DamageType.NATURE]=eff.power})
		eff.last_update = game.turn
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.dam_id)
	end,
}

newEffect{
	name = "CORRODE", image = "talents/blightzone.png",
	desc = "Corrode",
	long_desc = function(self, eff) return ("目标被侵蚀，降低 %d 命中、 %d 护甲值和 %d 闪避。"):format(eff.atk, eff.armor, eff.defense) end,
	type = "physical",
	subtype = { acid=true },
	status = "detrimental",
	parameters = { atk=5, armor=5, defense=10 }, no_ct_effect = true,
	on_gain = function(self, err) return "#Target# is corroded." end,
	on_lose = function(self, err) return "#Target# has shook off the effects of their corrosion." end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_atk", -eff.atk)
		self:effectTemporaryValue(eff, "combat_armor", -eff.armor)
		self:effectTemporaryValue(eff, "combat_def", -eff.defense)
	end,
}

newEffect{
	name = "SLIPPERY_MOSS", image = "talents/slippery_moss.png",
	desc = "Slippery Moss",
	long_desc = function(self, eff) return ("目标被光滑苔藓覆盖，每次使用技能时有 %d%% 几率失败。"):format(eff.fail) end,
	type = "physical",
	subtype = { moss=true, nature=true },
	status = "detrimental",
	parameters = {fail=5},
	on_gain = function(self, err) return "#Target# is covered in slippery moss!", "+Slippery Moss" end,
	on_lose = function(self, err) return "#Target# is free from the slippery moss.", "-Slippery Moss" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("talent_fail_chance", eff.fail)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("talent_fail_chance", eff.tmpid)
	end,
}

newEffect{
	name = "JUGGERNAUT", image = "talents/juggernaut.png",
	desc = "Juggernaut",
	long_desc = function(self, eff) return ("减少 %d%% 物理伤害并有  %d%% 几率无视暴击伤害。"):format(eff.power, eff.crits) end,
	type = "physical",
	subtype = { superiority=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# hardens its skin.", "+Juggernaut" end,
	on_lose = function(self, err) return "#Target#'s skin returns to normal.", "-Juggernaut" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("stone_skin", 1, {density=4}))
		self:effectTemporaryValue(eff, "resists", {[DamageType.PHYSICAL]=eff.power})
		self:effectTemporaryValue(eff, "ignore_direct_crits", eff.crits)
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "NATURE_REPLENISHMENT", image = "talents/meditation.png",
	desc = "Natural Replenishment",
	long_desc = function(self, eff) return ("目标被奥术力量伤害，重新联系自然，每回合回复 %0.1f 失衡值。"):format(eff.power) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = {power=1},
	on_gain = function(self, err) return ("#Target# defiantly reasserts %s connection to nature!"):format(string.his_her(self)), "+Nature Replenishment" end,
	on_lose = function(self, err) return "#Target# stops restoring Equilibrium.", "-Nature Replenishment" end,
	on_timeout = function(self, eff)
		self:incEquilibrium(-eff.power)
	end,
}


newEffect{
	name = "BERSERKER_RAGE", image = "talents/berserker.png",
	desc = "Berserker Rage",
	long_desc = function(self, eff) return ("增加 %d%% 暴击率"):format(eff.power) end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	decrease = 0, no_remove = true,
	parameters = {power=1},
	charges = function(self, eff) return ("%0.1f%%"):format(eff.power) end,
	on_merge = function(self, old_eff, new_eff)
		self:removeTemporaryValue("combat_physcrit", old_eff.tmpid)
		old_eff.tmpid = self:addTemporaryValue("combat_physcrit", new_eff.power)
		old_eff.power = new_eff.power
		return old_eff
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("combat_physcrit", eff.power)
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={toback=true,  size_factor=1.5, img="tentacles_shader/berserker_aura_2"}, shader={type="tentacles", wobblingType=0, appearTime=0.3, time_factor=500, noup=2.0}})
			self:effectParticles(eff, {type="shader_shield", args={toback=false, size_factor=1.5, img="tentacles_shader/berserker_aura_2"}, shader={type="tentacles", wobblingType=0, appearTime=0.3, time_factor=500, noup=1.0}})
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_physcrit", eff.tmpid)
	end
}


newEffect{
	name = "RELENTLESS_FURY", image = "talents/relentless_fury.png",
	desc = "Relentless Fury",
	long_desc = function(self, eff) return ("增加 %d 体力回复,  %d%% 攻击和移动速度."):format(eff.stamina, eff.speed) end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = {stamina=1, speed=10},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "stamina_regen", eff.stamina)
		self:effectTemporaryValue(eff, "movement_speed", eff.speed/100)
		self:effectTemporaryValue(eff, "combat_physspeed", eff.speed/100)
	end,
}

local normalize_direction = function(direction)
	return direction % (2*math.pi)
end

local in_angle = function(angle, min, max)
	if min <= max then
		return min <= angle and angle <= max
	else
		return min <= angle or angle <= max
	end
end

newEffect {
	name = "SKIRMISHER_DIRECTED_SPEED",
	desc = "Directed Speed",
	type = "physical",
	subtype = {speed = true},
	parameters = {
		-- Movement direction in radians.
		direction = 0,
		-- Allowed deviation from movement direction in radians.
		leniency = math.pi * 0.1,
		-- Movement speed bonus
		move_speed_bonus = 1.00
	},
	status = "beneficial",
	on_lose = function(self, eff) return "#Target# loses speed.", "-Directed Speed" end,
	lists = 'break_with_step_up',
	callbackOnMove = function(self, eff, moved, force, ox, oy)
		local angle_start = normalize_direction(math.atan2(self.y - eff.start_y, self.x - eff.start_x))
		local angle_last = normalize_direction(math.atan2(self.y - eff.last_y, self.x - eff.last_x))
		if ((self.x ~= eff.start_x or self.y ~= eff.start_y) and
				not in_angle(angle_start, eff.min_angle_start, eff.max_angle_start)) or
			((self.x ~= eff.last_x or self.y ~= eff.last_y) and
			 not in_angle(angle_last, eff.min_angle_last, eff.max_angle_last))
		then
			self:removeEffect(self.EFF_SKIRMISHER_DIRECTED_SPEED)
		end
		eff.last_x = self.x
		eff.last_y = self.y
		eff.min_angle_last = normalize_direction(angle_last - eff.leniency_last)
		eff.max_angle_last = normalize_direction(angle_last + eff.leniency_last)
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "movement_speed", eff.move_speed_bonus)
		eff.leniency_last = math.max(math.pi * 0.25, eff.leniency)

		eff.start_x = self.x
		eff.start_y = self.y
		eff.min_angle_start = normalize_direction(eff.direction - eff.leniency)
		eff.max_angle_start = normalize_direction(eff.direction + eff.leniency)
		eff.last_x = self.x
		eff.last_y = self.y
		eff.min_angle_last = normalize_direction(eff.direction - eff.leniency_last)
		eff.max_angle_last = normalize_direction(eff.direction + eff.leniency_last)

		-- AI won't use talents while active.
		if self.ai_state then
-- should change priorities rather than forbid all talents
			self:effectTemporaryValue(eff, "ai_state", {no_talents=1})
		end
	end,
	long_desc = function(self, eff)
		return ([[目标单方向（%s）移动时获得 %d%% 额外速度。停止或者改变方向将取消此效果。]])
		:format(eff.compass or "未知",eff.move_speed_bonus * 100 )
	end,
}

-- If they don't have stun, stun them. If they do, increase its
-- duration.
newEffect {
	name = "SKIRMISHER_STUN_INCREASE",
	desc = "Stun Lengthen",
	long_desc = function(self, eff) return ([[This should not be shown, oops.]]) end,
	type = "physical",
	subtype = {stun = true},
	status = "detrimental",
	on_gain = function(self, eff)
		local stun = self:hasEffect(self.EFF_STUNNED)
		if stun and stun.dur and stun.dur > 1 then
			return ("#Target# is stunned further! (now %d turns)"):format(stun.dur), "Stun Lengthened"
		end
	end,
	activate = function(self, eff)
		local stun = self:hasEffect(self.EFF_STUNNED)
		if stun then
			stun.dur = stun.dur + eff.dur
		else
			self:setEffect(self.EFF_STUNNED, eff.dur, {})
		end
		self:removeEffect(self.EFF_SKIRMISHER_STUN_INCREASE)
	end,
}

newEffect {
	name = "SKIRMISHER_ETERNAL_WARRIOR",
	desc = "Eternal Warrior",
	image = "talents/skirmisher_the_eternal_warrior.png",
	type = "mental",
	subtype = { morale=true },
	status = "beneficial",
	parameters = {
		-- Resist all increase
		res=.5,
		-- Resist caps increase
		cap=.5,
		-- Maximum stacking applications
		max=5
	},
	on_gain = function(self, err) return nil, "+Eternal Warrior" end,
	on_lose = function(self, err) return nil, "-Eternal Warrior" end,
	long_desc = function(self, eff)
		return ("目标十分强大，增加全体抗性 %0.1f%%, 全体抗性上限 %0.1f%%."):
		format(eff.res, eff.cap)
	end,
	activate = function(self, eff)
		eff.res_id = self:addTemporaryValue("resists", {all = eff.res})
		eff.cap_id = self:addTemporaryValue("resists_cap", {all = eff.cap})
	end,
	on_merge = function(self, old_eff, new_eff)
		self:removeTemporaryValue("resists", old_eff.res_id)
			self:removeTemporaryValue("resists_cap", old_eff.cap_id)
		new_eff.res = math.min(new_eff.res + old_eff.res, new_eff.res * new_eff.max)
		new_eff.cap = math.min(new_eff.cap + old_eff.cap, new_eff.cap * new_eff.max)
		new_eff.res_id = self:addTemporaryValue("resists", {all = new_eff.res})
		new_eff.cap_id = self:addTemporaryValue("resists_cap", {all = new_eff.cap})
		return new_eff
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.res_id)
		self:removeTemporaryValue("resists_cap", eff.cap_id)
	end,
}

newEffect {
	name = "SKIRMISHER_TACTICAL_POSITION",
	desc = "Tactical Position",
	type = "physical",
	subtype = {tactic = true},
	status = "beneficial",
	parameters = {combat_physcrit = 10},
	long_desc = function(self, eff)
		return ([[目标重新移动到自己喜欢的位置，增加 %d%% 物理暴击率。]])
		:format(eff.combat_physcrit)
	end,
	on_gain = function(self, eff) return "#Target# is poised to strike!" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_physcrit", eff.combat_physcrit)
	end,
}

newEffect {
	name = "SKIRMISHER_DEFENSIVE_ROLL",
	desc = "Defensive Roll",
	type = "physical",
	subtype = {tactic = true},
	status = "beneficial",
	parameters = {
		-- percent of all damage to ignore
		reduce = 50
	},
	on_gain = function(self, eff) return "#Target# assumes an extreme defensive posture, avoiding some damage!" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "incoming_reduce", eff.reduce)
	end,
	long_desc = function(self, eff)
		return ([[目标进行了防御性的滚动，减少 %d%% 受到的伤害。]])
		:format(eff.reduce)
	end,
}

newEffect {
	name = "SKIRMISHER_TRAINED_REACTIONS_COOLDOWN",
	desc = "Trained Reactions Cooldown",
	type = "other",
	subtype = {cooldown = true},
	status = "detrimental",
	no_stop_resting = true,
	on_lose = function(self, eff) return "#LIGHT_BLUE##Target# may dodge again.", "+Trained Reactions" end,
	long_desc = function(self, eff)
		return "训练反射暂时不能触发。"
	end,
}

newEffect {
	name = "SKIRMISHER_SUPERB_AGILITY",
	desc = "Superb Agility",
	image = "talents/skirmisher_superb_agility.png",
	type = "physical",
	subtype = {speed = true},
	status = "beneficial",
	parameters = {
		global_speed_add = 0.1,
	},
	on_gain = function(self, eff) return "#Target# has sped up!" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "global_speed_add", eff.global_speed_add)
	end,
	long_desc = function(self, eff)
		return ([[目标的反应速度变快了，增加 %d%% 整体速度。]])
		:format(eff.global_speed_add * 100)
	end,
}

newEffect{
	name = "ANTI_GRAVITY", image = "talents/gravity_locus.png",
	desc = "Anti-Gravity",
	long_desc = function(self, eff) return ("目标被反重力力量击中，减半击退免疫。"):format() end,
	type = "physical",
	subtype = { spacetime=true },
	status = "detrimental",
	on_gain = function(self, err) return nil, "+Anti-Gravity" end,
	on_lose = function(self, err) return nil, "-Anti-Gravity" end,
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		if self:attr("knockback_immune") then
			self:effectTemporaryValue(eff, "knockback_immune", -self:attr("knockback_immune") / 2)
		end
	end,
}

newEffect{
	name = "PARASITIC_LEECHES", image = "talents/blood_suckers.png",
	desc = "Parasitic Leeches",
	display_desc = function(self, eff) return "Parasitic Leeches: "..eff.nb.." masses" end,
	long_desc = function(self, eff)
		local source = eff.src or self
		return ("目标被 %d 堆寄生虫寄生，每回合受到 %0.2f 物理和 %0.2f 酸性伤害。每隔 %d 回合，一堆寄生虫将脱落并繁殖。"):format(eff.nb,
		source:damDesc("PHYSICAL", eff.dam*eff.nb/2), source:damDesc("ACID", eff.dam*eff.nb/2), eff.gestation)
	end,
	type = "physical",
	subtype = { parasite=true },
	status = "detrimental",
	decrease = 0,
	on_merge = function(self, old_eff, new_eff) -- More leeches = faster feeding and more damage.
		old_eff.nb = old_eff.nb + 1
		old_eff.gestation = old_eff.gestation - 1
		return old_eff
	end,
	activate = function(self, eff)
	end,
	charges = function(self, eff) return eff.nb end,
	parameters = {dam=10, nb=1, gestation=5, turns=0 },
	on_gain = function(self, err) return "#Target# is #GREEN#INFESTED#LAST# with parasitic leeches!", "+Parasitic Leeches" end,
	on_timeout = function(self, eff)
		eff.turns = eff.turns + 1
		-- Creepy, so the player tries to get rid of it as soon as possible...
		local source = eff.src or self
		source:project({}, self.x, self.y, DamageType.PHYSICAL, eff.dam*eff.nb/2)
		source:project({}, self.x, self.y, DamageType.ACID, eff.dam*eff.nb/2)
		if eff.turns >= eff.gestation then
			-- Find space
			local x, y = util.findFreeGrid(self.x, self.y, 3, true, {[Map.ACTOR]=true})
			if not x then
				--game.logPlayer(self, "Not enough space to invoke!")
				return
			end
			local m = game.zone:makeEntityByName(game.level, "actor", "HORROR_PARASITIC_LEECHES")
			if m then
				m.exp_worth = 0
				m.can_multiply = 1
				game.zone:addEntity(game.level, m, "actor", x, y)
				m:learnTalent(m.T_MULTIPLY, 1)

				game.logSeen(self, "Some leeches drop off %s!", self.name:capitalize())
			end
			eff.turns = 0
			eff.nb = eff.nb - 1
			eff.gestation = 6 - eff.nb
			if eff.nb <= 0 then self:removeEffect(self.EFF_PARASITIC_LEECHES, false, true) end
		end
	end,
	deactivate = function(self, eff)
		if eff.nb >= 0 then -- prematurely removed, drop all leeches without multiply.
			for n=1, eff.nb do
				-- Find space
				local x, y = util.findFreeGrid(self.x, self.y, 3, true, {[Map.ACTOR]=true})
				if not x then
					--game.logPlayer(self, "Not enough space to invoke!")
					return
				end
				local m = game.zone:makeEntityByName(game.level, "actor", "HORROR_PARASITIC_LEECHES")
				if m then
					m.exp_worth = 0
					game.zone:addEntity(game.level, m, "actor", x, y)
				end
			end
			game.logSeen(self, "Some leeches drop off %s!", self.name:capitalize())
		end
	end,
}

newEffect{
	name = "GARROTE", image = "talents/grab.png",
	desc = "Garrote",
	long_desc = function(self, eff)
		local silence = eff.silence > 0 and eff.silenceid and ("  It is silenced for the next %d turn(s), preventing it from casting spells and using some vocal talents."):format(eff.silence) or ""
		return ("The target is being garrotted by %s, rendering it unable to move and subject to an automatic unarmed attack (at %d%% damage) each turn.%s"):format(eff.src and eff.src.name or "something", eff.power*100, silence) 
	end,
	type = "physical",
	subtype = { grapple=true, pin=true },
	status = "detrimental",
	parameters = { power = 0.6, silence=0},
	remove_on_clone = true,
	on_gain = function(self, eff) return ("%s has garroted #Target#!"):format(eff.src and eff.src.name or "Something"), "+Garrote" end,
	on_lose = function(self, eff) return ("#Target# is free from %s's garrote."):format(eff.src and eff.src.name or "something"), "-Garrote" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "never_move", 1)
		if eff.silence > 0 then eff.silenceid = self:addTemporaryValue("silence", 1) end
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={toback=false, size_factor=1, img="garrote_tentacles"}, shader={type="tentacles", backgroundLayersCount=-4, appearTime=0.3, time_factor=1000, noup=0.0}})
		end
	end,
	charges = function(self, eff) return eff.silence end,
	on_timeout = function(self, eff)
		if eff.silence > 0 then
			eff.silence = eff.silence - 1
			if eff.silenceid and eff.silence <= 0 then self:removeTemporaryValue("silence", eff.silenceid); eff.silenceid = nil end
		end
		if not self.x or not eff.src or not eff.src.x or core.fov.distance(self.x, self.y, eff.src.x, eff.src.y) > 1 or eff.src.dead or not game.level:hasEntity(eff.src) then
			self:removeEffect(self.EFF_GARROTE)
		else
			eff.src:logCombat(self, "#Source# #LIGHT_RED#strangles#LAST# #Target#!")
			eff.src.turn_procs.auto_melee_hit = true
			self:attr("no_evasion", 1)
			eff.src:attackTarget(self, nil, eff.power, true, true)
			eff.src.turn_procs.auto_melee_hit = nil
			self:attr("no_evasion", -1)
		end
	end,
	deactivate = function(self, eff)
		if eff.silenceid then self:removeTemporaryValue("silence", eff.silenceid) end
	end, 
}

newEffect{
	name = "MARKED_FOR_DEATH", image = "talents/marked_for_death.png",
	desc = "Marked for Death",
	long_desc = function(self, eff) return ("The target takes %d%% increased damage from all sources.  If this effect runs its full course, the target will take an additional %0.1f physical damage (increased by %d%% of all damage taken while this effect is active)."):format(eff.power, eff.dam, eff.perc*100) end,
	type = "physical",
	subtype = {  },
	status = "detrimental",
	parameters = { power=20, perc=20, stam=0, turns = 0, max_dur=6},
	on_gain = function(self, err) return "#Target# is marked for death!", "+Marked for Death!" end,
	on_lose = function(self, err) return "#Target# is free from the deathmark.", "-Marked for Death" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {all=-eff.power})
		self:effectParticles(eff, {type="circle", args={toback=true, oversize=1.8, base_rot=180, a=255, shader=true, appear=12, img="marked_death_aura", speed=0, radius=0}})
	end,
	deactivate = function(self, eff)
		eff.src.__project_source = eff
		eff.src:project({type="hit", x=self.x, y=self.y}, self.x, self.y, DamageType.PHYSICAL, eff.dam, nil)
		game.level.map:particleEmitter(self.x, self.y, 1, "blood")
		eff.src.__project_source = nil
	end,
	on_timeout = function(self, eff)
		eff.turns = eff.turns + 1
	end,
	callbackOnHit = function(self, eff, cb)
		eff.dam = eff.dam + (cb.value * eff.perc)
		return true
	end,
	on_die = function(self, eff) -- splitting oozes?
		if eff.src then
			eff.src:incStamina(eff.stam)
			eff.src.talents_cd[eff.src.T_MARKED_FOR_DEATH] = 0
		end
	end,
}

newEffect{
	name = "DEADLY_POISON", image = "talents/apply_poison.png",
	desc = "Deadly Poison",
	long_desc = function(self, eff)
		local insidious = eff.insidious > 0 and (" Healing received is reduced by %d%%."):format(eff.insidious) or ""
		local numbing = eff.numbing > 0 and (" Damage dealt is reduced by %d%%."):format(eff.numbing) or ""
		local crippling = eff.crippling > 0 and (" %d%% chance to fail talents."):format(eff.crippling) or ""
		local volatile = eff.volatile > 0 and (" Poison damage also hits adjacent targets for 50%%."):format() or ""
		local leeching = eff.leeching > 0 and (" The source of this effect receives healing equal to %d%% of the damage it deals to the target."):format(eff.leeching) or ""
		return ("The target is poisoned, taking %0.2f nature damage per turn.%s%s%s%s%s"):format(eff.power, insidious, numbing, crippling, volatile, leeching) 
	end,
	charges = function(self, eff) return (math.floor(eff.power)) end,
	type = "physical",
	subtype = { poison=true, nature=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10, reduce=5},
	on_gain = function(self, err) return "#Target# is poisoned!", "+Deadly Poison" end,
	on_lose = function(self, err) return "#Target# is no longer poisoned.", "-Deadly Poison" end,
	-- Damage each turn
	on_timeout = function(self, eff, p, ed)
		if self:attr("purify_poison") then 
			self:heal(eff.power, eff.src)
		elseif self.x and self.y then
			local dam = DamageType:get(DamageType.NATURE).projector(eff.src, self.x, self.y, DamageType.NATURE, eff.power)
			if eff.volatile > 0 then
				local tg = {type="ball", radius=1, friendlyfire=false, x=self.x, y=self.y, act_exclude={[self.uid]=true}}
				eff.src:project(tg, self.x, self.y, DamageType.NATURE, eff.power / 2)
			end
			if dam > 0 and eff.leeching > 0 then
				local src = eff.src.resolveSource and eff.src:resolveSource()
				if src then src:heal(dam*eff.leeching/100, ed) end
			end
		end
	end,
	on_merge = function(self, old_eff, new_eff) --Note: on_merge called before activate
		-- Merge the poison
		local olddam = old_eff.power * old_eff.dur
		local newdam = new_eff.power * new_eff.dur
		local dur = math.ceil((old_eff.dur + new_eff.dur) / 2)
		old_eff.dur = dur
		old_eff.power = (olddam + newdam) / dur
		-- by default, can stack up to 5x power
		old_eff.max_power = math.max(old_eff.max_power or old_eff.power, new_eff.max_power or new_eff.power*5)
		old_eff.power = math.min(old_eff.power, old_eff.max_power)
		if old_eff.healid then 
			self:removeTemporaryValue("healing_factor", old_eff.healid)
			old_eff.healid = null
		end
		if old_eff.numbid then 
			self:removeTemporaryValue("numbed", old_eff.numbid) 
			old_eff.numbid = null
		end
		if old_eff.cripid then 
			self:removeTemporaryValue("talent_fail_chance", old_eff.cripid) 
			old_eff.cripid = null
		end
		if new_eff.insidious > 0 then old_eff.healid = self:addTemporaryValue("healing_factor", -new_eff.insidious / 100) end
		if new_eff.numbing > 0 then old_eff.numbid = self:addTemporaryValue("numbed", new_eff.numbing) end
		if new_eff.crippling > 0 then old_eff.cripid = self:addTemporaryValue("talent_fail_chance", new_eff.crippling) end
		old_eff.leeching = new_eff.leeching
		old_eff.volatile = new_eff.volatile
		return old_eff
	end,
	activate = function(self, eff)
		-- Only store ids for new temp values (Toxic Death may copy ids from killed victim)
		if eff.insidious > 0 then eff.healid = self:addTemporaryValue("healing_factor", -eff.insidious / 100) else eff.healid = nil end
		if eff.numbing > 0 then eff.numbid = self:addTemporaryValue("numbed", eff.numbing) else eff.numbid = nil end
		if eff.crippling > 0 then eff.cripid = self:addTemporaryValue("talent_fail_chance", eff.crippling) else eff.cripid = nil end
	end,
	deactivate = function(self, eff)
		if eff.healid then self:removeTemporaryValue("healing_factor", eff.healid) end
		if eff.numbid then self:removeTemporaryValue("numbed", eff.numbid) end
		if eff.cripid then self:removeTemporaryValue("talent_fail_chance", eff.cripid) end
	end,
}

newEffect{
	name = "RAZORWIRE", image = "talents/springrazor_trap.png",
	desc = "Razorwire",
	long_desc = function(self, eff) return ("The target's equipment has been shredded by razorwire, reducing its accuracy by %d, armour by %d, and defense by %d."):format(eff.power, eff.power, eff.power) end,
	type = "physical",
	subtype = { physical=true },
	status = "detrimental",
	parameters = { power=10 }, no_ct_effect = true,
	on_gain = function(self, err) return "#Target# is entangled in razorwire!" end,
	on_lose = function(self, err) return "#Target# has shook off the razorwire." end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_atk", -eff.power)
		self:effectTemporaryValue(eff, "combat_armor", -eff.power)
		self:effectTemporaryValue(eff, "combat_def", -eff.power)
	end,
}

newEffect{
	name = "DIRTY_FIGHTING", image = "talents/dirty_fighting.png",
	desc = "Dirty Fighting",
	long_desc = function(self, eff) return ("The target is reeling in pain. Stun, pin, blindness, and confusion immunity are halved and physical save is reduced by %d."):format(eff.power) end,
	type = "physical",
	subtype = { wound=true },
	status = "detrimental",
	parameters = { power=5 },
	on_gain = function(self, err) return nil, "+Dirty Fighting" end,
	on_lose = function(self, err) return nil, "-Dirty Fighting" end,
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		if self:attr("stun_immune") then
			self:effectTemporaryValue(eff, "stun_immune", -self:attr("stun_immune") / 2)
		end
		if self:attr("confusion_immune") then
			self:effectTemporaryValue(eff, "confusion_immune", -self:attr("confusion_immune") / 2)
		end
		if self:attr("blind_immune") then
			self:effectTemporaryValue(eff, "blind_immune", -self:attr("blind_immune") / 2)
		end
		if self:attr("pin_immune") then
			self:effectTemporaryValue(eff, "pin_immune", -self:attr("pin_immune") / 2)
		end
		self:effectTemporaryValue(eff, "combat_physresist", -eff.power)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "SOOTHING_DARKNESS", image = "talents/soothing_darkness.png",
	desc = "Soothing Darkness",
	long_desc = function(self, eff)
		local desc = ("The target is wreathed in shadows, increasing life regeneration by %0.1f"):format(eff.life)
		if eff.shadowguard > 0 then
			desc = desc..(", stamina regeneration by %0.1f and all damage resistance by %d%%."):format(eff.stamina, eff.shadowguard)
		else
			desc = desc..(" and stamina regeneration by %0.1f."):format(eff.stamina) end
		return desc
	end,
	type = "physical",
	subtype = { darkness=true, healing=true, regeneration=true },
	status = "beneficial",
	parameters = { life=1, stamina=0.5, dr=0, shadowguard=0 },
	activate = function(self, eff)
		eff.lifeid = self:addTemporaryValue("life_regen", eff.life)
		eff.staid = self:addTemporaryValue("stamina_regen", eff.stamina)
		self:effectTemporaryValue(eff, "resists", {all = eff.shadowguard})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("life_regen", eff.lifeid)
		self:removeTemporaryValue("stamina_regen", eff.staid)
	end,
}

newEffect{
	name = "SHADOW_DANCE", image = "talents/shadow_dance.png",
	desc = "Shadow Dance", 
	long_desc = function(self, eff) return ("The target is able to make actions and attacks while remaining stealthed."):format() end,
	type = "physical",
	subtype = { tactical=true, darkness=true },
	status = "beneficial",
	on_gain = function(self, err) game.logPlayer(self, "#GREY#You begin your Shadow Dance.") end,
	on_lose = function(self, err) game.logPlayer(self, "#GREY#You end your Shadow Dance.") end,
	parameters = {rad=10},
	activate = function(self, eff)
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={toback=true,  size_factor=2.5, y=0.25, img="shadow_dance_tentacle_wings"}, shader={type="tentacles", wobblingType=0, appearTime=0.8, time_factor=700, noup=0.0}})
		end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "SEDATED", image = "talents/dart_launcher.png",
	desc = "Sedated",
	long_desc = function(self, eff) return ("The target is in a deep sleep and unable to act.  Every %d damage it takes will reduce the duration of the effect by one turn."):format(eff.power) end,
	type = "physical",
	subtype = { sleep=true, poison=true },
	status = "detrimental",
	parameters = { power=10, insomnia=10, slow=0 },
	on_gain = function(self, eff)
		-- check non-poison immunities if this is being applied by Toxic Death
		if eff._from_toxic_death and not (self:checkClassification("living") and self:canBe("sleep")) then
			eff.cancel = true
			return
		end
		return "#Target# is in a deep sleep.", "+Sedated"
	end,
	on_lose = function(self, eff) return "#Target# is no longer sleeping.", "-Sedated" end,
	on_timeout = function(self, eff)
		-- Increment Insomnia Duration
		if not self:attr("lucid_dreamer") then
			self:setEffect(self.EFF_INSOMNIA, 1, {power=eff.insomnia})
		end
				
	end,
	activate = function(self, eff)
		if eff.cancel then self:removeEffect(eff.effect_id, true) return end
		eff._from_toxic_death = false
		self:effectTemporaryValue(eff, "sleep", 1)
	end,
	deactivate = function(self, eff)
		if not eff.cancel and not self:attr("sleep") and not self.dead and game.level:hasEntity(self) and eff.slow > 0 then
			if self:canBe("slow") then
				self:setEffect(self.EFF_SLOW, 4, {src=eff.src, power=eff.slow, no_ct_effect=true})
			end
		end
		if eff.particle then
			self:removeParticles(eff.particle)
		end
	end,
}

newEffect{
	name = "ROGUE_S_BREW", image = "talents/rogue_s_brew_mastery.png",
	desc = "Rogue's Brew",
	long_desc = function(self, eff) return ("The target will not die until falling below -%d life."):format(eff.power) end,
	type = "physical",
	charges = function(self, eff) return math.floor(eff.power) end,	
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power=1 },
	activate = function(self, eff)
		eff.die = self:addTemporaryValue("die_at", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("die_at", eff.die)
	end,
}

newEffect{
	name = "BEAR_TRAP", image = "talents/bear_trap.png",
	desc = "Bear Trap",
	long_desc = function(self, eff)
		local desc = {}
		if eff.pinid then desc[#desc+1] = "pinned" end
		if eff.slowid then desc[#desc+1] = ("slowed (%d%%)"):format(eff.power*100) end
		if eff.dam > 0 then desc[#desc+1] = ("taking %0.2f physical damage each turn"):format(eff.dam) end
		return "Caught in a bear trap: "..table.concat(desc, ", ")
	end,
	type = "physical",
	subtype = { slow=true, pin=true, wound=true, cut=true, bleed=true },
	status = "detrimental",
	parameters = { power=0.1, dam=10 },
	on_gain = function(self, err) return "A bear trap snaps onto #Target#!", "+Bear Trap" end,
	on_lose = function(self, err) return "#Target# is freed from a bear trap.", "-Bear Trap" end,
	activate = function(self, eff)
		local pin, cut = self:canBe("pin"), self:canBe("cut")
		if pin then
			eff.pinid = self:addTemporaryValue("never_move", 1)
			if self:canBe("slow") then eff.slowid = self:addTemporaryValue("global_speed_add", -eff.power) end
			if not cut then eff.dam = 0 end
		else
			self:removeEffect(eff.effect_id)
			if cut then
				self:setEffect(self.EFF_CUT, 5, {src=eff.src, power=eff.dam})
			end
			return
		end
		
		if cut and eff.src and eff.src:knowTalent(self.T_BLOODY_BUTCHER)then
			local t = eff.src:getTalentFromId(eff.src.T_BLOODY_BUTCHER)
			local resist = math.min(t.getResist(eff.src, t), math.max(0, self:combatGetResist(DamageType.PHYSICAL)))
			self:effectTemporaryValue(eff, "resists", {[DamageType.PHYSICAL] = -resist})
		end
	end,
	deactivate = function(self, eff)
		if eff.slowid then self:removeTemporaryValue("global_speed_add", eff.slowid) end
		if eff.pinid then self:removeTemporaryValue("never_move", eff.pinid) end
	end,
	on_timeout = function(self, eff)
		if eff.dam > 0 then DamageType:get(DamageType.PHYSICAL).projector(eff.src or self, self.x, self.y, DamageType.PHYSICAL, eff.dam) end
	end,
}

newEffect{
	name = "STONE_VINE",
	desc = "Stone Vine",
	long_desc = function(self, eff) return ("A living stone vine holds the target in place, inflicting %0.1f Nature%s damage per turn."):format(eff.dam, eff.arcanedam and (" and %0.1f Arcane"):format(eff.arcanedam) or "") end,
	type = "physical",
	subtype = { earth=true, pin=true },
	status = "detrimental",
	parameters = { dam=10 },
	on_gain = function(self, err) return "#Target# is seized by a stone vine.", "+Stone Vine" end,
	on_lose = function(self, err) return "#Target# is free from the stone vine.", "-Stone Vine" end,
	activate = function(self, eff)
		eff.last_x = eff.src.x
		eff.last_y = eff.src.y
		eff.tmpid = self:addTemporaryValue("never_move", 1)
		eff.particle = self:addParticles(Particles.new("stonevine", 1, {tx=eff.src.x-self.x, ty=eff.src.y-self.y}))
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("never_move", eff.tmpid)
		self:removeParticles(eff.particle)
	end,
	on_timeout = function(self, eff)
		local severed = false
		local src = eff.src or self
		if core.fov.distance(self.x, self.y, src.x, src.y) >= eff.free or src.dead or not game.level:hasEntity(src) then severed = true end
		if rng.percent(eff.free_chance) then severed = true end

		self:removeParticles(eff.particle)
		eff.particle = self:addParticles(Particles.new("stonevine", 1, {tx=eff.src.x-self.x, ty=eff.src.y-self.y}))

		if severed then
			return true
		else
			DamageType:get(DamageType.NATURE).projector(src, self.x, self.y, DamageType.NATURE, eff.dam)
			
			if eff.arcanedam and src:knowTalent(src.T_ELDRITCH_VINES) then
				src:incEquilibrium(-src:callTalent(src.T_ELDRITCH_VINES, "getEquilibrium"))
				src:incMana(src:callTalent(src.T_ELDRITCH_VINES, "getMana"))
				DamageType:get(DamageType.ARCANE).projector(src, self.x, self.y, DamageType.ARCANE, eff.arcanedam)
			end
		end
		eff.last_x = src.x
		eff.last_y = src.y
	end,
}

newEffect{
	name = "DWARVEN_RESILIENCE", image = "talents/dwarf_resilience.png",
	desc = "Dwarven Resilience",
	long_desc = function(self, eff)
		if eff.mid_ac then
			return ("The target's skin turns to stone, granting %d armour, %d physical save and %d spell save. Also applies %d armour to all non-physical damage."):format(eff.armor, eff.physical, eff.spell, eff.mid_ac)
		else
			return ("The target's skin turns to stone, granting %d armour, %d physical save and %d spell save."):format(eff.armor, eff.physical, eff.spell)
		end
	end,
	type = "physical",
	subtype = { earth=true },
	status = "beneficial",
	parameters = { armor=10, spell=10, physical=10 },
	on_gain = function(self, err) return "#Target#'s skin turns to stone." end,
	on_lose = function(self, err) return "#Target#'s skin returns to normal." end,
	activate = function(self, eff)
		eff.aid = self:addTemporaryValue("combat_armor", eff.armor)
		eff.hid = self:addTemporaryValue("combat_armor_hardiness", eff.armor_hardiness)
		eff.pid = self:addTemporaryValue("combat_physresist", eff.physical)
		eff.sid = self:addTemporaryValue("combat_spellresist", eff.spell)
		if self:knowTalent(self.T_STONE_FORTRESS) then
			local ac = self:combatArmor() * self:callTalent(self.T_STONE_FORTRESS, "getPercent")/ 100
			eff.mid_ac = ac
			eff.mid = self:addTemporaryValue("flat_damage_armor", {all=ac, [DamageType.PHYSICAL]=-ac})
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_armor", eff.aid)
		self:removeTemporaryValue("combat_armor_hardiness", eff.hid)
		self:removeTemporaryValue("combat_physresist", eff.pid)
		self:removeTemporaryValue("combat_spellresist", eff.sid)
		if eff.mid then self:removeTemporaryValue("flat_damage_armor", eff.mid) end
	end,
}

newEffect{
	name = "STONE_LINK_SOURCE", image = "talents/stone_link.png",
	desc = "Stone Link",
	long_desc = function(self, eff) return ("The target protects all those around it in radius %d by redirecting all damage against them to itself."):format(eff.rad) end,
	type = "physical",
	subtype = { earth=true, shield=true },
	status = "beneficial",
	parameters = { rad=3 },
	on_gain = function(self, err) return ("#Target# begins protecting %s friends with a stone shield."):format(string.his_her(self)), "+Stone Link" end,
	on_lose = function(self, err) return "#Target# is no longer protecting anyone.", "-Stone Link" end,
	activate = function(self, eff)
		if core.shader.active() then
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=eff.rad}, {type="shield", time_factor=4000, color={0.7, 0.4, 0.3}}))
		else
			eff.particle = self:addParticles(Particles.new("eldritch_stone", 1, {size_factor=eff.rad}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
	on_timeout = function(self, eff)
		self:project({type="ball", radius=eff.rad, selffire=false}, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target or self:reactionToward(target) < 0 then return end
			target:setEffect(target.EFF_STONE_LINK, 2, {src=self})
		end)
	end,
}

newEffect{
	name = "STONE_LINK", image = "talents/stone_link.png",
	desc = "Stone Link",
	long_desc = function(self, eff) return ("The target is protected by %s, redirecting all damage to it."):format(eff.src.name) end,
	type = "physical",
	subtype = { earth=true, shield=true },
	status = "beneficial",
	parameters = { },
	on_gain = function(self, err) return "#Target# is protected by a stone shield.", "+Stone Link" end,
	on_lose = function(self, err) return "#Target# is less protected.", "-Stone Link" end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "EXHAUSTION", image = "talents/slumber.png",
	desc = "Exhaustion",
	long_desc = function(self, eff) return ("The target has recently performed an extreme feat of agility and is exhausted.  The stamina cost of activated Mobility talents is increased by %d%%."):format(eff.fatigue) end,
	type = "other",
	subtype = {tactic = true},
	status = "detrimental", no_stop_enter_worlmap = true,
	parameters = {fatigue = 50 },
	charges = function(self, eff) return math.round(eff.fatigue) end,
	on_timeout = function(self, eff)
		local turns = eff.dur
		if turns <= 1 then self:removeEffect(eff.effect_id) return end
		eff.fatigue = eff.fatigue*(turns - 1)/turns
	end,
	on_merge = function(self, old_eff, new_eff)
		new_eff.fatigue = math.min(old_eff.fatigue + new_eff.fatigue)
		return new_eff
	end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "MOBILE_DEFENCE", image = "talents/light_armour_training.png",
	desc = "Mobile Defense",
	long_desc = function(self, eff)
		local stam = eff.stamina > 0 and ("stamina regeneration by %0.1f and "):format(eff.stamina) or ""
		return ("Increases %sdefense by %d."):format(stam, eff.power)
	end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = {stamina=1, power=10},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "stamina_regen", eff.stamina)
		self:effectTemporaryValue(eff, "combat_def", eff.power)
	end,
}

newEffect{
	name = "GHOULISH_LEAP", image = "talents/ghoulish_leap.png",
	desc = "Ghoulish Leap",
	long_desc = function(self, eff) return ("The target's global speed is increased by %d%%."):format(eff.speed * 100) end,
	type = "physical",
	subtype = { speed=true },
	status = "beneficial",
	parameters = { speed=0.1 },
	on_gain = function(self, err) return "#Target# speeds up.", "+Fast" end,
	on_lose = function(self, err) return "#Target# slows down.", "-Fast" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", eff.speed)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
	end,
}

newEffect{
	name = "FEINT", image = "talents/feint.png",
	desc = "Feint",
	long_desc = function(self, eff) return ("The target gains 1 extra parry opportunity each turn, and its chance to fail each parry is reduced by %d%%."):format(eff.parry_efficiency*100) end,
	type = "physical",
	subtype = { tactical=true },
	status = "beneficial",
	parameters = { power=0.1, parry_efficiency=0.1 },
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "MANA_CLASH", image = "talents/mana_clash.png",
	desc = "Mana Clash",
	long_desc = function(self, eff) return ("All damage you do also trigget a manaburn for %d%% of the damage done."):format(eff.power * 100) end,
	type = "physical",
	subtype = { antimagic=true },
	status = "beneficial",
	parameters = { power=0.15 },
	on_gain = function(self, err) return "#Target# exudes antimagic forces.", true end,
	on_lose = function(self, err) return "#Target# is no longer toxic to arcane users.", true end,
	callbackOnDealDamage = function(self, eff, val, target, dead, death_note)
		if self._manaclashing then return end
		if not target.x or dead then return end
		self._manaclashing = true
		DamageType:get(DamageType.MANABURN).projector(self, target.x, target.y, DamageType.MANABURN, val * eff.power)
		self._manaclashing = nil
	end,
}

newEffect{
	name = "BULLSEYE", image = "talents/bullseye.png",
	desc = "Bullseye",
	long_desc = function(self, eff) return ("Increases attack speed by %d%%."):format(eff.power*100) end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = { power=0.1 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_physspeed", eff.power)
	end,
}

newEffect{
	name = "TRUESHOT", image = "talents/trueshot.png",
	desc = "Trueshot",
	long_desc = function(self, eff) return ("Increases attack speed by %d%%, grants infinite ammo, and causes all marking shots to have a 100%% increased chance to mark."):format(eff.power*100) end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = { power=0.1 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_physspeed", eff.power)
		self:effectTemporaryValue(eff, "infinite_ammo", 1)
		local h1x, h1y = self:attachementSpot("head", true)
		h1x, h1y = h1x or 0, h1y or 0
		self:effectParticles(eff, {type="circle", args={oversize=0.7, x=h1x, y=h1y-0.2, base_rot=0, a=220, shader=true, appear=12, img="true_shot_aura", speed=0, radius=0}})
	end,
}

newEffect{
	name = "ESCAPE", image = "talents/escape.png",
	desc = "Escape",
	long_desc = function(self, eff) return ("Focusing on defense and mobility, reducing all damage taken by %d%%, stamina regeneration by %0.1f and movement speed by %d%%. Melee and ranged attacks will break this effect."):format(eff.power, eff.stamina, eff.speed) end,
	type = "physical",
	subtype = { tactic=true, speed=true },
	status = "beneficial",
	parameters = {power=1000},
	on_gain = function(self, err) return "#Target# enters an evasive stance!.", "+Escape!" end,
	on_lose = function(self, err) return "#Target# slows down.", "-Escape" end,
	get_fractional_percent = function(self, eff)
		local d = game.turn - eff.start_turn
		return util.bound(360 - d / eff.possible_end_turns * 360, 0, 360)
	end,
	lists = 'break_with_step_up',
	activate = function(self, eff)
		eff.start_turn = game.turn
		eff.possible_end_turns = 10 * (eff.dur+1)
		eff.tmpid = self:addTemporaryValue("wild_speed", 1)
		eff.moveid = self:addTemporaryValue("movement_speed", eff.speed/100)
-- should change priorities rather than forbid all talents
		if self.ai_state then eff.aiid = self:addTemporaryValue("ai_state", {no_talents=1}) end -- Make AI not use talents while using it
		eff.stun = self:addTemporaryValue("stun_immune", 1)
		eff.daze = self:addTemporaryValue("daze_immune", 1)
		eff.pin = self:addTemporaryValue("pin_immune", 1)
		eff.pid = self:addTemporaryValue("resists", {all=eff.power})
		eff.staid = self:addTemporaryValue("stamina_regen", eff.stamina)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("wild_speed", eff.tmpid)
		if eff.aiid then self:removeTemporaryValue("ai_state", eff.aiid) end
		self:removeTemporaryValue("movement_speed", eff.moveid)
		self:removeTemporaryValue("stun_immune", eff.stun)
		self:removeTemporaryValue("daze_immune", eff.daze)
		self:removeTemporaryValue("pin_immune", eff.pin)
		self:removeTemporaryValue("resists", eff.pid)
		self:removeTemporaryValue("stamina_regen", eff.staid)
	end,
}

newEffect{
	name = "SENTINEL", image = "talents/sentinel.png",
	desc = "Sentinel",
	long_desc = function(self, eff) return ("Target is watched, causing the next talent used to fail and trigger a counterattack."):format() end,
	type = "physical",
	subtype = { tactic=true },
	status = "detrimental",
	on_gain = function(self, err) return nil, "+Sentinel!" end,
	on_lose = function(self, err) return nil, "-Sentinel" end,
	do_proc = function(self, eff)
		eff.src:callTalent(eff.src.T_SENTINEL, "doShoot", eff)
	end,
	activate = function(self, eff)
		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1.5, y=-0.3, img="healcelestial"}, {type="healing", time_factor=4000, noup=2.0, beamColor1={229/255, 0/255, 0/255, 1}, beamColor2={299/255, 0/255, 0/255, 1}, circleColor={0,0,0,0}, beamsCount=5}))
			eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1.5, y=-0.3, img="healcelestial"}, {type="healing", time_factor=4000, noup=1.0, beamColor1={229/255, 0/255, 0/255, 1}, beamColor2={229/255, 0/255, 0/255, 1}, circleColor={0.8,0,0,0.8}, beamsCount=5}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
	end,
}

newEffect{
	name = "RAPID_MOVEMENT", image = "talents/rapid_shot.png",
	desc = "Rapid Movement",
	long_desc = function(self, eff) return ("Increases movement speed by %d%%."):format(eff.power*100) end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = {power=10},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "movement_speed", eff.power)
	end,
}

newEffect{
	name = "STICKY_PITCH", image = "talents/sticky_smoke.png",
	desc = "Sticky Pitch",
	long_desc = function(self, eff) return ("The target's global speed is reduced by %d%% and fire resistance by %d%%."):format(eff.slow, eff.resist) end,
	type = "physical",
	subtype = { slow=true },
	status = "detrimental",
	parameters = { slow=0.1, resist=10 },
	on_gain = function(self, err) return "#Target# is covered in sticky, flammable pitch.", "+Pitch" end,
	on_lose = function(self, err) return "#Target# is free from the pitch.", "-Pitch" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", -eff.slow)
		eff.resid = self:addTemporaryValue("resists", {[DamageType.FIRE] = -eff.resist})
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={toback=false, size_factor=2, img="sticky_pitch_debuff_tentacles"}, shader={type="tentacles", backgroundLayersCount=-4, appearTime=0.3, time_factor=500, noup=0.0}})
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
		self:removeTemporaryValue("resists", eff.resid)
	end,
}


newEffect{
	name = "PUNCTURED_ARMOUR", image = "talents/piercing_ammunition.png",
	desc = "Punctured Armour",
	long_desc = function(self, eff) return ("Armour has been punctured, increasing all damage taken by %d%%."):format(eff.power) end,
	type = "physical",
	subtype = { sunder=true },
	status = "detrimental",
	parameters = { power=20, },
	on_gain = function(self, err) return "#Target#'s armour is punctured!", "+Punctured Armour!" end,
	on_lose = function(self, err) return "#Target#'s armour is more intact.", "-Punctured Armour" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {all=-eff.power})
		self:effectParticles(eff, {type="circle", args={oversize=1, a=220, base_rot=180, shader=true, appear=12, img="pierced_armour_debuff_aura", speed=0, radius=0}})
	end,
}

newEffect{
	name = "LEECHING_POISON", image = "talents/leeching_poison.png",
	desc = "Leeching Poison",
	long_desc = function(self, eff) return ("The target is poisoned, doing %0.2f nature damage per turn and restoring life to the attacker equal to the damage dealt."):format(eff.power) end,
	type = "physical",
	subtype = { poison=true, nature=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10, heal=5},
	on_gain = function(self, err) return "#Target# is poisoned!", "+Leeching Poison" end,
	on_lose = function(self, err) return "#Target# is no longer poisoned.", "-Leeching Poison" end,
	-- Damage each turn
	on_timeout = function(self, eff)
		if self:attr("purify_poison") then 
			self:heal(eff.power, eff)
		else 
			local dam = DamageType:get(DamageType.NATURE).projector(eff.src, self.x, self.y, DamageType.NATURE, eff.power)
			local src = eff.src.resolveSource and eff.src:resolveSource()
			if src then src:heal(dam, self) end
		end
	end,
}

newEffect{
	name = "MAIM", image = "effects/deep_wound.png",
	desc = "Maim",
	long_desc = function(self, eff) return ("The target is maimed, doing %0.2f physical damage per turn. All damage it does is reduced by %d%%."):format(eff.power, eff.reduce) end,
	type = "physical",
	subtype = { cut=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10, reduce=5},
	on_gain = function(self, err) return "#Target# is maimed!", "+Maim" end,
	on_lose = function(self, err) return "#Target# is no longer maimed.", "-Maim" end,
	-- Damage each turn
	on_timeout = function(self, eff)
		if self:canBe("cut") then DamageType:get(DamageType.PHYSICAL).projector(eff.src, self.x, self.y, DamageType.PHYSICAL, eff.power) end
	end,
	-- There are situations this matters, such as copyEffect
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = math.max(old_eff.dur, new_eff.dur)
		return old_eff
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("numbed", eff.reduce)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("numbed", eff.tmpid)
	end,
}

newEffect{
	name = "SNIPE", image = "talents/snipe.png",
	desc = "Snipe",
	long_desc = function(self, eff) return ("The target is preparing a deadly sniper shot."):format() end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = { power=50 },
	on_gain = function(self, err) return "#Target# takes aim...", "+Snipe" end,
	on_lose = function(self, err) return "#Target# is no longer aiming.", "-Snipe" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "negative_status_effect_immune", 1)
		self:effectTemporaryValue(eff, "incoming_reduce", eff.power)

		if self.hotkey and self.isHotkeyBound then
			local pos = self:isHotkeyBound("talent", self.T_SNIPE)
			if pos then
				self.hotkey[pos] = {"talent", self.T_SNIPE_FIRE}
			end
		end

		local ohk = self.hotkey
		self.hotkey = nil -- Prevent assigning hotkey, we just did
		self:learnTalent(self.T_SNIPE_FIRE, true, 1, {no_unlearn=true})
		self.hotkey = ohk

		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={size_factor=1.5, img="snipe_tentacles2"}, shader={type="tentacles", appearTime=0.6, time_factor=1600, noup=0.0}})
		end
	end,
	deactivate = function(self, eff)
		if self.hotkey and self.isHotkeyBound then
			local pos = self:isHotkeyBound("talent", self.T_SNIPE_FIRE)
			if pos then
				self.hotkey[pos] = {"talent", self.T_SNIPE}
			end
		end

		self:unlearnTalent(self.T_SNIPE_FIRE, 1, nil, {no_unlearn=true})
	end,
}

newEffect{
	name = "CONCEALMENT", image = "talents/concealment.png",
	desc = "Concealment",
	long_desc = function(self, eff) return ("The target is concealed, increasing sight and attack range by %d and chance to avoid damage by %d%%."):format(eff.sight, eff.power*eff.charges) end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	charges = function(self, eff) return eff.charges end,
	parameters = { power=5, duration=1, sight=1, max_power=15, charges=3 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "cancel_damage_chance", eff.max_power)
		self:effectTemporaryValue(eff, "sight", eff.sight)
		self:effectTemporaryValue(eff, "infravision", eff.sight)
		self:effectTemporaryValue(eff, "heightened_senses", eff.sight)
		self:effectTemporaryValue(eff, "archery_bonus_range", eff.sight)
		self:doFOV()
	end,
	deactivate = function(self, eff)
		self:doFOV()
	end,
	on_timeout = function(self, eff)
		if not self:isTalentActive(self.T_CONCEALMENT) then 
			eff.charges = eff.charges -1
			eff.max_power = eff.power*eff.charges
			if eff.charges == 0 then self:removeEffect(self.EFF_CONCEALMENT) end
		end
	end,
}

newEffect{
	name = "SHADOW_SMOKE", image = "talents/shadow_shot.png",
	desc = "Shadow Smoke",
	long_desc = function(self, eff) return ("The target is wrapped in disorientating smoke, reducing vision range by %d."):format(eff.sight) end,
	type = "physical",
	subtype = { blind=true },
	status = "detrimental",
	parameters = { sight=5 },
	on_gain = function(self, err) return "#Target# is surrounded by a thick smoke.", "+Shadow Smoke" end,
	on_lose = function(self, err) return "The smoke around #target# dissipate.", "-Shadow Smoke" end,
	charges = function(self, eff) return -eff.sight end,
	activate = function(self, eff)
		if self:canBe("blind") then
			if self.sight - eff.sight < 1 then eff.sight = self.sight - 1 end
			eff.tmpid = self:addTemporaryValue("sight", -eff.sight)
			self:doFOV()
		end
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={size_factor=1.5, img="shadow_shot_debuff_tentacles"}, shader={type="tentacles", wobblingType=0, appearTime=0.8, time_factor=2000, noup=0.0}})
		end
	end,
	deactivate = function(self, eff)
		if eff.tmpid then 
			self:removeTemporaryValue("sight", eff.tmpid)
			self:doFOV()
		end
	end,
}

newEffect{
	name = "SHADOWSTRIKE", image = "talents/shadowstrike.png",
	desc = "Shadowstrike",
	long_desc = function(self, eff) return ("The target's critical strike damage bonus is increased by %d%%."):format(eff.power) end,
	type = "physical",
	subtype = { darkness=true },
	status = "beneficial",
	parameters = { power=1 },
	on_gain = function(self, err) return nil, true end,
	on_lose = function(self, err) return nil, true end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_critical_power", eff.power)
	end,
}

-- Premptive Chromatic resistance
newEffect{
	name = "CHROMATIC_RESONANCE", image = "shockbolt/object/artifact/ureslaks_molted_scales.png",
	desc = "Chromatic Resonance",
	long_desc = function(self, eff)
		local dt_descs = table.concatNice(eff.type_descs, ", ", ", or ")
		return ("Preemptively reacts to %s damage, increasing the appropriate resistance by %d for 5 turns."):format(dt_descs, eff.power)
	end,
	type = "physical",
	subtype = { nature=true, resist=true },
	status = "beneficial",
	parameters = {power=15, resist_types={"FIRE", "COLD", "LIGHTNING", "NATURE", "DARKNESS"} },
	on_gain = function(self, err) return "#Target##OLIVE_DRAB# shimmers in multiple hues.", true end,
	on_lose = function(self, err) return "#Target#'s#OLIVE_DRAB# multi-hued shimmer fades.", true end,
	callbackOnTakeDamageBeforeResists = function(self, eff, src, x, y, type, dam, state)
		if dam > 0 and src ~= self and not self:hasEffect(self.EFF_CHROMATIC_RESISTANCE) then
			for i, r_type in ipairs(eff.resist_types) do
				if type == r_type then
					self:setEffect(self.EFF_CHROMATIC_RESISTANCE, 5, {type=type, power=eff.power})
					break
				end
			end
		end
		return {dam=dam}
	end,
	activate = function(self, eff)
		eff.type_descs = {}
		for i = #eff.resist_types, 1, -1 do
			local dt = DamageType[eff.resist_types[i]] and DamageType:get(eff.resist_types[i])
			if dt then
				table.insert(eff.type_descs, (dt.text_color or "#aaaaaa#")..dt.name:capitalize().."#LAST#")
			else table.remove(eff.resist_types, i)
			end
		end
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={size_factor=1.5, img="ureslak_tentacles"}, shader={type="tentacles", wobblingType=0, appearTime=0.8, time_factor=2000, noup=0.0}})
		end
	end,
}

newEffect{
	name = "CHROMATIC_RESISTANCE", image = "shockbolt/object/artifact/ureslaks_molted_scales.png",
	desc = "Chromatic Resistance",
	long_desc = function(self, eff)
		local dt = DamageType[eff.type] and DamageType:get(eff.type)
		local type_desc = dt and ((dt.text_color or "#aaaaaa#")..dt.name:capitalize().."#LAST# ") or ""
		return ("%sresistance increased by %d%%."):format(type_desc, eff.power)
	end,
	type = "physical",
	subtype = { nature=true, resist=true },
	charges = function(self, eff) return eff.dtype.name:capitalize() end,
	status = "beneficial",
	parameters = { power=15 },
	on_gain = function(self, eff)
		local dt = DamageType[eff.type] and DamageType:get(eff.type)
		if dt then
			eff.dtype = dt
			return "#Target##OLIVE_DRAB# resonates with "..(dt.text_color or "#aaaaaa#")..dt.name:capitalize().."#LAST# damage!", true
		else eff.type = nil
		end
	end,
	on_lose = function(self, eff)
		if eff.dtype then
			return "#Target##OLIVE_DRAB# no longer resonates with "..(eff.dtype.text_color or "#aaaaaa#")..eff.dtype.name:capitalize().."#LAST# damage.", true
		end
	end,
	activate = function(self, eff)
		if eff.type then
			self:effectTemporaryValue(eff, "resists", {[eff.type] = eff.power})
		else
			self:removeEffect(eff.effect_id)
		end
	end,
}

newEffect{
	name = "SWIFT_SHOT", image = "talents/skirmisher_swift_shot.png",
	desc = "Swift Shot",
	long_desc = function(self, eff) return ("Increases attack speed by %d%%."):format(eff.speed * 100) end,
	type = "physical",
	subtype = { tactic=true },
	status = "beneficial",
	parameters = {speed=0.1},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_physspeed", eff.speed)
	end,
}

newEffect{ name = "CROOKED", image = "shockbolt/object/artifact/weapon_crooked_club.png",
	desc = "Crooked",
	long_desc = function(self, eff) return ("The target becomes more and more primitive, reducing accuracy and powers by %d"):format(eff.power*eff.stacks) end,
	type = "physical",
	subtype = { }, 
	status = "detrimental",
	parameters = { power=10, stacks=1, max_stacks=5 },
	
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		old_eff.stacks = math.min(old_eff.stacks + new_eff.stacks, new_eff.max_stacks)
		self:removeTemporaryValue("combat_atk", old_eff.acc)
		self:removeTemporaryValue("combat_mindpower", old_eff.mental)
		self:removeTemporaryValue("combat_spellpower", old_eff.spell)
		self:removeTemporaryValue("combat_dam", old_eff.physical)	
		old_eff.acc = self:addTemporaryValue("combat_atk", -old_eff.power*old_eff.stacks)
		old_eff.mental = self:addTemporaryValue("combat_mindpower", -old_eff.power*old_eff.stacks)
		old_eff.spell = self:addTemporaryValue("combat_spellpower", -old_eff.power*old_eff.stacks)
		old_eff.physical = self:addTemporaryValue("combat_dam", -old_eff.power*old_eff.stacks)	
		return old_eff
		
	end,
	
	activate = function(self, eff)		
		eff.acc = self:addTemporaryValue("combat_atk", -eff.power*eff.stacks )
		eff.mental = self:addTemporaryValue("combat_mindpower", -eff.power*eff.stacks)
		eff.spell = self:addTemporaryValue("combat_spellpower", -eff.power*eff.stacks)
		eff.physical = self:addTemporaryValue("combat_dam", -eff.power*eff.stacks)
	end,
	
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_atk", eff.acc)
		self:removeTemporaryValue("combat_mindpower", eff.mental)
		self:removeTemporaryValue("combat_spellpower", eff.spell)
		self:removeTemporaryValue("combat_dam", eff.physical)
	end,
}

newEffect{
	name = "ELDORAL", image = "talents/uncanny_reload.png",
	desc = "Eldoral",
	long_desc = function(self, eff) return ("Firing slings does not consume shots."):format() end,
	type = "physical",
	subtype = { },
	status = "beneficial",
	parameters = { speed = 20, fatigue = 100},
	on_gain = function(self, err) return "#Target# is focused on firing.", "+Eldoral" end,
	on_lose = function(self, err) return "#Target# is less focused.", "-Eldoral" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "infinite_ammo", 1)
		self:effectTemporaryValue(eff, "combat_physspeed", eff.speed/100)
		self:effectTemporaryValue(eff, "fatigue", -eff.fatigue)
	end,
}

newEffect{
	name = "SILENT_STEALTH", image = "talents/stealth.png",
	desc = "Stealthed",
	long_desc = function(self, eff) return ("Gain %d stealth power"):format(eff.power) end,
	type = "physical",
	subtype = { },
	status = "beneficial",
	parameters = { power = 30 },
	on_gain = function(self, err) return "#Target# is more stealthy.", "+Silent stealth" end,
	on_lose = function(self, err) return "#Target# is visible again.", "-Silent stealth" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "stealth", eff.power)
	end,
}

newEffect{
	name = "FORGONE_VISION", image = "effects/blinded.png",
	desc = "Blinded",
	long_desc = function(self, eff) return "The target is blinded, unable to see anything." end,
	type = "other",
	subtype = {},
	status = "detrimental",
	parameters = {power = 2},
	on_lose = function(self, err) return "#Target# recovers sight.", "-Blind" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("blind", 1)
		eff.blind = self:addTemporaryValue("blind_immune", eff.power) --Lets the player control blinds for the duration--
		if game.level then
			self:resetCanSeeCache()
			if self.player then for uid, e in pairs(game.level.entities) do if e.x then game.level.map:updateMap(e.x, e.y) end end game.level.map.changed = true end
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("blind", eff.tmpid)
		self:removeTemporaryValue("blind_immune", eff.blind)
		if game.level then
			self:resetCanSeeCache()
			if self.player then for uid, e in pairs(game.level.entities) do if e.x then game.level.map:updateMap(e.x, e.y) end end game.level.map.changed = true end
		end
	end,
	callbackOnTakeoff = function(self, eff, o)
		if o.name and o.name == "Yaldan Baoth" then
			self:removeEffect(self.EFF_FORGONE_VISION)
		end
	end,
}


newEffect{
	name = "GIFT_WOODS", image = "talents/thaloren_wrath.png",
	desc = "Gift of the Woods",
	long_desc = function(self, eff) return ("Increases the effectiveness of all healing the target receives by %d%%."):format(eff.power * 100) end,
	type = "physical",
	subtype = { nature=true },
	status = "beneficial",
	parameters = { power = 0.1 },
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("healing_factor", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("healing_factor", eff.tmpid)
	end,
}
