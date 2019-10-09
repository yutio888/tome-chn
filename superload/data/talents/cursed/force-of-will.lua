local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WILLFUL_STRIKE",
	name = "偏执打击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local knockback = t.getKnockback(self, t)
		return ([[专注你的仇恨，你用无形的力量打击敌人造成 %d 点伤害和 %d 码击退效果。 
		 此外，你灌注力量的能力使你增加 %d%% 所有暴击伤害。（当前： %d%% ） 
		 受精神强度影响，伤害有额外加成。]]):format(damDesc(self, DamageType.PHYSICAL, damage), knockback, t.critpower(self, t), self.combat_critical_power or 0)
	end,
}

registerTalentTranslation{
	id = "T_DEFLECTION",
	name = "念力折射",
	info = function(self, t)
		local maxDamage = t.getMaxDamage(self, t)
		local recharge_rate = t.getRechargeRate(self, t)
		return ([[用你的意志力折射 50%% 的伤害。你可以折射最多 %d 点伤害，护盾值每回合回复最大值的 1 / %d 。（技能激活时 -0.2 仇恨值回复）。 
		 你灌注力量的能力使你增加 %d%% 所有暴击伤害。（当前： %d%% ） 
		 受精神强度影响，最大伤害折射值有额外加成。]]):format(maxDamage, recharge_rate, t.critpower(self, t),self.combat_critical_power or 0)
	end,
}

registerTalentTranslation{
	id = "T_BLAST",
	name = "怒火爆炸",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		local knockback = t.getKnockback(self, t)
		local dazeDuration = t.getDazeDuration(self, t)
		return ([[你将愤怒聚集在一点，然后向 %d 码范围内所有方向炸开。爆炸造成 %d 点伤害，在中心点处造成 %d 码击退效果，距离越远效果越弱。 
		 在爆炸范围内的任何目标将会被眩晕 3 回合。 
		 你灌注力量的能力使你每点增加 %d%% 所有暴击伤害。（当前： %d%% ） 
		 受精神强度影响，伤害有额外加成。]]):format(radius, damDesc(self, DamageType.PHYSICAL, damage), knockback, t.critpower(self, t), self.combat_critical_power or 0)
	end,
}

registerTalentTranslation{
	id = "T_UNSEEN_FORCE",
	name = "怒意鞭笞",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		local knockback = t.getKnockback(self, t)
		local secondHitChance = t.getSecondHitChance(self, t)
		local hits = 1 + math.floor(secondHitChance/100)
		local chance = secondHitChance - math.floor(secondHitChance/100)*100
		return ([[你的愤怒变成一股无形之力，猛烈鞭笞你附近的随机敌人。在 %d 回合内，你将攻击 %d （ %d%% 概率攻击 %d ）个半径 5  以内的敌人，造成 %d 点伤害并击退 %d 码。额外攻击的数目随技能等级增长。 
		 你灌注力量的能力使你增加 %d%% 所有暴击伤害。（当前： %d%% ） 
		 受精神强度影响，伤害有额外加成。]]):format(duration, hits, chance, hits+1, damDesc(self, DamageType.PHYSICAL, damage), knockback, t.critpower(self, t), self.combat_critical_power or 0)
	end,
}



return _M
