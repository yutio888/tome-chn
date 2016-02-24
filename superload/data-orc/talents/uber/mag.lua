
local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ARCANE_AMPLIFICATION_DRONE_EFFECT",
	name = "Arcane Amplification Drone Effect",
	info = function(self, t)
		return ([[Spell damage done to it ripples in radius 4 doing 160% arcane damage.]])
	end,}

registerTalentTranslation{
	id = "T_ARCANE_AMPLIFICATION_DRONE",
	name = "Arcane Amplification Drone",
	require_special_desc = "Have gained the #{italic}#Tales of the Spellblaze#{normal}# achievement with this or any previous character for the current difficulty & permadeath settings.", 
	info = function(self, t)
		return ([[You create an Arcane Amplification Drone at the selected location for 3 turns.
		When you cast a spell that damages the drone it will ripple the damage as 160%% arcane damage of the initial hit in radius 4.]])
		:format()
	end,
}
