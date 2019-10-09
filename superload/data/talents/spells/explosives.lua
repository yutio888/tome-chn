local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_THROW_BOMB",
	name = "炸弹投掷",
	info = function(self, t)
		local ammo = self:hasAlchemistWeapon()
		local dam, damtype = 1, DamageType.FIRE
		if ammo then dam, damtype = t.computeDamage(self, t, ammo) end
		dam = damDesc(self, damtype, dam)
		return ([[向一块炼金宝石内灌输爆炸能量并扔出它。 
		 宝石将会爆炸并造成 %0.1f 的 %s 伤害。 
		 每个种类的宝石都会提供一个特殊的效果。 
		 受宝石品质和法术强度影响，伤害有额外加成。]]):format(dam, DamageType:get(damtype).name)
	end,
}

registerTalentTranslation{
	id = "T_ALCHEMIST_PROTECTION",
	name = "炼金保护",
	info = function(self, t)
		return ([[提高你和其他友好生物对自己炸弹 %d%% 的元素伤害抵抗，并增加 %d%% 对外界的元素伤害抵抗。 
		 在等级 5 时它同时会保护你免疫你的炸弹所带来的特殊效果。]]):
		format(math.min(100, self:getTalentLevelRaw(t) * 20), self:getTalentLevelRaw(t) * 3)
	end,
}

registerTalentTranslation{
	id = "T_EXPLOSION_EXPERT",
	name = "爆破专家",
	info = function(self, t)
		local min, max = t.minmax(self, t)
		return ([[炼金炸弹的爆炸半径现在增加 %d 码。
		 增加 %d%% （地形开阔）～ %d%% （地形狭窄）爆炸伤害。 ]]):
		format(t.getRadius(self, t), min*100, max*100) 
	end,
}

registerTalentTranslation{
	id = "T_SHOCKWAVE_BOMB",
	name = "烈性炸弹",
	info = function(self, t)
		local ammo = self:hasAlchemistWeapon()
		local dam, damtype = 1
		if ammo then dam = t.computeDamage(self, t, ammo) end
		dam = damDesc(self, DamageType.PHYSICAL, dam)
		return ([[将 2 颗炼金宝石压缩在一起，使它们变的极度不稳定。 
		 然后，你将它们扔到指定地点，爆炸会产生 %0.2f 物理伤害并击退爆炸范围内的任何怪物。 
		 每个种类的宝石都会提供一个特殊的效果。 
		 受宝石品质和法术强度影响，伤害有额外加成。]]):format(dam)
	end,
}


return _M
