
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

registerTalentTranslation{
	id = "T_TECHNOMANCER",
	name = "科技法师",
	info = function(self, t)
		return ([[科技法师是一些特殊的元素法师，他精通于蒸汽科技，用科技的力量来强化他们已经足够强大的法术力量。
		当你选择这一项进阶职业的时候，你获得以下能力：
		- 奥术发电机插件配方
		- 蒸汽/物理系 （已解锁）
		- 蒸汽/化学系 （未解锁）
		- 一个便携式自动材料提取仪。
		- 1级铁匠技能，2级机械和电子技能。
		- 法术/科技法术：放电系 （未解锁）
		- 法术/科技法术：寒岩系 （未解锁）
		- 法术/科技法术：超自然系 （未解锁）
		- 你可以免费解锁三个科技法术系的其中之一。

		当你装备长袍的时候，奥术发电机会在你消耗魔法值的时候自动产生蒸汽，并根据蒸汽等级提升法术强度。
		#{bold}#当你完成这职业进阶的时候，你应该尽快制造一个奥术发电机，装备在长袍中，以使用科技法术的力量。#{normal}#]])
		:format()
	end,
}
return _M