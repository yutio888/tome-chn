local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STALK",
	name = "跟踪",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[当 你 连 续 两 回 合 持 续 近 战 攻 击 同 一 个 目 标 时， 你 将 憎 恨 目 标 并 追 踪 目 标， 效 果 持 续 %d 回 合 或 直 到 目 标 死 亡。 
		 你 每 回 合 攻 击 追 踪 目 标 都 将 获 得 可 叠 加 增 益 效 果， 该 效 果 在 你 不 攻 击 会 减 少 1 重 效 果。 
		1 重 增 益 : +%d 命 中， +%d%% 近 战 伤 害， 当 目 标 被 击 中 时， 每 回 合 增 加 +%0.2f 仇 恨 值。 
		2 重 增 益 : +%d 命 中， +%d%% 近 战 伤 害， 当 目 标 被 击 中 时， 每 回 合 增 加 +%0.2f 仇 恨 值。 
		3 重 增 益 : +%d 命 中， +%d%% 近 战 伤 害， 当 目 标 被 击 中 时， 每 回 合 增 加 +%0.2f 仇 恨 值。 
		 受 意 志 影 响， 命 中 有 额 外 加 成。 
		 受 力 量 影 响， 近 战 伤 害 有 额 外 加 成。]]):format(duration,
		t.getAttackChange(self, t, 1), t.getStalkedDamageMultiplier(self, t, 1) * 100 - 100, t.getHitHateChange(self, t, 1),
		t.getAttackChange(self, t, 2), t.getStalkedDamageMultiplier(self, t, 2) * 100 - 100, t.getHitHateChange(self, t, 2),
		t.getAttackChange(self, t, 3), t.getStalkedDamageMultiplier(self, t, 3) * 100 - 100, t.getHitHateChange(self, t, 3))
	end,
}

registerTalentTranslation{
	id = "T_BECKON",
	name = "引诱思维",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		local spellpowerChange = t.getSpellpowerChange(self, t)
		local mindpowerChange = t.getMindpowerChange(self, t)
		return ([[捕 猎 者 和 猎 物 之 间 的 联 系 能 让 你 给 予 目 标 思 想 暗 示 , 引 诱 他 们 更 靠 近 你。 
		 在 %d 回 合 内， 目 标 会 试 图 接 近 你， 甚 至 推 开 路 径 上 的 其 他 单 位。 
		 每 回 合 有 %d%% 的 几 率， 它 们 会 取 消 原 有 动 作 并 直 接 向 你 走 去。 
		 目 标 受 到 致 命 攻 击 时 可 能 会 打 断 该 效 果， 此 效 果 会 减 少 目 标 注 意 力， 在 它 们 到 达 你 所 在 位 置 之 前， 降 低 其 %d 点 法 术 强 度 和 精 神 强 度。 
		 受 意 志 影 响， 法 术 强 度 和 精 神 强 度 的 降 低 效 果 有 额 外 加 成。]]):format(duration, chance, -spellpowerChange)
	end,
}

registerTalentTranslation{
	id = "T_HARASS_PREY",
	name = "痛苦折磨",
	info = function(self, t)
		local damageMultipler = t.getDamageMultiplier(self, t)
		local cooldownDuration = t.getCooldownDuration(self, t)
		local targetDamageChange = t.getTargetDamageChange(self, t)
		local duration = t.getDuration(self, t)
		return ([[用 两 次 快 速 的 攻 击 折 磨 你 追 踪 的 目 标 , 每 次 攻 击 造 成 %d%% （ 0 仇 恨） ～ %d%% （ 100+ 仇 恨） 的 伤 害。 并 且 每 次 攻 击 都 将 中 断 目 标 某 项 技 能 或 符 文， 持 续 %d 回 合。 目 标 会 因 为 你 的 攻 击 而 气 馁， 它 的 伤 害 降 低 %d%% ， 持 续 %d 回 合。 
		 受 意 志 影 响， 伤 害 降 低 有 额 外 加 成。]]):format(t.getDamageMultiplier(self, t, 0) * 100, t.getDamageMultiplier(self, t, 100) * 100, cooldownDuration, -targetDamageChange, duration)
	end,
}

registerTalentTranslation{
	id = "T_SURGE",
	name = "杀意涌动",
	info = function(self, t)
		local movementSpeedChange = t.getMovementSpeedChange(self, t)
		local defenseChange = t.getDefenseChange(self, t, true)
		return ([[让 杀 意 激 发 你 敏 捷 的 身 手 , 提 高 你 %d%% 移 动 速 度。 不 顾 一 切 的 移 动 会 带 给 你 厄 运 (-3 幸 运 )。 
		 分 裂 攻 击、 杀 意 涌 动 和 无 所 畏 惧 不 能 同 时 开 启， 并 且 激 活 其 中 一 个 也 会 使 另 外 两 个 进 入 冷 却。 
		 你 的 移 动 速 度 与 双 武 器 提 供 的 完 美 平 衡， 使 你 在 双 持 的 同 时 闪 避 增 加 %d 点。 
		 受 意 志 影 响， 移 动 速 度 和 双 持 时 的 闪 避 增 益 有 额 外 加 成。]]):format(movementSpeedChange * 100, defenseChange)
	end,
}



return _M
