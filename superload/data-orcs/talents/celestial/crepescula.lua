local _M = loadPrevious(...)

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

每点光  伤害减速敌人 %0.2f%% 持续 %d 回合, 在 %d 伤害时达到最大值, 为 %d%% .
暗系伤害创造一个持续 %d 回合的地块, 每回合造成伤害的 %d%%. 当有另一个微光回响激活或目标持续承受此伤害时, 将刷新持续时间, 剩余伤害和新承受的伤害将平分至新持续时间内.]])
		:format(duration, slow_per * 100, echo_dur, slow_max * 100, slow_max/slow_per, echo_dur, 100 * echo_factor)
	end,}
	
	return _M