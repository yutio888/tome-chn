local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHADOW_COMBAT",
	name = "影之格斗",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[在你的武器上注入一股黑暗的能量，每次攻击会造成 %0.2f 暗影伤害。
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage))
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_CUNNING",
	name = "影之狡诈",
	info = function(self, t)
		local spellpower = t.getSpellpower(self, t)
		local bonus = self:getCun()*spellpower/100
		return ([[你的充分准备提高了你的魔法运用能力。增加相当于你 %d%% 灵巧的法术强度。目前的法术强度加成： %d]]):
		format(spellpower, bonus)
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_FEED",
	name = "暗影充能",
	info = function(self, t)
		local manaregen = t.getManaRegen(self, t)
		return ([[你学会从暗影中汲取能量。 
		当此技能激活时，每回合回复 %0.2f 法力值。 
		同时，你的攻击速度和施法速度获得 %0.1f%% 的提升。]]):
		format(manaregen, t.getAtkSpeed(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHADOWSTEP",
	name = "暗影突袭",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[通过阴影突袭你的目标，眩晕它 %d 回合并用你所有武器对目标造成 %d%% 暗影武器伤害。 
		被眩晕的目标受到显著伤害，但任何对目标的伤害会解除眩晕。 
		当你使用暗影突袭时，目标必须在视野范围内。]]):
		format(duration, t.getDamage(self, t) * 100)
	end,
}




return _M
