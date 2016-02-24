local _M = loadPrevious(...)


registerTalentTranslation{
	id = "T_SUBCUTANEOUS_METALLISATION",
	name = "Subcutaneous Metallisation",
	info = function(self, t)
		return ([[When your life dips below 50%% of your total life an automated process turns some of your lower skin layers (or other internal organs) into a thick metallic layer for 6 turns.
		While the effect lasts all damage done to you is reduced by a flat amount equal to 150%% of your Constitution.]])
		:format()
	end,
}
