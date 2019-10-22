local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_HEAVE",
	name = "前踢",
	info = function(self, t)
		return ([[一次强力的前踢使你的目标被击退 %d 码。 
		如果有另外一个怪物挡在路上，它也会被推开。 
		受敏捷或物理强度（取较大值）影响，击退概率有额外加成。]])
		:format(t.getDist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SLOW_MOTION",
	name = "子弹时间",
	info = function(self, t)
		return ([[你敏捷的身手允许你看见飞来的抛射物（法术、箭矢……），减慢它们 %d%% 速度。]]):
		format(math.min(90, 15 + self:getDex(10, true) * self:getTalentLevel(t)))
	end,
}


return _M
