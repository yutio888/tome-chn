local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TEMPORAL_BOLT",
	name = "时空之箭",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[ 将一道时空之箭射入时间线中。
		时空之箭会返回你的位置，对路径上目标造成 %0.2f 时空伤害。每飞行 1 格，伤害增加 5%% 。
		每命中一个目标会减少你随机一个冷却中的时空技能一回合 CD。
		技能等级 5 时，减少 2 回合cd。]]):
		format(damDesc(self, DamageType.TEMPORAL, damage))
	end,
}

registerTalentTranslation{
	id = "T_TIME_SKIP",
	name = "时间跳跃",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[造成 %0.2f 时空伤害。如果你的目标存活，他将被从这个时空放逐 %d 回合。
		伤害受到法术强度加成。	]]):format(damDesc(self, DamageType.TEMPORAL, damage), duration)
	end,
}

registerTalentTranslation{
	id = "T_TEMPORAL_REPRIEVE",
	name = "时空避难所",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[将自己传送至安全的位置，停留 %d 回合.]]):
		format(duration)
	end,
}

registerTalentTranslation{
	id = "T_ECHOES_FROM_THE_PAST",
	name = "往昔回响",
	info = function(self, t)
		local percent = t.getPercent(self, t) * 100
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		return ([[在半径 %d 的范围内制造一次时空回响。
		范围内的生物将受到 %0.2f 时空伤害，然后额外受到等于当前已损失生命值 %d%% 的伤害。
		额外伤害将被对面怪物的阶级除。
		伤害受法术强度加成。]]):
		format(radius, damDesc(self, DamageType.TEMPORAL, damage), percent)
	end,
}

return _M
