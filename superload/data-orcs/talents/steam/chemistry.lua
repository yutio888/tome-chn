local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_THERAPEUTICS",
	name = "治疗学",
	info = function(self, t)
		return ([[允许你制造 %d 等级的治疗学道具。
	1 级时必定获得一个配方。之后每一级有 20%% 的概率获得一个新配方。如果到 5 级还没有获得第二个新配方，就必定再获得一个新配方。
		%s]])
		:format(math.floor(self:getTalentLevel(t)), tinkers_list_for_craft_chn(self, t))
	end,}

registerTalentTranslation{
	id = "T_CHEMISTRY",
	name = "药剂学",
	info = function(self, t)
		return ([[允许你制造 %d 等级的药剂学道具。
	1 级时必定获得一个配方。之后每一级有 20%% 的概率获得一个新配方。如果到 5 级还没有获得第二个新配方，就必定再获得一个新配方。
		%s]])
		:format(math.floor(self:getTalentLevel(t)), tinkers_list_for_craft_chn(self, t))
	end,}

registerTalentTranslation{
	id = "T_EXPLOSIVES",
	name = "爆炸学",
	info = function(self, t)
		return ([[允许你制造 %d 等级的爆炸学道具。
	1 级时必定获得一个配方。之后每一级有 20%% 的概率获得一个新配方。如果到 5 级还没有获得第二个新配方，就必定再获得一个新配方。
		%s]])
		:format(math.floor(self:getTalentLevel(t)), tinkers_list_for_craft_chn(self, t))
	end,}

registerTalentTranslation{
	id = "T_STEAM_POWER",
	name = "蒸汽动力",
	info = function(self, t)
		return ([[提高所有蒸汽设备的效果，获得 %d 点蒸汽强度。]])
		:format(t.getPower(self, t))
	end,}
return _M