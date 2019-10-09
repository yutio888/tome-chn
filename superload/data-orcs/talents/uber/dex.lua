
local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_AUTOMATED_REFLEX_SYSTEM",
	name = "自动化反射系统",
	require_special_desc ="当前或之前的角色在当前难度与模式下解锁过 #{italic}#黑客帝国#{normal}# 这个成就。.",
	info = function(self, t)
		return ([[在身上安装一个小型自动投射物监测系统。每当一个投射物即将击中你时，它会注射药物来强化你的反应能力，给你一个额外回合。
		这个效果最短每 5 回合触发一次。]])
		:format()
	end,
}
return _M