local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_BLOOD_RED_MOON",
	name = "血月唤醒",
	info = function(self, t)
		return ([[增 加 你 %d%% 法 术 暴 击 率。]]):
		format(t.getCrit(self, t))
	end,
}

registerTalentTranslation{
	id = "T_TOTALITY",
	name = "日全食",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local penetration = t.getResistancePenetration(self, t)
		local cooldownreduction = t.getCooldownReduction(self, t)
		return ([[增 加 %d%% 光 系 和 暗 影 系 抵 抗 穿 透， 持 续 %d 回 合。 同 时， 减 少 你 所 有 天 空 系 技 能 冷 却 时 间 %d 回 合 至 冷 却。 
		 受 灵 巧 影 响， 抵 抗 穿 透 有 额 外 加 成。]]):
		format(penetration, duration, cooldownreduction)
	end,
}

registerTalentTranslation{
	id = "T_CORONA",
	name = "日冕",
	info = function(self, t)
		local targetcount = t.getTargetCount(self, t)
		local lightdamage = t.getLightDamage(self, t)
		local darknessdamage = t.getDarknessDamage(self, t)
		return ([[每 当 你 的 法 术 打 出 暴 击 时， 你 会 对 %d 码 内 %d 个 目 标 发 射 一 颗 光 球 或 暗 影 球， 造 成 %0.2f 光 系 或 %0.2f 暗 影 伤 害。 
		 每 个 球 都 会 消 耗 2 点 正 能 量 或 负 能 量， 当 你 的 正 能 量 或 负 能 量 低 于 2 时 不 会 触 发。 
		 受 法 术 强 度 影 响， 伤 害 按 比 例 加 成。
		 这 一 法 术 不 能 暴 击 。]]):
		format(self:getTalentRange(t), targetcount, damDesc(self, DamageType.LIGHT, lightdamage), damDesc(self, DamageType.DARKNESS, darknessdamage))
	end,
}

registerTalentTranslation{
	id = "T_DARKEST_LIGHT",
	name = "无尽黑暗",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local dotDam = t.getDotDamage(self, t)
		local conversion = t.getConversion(self, t)
		local duration = t.getDuration(self, t)
		return ([[用 无 尽 黑 暗 包 围 半 径 %d 范 围 内 的 所 有 敌 人 ， 每 回 合 对 其 造 成 %0.2f 光 系 和 %0.2f 暗 影 伤 害 ， 并 将 它 们 所 造 成 的 伤 害 的 %d%% 转 化 为 光 系 和 暗 影 伤 害 ， 持 续 %d 回 合 。]]):format(radius, damDesc(self, DamageType.LIGHT, dotDam), damDesc(self, DamageType.DARKNESS, dotDam), conversion*100, duration)
	end,
}

return _M
