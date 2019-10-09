local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ATROPHY",
	name = "衰亡",
	info = function(self, t)
		return ([[吸收他人时间的熵能漩涡围绕着你。当你释放法术时，半径 10 格内的随机目标将迅速老化、凋零，所有属性降低 %d ，持续 8 回合，效  果可叠加 %d 层。
			每次施法可以释放最多 %d 层加速衰老，但同一目标一次最多增加 2 层效果。]]):
		format(t.getStat(self, t), t.getMaxStacks(self, t), t.getStacks(self, t))
	end
}

registerTalentTranslation{
	id = "T_SEVERED_THREADS",
	name = "断绝",
	info = function(self, t)
		local life = t.getLife(self,t)*100
		local dur = t.getDuration(self,t)
		local power = t.getPower(self,t)
		return ([[当对不足 %d%% 最大生命值的目标释放衰亡时，你将尝试切断目标的生命线，立刻杀死目标。在接下来的 %d 回合中，你将会享用目标残余的生命线，增加你的生命回复 %0.1f 并使没有固定冷却时间的技能冷却速度  加倍。
		这个技能的增益效果每 15 回合只能发动一次。]])
		:format(life, dur, power)
	end
}

registerTalentTranslation{
	id = "T_TEMPORAL_FEAST",
	name = "盛宴",
	info = function(self, t)
		local speed = t.getSpeed(self,t)*100
		local slow = t.getSlow(self,t)*100
		return ([[你进一步榨取他人的时间线。每次使用衰亡时，目标身上的每层衰亡效果将使你获得 %0.1f%% 施法速度，同时目标将失去 %d%% 回合。
			计算施法速度增加时，会使用你周围最高层数的衰亡效果。]])
		:format(speed, slow)
	end
}

registerTalentTranslation{
	id = "T_TERMINUS",
	name = "终点",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local rad = self:getTalentRadius(t)
		local turn = t.getTurn(self,t)/10
		return ([[打破时空连续性，对 %d 格内所有敌人造成 %0.2f 时空伤害。同时，衰亡状态将窃取目标的时间，每层造成额外 %0.2f 时空伤害并使你获得 %d%% 回合（最多获得 3 回合）。
		伤害随法术强度增加。]]):format(rad,damDesc(self, DamageType.TEMPORAL, damage),  damDesc(self, DamageType.TEMPORAL, damage/6), turn)
	end
}

return _M
