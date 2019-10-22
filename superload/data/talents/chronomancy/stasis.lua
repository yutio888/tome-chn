local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SPACETIME_STABILITY",
	name = "时空稳定",
	info = function(self, t)
		local tune = t.getTuning(self, t)
		return ([[当时空调谐处于非激活状态时，你的紊乱值每回合自动向设定值调整  %0.2f  点。
		处于激活状态时，该效果加倍。]]):
		format(tune)
	end,
}

registerTalentTranslation{
	id = "T_CHRONO_TIME_SHIELD",
	name = "时间盾",
	info = function(self, t)
		local maxabsorb = t.getMaxAbsorb(self, t)
		local duration = t.getDuration(self, t)
		local time_reduc = t.getTimeReduction(self,t)
		return ([[这个复杂的法术会立刻在施法者身边制造一个时空屏障，阻止受到的一切伤害，并将其送到将来。		一旦护盾吸收伤害达到最大值 ( %d )，或者持续时间结束 ( %d  回合 )，储存的伤害将会返回变为一个时空回复场，持续五回合。
		每回合回复场可以为你回复吸收伤害的  10%%  。
		当激活时光之盾时，所有新附加的魔法、物理和精神状态的持续时间减少  %d%%  。		受法术强度影响，护盾的最大吸收值有额外加成。]]):
		format(maxabsorb, duration, time_reduc)
	end,
}

registerTalentTranslation{
	id = "T_STOP",
	name = "时间静止",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		return ([[造成  %0.2f  时空伤害，并试图震慑半径  %d  码  范围内所有目标  %d  回合。
		受法术强度影响，伤害按比例加成。]]):
		format(damDesc(self, DamageType.TEMPORAL, damage), radius, duration)
	end,
}

registerTalentTranslation{
	id = "T_STATIC_HISTORY",
	name = "静态历史",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[接下来的  %d  回合中，你不会产生微小异变。   当随机异变正常发生时，不会导致你获得紊乱值或者施法失败。
		这个技能对重大异变没有影响。]]):
		format(duration)
	end,
}

return _M
