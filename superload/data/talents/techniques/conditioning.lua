local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_VITALITY",
	name = "活力",
	info = function(self, t)
		local wounds = t.getWoundReduction(self, t) * 100
		local baseheal = t.getHealValues(self, t)
		local duration = t.getDuration(self, t)
		local totalheal = baseheal
		return ([[你受中毒、疾病和创伤的影响较小，减少 %d%% 此类效果的持续时间。 
		此外在生命值低于 50%% 时，你的生命回复将会增加 %0.1f ，持续 %d 回合，共回复 %d 生命值，但每隔 %d 回合才能触发一次。
		受体质影响，生命回复有额外加成。]]):
		format(wounds, baseheal, duration, baseheal*duration, self:getTalentCooldown(t))
	end,
}

registerTalentTranslation{
	id = "T_UNFLINCHING_RESOLVE",
	name = "顽强意志",
	info = function(self, t)
		local chance = t.getChance(self, t)
		return ([[你学会从负面状态中快速恢复。 
		每回合你有 %d%% 几率从震慑效果中恢复。 
		在等级 2 时，也可以从致盲效果中恢复。 
		在等级 3 时，也可以从混乱效果中恢复。 
		在等级 4 时，也可以从定身效果中恢复。 
		在等级 5 时，也可以从减速或流血效果中恢复。 
		每回合你只能摆脱 1 种状态。 
		受体质影响，恢复概率按比例加成。]]):
		format(chance)
	end,
}

registerTalentTranslation{
	id = "T_DAUNTING_PRESENCE",
	name = "望而生畏",
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local penalty = t.getPenalty(self, t)
		return ([[敌人因你的存在而恐惧。 
		半径 %d 码范围内的敌人的物理强度，精神强度和法术强度会降低 %d 。
		受物理强度影响，威胁效果有加成。]]):
		format(radius, penalty)
	end,
}

registerTalentTranslation{
	id = "T_ADRENALINE_SURGE",
	name = "肾上腺素",
	info = function(self, t)
		local attack_power = t.getAttackPower(self, t)
		local duration = t.getDuration(self, t)
		return ([[你激活肾上腺素来增加 %d 物理强度持续 %d 回合。 
		此技能激活时，你可以不知疲倦地战斗，若体力为 0 ，可继续使用消耗类技能，代价为消耗生命。 
		受体质影响，物理强度有额外加成。 
		使用本技能不会消耗额外回合。]]):
		format(attack_power, duration)
	end,
}


return _M
