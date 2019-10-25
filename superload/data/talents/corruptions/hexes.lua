local _M = loadPrevious(...)

registerTalentTranslation{
  id = "T_PACIFICATION_HEX",
  name = "宁神邪术",
	info = function(self, t)
		return ([[对目标施放邪术，眩晕它和 2 码球形范围内的一切，持续 3 回合。同时，每回合有 %d%% 概率再次眩晕目标，持续 20 回合。 
		受法术强度影响，概率有额外加成。]]):format(t.getchance(self,t))
	end,
}

registerTalentTranslation{
  id = "T_BURNING_HEX",
  name = "燃烧邪术",
	info = function(self, t)
		return ([[对目标施放邪术，诅咒它和 2 码球形范围内的一切，持续 20 回合。每次受影响的对象消耗资源（体力、法力、活力等）时，将会受到 %0.2f 点火焰伤害。 
		同时，对方使用的技能的冷却时间延长 %d%% +1 个回合。 
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.FIRE, self:combatTalentSpellDamage(t, 4, 90)), t.getCDincrease(self, t)*100)
	end,
}

registerTalentTranslation{
  id = "T_EMPATHIC_HEX",
  name = "转移邪术",
	info = function(self, t)
		return ([[对目标施放邪术，诅咒目标和 2 码球形范围内的一切。每当目标造成伤害时，它们也会受到 %d%% 相同伤害，持续 20 回合。 
		受法术强度影响，伤害有额外加成。]]):format(t.recoil(self,t))
	end,
}

registerTalentTranslation{
  id = "T_DOMINATION_HEX",
  name = "支配邪术",
	info = function(self, t)
		return ([[对目标施放邪术，使它成为你的奴隶，持续 %d 回合。 
		如果你对目标造成伤害，则目标会脱离诅咒。]]):format(t.getDuration(self, t))
	end,
}

return _M
