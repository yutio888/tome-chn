local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_PRISMATIC_SLASH",
	name = "五灵挥击",
	info = function(self, t)
		local burstdamage = t.getBurstDamage(self, t)
		local radius = self:getTalentRadius(t)
		local speed = t.getPassiveSpeed(self, t)
		return ([[向你的敌人释放原始的混乱元素攻击。 
		你有几率使用致盲之沙、缴械酸雾、冰结之息、震慑闪电或燃烧之焰攻击敌人，造成 %d%% 点对应伤害类型的武器伤害。 
		此外，无论你的元素攻击是否命中敌人你都会对 %d 码半径范围内的生物造成 %0.2f 伤害。 
		五灵挥击还会增加你的物理、法术和精神速度 %d%% 。
		如果你装备了盾牌，这一技能也会用你的盾牌攻击。]]):format(100 * self:combatTalentWeaponDamage(t, 1.2, 2.0), radius,burstdamage , 100*speed)
	end,
}

registerTalentTranslation{
	id = "T_VENOMOUS_BREATH",
	name = "剧毒吐息",
	message = "@Source@ 呼出剧毒!",
	info = function(self, t)
		local effect = t.getEffect(self, t)
		return ([[你向 %d 码锥形半径范围的敌人释放剧毒吐息。在攻击范围内的敌人，每回合会受到 %0.2f 自然伤害，持续 6 回合。 
		剧毒令目标有 %d%% 几率行动失败。 
		受力量影响，伤害有额外加成；技能暴击率基于精神暴击值计算。 
		每提升 1 级剧毒吐息同样增加你 4 ％自然抵抗。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.NATURE, t.getDamage(self,t)/6), effect)
	end,
}

registerTalentTranslation{
	id = "T_WYRMIC_GUILE",
	name = "龙之狡诈",
	info = function(self, t)
		return ([[你熟练掌握了巨龙的本性。 
		你的力量和意志增加 %d 。
		你获得 %d%% 击退抵抗和 %d%% 致盲、震慑抵抗。]]):format(t.getStat(self, t), 100*t.resistKnockback(self, t), 100*t.resistBlindStun(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CHROMATIC_FURY",
	name = "天龙之怒",
	info = function(self, t)
		return ([[你获得了世界中数不清的龙的力量传承，你对物理、火焰、寒冷、酸性、自然、枯萎和暗影属性伤害的抵抗力和适应力增强了。
		你对这些属性的 %0.1f%% ，使用这些属性的时候伤害提升 %0.1f%% ，获得 %0.1f%% 伤害穿透。

		学习这一技能还会给你的吐息技能伤害增加意志值加成。若你的这两项属性相等，则这相当于加成值翻倍。]]) 
		:format(t.getResists(self, t), t.getDamageIncrease(self, t), t.getResistPen(self, t))
	end,
}


return _M
