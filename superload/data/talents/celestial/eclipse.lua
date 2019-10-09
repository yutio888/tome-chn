local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_BLOOD_RED_MOON",
	name = "血月唤醒",
	info = function(self, t)
		return ([[增加你 %d%% 法术暴击率。]]):
		format(t.getCrit(self, t))
	end,
}

registerTalentTranslation{
	id = "T_TOTALITY",
	name = "日全食",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local penetration = t.getResistancePenetration(self, t)
		local cooldownreduction = t.getCooldownReduction(self, t)
		return ([[增加 %d%% 光系和暗影系抵抗穿透，持续 %d 回合。同时，减少你所有天空系技能冷却时间 %d 回合至冷却。 
		 受灵巧影响，抵抗穿透有额外加成。]]):
		format(penetration, duration, cooldownreduction)
	end,
}

registerTalentTranslation{
	id = "T_CORONA",
	name = "日冕",
	info = function(self, t)
		local targetcount = t.getTargetCount(self, t)
		local lightdamage = t.getLightDamage(self, t)
		local darknessdamage = t.getDarknessDamage(self, t)
		return ([[每当你的法术打出暴击时，你会对 %d 码内 %d 个目标发射一颗光球或暗影球，造成 %0.2f 光系或 %0.2f 暗影伤害。 
		 每个球都会消耗 2 点正能量或负能量，当你的正能量或负能量低于 2 时不会触发。 
		 受法术强度影响，伤害按比例加成。
		 该法术造成的伤害不能暴击。]]):
		format(self:getTalentRange(t), targetcount, damDesc(self, DamageType.LIGHT, lightdamage), damDesc(self, DamageType.DARKNESS, darknessdamage))
	end,
}

registerTalentTranslation{
	id = "T_DARKEST_LIGHT",
	name = "至暗之光",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local dotDam = t.getDotDamage(self, t)
		local conversion = t.getConversion(self, t)
		local duration = t.getDuration(self, t)
		return ([[用无尽黑暗包围半径 %d 范围内的所有敌人，每回合对其造成 %0.2f 光系和 %0.2f 暗影伤害，并将它们所造成的伤害的 %d%% 转化为光系和暗影伤害，持续 %d 回合。]]):format(radius, damDesc(self, DamageType.LIGHT, dotDam), damDesc(self, DamageType.DARKNESS, dotDam), conversion*100, duration)
	end,
}

return _M
