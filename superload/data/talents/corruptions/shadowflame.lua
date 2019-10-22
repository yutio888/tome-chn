local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WRAITHFORM",
	name = "鬼魂形态",
	info = function(self, t)
		return ([[转化为鬼魂，允许你穿墙且不需要呼吸，持续 %d 回合。 
		同时增加闪避 %d 和护甲值 %d 。 
		效果结束时若你处于墙内，你将被随机传送。
		受法术强度影响，增益效果有额外加成。]]):
		format(t.getDuration(self, t), t.getDefs(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DARKFIRE",
	name = "黑暗之炎",
	info = function(self, t)
		return ([[向目标发射一团黑暗之炎，产生爆炸并造成 %0.2f 火焰伤害和 %0.2f 暗影伤害（ %d 码半径范围内）。 
		受法术强度影响，伤害有额外加成。]]):format(
			damDesc(self, DamageType.FIRE, self:combatTalentSpellDamage(t, 28, 220) / 2),
			damDesc(self, DamageType.DARKNESS, self:combatTalentSpellDamage(t, 28, 220) / 2),
			self:getTalentRadius(t)
		)
	end,
}

registerTalentTranslation{
	id = "T_FLAME_OF_URH_ROK",
	name = "乌鲁洛克之焰",
	info = function(self, t)
		return ([[召唤伟大的恶魔领主乌鲁洛克的实体，转化为恶魔。 
		当你处于恶魔形态时，你增加 %d%% 火焰抵抗， %d%% 暗影抵抗并且增加 %d%% 整体速度。 
		当你处于恶魔形态时，恐惧空间的火焰会治疗你。 
		受法术强度影响，抵抗和治疗量有额外加成。]]):
		format(self:combatTalentSpellDamage(t, 20, 30), self:combatTalentSpellDamage(t, 20, 35), t.getSpeed(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_DEMON_PLANE",
	name = "恐惧空间",
	info = function(self, t)
		return ([[召唤一部分恐惧空间与现有空间交叉。 
		你的目标和你自己都会被带入恐惧空间，只有当你中断技能或目标死亡时，限制解除。 
		在恐惧空间内，永恒之焰会燃烧你和目标，造成 %0.2f 火焰伤害，对恶魔则会改为进行治疗。
		当技能中断时，你和目标（如果还活着），以及所有掉落物品会被带回原来空间。
		这个强大的法术最初每回合消耗 5 点活力，活力值消耗每回合增加 1 点，当活力值归零时技能终止。
		当你已处于恐惧空间时，此技能施放无效果。 
		受法术强度影响，伤害有额外加成。]]):format(damDesc(self, DamageType.FIRE, self:combatTalentSpellDamage(t, 12, 140)))
	end,
}



return _M
