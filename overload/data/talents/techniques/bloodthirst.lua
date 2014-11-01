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
	name = "Mortal Terror",
	type = {"technique/bloodthirst", 1},
	require = techs_req_high1,
	points = 5,
	mode = "passive",
	threshold = function(self,t) return self:combatTalentLimit(t, 10, 45, 25) end, -- Limit >10%
	getCrit = function(self, t) return self:combatTalentScale(t, 2.8, 14) end,
	do_terror = function(self, t, target, dam)
		if dam < target.max_life * t.threshold(self, t) / 100 then return end

		local weapon = target:getInven("MAINHAND")
		if type(weapon) == "boolean" then weapon = nil end
		if weapon then weapon = weapon[1] and weapon[1].combat end
		if not weapon or type(weapon) ~= "table" then weapon = nil end
		weapon = weapon or target.combat

		if target:canBe("stun") then
			target:setEffect(target.EFF_DAZED, 5, {apply_power=self:combatPhysicalpower()})
		else
			game.logSeen(target, "%s resists the terror!", target.name:capitalize())
		end
	end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_physcrit", t.getCrit(self, t))
	end,
	info = function(self, t)
		return ([[你 强 力 的 攻 击 引 发 敌 人 深 深 的 恐 惧。 
		任 何 你 对 目 标 造 成 的 超 过 其 %d%% 总 生 命 值 的 近 身 打 击 会 使 目 标 陷 入 深 深 的 恐 惧 中， 眩 晕 目 标 5 回 合。 
		你 的 暴 击 率 同 时 增 加 %d%% 。 
		受 物 理 强 度 影 响， 眩 晕 概 率 有 额 外 加 成。 ]]):
		format(t.threshold(self, t), self:getTalentLevelRaw(t) * 2.8)
	end,
}

newTalent{
	name = "Bloodbath",
	type = {"technique/bloodthirst", 2},
	require = techs_req_high2,
	points = 5,
	mode = "passive",
	getHealth = function(self,t) return self:combatTalentLimit(t, 50, 2, 10)  end,  -- Limit max health increase to <+50%
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	getRegen = function (self, t) return self:combatTalentScale(t, 1.7, 5) end,
	getMax = function(self, t) return 5*self:combatTalentScale(t, 1.7, 5) end,
	-- called by _M:attackTargetWith in mod.class.interface.Combat.lua
	do_bloodbath = function(self, t)
		self:setEffect(self.EFF_BLOODBATH, t.getDuration(self, t), {regen=t.getRegen(self, t), max=t.getMax(self, t), hp=t.getHealth(self,t)})
	end,
	info = function(self, t)
		local regen = t.getRegen(self, t)
		local max_regen = t.getMax(self, t)
		local max_health = t.getHealth(self,t)
		return ([[沐 浴 着 敌 人 的 鲜 血 令 你 感 到 兴 奋。 
		在 成 功 打 出 一 次 暴 击 后， 会 增 加 你 %d%% 的 最 大 生 命 值、 %0.2f 每 回 合 生 命 回 复 点 数 和 %0.2f 每 回 合 体 力 回 复 点 数 持 续 %d 回 合。  
		生 命 与 体 力 回 复 可 以 叠 加 5 次 直 至 %0.2f 生 命 和 %0.2f 体 力 回 复 / 回 合。]]):
		format(t.getHealth(self, t), regen, regen/5, t.getDuration(self, t),max_regen, max_regen/5)
	end,
}

newTalent{
	name = "Bloody Butcher",
	type = {"technique/bloodthirst", 3},
	require = techs_req_high3,
	points = 5,
	mode = "passive",
	getDam = function(self, t) return self:combatScale(self:getStr(5, true) * self:getTalentLevel(t), 5, 0, 40, 35) end,
	getResist = function(self,t) return self:combatTalentScale(t, 10, 40) end,
	info = function(self, t)
		return ([[你 沉 醉 于 撕 裂 伤 口 的 兴 奋 中，增 加 %d 物 理 强 度。
		同 时 ， 每 次 你 让 敌 人流 血 时 ， 它 的 物 理 抗 性 下 降 %d%%（但 不 会 小 于0）
		物 理 强 度 加 成 受 力 量 影 响。]]):
		format(t.getDam(self, t), t.getResist(self, t))
	end,
}

newTalent{
	name = "Unstoppable",
	type = {"technique/bloodthirst", 4},
	require = techs_req_high4,
	points = 5,
	cooldown = 45,
	stamina = 120,
	tactical = { DEFEND = 5, CLOSEIN = 2 },
	getHealPercent = function(self,t) return self:combatTalentLimit(t, 50, 3.5, 17.5) end, -- Limit <50%
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 25, 3, 7, true)) end, -- Limit < 25
	action = function(self, t)
		self:setEffect(self.EFF_UNSTOPPABLE, t.getDuration(self, t), {hp_per_kill=t.getHealPercent(self,t)})
		return true
	end,
	info = function(self, t)
		return ([[你 进 入 疯 狂 战 斗 状 态 %d 回 合。 
		在 这 段 时 间 内 你 不 能 使 用 物 品， 并 且 治 疗 无 效， 此 时 你 的 生 命 值 无 法 低 于 1 点。 
		状 态 结 束 后 你 每 杀 死 一 个 敌 人 可 以 回 复 %d%% 最 大 生 命 值。
		当 进 入 无 双 状 态 时 ， 由 于 你 失 去 了 死 亡 的 威 胁 ， 狂 战 之 怒 不 能 提 供 暴 击 加 成。]]):
		format(t.getDuration(self, t), t.getHealPercent(self,t))
	end,
}
