-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011, 2012, 2013 Nicolas Casalini
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

local function getStrikingStyle(self, dam)
	local dam = 0
	if self:isTalentActive(self.T_STRIKING_STANCE) then
		local t = self:getTalentFromId(self.T_STRIKING_STANCE)
		dam = t.getDamage(self, t)
	end
	return dam / 100
end

newTalent{
	name = "Tactical Expert",
	type = {"cunning/tactical", 1},
	require = cuns_req1,
	mode = "passive",
	points = 5,
	getDefense = function(self, t) return self:combatStatScale("cun", 5, 15, 0.75) end,
	getMaximum = function(self, t) return t.getDefense(self, t) * self:combatTalentLimit(t, 8, 1, 5) end, -- Limit to 8x defense bonus
	do_tact_update = function (self, t)
		local nb_foes = 0
		local act
		for i = 1, #self.fov.actors_dist do
			act = self.fov.actors_dist[i]
			-- Possible bug with this formula
			if act and game.level:hasEntity(act) and self:reactionToward(act) < 0 and self:canSee(act) and act["__sqdist"] <= 2 then nb_foes = nb_foes + 1 end
		end

		local defense = nb_foes * t.getDefense(self, t)

		if defense <= t.getMaximum(self, t) then
			defense = defense
		else
			defense = t.getMaximum(self, t)
		end

		return defense
	end,
	info = function(self, t)
		local defense = t.getDefense(self, t)
		local maximum = t.getMaximum(self, t)
		return ([[每 个 可 见 的 相 邻 敌 人 可 以 使 你 的 闪 避 增 加 %d 点， 最 大 增 加 +%d 点 闪 避。 
		 受 灵 巧 影 响， 闪 避 增 益 和 增 益 最 大 值 按 比 例 加 成。]]):format(defense, maximum)
	end,
}

-- Limit counter attacks/turn for balance using a buff (warns attacking players of the talent)	
-- Talent effect is implemented in _M:attackTargetWith function in mod\class\interface\Combat.lua (includes adjacency check)
-- The Effect EFF_COUNTER_ATTACKING is defined in mod.data.timed_effects.physical.lua
-- and is refreshed each turn in mod.class.Actor.lua _M:actBase
newTalent{
	name = "Counter Attack",
	type = {"cunning/tactical", 2},
	require = cuns_req2,
	mode = "passive",
	points = 5,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.5, 0.9) + getStrikingStyle(self, dam) end,
	counterchance = function(self, t) return self:combatLimit(self:getTalentLevel(t) * (5 + self:getCun(5, true)), 100, 0, 0, 50, 50) end, --Limit < 100%
	getCounterAttacks = function(self, t) return self:combatStatScale("cun", 1, 2.24) end,
	checkCounterAttack = function(self, t)
		local ef = self:hasEffect(self.EFF_COUNTER_ATTACKING)
		if not ef then return end
		local damage = rng.percent(self.tempeffect_def.EFF_COUNTER_ATTACKING.counterchance(self, ef)) and t.getDamage(self,t)
		ef.counterattacks = ef.counterattacks - 1
		if ef.counterattacks <=0 then self:removeEffect(self.EFF_COUNTER_ATTACKING) end
		return damage
	end,
	on_unlearn = function(self, t)
		self:removeEffect(self.EFF_COUNTER_ATTACKING)
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[当 你 闪 避 一 次 紧 靠 着 你 的 对 手 的 近 战 攻 击 时 你 有 %d%% 的 概 率 对 对 方 造 成 一 次 %d%% 伤 害 的 反 击 , 每 回 合 最 多 触 发 %0.1f 次。 
		 徒 手 格 斗 时 会 被 视 作 是 攻 击 姿 态（ 如 果 有 的 话） 的 一 种 结 果， 且 会 产 生 额 外 伤 害 加 成。 
		 装 备 武 器 使 用 此 技 能 时 不 产 生 额 外 伤 害。 
		 受 灵 巧 影 响， 反 击 概 率 和 反 击 数 目 有 额 外 加 成。]]):format(t.counterchance(self,t), damage,  t.getCounterAttacks(self, t))
	end,
}

newTalent{
	name = "Set Up",
	type = {"cunning/tactical", 3},
	require = cuns_req3,
	points = 5,
	random_ego = "utility",
	cooldown = 12,
	stamina = 12,
	tactical = { DISABLE = 1, DEFEND = 2 },
	getPower = function(self, t) return 5 + self:combatTalentStatDamage(t, "cun", 1, 25) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	getDefense = function(self, t) return 5 + self:combatTalentStatDamage(t, "cun", 1, 50) end,
	action = function(self, t)
		self:setEffect(self.EFF_DEFENSIVE_MANEUVER, t.getDuration(self, t), {power=t.getDefense(self, t)})
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local power = t.getPower(self, t)
		local defense = t.getDefense(self, t)
		return ([[增 加 %d 点 闪 避， 持 续 %d 回 合。 当 你 闪 避 1 次 近 战 攻 击 时， 你 可 以 架 起 目 标， 有 %d%% 概 率 使 你 对 目 标 进 行 1 次 暴 击 并 减 少 它 们 %d 点 豁 免。 
		 受 灵 巧 影 响， 效 果 按 比 例 加 成。]])
		:format(defense, duration, power, power)
	end,
}

newTalent{
	name = "Exploit Weakness",
	type = {"cunning/tactical", 4},
	require = cuns_req4,
	mode = "sustained",
	points = 5,
	cooldown = 30,
	sustain_stamina = 30,
	tactical = { BUFF = 2 },
	getReductionMax = function(self, t) return 5 * math.floor(self:combatTalentLimit(t, 20, 1.4, 7.1)) end, -- Limit to 95%
	do_weakness = function(self, t, target)
		target:setEffect(target.EFF_WEAKENED_DEFENSES, 3, {inc = - 5, max = - t.getReductionMax(self, t)})
	end,
	activate = function(self, t)
		return {
			dam = self:addTemporaryValue("inc_damage", {[DamageType.PHYSICAL]=-10}),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("inc_damage", p.dam)
		return true
	end,
	info = function(self, t)
		local reduction = t.getReductionMax(self, t)
		return ([[感 知 对 手 的 物 理 弱 点， 代 价 是 你 减 少 10%% 物 理 伤 害。 每 次 你 击 中 对 手 时， 你 会 减 少 它 们 5%% 物 理 伤 害 抵 抗， 最 多 减 少 %d%% 。]]):format(reduction)
	end,
}
