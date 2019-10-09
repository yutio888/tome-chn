local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_OSMOSIS_SHIELD",
	name = "渗透护盾",
	info = function(self, t)
		return ([[你的盾牌充满了恶魔能量，带来一层魔法护盾，每回合受到第一次伤害时给予你持续 3 回合的治疗（基于格挡值），治疗效果可以叠加。
		 治疗量等于 5+ %d%% 格挡值（当前 %d 点）。
		 技能等级 3 时，如果伤害在治疗量两倍以上，有 %d%% 几率解除你一个负面物理状态。
		 在休息和跑步时，该技能自动终止。
		#{bold}#开启护盾不消耗时间，关闭护盾消耗时间。#{normal}#]])
		:format(self:combatTalentLimit(t, 50, 15, 40), t.getAbsorb(self, t), t.getChance(self, t))
	end,
}


registerTalentTranslation{
	id = "T_HARDENED_CORE",
	name = "硬化之核",
	info = function(self, t)
		return ([[从恶魔家乡中学习，强化自身。
		 增加 10 + %d%% 总护甲值 ,每点力量提供 %d%% 法术强度。]]):
		format((self:combatTalentScale(t, 1.1, 1.6)-1) * 100, self:combatTalentScale(t, 20, 40, 0.75))
	end,
}


registerTalentTranslation{
	id = "T_DEMONIC_MADNESS",
	name = "疯狂旋转",
	info = function(self, t)
		return ([[你疯狂旋转你的盾牌，攻击周围生物，造成 %d%% 暗影盾牌伤害并使其混乱 %d 回合。
		 技能等级 4 时，你自动进入格挡状态。]]):
		format(t.getDam(self, t) * 100, t.getDur(self, t))
	end,
}


registerTalentTranslation{
	id = "T_BLIGHTED_SHIELD",
	name = "枯萎能量",
	info = function(self, t)
		return ([[你的盾牌充满强大的枯萎能量。每次你格挡并附加反击状态时，目标将被虚弱诅咒感染， 5 回合内降低 %d%% 伤害。
		 效果受法术强度加成。]]):format(t.imppower(self,t))
	end,
}


return _M
