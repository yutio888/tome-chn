local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TURN_BACK_THE_CLOCK",
	name = "时光倒流",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local damagestat = t.getDamageStat(self, t)
		return ([[制造一束时空能量波造成 %0.2f 时空伤害并降低目标三项最高属性值 %d 点，持续 3 回合。 
		受法术强度影响，伤害按比例加成。]]):format(damDesc(self, DamageType.TEMPORAL, damage), damagestat)
	end,
}

registerTalentTranslation{
	id = "T_TEMPORAL_FUGUE_OLD",
	name = "时空神游（旧）",
	info = function(self, t)
		local duration = t.getConfuseDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[将 %d 码锥形半径范围内敌人的心智降低到婴儿水平，混乱目标 ( %d%% 强度) %d 回合。 ]]):
		format(radius, t.getConfuseEfficency(self, t), duration)
	end,
}

registerTalentTranslation{
	id = "T_ASHES_TO_ASHES",
	name = "尘归尘",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[时空扭曲光环围绕着你（ %d 码半径范围），在 3 回合内对范围所有目标造成 %0.2f 累积时空伤害。效果持续 %d 回合。 
		 受法术强度影响，伤害按比例加成。]]):format(radius, damDesc(self, DamageType.TEMPORAL, damage), duration)
	end,
}

registerTalentTranslation{
	id = "T_BODY_REVERSION",
	name = "返老还童",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		local count = t.getRemoveCount(self, t)
		return ([[你的身体回复至先前状态，治疗自己 %0.2f 生命值并移除 %d 个物理状态（增益状态或负面状态）。 
		 受法术强度影响，生命回复按比例加成。]]):
		format(heal, count)
	end,
}

return _M
