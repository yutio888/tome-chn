local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TACTICAL_EXPERT",
	name = "战术大师",
	info = function(self, t)
		local defense = t.getDefense(self, t)
		local maximum = t.getMaximum(self, t)
		return ([[每个可见的相邻敌人可以使你的闪避增加 %d 点，最大增加 +%d 点闪避。 
		 受灵巧影响，闪避增益和增益最大值按比例加成。]]):format(defense, maximum)
	end,
}

registerTalentTranslation{
	id = "T_COUNTER_ATTACK",
	name = "相位反击",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[当你闪避一次紧靠着你的对手的近战攻击时你有 %d%% 的概率对对方造成一次 %d%% 伤害的反击 , 每回合最多触发 %0.1f 次。 
		 徒手格斗时会尝试将敌人掀翻在地，眩晕两回合，如果处于抓取状态改为震慑。 
		 受灵巧影响，反击概率和反击数目有额外加成。]]):format(t.counterchance(self,t), damage,  t.getCounterAttacks(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SET_UP",
	name = "致命闪避",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local power = t.getPower(self, t)
		local defense = t.getDefense(self, t)
		return ([[增加 %d 点闪避，持续 %d 回合。当你闪避 1 次近战攻击时，你可以架起目标，有 %d%% 概率使你对目标进行 1 次暴击并减少它们 %d 点豁免。 
		 受灵巧影响，效果按比例加成。]])
		:format(defense, duration, power, power)
	end,
}

registerTalentTranslation{
	id = "T_EXPLOIT_WEAKNESS",
	name = "弱点感知",
	info = function(self, t)
		local reduction = t.getReductionMax(self, t)
		return ([[感知对手的物理弱点，代价是你减少 10%% 物理伤害。每次你击中对手时，你会减少它们 5%% 物理伤害抵抗，最多减少 %d%% 。]]):format(reduction)
	end,
}



return _M
