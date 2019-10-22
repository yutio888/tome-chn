local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MIND_SEAR",
	name = "心灵光束",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[向前方发出一道心灵光束，摧毁范围内所有目标的神经系统，造成 %0.2f 精神伤害。 
		受精神强度影响，伤害有额外加成。]]):format(damDesc(self, DamageType.MIND, damage))
	end,
}

registerTalentTranslation{
	id = "T_PSYCHIC_LOBOTOMY",
	name = "精神切断",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local cunning_damage = t.getPower(self, t)/2
		local power = t.getConfuse(self, t)
		local duration = t.getDuration(self, t)
		return ([[造成 %0.2f 精神伤害，并摧毁目标的高级精神系统，降低 %d 灵巧并混乱目标（ %d%% 强度），持续 %d 回合。 
		受精神强度影响，伤害、灵巧降幅和混乱强度按比例加成。]]):
		format(damDesc(self, DamageType.MIND, (damage)), cunning_damage, power, duration)
	end,
}

registerTalentTranslation{
	id = "T_SYNAPTIC_STATIC",
	name = "心灵爆破",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 %d 码半径范围内释放一波心灵爆震，造成 %0.2f 精神伤害。此技能可以对目标附加锁脑效果。 
		受精神强度影响，伤害有额外加成。]]):format(radius, damDesc(self, DamageType.MIND, damage))
	end,
}

registerTalentTranslation{
	id = "T_SUNDER_MIND",
	name = "碾碎心灵",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local power = t.getDamage(self, t) / 10
		return ([[摧毁目标的思维，造成 %0.2f 精神伤害并且减少 %d 目标的精神豁免，持续 4 回合。 
		此技能必中且精神豁免削减效果可叠加。 
		若目标处于锁脑状态，则会产生双倍的伤害和豁免削减。 
		受精神强度影响，伤害和豁免削减按比例加成。]]):
		format(damDesc(self, DamageType.MIND, (damage)), power)
	end,
}


return _M
