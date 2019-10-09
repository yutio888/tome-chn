local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CHAOS_ORBS",	
	name = "混沌之球",
	info = function(self, t)
		return ([[你操控诞生于强烈疯狂中的混沌。
		每当触发一次强度大于 %d 或者小于 -%d 的混沌效果，你将获得一个持续 1 0 回合的混沌之球（这个效果每回合只能触发一次）。
		每个混沌之球增加你造成的伤害 3%% ，总共可以获得 %d 个混沌之球。]]):
		format(t.getTrigger(self, t), t.getTrigger(self, t), t.getMax(self, t))
	end,
}
registerTalentTranslation{
	id = "T_ANARCHIC_WALK",	
	name = "混沌穿行",
	info = function(self, t)
		return ([[消耗 2 个混沌之球，令你朝指定的方向随机传送不超过 %d 格的距离。可能的话，你被传送的最短距离为 %d 格。]]):format(t.getMax(self, t), self:getTalentRange(t))
	end,
}
registerTalentTranslation{
	id = "T_DISJOINTED_MIND",	
	name = "意识粉碎",
	info = function(self, t)
		return ([[你在目标位置引爆混沌之球。
		这场爆炸不造成伤害，但是会使目标混乱 %d 回合，同时每引爆一个球，混乱强度增加 10%% 。
		在对抗目标的精神豁免时，每个混乱之球还会增加你的有效法术强度10%% 。
		这个技能会消耗所有的混乱之球。]]):
		format(t.getDur(self, t))
	end,
}
registerTalentTranslation{
	id = "T_CONTROLLED_CHAOS",	
	name = "混沌掌控",
	info = function(self, t)
		return ([[你令混沌力量朝更有利于自身的方向偏移。
		混沌效果产生的最大负面影响从 50%% 减少至 %d%% 。
		你可以主动开启该技能，消耗所有混沌之球，每消耗一个获得 %d 疯狂值。]]):
		format(t.getReduced(self, t), t.getInsanity(self, t))
	end,
}
return _M
