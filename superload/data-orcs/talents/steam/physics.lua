local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SMITH",
	name = "铁匠",
	info = function(self, t)
		return ([[允许你制造 %d 等级的铁匠道具。
			1 级时必定获得一个配方。之后每一级有 20%% 的概率获得一个新配方。如果到 5 级还没有获得第二个新配方，就必定再获得一个新配方。
		%s]])
		:format(math.floor(self:getTalentLevel(t)), tinkers_list_for_craft_chn(self, t))
	end,}

registerTalentTranslation{
	id = "T_MECHANICAL",
	name = "机械",
	info = function(self, t)
		return ([[允许你制造 %d 等级的机械道具。
			1 级时必定获得一个配方。之后每一级有 20%% 的概率获得一个新配方。如果到 5 级还没有获得第二个新配方，就必定再获得一个新配方。
		%s]])
		:format(math.floor(self:getTalentLevel(t)), tinkers_list_for_craft_chn(self, t))
	end,}

registerTalentTranslation{
	id = "T_ELECTRICITY",
	name = "电子",
	info = function(self, t)
		return ([[允许你制造 %d 等级的电子道具。
			1 级时必定获得一个配方。之后每一级有 20%% 的概率获得一个新配方。如果到 5 级还没有获得第二个新配方，就必定再获得一个新配方。
		%s]])
		:format(math.floor(self:getTalentLevel(t)), tinkers_list_for_craft_chn(self, t))
	end,}

registerTalentTranslation{
	id = "T_COMPACT_STEAM_TANK",
	name = "蒸汽容量强化",
	info = function(self, t)
		return ([[增加你的蒸汽容量 %d 。]])
		:format(t.getPower(self, t))
	end,}
return _M