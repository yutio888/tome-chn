local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TENTACLED_WINGS",
	name = "触手之翼",
	info = function(self, t)
		return ([[你向前方半径%d的锥形区域内发射触手。
		任何在范围内的敌人将会被触手缠绕并受到属性为枯萎的%d%%点武器伤害，如果攻击命中，该生物还会被拉向你。]]):
		format(self:getTalentRange(t), damDesc(self, DamageType.BLIGHT, t.getDamage(self, t) * 100))
	end,
}

registerTalentTranslation{
	id = "T_DECAYING_GROUNDS",
	name = "腐朽之地",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你使一个区域枯萎，把它们变成腐朽之地，持续%d回合。所有在其中的生物每回合受到%0.2f点枯萎伤害，并且所有技能冷却时间增加%d%%回合，持续3回合。
		伤害受你的法术强度或者精神强度两者中更高一方影响。]]):
		format(t.getDuration(self, t), damDesc(self, DamageType.DARKNESS, damage), t.getPower(self,t))
	end,
}

registerTalentTranslation{
	id = "T_AUGMENT_DESPAIR",
	name = "扩大绝望",
	info = function(self, t)
		return ([[你选取一个目标，将你的疯狂和仇恨灌注于它，扩大它的绝望。增加负面效果的持续时间%d回合，并且每有一个负面效果，造成%0.2f点枯萎伤害。(每个效果造成前一个效果75%%的伤害。)。
		伤害受你的法术强度或者精神强度两者中更高一方影响。]]):
		format(t.getDuration(self, t), damDesc(self, DamageType.BLIGHT, t.getDamage(self, t)))
	end,
}


registerTalentTranslation{
	id = "T_MAGGOT_BREATH",
	name = "蛆虫吐息",
	info = function(self, t)
		return ([[你向半径为%d的锥形区域内吐出一道由蛆虫尸体组成的波浪。任何在范围内的的目标会受到%0.2f 点枯萎伤害， 并且会被残废恶疾感染，持续10回合。
		残废恶疾减慢目标%d%%，并且每回合造成%0.2f点枯萎伤害。.
		伤害随法术强度增加而增加，暴击率基于法术暴击。]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.BLIGHT, t.getDamage(self, t)), t.getSlow(self, t) * 100, damDesc(self, DamageType.BLIGHT, t.getDiseaseDamage(self, t)))
	end,
}

return _M
