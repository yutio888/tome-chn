local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DIRTY_FIGHTING",
	name = "卑劣攻击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 对 目 标 造 成 %d%% 伤 害， 试 图 震 慑 他。 如 果 你 的 攻 击 命 中 目 标， 则 会 使 目 标 震 慑 %d 回 合。 
		 受 你 的 命 中 影 响， 震 慑 概 率 有 额 外 加 成。 
		 如 果 你 震 慑 目 标 失 败 ( 或 者 对 震 慑 免 疫 )， 你 会 快 速 恢 复， 此 技 能 的 使 用 不 会 消 耗 回 合。]]):
		format(100 * damage, duration)
	end,
}

registerTalentTranslation{
	id = "T_BACKSTAB",
	name = "背刺",
	info = function(self, t)
		return ([[在 攻 击 震 慑 目 标 时， 你 有 很 大 的 优 势， 你 的 所 有 攻 击 会 提 高 %d%% 暴 击 率。 同 时， 你 的 近 战 攻 击 有 %d%% 几 率 震 慑 目 标 3 回 合。]]):
		format(t.getCriticalChance(self, t), t.getStunChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SWITCH_PLACE",
	name = "换位",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[通 过 一 系 列 的 战 术 和 策 略， 你 和 你 的 目 标 交 换 了 位 置。 
		 移 形 换 位 会 混 乱 你 的 目 标， 允 许 你 进 入 50%% 闪 避 状 态 %d 回 合。 
		 移 形 换 位 的 同 时， 你 的 武 器 会 连 接 你 的 目 标， 不 造 成 伤 害 但 会 触 发 武 器 特 效。]]):
		format(duration)
	end,
}

registerTalentTranslation{
	id = "T_CRIPPLE",
	name = "致残",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local speedpen = t.getSpeedPenalty(self, t)
		return ([[你 对 目 标 造 成 %d%% 的 伤 害。 
		 如 果 你 的 攻 击 命 中， 目 标 会 被 致 残 %d 回 合， 减 少 目 标 %d%% 近 战、 施 法 和 精 神 速 度。 
		 受 命 中 影 响， 技 能 命 中 率 有 额 外 加 成。 
		 受 灵 巧 影 响， 技 能 效 果 有 额 外 加 成。]]):
		format(100 * damage, duration, speedpen)
	end,
}


