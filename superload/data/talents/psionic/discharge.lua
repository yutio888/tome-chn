local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MIND_STORM",
	name = "心灵风暴",
	info = function(self, t)
		local targets = t.getTargetCount(self, t)
		local damage = t.getDamage(self, t)
		local charge_ratio = t.getOverchargeRatio(self, t)
		return ([[用 你 的 潜 意 识 渗 透 周 围 的 环 境。 当 此 技 能 激 活 时， 每 回 合 你 会 射 出 %d 个 超 能 力 值 球 造 成 %0.2f 精 神 伤 害（ 每 个 敌 方 单 位 只 承 受 一 次 超 能 力 值 球 攻 击）。 每 个 超 能 力 值 球 消 耗 5 点 反 馈 值。 
		 当 获 得 的 反 馈 值 超 出 最 大 值 时， 你 会 产 生 额 外 的 超 能 力 值 球（ 每 超 出 %d 反 馈 值 产 生 1 个 超 能 力 值 球）， 但 是 每 回 合 产 生 的 额 外 超 能 力 值 球 数 量 不 会 超 过 %d 。 
		 此 技 能 运 用 了 灵 能 通 道， 所 以 当 你 移 动 时 会 中 断 此 技 能。 
		 受 精 神 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(targets, damDesc(self, DamageType.MIND, damage), charge_ratio, targets)
	end,
}

registerTalentTranslation{
	id = "T_FEEDBACK_LOOP",
	name = "反馈逆转",
	info = function(self, t)
		local duration = t.getDuration(self, t, true)
		return ([[激 活 以 逆 转 你 的 反 馈 值 衰 减， 持 续 %d 回 合。 此 技 能 激 活 时 可 产 生 暴 击 效 果， 效 果 为 增 加 技 能 持 续 时 间。 
		 你 必 须 在 反 馈 值 非 空 的 时 候 才 能 使 用 此 技 能（ 否 则 没 有 衰 减）。 
		 受 精 神 强 度 影 响， 反 馈 值 的 最 大 增 加 值 按 比 例 加 成。]]):format(duration)
	end,
}

registerTalentTranslation{
	id = "T_BACKLASH",
	name = "灵能反击",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local damage = t.getDamage(self, t)
		return ([[你 的 潜 意 识 会 报 复 那 些 伤 害 你 的 人。 
		 当 攻 击 者 在 %d 码 范 围 内 时， 你 会 对 目 标 造 成 伤 害， 伤 害 值 为 因 承 受 此 攻 击 而 获 得 的 反 馈 数 值 （但 不 超 过 %0.2f）。
		 此 效 果 每 回 合 对 同 一 生 物 最 多 只 能 触 发 1 次。
		 受 精 神 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(range, damDesc(self, DamageType.MIND, damage))
	end,
}

registerTalentTranslation{
	id = "T_FOCUSED_WRATH",
	name = "集火",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local crit_bonus = t.getCritBonus(self, t)
		return ([[将 注 意 力 集 中 于 单 体 目 标， 将 所 有 攻 击 性 灵 能 脉 冲 系 技 能 射 向 目 标， 持 续 %d 回 合。 当 此 技 能 激 活 时， 所 有 灵 能 脉 冲 系 技 能 增 加 %d%% 暴 击 伤 害。 
		 如 果 目 标 死 亡， 则 该 技 能 提 前 中 断。 
		 受 精 神 强 度 影 响， 暴 击 增 益 效 果 按 比 例 加 成。]]):format(duration, crit_bonus)
	end,
}


return _M
