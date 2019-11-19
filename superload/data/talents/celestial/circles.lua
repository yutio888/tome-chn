local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CIRCLE_OF_SHIFTING_SHADOWS",
	name = "暗影之阵",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在你的脚下创造一个 %d 码半径范围的阵法，它会提高你 %d 近身闪避和所有豁免，并对周围目标造成 %0.2f 暗影伤害。 
		阵法持续 %d 回合。 
		受法术强度影响，伤害有额外加成。 ]]):
		format(radius, damage, (damDesc (self, DamageType.DARKNESS, damage)), duration)
	end,
}

registerTalentTranslation{
	id = "T_CIRCLE_OF_SANCTITY",
	name = "圣洁之阵",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		return ([[在你的脚下制造一个 %d 码半径范围的法阵，当你在法阵内，它会使你免疫沉默效果，沉默进入此范围内的敌人，并对其造成 %d 光系伤害。
		阵法持续 %d 回合。]]):
		format(radius, damDesc(self, DamageType.LIGHT, damage), duration)
	end,
}

registerTalentTranslation{
	id = "T_CIRCLE_OF_WARDING",
	name = "守护之阵",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在你的脚下制造一个 %d 码半径范围的法阵，它会减慢 %d%% 抛射物速度并将除你外的其他生物推出去。 
		同时，每回合对目标造成 %0.2f 光系伤害和 %0.2f 暗影伤害。 
		法阵持续 %d 回合。 
		受法术强度影响，效果有额外加成。]]):
		format(radius, damage*5, (damDesc (self, DamageType.LIGHT, damage)), (damDesc (self, DamageType.DARKNESS, damage)), duration)
	end,
}

registerTalentTranslation{
	id = "T_CELESTIAL_SURGE",
	name = "天体潮涌",
	info = function(self, t)
		return ([[从你的法阵中召唤天体能量的潮涌。任何站在你的法阵中的敌人将会受到持续%d回合的%d%%减速效果，并受到 %d 光系和 %d 黑暗伤害。
		能量潮涌的残余力量将会从你的法阵中发出。在 %d 回合内，你每站在一个法阵中，都会获得额外的天体能量恢复。
		暗影之阵：获得 +1 负能量。
		圣洁之阵：获得 +1 正能量。
		守护之阵：获得 +0.5 正能量和负能量。]]):format(t.getSlowDur(self, t),t.getSlow(self, t), damDesc(self, DamageType.LIGHT, t.getDamage(self, t)), damDesc(self, DamageType.DARKNESS, t.getDamage(self, t)), t.getDuration(self, t))
	end,
}

return _M
