local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ARCANE_POWER",
	name = "奥术能量",
	info = function(self, t)
		local resist = self.sustain_talents[t.id] and self.sustain_talents[t.id].display_resist or t.getArcaneResist(self, t)
		return ([[你对魔法的理解使你进入精神集中状态，增加 %d 点法术强度和 %d%% 奥术抗性。]]):
		format(t.getSpellpowerIncrease(self, t), resist)
	end,
}

registerTalentTranslation{
	id = "T_MANATHRUST",
	name = "奥术射线",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[制造出一个强大的奥术之球对目标造成 %0.2f 奥术伤害。 
		在等级 3 时，它会有穿透效果。 
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.ARCANE, damage))
	end,
}

registerTalentTranslation{
	id = "T_ARCANE_VORTEX",
	name = "奥术漩涡",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[在目标身上放置一个持续 6 回合的奥术漩涡。 
		每回合，奥术漩涡会随机寻找视野内的另一个敌人，并且释放一次奥术射线，对一条线上的所有敌人造成 %0.2f 奥术伤害。 
		若没有发现其他敌人，则目标会承受 150 ％额外奥术伤害。 
		若目标死亡，则奥术漩涡爆炸并释放所有的剩余奥术伤害，在 2 码半径范围内形成奥术爆炸。 
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.ARCANE, dam))
	end,
}

registerTalentTranslation{
	id = "T_DISRUPTION_SHIELD",
	name = "干扰护盾",
	info = function(self, t)
		return ([[你的身边充满奥术力量，制造出一层能吸收%d伤害的护盾。
		在战斗中你无法集中精力持续维持这层护盾，一旦护盾值消耗归零，则会使用你的法力值来吸收伤害，比例为%0.2f法力吸收一点伤害。
		每当法力值被该效果消耗时，护盾会储存一定能量（最多%d）。当护盾关闭时，这些储存的能量将转化为在你身边%d格的奥术风暴，在5回合内造成累计等于能量值的奥术伤害。
		战斗外该护盾每回合回复10%%，同时储存的能量迅速消散。
		护盾值受法术强度加成。
		最大储存能量受原始法力值上限加成。

		当前护盾值：%d
		当前储能: %d]]):
		format(t.getMaxAbsorb(self, t), t.getManaRatio(self, t), t.getMaxDamage(self, t), self:getTalentRadius(t), self.disruption_shield_power or 0, self.disruption_shield_storage or 0)
	end,
}




return _M
