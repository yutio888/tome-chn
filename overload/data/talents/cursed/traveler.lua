-- ToME - Tales of Middle-Earth
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

newTalent{
	name = "Hardened",
	type = {"cursed/traveler", 1},
	require = cursed_wil_req1,
	mode = "passive",
	points = 5,
	on_learn = function(self, t)
		self.combat_armor = (self.combat_armor or 0) + 2
	end,
	on_unlearn = function(self, t)
		self.combat_armor = self.combat_armor - 2
	end,
	info = function(self, t)
		return ([[你 的 经 历 使 你 的 护 甲 值 增 加 +%d 。]]):format(self:getTalentLevelRaw(t) * 2)
	end
}

newTalent{
	name = "Wary",
	type = {"cursed/traveler", 2},
	require = cursed_wil_req2,
	mode = "passive",
	points = 5,
	on_learn = function(self, t)
		self.trap_avoidance = (self.trap_avoidance or 0) + 14
	end,
	on_unlearn = function(self, t)
		self.trap_avoidance = self.trap_avoidance - 14
	end,
	info = function(self, t)
		return ([[你 的 行 动 变 得 更 加 谨 慎， 有 %d%% 几 率 不 会 触 发 陷 阱。]]):format(self:getTalentLevelRaw(t) * 14)
	end
}

newTalent{
	name = "Weathered",
	type = {"cursed/traveler", 3},
	require = cursed_wil_req3,
	mode = "passive",
	points = 5,

	on_learn = function(self, t)
		self.resists[DamageType.FIRE] = (self.resists[DamageType.FIRE] or 0) + 7
		self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) + 7
	end,
	on_unlearn = function(self, t)
		self.resists[DamageType.FIRE] = self.resists[DamageType.FIRE] - 7
		self.resists[DamageType.COLD] = self.resists[DamageType.COLD] - 7
	end,
	info = function(self, t)
		return ([[你 更 适 应 元 素 攻 击， 增 加 你 火 焰 和 冰 冻 抵 抗 %d%% 。]]):format(self:getTalentLevel(t) * 7)
	end
}

newTalent{
	name = "Savvy",
	type = {"cursed/traveler", 4},
	require = cursed_wil_req4,
	mode = "passive",
	points = 5,
	on_learn = function(self, t)
		self.exp_kill_multiplier = (self.exp_kill_multiplier or 1) + 0.03
	end,
	on_unlearn = function(self, t)
		self.exp_kill_multiplier = (self.exp_kill_multiplier or 1) - 0.03
	end,
	info = function(self, t)
		return ([[你 在 旅 途 中 逐 渐 成 长 为 一 个 敏 锐 的 观 察 者， 杀 死 敌 人 获 得 %d%% 更 多 经 验 值。]]):format(self:getTalentLevelRaw(t) * 3)
	end
}

