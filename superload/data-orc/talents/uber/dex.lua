
local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_AUTOMATES_REFLEX_SYSTEM",
	name = "Automated Reflex System",
	require_special_desc ="Have gained the #{italic}#Matrix Style#{normal}# achievement with this or any previous character for the current difficulty & permadeath settings.",
	info = function(self, t)
		return ([[A small automatic detection system is always looking for incoming projectiles, when one is about to hit you it injects drugs into your system to boost your reactivity, granting you a free turn.
		This effect can not happen more than once every 5 turns.]])
		:format()
	end,
}
