local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MIND_STORM",
	name = "心灵风暴",
	info = function(self, t)
		local targets = t.getTargetCount(self, t)
		local damage = t.getDamage(self, t)
		local charge_ratio = t.getOverchargeRatio(self, t)
		return ([[用你的潜意识渗透周围的环境。当此技能激活时，每回合你会射出 %d 个超能力值球造成 %0.2f 精神伤害（每个敌方单位只承受一次超能力值球攻击）。每个超能力值球消耗 5 点反馈值。 
		当获得的反馈值超出最大值时，你会产生额外的超能力值球（每超出 %d 反馈值产生 1 个超能力值球），但是每回合产生的额外超能力值球数量不会超过 %d 。 
		此技能运用了灵能通道，所以当你移动时会中断此技能。		
		特别地，当你开启此技能时，心灵光束、精神切断和碾碎心灵的攻击范围将变为10格。
		受精神强度影响，伤害按比例加成。]]):format(targets, damDesc(self, DamageType.MIND, damage), charge_ratio, targets)
	end,
}

registerTalentTranslation{
	id = "T_FEEDBACK_LOOP",
	name = "反馈逆转",
	info = function(self, t)
		local duration = t.getDuration(self, t, true)
		return ([[激活以逆转你的反馈值衰减，持续 %d 回合。此技能激活时可产生暴击效果，效果为增加技能持续时间。 
		你必须在反馈值非空的时候才能使用此技能（否则没有衰减）。 
		受精神强度影响，反馈值的最大增加值按比例加成。]]):format(duration)
	end,
}

registerTalentTranslation{
	id = "T_BACKLASH",
	name = "灵能反击",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local damage = t.getDamage(self, t)
		return ([[你的潜意识会报复那些伤害你的人。 
		当攻击者在 %d 码范围内时，你会对目标造成伤害，伤害值为因承受此攻击而获得的反馈数值（但不超过 %0.2f ）。
		此效果每回合对同一生物最多只能触发 1 次。
		受精神强度影响，伤害按比例加成。]]):format(range, damDesc(self, DamageType.MIND, damage))
	end,
}

registerTalentTranslation{
	id = "T_FOCUSED_WRATH",
	name = "集火",
	info = function(self, t)
		local penetration = t.getResistPenalty(self, t)
		local duration = t.getDuration(self, t)
		local crit_bonus = t.getCritBonus(self, t)
		return ([[将注意力集中于单体目标，将所有攻击性灵能脉冲系技能射向目标，持续 %d 回合。当此技能激活时，所有灵能脉冲系技能增加 %d%% 暴击伤害， 并且你可以获得 %d%% 精神抗性穿透。 
		如果目标死亡，则该技能提前中断。 
		受精神强度影响，暴击增益效果按比例加成。]]):format(duration, crit_bonus, penetration)
	end,
}


return _M
