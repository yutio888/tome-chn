local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ACIDBEAM",
	name = "酸性射线",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[ 在你的心灵利刃里充填酸性能量，延展攻击范围, 形成一道射线，造成 %0.1f 点酸性缴械伤害。 
		 受精神强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.ACID, dam))
	end,
}

registerTalentTranslation{
	id = "T_CORROSIVE_NATURE",
	name = "自然腐蚀",
	info = function(self, t)
		return ([[ 你的酸性抗性增加 %d%% 。
		 当你造成自然伤害时，你的酸性伤害增加 %0.1f%% ，持续 %d 回合。
		 伤害加成能够积累到最多 4 倍（ 1 回合至多触发 1 次），最大值 %0.1f%% 。
		 受精神强度影响，抗性和伤害加成有额外加成。]]):
		format(t.getResist(self, t), t.getAcidDamage(self, t, 1), t.getDuration(self, t), t.getAcidDamage(self, t, 5))
	end,
}

registerTalentTranslation{
	id = "T_CORROSIVE_SEEDS",
	name = "腐蚀之种",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local nb = t.getNb(self, t)
		return ([[ 你集中精神于某块半径 2 的区域，制造出 %d 个腐蚀之种。 
		 第一个种子会产生于中心处，其他的会随机出现。
         每个种子持续 %d 回合，
		 当一个生物走过腐蚀之种时，会在半径 1 的区域内引发一场爆炸，击退对方并造成 %0.1f 点酸性伤害。 
		 受精神强度影响，伤害有额外加成]]):
		format(nb, t.getDuration(self, t), damDesc(self, DamageType.ACID, dam))
	end,
}

registerTalentTranslation{
	id = "T_ACIDIC_SOIL",
	name = "酸化大地",
	info = function(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		local regen = t.getRegen(self, t)
		return ([[ 你的周围充满了自然力量，忽略目标 %d%% 的酸性伤害抵抗。 
		 同时酸性能量会治疗你的浮肿软泥怪，增加他们每回合 %0.1f 的生命回复。]])
		:format(ressistpen, regen)
	end,
}


return _M
