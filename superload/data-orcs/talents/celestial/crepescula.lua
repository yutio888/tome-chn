local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TWILIT_ECHOES",
	name = "微 光 回 响",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local echo_dur = t.getEchoDur(self, t)
		local slow_per = t.getSlowPer(self, t)
		local slow_max = t.getSlowMax(self, t)
		local echo_factor = t.getDarkEcho(self, t)
		return ([[目 标 会 受 到 你 所 有 光 暗 伤 害 的 回 响, 持 续 %d 回合. 

每 点 光  伤 害 减 速 敌 人 %0.2f%% 持 续 %d 回 合, 在 %d 伤 害 时 达 到 最 大 值, 为 %d%% .
暗 系 伤 害 创 造 一 个 持 续 %d 回 合 的 地 块, 每 回 合 造 成 伤 害 的 %d%%. 当 有 另 一 个 微 光 回 响 激 活 或 目 标 持 续 承 受 此 伤 害 时, 将 刷 新 持 续 时 间, 剩 余 伤 害 和 新 承 受 的 伤 害 将 平 分 至 新 持 续 时 间 内.]])
		:format(duration, slow_per * 100, echo_dur, slow_max * 100, slow_max/slow_per, echo_dur, 100 * echo_factor)
	end,}
	
	return _M