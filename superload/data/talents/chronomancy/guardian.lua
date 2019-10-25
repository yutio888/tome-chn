local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STRENGTH_OF_PURPOSE",
	name = "意志之力",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[当使用剑、斧、权杖、匕首或者弓箭时，增加武器伤害 %d%% ，物理强度30。
		当装备武器、弹药或者计算武器伤害时，你使用魔法取代你的力量属性进行计算。
		这个技能的奖励伤害取代武器掌握、匕首掌握和弓箭掌握的加成。]]):
		format(100*inc)
	end,
}

registerTalentTranslation{
	id = "T_GUARDIAN_UNITY",
	name = "守卫融合",
	info = function(self, t)
		local trigger = t.getLifeTrigger(self, t)
		local split = t.getDamageSplit(self, t) * 100
		local duration = t.getDuration(self, t)
		local cooldown = self:getTalentCooldown(t)
		return ([[当单次攻击对你造成了最大生命值 %d%% 以上的伤害时，另一个你出现，吸收这次伤害的 %d%% ，并吸收 %d%% 你在接下来 %d 回合中的所有伤害。
		这个克隆体处于现实位面之外，因此只能造成 50%% 伤害，并且射出的箭矢可以穿过友军。		这个技能有冷却时间。]]):format(trigger, split * 2, split, duration)
	end,
}

registerTalentTranslation{
	id = "T_VIGILANCE",
	name = "严阵以待",
	info = function(self, t)
		local sense = t.getSense(self, t)
		local power = t.getPower(self, t)
		return ([[增强你的隐形侦测能力 +%d 以及潜行侦测能力 +%d 。  此外，每回合你有 %d%% 的几率从一个负面状态中回复。
		受魔法属性影响，侦测能力按比例增加。]]):
		format(sense, sense, power)
	end,
}

registerTalentTranslation{
	id = "T_WARDEN_S_FOCUS",
	name = "专注守卫",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local power = t.getPower(self, t)
		local duration = t.getDuration(self, t)
		return ([[使用你的远程或者近战武器对目标造成 %d%% 武器伤害。  在接下来的 %d 回合中，你的随机目标技能，比如闪烁灵刃和守卫召唤将会集中命中目标。
		对这个目标的攻击获得 %d%% 额外的暴击几率和暴击加成，同时其他分级低于目标的单位对你造成的伤害减少 %d%% ]])
		:format(damage, duration, power, power, power)
	end,
}

return _M
