local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TUTORIAL_SPELL_KB",
	name = "魔法风暴",
	info =  function(self, t)
		local dist = self:getTalentLevel(t)
		return ([[施放一股强力的魔法风暴，将目标击退 %d 码。]]):format(dist)
	end,
}
registerTalentTranslation{
	id = "T_TUTORIAL_MIND_KB",
	name = "念力打击",
	info =  function(self, t)
		return ([[使用念力将目标击退的一次强力打击。]])
	end,
}
registerTalentTranslation{
	id = "T_TUTORIAL_SPELL_BLINK",
	name = "闪烁",
	info =  function(self, t)
		return ([[将目标轻微的传送至远处。]])
	end,
}
registerTalentTranslation{
	id = "T_TUTORIAL_MIND_FEAR",
	name = "恐惧",
	info =  function(self, t)
		return ([[尝试恐惧目标使其逃跑。]])
	end,
}
registerTalentTranslation{
	id = "T_TUTORIAL_SPELL_BLEED",
	name = "流血",
	info =  function(self, t)
		return ([[制造 10 回合的流血效果。]])
	end,
}
registerTalentTranslation{
	id = "T_TUTORIAL_MIND_CONFUSION",
	name = "混乱",
	info =  function(self, t)
		return ([[使用你的精神力量使目标混乱 5 回合。]])
	end,
}

return _M
