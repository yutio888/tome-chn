local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_THERAPEUTICS",
	name = "治疗学",
	info = function(self, t)
		return ([[允 许 你 制 造 %d 等 级 的 治 疗 学 道 具 。
	1 级 时 必 定 获 得 一 个 配 方 。 之 后 每 一 级 有 20%% 的 概 率 获 得 一 个 新 配 方 。 如 果 到 5 级 还 没 有 获 得 第 二 个 新 配 方 ， 就 必 定 再 获 得 一 个 新 配 方 。
		%s]])
		:format(math.floor(self:getTalentLevel(t)), tinkers_list_for_craft_chn(self, t))
	end,}

registerTalentTranslation{
	id = "T_CHEMISTRY",
	name = "药剂学",
	info = function(self, t)
		return ([[允 许 你 制 造 %d 等 级 的 药 剂 学 道 具 。
	1 级 时 必 定 获 得 一 个 配 方 。 之 后 每 一 级 有 20%% 的 概 率 获 得 一 个 新 配 方 。 如 果 到 5 级 还 没 有 获 得 第 二 个 新 配 方 ， 就 必 定 再 获 得 一 个 新 配 方 。
		%s]])
		:format(math.floor(self:getTalentLevel(t)), tinkers_list_for_craft_chn(self, t))
	end,}

registerTalentTranslation{
	id = "T_EXPLOSIVES",
	name = "爆炸学",
	info = function(self, t)
		return ([[允 许 你 制 造 %d 等 级 的 爆 炸 学 道 具。
	1 级 时 必 定 获 得 一 个 配 方 。 之 后 每 一 级 有 20%% 的 概 率 获 得 一 个 新 配 方 。 如 果 到 5 级 还 没 有 获 得 第 二 个 新 配 方 ， 就 必 定 再 获 得 一 个 新 配 方 。
		%s]])
		:format(math.floor(self:getTalentLevel(t)), tinkers_list_for_craft_chn(self, t))
	end,}

registerTalentTranslation{
	id = "T_STEAM_POWER",
	name = "蒸汽动力",
	info = function(self, t)
		return ([[提 高 所 有 蒸 汽 设 备 的 效 果 ， 获 得 %d 点 蒸 汽 强 度 。]])
		:format(t.getPower(self, t))
	end,}
return _M