local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GESTURE_OF_PAIN",
	name = "痛苦手势",
	info = function(self, t)
		local baseDamage = t.getBaseDamage(self, t)
		local stunChance = t.getStunChance(self, t)
		local bonusDamage = t.getBonusDamage(self, t)
		local bonusCritical = t.getBonusCritical(self, t)
		return ([[使用痛苦手势来代替通常攻击，对你的敌人的精神进行打击，造成 %0.1f 到 %0.1f 点精神伤害。如果攻击命中，有 %d%% 概率震慑你的目标 3 个回合。 
		这项攻击采用你的精神强度而非物理强度，同时需检查对方精神豁免。这项攻击不受你的命中或对方闪避影响，也不会触发任何当你的武器命中对方时触发的效果。但是，你的灵晶提供的基础伤害（按双倍计算）和暴击率会被计算入攻击中。 
		这项技能需要你空手或双持灵晶，同时有 25%% 概率触发可暴击的锁脑效果。
		如果用双持灵晶攻击，能够触发命中效果。
		受精神强度影响，伤害有额外加成。 
		受灵晶影响，增加 %d 伤害和 %d%% 暴击率。]])
		:format(damDesc(self, DamageType.MIND, baseDamage * 0.5), damDesc(self, DamageType.MIND, baseDamage), stunChance, bonusDamage, bonusCritical)
	end,
}

registerTalentTranslation{
	id = "T_GESTURE_OF_MALICE",
	name = "怨恨手势",
	info = function(self, t)
		local resistAllChange = t.getResistAllChange(self, t)
		local duration = t.getDuration(self, t)
		return ([[使你的痛苦手势充满怨恨的诅咒，任何受到痛苦手势攻击的目标会降低 %d%% 所有抵抗，持续 %d 回合。
		]]):format(-resistAllChange, duration)
	end,
}

registerTalentTranslation{
	id = "T_GESTURE_OF_POWER",
	name = "力量手势",
	info = function(self, t)
		local mindpowerChange = t.getMindpowerChange(self, t, 2)
		local mindCritChange = t.getMindCritChange(self, t)
		return ([[通过一个手势来增强你的精神攻击。你获得 +%d 精神强度和 +%d%% 几率增加精神攻击的暴击率（当前几率为 %d%% ）。 
		需要至少一只空手或者装备灵晶。不需要痛苦手势持续激活。]]):format(mindpowerChange, mindCritChange, self:combatMindCrit())
	end,
}

registerTalentTranslation{
	id = "T_GESTURE_OF_GUARDING",
	name = "守护手势",
	info = function(self, t)
		local damageChange = t.getDamageChange(self, t, true)
		local counterAttackChance = t.getCounterAttackChance(self, t, true)
		return ([[ 你通过手势来防御近战伤害。只要你能使用手势（要求空手或双持灵晶），你最多偏移 %d 点伤害（你的单手最大伤害的 %0.1f%% ），每回合最多触发 %0.1f 次（基于你的灵巧）。成功防御的攻击不会暴击。
		如果痛苦手势被激活，你将有 %0.1f%% 的概率造成反击状态。]]):
		format(damageChange, t.getGuardPercent(self, t), t.getDeflects(self, t, true), counterAttackChance)
	end,
}



return _M
