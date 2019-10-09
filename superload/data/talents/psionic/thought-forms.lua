local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TF_BOWMAN",
	name = "具象之弧：弓箭手",
	info = function(self, t)
		local stat = t.getStatBonus(self, t)
		return ([[你从脑海里召唤出一位身穿皮甲的精神体弓箭手。当精神体弓箭手到达对应等级时可习得弓术掌握、强化命中、稳固射击、致残射击和急速射击，并且可增加 %d 点力量、 %d 点敏捷和 %d 体质。 
		 激活此技能会使其他具象之弧系技能进入冷却。 
		 受精神强度影响，属性增益有额外加成。]]):format(stat/2, stat, stat/2)
	end,
}

registerTalentTranslation{
	id = "T_TF_WARRIOR",
	name = "具象之弧：狂战士",
	info = function(self, t)
		local stat = t.getStatBonus(self, t)
		return ([[你从脑海里召唤出一位手持战斧的精神体狂战士。当精神体狂战士到达对应等级时可习得武器掌握、强化命中、嗜血、死亡之舞和冲锋，并且可增加 %d 点力量、 %d 点敏捷和 %d 体质。 
		 激活此技能会使其他具象之弧系技能进入冷却。 
		 受精神强度影响，属性增益有额外加成。]]):format(stat, stat/2, stat/2)
	end,
}

registerTalentTranslation{
	id = "T_TF_DEFENDER",
	name = "具象之弧：盾战士",
	info = function(self, t)
		local stat = t.getStatBonus(self, t)
		return ([[你从脑海里召唤出一位手持剑盾的精神体盾战士。当精神体盾战士到达对应等级时可习得护甲掌握、武器掌握、强化命中、盾牌连击和盾墙，并且可增加 %d 点力量、 %d 点敏捷和 %d 体质。 
		 激活此技能会使其他具象之弧系技能进入冷却。 
		 受精神强度影响，属性增益有额外加成。]]):format(stat/2, stat/2, stat)
	end,
}

registerTalentTranslation{
	id = "T_THOUGHT_FORMS",
	name = "具象之弧",
	info = function(self, t)
		local bonus = t.getStatBonus(self, t)
		local range = self:getTalentRange(t)
		return([[你从脑海里召唤出一位强大的守护者。 
		 你的守护者主属性会增加 %d ，他的两项副属性会增加 %d ，同时他的力量、灵巧和意志属性等同于你的属性值。 
		 在等级 1 时，你会召唤出身着皮甲的弓箭手大师； 
		 在等级 3 时，你会召唤出手持双手武器的精英狂战士； 
		 在等级 5 时，你会召唤出手持剑盾的精英盾战士。 
		 精神体只能存在于 %d 码范围内，若超出此范围，则精神体会回到你身边。 
		 在同一时间内只有一种具象之弧可以激活。 
		 受精神强度影响，属性增益有额外加成。]]):format(bonus, bonus/2, range)
	end,
}

registerTalentTranslation{
	id = "T_TRANSCENDENT_THOUGHT_FORMS",
	name = "具象之弧：卓越",
	info = function(self, t)
		local level = math.floor(self:getTalentLevel(t))
		return([[你的精神体习得技能等级为 %d 的清晰梦境、生物反馈和共鸣之心。]]):format(level)
	end,
}

registerTalentTranslation{
	id = "T_OVER_MIND",
	name = "具象之弧：支配",
	info = function(self, t)
		local bonus = t.getControlBonus(self, t)

		return ([[直接控制当前的精神体，增加其 %d%% 伤害、攻速以及最大生命值，但是此时你的身体会处于比较脆弱的状态。 
		 在等级 1 时，你的守护者所获得的任何反馈值也会传递给你。 
		 在等级 3 时，你的守护者会获得所有豁免的增益效果，数值等同你精神豁免的大小。 
		 在等级 5 时，它们会获得伤害增益，增益值基于你的额外精神伤害。 
		 等级 3 的增益为被动效果，无论此技能是否激活均有效。 
		 受精神强度影响，增益效果有额外加成。]]):format(bonus)
	end,
}

registerTalentTranslation{
	id = "T_TF_UNITY",
	name = "具象之弧：共鸣",
	info = function(self, t)
		local offense = t.getOffensePower(self, t)
		local defense = t.getDefensePower(self, t)
		local speed = t.getSpeedPower(self, t)
		return([[现在，当具象之弧：弓箭手激活时，你提升 %d%% 精神速度； 
		 当具象之弧：狂战士激活时，你提升 %d 精神强度； 
		 当具象之弧：盾战士激活时，你提升 %d%% 所有抵抗。 
		 受精神强度影响，增益效果按比例加成。]]):format(speed, offense, defense, speed)
	end,
}


return _M
