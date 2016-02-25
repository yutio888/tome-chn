
local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_AUTOMATED_REFLEX_SYSTEM",
	name = "自动化反射系统",
	require_special_desc ="当 前 或 之 前 的 角 色 在 当 前 难 度 与 模 式 下 解 锁 过 #{italic}#黑 客 帝 国#{normal}# 这 个 成 就。.",
	info = function(self, t)
		return ([[在 身 上 安 装 一 个 小 型 自 动 投 射 物 监 测 系 统。 每 当 一 个 投 射 物 即 将 击 中 你 时， 它 会 注 射 药 物 来 强 化 你 的 反 应 能 力， 给 你 一 个 额 外 回 合。
		这 个 效 果 最 短 每 5 回 合 触 发 一 次。]])
		:format()
	end,
}
return _M