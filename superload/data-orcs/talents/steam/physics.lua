local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SMITH",
	name = "Smith",
	info = function(self, t)
		return ([[Allows you to create smithed tinkers of level %d.
		You will learn a new schematic at level 1.
		Each other talent level, you have a 20%% chance to learn one more random schematic, if you have not gained it by level 5 you are guaranteed it (unless all are known).
		%s]])
		:format(math.floor(self:getTalentLevel(t)), tinkers_list_for_craft_chn(self, t))
	end,}

registerTalentTranslation{
	id = "T_MECHANICAL",
	name = "Mechanical",
	info = function(self, t)
		return ([[Allows you to create mechanical tinkers of level %d.
		You will learn a new schematic at level 1.
		Each other talent level, you have a 20%% chance to learn one more random schematic, if you have not gained it by level 5 you are guaranteed it (unless all are known).
		%s]])
		:format(math.floor(self:getTalentLevel(t)), tinkers_list_for_craft_chn(self, t))
	end,}

registerTalentTranslation{
	id = "T_ELECTRICITY",
	name = "Electricity",
	info = function(self, t)
		return ([[Allows you to create electrical tinkers of level %d.
		You will learn a new schematic at level 1.
		Each other talent level, you have a 20%% chance to learn one more random schematic, if you have not gained it by level 5 you are guaranteed it (unless all are known).
		%s]])
		:format(math.floor(self:getTalentLevel(t)), tinkers_list_for_craft_chn(self, t))
	end,}

registerTalentTranslation{
	id = "T_COMPACT_STEAM_TANK",
	name = "Compact Steam Tank",
	info = function(self, t)
		return ([[Increases the capacity of your steam tank by %d.]])
		:format(t.getPower(self, t))
	end,}
return _M