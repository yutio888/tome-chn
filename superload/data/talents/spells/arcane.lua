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
		local radius = self:hasEffect(self.EFF_AETHER_AVATAR) and 10 or 3
		return ([[你的身边充满奥术力量，阻止你受到的伤害，并将其改为扣减法力值。
		你受到的伤害的 25%% 将会被改为扣减法力值，每点伤害扣减 %0.2f 点法力值。伤害护盾会降低这一消耗。
		当你解除干扰护盾时，你会获得 100 点法力值，并在你周围产生半径为 %d 的致命的奥术风暴，持续 10 回合，每回合造成 10%% 的吸收的总伤害，共造成 %d 点伤害。
		当你的法力值不足 10%% 时，你会自动解除这一技能。
		伤害到魔法的比例受你的法术强度加成。]]):
		format(t.getManaRatio(self, t), radius, damDesc(self, DamageType.ARCANE, t.getMaxDamage(self, t)))
	end,
}


return _M
