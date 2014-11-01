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




newTalent{
	name = "Aura Discipline",
	type = {"psionic/mental-discipline", 1},
	require = psi_wil_req1,
	points = 5,
	mode = "passive",
	cooldownred = function(self,t) return math.max(0,math.floor(self:combatTalentLimit(t, 8, 1, 5))) end, -- Limit to <8 turns reduction
	getMastery = function(self, t) return self:combatTalentScale(t, 2.5, 10, 0.75) end,
	info = function(self, t)
		local cooldown = t.cooldownred(self,t)
		local mast = t.getMastery(self, t)
		return ([[你 增 加 了 在 超 能 力 值 运 用 方 面 的 知 识。 
		 所 有 光 环 的 冷 却 时 间 减 少 %d 回 合。 
		 光 环 消 耗 超 能 力 值 变 的 更 慢（ 消 耗 每 点 超 能 力 值 所 需 伤 害 值 +%0.2f ）。]]):format(cooldown, mast)
	end,
}

newTalent{
	name = "Shield Discipline",
	type = {"psionic/mental-discipline", 2},
	require = psi_wil_req2,
	points = 5,
	mode = "passive",
	mastery = function(self,t) return self:combatTalentLimit(t, 20, 3, 10) end, -- Adjustment to damage absorption, Limit to 20
	cooldownred = function(self,t) return math.floor(self:combatTalentLimit(t, 16, 4, 10)) end,  -- Limit to <16 turns reduction
	absorbLimit = function(self,t) return self:combatTalentScale(t, 0.5, 2) end, -- Limit of bonus psi on shield hit per turn
	info = function(self, t)
		local cooldown = t.cooldownred(self,t)
		local mast = t.mastery(self,t)
		return ([[你 增 加 了 在 超 能 力 值 吸 收 方 面 的 知 识。 所 有 护 盾 的 冷 却 时 间 减 少 %d 回 合。 护 盾 额 外 增 加 超 能 力 值 所 需 伤 害 值 减 少 %0.1f, 每 个 超 能 力 盾 每 回 合 能 提 供 的 最 大 超 能 力 值 增 加 %0.1f.]]):
		format(cooldown, mast, t.absorbLimit(self, t))
	end,
}

newTalent{
	name = "Iron Will",
	type = {"psionic/mental-discipline", 3},
	require = psi_wil_req3,
	points = 5,
	mode = "passive",
	stunImmune = function(self, t) return self:combatTalentLimit(t, 1, 0.17, 0.50) end,
	on_learn = function(self, t)
		self.combat_mentalresist = self.combat_mentalresist + 6
	end,
	on_unlearn = function(self, t)
		self.combat_mentalresist = self.combat_mentalresist - 6
	end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "stun_immune", t.stunImmune(self, t))
	end,
	info = function(self, t)
		return ([[增 加 %d 点 精 神 豁 免 和 震 慑 免 疫 %d%% 。]]):
		format(self:getTalentLevelRaw(t)*6, t.stunImmune(self, t)*100)
	end,
}

newTalent{
	name = "Highly Trained Mind",
	type = {"psionic/mental-discipline", 4},
	mode = "passive",
	require = psi_wil_req4,
	points = 5,
	on_learn = function(self, t)
		self.inc_stats[self.STAT_WIL] = self.inc_stats[self.STAT_WIL] + 2
		self:onStatChange(self.STAT_WIL, 2)
		self.inc_stats[self.STAT_CUN] = self.inc_stats[self.STAT_CUN] + 2
		self:onStatChange(self.STAT_CUN, 2)
	end,
	on_unlearn = function(self, t)
		self.inc_stats[self.STAT_WIL] = self.inc_stats[self.STAT_WIL] - 2
		self:onStatChange(self.STAT_WIL, -2)
		self.inc_stats[self.STAT_CUN] = self.inc_stats[self.STAT_CUN] - 2
		self:onStatChange(self.STAT_CUN, -2)
	end,
	info = function(self, t)
		return ([[一 次 精 神 训 练 加 强 了 你 的 意 志 和 灵 巧。 
		 增 加 %d 点 意 志 和 灵 巧。]]):format(2*self:getTalentLevelRaw(t))
	end,
}
