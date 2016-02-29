local _M = loadPrevious(...)


registerTalentTranslation{
	id = "T_SUBCUTANEOUS_METALLISATION",
	name = "金属内皮",
	info = function(self, t)
		return ([[当 你 的 生 命 值 降 到 总 生 命 的 50%% 以 下 时， 一 个 自 动 程 序 将 会 把 你 的 一 部 分 内 层 皮 肤 （或 别 的 什 么 器 官） 传 化 为 致 密 的 金 属 内 层 6 回 合。
		在 效 果 持 续 期 间， 你 受 到 的 所 有 伤 害 都 将 被 减 少 等 于 你 体 质 100%% 的 数 值。
		该 效 果 有 12 回 合 冷 却 时 间。]])
		:format()
	end,
}
return _M