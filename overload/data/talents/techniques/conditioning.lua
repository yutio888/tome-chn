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
	name = "Vitality",
	type = {"technique/conditioning", 1},
	require = techs_con_req1,
	mode = "passive",
	points = 5,
	cooldown = 15,
	getHealValues = function(self, t)  --base, fraction of max life
		return (self.life_rating or 10) + self:combatTalentStatDamage(t, "con", 2, 20), self:combatTalentLimit(t, 0.3, 0.07, 0.16)
	end,
	getWoundReduction = function(self, t) return self:combatTalentLimit(t, 1, 0.17, 0.5) end, -- Limit <100%
	getDuration = function(self, t) return 8 end,
	do_vitality_recovery = function(self, t)
		if self:isTalentCoolingDown(t) then return end
		local baseheal, percent = t.getHealValues(self, t)
		self:setEffect(self.EFF_RECOVERY, t.getDuration(self, t), {power = baseheal, pct = percent / t.getDuration(self, t)})
		self:startTalentCooldown(t)
	end,
	info = function(self, t)
		local wounds = t.getWoundReduction(self, t) * 100
		local baseheal, healpct = t.getHealValues(self, t)
		local duration = t.getDuration(self, t)
		local totalheal = baseheal + self.max_life*healpct/duration
		return ([[你 受 中 毒、 疾 病 和 创 伤 的 影 响 较 小， 减 少 %d%% 此 类 效 果 的 持 续 时 间。 
		此 外 在 生 命 低 于 50%% 时 你 会 得 到 回 复 效 果 ，回 复 总 量为 %0.1f 加 上 %0.1f%% 最 大 生 命 值(%0.1f 点) ，持 续 %d 回 合 ， 但 每 隔 %d 回 合 才 能 触 发 一 次。
		受 体 质 影 响， 治 疗 加 成 和 生 命 回 复 有 额 外 加 成。]]):
		format(wounds, baseheal, healpct/duration*100, totalheal, duration, self:getTalentCooldown(t))
	end,
}

newTalent{
	name = "Unflinching Resolve",
	type = {"technique/conditioning", 2},
	require = techs_con_req2,
	mode = "passive",
	points = 5,
	getChance = function(self, t) return self:combatStatLimit("con", 1, .28, .745)*self:combatTalentLimit(t,100, 28,74.8) end, -- Limit < 100%
	do_unflinching_resolve = function(self, t)
		local effs = {}
		-- Go through all spell effects
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.status == "detrimental" then
				if e.subtype.stun then 
					effs[#effs+1] = {"effect", eff_id}
				elseif e.subtype.blind and self:getTalentLevel(t) >=2 then
					effs[#effs+1] = {"effect", eff_id}
				elseif e.subtype.confusion and self:getTalentLevel(t) >=3 then
					effs[#effs+1] = {"effect", eff_id}
				elseif e.subtype.pin and self:getTalentLevel(t) >=4 then
					effs[#effs+1] = {"effect", eff_id}
				elseif (e.subtype.slow or e.subtype.wound) and self:getTalentLevel(t) >=5 then
					effs[#effs+1] = {"effect", eff_id}
				end
			end
		end
		
		if #effs > 0 then
			local eff = rng.tableRemove(effs)
			if eff[1] == "effect" and rng.percent(t.getChance(self, t)) then
				self:removeEffect(eff[2])
				game.logSeen(self, "%s has recovered!", self.name:capitalize())
			end
		end
	end,
	info = function(self, t)
		local chance = t.getChance(self, t)
		return ([[你 学 会 从 负 面 状 态 中 快 速 恢 复。 
		每 回 合 你 有 %d%% 几 率 从 震 慑 效 果 中 恢 复。 
		在 等 级 2 时， 也 可 以 从 致 盲 效 果 中 恢 复。 
		在 等 级 3 时， 也 可 以 从 混 乱 效 果 中 恢 复。 
		在 等 级 4 时， 也 可 以 从 定 身 效 果 中 恢 复。 
		在 等 级 5 时， 也 可 以 从 减 速 或 流 血 效 果 中 恢 复。 
		每 回 合 你 只 能 摆 脱 1 种 状 态。 
		受 体 质 影 响， 恢 复 概 率 按 比 例 加 成。]]):
		format(chance)
	end,
}

newTalent{
	name = "Daunting Presence",
	type = {"technique/conditioning", 3},
	require = techs_con_req3,
	points = 5,
	mode = "sustained",
	sustain_stamina = 20,
	cooldown = 8,
	tactical = { DEFEND = 2, DISABLE = 1, },
	range = 0,
	getRadius = function(self, t) return math.ceil(self:combatTalentScale(t, 0.25, 2.3)) end,
	getPenalty = function(self, t) return self:combatTalentPhysicalDamage(t, 5, 36) end,
	getMinimumLife = function(self, t)
		return self.max_life * self:combatTalentLimit(t, 0.1, 0.45, 0.25) -- Limit > 10% life
	end,
	on_pre_use = function(self, t, silent) if t.getMinimumLife(self, t) > self.life then if not silent then game.logPlayer(self, "You are too injured to use this talent.") end return false end return true end,
	do_daunting_presence = function(self, t)
		local tg = {type="ball", range=0, radius=t.getRadius(self, t), friendlyfire=false, talent=t}
		self:project(tg, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if target then
				if target:canBe("fear") then
					target:setEffect(target.EFF_INTIMIDATED, 4, {apply_power=self:combatAttackStr(), power=t.getPenalty(self, t), no_ct_effect=true})
					game.level.map:particleEmitter(target.x, target.y, 1, "flame")
				else
					game.logSeen(target, "%s is not intimidated!", target.name:capitalize())
				end
			end
		end)
	end,
	activate = function(self, t)
		local ret = {	}
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local penalty = t.getPenalty(self, t)
		local min_life = t.getMinimumLife(self, t)
		return ([[敌 人 因 你 不 屈 不 挠 的 意 志 而 恐 惧。 当 你 承 受 超 过 5%% 最 大 生 命 值 的 单 次 伤 害 时， 你 周 围 %d 码 半 径 的 敌 人 会 因 你 的 霸 气 侧 漏 而 感 到 恐 慌， 减 少 %d 物 理 强 度、 法 术 强 度、 精 神 强 度 4 回 合。 
		如 果 你 的 生 命 值 低 于 %d 你 将 不 能 激 活 此 技 能 且 此 技 能 自 动 停 止。 
		受 物 理 强 度 影 响， 威 胁 效 果 有 加 成。 
		受 力 量 影 响， 敌 人 受 影 响 的 几 率 有 额 外 加 成。]]):
		format(radius, penalty, min_life)
	end,
}

newTalent{
	name = "Adrenaline Surge", -- no stamina cost; it's main purpose is to give the player an alternative means of using stamina based talents
	type = {"technique/conditioning", 4},
	require = techs_con_req4,
	points = 5,
	cooldown = 24,
	tactical = { STAMINA = 1, BUFF = 2 },
	getAttackPower = function(self, t) return self:combatTalentStatDamage(t, "con", 5, 25) end,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 24, 3, 7)) end, -- Limit < 24
	no_energy = true,
	action = function(self, t)
		self:setEffect(self.EFF_ADRENALINE_SURGE, t.getDuration(self, t), {power = t.getAttackPower(self, t)})
		return true
	end,
	info = function(self, t)
		local attack_power = t.getAttackPower(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 激 活 肾 上 腺 素 来 增 加 %d 物 理 强 度 持 续 %d 回 合。 
		此 技 能 激 活 时， 你 可 以 不 知 疲 倦 地 战 斗， 若 体 力 为 0， 可 继 续 使 用 消 耗 类 技 能， 代 价 为 消 耗 生 命。 
		受 体 质 影 响， 物 理 强 度 有 额 外 加 成。 
		使 用 本 技 能 不 会 消 耗 额 外 回 合。]]):
		format(attack_power, duration)
	end,
}
