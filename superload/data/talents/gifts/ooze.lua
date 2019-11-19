local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MITOSIS",
	name = "有丝分裂",
	info = function(self, t)
		local xs = self:knowTalent(self.T_REABSORB) and ([[同时，当这个技能开启时，每回合回复 %0.1f 点失衡值。
		]]):format(self:callTalent(self.T_REABSORB, "equiRegen")) or ""
		return ([[你的身体构造变的像软泥怪一样。 
		当你受到攻击时，你有几率分裂出一个浮肿软泥怪，其生命值为你所承受的伤害值的两倍（最大 %d ）。 
		分裂几率为你损失生命百分比的 %0.2f 倍。
		你所承受的所有伤害会在你和浮肿软泥怪间均摊。 
		每只浮肿软泥怪存在%d回合，你同时最多只能拥有 %d 只浮肿软泥怪（基于你的灵巧值和技能等级）。
		浮肿软泥怪对非均摊的伤害的抗性很高（ %d%% 对全部伤害的抗性）,同时生命回复快。
		受精神强度影响，最大生命值有额外加成。 
		受灵巧影响，几率有额外加成。]]):
		format(t.getMaxHP(self, t), t.getChance(self, t)*3/100, t.getSummonTime(self, t),  t.getMax(self, t),t.getOozeResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_REABSORB",
	name = "强化吸收",
	info = function(self, t)
		return ([[ 你随机吸收一个紧靠你的浮肿软泥怪，获得 40%% 对全部伤害的抗性，持续 %d 个回合。 
		同时你会释放一股反魔能量，在 %d 半径内造成 %0.2f 点法力燃烧伤害。 
		如果有丝分裂技能开启，每回合你将回复 %0.1f 点失衡值。
		受精神强度影响，伤害、持续时间和失衡值回复有额外加成。]]):
		format(t.getDuration(self, t), 3,damDesc(self, DamageType.ARCANE, t.getDam(self, t)),	 t.equiRegen(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CALL_OF_THE_OOZE",
	name = "软泥召唤",
	info = function(self, t)
		return ([[立刻召集所有的浮肿软泥怪来战斗，如果现有浮肿软泥怪数目比最大值小，最多可以制造 %d 个浮肿软泥怪，每一个的生命值为 %d （有丝分裂技能允许的生命最大值的 %d%% ）。 
		每一个浮肿软泥怪将被传送到其视野内的敌人附近，并吸引其注意力。 
		利用这一形势，你将对浮肿软泥怪面对的敌人各造成一次近战酸性伤害，数值为武器伤害的 %d%% 。]]):
		format(t.getMax(self, t), t.getLife(self, t), t.getModHP(self, t)*100, t.getWepDamage(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_INDISCERNIBLE_ANATOMY",
	name = "奇异骨骼",
	info = function(self, t)
		return ([[ 你身体里的内脏全都融化在一起，隐藏了你的要害部位。 
		你有 %d%% 几率摆脱任何（物理，精神，法术）暴击。
		你将额外获得 %d%% 的疾病、毒素、切割和目盲免疫。]]):
		format(t.critResist(self, t), 100*t.immunities(self, t))
	end,
}


return _M
