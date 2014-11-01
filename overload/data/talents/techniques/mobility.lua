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

local Map = require "engine.Map"

newTalent{
	name = "Hack'n'Back",
	type = {"technique/mobility", 1},
	points = 5,
	cooldown = 14,
	stamina = 30,
	tactical = { ESCAPE = 1, ATTACK = { weapon = 0.5 } },
	require = techs_dex_req1,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.4, 1) end,
	getDist = function(self, t) return math.ceil(self:combatTalentScale(t, 1.2, 3.3)) end,
	on_pre_use = function(self, t)
		if self:attr("never_move") then return false end
		return true
	end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local hitted = self:attackTarget(target, nil, t.getDamage(self, t), true)

		if hitted then
			self:knockback(target.x, target.y, t.getDist(self, t))
		end

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local dist = t.getDist(self, t)
		return ([[你 对 目 标 造 成 %d%% 伤 害， 分 散 它 的 注 意 力 并 往 回 跳 %d 码。]]):
		format(100 * damage, dist)
	end,
}

newTalent{
	name = "Mobile Defence",
	type = {"technique/mobility", 2},
	mode = "passive",
	points = 5,
	require = techs_dex_req2,
	getDef = function(self, t) return self:getTalentLevel(t) * 0.08 end,
	getHardiness = function(self, t) return self:getTalentLevel(t) * 0.06 end,
	-- called by _M:combatDefenseBase function in mod\class\interface\Combat.lua
	getDef = function(self, t) return self:combatTalentLimit(t, 1, 0.10, 0.40) end, -- Limit to <100% defense bonus
	-- called by _M:combatArmorHardiness function in mod\class\interface\Combat.lua
	getHardiness = function(self, t) return self:combatTalentLimit(t, 100, 6, 30) end, -- Limit < 100%
	info = function(self, t)
		return ([[当 你 装 备 皮 甲 或 轻 甲 时， 你 会 增 加 %d%% 近 身 闪 避 和 %d%% 护 甲 韧 性。]]):
		format(t.getDef(self, t) * 100, t.getHardiness(self, t))
	end,
}

newTalent{
	name = "Light of Foot",
	type = {"technique/mobility", 3},
	mode = "passive",
	points = 5,
	require = techs_dex_req3,
	getFatigue = function(self, t) return self:combatTalentLimit(t, 100, 1.5, 7.5) end, -- Limit < 50%
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "fatigue", -t.getFatigue(self, t))
	end,
	info = function(self, t)
		return ([[你 的 步 伐 很 轻 快， 使 你 能 更 好 的 适 应 盔 甲 的 重 量。 每 移 动 一 步 你 可 以 回 复 %0.2f 体 力 并 且 你 的 负 担 永 久 减 少 %0.1f%% 。 
		在 等 级 3 时 你 的 脚 步 非 常 轻 快 以 至 于 你 不 会 触 发 压 力 式 陷 阱。]]):
		format(self:getTalentLevelRaw(t) * 0.2, t.getFatigue(self, t))
	end,

}

newTalent{
	name = "Strider",
	type = {"technique/mobility", 4},
	mode = "passive",
	points = 5,
	require = techs_dex_req4,
	incspeed = function(self, t) return self:combatTalentScale(t, 0.02, 0.10, 0.75) end,
	CDreduce = function(self, t) return math.floor(self:combatTalentLimit(t, 8, 1, 5)) end, -- Limit < 8
	passives = function(self, t, p)
		local cdr = t.CDreduce(self, t)
		self:talentTemporaryValue(p, "movement_speed", t.incspeed(self, t))
		self:talentTemporaryValue(p, "talent_cd_reduction",
			{[Talents.T_RUSH]=cdr, [Talents.T_HACK_N_BACK]=cdr, [Talents.T_DISENGAGE]=cdr, [Talents.T_EVASION]=cdr})
	end,
	info = function(self, t)
		return ([[你 在 敌 人 周 围 跳 起 华 丽 的 舞 蹈， 增 加 %d%% 移 动 速 度 并 减 少 燕 回 斩、 冲 锋、 逃 脱 和 回 避 技 能 %d 回 合。]]):
		format(t.incspeed(self, t)*100,t.CDreduce(self, t))
	end,
}

