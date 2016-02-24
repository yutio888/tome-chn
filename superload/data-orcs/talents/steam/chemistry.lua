local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_THERAPEUTICS",
	name = "Therapeutics",
	info = function(self, t)
		return ([[Allows you to create therapeutic tinkers of level %d.
		You will learn a new schematic at level 1.
		Each other talent level, you have a 20%% chance to learn one more random schematic, if you have not gained it by level 5 you are guaranteed it (unless all are known).
		%s]])
		:format(math.floor(self:getTalentLevel(t)), tinkers_list_for_craft(self, t))
	end,}

registerTalentTranslation{
	id = "T_CHEMISTRY",
	name = "Chemistry",
	info = function(self, t)
		return ([[Allows you to create chemical tinkers of level %d.
		You will learn a new schematic at level 1.
		Each other talent level, you have a 20%% chance to learn one more random schematic, if you have not gained it by level 5 you are guaranteed it (unless all are known).
		%s]])
		:format(math.floor(self:getTalentLevel(t)), tinkers_list_for_craft(self, t))
	end,}

registerTalentTranslation{
	id = "T_EXPLOSIVES",
	name = "Explosives",
	info = function(self, t)
		return ([[Allows you to create explosive tinkers of level %d.
		You will learn a new schematic at level 1.
		Each other talent level, you have a 20%% chance to learn one more random schematic, if you have not gained it by level 5 you are guaranteed it (unless all are known).
		%s]])
		:format(math.floor(self:getTalentLevel(t)), tinkers_list_for_craft(self, t))
	end,}

registerTalentTranslation{
	id = "T_STEAM_POWER",
	name = "Steam Power",
	info = function(self, t)
		return ([[Increases the efficiency of all steamtech you operate, granting %d steampower.]])
		:format(t.getPower(self, t))
	end,}
