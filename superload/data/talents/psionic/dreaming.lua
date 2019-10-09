local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SLEEP",
	name = "入梦",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		local power = t.getSleepPower(self, t)
		local insomnia = t.getInsomniaPower(self, t)
		return([[使 %d 码半径范围内的目标陷入 %d 回合的睡眠状态中，使它们无法行动。它们每承受 %d 点伤害，睡眠的持续时间减少一回合。 
		 当睡眠结束时，目标会饱受失眠的痛苦，持续回合等于已睡眠的回合数（但最多 10 回合），失眠状态的每一个剩余回合数会让目标获得 %d%% 睡眠免疫。 
		 在等级 5 时，睡眠会具有传染性，每回合有 25 ％几率传播向附近的目标。 
		 受精神强度影响，伤害临界点按比例加成。]]):format(radius, duration, power, insomnia)
	end,
}

registerTalentTranslation{
	id = "T_LUCID_DREAMER",
	name = "清晰梦境",
	info = function(self, t)
		local power = t.getPower(self, t)
		return ([[你进入清晰梦境。在此状态下，你虽然处于睡眠状态但仍可以行动，并且对失眠免疫，对失眠状态下的目标附加 %d%% 伤害，同时，你的物理、法术和精神豁免增加 %d 点。 
		 注意在睡眠状态下会使你降低对特定负面状态的抵抗（例如心魔，暗夜恐惧和梦靥行者）。 
		 受精神强度影响，豁免增益效果按比例加成。]]):format(power, power)
	end,
}

registerTalentTranslation{
	id = "T_DREAM_WALK",
	name = "梦境穿梭",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[你穿越梦境，出现在某个目标地点附近。
		 如果目标为处于睡眠状态的生物，你将会出现在离目标最近的地方。
		 否则，你会出现在目标位置的 %d 码范围内。]]):format(radius)
	end,
}

registerTalentTranslation{
	id = "T_DREAM_PRISON",
	name = "梦境牢笼",
	info = function(self, t)
		local drain = t.getDrain(self, t)
		return ([[将范围内所有睡眠状态的目标囚禁在梦境牢笼里，有效地延长他们的睡眠效果，这个强大的技能每回合会持续消耗 %d%% 最大超能力值（本技能除外），并且运用了灵能通道，所以当你移动时会中断此技能。 
		 注意：每回合可产生的睡眠附加状态，如梦靥的伤害和入梦的传染效果，将在此效果持续过程中失效。]]):format(drain)
	end,
}


return _M
