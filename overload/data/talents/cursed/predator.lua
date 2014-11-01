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

newTalent{
	name = "Mark Prey",
	type = {"cursed/predator", 1},
	require = cursed_lev_req1,
	points = 5,
	tactical = { ATTACK = 3 },
	cooldown = 5,
	range = 10,
	no_energy = true,
	getMaxKillExperience = function(self, t)
		local total = 0
		
		if t then total = total + self:getTalentLevelRaw(t) end
		local t = self:getTalentFromId(self.T_ANATOMY)
		if t then total = total + self:getTalentLevelRaw(t) end
		local t = self:getTalentFromId(self.T_OUTMANEUVER)
		if t then total = total + self:getTalentLevelRaw(t) end
		local t = self:getTalentFromId(self.T_MIMIC)
		if t then total = total + self:getTalentLevelRaw(t) end
		
		return self:combatLimit(total, 0, 19.5, 1, 10, 20) --  Limit > 0
	end,
	getSubtypeDamageChange = function(self, t)
		return math.pow(self:getTalentLevel(t), 0.5) * 0.15
	end,
	getTypeDamageChange = function(self, t)
		return math.pow(self:getTalentLevel(t), 0.5) * 0.065
	end,
	getHateBonus = function(self, t) return self:combatTalentScale(t, 3, 10, "log")	end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end
		
		local eff = self:hasEffect(self.EFF_PREDATOR)
		if eff and eff.type == target.type and eff.subtype == target.subtype then
			return false
		end
		if eff then self:removeEffect(self.EFF_PREDATOR, true, true) end
		self:setEffect(self.EFF_PREDATOR, 1, { type=target.type, subtype=target.subtype, killExperience = 0, subtypeKills = 0, typeKills = 0 })
		
		return true
	end,
	on_unlearn = function(self, t)
		if not self:knowTalent(t) then
			local ef = self.tempeffect_def.EFF_PREDATOR
			ef.no_remove = false
			self:removeEffect(self.EFF_PREDATOR)
			ef.no_remove = true
		end
	end,
	info = function(self, t)
		local maxKillExperience = t.getMaxKillExperience(self, t)
		local subtypeDamageChange = t.getSubtypeDamageChange(self, t)
		local typeDamageChange = t.getTypeDamageChange(self, t)
		local hateDesc = ""
		if self:knowTalent(self.T_HATE_POOL) then
			local hateBonus = t.getHateBonus(self, t)
			hateDesc = ("无 论 当 前 仇 恨 回 复 值 为 多 少， 每 击 杀 一 个 被 标 记 的 亚 类 生 物 给 予 你 额 外 的 +%d 仇 恨 值 回 复。"):format(hateBonus)
		end
		return ([[标 记 某 个 敌 人 作 为 你 的 捕 猎 目 标， 使 攻 击 该 类 及 该 亚 类 的 生 物 时 获 得 额 外 加 成， 加 成 量 受 你 杀 死 该 标 记 类 生 物 获 得 的 经 验 值 加 成（ +0.25 主 类， +1 亚 类）， 当 你 增 加 %0.1f 经 验 值 时， 获 得 100%% 效 果 加 成。 攻 击 标 记 目 标 类 生 物 将 造 成 +%d%% 伤 害， 攻 击 标 记 目 标 亚 类 生 物 将 造 成 +%d%% 伤 害。 
		 每 增 加 一 个 技 能 点 减 少 达 到 100%% 效 果 加 成 的 经 验 需 求。 
		%s]]):format(maxKillExperience, typeDamageChange * 100, subtypeDamageChange * 100, hateDesc)
	end,
}

newTalent{
	name = "Anatomy",
	type = {"cursed/predator", 2},
	mode = "passive",
	require = cursed_lev_req2,
	points = 5,
	getSubtypeAttackChange = function(self, t) return self:combatTalentScale(t, 5, 15.4, 0.75) end,
	getTypeAttackChange = function(self, t) return self:combatTalentScale(t, 2, 6.2, 0.75) end,
	getSubtypeStunChance = function(self, t) return self:combatLimit(self:getTalentLevel(t)^0.5, 100, 3.1, 1, 6.93, 2.23) end, -- Limit < 100%
	on_learn = function(self, t)
		local eff = self:hasEffect(self.EFF_PREDATOR)
		if eff then
			self.tempeffect_def[self.EFF_PREDATOR].updateEffect(self, eff)
		end
	end,
	on_unlearn = function(self, t)
		local eff = self:hasEffect(self.EFF_PREDATOR)
		if eff then
			self.tempeffect_def[self.EFF_PREDATOR].updateEffect(self, eff)
		end
	end,
	info = function(self, t)
		local subtypeAttackChange = t.getSubtypeAttackChange(self, t)
		local typeAttackChange = t.getTypeAttackChange(self, t)
		local subtypeStunChance = t.getSubtypeStunChance(self, t)
		return ([[你 对 捕 猎 目 标 的 了 解 使 你 的 攻 击 提 高 额 外 精 度， 对 标 记 类 目 标 获 得 +%d 命 中， 对 标 记 亚 类 目 标 获 得 +%d 命 中。 
		 每 次 近 战 攻 击 对 标 记 亚 类 生 物 有 %0.1f%% 概 率 震 慑 目 标 3 回 合。 
		 每 增 加 一 个 技 能 点 减 少 达 到 100%% 效 果 加 成 的 经 验 需 求。]]):format(typeAttackChange, subtypeAttackChange, subtypeStunChance)
	end,
}

newTalent{
	name = "Outmaneuver",
	type = {"cursed/predator", 3},
	mode = "passive",
	require = cursed_lev_req3,
	points = 5,
	getDuration = function(self, t)
		return 10
	end,
	on_learn = function(self, t)
	end,
	on_unlearn = function(self, t)
	end,
	getSubtypeChance = function(self, t) return self:combatLimit(self:getTalentLevel(t)^0.5, 100, 10, 1, 22.3, 2.23) end, -- Limit <100%
	getTypeChance = function(self, t) return self:combatLimit(self:getTalentLevel(t)^0.5, 100, 4, 1, 8.94, 2.23) end, -- Limit <100%
	getPhysicalResistChange = function(self, t) return -self:combatLimit(self:getTalentLevel(t)^0.5, 100, 8, 1, 17.9, 2.23) end, -- Limit <100%
	getStatReduction = function(self, t)
		return math.floor(math.sqrt(self:getTalentLevel(t)) * 4.3)
	end,
	on_learn = function(self, t)
		local eff = self:hasEffect(self.EFF_PREDATOR)
		if eff then
			self.tempeffect_def[self.EFF_PREDATOR].updateEffect(self, eff)
		end
	end,
	on_unlearn = function(self, t)
		local eff = self:hasEffect(self.EFF_PREDATOR)
		if eff then
			self.tempeffect_def[self.EFF_PREDATOR].updateEffect(self, eff)
		end
	end,
	info = function(self, t)
		local subtypeChance = t.getSubtypeChance(self, t)
		local typeChance = t.getTypeChance(self, t)
		local physicalResistChange = t.getPhysicalResistChange(self, t)
		local statReduction = t.getStatReduction(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 的 每 次 近 战 攻 击 有 一 定 概 率 触 发 运 筹 帷 幄， 降 低 目 标 的 物 理 抵 抗 %d%% 同 时 降 低 他 们 最 高 的 三 项 属 性 %d ， 对 标 记 类 生 物 有 %0.1f%% 概 率 触 发， 对 标 记 亚 类 生 物 有 %0.1f%% 概 率 触 发， 持 续 %d 回 合， 该 效 果 可 叠 加。 
		 每 增 加 一 个 技 能 点 减 少 达 到 100%% 效 果 加 成 的 经 验 需 求。]]):format(-physicalResistChange, statReduction, typeChance, subtypeChance, duration)
	end,
}

newTalent{
	name = "Mimic",
	type = {"cursed/predator", 4},
	mode = "passive",
	require = cursed_lev_req4,
	points = 5,
	getMaxIncrease = function(self, t) return self:combatTalentScale(t, 7, 21.6, 0.75) end,
	on_learn = function(self, t)
		self:removeEffect(self.EFF_MIMIC, true, true)
	end,
	on_unlearn = function(self, t)
		self:removeEffect(self.EFF_MIMIC, true, true)
	end,
	info = function(self, t)
		local maxIncrease = t.getMaxIncrease(self, t)
		return ([[你 学 习 汲 取 目 标 的 力 量， 杀 死 该 亚 类 生 物 可 以 提 升 你 的 属 性 值 以 接 近 该 生 物 的 能 力（ 最 多 %d 总 属 性 点 数， 由 你 的 当 前 效 能 决 定）， 效 果 持 续 时 间 并 不 确 定， 且 只 有 最 近 杀 死 的 敌 人 获 得 的 效 果 有 效。 
		 每 增 加 一 个 技 能 点 减 少 达 到 100%% 效 果 加 成 的 经 验 需 求。]]):format(maxIncrease)
	end,
}
