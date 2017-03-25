local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WATERS_OF_LIFE",
	name = "生命之水",
	info = function(self, t)
		return ([[生 命 之 水 流 过 你 的 身 体， 净 化 你 身 上 的 毒 素 或 疾 病 效 果。 
		 在 %d 回 合 内 所 有 的 毒 素 或 疾 病 效 果 都 无 法 伤 害 却 能 治 疗 你。 
		 当 此 技 能 激 活 时， 你 身 上 每 有 1 种 毒 素 或 疾 病 效 果， 恢 复 %d 点 生 命。 
		 受 意 志 影 响， 治 疗 量 有 额 外 加 成。]]):
		format(t.getdur(self,t), self:combatTalentStatDamage(t, "wil", 20, 60))
	end,
}

registerTalentTranslation{
	id = "T_ELEMENTAL_HARMONY",
	name = "元素和谐",
	info = function(self, t)
		local power = self:getTalentLevel(t)
		local turns = t.duration(self, t)
		local fire = 100 * t.fireSpeed(self, t)
		local cold = 3 + power * 2
		local lightning = math.floor(power)
		local acid = 5 + power * 2
		local nature = 5 + power * 1.4
		return ([[通 过 自 然 协 调 与 元 素 们 成 为 朋 友。 每 当 你 被 某 种 元 素 攻 击 时， 你 可 以 获 得 对 应 效 果， 持 续 %d 回 合。 每 %d 回 合 只 能 触 发 一 次。 
		 火 焰： +%d%% 全 部 速 度 
		 寒 冷： +%d 护 甲 值 
		 闪 电： +%d 所 有 属 性 
		 酸 液： +%0.2f 生 命 回 复 
		 自 然： +%d%% 所 有 抵 抗]]):
		format(turns, turns, fire, cold, lightning, acid, nature)
	end,
}

registerTalentTranslation{
	id = "T_ONE_WITH_NATURE",
	name = "自然之友",
	info = function(self, t)
		local turns = t.getCooldown(self, t)
		local nb = t.getNb(self, t)
		return ([[与 自 然 交 流， 移 除 纹 身 类 技 能 饱 和 效 果 并 减 少 %d 种 纹 身 %d 回 合 冷 却 时 间。]]):
		format(nb, turns)
	end,
}

registerTalentTranslation{
	id = "T_HEALING_NEXUS",
	name = "治疗转移",
	info = function (self,t)
		local pct = t.getPct(self, t)*100
		return ([[在 你 的 身 旁 %d 码 半 径 范 围 内 流 动 着 一 波 自 然 能 量， 所 有 被 击 中 的 敌 人 都 会 受 到 治 疗 转 移 的 效 果， 持 续 %d 回 合。 
		 每 次 你 被 治 疗 ， 会 回 复 %d 点 自 然 失 衡 值，治 疗 效 率 %d%% 。
		 当 此 技 能 激 活 时， 所 有 对 敌 人 的 治 疗 都 会 转 移 到 你 身 上， 继 承 %d%% 治 疗 价 值。（ 敌 人 不 受 到 治 疗） 
		 。]]):
		format(self:getTalentRadius(t), t.getDur(self, t), t.getEquilibrium(self, t), 100 + pct, pct)
	end,
}


return _M
