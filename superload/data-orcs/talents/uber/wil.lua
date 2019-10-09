local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RANGE_AMPLIFICATION_DEVICE",
	name = "射程增幅装置",
	require_special_desc ="光照范围为10或以上", 
	info = function(self, t)
		return ([[启动一个特殊的聚焦装置来使你的所有远程魔法和精神技能射程延长 3 （仅对射程至少为 2 的技能生效，且上限为 1 0 ）。
		使用这个装置非常的费力，启动时会增加 60%% 疲劳值。]])
		:format()
	end,
}
return _M