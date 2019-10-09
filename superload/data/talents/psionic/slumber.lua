local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SLUMBER",
	name = "催眠",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local power = t.getSleepPower(self, t)
		local insomnia = t.getInsomniaPower(self, t)
		return([[目标进入持续 %d 回合的深睡眠，使其无法进行任何动作。目标每承受 %d 伤害，睡眠的持续时间减少一回合。 
		 当催眠结束时，目标会饱受失眠的痛苦，持续回合等于已睡眠的回合数（但最多 5 回合），失眠状态的每一个剩余回合数会让目标获得 %d%% 睡眠免疫。 
		 受精神强度影响，伤害临界点有额外加成。]]):format(duration, power, insomnia)
	end,
}

registerTalentTranslation{
	id = "T_RESTLESS_NIGHT",
	name = "不眠之夜",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return([[被你沉睡的目标在醒来时每行走一回合将承受 %0.2f 精神伤害，持续 5 回合。 
		 受精神强度影响，伤害按比例加成。]]):format(damDesc(self, DamageType.MIND, (damage)))
	end,
}

registerTalentTranslation{
	id = "T_SANDMAN",
	name = "睡魔",
	info = function(self, t)
		local power_bonus = t.getSleepPowerBonus(self, t) - 1
		local insomnia = t.getInsomniaPower(self, t)
		return([[增加 %d%% 你对被睡眠目标在睡眠回合减少前所能造成的伤害，并且减少 %d%% 你造成的失眠效果所增加的睡眠免疫。 
		 这些效果将即时反映在技能描述中。 
		 受精神强度影响，伤害临界点的增益效果按比例加成。]]):format(power_bonus * 100, insomnia)
	end,
}

registerTalentTranslation{
	id = "T_DREAMSCAPE",
	name = "梦境空间",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local power = t.getPower(self, t)
		return([[进入某个睡眠状态目标的梦境中，持续 %d 回合。 
		 当你位于梦境空间中时，你将会遇到目标无敌的睡眠形态，每 4 回合它会制造出 1 个梦境守卫来保护它的心灵。 
		 除非目标激活了清晰梦境，否则梦境守卫造成的普通伤害只有 50 ％。 
		 当梦境空间的效果结束时，你每摧毁一个梦境守卫，目标生命值会减少 10 ％，并且受到持续 1 回合的锁脑效果（可叠加）。 
		 在梦境空间中时，你的伤害会提高 %d%% 。 
		 受精神强度影响，伤害增益有额外加成。]]):format(duration, power)
	end,
}


return _M
