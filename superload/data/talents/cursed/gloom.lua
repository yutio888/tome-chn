local _M = loadPrevious(...)

local function gloomTalentsMindpower(self)
	return self:combatScale(self:getTalentLevel(self.T_GLOOM) + self:getTalentLevel(self.T_WEAKNESS) + self:getTalentLevel(self.T_DISMAY) + self:getTalentLevel(self.T_SANCTUARY), 1, 1, 20, 20, 0.75)
end

registerTalentTranslation{
	id = "T_GLOOM",
	name = "黑暗光环",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local duration = t.getDuration(self, t)
		local mindpowerChange = gloomTalentsMindpower(self)
		return ([[一个 3 码半径范围的可怕黑暗光环围绕你 , 影响附近的敌人。在每个回合结束时，光环内的每一个目标必须与你的精神强度进行豁免鉴定，未通过鉴定则有 %d%% 概率被减速30%% 、震慑或混乱(30%%)，持续 %d 回合。 
		几率受精神速度影响。
		这个能力是与生俱来的，激活或停止不消耗任何能量。
		黑暗光环树下的每个技能都会增加你的精神强度（当前总计： %d ）。]]):format(chance, duration, mindpowerChange)
	end,
}

registerTalentTranslation{
	id = "T_WEAKNESS",
	name = "黑暗衰竭",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local duration = t.getDuration(self, t)
		local incDamageChange = t.getIncDamageChange(self, t)
		local hateBonus = t.getHateBonus(self, t)
		local mindpowerChange = gloomTalentsMindpower(self)
		return ([[在黑暗光环里的每一个目标每回合必须与你的精神强度进行豁免鉴定，未通过鉴定则有 %d%% 概率被恐惧而虚弱持续 %d 回合，降低 %d%% 伤害，你对被削弱目标的首次近战攻击能获得 %d 点仇恨值。 
		几率受精神速度影响。
		黑暗光环树下的每个技能都会增加你的精神强度（当前总计： %d ）。]]):format(chance, duration, -incDamageChange, hateBonus, mindpowerChange)
	end,
}

registerTalentTranslation{
	id = "T_MINDROT",
	name = "思维腐蚀",
	info = function(self, t)
		return ([[每当你行动时，所有在你黑暗光环内的敌人都会受到  %0.2f  精神伤害和  %0.2f  暗影伤害。
		伤害受精神强度影响。
		黑暗光环树下的每个技能都会增加你的精神强度（当前总计： %d）。]]):format(damDesc(self, DamageType.MIND, t.getDamage(self, t) * 0.5), damDesc(self, DamageType.DARKNESS, t.getDamage(self, t) * 0.5), gloomTalentsMindpower(self))
	end,
}

registerTalentTranslation{
	id = "T_SANCTUARY",
	name = "庇护光环",
	info = function(self, t)
		local damageChange = t.getDamageChange(self, t)
		local mindpowerChange = gloomTalentsMindpower(self)
		return ([[你的黑暗光环成为独立于外界的避难所，任何光环外的目标对你的伤害降低 %d%% 。 
		黑暗光环树下的每个技能都会增加你的精神强度（当前总计： %d ）。]]):format(-damageChange, mindpowerChange)
	end,
}



return _M
