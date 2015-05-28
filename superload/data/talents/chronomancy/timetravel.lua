local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TEMPORAL_BOLT",
	name = "时空之箭",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[ 将 一 道 时 空 之 箭 射 入 时 间 线 中 。
		时 空 之 箭 会 返 回 你 的 位 置 ，对 路 径 上 目 标 造 成 %0.2f 时 空 伤害 。每 飞 行 1 格 ， 伤 害 增 加 5%% 。
		每 命 中 一 个 目 标 会 减 少 你 随 机 一 个 冷 却 中 的时 空 技 能 一 回 合 CD。
		技 能 等 级 5 时 ， 减 少 2 回 合cd。]]):
		format(damDesc(self, DamageType.TEMPORAL, damage))
	end,
}

registerTalentTranslation{
	id = "T_TIME_SKIP",
	name = "时间跳跃",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[造 成 %0.2f 时 空 伤 害 。 如 果 你 的 目 标 存 活 ， 他 将 被 从 这 个 时 空 放 逐 %d 回 合 。
		伤 害 受 到 法 术 强 度 加 成 。	]]):format(damDesc(self, DamageType.TEMPORAL, damage), duration)
	end,
}

registerTalentTranslation{
	id = "T_TEMPORAL_REPRIEVE",
	name = "时空避难所",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[将 自 己 传 送 至 安 全 的 位 置 ，停 留 %d 回 合.]]):
		format(duration)
	end,
}

registerTalentTranslation{
	id = "T_ECHOES_FROM_THE_PAST",
	name = "往昔回响",
	info = function(self, t)
		local percent = t.getPercent(self, t) * 100
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		return ([[在 半 径 %d 的 范 围 内 制 造 一 次 时 空 回 响。
		范 围 内 的生 物 将 受 到 %0.2f 时 空 伤 害 ， 然 后 额 外 受 到 等 于 当 前 已 损 失 生 命 值 %d%% 的 伤 害。
		额 外 伤 害 将 被 对 面 怪 物 的 阶 级 除 。
		伤 害 受 法 术 强 度 加 成 。]]):
		format(radius, damDesc(self, DamageType.TEMPORAL, damage), percent)
	end,
}

return _M
