
local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_PAIN_ENHANCEMENT_SYSTEM",
	name = "痛苦强化系统",
	mode = "passive",
	require_special_desc ="当前角色解锁了‘伤害很重要’成就。",
	info = function(self, t)
		return ([[系统将会在你暴击时启动，在 6 回合内你的全属性( 力量除外 ) 将会增加等同于你 50%% 力量的值。
		该效果有冷却时间。
		]])
		:format()
	end,
}
return _M