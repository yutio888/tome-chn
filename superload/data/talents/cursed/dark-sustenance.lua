local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FEED",
	name = "吸食精华",
	info = function(self, t)
		local hateGain = t.getHateGain(self, t)
		return ([[吸食敌人的精华。只要目标停留在视野里，你每回合会从其身上吸取 %0.1f 仇恨值。 
		如果你没有开启吸食精华，你会自动从最近的敌人身上吸食精华。
		受精神强度影响，怒气吸取量有额外加成。]]):format(hateGain)
	end,
}

registerTalentTranslation{
	id = "T_DEVOUR_LIFE",
	name = "吞噬生命",
	info = function(self, t)
		local regen = t.getLifeRegen(self, t)
		return ([[你的吸食效果会吸收目标的生命。降低目标 %d 的生命回复率，将一半的回复量加到自己身上。
		技能效果随精神强度提升。]]):format(regen)
	end,
}

registerTalentTranslation{
	id = "T_FEED_POWER",
	name = "强化吸食",
	info = function(self, t)
		local damageGain = t.getDamageGain(self, t)
		return ([[提高你的吸食能力，降低目标 %d%% 伤害并增加你自己同样数值的伤害。 
		受精神强度影响，效果有额外加成。]]):format(damageGain)
	end,
}

registerTalentTranslation{
	id = "T_FEED_STRENGTHS",
	name = "腐蚀吸食",
	info = function(self, t)
		local resistGain = t.getResistGain(self, t)
		return ([[提高你的吸食能力，降低目标 %d%% 负面状态抵抗并增加你同样数值的状态抵抗。 
		对“所有”抵抗无效。 
		受精神强度影响，效果有额外加成。]]):format(resistGain)
	end,
}



return _M
