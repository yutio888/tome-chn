local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ACID_INFUSION",
	name = "酸液充能",
	info = function(self, t)
		local daminc = t.getIncrease(self, t)
		return ([[ 将酸性能量填充至炼金炸弹，能致盲敌人。
		你造成的酸性伤害增加 %d%% 。]]):
		format(daminc)
	end,
}

registerTalentTranslation{
	id = "T_CAUSTIC_GOLEM",
	name = "酸液覆体",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		local dam = self.alchemy_golem and self.alchemy_golem:damDesc(engine.DamageType.ACID, t.getDamage(self, t)) or 0
		return ([[当你的酸性充能激活时，若你的炸弹击中了你的傀儡，酸液会覆盖傀儡 %d 回合。
		当傀儡被酸液覆盖时，任何近战攻击有 %d%% 概率产生一次范围 4 的锥形酸液喷射，造成 %0.1f 点伤害（每回合至多一次）。

		受法术强度、技能等级和傀儡伤害影响，效果有额外加成。]]):
		format(duration, chance, dam)
	end,
}

registerTalentTranslation{
	id = "T_CAUSTIC_MIRE",
	name = "腐蚀之地",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local slow = t.getSlow(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[ 一小块酸液覆盖了目标地面，散落在半径 %d 的范围内，每回合造成 %0.1f 点酸性伤害，持续 %d 回合。
		受影响的生物同时会减速 %d%% 。
		受法术强度影响，伤害有额外加成。]]):
		format(radius, damDesc(self, DamageType.ACID, damage), duration, slow)
	end,
}

registerTalentTranslation{
	id = "T_DISSOLVING_ACID",
	name = "酸液溶解",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[ 酸液在目标周围爆发，造成 %0.1f 点酸性伤害。
		酸性伤害具有腐蚀性，有一定概率除去至多 %d 个物理 / 精神状态效果或是精神持续效果。
		受法术强度影响，伤害和几率额外加成。]]):format(damDesc(self, DamageType.ACID, damage), t.getRemoveCount(self, t))
	end,
}


return _M
