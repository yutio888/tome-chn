local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WILD_GROWTH",
	name = "野性生长",
	info = function(self, t)
		local dur = t.getDur(self, t)
		return ([[使 你 自 身 周 围 环 绕 无 数 微 不 可 见、 有 治 疗 作 用 的 孢 子。 
		 作 用 于 你 身 上 的 任 何 回 复 效 果， 会 增 加 +%d 回 合 持 续 时 间。]]):
		format(dur)
	end,
}

registerTalentTranslation{
	id = "T_FUNGAL_GROWTH",
	name = "真菌生长",
	info = function(self, t)
		local p = t.getPower(self, t)
		return ([[强 化 你 的 孢 子 使 其 能 够 参 与 到 你 的 治 疗 作 用 中。 
		 每 当 你 受 到 治 疗 时， 你 会 得 到 一 个 持 续 6 回 合 的 回 复 效 果， 回 复 值 为 你 所 受 治 疗 值 的 %d%% 。 
		 受 精 神 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(p)
	end,
}

registerTalentTranslation{
	id = "T_ANCESTRAL_LIFE",
	name = "原始生命",
	info = function(self, t)
		local eq = t.getEq(self, t)
		local turn = t.getTurn(self, t)
		return ([[你 的 孢 子 可 以 追 溯 到 创 世 纪 元， 你 可 以 传 承 来 自 远 古 的 天 赋。  
		 每 当 一 个 新 的 回 复 效 果 作 用 到 你 身 上 时， 你 增 加 %d%% 的 增 益 回 合。  
		 同 时， 每 当 你 受 到 回 复 作 用 时， 每 回 合 你 的 失 衡 值 将 会 减 少 %0.1f 。 
		 受 精 神 强 度 影 响， 增 益 回 合 有 额 外 加 成。]]):
		format(turn, eq)
	end,
}

registerTalentTranslation{
	id = "T_SUDDEN_GROWTH",
	name = "疯狂成长",
	info = function(self, t)
		local mult = t.getMult(self, t)
		return ([[一 股 强 大 的 能 量 穿 过 你 的 孢 子， 使 其 立 刻 对 你 释 放 治 愈 性 能 量， 治 疗 你 %d%% 当 前 生 命 回 复 值。]]):
		format(mult * 100)
	end,
}


return _M
