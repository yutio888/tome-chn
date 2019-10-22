local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_VIRULENT_DISEASE",
	name = "剧毒瘟疫",
	info = function(self, t)
		return ([[每当你造成一个非疾病的枯萎伤害时，你将会对目标施加一项疾病，每回合造成  %0.2f  枯萎伤害，持续 6 回合，并降低其一项物理能力值（力量、体质、敏捷） %d  。三种疾病可以叠加。
		剧毒瘟疫总是会使目标感染一项其所没有的疾病，并试图附加一项对目标有着最大负面效果的疾病。
		疾病会优先附加在目标周围感染疾病数量最多的单位身上。
		疾病效果随法术强度提升。]]):
		format(damDesc(self, DamageType.BLIGHT, 7 + self:combatTalentSpellDamage(t, 6, 45)), self:combatTalentSpellDamage(t, 5, 35))
	end,
}

registerTalentTranslation{
	id = "T_CYST_BURST",
	name = "瘟疫爆发",
	info = function(self, t)
		return ([[使目标的疾病爆发，每种疾病造成 %0.2f 枯萎伤害。 
		同时会向 %d 码半径范围内任意敌人散播衰老、虚弱、腐烂或传染性疾病，疾病的持续时间最少为6回合。
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 15, 115)), self:getTalentRadius(t))
		end,
}

registerTalentTranslation{
	id = "T_CATALEPSY",
	name = "僵硬瘟疫",
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[所有 %d 码球形范围内感染疾病的目标进入僵硬状态，震慑它们 %d 回合并立即爆发 %d%% 剩余所有疾病伤害。]]):
		format(radius, duration, damage * 100)
	end,
}

registerTalentTranslation{
	id = "T_EPIDEMIC",
	name = "传染病",
	info = function(self, t)
		return ([[使目标感染 1 种传染性极强的疾病，每回合造成 %0.2f 伤害，持续 6 回合。 
		如果目标受到非疾病造成的任何枯萎伤害，则感染者会自动向周围 2 码球形范围目标散播一种随机疾病。
		疾病传播概率受造成的枯萎伤害影响，且当枯萎伤害超过最大生命值 35%% 时必定传播。
		任何感染疾病单位同时会减少 %d%% 治疗效果和 %d%% 疾病免疫。 
		传染病是一种极强的疾病，以至于它可以完全忽略目标的疾病免疫。
		受法术强度影响，伤害有额外加成；受枯萎伤害影响，传染疾病的概率有额外加成。]]):
		format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 15, 70)), 40 + self:getTalentLevel(t) * 4, 30 + self:getTalentLevel(t) * 6)
	end,
}



return _M
