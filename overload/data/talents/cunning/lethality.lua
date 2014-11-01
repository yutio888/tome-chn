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
	name = "Lethality",
	type = {"cunning/lethality", 1},
	mode = "passive",
	points = 5,
	require = cuns_req1,
	critpower = function(self, t) return self:combatTalentScale(t, 7.5, 25, 0.75) end,
	-- called by _M:combatCrit in mod.class.interface.Combat.lua
	getCriticalChance = function(self, t) return self:combatTalentScale(t, 2.3, 7.5, 0.75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_critical_power", t.critpower(self, t))
	end,
	info = function(self, t)
		local critchance = t.getCriticalChance(self, t)
		local power = t.critpower(self, t)
		return ([[你 学 会 寻 找 并 打 击 目 标 弱 点。 你 的 攻 击 有 %0.2f%% 更 大 几 率 出 现 暴 击 且 暴 击 伤 害 增 加 %0.1f%% 。 同 时， 当 你 使 用 匕 首 时， 你 的 灵 巧 点 数 会 代 替 力 量 影 响 额 外 伤 害。]]):
		format(critchance, power)
	end,
}

newTalent{
	name = "Deadly Strikes",
	type = {"cunning/lethality", 2},
	points = 5,
	random_ego = "attack",
	cooldown = 12,
	stamina = 15,
	require = cuns_req2,
	tactical = { ATTACK = {weapon = 2} },
	no_energy = true,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.8, 1.4) end,
	getArmorPierce = function(self, t) return self:combatTalentStatDamage(t, "cun", 5, 45) end,  -- Adjust to scale like armor progression elsewhere
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 12, 6, 10)) end, --Limit to <12
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local hitted = self:attackTarget(target, nil, t.getDamage(self, t), true)

		if hitted then
			self:setEffect(self.EFF_DEADLY_STRIKES, t.getDuration(self, t), {power=t.getArmorPierce(self, t)})
		end

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local apr = t.getArmorPierce(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 对 目 标 造 成 %d%% 的 伤 害。 如 果 你 的 攻 击 命 中， 你 会 增 加 %d 点 护 甲 穿 透， 持 续 %d 回 合。 
		 受 你 的 灵 巧 影 响， 护 甲 穿 透 有 额 外 加 成。]]):
		format(100 * damage, apr, duration)
	end,
}

newTalent{
	name = "Willful Combat",
	type = {"cunning/lethality", 3},
	points = 5,
	random_ego = "attack",
	cooldown = 60,
	stamina = 25,
	tactical = { BUFF = 3 },
	require = cuns_req3,
	no_energy = true,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 60, 5, 11.1)) end, -- Limit <60
	getDamage = function(self, t) return self:combatStatScale("wil", 4, 40, 0.75) + self:combatStatScale("cun", 4, 40, 0.75) end,
	action = function(self, t)
		self:setEffect(self.EFF_WILLFUL_COMBAT, t.getDuration(self, t), {power=t.getDamage(self, t)})
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[你 专 注 于 你 的 攻 击， 持 续 %d 回 合， 增 加 每 次 攻 击 %d 点 物 理 强 度。 
		 受 你 的 灵 巧 与 意 志 影 响， 效 果 有 额 外 加 成。]]):
		format(duration, damage)
	end,
}

newTalent{
	name = "Snap",
	type = {"cunning/lethality",4},
	require = cuns_req4,
	points = 5,
	stamina = 50,
	cooldown = 50,
	tactical = { BUFF = 1 },
	getTalentCount = function(self, t) return math.floor(self:combatTalentScale(t, 2, 7, "log")) end,
	getMaxLevel = function(self, t) return self:getTalentLevel(t) end,
	action = function(self, t)
		local tids = {}
		for tid, _ in pairs(self.talents_cd) do
			local tt = self:getTalentFromId(tid)
			if tt.type[2] <= t.getMaxLevel(self, t) and (tt.type[1]:find("^cunning/") or tt.type[1]:find("^technique/")) then
				tids[#tids+1] = tid
			end
		end
		for i = 1, t.getTalentCount(self, t) do
			if #tids == 0 then break end
			local tid = rng.tableRemove(tids)
			self.talents_cd[tid] = nil
		end
		self.changed = true
		return true
	end,
	info = function(self, t)
		local talentcount = t.getTalentCount(self, t)
		local maxlevel = t.getMaxLevel(self, t)
		return ([[你 的 快 速 反 应 使 你 能 够 重 置 至 多 %d 个 层 级 不 超 过 %d 的 战 斗 技 能（ 灵 巧 类 或 格 斗 类） 的 冷 却 时 间。]]):
		format(talentcount, maxlevel)
	end,
}

