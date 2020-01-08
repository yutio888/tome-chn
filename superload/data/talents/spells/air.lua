local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_LIGHTNING",
	name = "闪电术",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[用魔法召唤一次强力的闪电造成 %0.2f ～ %0.2f 伤害（平均 %0.2f ）。 
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.LIGHTNING, damage / 3),
		damDesc(self, DamageType.LIGHTNING, damage),
		damDesc(self, DamageType.LIGHTNING, (damage + damage / 3) / 2))
	end,
}

registerTalentTranslation{
	id = "T_CHAIN_LIGHTNING",
	name = "连锁闪电",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local targets = t.getTargetCount(self, t)
		return ([[召唤一次叉状闪电造成 %0.2f ～ %0.2f 伤害（平均 %0.2f ）并连锁到另外一个目标。 
		它最多可以连锁 10 码范围内 %d 个目标并且不会对同一目标伤害 2 次，同样它不会伤害到施法者。 
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.LIGHTNING, damage / 3),
			damDesc(self, DamageType.LIGHTNING, damage),
			damDesc(self, DamageType.LIGHTNING, (damage + damage / 3) / 2),
			targets)
 end,
}

registerTalentTranslation{
	id = "T_FEATHER_WIND",
	name = "风之羽翼",
	info = function(self, t)
		local encumberance = t.getEncumberance(self, t)
		local rangedef = t.getRangedDefence(self, t)
		local stun = t.getStunImmune(self, t)
		local pin = t.getPinImmune(self, t)
		return ([[一股温柔的风围绕着施法者，增加 %d 点负重能力，增加 %d 点对抛射物的闪避，获得 %d%% 定身免疫和 %d%% 震慑免疫。 
		在等级 4 时，它会使你轻微的漂浮在空中，可忽略部分陷阱。 
		在等级 5 时，同时还会提升你 %d%% 的移动速度并且移除 %d 点负重。]]):
		format(encumberance, rangedef, pin*100, stun*100, t.getSpeed(self, t) * 100, t.getFatigue(self, t))
	end,
}

registerTalentTranslation{
	id = "T_THUNDERSTORM",
	name = "闪电风暴",
	info = function(self, t)
		local targetcount = t.getTargetCount(self, t)
		local damage = t.getDamage(self, t)
		return ([[当此技能激活时，在 6 码半径范围内召唤一阵强烈的闪电风暴跟随你。 
		每回合闪电风暴会随机伤害 %d 个敌方单位，对 1 码半径范围造成 1.00 ～ %0.2f 伤害（平均 %0.2f ）。 
		受法术强度影响，伤害有额外加成。]]):
		format(targetcount, damDesc(self, DamageType.LIGHTNING, damage), damDesc(self, DamageType.LIGHTNING, damage / 2))
	end,
}


return _M
