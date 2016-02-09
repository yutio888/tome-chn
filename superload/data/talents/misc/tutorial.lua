local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TUTORIAL_SPELL_KB",
	name = "魔法风暴",
	info =  function(self, t)
		local dist = self:getTalentLevel(t)
		return ([[施 放 一 股 强 力 的 魔 法 风 暴， 将 目 标 击 退 %d 码。]]):format(dist)
	end,
}
registerTalentTranslation{
	id = "T_TUTORIAL_MIND_KB",
	name = "念力打击",
	info =  function(self, t)
		return ([[使 用 念 力 将 目 标 击 退 的 一 次 强 力 打 击。]])
	end,
}
registerTalentTranslation{
	id = "T_TUTORIAL_SPELL_BLINK",
	name = "闪烁",
	info =  function(self, t)
		return ([[将 目 标 轻 微 的 传 送 至 远 处。]])
	end,
}
registerTalentTranslation{
	id = "T_TUTORIAL_MIND_FEAR",
	name = "恐惧",
	info =  function(self, t)
		return ([[尝 试 恐 惧 目 标 使 其 逃 跑。]])
	end,
}
registerTalentTranslation{
	id = "T_TUTORIAL_SPELL_BLEED",
	name = "流血",
	info =  function(self, t)
		return ([[制 造 10 回 合 的 流 血 效 果。]])
	end,
}
registerTalentTranslation{
	id = "T_TUTORIAL_MIND_CONFUSION",
	name = "混乱",
	info =  function(self, t)
		return ([[使 用 你 的 精 神 力 量 使 目 标 混 乱 5 回 合。]])
	end,
}

return _M
