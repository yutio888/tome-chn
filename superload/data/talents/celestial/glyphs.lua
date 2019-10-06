local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GLYPHS",
	name = "圣印",
	info = function(self, t)
		local dam = t.getGlyphDam(self, t)
		local heal = t.getSunlightHeal(self, t)
		local numb = t.getMoonlightNumb(self, t)
		local numbDur = t.getMoonlightNumbDur(self, t)
		local dist = t.getTwilightKnockback(self, t)
		return ([[每 当 你 的 法 术 暴 击 时，你 消 耗 5 点 正 能 量 和 负 能 量 ， 在 范 围 %d 内 的 随 机 目 标  周 围 1 码 半 径 的 区 域 内 放 置 随 机 圣  印。
		圣 印 持 续 %d 回 合 ， 当 敌 人 踩 上 时 ， 会 对 其 产 生 特 殊 效 果 。
		圣 印 只 会 在 周 围 没 有 圣 印 的 敌 人 周 围 产 生 ， 并 且 会 尽 可 能 在 你 的 周 围 产 生 。
		每 %d 游 戏 回 合 最 多 触 发 一 次 该 效 果。
		圣 印 效 果 受 法 术 强 度 加 成 。
		
		有 以 下 几 种 可 用 的 圣 印：
		日 光 圣 印 —— 将 阳 光 注 入 圣 印 。 当 其 触 发 时 ， 将 会 释 放 出 明 亮 耀 眼 的 光 芒 ， 造 成 %0.2f 光 系 伤 害 ， 并 恢 复 你 %d 生 命 值 。
		月 光 圣 印 —— 将 月 光 注 入 圣 印 。 当 其 触 发 时 ， 将 会 释 放 出 疲 惫 困 倦 的 黑 暗 ， 造 成 %0.2f 暗 影 伤 害 ， 并 使 目 标 所 造 成 的 伤 害 减 少 %d%% ， 持 续 %d 回 合 。
		暮 光 圣 印 —— 将 暮 光 注 入 圣 印。 当 其 触 发 时，将 会 释 放 出 突 然 爆 炸 的 暮 光 ， 造 成 %0.2f 光 系 和 %0.2f 暗 影 伤 害 ， 并 将 目 标 击 退 %d 格。
		]]):format(self:getTalentRange(t), t.getDuration(self, t), t.getGlyphCD(self, t), 
			damDesc(self, DamageType.LIGHT, dam), heal,
			damDesc(self, DamageType.DARKNESS, dam), numb, numbDur,
			damDesc(self, DamageType.LIGHT, dam/2), damDesc(self, DamageType.DARKNESS, dam/2), dist)
	end,
}
registerTalentTranslation{
	id = "T_GLYPHS_OF_FURY",
	name = "愤怒之印",
	info = function(self, t)
		local dam = t.getTriggerDam(self, t)
		return ([[你 的 圣 印 被 注 入 了 来 自 天 空 的 怒 火 。
		它 们 的 持 续 时 间 延 长 %d 回 合 ， 并 在 触 发 时 造 成 额 外 伤 害。
		日 光 圣 印 ： 造 成 %0.2f 光 系 伤 害。
		月 光 圣 印 ： 造 成 %0.2f 暗 影 伤 害。
		暮 光 圣 印 ： 造 成 %0.2f 光 系 和  %0.2f 暗 影 伤 害 。]]):format(t.getPersistentDuration(self, t), damDesc(self, DamageType.LIGHT, dam), damDesc(self, DamageType.DARKNESS, dam), damDesc(self, DamageType.LIGHT, dam/2), damDesc(self, DamageType.DARKNESS, dam/2))
	end,
}
registerTalentTranslation{
	id = "T_DIVINE_GLYPHS",
	name = "神圣之印",
	info = function(self, t)
		return ([[当 你 的 圣 印 触 发 时 ， 天 空 能 量 的 涌 动 让 你 获 得 暗 影、光 系 抗 性 和 伤 害 吸 收 各 5%% ，持 续 %d 回 合 ， 最 多 叠 加 %d 次。 该 效 果 每 回 合 最 多 触 发 3 次。]]):format(t.getTurns(self, t), t.getMaxStacks(self, t))
	end,
}
registerTalentTranslation{
	id = "T_TWILIGHT_GLYPH",
	name = "暮光之印",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[你 放 置 一 枚 临 时 的 暮 光 之 印 ， 立 刻 造 成 %d 光 系 或 者 %d 暗 影 伤 害 并 随 之 消 散 。 伤 害 类 型 在 光 系 和 暗 影 之 间 轮 流 切 换 。
		你 可 以 连 续 使 用  %d  次 该 技 能 而 不 会 使 该 技 能 进 入 冷 却 ， 但 每 次 使 用 都 会 增 加 其 最 终 冷 却 时 间 2 回 合 。 当 触 发 次 数 达 到 上 限 ，或 你 在 1 回 合 内 没 有 使 用 这 个 技 能 时， 这 个 技 能 将 会 立 刻 进 入 冷 却。]]):format(damDesc(self, DamageType.LIGHT, dam), damDesc(self, DamageType.DARKNESS, dam), t.getConsecutiveTurns(self, t))
	end,
}
return _M
