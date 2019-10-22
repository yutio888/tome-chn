local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RADIANT_FEAR",
	name = "恐惧辉耀",
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local duration = t.getDuration(self, t)
		return ([[恐惧 %d 码半径内的目标以驱逐他们，持续 %d 回合。]]):format(radius, duration)
	end,
}

registerTalentTranslation{
	id = "T_SUPPRESSION",
	name = "诅咒抑制",
	info = function(self, t)
		local percent = t.getPercent(self, t)
		return ([[长年对抗诅咒的经历使你能够自我控制。大部分非魔法效果的持续时间减少 %d%% 。]]):format(percent)
	end,
}

registerTalentTranslation{
	id = "T_CRUEL_VIGOR",
	name = "残酷活力",
	info = function(self, t)
		local speed = t.getSpeed(self, t)
		local duration = t.getDuration(self, t)
		return ([[你被周围的死亡所鼓舞。你每杀死一个单位提供你 %d%% 的速度，持续 %d 更多回合。]]):format(100 + speed, duration)
	end,
}

registerTalentTranslation{
	id = "T_PITY",
	name = "怜悯",
	info = function(self, t)
		local range = t.range(self, t)
		return ([[你收起可怕的本质伪装成可怜虫。那些在 %d 码外看到你的敌人将忽略你。 
		当你攻击或使用技能时，它们会看穿你的本质，怜悯技能将失效。]]):format(range)
	end,
}




return _M
