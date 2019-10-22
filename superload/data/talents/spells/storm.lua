local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_NOVA",
	name = "闪电新星",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[一圈闪电从你身上放射出来，在 %d 码范围内对目标造成 %0.2f ～ %0.2f 闪电伤害（平均 %0.2f ）并有 75%% 概率眩晕敌人。 
		受法术强度影响，伤害有额外加成。]]):format(radius,
		damDesc(self, DamageType.LIGHTNING, damage / 3),
		damDesc(self, DamageType.LIGHTNING, damage),
		damDesc(self, DamageType.LIGHTNING, (damage + damage / 3) / 2))
	end,
}

registerTalentTranslation{
	id = "T_SHOCK",
	name = "闪电之击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[召唤一个闪电球对目标造成 %0.2f ～ %0.2f 闪电伤害（平均 %0.2f ）并眩晕目标 3 回合。 
		如果目标免疫了眩晕，则 5 回合内震慑和定身抗性减半。
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.LIGHTNING, damage / 3),
		damDesc(self, DamageType.LIGHTNING, damage),
		damDesc(self, DamageType.LIGHTNING, (damage + damage / 3) / 2))
	end,
}

registerTalentTranslation{
	id = "T_HURRICANE",
	name = "风暴之怒",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local chance = t.getChance(self, t)
		local radius = t.getRadius(self, t)
		return ([[每次你的闪电法术眩晕目标时，它会有 %d%% 的概率发生连锁反应，生成一个围绕目标 %d 码半径范围的飓风，持续 10 回合。 
		每回合该单位附近的所有生物会承受 %0.2f ～ %0.2f 闪电伤害（平均 %0.2f ）。 
		受法术强度影响，伤害有额外加成。]]):format(chance, radius,
		damDesc(self, DamageType.LIGHTNING, damage / 3),
		damDesc(self, DamageType.LIGHTNING, damage),
		damDesc(self, DamageType.LIGHTNING, (damage + damage / 3) / 2))
	end,
}

registerTalentTranslation{
	id = "T_TEMPEST",
	name = "无尽风暴",
	info = function(self, t)
		local damageinc = t.getLightningDamageIncrease(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		local daze = t.getDaze(self, t)
		return ([[在你周围生成一股风暴，增加你 %d%% 闪电伤害并无视目标 %d%% 闪电抵抗。 
		你的闪电术和连锁闪电同时会增加 %d%% 眩晕几率，并且闪电风暴也会增加 %d%% 眩晕几率。]])
		:format(damageinc, ressistpen, daze, daze / 2)
	end,
}


return _M
