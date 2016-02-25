local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SMITH",
	name = "铁匠",
	info = function(self, t)
		return ([[允 许 你 制 造 %d 等 级 的 铁 匠 道 具 。
			1 级 时 必 定 获 得 一 个 配 方 。 之 后 每 一 级 有 20%% 的 概 率 获 得 一 个 新 配 方 。 如 果 到 5 级 还 没 有 获 得 第 二 个 新 配 方 ， 就 必 定 再 获 得 一 个 新 配 方 。
		%s]])
		:format(math.floor(self:getTalentLevel(t)), tinkers_list_for_craft_chn(self, t))
	end,}

registerTalentTranslation{
	id = "T_MECHANICAL",
	name = "机械",
	info = function(self, t)
		return ([[允 许 你 制 造 %d 等 级 的 机 械 道 具 。
			1 级 时 必 定 获 得 一 个 配 方 。 之 后 每 一 级 有 20%% 的 概 率 获 得 一 个 新 配 方 。 如 果 到 5 级 还 没 有 获 得 第 二 个 新 配 方 ， 就 必 定 再 获 得 一 个 新 配 方 。
		%s]])
		:format(math.floor(self:getTalentLevel(t)), tinkers_list_for_craft_chn(self, t))
	end,}

registerTalentTranslation{
	id = "T_ELECTRICITY",
	name = "电子",
	info = function(self, t)
		return ([[允 许 你 制 造 %d 等 级 的 电 子 道 具 。
			1 级 时 必 定 获 得 一 个 配 方 。 之 后 每 一 级 有 20%% 的 概 率 获 得 一 个 新 配 方 。 如 果 到 5 级 还 没 有 获 得 第 二 个 新 配 方 ， 就 必 定 再 获 得 一 个 新 配 方 。
		%s]])
		:format(math.floor(self:getTalentLevel(t)), tinkers_list_for_craft_chn(self, t))
	end,}

registerTalentTranslation{
	id = "T_COMPACT_STEAM_TANK",
	name = "蒸汽容量强化",
	info = function(self, t)
		return ([[增 加 你 的 蒸 汽 容 量 %d 。]])
		:format(t.getPower(self, t))
	end,}
return _M