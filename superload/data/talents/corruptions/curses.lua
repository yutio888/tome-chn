local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CURSE_OF_DEFENSELESSNESS",
	name = "衰竭诅咒",
	info = function(self, t)
		return ([[诅咒目标，减少它 %d 点闪避和所有豁免，持续 5 回合。这一效果不能豁免。
		受法术强度影响，效果有额外加成。]]):format(self:combatTalentSpellDamage(t, 30, 60))
	end,
}

registerTalentTranslation{
	id = "T_CURSE_OF_IMPOTENCE",
	name = "虚弱诅咒",
	info = function(self, t)
		return ([[诅咒目标，减少它 %d%% 所有伤害，持续 10 回合。 
		受法术强度影响，伤害值有额外减少。]]):format(t.imppower(self,t))
	end,
}

registerTalentTranslation{
	id = "T_CURSE_OF_DEATH",
	name = "死亡诅咒",
	info = function(self, t)
		return ([[诅咒目标，阻止其生命值自然恢复，并在10回合内造成 %0.2f点暗影伤害。
		受法术强度影响，伤害有额外加成。]]):format(damDesc(self, DamageType.DARKNESS, self:combatTalentSpellDamage(t, 10, 70)*10))
	end,
}

registerTalentTranslation{
	id = "T_CURSE_OF_VULNERABILITY",
	name = "弱点诅咒",
	info = function(self, t)
		return ([[诅咒目标，减少其 %d%% 所有抵抗，持续 7 回合。 
		受法术强度影响，效果有额外加成。]]):format(self:combatTalentSpellDamage(t, 10, 40))
	end,
}



return _M
