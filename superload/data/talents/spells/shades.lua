local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHADOW_TUNNEL",
	name = "暗影通道",
	info = function(self, t)
		local chance = t.getChance(self, t)
		return ([[用一片黑暗笼罩你的亡灵随从。 
		 黑暗会传送他们到你身边并使他们增加 %d%% 闪避，持续 5 回合。 
		 受法术强度影响，闪避率有额外加成。]]):
		format(chance)
	end,
}

registerTalentTranslation{
	id = "T_CURSE_OF_THE_MEEK",
	name = "驯服诅咒",
	info = function(self, t)
		return ([[通过阴影，从安全地区召唤 %d 个无害生物。 
		 这些生物会受到仇恨诅咒，吸引附近所有的敌人的攻击。 
		 若这些生物被敌人杀死，你有 70%% 概率增加 1 个灵魂。]]):
		format(math.ceil(self:getTalentLevel(t)))
	end,
}

registerTalentTranslation{
	id = "T_FORGERY_OF_HAZE",
	name = "暗影分身",
	info = function(self, t)
		return ([[你使用暗影复制自己，生成一个分身，持续 %d 回合。 
		 你的分身继承你的天赋和属性，继承 %d%% 生命值和 %d%% 伤害。]]):
		format(t.getDuration(self, t), t.getHealth(self, t) * 100, t.getDam(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_FROSTDUSK",
	name = "幽暗极冰",
	info = function(self, t)
		local damageinc = t.getDamageIncrease(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		local affinity = t.getAffinity(self, t)
		return ([[ 让幽暗极冰围绕你，增加你 %0.1f%% 所有的暗影系和冰冷系伤害并无视目标 %d%% 暗影抵抗。 
		 此外，你受到的所有暗影伤害可治疗你。治疗量为 %d%% 暗影伤害值。]])
		:format(damageinc, ressistpen, affinity)
	end,
}


return _M
