local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ENERGY_DECOMPOSITION",
	name = "能量分解",
	info = function(self, t)
		local decomp = t.getDecomposition(self, t)
		return ([[分 解 一 部 分 受 到 的 伤 害 。减 少  30%%  伤 害 ,  最 多 减 少  %d 。
		 受 法 术 强 度 影 响 ，减 少 伤 害 的 最 大 值 有 额 外 加 成 。]]):format(decomp)
	end,
}

registerTalentTranslation{
	id = "T_ENERGY_ABSORPTION",
	name = "能量吸收",
	info = function(self, t)
		local talentcount = t.getTalentCount(self, t)
		local cooldown = t.getCooldown(self, t)
		return ([[你 吸 收 目 标 的 能 量 并 化 为 己 用 ，最 多 使  %d  个 随 机 技 能 进 入  %d  回 合 冷 却 。
		 每 使 一 个 技 能 进 入 冷 却 ，你 可 以 减 少 你 处 于 冷 却 中 的 技 能 的 冷 却 时 间  %d  回 合 。]]):
		format(talentcount, cooldown, cooldown)
	end,
}

registerTalentTranslation{
	id = "T_REDUX",
	name = "回响",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local cooldown = t.getMaxCooldown(self, t)
		return ([[接 下 来 %d 回 合 中 ，冷 却 时 间 不 大 于 %d 的 技 能 ， 只 需 要 一 回 合 冷 却。
对 一 个 技 能 生 效 后 ， 该 效 果 将 结 束。
		]]):
		format(duration, cooldown)
	end,
}

registerTalentTranslation{
	id = "T_ENTROPY",
	name = "熵",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[接 下 来 %d 回 合 中 ， 每 回 合 解 除 目 标 的 随 机 一 个 持 续 性 技 能。]]):format(duration)
	end,
}


return _M
