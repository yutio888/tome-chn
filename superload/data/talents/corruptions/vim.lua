local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SOUL_ROT",
	name = "灵魂腐蚀",
	info = function(self, t)
		return ([[向目标发射一枚纯粹的枯萎弹，造成 %0.2f 枯萎伤害。 
		此技能的暴击率增加 +%0.2f%% 。 
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 20, 250)), t.getCritChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DARK_PORTAL",
	name = "黑暗之门",
	info = function(self, t)
		return ([[开启一扇通往目标地点的黑暗之门。所有在目标地点的怪物将和你调换位置。 
		所有怪物（除了你）在传送过程中都会随机感染一种疾病，每回合受到 %0.2f 枯萎伤害，持续 6 回合。 
		同时，减少其某项物理属性（力量，体质或敏捷） %d 点。 
		受法术强度影响，伤害有额外加成。]]):format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 12, 80)), self:combatTalentSpellDamage(t, 5, 25))
	end,
}

registerTalentTranslation{
	id = "T_VIMSENSE",
	name = "活力感知",
	info = function(self, t)
		return ([[感受你周围 10 码半径范围内怪物的位置，持续 %d 回合。 
		这个邪恶的力量同时会降低目标 %d%% 枯萎抵抗，但也会使它们察觉到你。 
		受法术强度影响，抵抗的降低效果有额外加成。]]):
		format(t.getDuration(self,t), t.getResistPenalty(self,t))
	end,
}

registerTalentTranslation{
	id = "T_LEECH",
	name = "活力吸取",
	info = function(self, t)
		return ([[每当被活力感知发现的敌人攻击你时，你回复 %0.2f 活力值和 %0.2f 生命值。]]):
		format(t.getVim(self,t),t.getHeal(self,t))
	end,
}




return _M
