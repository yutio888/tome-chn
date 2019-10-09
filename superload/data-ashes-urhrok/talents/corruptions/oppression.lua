local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_HORRIFYING_BLOWS",
	name = "恐惧打击",
	info = function(self, t)
	return ([[你的攻击能够惊吓目标，降低目标 %d%% 的伤害。 
	此效果可以叠加 %d 次，每次攻击会刷新持续时间。但是当目标与你距离超过 %d 码，恐惧效果会迅速消退。
	技能 3 级时，每次叠加会同时减少目标 %0.2f%% 的速度。
	技能 5 级时，可以影响到 %d 码内的所有敌对生物。
	此技能无视豁免和免疫。]])
	:format(t.getDamageReduction(self,t),t.getMaxStacks(self,t),t.getLeashRange(self, t),t.getSlowPower(self,t)*100,self:getTalentRadius(t))
	end,
}


registerTalentTranslation{
	id = "T_MASS_HYSTERIA",
	name = "恐惧之潮",
	info = function(self, t)
	return ([[增强目标的恐惧，目标身上每有一次恐惧叠加，效果增强 %d%% ，持续时间增大到 %d 回合。增强后的恐惧效果影响 %d 码内所有敌对生物。]]):format(t.getPowerBonus(self, t), t.getDurationBonus(self, t), self:getTalentRadius(t))
	end,
}


registerTalentTranslation{
	id = "T_FEARFEAST",
	name = "恐惧盛宴",
	info = function(self, t)
	return ([[汲取 %d 码内敌对生物身上的恐惧，每汲取一层恐惧，恢复 %d 生命并获得 %0.1f%% 额外回合。
	至多能获得 %0.1f 个额外回合。]])
	:format(self:getTalentRadius(t), t.getHeal(self, t), t.getEnergyDrain(self, t)*0.1, t.getEnergyCap(self, t) / 1000)
	end,
}

	
registerTalentTranslation{
	id = "T_HOPE_WANES",
	name = "绝望碾压",
	info = function(self, t)
	return ([[击溃已叠加至少 %d 层恐惧目标的精神，清除所有恐惧效果，使目标 %d 回合无法行动。
	此技能无视豁免和免疫。]]):format(t.getStackReq(self, t), t.getDuration(self, t))
	end,
}


return _M
