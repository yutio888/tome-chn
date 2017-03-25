local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GESTURE_OF_PAIN",
	name = "痛苦手势",
	info = function(self, t)
		local baseDamage = t.getBaseDamage(self, t)
		local stunChance = t.getStunChance(self, t)
		local bonusDamage = t.getBonusDamage(self, t)
		local bonusCritical = t.getBonusCritical(self, t)
		return ([[使 用 痛 苦 手 势 来 代 替 通 常 攻 击， 对 你 的 敌 人 的 精 神 进 行 打 击， 造 成 %0.1f 到 %0.1f 点 精 神 伤 害。 如 果 攻 击 命 中， 有 %d%% 概 率 震 慑 你 的 目 标 3 个 回 合。 
		 这 项 攻 击 采 用 你 的 精 神 强 度 而 非 物 理 强 度， 同 时 需 检 查 对 方 精 神 豁 免。 这 项 攻 击 不 受 你 的 命 中 或 对 方 闪 避 影 响， 也 不 会 触 发 任 何 当 你 的 武 器 命 中 对 方 时 触 发 的 效 果。 但 是， 你 的 灵 晶 提 供 的 基 础 伤 害（ 按 双 倍 计 算） 和 暴 击 率 会 被 计 算 入 攻 击 中。 
		 这 项 技 能 需 要 你 空 手 或 双 持 灵 晶， 同 时 有 25%% 概 率 触 发 可 暴 击 的 锁 脑 效 果。
		 如 果 用 双 持 灵 晶 攻 击，能 够 触 发 命 中 效 果。
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。 
		 受 灵 晶 影 响， 增 加 %d 伤 害 和 %d%% 暴 击 率。]])
		:format(damDesc(self, DamageType.MIND, baseDamage * 0.5), damDesc(self, DamageType.MIND, baseDamage), stunChance, bonusDamage, bonusCritical)
	end,
}

registerTalentTranslation{
	id = "T_GESTURE_OF_MALICE",
	name = "怨恨手势",
	info = function(self, t)
		local resistAllChange = t.getResistAllChange(self, t)
		local duration = t.getDuration(self, t)
		return ([[使 你 的 痛 苦 手 势 充 满 怨 恨 的 诅 咒， 任 何 受 到 痛 苦 手 势 攻 击 的 目 标 会 降 低 %d%% 所 有 抵 抗， 持 续 %d 回 合。
		]]):format(-resistAllChange, duration)
	end,
}

registerTalentTranslation{
	id = "T_GESTURE_OF_POWER",
	name = "力量手势",
	info = function(self, t)
		local mindpowerChange = t.getMindpowerChange(self, t, 2)
		local mindCritChange = t.getMindCritChange(self, t)
		return ([[通 过 一 个 手 势 来 增 强 你 的 精 神 攻 击。 你 获 得 +%d 精 神 强 度 和 +%d%% 几 率 增 加 精 神 攻 击 的 暴 击 率（ 当 前 几 率 为 %d%% ）。 
		 需 要 至 少 一 只 空 手 或 者 装 备 灵 晶。 不 需 要 痛 苦 手 势 持 续 激 活。]]):format(mindpowerChange, mindCritChange, self:combatMindCrit())
	end,
}

registerTalentTranslation{
	id = "T_GESTURE_OF_GUARDING",
	name = "守护手势",
	info = function(self, t)
		local damageChange = t.getDamageChange(self, t, true)
		local counterAttackChance = t.getCounterAttackChance(self, t, true)
		return ([[ 你 通 过 手 势 来 防 御 近 战 伤 害。 只 要 你 能 使 用 手 势 （ 要 求 空 手 或 双 持 灵 晶 ）， 你 最 多 偏 移 %d 点 伤 害（ 你 的 单 手 最 大 伤 害 的 %0.1f%% ） ， 每 回 合 最 多 触 发 %0.1f 次 （ 基 于 你 的 灵 巧 ）。成 功 防 御 的 攻 击 不 会 暴 击。
		 如 果 痛 苦 手 势 被 激 活， 你 将 有 %0.1f%% 的 概 率 造 成 反 击 状 态。 ]]):
		format(damageChange, t.getGuardPercent(self, t), t.getDeflects(self, t, true), counterAttackChance)
	end,
}



return _M
