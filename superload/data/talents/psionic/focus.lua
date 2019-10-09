local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MINDLASH",
	name = "心灵鞭笞",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[汇聚能量形成一道光束鞭笞敌人，造成 %d 点物理伤害并使他们失去平衡两轮（-15%% 全局速度）。
		受精神强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.PHYSICAL, dam))
	end,
}

registerTalentTranslation{
	id = "T_PYROKINESIS",
	name = "意念燃烧",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local dam = t.getDamage(self, t)
		return ([[对 %d 范围内的所有敌人，用意念使组成其身体的分子活化并引燃他们，在 6 回合内造成 %0.1f 火焰伤害。]]):
		format(radius, damDesc(self, DamageType.FIREBURN, dam))
	end,
}

registerTalentTranslation{
	id = "T_BRAIN_STORM",
	name = "头脑风暴",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[念力电离空气，将等离子体球掷向敌人。
		等离子球会因碰撞而爆炸，造成半径为 %d 的 %0.1f 闪电伤害。
		此技能将施加锁脑状态。
		受精神强度影响，伤害有额外加成。]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.LIGHTNING, dam) )
	end,
}

registerTalentTranslation{
	id = "T_IRON_WILL",
	name = "钢铁意志",
	info = function(self, t)
		return ([[ 钢铁意志提高 %d%% 震慑免疫，并使得你每回合有 %d%% 的几率从随机一个精神效果中恢复。]]):
		format(t.stunImmune(self, t)*100, t.cureChance(self, t)*100)
	end,
}


return _M
