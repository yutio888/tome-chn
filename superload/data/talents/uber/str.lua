local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GIANT_LEAP",
	name = "战争践踏",
	["require.special.desc"] = "曾使用武器或徒手造成超过50000点伤害",
	info = function(self, t)
		return ([[你跃向目标地点，对 1 码半径范围内的所有敌人造成 200％的武器伤害，并眩晕目标 3 回合。  
		落地后，你解除自身眩晕、定身和震慑效果。
		]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_TITAN_S_SMASH",
	name = "化作星星吧！！",
	["require.special.desc"] = "体型至少为巨大（使用也要满足此条件）",
	info = function(self, t)
		return ([[对敌人进行一次猛击，造成 350％的武器伤害并击退目标 5 码，路径上的敌人都会被击中。
		所有受影响的目标都会被震慑 3 回合。
		体型超过  “Big”时，每增加一级，额外增加 80%% 武器伤害。]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_MASSIVE_BLOW",
	name = "巨人之锤",
	["require.special.desc"] = "曾挖掉至少 30 块石头 / 树木 / 等等，并且使用双手武器造成超过 50000 点伤害",
	info = function(self, t)
		return ([[对敌人进行一次猛击，造成 150％的武器伤害并击退目标 4 码。（无视击退免疫和物理豁免） 
		如果敌人在击退时撞上墙壁，墙壁会被撞毁且对敌人造成额外的 350％武器伤害，并附加被反击特效。  ]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_STEAMROLLER",
	name = "无尽冲锋",
	["require.special.desc"] = "习得冲锋技能",
	info = function(self, t)
		return ([[当你使用冲锋时，冲锋目标会被标记。在接下来两轮之内杀掉冲锋对象，则冲锋技能会冷却完毕。 
		每当此技能触发时，你获得 1 个增加 20％伤害的增益效果，最大叠加至 100％。
		冲锋现在只消耗 2 点体力。]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_IRRESISTIBLE_SUN",
	name = "无御之日",
	["require.special.desc"] = "曾造成50000点以上的光系或者火系伤害",
	info = function(self, t)
		local dam = (35 + self:getStr() * 1.3) / 3
		return ([[你获得 8 回合的星之引力，将周围 5 码范围内的所有生物向你拉扯，并对所有敌人造成 %0.2f 火焰、 %0.2f 光系和 %0.2f 物理伤害。他们所造成的伤害减少30%%。 
		最靠近你的敌人受到额外的 150％伤害。 
		受力量影响，伤害值有额外加成。  ]])
		:format(damDesc(self, DamageType.FIRE, dam), damDesc(self, DamageType.LIGHT, dam), damDesc(self, DamageType.PHYSICAL, dam))
	end,
}

registerTalentTranslation{
	id = "T_NO_FATIGUE",
	name = "我能举起世界！",
	["require.special.desc"] = "能够使用板甲",
	info = function(self, t)
		return ([[你是如此强壮，永不疲倦。 
		疲劳值永久为 0 且负重上限增加 500 点。
		你增加 50 点力量并且体型 +1 。
		]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_LEGACY_OF_THE_NALOREN",
	name = "纳鲁之传承",
	["require.special.desc"] = "站在萨拉苏尔一方并且杀死厄库尔维斯克",
	info = function(self, t)
		local level = t.bonusLevel(self,t)
		return ([[你站在萨拉苏尔一方并帮助他解决了厄库尔维斯克。你现在可以轻松的在水下呼吸。 
	         同时，你能轻易学会如何使用三叉戟和其他异形武器（获得 %d 级异形武器掌握），并且可以像娜迦一样喷吐毒素（等级 %d ）。技能等级随人物等级增长。   
		此外，若萨拉苏尔仍然存活，他还会送你一份大礼…]])
		:format(level, level)
	end,
}

registerTalentTranslation{
	id = "T_SUPERPOWER",
	name = "超级力量",
	info = function(self, t)
		return ([[强壮的身体才能承载强大的灵魂。而强大的灵魂却可以创造一个强壮的身体。 
		获得相当于你 60％力量值的精神强度增益。 
		此外，你的所有武器都会有额外的 40％意志修正加成。  ]])
		:format()
	end,
}

return _M
