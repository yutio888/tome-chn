
local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RAKSHOR_CUNNING",
	name = "Rak'Shor's Cunning", 
	require_special_desc = "Skeleton and Ghoul unlocked and not already undead.",
	info = function(self, t)
		return ([[Set up some cunning contingency plans in case of death.
		If you die you will have the option to raise back from the dead once, but at the cost of becoming a ghoul or a skeleton, at random.
		When rising this way you will lose access to your racial tree, if any, get refunded for half the points you spent in it and gain access to the ghoul or skeleton racial tree.
		As undead are not able to use infusions you will lose any that you may have upon turning.]])
		:format()
	end,
}
