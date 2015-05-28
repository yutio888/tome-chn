local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CELERITY",
	name = "迅捷",
	info = function(self, t)
		local speed = t.getSpeed(self, t) * 100
		local duration = t.getDuration(self, t)
		return ([[当 你 移 动 时 ，你 获 得  %d%%  移 动 速 度 ，持 续  %d  回 合 。   这 个 效 果 可 以 叠 加 三 次 ，每 回 合 只 能 触 发 一 次 。]]):format(speed, duration)
	end,
}

registerTalentTranslation{
	id = "T_TIME_DILATION",
	name = "时间膨胀",
	info = function(self, t)
		local speed = t.getSpeed(self, t) * 100
		local duration = t.getDuration(self, t)
		return ([[当 你 使 用 非 瞬 发 时 空 系 法 术 ， 你 获 得 %d%% 战 斗 、 施 法 和 精 神 速 度 ， 持 续  %d 回 合 。 这 个 效 果 可 以 叠 加 三 次 ， 每 回 合 只 能 触 发 一 次 。 
		]]):format(speed, duration)
	end,
}

registerTalentTranslation{
	id = "T_HASTE",
	name = "加速",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local speed = t.getSpeed(self, t) * 100
		return ([[增 加 你 的 整 体 速 度 %d%% ，持 续 %d 游 戏 回 合。]]):format(speed, duration)
	end,
}

registerTalentTranslation{
	id = "T_TIME_STOP",
	name = "时间停止",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local reduction = t.getReduction(self, t)
		return ([[获 得 %d 个 回 合 。 在 这 段 时 间 内， 你 造 成 的 伤 害 减 少 %d%% 。]]):format(duration, reduction)
	end,
}

return _M
