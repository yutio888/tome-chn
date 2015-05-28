local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WARP_MINE_TOWARD",
	name = "时空地雷：接近",
	info = function(self, t)
		local damage = self:callTalent(self.T_WARP_MINES, "getDamage")/2
		local duration = self:callTalent(self.T_WARP_MINES, "getDuration")
		local detect = self:callTalent(self.T_WARP_MINES, "trapPower") * 0.8
		local disarm = self:callTalent(self.T_WARP_MINES, "trapPower")
		return ([[ 在 半 径 1 的 范 围 里 埋 设 地 雷 ， 将 敌 人 传 送 至 你 身 边 并 造 成 %0.2f 物 理 和 %0.2f 时 空 伤 害 。
		地 雷 是 隐 藏 的 陷 阱（ %d 侦 查 强 度 %d 解 除 强 度 基 于 魔 法 ），持 续 %d 回 合 。
		伤 害 受 法 术 强 度 加 成。]]):
		format(damDesc(self, DamageType.PHYSICAL, damage), damDesc(self, DamageType.TEMPORAL, damage), detect, disarm, duration)
	end,
}

registerTalentTranslation{
	id = "T_WARP_MINE_AWAY",
	name = "时空地雷：远离",
	info = function(self, t)
		local damage = self:callTalent(self.T_WARP_MINES, "getDamage")/2
		local duration = self:callTalent(self.T_WARP_MINES, "getDuration")
		local detect = self:callTalent(self.T_WARP_MINES, "trapPower") * 0.8
		local disarm = self:callTalent(self.T_WARP_MINES, "trapPower")
		return ([[在 半 径 1 的 范 围 里 埋 设 地 雷 ， 将 敌 人 传 送 远 离 你 身 边 并 造 成 %0.2f 物 理 和 %0.2f 时 空 伤 害 。
		地 雷 是 隐 藏 的 陷 阱（ %d 侦 查 强 度 %d 解 除 强 度 基 于 魔 法 ），持 续 %d 回 合 。
		伤 害 受 法 术 强 度 加 成。]]):
		format(damDesc(self, DamageType.PHYSICAL, damage), damDesc(self, DamageType.TEMPORAL, damage), detect, disarm, duration) 
	end,
}

registerTalentTranslation{
	id = "T_WARP_MINES",
	name = "时空地雷",
	info = function(self, t)
		local range = t.getRange(self, t)
		local damage = t.getDamage(self, t)/2
		local detect = t.trapPower(self,t)*0.8
		local disarm = t.trapPower(self,t)
		local duration = t.getDuration(self, t)
		return ([[学 会 在 半 径 1 的 范 围 内 埋 设 时 空 地 雷，造 成 %0.2f 物 理 和 %0.2f 时 空 伤 害。
		时 空 地 雷 能 将 敌 人 传 送 ， 到 你 身 边 或 者 传 到 远 处 。
		地 雷 是 隐 藏 的 陷 阱（ %d 侦 查 强 度 %d 解 除 强 度 基 于 魔 法 ），持 续 %d 回 合 ，有 10 回 合 冷 却 时 间 。
		在 该 技 能 上 投 入 点 数 能 增 加 时 空 折 叠 系 技 能 的 半 径。
		地 雷 伤 害 受 法 术 强 度 加 成。

		当 前 半 径 ： %d]]):
		format(damDesc(self, DamageType.PHYSICAL, damage), damDesc(self, DamageType.TEMPORAL, damage), detect, disarm, duration, range) --I5
	end,
}

registerTalentTranslation{
	id = "T_SPATIAL_TETHER",
	name = "时空束缚",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		local damage = t.getDamage(self, t)/2
		local radius = self:getTalentRadius(t)
		return ([[将 目 标 束 缚 于 某 处 %d 回 合 。
		每 回 合 ， 目 标 每 离 开 该 处 1 格 ， 便 有 %d%% 几 率 传 送 回 去 ， 并 在 传 送 点 周 围 造 成 %0.2f 物 理 %0.2f 时 空 伤 害 的 %d 半 径 的 爆 炸。
		伤 害 受 法 术 强 度 加 成。]])
		:format(duration, chance, damDesc(self, DamageType.PHYSICAL, damage), damDesc(self, DamageType.TEMPORAL, damage), radius)
	end,
}

registerTalentTranslation{
	id = "T_BANISH",
	name = "放逐",
	info = function(self, t)
		local range = t.getTeleport(self, t)
		local duration = t.getDuration(self, t)
		return ([[将 半 径 3 以 内 的 敌 人 随 机 传 送。
		敌 人 将 会 传 送 至 距 离 你 %d 至 %d 码 的 范 围 内 ， 并 被 震 慑 、 致 盲 、混 乱 或 者 定 身 %d 回 合 。
		传 送 几 率 与 法 术 强 度 相 关 。]]):format(range / 2, range, duration)
	end,
}

registerTalentTranslation{
	id = "T_DIMENSIONAL_ANCHOR",
	name = "禁传区",
	info = function(self, t)
		local damage = t.getDamage(self, t)/2
		local duration = t.getDuration(self, t)
		return ([[制 造 一 个 半 径 3 的 禁 传 区 ， 持 续 %d 轮 ， 并 眩 晕 其 中 所 有 目 标 2 回 合 。
		试 图 传 送 的 敌 人 将 受 到 %0.2f 物 理 %0.2f 时 空 伤 害。
		伤 害 受 法 术 强 度 加 成 。]]):format(duration, damDesc(self, DamageType.PHYSICAL, damage), damDesc(self, DamageType.TEMPORAL, damage))
	end,
}

return _M
