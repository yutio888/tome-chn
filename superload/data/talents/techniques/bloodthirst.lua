local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MORTAL_TERROR",
	name = "致命恐惧",
	info = function(self, t)
		return ([[你强力的攻击引发敌人深深的恐惧。 
		任何你对目标造成的超过其 %d%% 总生命值的近身打击会使目标陷入深深的恐惧中，眩晕目标 5 回合。 
		你的暴击率同时增加 %d%% 。 
		受物理强度影响，眩晕概率有额外加成。]]):
		format(t.threshold(self, t), self:getTalentLevelRaw(t) * 2.8)
	end,
}

registerTalentTranslation{
	id = "T_BLOODBATH",
	name = "浴血奋战",
	info = function(self, t)
		local regen = t.getRegen(self, t)
		local max_regen = t.getMax(self, t)
		local max_health = t.getHealth(self,t)
		return ([[沐浴着敌人的鲜血令你感到兴奋。 
		在成功打出一次暴击后，会增加你 %d%% 的最大生命值、 %0.2f 每回合生命回复点数和 %0.2f 每回合体力回复点数持续 %d 回合。  
		生命与体力回复可以叠加 5 次直至 %0.2f 生命和 %0.2f 体力回复 / 回合。]]):
		format(t.getHealth(self, t), regen, regen/5, t.getDuration(self, t),max_regen, max_regen/5)
	end,
}

registerTalentTranslation{
	id = "T_BLOODY_BUTCHER",
	name = "血之屠夫",
	info = function(self, t)
		return ([[你沉醉于撕裂伤口的兴奋中，增加 %d 物理强度。
		同时，每次你让敌人流血时，它的物理抗性下降 %d%% （但不会小于 0 ）
		物理强度加成受力量影响。]]):
		format(t.getDam(self, t), t.getResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_UNSTOPPABLE",
	name = "天下无双",
	info = function(self, t)
		return ([[你进入疯狂战斗状态 %d 回合。 
		在这段时间内你不能使用物品，并且治疗无效，此时你的生命值无法低于 1 点。 
		状态结束后你每杀死一个敌人可以回复 %d%% 最大生命值。
		当进入无双状态时，由于你失去了死亡的威胁，狂战之怒不能提供暴击加成。]]):
		format(t.getDuration(self, t), t.getHealPercent(self,t))
	end,
}


return _M
