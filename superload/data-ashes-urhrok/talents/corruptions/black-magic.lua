local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_BLEAK_OUTCOME",
	name = "悲惨结局",
	info = function(self, t)
		return ([[你 的 一 举 一 动 都 是 敌 人 悲 惨 结 局 的 预 兆。
		每 次 你 造 成 暗 影 、 火 焰 、 枯 萎 或 酸 性 伤 害 时 ， 你 诅 咒 你 的 目 标 ， 最 多 叠 加 至 %d 次 （ 每 回 合 只 能 诅 咒 一 个 目 标 ）。
		每 有 一 层 诅 咒 ， 你 杀 死 被 诅 咒 目 标 时 获 得 的 活 力 值 增 加 100%% 。
		获 得 活 力 值 基 础 值 取 决 于 意 志 。]]):
		format(t.getStack(self, t))
	end,
}

	
registerTalentTranslation{
	id = "T_STRIPPED_LIFE",
	name = "生命剥夺",
	info = function(self, t)
		return ([[当 至 少 承 受 了 你 5 层 悲 惨 结 局 诅 咒 的 生 物 死 亡 时，你 尽 情 享 受 它 的 活 力，在 6 回 合 内 增 加 法 术 强 度 %d 点。]])
		:format(t.getSpellpowerIncrease(self, t))
	end,
}


registerTalentTranslation{
	id = "T_GRIM_FUTURE",
	name = "无情未来",
	info = function(self, t)
		return ([[对 你 的 敌 人 来 说 ， 未 来 非 常 无 情。
		每 次 你 杀 死 被 你 的 悲 惨 结 局 诅 咒 的 生 物 时 ， 该 生 物 半 径 %d 范 围 内 的 生 物 将 被 眩 晕 2 回 合 。
		这 个 效 果 每 %d 回 合 只 能 触 发 一 次( 只 计 算 眩 晕 成 功 的 回 合 )。]]):
		format(self:getTalentRadius(t), t.cooldown(self, t))
	end,
}


registerTalentTranslation{
	id = "T_OMINOUS_SHADOW",
	name = "不祥黑影",
	info = function(self, t)
		return ([[当 被 悲 惨 结 局 诅 咒 的 生 物 死 亡 时，你 获 得 一 个 不 祥 黑 影（至 多 %d 个），保 存 12 回 合。
		每 个 不 祥 黑 影 能 让 你 隐 身 2 回 合 ，隐 形 强 度 %d 。]]):
		format(t.getStack(self, t), t.getInvisibilityPower(self, t))
	end,
}


return _M
