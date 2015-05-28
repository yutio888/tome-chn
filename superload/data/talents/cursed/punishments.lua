local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_REPROACH",
	name = "意念惩罚",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local spreadFactor = t.getSpreadFactor(self, t)
		return ([[你 对 任 何 敢 于 靠 近 的 敌 人 释 放 意 念 惩 罚， 造 成 %d 精 神 伤 害。 攻 击 可 能 会 指 向 多 个 目 标， 但 是 每 个 目 标 会 减 少 %d%% 伤 害。 
		25%% 概 率 附 加 思 维 封 锁 效 果。 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.MIND, damage), (1 - spreadFactor) * 100)
	end,
}

registerTalentTranslation{
	id = "T_HATEFUL_WHISPER",
	name = "憎恨私语",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local jumpRange = t.getJumpRange(self, t)
		local jumpCount = t.getJumpCount(self, t)
		local jumpChance = t.getJumpChance(self, t)
		local hateGain = t.getHateGain(self, t)
		return ([[你 向 周 围 的 敌 人 发 出 充 满 憎 恨 的 私 语。 第 1 个 听 到 的 敌 人 会 受 到 %d 点 精 神 伤 害 并 提 供 你 %d 仇 恨 值。 在 最 初 的 %d 回 合 里 私 语 会 从 目 标 身 上 传 播 到 %0.1f 码 半 径 范 围 新 的 敌 人 身 上。 
		 每 个 目 标 在 每 回 合 有 %d%% 几 率 将 私 语 传 播 向 另 一 个 目 标。 
		25%% 概 率 附 加 思 维 封 锁 效 果。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.MIND, damage), hateGain, jumpCount, jumpRange, jumpChance)
	end,
}

registerTalentTranslation{
	id = "T_AGONY",
	name = "极度痛苦",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local maxDamage = t.getDamage(self, t)
		local minDamage = maxDamage / duration
		return ([[对 你 的 目 标 释 放 极 大 的 痛 苦。 痛 苦 会 在 %d 回 合 内 逐 渐 增 加。 第 一 回 合 会 造 成 %d 点 伤 害 并 在 最 后 1 回 合 增 加 至 %d 点 伤 害（ 总 计 %d ）。 
		25%% 概 率 附 加 思 维 封 锁 效 果。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(duration, damDesc(self, DamageType.MIND, minDamage), damDesc(self, DamageType.MIND, maxDamage), maxDamage * (duration + 1) / 2)
	end,
}

registerTalentTranslation{
	id = "T_MADNESS",
	name = "精神崩溃",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local mindResistChange = t.getMindResistChange(self, t)
		return ([[每 次 你 造 成 精 神 伤 害 时， 有 %d%% 概 率 你 的 敌 人 必 须 用 精 神 抵 抗 抵 消 你 的 精 神 强 度， 否 则 会 崩 溃。 精 神 崩 溃 会 使 它 们 在 短 时 间 内 被 混 乱、 减 速 或 震 慑 3 回 合， 并 且 降 低 它 们 %d%% 对 精 神 伤 害 的 抵 抗。]]):format(chance, -mindResistChange)
	end,
}

return _M
