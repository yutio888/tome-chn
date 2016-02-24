
local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_PAIN_ENHANCEMENT_SYSTEM",
	name = "Pain Enhancement System",
	mode = "passive",
	require_special_desc ="Earned the achievement 'Size Is Everything' on this character.",
	info = function(self, t)
		return ([[When you deal a critical hit your embedded system activates, increasing all your primary stats by 40%% of your Strength for 6 turn.]])
		:format()
	end,
}
