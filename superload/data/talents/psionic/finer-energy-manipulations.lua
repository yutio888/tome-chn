local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_REALIGN",
	name = "重组",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		local cure = t.numCure(self, t)
		return ([[用你的精神力量重组并调整你的身体，移除最多 %d 负面物理状态并治愈 %d 生命。
		受精神强度影响，治疗量有额外加成。]]):
		format(cure, heal)
	end,
}

registerTalentTranslation{
	id = "T_FORM_AND_FUNCTION",
	name = "武器护甲改造",
	info = function(self, t)
		local weapon_boost = t.damBoost(self, t)
		local arm = t.armorBoost(self, t)
		local fat = t.fatigueBoost(self, t)
		return ([[操纵力量从分子层面重组、平衡、磨砺你的装备。
		你装备的每一件武器都会提升 %d 的命中和伤害。灵晶不能被调整，因为他们已经是完美的自然形态。
		你每件身上的护甲和盾牌增加你 %d 护甲，同时减少 %d 疲劳。
		该技能效果受精神强度影响。]]):
		format(weapon_boost, arm, fat)
	end,
}

registerTalentTranslation{
	id = "T_MATTER_IS_ENERGY",
	name = "宝石能量",
	info = function(self, t)
		local amt = t.energy_per_turn(self, t)
		return ([[任何优秀的心灵杀手都知道，物质就是能量。遗憾的是，大多数物质由于分子成分的复杂性无法转换。然而，宝石有序的晶体结构使得部分物质转化为能量成为可能。
		这个技能消耗一个宝石，在 5~13 回合内，每回合获得 %d 超能力值，持续回合取决于所用的宝石品质。
		在持续时间内同时获得一个共振领域提供宝石的效果 ]]):
		format(amt)
	end,
}

registerTalentTranslation{
	id = "T_RESONANT_FOCUS",
	name = "共振聚焦",
	info = function(self, t)
		local inc = t.bonus(self,t)
		return ([[通过小心的同步你的精神和灵能聚焦的共振频率，强化灵能聚焦的效果 
		对于武器，提升你的意志和灵巧来代替力量和敏捷的百分比，从 60%% 到 %d%%.
		对于灵晶，提升 %d%% 将敌人抓取过来的几率 .
		对于宝石，提升 %d 额外全属性。]]):
		format(60+inc, inc, math.ceil(inc/5))
	end,
}

return _M
