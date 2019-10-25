local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SKATE",
	name = "极速滑行",
	info = function(self, t)
		return ([[用念力使自己漂浮。
		这使你能在战斗中快速滑行，增加你的移动速度 %d%% 。
		它同样使你更容易被推开 (-%d%% 击退抗性 )。]]): 
		format(t.getSpeed(self, t)*100, t.getKBVulnerable(self, t)*100) 
	end,
}

registerTalentTranslation{
	id = "T_QUICK_AS_THOUGHT",
	name = "灵动迅捷",
	info = function(self, t)
		local inc = t.speed(self, t)
		local percentinc = 100 * inc
		local boost = t.getBoost(self, t)
		return ([[用灵能围绕你的躯体，通过思想直接高效控制身体，而不是通过神经和肌肉。
		增加 %d 命中、 %0.1f%% 暴击率和 %d%% 攻击速度，持续 %d 回合。 
		受精神强度影响，持续时间有额外加成。]]):
		format(boost, 0.5*boost, percentinc, t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_MINDHOOK",
	name = "心灵钩爪",
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[用灵能将远处的敌人抓过来。
		至多对半径 %d 的敌人有效。
		范围和冷却时间受技能等级影响。]]):
		format(range)
	end,
}

registerTalentTranslation{
	id = "T_TELEKINETIC_LEAP",
	name = "灵能跳跃",
	message = "@Source@ 施展了灵能跳跃!",
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[使用灵能，精准地跳向 %d 码外的地点。]]):
		format(range)
	end,
}


return _M
