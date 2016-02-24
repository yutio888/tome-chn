
local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RANGE_AMPLIFICATION_DEVICE",
	name = "Range Amplification Device",
	require_special_desc ="Have a light radius of 10 or more", 
	info = function(self, t)
		return ([[Activate a special focusing device that extends all your ranged spells and psionic powers range by 3 (only works on those with range 2 or more and up to 10 max).
		The use of this device is very strenuous, increasing fatigue by 60%% while active.]])
		:format()
	end,
}
