local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_EARTHEN_BARRIER",
	name = "奥术打击",
	info = function(self, t)
		return ([[使用你的主手武器打击两次目标，造成 %d%% 奥术伤害。
		如果任何一击命中目标，你获得 %d 法力值。
		法力值恢复受法术强度加成。]]):
		format(t.getDamage(self, t)*100, t.getMana(self, t))
	end,
}

registerTalentTranslation{
	id = "T_FIERY_HANDS",
	name = "燃烧之手",
	info = function(self, t)
		local firedamage = t.getFireDamage(self, t)
		local firedamageinc = t.getFireDamageIncrease(self, t)
		return ([[你的双手笼罩在火焰中，每次近战攻击会造成 %0.2f 火焰伤害并提高所有火焰伤害 %d%% 。 
		每次攻击同时也会回复 %0.2f 体力值。 
		受法术强度影响，效果有额外加成。]]):
		format(damDesc(self, DamageType.FIRE, firedamage), firedamageinc, self:getTalentLevel(t) / 3)
	end,
}


registerTalentTranslation{
	id = "T_SHOCK_HANDS",
	name = "闪电之触",
	info = function(self, t)
		local icedamage = t.getIceDamage(self, t)
		local icedamageinc = t.getIceDamageIncrease(self, t)
		return ([[你的双手笼罩在雷电中，每次近战攻击会造成 %d 闪电伤害（ 25%% 几率眩晕敌人），并提高 %d%% 所有闪电系伤害。 
		每次攻击同时也会回复 %0.2f 法力值。 
		受法术强度影响，效果有额外加成。]]):
		format(damDesc(self, DamageType.LIGHTNING, icedamage), icedamageinc, self:getTalentLevel(t) / 3)
	end,
}

registerTalentTranslation{
	id = "T_INNER_POWER",
	name = "心灵之力",
	info = function(self, t)
		local statinc = t.getStatIncrease(self, t)
		local absorb = t.getShield(self, t) * (100 + (self:attr("shield_factor") or 0)) / 100
		return ([[你专注于你的内心，增加你 %d 点力量，敏捷，魔法和灵巧。
		在你受到伤害前，你会产生一个吸收  %d  伤害的护盾，该效果最多每 %d 回合触发一次。
		属性值增长和护盾强度受法术强度加成。]]):
		format(statinc, absorb, self:getTalentCooldown(t) )
	end,
}


return _M
