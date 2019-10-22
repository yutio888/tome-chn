local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STONE_SKIN",
	name = "石化皮肤",
	info = function(self, t)
		local armor = t.getArmor(self, t)
		return ([[施法者的皮肤变的和岩石一样坚硬，提高 %d 点护甲。 
		每次你被近战攻击击中，你有 %d%% 几率减少一个土系或石系法术 2 回合冷却（一回合最多一次）。
		受法术强度影响，护甲有额外加成。]]):
		format(armor, t.getCDChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DIG",
	name = "粉碎钻击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local nb = t.getDigs(self, t)
		return ([[射出一道能击碎岩石的强有力的射线，在其路径上击碎 %d 码距离内的所有墙壁。
		射线会继续前进直到 %d 码距离处，对路径上的所有生物造成 %0.2f 点物理伤害。 
		如果有墙壁被击碎，你在 6 回合内获得 %d%% 物理伤害加成。
		受法术强度影响，伤害有额外加成。]]):
		format(nb, self:getTalentRange(t), damDesc(self, DamageType.PHYSICAL, damage), t.getBonus(self, t))
	end,
}

registerTalentTranslation{
	id = "T_MUDSLIDE",
	name = "山崩地裂",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[召唤一次山崩对敌人造成 %0.2f 点物理伤害（ %d 码锥形范围）。 
		范围内的任何敌人都将被击退。 
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.PHYSICAL, damage), self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_STONE_WALL",
	name = "岩石堡垒",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[召唤岩石堡垒环绕着你，持续 %d 回合。 
		在等级 4 时，它可以环绕其他目标。
		范围内的任何敌对生物将受到 %0.2f 点物理伤害。 
		受法术强度影响，持续时间和伤害有额外加成。]]):
		format(duration, damDesc(self, DamageType.PHYSICAL, damage))
	end,
}


return _M
