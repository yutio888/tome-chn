local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_NEBULA_SPEAR",
	name = "星云之矛",
	info = function(self, t)
		local damage = damDesc(self, DamageType.DARKNESS, t.getDamage(self, t))
		local radius = self:getTalentRadius(t)
		return ([[射出一个带有宇宙能量的矛. 如果击中敌人将造成 %0.2f 伤害, 否则它在到达最大射程时爆炸并造成一个范围 %d 的锥形伤害, 能被敌人阻挡, 造成 %0.2f 至 %0.2f 伤害取决于有多少个敌人阻挡.]]):
		format(damage * 2.5, radius, damage, damage * 2.5)
	end,}

registerTalentTranslation{
	id = "T_CRESCENT_WAVE",
	name = "新月波动",
	info = function(self, t)
		return ([[向顺时针方向发射一个抛射物. 如果击中敌人将造成 %0.2f 伤害并定身 1 回合. 如果另一个抛射物在 %d 回合里击中他们, 他们将只收到一半的伤害并再次定身.]])
	end,}

registerTalentTranslation{
	id = "T_TWILIT_ECHOES",
	name = "微光回响",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local echo_dur = t.getEchoDur(self, t)
		local slow_per = t.getSlowPer(self, t)
		local slow_max = t.getSlowMax(self, t)
		local echo_factor = t.getDarkEcho(self, t)
		return ([[目标会受到你所有光暗伤害的回响, 持续 %d 回合. 

每点光伤害减速敌人 %0.2f%% 持续 %d 回合, 在 %d 伤害时达到最大值, 为 %d%% .
暗系伤害创造一个持续 %d 回合的地块, 每回合造成伤害的 %d%%. 当有另一个微光回响激活或目标持续承受此伤害时, 将刷新持续时间, 剩余伤害和新承受的伤害将平分至新持续时间内.
]])
		:format(duration, slow_per * 100, echo_dur, slow_max * 100, slow_max/slow_per, echo_dur, 100 * echo_factor)
	end,}

registerTalentTranslation{
	id = "T_STARSCAPE",
	name = "星界领域",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		
		return ([[在 %d 范围内召唤一片星界领域 . %d 回合内, 这个区域存在于正常时间之外, 且重力为零. 除了零重力之外, 抛射物和生物的活动比平时慢 3 倍. 法术和攻击不能逃脱范围, 直到效果结束.]]):
		format(radius, duration)
	end,}
	
	return _M