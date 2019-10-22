local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RAMPAGE",
	name = "暴走",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local maxDuration = t.getMaxDuration(self, t)
		local movementSpeedChange = t.getMovementSpeedChange(self, t)
		local combatPhysSpeedChange = t.getCombatPhysSpeedChange(self, t)
		local combatMindSpeedChange = t.getCombatMindSpeedChange(self, t)
		return ([[你进入暴走状态 %d 回合（最多 %d 回合），摧毁在你路径上的所有东西，该技能瞬发，同时也有较小几率在你受到 8%% 最大生命值以上的伤害时自动激活。暴走状态下你使用任何技能、符文或纹身都无法专心使得技能效果持续时间缩短 1 回合，暴走状态下的第一次移动可延长暴走效果 1 回合。 
		暴走加成： +%d%% 移动速度。 
		暴走加成： +%d%% 攻击速度。
		暴走加成： +%d%% 精神速度。]]):format(duration, maxDuration, movementSpeedChange * 100, combatPhysSpeedChange * 100, combatMindSpeedChange *100)
	end,
}

registerTalentTranslation{
	id = "T_BRUTALITY",
	name = "无情",
	info = function(self, t)
		local physicalDamageChange = t.getPhysicalDamageChange(self, t)
		local combatPhysResistChange = t.getCombatPhysResistChange(self, t)
		local combatMentalResistChange = t.getCombatMentalResistChange(self, t)
		return ([[使你的暴走更加无情，暴走状态下的第一次暴击可延长暴走效果 1 回合。 
		暴走加成：你的物理伤害增加 %d%% 。 
		暴走加成：你的物理豁免增加 %d ，精神豁免增加 %d 。]]):format(physicalDamageChange, combatPhysResistChange, combatMentalResistChange)
	end,
}

registerTalentTranslation{
	id = "T_TENACITY",
	name = "不屈不挠",
	info = function(self, t)
		local damageShield = t.getDamageShield(self, t)
		local damageShieldBonus = t.getDamageShieldBonus(self, t)
		return ([[你的暴走变得势不可挡。 
		暴走加成：暴走状态下每回合你最多可以无视 %d 伤害，当你无视超过 %d 伤害时，暴走效果延长 1 回合。 
		受力量加成，你无视的伤害有额外加成。]]):format(damageShield, damageShieldBonus)
	end,
}

registerTalentTranslation{
	id = "T_SLAM",
	name = "猛力抨击",
	info = function(self, t)
		local hitCount = t.getHitCount(self, t)
		local stunDuration = t.getStunDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[暴走状态中，你可以攻击到最多 %d 个邻近目标，震慑他们 %d 回合，并造成 %d ～ %d 物理伤害，首次同时对两个以上目标造成的攻击可以延长暴走效果 1 回合。 
		受物理强度影响，伤害有额外加成。]]):format(hitCount, stunDuration, damage * 0.5, damage)
	end,
}



return _M
