local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_EMPOWER",
	name = "能量增幅",
	info = function(self, t)
		local power = t.getPower(self, t) * 100
		local talent = self:isTalentActive(t.id) and self:getTalentFromId(self:isTalentActive(t.id).talent).name or "None"
		return ([[强化指定的时空系法术，施放指定技能时法术强度增加  %d%%  。
		每个技能只能附加一种时空增效系效果。		
		当前强化法术： %s ]]):
		format(power, talent)
	end,
}

registerTalentTranslation{
	id = "T_EXTENSION",
	name = "法术延展",
	info = function(self, t)
		local power = t.getPower(self, t) * 100
		local talent = self:isTalentActive(t.id) and self:getTalentFromId(self:isTalentActive(t.id).talent).name or "None"
		return ([[强化指定的时空系法术，延展指定法术的持续时间  %d%%  。
		每个技能只能附加一种时空增效系效果。				
		当前强化法术： %s ]]):
		format(power, talent)
	end,
}

registerTalentTranslation{
	id = "T_MATRIX",
	name = "矩阵加速",
	info = function(self, t)
		local power = t.getPower(self, t) * 100
		local talent = self:isTalentActive(t.id) and self:getTalentFromId(self:isTalentActive(t.id).talent).name or "None"
		return ([[强化指定的时空系法术，减少指定法术的冷却时间 %d%% 。
		每个技能只能附加一种时空增效系效果。	
		当前强化法术： %s]]):
		format(power, talent)
	end,
}

registerTalentTranslation{
	id = "T_QUICKEN",
	name = "迅捷施法",
	info = function(self, t)
		local power = t.getPower(self, t) * 100
		local talent = self:isTalentActive(t.id) and self:getTalentFromId(self:isTalentActive(t.id).talent).name or "None"
		return ([[强化指定的时空系法术，减少施放指定法术需要的时间 %d%% 。
		每个技能只能附加一种时空增效系效。
		
		当前强化法术： %s  ]]):
		format(power, talent)
	end,
}


return _M
