local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_INTERACT_GOLEM",
	name = "检查傀儡",
	info = function(self, t)
		return ([[和你的傀儡交互，检查它的物品、技能等。]]):
		format()
	end,
}

registerTalentTranslation{
	id = "T_REFIT_GOLEM",
	name = "改装傀儡",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[与你的傀儡进行交互： 
		- 如果它被摧毁，你将耗费一些时间重新安装傀儡（需要 15 个炼金宝石）。 
		- 如果它还存活，你可以修整它使其恢复 %d 生命值。（耗费 2 个炼金宝石）。法术强度、炼金宝石和强化傀儡技能都会影响治疗量。]]):
		format(heal)
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_POWER",
	name = "强化傀儡",
	info = function(self, t)
		if not self.alchemy_golem then return "提高傀儡的武器熟练度，增加它的命中、物理强度和伤害。" end
		local rawlev = self:getTalentLevelRaw(t)
		local olda, oldd = self.alchemy_golem.talents[Talents.T_WEAPON_COMBAT], self.alchemy_golem.talents[Talents.T_WEAPONS_MASTERY]
		self.alchemy_golem.talents[Talents.T_WEAPON_COMBAT], self.alchemy_golem.talents[Talents.T_WEAPONS_MASTERY] = 1 + rawlev, rawlev
		local ta, td = self:getTalentFromId(Talents.T_WEAPON_COMBAT), self:getTalentFromId(Talents.T_WEAPONS_MASTERY)
		local attack = ta.getAttack(self.alchemy_golem, ta)
		local power = td.getDamage(self.alchemy_golem, td)
		local damage = td.getPercentInc(self.alchemy_golem, td)
		self.alchemy_golem.talents[Talents.T_WEAPON_COMBAT], self.alchemy_golem.talents[Talents.T_WEAPONS_MASTERY] = olda, oldd
		return ([[提高傀儡的武器熟练度，增加它 %d 点命中、 %d 物理强度和 %d%% 伤害。]]):
		format(attack, power, 100 * damage)
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_RESILIENCE",
	name = "坚韧傀儡",
	info = function(self, t)
		if not self.alchemy_golem then return " 提高傀儡护甲熟练度和伤害抵抗和治疗系数。" end
		local rawlev = self:getTalentLevelRaw(t)
		local oldh, olda = self.alchemy_golem.talents[Talents.T_THICK_SKIN], self.alchemy_golem.talents[Talents.T_GOLEM_ARMOUR]
		self.alchemy_golem.talents[Talents.T_THICK_SKIN], self.alchemy_golem.talents[Talents.T_GOLEM_ARMOUR] = rawlev, 1 + rawlev
		local th, ta, ga = self:getTalentFromId(Talents.T_THICK_SKIN), self:getTalentFromId(Talents.T_ARMOUR_TRAINING), self:getTalentFromId(Talents.T_GOLEM_ARMOUR)
		local res = th.getRes(self.alchemy_golem, th)
		local heavyarmor = ta.getArmor(self.alchemy_golem, ta) + ga.getArmor(self.alchemy_golem, ga)
		local hardiness = ta.getArmorHardiness(self.alchemy_golem, ta) + ga.getArmorHardiness(self.alchemy_golem, ga)
		local crit = ta.getCriticalChanceReduction(self.alchemy_golem, ta) + ga.getCriticalChanceReduction(self.alchemy_golem, ga)
		self.alchemy_golem.talents[Talents.T_THICK_SKIN], self.alchemy_golem.talents[Talents.T_GOLEM_ARMOUR] = oldh, olda

		return ([[提高傀儡护甲熟练度和伤害抵抗。 
		增加 %d%% 所有伤害抵抗；增加 %d 点护甲和 %d%% 护甲韧性；当装备 1 件锁甲或板甲时，减少 %d%% 被暴击率；增加 %d%% 治疗效果。 
		傀儡可以使用所有类型的护甲，包括板甲。]]):
		format(res, heavyarmor, hardiness, crit, t.getHealingFactor(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_INVOKE_GOLEM",
	name = "傀儡召返",
	info = function(self, t)
		local power=t.getPower(self, t)
		return ([[你将傀儡拉到你身边，使它暂时性增加 %d 点近战物理强度，持续 5 回合。]]):
		format(power)
	end,
}

registerTalentTranslation{
	id = "T_GOLEM_PORTAL",
	name = "傀儡传送",
	info = function(self, t)
		return ([[使用此技能后，你和傀儡将会交换位置。 
		你的敌人会被混乱，那些之前攻击你的敌人将有 %d%% 概率转而攻击傀儡。]]):
		format(math.min(100, self:getTalentLevelRaw(t) * 15 + 25))
	end,
}


return _M
