local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_LIGHTNING_INFUSION",
	name = "闪电充能",
	info = function(self, t)
		local daminc = t.getIncrease(self, t)
		return ([[ 将闪电能量填充至炼金炸弹，能眩晕敌人。
		 你造成的闪电伤害增加 %d%% 。]]):
		format(daminc)
	end,
}

registerTalentTranslation{
	id = "T_DYNAMIC_RECHARGE",
	name = "动态充能",
	info = function(self, t)
		return ([[ 当闪电充能开启时，你的炸弹会给傀儡充能。
		 你的傀儡的所有冷却中技能有 %d%% 概率减少 %d 回合冷却时间。]]):
		format(t.getChance(self, t), t.getNb(self, t))
	end,
}

registerTalentTranslation{
	id = "T_THUNDERCLAP",
	name = "闪电霹雳",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[ 粉碎一颗炼金宝石，制造一次闪电霹雳，在半径 %d 的锥形区域内造成 %0.2f 点物理伤害和 %0.2f 点闪电伤害。
		 范围内的生物将会被击退并被缴械 %d 回合。
		 受法术强度影响，伤害和持续时间有额外加成。]]):format(radius, damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), damDesc(self, DamageType.LIGHTNING, t.getDamage(self, t)), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_LIVING_LIGHTNING",
	name = "闪电之体",
	info = function(self, t)
		local speed = t.getSpeed(self, t) * 100
		local dam = t.getDamage(self, t)
		local turn = t.getTurn(self, t)
		local range = self:getTalentRange(t)
		return ([[ 将闪电能量填充到身体中，增加 %d%% 移动速度。
		 每回合半径 %d 内的一个生物将会被闪电击中，造成 %0.2f 点闪电伤害。
		 每次你的回合开始时，如果自从上个回合结束你受到超过 20%% 最大生命值的伤害，你将获得 %d%% 个额外回合。
		 受法术强度影响，伤害有额外加成。]]):
		format(speed, range, damDesc(self, DamageType.LIGHTNING, t.getDamage(self, t)), turn)
	end,
}


return _M
