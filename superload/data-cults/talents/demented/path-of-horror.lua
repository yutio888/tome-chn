local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_CARRION_FEET",
	name = "蠕动之足",
	info = function(self, t)
		return ([[蠕虫在你脚下不断产生，它们在你行走的时候不断爆裂，被动地增加你 %d%% 移动速度。
		你也可以激活这个天赋来引爆更多的蠕虫，让你跳跃到 %d 码外的可见地形。
		着陆时会有更多的蠕虫爆裂，形成范围 2 码的脓液喷射；范围内的生物下回合造成的伤害降低 70%% 。
		如果有敌人受到脓液喷射的影响，你会得到额外 20 点疯狂值。]]):
		format(t.getPassiveSpeed(self, t)*100, self:getTalentRange(t))
	end,
}

registerTalentTranslation{
	name = "恐怖进化",
	id = "T_DECAYING_GUTS",
	info = function(self, t)
		return ([[你的突变强化了你的攻击能力。
		你获得 %d 命中和 %d 法术强度。
		技能效果会随着你的魔法属性增强。]])
		:format(t.getAccuracy(self, t), t.getSpellpower(self, t))
	end,
}

registerTalentTranslation{
	name = "巨型变异", 
	id = "T_CULTS_OVERGROWTH",
	info = function(self, t)
		return ([[你激发了一次持续 %d 回合的体细胞急速变异。
		你的身体急速变大，获得 + 2 体型，并使你能够在行走时随意撞碎墙壁。增加 %d%% 全体伤害和 %d%% 全体伤害抗性。
		你的巨大体型使你在每次行走时都导致一场小型的地震，破坏并重组周围的地形。]]):
		format(t.getDur(self, t), t.getDam(self, t), t.getResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WRITHING_ONE",
	name = "终极异变",
	info = function(self, t)
		return ([[你终于解开了这具变异身体的最终力量！
		你获得 %d%% 震慑免疫 , %d%% 几率无视受到的暴击，并且增加 %d%% 黑暗及枯萎伤害。]]):
		format(t.getImmunities(self, t) * 100, t.getCritResist(self, t), t.getDam(self, t))
	end,
}

return _M
