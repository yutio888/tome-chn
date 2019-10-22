local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DRACONIC_WILL",
	name = "龙族意志",
	["require.special.desc"] = "熟悉龙之世界",
	info = function(self, t)
		return ([[你的身体如巨龙般强韧，可以轻易抵抗负面效果。 
		在 5 回合内对负面效果免疫。]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_METEORIC_CRASH",
	name = "落星",
	["require.special.desc"] = "曾亲眼目睹过陨石坠落",
	info = function(self, t)
		local dam = t.getDamage(self, t)/2
		return ([[在施展伤害类魔法或精神攻击时，你会释放意念，召唤一颗陨石砸向附近敌人。 
		陨石在 2 码半径内造成 %0.2f  火焰和 %0.2f  物理伤害，震慑敌人 3 回合。
		周围 3 码半径的地形将会被冲击转换成岩浆，每回合造成 %0.2f  火焰伤害，持续 8 回合。
		你和你的盟友不会受到陨石的伤害。

		另外，你的火焰伤害加成和穿透将被设置成你最高的伤害加成和穿透，这对你造成的所有火焰伤害都有效。
		受精神强度或法术强度影响，伤害按比例加成。  ]])
		:format(damDesc(self, DamageType.FIRE, dam), damDesc(self, DamageType.PHYSICAL, dam), damDesc(self, DamageType.FIRE, t.getLava(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_GARKUL_S_REVENGE",
	name = "加库尔的复仇",
	["require.special.desc"] = "装备加库尔的两件宝物并且了解加库尔的一生",
	info = function(self, t)
		return ([[加库尔之魂与你同在，你现在能对建筑类造成 1000％额外伤害，对人形生物和巨人造成 20％额外伤害。  ]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_HIDDEN_RESOURCES",
	name = "潜能爆发",
	["require.special.desc"] = "曾获得千钧一发成就（在低于 1HP 情况下杀死 1 个敌人）",
	info = function(self, t)
		return ([[在严峻的形势面前，你集中意念进入心如止水的状态。 
		在 5 回合内，所有技能不消耗任何能量。  ]])
		:format()
	end,
}


registerTalentTranslation{
	id = "T_LUCKY_DAY",
	name = "幸运日",
	["require.special.desc"] = "拥有大运气。（至少有+5luck属性）",
	info = function(self, t)
		return ([[每天都是幸运日。幸运永久 +40，有 10%% 几率闪避所有攻击。  ]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_UNBREAKABLE_WILL",
	name = "坚定意志",
	info = function(self, t)
		return ([[你的意志如此坚定，可以忽视对你造成的精神效果。 
	 	这一技能每 5 回合最多触发一次。]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_SPELL_FEEDBACK",
	name = "法术反馈",
	["require.special.desc"] = "习得反魔技能",
	info = function(self, t)
		return ([[你的意志是对抗邪恶魔法师的盾牌。 
		每当你受到魔法伤害，你会惩罚施法者，使其受到 %0.2f 的精神伤害。 
		同时，它们在对你使用的技能进入冷却的回合中，会受到 35％法术失败率惩罚。
		注意：该技能有冷却时间。]])
		:format(damDesc(self, DamageType.MIND, 20 + self:getWil() * 2))
	end,
}

registerTalentTranslation{
	id = "T_MENTAL_TYRANNY",
	name = "灵魂之怒",
	["require.special.desc"] = "曾造成50000点精神伤害",
	info = function(self, t)
		return ([[用钢铁般的意志驱使整个身体。 
		当此技能激活时，你 33%% 的伤害会转化为精神伤害。 
		此外，你获得 30％精神抵抗穿透并增加 10％精神伤害。]]):
		format()
	end,
}

return _M
