local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ENERGY_DECOMPOSITION",
	name = "能量分解",
	info = function(self, t)
		local decomp = t.getDecomposition(self, t)
		return ([[分解一部分受到的伤害。减少 30%% 伤害 , 最多减少 %d 。
		受法术强度影响，减少伤害的最大值有额外加成。]]):format(decomp)
	end,
}

registerTalentTranslation{
	id = "T_ENERGY_ABSORPTION",
	name = "能量吸收",
	info = function(self, t)
		local talentcount = t.getTalentCount(self, t)
		local cooldown = t.getCooldown(self, t)
		return ([[你吸收目标的能量并化为己用，最多使 %d 个随机技能进入 %d 回合冷却。
		每使一个技能进入冷却，你可以减少你处于冷却中的技能的冷却时间 %d 回合。]]):
		format(talentcount, cooldown, cooldown)
	end,
}

registerTalentTranslation{
	id = "T_REDUX",
	name = "回响",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local cooldown = t.getMaxCooldown(self, t)
		return ([[接下来 %d 回合中，冷却时间不大于 %d 的技能，只需要一回合冷却。
对一个技能生效后，该效果将结束。
		]]):
		format(duration, cooldown)
	end,
}

registerTalentTranslation{
	id = "T_ENTROPY",
	name = "熵",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[接下来 %d 回合中，每回合解除目标的随机一个持续性技能。]]):format(duration)
	end,
}


return _M
