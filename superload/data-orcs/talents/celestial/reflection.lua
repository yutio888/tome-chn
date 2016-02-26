local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DIFFRACTION_PULSE",
	name = "衍射脉冲",
	info = function(self, t)
		return ([[在 目 标 所 在 地 创 造 一 个 地 块, 击 退 所 有 的 飞 行 物 如 果 可 能 的 话 还 会 改 变 他 们 的 方 向.]])
	end,}

registerTalentTranslation{
	id = "T_MIRROR_WALL",
	name = "反射镜墙",
	info = function(self, t)
		local halflength = t.getHalflength(self, t)
		local duration = t.getDuration(self, t)
		return([[创 造 一 堵 墙 长 %d 持 续 %d 回 合, 反 射 所 有 击 中 此 墙 的 飞 行 物 并 且 阻 挡 视 线.]]):
		format(halflength * 2 + 1, duration)
	end,}

registerTalentTranslation{
	id = "T_SPATIAL_PRISM",
	name = "空间棱镜",
	info = function(self, t)
		return([[选 择 一 个 飞 行 中 抛 射 物 复 制 并 使 它 们 分 开. 你 获 得 新 的 抛 射 物 所 有 权.]])
	end,}

registerTalentTranslation{
	id = "T_MIRROR_SELF",
	name = "自我镜像",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDam(self, t)
		local health = t.getHealth(self, t)
		return([[召 唤 一 个 持 续 %d 回 合 能 施 放 你 所 有 法 术 的 镜 像, 造 成 %d%% 的 伤 害 和 拥 有 %d%% 生 命 值. 此 外, 镜 像 造 成 的 所 有 光 伤 害 转 换 为 暗 影 伤 害， 所 有 暗 影 伤 害 转 换 为 光 伤 害.]]):
		format(duration, damage * 100, health * 100)
	end,}
	
	return _M