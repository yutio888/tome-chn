local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RANGE_AMPLIFICATION_DEVICE",
	name = "射程增幅装置",
	require_special_desc ="光照范围为10或以上", 
	info = function(self, t)
		return ([[启 动 一 个 特 殊 的 聚 焦 装 置 来 使 你 的 所 有 远 程 魔 法 和 精 神 技 能 射 程 延 长 3 （ 仅 对 射 程 至 少 为 2 的 技 能 生 效 ， 且 上 限 为 1 0 ） 。
		使 用 这 个 装 置 非 常 的 费 力 ， 启 动 时 会 增 加 60%% 疲 劳 值 。]])
		:format()
	end,
}
return _M