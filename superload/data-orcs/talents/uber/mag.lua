
local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ARCANE_AMPLIFICATION_DRONE_EFFECT",
	name = "奥术增幅装置效果",
	info = function(self, t)
		return ([[其受到的法术伤害转化为波纹 , 对半径 4 内的所有目标造成等同于该伤害 160%% 的奥术伤害。]])
	end,}

registerTalentTranslation{
	id = "T_ARCANE_AMPLIFICATION_DRONE",
	name = "奥术增幅装置",
	require_special_desc = "当前或之前的角色在当前难度与模式下解锁过 #{italic}#大灾变的故事#{normal}# 这个成就。", 
	info = function(self, t)
		return ([[你在目标地点放置一个持续 3 回合的奥术增幅装置。
		每当你释放的法术对其造成伤害时，增幅装置把伤害转化为波纹对半径 4 内的所有目标造成等同于该伤害 160%% 的奥术伤害。]])
		:format()
	end,
}
return _M