local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_REPULSION_BLAST",
	name = "排斥冲击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 半 径  %d  码 的 锥 形 范 围 内 释 放 一 股 爆 炸 性 的 重 力 冲 击 波 ，造 成  %0.2f  物 理 (重 力 )伤 害 并 击 退 范 围 内 目 标 。
		 被 击 飞 至 墙 上 或 其 他 单 位 的 目 标 受 到 额 外  25%%  伤 害 ，并 对 被 击 中 的 单 位 造 成  25%%  伤 害 。
		 离 你 越 近 的 目 标 将 会 被 击 飞 得 更 远 。受 法 术 强 度 影 响 ，伤 害 按 比 例 加 成 。]]):
		format(radius, damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}

	
registerTalentTranslation{
	id = "T_GRAVITY_SPIKE",
	name = "重力钉刺",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 半 径  %d  范 围 内 制 造 一 个 重 力 钉 刺 ，将 所 有 目 标 牵 引 至 法 术 中 心 ，造 成  %0.2f  物 理 (重 力 )伤 害 。
		 从 第 二 个 单 位 起 ，每 牵 引 一 个 单 位 将 会 使 伤 害 增 加  %0.2f (最 多 增 加  %0.2f  额 外 伤 害 )。
		 离 法 术 中 心 越 远 ，目 标 收 到 的 伤 害 越 少  (每 格 减 少  20%%)。
		 受 法 术 强 度 影 响 ，伤 害 按 比 例 加 成 。]])
		:format(radius, damDesc(self, DamageType.PHYSICAL, damage), damDesc(self, DamageType.PHYSICAL, damage/8), damDesc(self, DamageType.PHYSICAL, damage/2))
	end,
}

registerTalentTranslation{
	id = "T_GRAVITY_LOCUS",
	name = "重力核心"	,
	info = function(self, t)
		local conv = t.getConversion(self, t)
		local proj = t.getSlow(self, t)
		local anti = t.getAnti(self, t)
		return ([[在 你 身 边 制 造 一 个 重 力 场 ，将 你 造 成 伤 害 的  %d%%  转 化 为 物 理 伤 害 ， 使 向 你 发 射 的 飞 行 物 减 速  %d%% ，并 使 你 免 受 重 力 伤 害 和 效 果 的 影 响 。
		 此 外 ，排 斥 冲 击 对 目 标 造 成 伤 害 之 后 ，有  %d%%  的 几 率 将 目 标 的 击 退 抗 性 减 半 两 回 合 。]])
		 :format(conv, proj, anti)
	end,
}

registerTalentTranslation{
	id = "T_GRAVITY_WELL",
	name = "重力之井",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		local slow = t.getSlow(self, t)
		return ([[增 加 半 径 %d 范 围 内 的 重 力 %d 回 合 ， 造 成 %0.2f 物 理 ( 重 力 ) 伤 害 ， 并 降 低 所 有 目 标 的 整 体 速 度 %d%% 。
		受 法 术 强 度 影 响 ， 伤 害 按 比 例 加 成 。]]):format(radius, duration, damDesc(self, DamageType.PHYSICAL, damage), slow*100)
	end,
}


return _M
