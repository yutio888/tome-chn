local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_BLURRED_MORTALITY",
	name = "模糊死亡",
	info = function(self, t)
		return ([[对你而言，生死之别变的模糊，你只有在生命值下降到 -%d 时才会死亡。 ]]):
		format(t.lifeBonus(self, t))
	end,
}

registerTalentTranslation{
	id = "T_IMPENDING_DOOM",
	name = "灾厄降临",
	info = function(self, t)
		return ([[你使目标厄运临头。目标的治疗加成减少 80%% 且会对目标造成它 %d%% 剩余生命值的奥术伤害（或 %0.2f ，取最小伤害值），持续 10 回合。 
		 受法术强度影响，伤害有额外加成。]]):
		format(t.getDamage(self, t), t.getMax(self, t))
	end,
}

registerTalentTranslation{
	id = "T_UNDEATH_LINK",
	name = "亡灵分流",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[[吸收你所有亡灵随从 %d%% 的最大生命值（可能会杀死它们）并使用这股能量治愈你。
		 受法术强度影响，治疗量有额外加成。]]):
		format(heal)
	end,
}

registerTalentTranslation{
	id = "T_LICHFORM",
	name = "巫妖转生",
	info = function(self, t)
		return ([[你的终极目标。所有亡灵法师的目标，就是变成一个强大且永生的巫妖！ 
		 当此技能激活时，如果你被杀死，你的身体会被转化为巫妖。 
		 所有的巫妖会增加以下天赋： 
		* 中毒、流血、恐惧免疫 
		*100%% 疾病和震慑抵抗 
		*20%% 冰冷和暗影抵抗 
		* 不需要呼吸 
		* 纹身不起作用 
		 同时： 
		* 等级 1 ： -3 所有属性， -10%% 所有抵抗。 
		 如此微小的代价！ 
		* 等级 2 ：无 
		* 等级 3 ： +3 魔法和意志， +1 每等级增加生命值（不追加前面等级的生命值）。 
		* 等级 4 ： +3 魔法和意志， +2 每等级增加生命值（不追加前面等级的生命值）， +10 法术和精神豁免，天空 / 星怒系技能树（ 0.7 ）和每回合 0.1 负能量回复。 
		* 等级 5 ： +5 魔法和意志， +2 每等级增加生命值（不追加前面等级的生命值）， +10 法术和精神豁免，所有抵抗上限增加 10%% ，天空 / 星怒系技能树（ 0.9 ）和每回合 0.5 负能量回复。 
		* 等级 6 ： +6 魔法、意志和灵巧， +3 每等级增加生命值（不追加前面等级的生命值）， +15 法术和精神豁免，所有抵抗上限增加 15%% ，天空 / 星怒系技能树（ 1.1 ）和每回合 1.0 负能量回复。 
		* 等级 7 ： #CRIMSON##{bold}#你的力量无比强大 !#{normal}##LAST# +12 魔法, 意志和灵巧， 60%% 几率无视暴击，+4 每等级增加生命值（不追加前面等级的生命值）， +35 法术和精神豁免, 所有抵抗上限增加 15%% ，天空 / 星怒系技能树（ 1.3 ）和每回合 1.0 负能量回复。
		 不死族无法使用此天赋。 
		 当此技能激活时，每回合消耗 4 法力值。]]):
		format()
	end,
}


return _M
