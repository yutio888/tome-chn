local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GOLEM_KNOCKBACK",
	name = "击退",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你的傀儡冲向目标，将其击退并造成 %d%% 伤害。 
		受技能等级影响，击退几率有额外加成。]]):format(100 * damage)
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_TAUNT",
	name = "嘲讽",
	info = function(self, t)
		return ([[你的傀儡嘲讽 %d 码半径范围的敌人，强制他们攻击傀儡。]]):format(self:getTalentRadius(t)) 
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_CRUSH",
	name = "压碎",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getPinDuration(self, t)
		return ([[你的傀儡冲向目标，将其推倒在地持续 %d 回合，造成 %d%% 伤害。 
		受技能等级影响，定身几率有加成。]]):
		format(duration, 100 * damage)
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_POUND",
	name = "敲击",
	info = function(self, t)
		local duration = t.getDazeDuration(self, t)
		local damage = t.getGolemDamage(self, t)
		return ([[你的傀儡冲向目标，践踏周围 2 码范围，眩晕所有目标 %d 回合并造成 %d%% 伤害。 
		受技能等级影响，眩晕几率有额外加成。]]):
		format(duration, 100 * damage)
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_BEAM",
	name = "眼睛光束",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[从你的眼睛中发射一束光束，造成 %0.2f 火焰伤害， %0.2f 冰冷伤害或 %0.2f 闪电伤害。 
		该射线永远具有最大范围，并不会伤害友方单位。
		受傀儡的法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.FIRE, damage), damDesc(self, DamageType.COLD, damage), damDesc(self, DamageType.LIGHTNING, damage))
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_REFLECTIVE_SKIN",
	name = "反射皮肤",
	info = function(self, t)
		return ([[你的傀儡皮肤闪烁着艾尔德里奇能量。 
		所有对其造成的伤害有 %d%% 被反射给攻击者。 
		傀儡仍然受到全部伤害。 
		受傀儡的法术强度影响，伤害反射值有额外加成。]]):
		format(t.getReflect(self, t))
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_ARCANE_PULL",
	name = "奥术牵引",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local dam = t.getDamage(self, t)
		return ([[你的傀儡将 %d 码范围内的敌人牵引至身边，并造成 %0.2f 奥术伤害。]]):
		format(rad, dam)
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_MOLTEN_SKIN",
	name = "熔岩皮肤",
	info = function(self, t)
		return ([[使傀儡的皮肤变成灼热岩浆，发出的热量可以将 3 码范围内的敌人点燃，在 3 回合内每回合造成 %0.2f 灼烧伤害持续 %d 回合。 
		灼烧可叠加，他们在火焰之中持续时间越长受到伤害越高。 
		此外傀儡获得 %d%% 火焰抵抗。 
		熔岩皮肤不能影响傀儡的主人。 
		受法术强度影响，伤害和抵抗有额外加成。]]):format(damDesc(self, DamageType.FIRE, self:combatTalentSpellDamage(t, 12, 120)), 5 + self:getTalentLevel(t), 30 + self:combatTalentSpellDamage(t, 12, 60))
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_DESTRUCT",
	name = "自爆",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		return ([[傀儡引爆自己，摧毁傀儡并产生一个火焰爆炸， %d 码有效范围内造成 %0.2f 火焰伤害。 
		这个技能只有傀儡的主人死亡时能够使用。]]):format(rad, damDesc(self, DamageType.FIRE, 50 + 10 * self.level))
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_ARMOUR",
	name = "护甲掌握",
	info = function(self, t)
		local hardiness = t.getArmorHardiness(self, t)
		local armor = t.getArmor(self, t)
		local critreduce = t.getCriticalChanceReduction(self, t)
		local dir = self:getTalentLevelRaw(t) >= 3 and "In" or "De"
		return ([[傀儡学会重新组装重甲和板甲，以便更加适用于傀儡。 
		当装备重甲或板甲时， %s 增加护甲强度 %d 点 , 护甲韧性 %d%% ，并且减少 %d%% 暴击伤害。]]):
		format(dir, armor, hardiness, critreduce)
	end,
}

registerTalentTranslation{
	id = "T_DROLEM_POISON_BREATH",
	name = "毒性吐息",
	message = "@Source@ 呼出毒液!",
	info = function(self, t)
		return ([[ 对你的敌人喷吐毒雾，在几个回合内造成 %d 点伤害。受魔法影响，伤害有额外加成。]]):format(damDesc(self, DamageType.NATURE, self:combatTalentStatDamage(t, "mag", 30, 460)))
	end,
}


return _M
