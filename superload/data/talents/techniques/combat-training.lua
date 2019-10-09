local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_THICK_SKIN",
	name = "硬化皮肤",
	info = function(self, t)
		local res = t.getRes(self, t)
		return ([[你的皮肤变的更加坚硬。增加所有伤害抵抗 %0.1f%% 。]]):
		format(res)
	end,
}

registerTalentTranslation{
	id = "T_ARMOUR_TRAINING",
	name = "重甲训练",
	info = function(self, t)
		local hardiness = t.getArmorHardiness(self, t)
		local armor = t.getArmor(self, t)
		local criticalreduction = t.getCriticalChanceReduction(self, t)
		local classrestriction = ""
		if self.descriptor and self.descriptor.subclass == "Brawler" then
			classrestriction = "(注意当格斗家穿戴板甲时，他们的大部分技能无法使用。 )"
		end
		if self:knowTalent(self.T_STEALTH) then
			classrestriction = "(注意当你穿戴锁甲时会干扰潜行。)"
		end
		return ([[ 你使用防具来偏转攻击和保护重要部位的能力加强了。 
		根据现有防具，提高 %d 护甲值和 %d%% 护甲韧性，并减少 %d%% 被暴击几率。 
		( 这项技能只对重甲或板甲提供加成。 ) 
		在等级 1 时，能使你装备锁甲、金属手套、头盔和重靴。 
		在等级 2 时，能使你装备盾牌。 
		在等级 3 时，能使你装备板甲。
		%s]]):format(armor, hardiness, criticalreduction, classrestriction)
	end,
}
registerTalentTranslation{
	id = "T_LIGHT_ARMOUR_TRAINING",
	name = "轻甲训练",
	info = function (self,t)
		local defense = t.getDefense(self,t)
		return ([[你学会在身着轻甲时保持敏捷，增加 %d 闪避， %d%% 护甲硬度，减少 %d%% 疲劳。
		此外，每当你进入和（可见的）敌人相邻的位置时，你获得 %d 闪避，持续 2 回合。
		闪避受敏捷加成。]]):
		format(defense, t.getArmorHardiness(self,t), t.getFatigue(self, t, true), defense/2)
	end,
}
registerTalentTranslation{
	id = "T_WEAPON_COMBAT",
	name = "强化命中",
	info = function(self, t)
		local attack = t.getAttack(self, t)
		return ([[增加你的徒手、近身和远程武器命中 %d 点。]]):
		format(attack)
	end,
}

registerTalentTranslation{
	id = "T_WEAPONS_MASTERY",
	name = "武器掌握",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[使用剑、斧、狼牙棒时，增加 %d%% 伤害，增加 30 物理强度。]]):
		format(100*inc)
	end,
}

registerTalentTranslation{
	id = "T_KNIFE_MASTERY",
	name = "匕首掌握",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[使用匕首时，增加 %d%% 伤害，增加 30 物理强度。]]):
		format(100*inc)
	end,
}

registerTalentTranslation{
	id = "T_EXOTIC_WEAPONS_MASTERY",
	name = "特殊武器掌握",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[使用特殊武器时，增加 %d%% 伤害，增加 30 物理强度。]]):
		format(damage, 100*inc)
	end,
}


return _M
