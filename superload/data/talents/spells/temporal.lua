local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CONGEAL_TIME",
	name = "时间凝固",
	info = function(self, t)
		local slow = t.getSlow(self, t)
		local proj = t.getProj(self, t)
		return ([[制造一个扭曲时间的力场，减少目标 %d%% 的整体速度，目标所释放的抛射物减速 %d%% ，持续 7 回合。]]):
		format(100 * slow, proj)
	end,
}

registerTalentTranslation{
	id = "T_TIME_SHIELD",
	name = "时光之盾",
	info = function(self, t)
		local maxabsorb = t.getMaxAbsorb(self, t)
		local duration = t.getDuration(self, t)
		local time_reduc = t.getTimeReduction(self,t)
		return ([[这个复杂的法术在施法者周围立刻制造一个时间屏障，吸收你受到的伤害。 
		 一旦达到最大伤害吸收值（ %d ）或持续时间（ %d 回合）结束，存储的能量会治疗你，持续 5 回合，每回合回复总吸收伤害的 10%% ( 强化护盾技能会影响该系数 )。   
		 受法术强度影响，最大吸收值有额外加成。 ]]):
		 format(maxabsorb, duration)
	end,
}

registerTalentTranslation{
	id = "T_TIME_PRISON",
	name = "时光之牢",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[将目标从时光的流动中移出，持续 %d 回合。 
		 在此状态下，目标不能动作也不能被伤害。 
		 对于目标来说，时间是静止的，技能无法冷却，也没有能量回复…… 
		 受法术强度影响，持续时间有额外加成。]]):
		format(duration)
	end,
}

registerTalentTranslation{
	id = "T_ESSENCE_OF_SPEED",
	name = "时间加速",
	info = function(self, t)
		local haste = t.getHaste(self, t)
		return ([[增加施法者 %d%% 整体速度。]]):
		format(100 * haste)
	end,
}


return _M
