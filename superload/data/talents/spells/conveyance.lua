local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_PHASE_DOOR",
	name = "次元之门",
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local range = t.getRange(self, t)
		return ([[在 %d 码 范 围 内 随 机 传 送 你 自 己。 
		 在 等 级 4 时， 你 可 以 传 送 指 定 生 物（ 怪 物 或 被 护 送 者）。 
		 在 等 级 5 时， 你 可 以 选 择 传 送 位 置（ 半 径 %d ）。 
		 如 果 目 标 位 置 不 在 你 的 视 线 里， 则 法 术 有 可 能 失 败，变 为 随 机 传 送。 
		 受 法 术 强 度 影 响， 影 响 范 围 有 额 外 加 成。]]):format(range, radius)
	end,
}

registerTalentTranslation{
	id = "T_TELEPORT",
	name = "传送",
	info = function(self, t)
		local range = t.getRange(self, t)
		local radius = t.getRadius(self, t)
		return ([[在 %d 码 范 围 内 随 机 传 送 。 
		 在 等 级 4 时， 你 可 以 传 送 指 定 生 物（ 怪 物 或 被 护 送 者）。 
		 在 等 级 5 时， 你 可 以 选 择 传 送 位 置（ 半 径 %d ）。 
		 随 机 传 送 的 最 小 半 径 为 %d。
		 受 法 术 强 度 影 响， 影 响 范 围 有 额 外 加 成。]]):format(range, radius, t.minRange)
	end,
}

registerTalentTranslation{
	id = "T_DISPLACEMENT_SHIELD",
	name = "相位护盾",
	info = function(self, t)
		local chance = t.getTransferChange(self, t)
		local maxabsorb = t.getMaxAbsorb(self, t)
		local duration = t.getDuration(self, t)
		return ([[这 个 复 杂 的 法 术 可 以 扭 曲 施 法 者 周 围 的 空 间， 此 空 间 可 连 接 至 范 围 内 的 另 外 1 个 目 标。 
		 任 何 时 候， 施 法 者 所 承 受 的 伤 害 有 %d%% 的 概 率 转 移 给 指 定 连 接 的 目 标。 
		 一 旦 吸 收 伤 害 达 到 上 限（ %d ）， 持 续 时 间 到 了（ %d 回 合） 或 目 标 死 亡， 护 盾 会 破 碎 掉。 
		 受 法 术 强 度 影 响， 护 盾 的 伤 害 最 大 吸 收 值 有 额 外 加 成。]]):
		format(chance, maxabsorb, duration)
	end,
}

registerTalentTranslation{
	id = "T_PROBABILITY_TRAVEL",
	name = "次元移动",
	info = function(self, t)
		local range = t.getRange(self, t)
		return ([[当 你 击 中 一 个 固 体 表 面 时， 此 法 术 会 撕 裂 位 面 将 你 瞬 间 传 送 至 另 一 面。 
		 传 送 最 大 距 离 为 %d 码。 
		 在 一 次 成 功 的 移 动 后， 你 将 进 入 不 稳 定 状 态， 在 基 于 你 传 送 码 数 的 %d%% 回 合 内， 无 法 再 次 使 用 该 技 能。 
		 受 法 术 强 度 影 响， 传 送 距 离 有 额 外 加 成。]]):
		format(range, (2 + (5 - math.min(self:getTalentLevelRaw(t), 5)) / 2) * 100)
	end,
}


return _M
