local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GLACIAL_VAPOUR",
	name = "寒霜冰雾",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[在 3 码 半 径 范 围 内 升 起 一 片 寒 冷 的 冰 雾， 每 回 合 造 成 %0.2f 冰 冷 伤 害， 持 续 %d 回 合。 
		 处 于 湿 润 状 态 的 生 物 承 受 额 外 30%% 伤 害， 并 有 15%% 几 率 被 冻 结。
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.COLD, damage), duration)
	end,
}

registerTalentTranslation{
	id = "T_FREEZE",
	name = "冻结",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[凝 聚 周 围 的 水 冻 结 目 标 %d 回 合 并 对 其 造 成 %0.2f 伤 害。 
		 如 果 目 标 为 友 好 生 物 ， 冷 却 时 间 减 半。
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(t.getDuration(self, t), damDesc(self, DamageType.COLD, damage))
	end,
}

registerTalentTranslation{
	id = "T_TIDAL_WAVE",
	name = "潮汐",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[以 施 法 者 为 中 心， 在 1 码 半 径 范 围 内 生 成 一 股 巨 浪， 每 回 合 增 加 1 码 半 径 范 围， 最 大 %d 码。 
		 对 目 标 造 成 %0.2f 冰 冷 伤 害 和 %0.2f 物 理 伤 害， 同 时 击 退 目 标， 持 续 %d 回 合。 
		 所 有 受 影 响 的 生 物 进 入 湿 润 状 态 ， 震 慑 抗 性 减 半。
		 受 法 术 强 度 影 响， 伤 害 和 持 续 时 间 有 额 外 加 成。]]):
		format(radius, damDesc(self, DamageType.COLD, damage/2), damDesc(self, DamageType.PHYSICAL, damage/2), duration)
	end,
}

registerTalentTranslation{
	id = "T_SHIVGOROTH_FORM",
	name = "寒冰之体",
	info = function(self, t)
		local power = t.getPower(self, t)
		local dur = t.getDuration(self, t)
		return ([[你 吸 收 周 围 的 寒 冰 围 绕 你， 将 自 己 转 变 为 纯 粹 的 冰 元 素 — — 西 码 罗 斯， 持 续 %d 回 合。 
		 转 化 成 元 素 后， 你 不 需 要 呼 吸 并 获 得 等 级 %d 的 冰 雪 风 暴， 所 有 冰 冷 伤 害 可 对 你 产 生 治 疗， 治 疗 量 基 于 伤 害 值 的 %d%% 。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(dur, self:getTalentLevelRaw(t), power * 100, power * 100 / 2, 50 + power * 100)
	end,
}

registerTalentTranslation{
	id = "T_ICE_STORM",
	name = "冰雪风暴",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[召 唤 一 股 激 烈 的 暴 风 雪 围 绕 着 施 法 者， 在 3 码 范 围 内 每 回 合 对 目 标 造 成 %0.2f 冰 冷 伤 害， 持 续 %d 回 合。 
		 它 有 25%% 概 率 冰 冻 受 影 响 目 标。 
		 如 果 目 标 处 于 湿 润 状 态 ， 伤 害 增 加 30%% ， 同 时 冻 结 率 上 升 至 50%% 。
		 受 法 术 强 度 影 响， 伤 害 和 持 续 时 间 有 额 外 加 成。]]):format(damDesc(self, DamageType.COLD, damage), duration)
	end,
}


return _M
