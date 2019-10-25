local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SPIN_FATE",
	name = "命运之丝",
	info = function(self, t)
		local save = t.getSaveBonus(self, t)
		return ([[每当你要受到其他人造成的伤害时，你编织一层命运之丝，使你的闪避和豁免增加 %d ，持续三回合。
		这个效果每回合只能触发一次，丝能叠加三层 ( 加成最多为 %d ).]]):
		format(save, save * 3)
	end,
}

registerTalentTranslation{
	id = "T_SEAL_FATE",
	name = "命运封印",
	info = function(self, t)
		local procs = t.getProcs(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		return ([[激活这个技能封印命运 %d 回合。
		在这个技能激活期间，每当你对目标造成伤害，你获得一层命运之丝效果，并有 %d%% 几率延长目标的一个负面效果一回合。
		每层命运之茧将使负面状态延长的概率增加 33%% ( 三层效果时增加 %d%% 。 )
		负面状态延长每回合只能触发 %d 次，该效果获得的命运之丝每回合最多一层。]]):format(duration, chance, chance * 2, procs)
	end,
}

registerTalentTranslation{
	id = "T_FATEWEAVER",
	name = "命运编织",
	info = function(self, t)
		local power = t.getPowerBonus(self, t)
		return ([[现在每层命运之网使你获得 %d 命中，物理、法术和精神强度。]]):
		format(power)
	end,
}

registerTalentTranslation{
	id = "T_WEBS_OF_FATE",
	name = "命运之网",
	info = function(self, t)
		local power = t.getPower(self, t) * 100
		local duration = t.getDuration(self, t)
		return ([[接下来的 %d 回合中，你将受到的 %d%% 伤害转移给随机的敌人。
		当命运之网激活时，你每回合可以额外获得一层命运之丝，同时你的命运之丝上限翻倍。]])
		:format(duration, power)
	end,
}


return _M
