local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MEDITATION",
	name = "冥想",
	message = function(self, t) return self.sustain_talents[t.id] and "@Source@ 中断了 @hisher@ #GREEN#冥想#LAST#." or "@Source@ 开始 #GREEN#冥想#LAST# 自然." end,
	info = function(self, t)
		local boost = 1 + (self.enhance_meditate or 0)

		local pt = (2 + self:combatTalentMindDamage(t, 20, 120) / 10) * boost
		local save = (5 + self:combatTalentMindDamage(t, 10, 40)) * boost
		local heal = (5 + self:combatTalentMindDamage(t, 12, 30)) * boost
		local rest = 0.5 * self:getTalentLevelRaw(t)
		return ([[你进入冥想，与大自然进行沟通。 
		 冥想时每回合你能回复 %0.2f 失衡值，你的精神豁免提高 %d ，你的治疗效果提高 %d%% 。 
		 冥想时你无法集中精力攻击，你和你的召唤物造成的伤害减少 50 ％。 
		 另外，你在休息时（即使未开启冥想）会自动进入冥想状态，使你每回合能回复 %d 点失衡值。 
		 受精神强度影响，激活时效果有额外加成。]]):
		format(pt, save, heal, rest)
	end,
}

registerTalentTranslation{
	id = "T_NATURE_TOUCH",
	name = "自然之触",
	info = function(self, t)
		return ([[对你自己或某个目标注入大自然的能量，治疗 %d 点生命值（对不死族无效）。 
		 受精神强度影响，治疗量有额外加成。]]):
		format(t.getHeal(self, t))
	end,
}

registerTalentTranslation{
	id = "T_EARTH_S_EYES",
	name = "大地之眼",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local radius_esp = t.radius_esp(self, t)
		return ([[利用你与大自然的联系，你可以查看自身周围 %d 码半径范围的区域。 
		 同时，当你处于冥想状态时，你还可以查看自身周围 %d 码半径范围中怪物的位置。]]):
		format(radius, radius_esp)
	end,
}

registerTalentTranslation{
	id = "T_NATURE_S_BALANCE",
	name = "自然平衡",
	info = function(self, t)
		return ([[你与大自然间的深刻联系，使你能够立刻冷却 %d 个技能层次不超过 %d 的自然系技能。]]):
		format(t.getTalentCount(self, t), t.getMaxLevel(self, t))
	end,
}


return _M
