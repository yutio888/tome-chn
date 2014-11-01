-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2014 Nicolas Casalini
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

local function combatTalentDamage(self, t, min, max)
	return self:combatTalentSpellDamage(t, min, max, (self.level + self:getWil()) * 1.2)
end

newTalent{
	name = "Unnatural Body",
	type = {"cursed/cursed-form", 1},
	mode = "passive",
	require = cursed_wil_req1,
	points = 5,
	no_unlearn_last = true,
	getHealPerKill = function(self, t)
		return combatTalentDamage(self, t, 15, 50)
	end,
	getMaxUnnaturalBodyHeal = function(self, t) -- Add up to 50% max life to pool
		return t.getHealPerKill(self, t) * 2 + self:combatTalentLimit(t, .5, 0.01, 0.03) * self.max_life
	end,
	getRegenRate = function(self, t) return 3 + combatTalentDamage(self, t, 15, 25) end,
	updateHealingFactor = function(self, t)
		local change = -0.5 + math.min(100, self:getHate()) * .005
		self.healing_factor = (self.healing_factor or 1) - (self.unnatural_body_healing_factor or 0) + change
		self.unnatural_body_healing_factor = change
	end,
	do_regenLife  = function(self, t) -- called by _M:actBase in mod.class.Actor.lua
		-- update healing factor
		t.updateHealingFactor(self, t)

		-- heal
		local maxHeal = self.unnatural_body_heal or 0
		if maxHeal > 0 then
			local heal = math.min(t.getRegenRate(self, t), maxHeal)
			local temp = self.healing_factor
			self.healing_factor = 1
			self:heal(heal, t)
			self.healing_factor = temp

			self.unnatural_body_heal = math.max(0, (self.unnatural_body_heal or 0) - heal)
		end
	end,
	on_kill = function(self, t, target) -- called by _M:die in mod.class.Actor.lua
		if target and target.max_life then
			local heal = math.min(t.getHealPerKill(self, t), target.max_life)
			if heal > 0 then
				self.unnatural_body_heal = math.min(self.life, (self.unnatural_body_heal or 0) + heal)
				self.unnatural_body_heal = math.min(self.unnatural_body_heal, t.getMaxUnnaturalBodyHeal(self, t))
			end
		end
	end,
	info = function(self, t)
		local healPerKill = t.getHealPerKill(self, t)
		local maxUnnaturalBodyHeal = t.getMaxUnnaturalBodyHeal(self, t)
		local regenRate = t.getRegenRate(self, t)

		return ([[你 的 力 量 来 源 于 心 底 的 憎 恨， 这 使 得 大 部 分 治 疗 效 果 减 至 原 来 的 50%%（ 0 仇 恨） ～ 100%%（ 100+ 仇 恨）。 
		 另 外， 每 次 击 杀 敌 人 你 将 存 储 生 命 能 量 来 治 疗 自 己， 回 复 %d 点 生 命（ 受 敌 人 最 大 生 命 值 限 制， 任 何 时 候 不 能 超 过 %d 点 ）。 这 个 方 式 带 来 的 每 回 合 回 复 量 不 能 超 过 %0.1f 点 生 命， 也 不 受 仇 恨 等 级 或 治 疗 加 成 等 因 素 影 响。 
		 受 意 志 影 响， 通 过 杀 死 敌 人 获 得 的 治 疗 量 有 额 外 加 成。]]):format(healPerKill, maxUnnaturalBodyHeal, regenRate)
	end,
}

newTalent{
	name = "Relentless",
	type = {"cursed/cursed-form", 2},
	mode = "passive",
	require = cursed_wil_req2,
	points = 5,
	getImmune = function(self, t) return self:combatTalentLimit(t, 1, 0.15, 0.5) end, -- Limit < 100%
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "fear_immune", t.getImmune(self, t))
		self:talentTemporaryValue(p, "confusion_immune", t.getImmune(self, t))
		self:talentTemporaryValue(p, "knockback_immune", t.getImmune(self, t))
		self:talentTemporaryValue(p, "stun_immune", t.getImmune(self, t))
	end,
	info = function(self, t)
		return ([[对 鲜 血 的 渴 望 控 制 了 你 的 行 为。 增 加 +%d%% 混 乱、 恐 惧、 击 退 和 震 慑 免 疫。]]):format(t.getImmune(self, t)*100)
	end,
}

newTalent{
	name = "Seethe",
	type = {"cursed/cursed-form", 3},
	mode = "passive",
	require = cursed_wil_req3,
	points = 5,
	getIncDamageChange = function(self, t, increase)
		return self:combatTalentLimit(t, 60, 2, 2*2.24) * increase --I5 Limit < 60%
	end,
	info = function(self, t)
		local incDamageChangeMax = t.getIncDamageChange(self, t, 5)
		return ([[你 学 会 控 制 憎 恨， 并 用 你 的 痛 苦 燃 烧 心 底 的 愤 怒。 
		 每 当 你 受 到 伤 害 时， 你 的 伤 害 会 在 5 回 合 后 增 加 至 最 大 值 +%d%% 。 
		 每 个 你 不 承 受 伤 害 的 回 合 会 降 低 该 增 益 效 果。]]):format(incDamageChangeMax)
	end
}

newTalent{
	name = "Grim Resolve",
	type = {"cursed/cursed-form", 4},
	require = cursed_wil_req4,
	mode = "passive",
	points = 5,
	getStatChange = function(self, t, increase) return math.floor(self:combatTalentScale(t, 1, 2.24) * increase) end,
	getNeutralizeChance = function(self, t) return self:combatTalentLimit(t, 60, 10, 23.4) end, -- Limit < 60%
	info = function(self, t)
		local statChangeMax = t.getStatChange(self, t, 5)
		local neutralizeChance = t.getNeutralizeChance(self, t)
		return ([[你 勇 于 面 对 其 他 人 带 给 你 的 痛 苦。 每 回 合 当 你 承 受 伤 害 时， 你 将 会 增 加 你 的 力 量 和 意 志， 直 至 在 5 回 合 后 增 加 至 最 大 值 +%d 。 
		 每 个 你 不 承 受 伤 害 的 回 合 会 降 低 该 增 益 效 果。 
		 当 此 效 果 激 活 时， 每 回 合 你 有 %d%% 的 概 率 抵 抗 毒 素 和 疾 病 效 果。]]):format(statChangeMax, neutralizeChance)
	end,
}


