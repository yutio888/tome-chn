local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SLIME_SPIT",
	name = "史莱姆喷射",
	info = function(self, t)
		return ([[向你的目标喷吐酸液造成 %0.1f 自然伤害并减速目标 30%% 3 回合。 
		酸液球可弹射到附近的某个敌方单位 %d 次。 
		弹射距离最多为 6 码，同时每弹一次会减少 %0.1f%% 伤害。
		受精神强度影响，伤害有额外加成。]]):format(damDesc(self, DamageType.NATURE, self:combatTalentMindDamage(t, 30, 250)), t.getTargetCount(self, t), 100-t.bouncePercent(self, t))
	end,
}

registerTalentTranslation{
	id = "T_POISONOUS_SPORES",
	name = "毒性孢子",
	message = "@Source@ 朝 @target@ 喷出毒性孢子。",
	info = function(self, t)
		return ([[向 %d 码半径范围释放毒性孢子，使范围内的敌方单位感染随机类型的毒素，造成 %0.1f 自然伤害，持续 10 回合。
		这个攻击能够暴击，造成额外 %d%% 暴击伤害。
		受精神强度影响，伤害和暴击加成有额外加成。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.NATURE, t.getDamage(self, t)), t.critPower(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ACIDIC_SKIN",
	name = "酸性皮肤",
	message = "@Source@ 的皮肤开始滴落酸液。",
	info = function(self, t)
		return ([[你的皮肤浸泡着酸液，对所有攻击你的目标造成 %0.1f 酸性缴械伤害。
		受精神强度影响，伤害有额外加成。]]):format(damDesc(self, DamageType.ACID, t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_SLIME_ROOTS",
	name = "史莱姆触手",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local radius = self:getTalentRadius(t)
		local talents = t.getNbTalents(self, t)
		return ([[你延伸史莱姆触手进入地下，然后在 %d 码范围内的指定位置出现（ %d 码误差）。
		释放此技能会导致你的身体结构发生轻微的改变，使 %d 个技能冷却完毕。]]):format(range, radius, talents)
	end,
}


return _M
