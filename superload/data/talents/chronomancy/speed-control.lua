local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CELERITY",
	name = "迅捷",
	info = function(self, t)
		local speed = t.getSpeed(self, t) * 100
		local duration = t.getDuration(self, t)
		return ([[当你移动时，你获得  %d%%  移动速度，持续  %d  回合。   这个效果可以叠加三次，每回合只能触发一次。]]):format(speed, duration)
	end,
}

registerTalentTranslation{
	id = "T_TIME_DILATION",
	name = "时间膨胀",
	info = function(self, t)
		local speed = t.getSpeed(self, t) * 100
		local duration = t.getDuration(self, t)
		return ([[当你使用非瞬发时空系法术，你获得 %d%% 战斗、施法和精神速度，持续  %d 回合。这个效果可以叠加三次，每回合只能触发一次。 
		]]):format(speed, duration)
	end,
}

registerTalentTranslation{
	id = "T_HASTE",
	name = "加速",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local speed = t.getSpeed(self, t) * 100
		return ([[增加你的整体速度 %d%% ，持续 %d 游戏回合。]]):format(speed, duration)
	end,
}

registerTalentTranslation{
	id = "T_TIME_STOP",
	name = "时间停止",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local reduction = t.getReduction(self, t)
		return ([[获得 %d 个回合。在这段时间内，你造成的伤害减少 %d%% 。]]):format(duration, reduction)
	end,
}

return _M
