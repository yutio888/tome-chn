local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DIMENSIONAL_STEP",
	name = "空间跳跃",
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[将 你 传 送 到  %d  码 视 野 范 围 内 的 指 定 地 点 。
		 在 等 级 5 时 ，你 可 以 与 指 定 的 目 标 交 换 位 置 。]]):format(range)
	end,
}

registerTalentTranslation{
	id = "T_DIMENSIONAL_SHIFT",
	name = "时空流转",
	info = function(self, t)
		local reduction = t.getReduction(self, t)
		return ([[每 当 你 进 行 传 送 ，你 的 1 个 负 面 效 果 的 持 续 时 间 被 减 少 %d 回 合 。]]):
		format(reduction)
	end,
}

registerTalentTranslation{
	id = "T_WORMHOLE",
	name = "虫洞穿梭",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		local range = self:getTalentRange(t)
		return ([[你 创 造 一 对 虫 洞 ，使 你 所 在 之 处 和  %d  码 范 围 内 一 点 的 空 间 重 叠 。   任 何 踏 入 虫 洞 的 生 物 会 被 传 送 至 另 一 个 虫 洞 附 近 (精 度 半 径  %d )。   
		 虫 洞 持 续  %d  回 合 并 且 至 少 相 距 两 码 。
		 受 法 术 强 度 影 响 ，传 送 敌 人 的 几 率 按 比 例 加 成 。]])
		:format(range, radius, duration)
	end,
}

registerTalentTranslation{
	id = "T_PHASE_PULSE",
	name = "相位脉冲",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		return ([[每 当 你 进 行 传 送 ，你 发 射 一 道 脉 冲 将 起 点 和 终 点 半 径  %d  码 内 的 敌 人 击 出 位 面 。  
		 你 每 传 送 一 码 ，被 击 中 的 目 标 将 有  %d%%  的 几 率 被 震 慑 、致 盲 、混 乱 或 者 束 缚  %d  回 合 。]]):
		format(radius, chance, duration)
	end,
}

return _M
