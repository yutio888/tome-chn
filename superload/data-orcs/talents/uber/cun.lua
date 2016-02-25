
local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RAKSHOR_CUNNING",
	name = "拉克·肖的狡诈", 
	require_special_desc = "已经解锁了骷髅和尸鬼且不是亡灵。",
	info = function(self, t)
		return ([[准 备 一 个 应 对 死 亡 的 应 急 方 案。
	如 果 你 死 了 ， 你 可 以 选 择 从 死 亡 归 来 ， 代 价 则 是 你 将 随 机 成 为 一 个 骷 髅 或 者 尸 鬼。
	当 你 选 择 以 这 种 方 法 归 来 时 ， 你 会 失 去 你 的 种 族 技 能 树 并 收 回 其 中 一 半 的 点 数 ， 然 后 获 得 骷 髅 或 者 尸 鬼 的 种 族 技 能 树 。 
	作 为 一 个 亡 灵 ， 你 无 法 使 用 纹 身 。 你 会 在 转 化 时 失 去 所 有 的 纹 身。]])
		:format()
	end,
}
return _M