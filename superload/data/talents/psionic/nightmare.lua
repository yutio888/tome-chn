local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_NIGHTMARE",
	name = "梦靥",
	info = function(self, t)
		local radius = self:getTalentRange(t)
		local duration = t.getDuration(self, t)
		local power = t.getSleepPower(self, t)
		local damage = t.getDamage(self, t)
		local insomnia = t.getInsomniaPower(self, t)
		return([[使 %d 码锥形范围内的目标进入持续 %d 回合的噩梦，令其无法行动。目标每承受 %d 点伤害减少一回合状态持续时间。 
		每回合目标会受到 %0.2f 暗影伤害。此伤害不会减少噩梦的状态持续时间。 
		当梦靥结束时，目标会饱受失眠的痛苦，持续回合等于已睡眠的回合数（但最多 10 回合），失眠状态的每一个剩余回合数会让目标获得 %d%% 睡眠免疫。 
		受精神强度影响，伤害临界点和精神伤害有额外加成。]]):format(radius, duration, power, damDesc(self, DamageType.DARKNESS, (damage)), insomnia)
	end,
}

registerTalentTranslation{
	id = "T_INNER_DEMONS",
	name = "心魔",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		return ([[使目标的心魔具象化。在 %d 回合内，每回合有 %d%% 的几率会召唤一个心魔，需要目标进行一次精神豁免鉴定，失败则心魔具象化。 
		如果目标处于睡眠状态，豁免概率减半，且无视目标的恐惧免疫。若目标豁免鉴定成功，则心魔的效果提前结束。 
		受精神强度影响，召唤几率按比例加成。 
		受目标分级影响，心魔的生命值有额外加成。
		心魔具现化时，会移除目标身上的所有睡眠类效果，本技能除外]]):format(duration, chance)
	end,
}

registerTalentTranslation{
	id = "T_WAKING_NIGHTMARE",
	name = "梦靥复苏",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		return ([[每回合造成 %0.2f 暗影伤害，持续 %d 回合，并且有 %d%% 几率随机造成致盲、震慑或混乱效果（持续 3 回合）。 
		如果目标处于睡眠状态，则其不受负面状态的几率减半。 
		受精神强度影响，伤害按比例加成。]]):
		format(damDesc(self, DamageType.DARKNESS, (damage)), duration, chance)
	end,
}

registerTalentTranslation{
	id = "T_NIGHT_TERROR",
	name = "梦靥降临",
	info = function(self, t)
		local damage = t.getDamageBonus(self, t)
		local summon = t.getSummonTime(self, t)
		return ([[增加 %d%% 你对睡眠状态目标的伤害和抵抗穿透效果。另外每当你杀死一个睡眠状态的目标，你可以召唤一只持续 %d 回合的暗夜恐魔。 
		受精神强度影响，伤害和暗夜恐魔的属性按比例加成。]]):format(damage, summon)
	end,
}


return _M
