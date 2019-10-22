local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_BLASTWAVE",
	name = "火焰新星",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[从你身上释放出一波 %d 码半径范围的火焰，击退范围内所有目标并使它们进入 3 回合灼烧状态，共造成 %0.2f 火焰伤害。 
		受法术强度影响，伤害有额外加成。]]):format(radius, damDesc(self, DamageType.FIRE, damage))
	end,
}

registerTalentTranslation{
	id = "T_BURNING_WAKE",
	name = "无尽之炎",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你的火球术、火焰冲击、爆裂火球和火焰新星都会在地上留下燃烧的火焰，每回合对经过者造成 %0.2f 火焰伤害，持续 4 回合。 
		受法术强度影响，伤害有额外加成。]]):format(damDesc(self, DamageType.FIRE, damage))
	end,
}

registerTalentTranslation{
	id = "T_CLEANSING_FLAMES",
	name = "净化之焰",
	info = function(self, t)
		return ([[当你的无尽之炎激活时，你的地狱火和无尽之炎均有 %d%% 概率净化目标身上一种状态。（物理或法术） 
		如果目标是敌人，则净化其增益状态。 
		如果目标时友方单位，则净化负面状态（仍然有燃烧效果）。]]):format(t.getChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WILDFIRE",
	name = "野火燎原",
	info = function(self, t)
		local damageinc = t.getFireDamageIncrease(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		local selfres = t.getResistSelf(self, t)
		return ([[使身上缠绕火焰，增加 %d%% 所有火系伤害并无视目标 %d%% 火焰抵抗。 
		同时，减少 %d%% 对自己造成的火焰伤害。]])
		:format(damageinc, ressistpen, selfres)
	end,
}


return _M
