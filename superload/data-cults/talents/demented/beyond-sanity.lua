local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CHAOS_ORBS",	
	name = "混沌之球",
	info = function(self, t)
		return ([[你 操 控 诞 生 于 强 烈 疯 狂 中 的 混 沌 。
		每 当 触 发 一 次 强 度 大 于 %d 或 者 小 于 -%d 的 混 沌 效 果 ， 你 将 获 得 一 个 持 续 1 0 回 合 的 混 沌 之 球 （ 这 个 效 果 每 回 合 只 能 触 发 一 次 ）。
		每 个 混 沌 之 球 增 加 你 造 成 的 伤 害 3%% ， 总 共 可 以 获 得 %d 个 混 沌 之 球 。]]):
		format(t.getTrigger(self, t), t.getTrigger(self, t), t.getMax(self, t))
	end,
}
registerTalentTranslation{
	id = "T_ANARCHIC_WALK",	
	name = "混沌穿行",
	info = function(self, t)
		return ([[消 耗 2 个 混 沌 之 球 ， 令 你 朝 指 定 的 方 向 随 机 传 送 不 超 过 %d 格 的 距 离。 可 能 的 话， 你 被 传 送 的 最 短 距 离 为 %d 格 。]]):format(t.getMax(self, t), self:getTalentRange(t))
	end,
}
registerTalentTranslation{
	id = "T_DISJOINTED_MIND",	
	name = "意识粉碎",
	info = function(self, t)
		return ([[你 在 目 标 位 置 引 爆 混 沌 之 球 。
		这 场 爆 炸 不 造 成 伤 害， 但 是 会 使 目 标 混 乱 %d 回 合 ， 同 时 每 引 爆 一 个 球， 混 乱 强 度 增 加 10%% 。
		在 对 抗 目 标 的 精 神 豁 免 时 ， 每 个 混 乱 之 球 还 会 增 加 你 的 有 效 法 术 强 度10%% 。
		这 个 技 能 会 消 耗 所 有 的 混 乱 之 球。]]):
		format(t.getDur(self, t))
	end,
}
registerTalentTranslation{
	id = "T_CONTROLLED_CHAOS",	
	name = "混沌掌控",
	info = function(self, t)
		return ([[你 令 混 沌 力 量 朝 更 有 利 于 自 身 的 方 向 偏 移 。
		混 沌 效 果 产 生 的 最 大 负 面 影 响 从 50%% 减 少 至 %d%% 。
		你 可 以 主 动 开 启 该 技 能 ， 消 耗 所 有 混 沌 之 球， 每 消 耗 一 个 获 得 %d 疯 狂 值 。]]):
		format(t.getReduced(self, t), t.getInsanity(self, t))
	end,
}
return _M
