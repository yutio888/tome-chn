



















newTalentType{ type="tutorial", name = "tutorial", hide = true, description = "Tutorial-specific talents."
	info= function(self, t)
		return ([[将 目 标 击 退 一 码。]])
	end
name = "Mana Gale", short_name = "TUTORIAL_SPELL_KB"
	info= function(self, t)
		local dist = self:getTalentLevel(t)
		return ([[施 放 一 股 强 力 的 魔 法 风 暴， 将 目 标 击 退 %d 码。]]):format(dist)
	end
name = "Telekinetic Punt", short_name = "TUTORIAL_MIND_KB"
	info= function(self, t)
		return ([[使 用 念 力 将 目 标 击 退 的 一 次 强 力 打 击。]])
	end
name = "Blink", short_name = "TUTORIAL_SPELL_BLINK"
	info= function(self, t)
		return ([[将 目 标 轻 微 的 传 送 至 远 处。]])
	end
name = "Fear", short_name = "TUTORIAL_MIND_FEAR"
	info= function(self, t)
		return ([[尝 试 恐 惧 目 标 使 其 逃 跑。]])
	end
name = "Bleed", short_name = "TUTORIAL_SPELL_BLEED"
	info= function(self, t)
		return ([[制 造 10 回 合 的 流 血 效 果。]])
	end
name = "Confusion", short_name = "TUTORIAL_MIND_CONFUSION"
	info= function(self, t)
		return ([[使 用 你 的 精 神 力 量 使 目 标 混 乱 5 回 合。]])
	end

