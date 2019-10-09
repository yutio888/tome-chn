local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FROST_INFUSION",
	name = "冰霜充能",
	info = function(self, t)
		local daminc = t.getIncrease(self, t)
		return ([[将寒冰能量填充至炼金炸弹，能冰冻敌人。
		 你造成的寒冰伤害增加 %d%% 。]]):
		format(daminc)
	end,
}

registerTalentTranslation{
	id = "T_ICE_ARMOUR",
	name = "寒冰护甲",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local dam = self.alchemy_golem and self.alchemy_golem:damDesc(engine.DamageType.COLD, t.getDamage(self, t)) or 0
		local armor = t.getArmor(self, t)
		return ([[当你的寒冰充能激活时，若你的炸弹击中了你的傀儡，冰霜会覆盖傀儡 %d 回合。
		 冰霜会增加傀儡 %d 点护甲，同时受到近战攻击时，会反击攻击方 %0.1f 点寒冷伤害，同时傀儡造成的一半伤害转化为寒冰伤害。
		 受法术强度、技能等级和傀儡伤害影响，效果有额外加成。]]):
		format(duration, armor, dam)
	end,
}

registerTalentTranslation{
	id = "T_FLASH_FREEZE",
	name = "极速冻结",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[ 在半径 %d 的范围内激发寒冰能量，造成 %0.1f 点寒冷伤害，同时将周围的生物冻结在地面上 %d 个回合。 
		 受影响的生物能够行动，但不能移动。
		 受法术强度影响，持续时间有额外加成。]]):format(radius, damDesc(self, DamageType.COLD, t.getDamage(self, t)), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BODY_OF_ICE",
	name = "冰霜之躯",
	info = function(self, t)
		local resist = t.getResistance(self, t)
		local crit = t.critResist(self, t)
		return ([[ 将你的身体转化为纯净的寒冰体，你受到的寒冰伤害的 %d%% 会治疗你，同时你的物理抗性增加 %d%% 。
		你有 %d%% 几率摆脱暴击伤害（物理，精神，法术）。
 		受法术强度影响，效果有额外加成。]]):
		format(t.getAffinity(self, t), resist, crit)
	end,
}


return _M
