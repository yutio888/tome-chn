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
		 受 法 术 强 度 影 响， 伤 害 按 比 例 加 成。]]):
		format(self:getTalentRange(t), targetcount, damDesc(self, DamageType.LIGHT, lightdamage), damDesc(self, DamageType.DARKNESS, darknessdamage))
	end,
}

registerTalentTranslation{
	id = "T_DARKEST_LIGHT",
	name = "无尽黑暗",
	info = function(self, t)
		local invisibilitypower = t.getInvisibilityPower(self, t)
		local convert = t.getEnergyConvert(self, t)
		local damage = t.getDamage(self, t)
		local radius = t.getRadius(self, t)
		return ([[这 个 强 大 的 技 能 提 供 你 %d 额 外 隐 形 等 级， 但 是 每 回 合 会 转 化 %d 负 能 量 至 正 能 量。 一 旦 你 的 正 能 量 超 过 负 能 量， 或 你 中 断 此 技 能， 此 效 果 会 终 止 并 产 生 光 系 爆 炸， 将 你 所 有 的 正 能 量 转 化 为 伤 害 并 对 所 有 敌 人 附 加 %0.2f 伤 害（ %d 码 有 效 范 围）。 
		 由 于 你 变 得 不 可 见， 你 脱 离 了 相 位 现 实， 你 的 所 有 伤 害 减 少 50%% 。 
		 当 此 技 能 激 活 时， 你 不 能 激 活 黄 昏 技 能 并 且 你 必 须 取 下 光 源， 否 则 你 仍 然 会 被 发 现。 
		 受 灵 巧 影 响， 隐 形 等 级 有 额 外 加 成； 受 法 术 强 度 影 响， 爆 炸 伤 害 有 额 外 加 成。]]):
		format(invisibilitypower, convert, damDesc(self, DamageType.LIGHT, damage), radius)
	end,
}

return _M
