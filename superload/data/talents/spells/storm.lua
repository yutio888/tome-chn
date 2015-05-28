local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_NOVA",
	name = "闪电新星",
	info = function(self, t)
		local dam = damDesc(self, DamageType.LIGHTNING, t.getDamage(self, t))
		local radius = self:getTalentRadius(t)
		return ([[一 圈 闪 电 从 你 身 上 放 射 出 来， 在 %d 码 范 围 内 对 目 标 造 成 %0.2f ～ %0.2f 闪 电 伤 害 并 有 75%% 概 率 眩 晕 敌 人。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(radius, dam / 3, dam)
	end,
}

registerTalentTranslation{
	id = "T_SHOCK",
	name = "闪电之击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[召 唤 一 个 闪 电 球 对 目 标 造 成 %0.2f ～ %0.2f 闪 电 伤 害 并 眩 晕 目 标 3 回 合。 
		 如 果 目 标 免 疫 了 眩 晕 ， 则 5 回 合 内 震 慑 和 定 身 抗 性 减 半。
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.LIGHTNING, damage/3), damDesc(self, DamageType.LIGHTNING, damage))
	end,
}

registerTalentTranslation{
	id = "T_HURRICANE",
	name = "风暴之怒",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local chance = t.getChance(self, t)
		local radius = t.getRadius(self, t)
		return ([[每 次 你 的 闪 电 法 术 眩 晕 目 标 时， 它 会 有 %d%% 的 概 率 发 生 连 锁 反 应， 生 成 一 个 围 绕 目 标 %d 码 半 径 范 围 的 飓 风， 持 续 10 回 合。 
		 每 回 合 该 单 位 附 近 的 所 有 生 物 会 承 受 %0.2f ～ %0.2f 闪 电 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(chance, radius, damage / 3, damage)
	end,
}

registerTalentTranslation{
	id = "T_TEMPEST",
	name = "无尽风暴",
	info = function(self, t)
		local damageinc = t.getLightningDamageIncrease(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		local daze = t.getDaze(self, t)
		return ([[在 你 周 围 生 成 一 股 风 暴， 增 加 你 %d%% 闪 电 伤 害 并 无 视 目 标 %d%% 闪 电 抵 抗。 
		 你 的 闪 电 术 和 连 锁 闪 电 同 时 会 增 加 %d%% 眩 晕 几 率， 并 且 闪 电 风 暴 也 会 增 加 %d%% 眩 晕 几 率。]])
		:format(damageinc, ressistpen, daze, daze / 2)
	end,
}


return _M
