local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_OOZEBEAM",
	name = "软泥射线",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[ 在你的心灵利刃里充填史莱姆能量，延展攻击范围, 形成一道射线，造成 %0.1f 点史莱姆伤害。 
		受精神强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.NATURE, dam))
	end,
}

registerTalentTranslation{
	id = "T_NATURAL_ACID",
	name = "自然酸化",
	info = function(self, t)
		return ([[ 你的自然抗性增加 %d%% 。
		当你造成酸性伤害时，你的自然伤害增加 %0.1f%% ，持续 %d 回合。
		伤害加成能够积累到最多 4 倍（ 1 回合至多触发 1 次），最大值 %0.1f%% 。
		受精神强度影响，抗性和伤害加成有额外加成。]]):
		format(t.getResist(self, t), t.getNatureDamage(self, t, 1), t.getDuration(self, t), t.getNatureDamage(self, t, 5))
	end,
}

registerTalentTranslation{
	id = "T_MIND_PARASITE",
	name = "精神寄生",
	info = function(self, t)
		return ([[你利用你的心灵利刃朝你的敌人发射一团蠕虫。 
		当攻击击中时，它会进入目标大脑，并在那里待 6 回合，干扰对方使用技能的能力。 
		每次对方使用技能时，有 %d%% 概率 %d 个技能被打入 %d 个回合的冷却。 
		受精神强度影响，概率有额外加成。]]):
		format(t.getChance(self, t), t.getNb(self, t), t.getTurns(self, t))
	end,
}

registerTalentTranslation{
	id = "T_UNSTOPPABLE_NATURE",
	name = "自然世界",
	info = function(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		local chance = t.getChance(self, t)
		return ([[你的周围充满了自然力量，忽略目标 %d%% 的自然伤害抵抗。 
		同时，每次你使用自然力量造成伤害时，有 %d%% 概率你的一个粘液软泥怪会向目标释放喷吐，这个攻击不消耗时间。]])
		:format(ressistpen, chance)
	end,
}


return _M
