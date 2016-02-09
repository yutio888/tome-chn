local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DISTORTION_BOLT",
	name = "扭曲之球",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local distort = DistortionCount(self)
		return ([[射 出 一 枚 无 视 抵 抗 的 扭 曲 之 球 并 造 成 %0.2f 物 理 伤 害。 此 技 能 会 扭 曲 目 标，减 少 对 方 物 理 抗 性 %d%% ，并 使 其 在 2 回 合 内 受 到 扭 曲 效 果 时 会 产 生 额 外 的 负 面 影 响。
		 如 果 目 标 身 上 已 存 在 扭 曲 效 果， 则 会 在 %d 码 范 围 内 产 生 150 ％ 基 础 伤 害 的 爆 炸。 
		 在 该 技 能 投 入 点 数 会 增 加 你 所 有 扭 曲 效 果 的 降 抗 效 果。
		 在 等 级 5 时， 你 学 会 控 制 你 的 扭 曲 效 果， 防 止 扭 曲 效 果 攻 击 到 你 或 友 军。 
		 受 精 神 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(damDesc(self, DamageType.PHYSICAL, damage), distort, radius)
	end,
}

registerTalentTranslation{
	id = "T_DISTORTION_WAVE",
	name = "扭曲之涛",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local power = t.getPower(self, t)
		local distort = DistortionCount(self)
		return ([[在 %d 码 锥 形 半 径 范 围 内 创 建 一 股 扭 曲 之 涛， 造 成 %0.2f 物 理 伤 害， 并 击 退 扭 曲 之 涛 中 的 目 标。 
		 此 技 能 会 扭 曲 目 标，减 少 对 方 物 理 抗 性 %d%% ，并 使 其 在 2 回 合 内 受 到 扭 曲 效 果 时 会 产 生 额 外 的 负 面 影 响。
		 在 该 技 能 投 入 点 数 会 增 加 你 所 有 扭 曲 效 果 的 降 抗 效 果。
		 如 果 目 标 身 上 已 存 在 扭 曲 效 果， 则 会 被 震 慑 %d 回 合。 
		 受 精 神 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(radius, damDesc(self, DamageType.PHYSICAL, damage), distort, power)
	end,
}

registerTalentTranslation{
	id = "T_RAVAGE",
	name = "疯狂扭曲",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local distort = DistortionCount(self)
		return ([[疯 狂 扭 曲 目 标， 造 成 每 轮 %0.2f 物 理 伤 害， 持 续 %d 回 合。 
		 此 技 能 会 扭 曲 目 标，减 少 对 方 物 理 抗 性 %d%% ，并 使 其 在 2 回 合 内 受 到 扭 曲 效 果 时 会 产 生 额 外 的 负 面 影 响。
		 如 果 目 标 身 上 已 存 在 扭 曲 效 果， 则 伤 害 提 升 50 ％， 并 且 目 标 每 回 合 会 丢 失 一 种 物 理 增 益 效 果 或 持 续 技 能 效 果。 
		 在 该 技 能 投 入 点 数 会 增 加 你 所 有 扭 曲 效 果 的 降 抗 效 果。
		 受 精 神 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(damDesc(self, DamageType.PHYSICAL, damage), duration, distort)
	end,
}

registerTalentTranslation{
	id = "T_MAELSTROM",
	name = "灵能漩涡",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local distort = DistortionCount(self)
		return ([[创 造 一 个 强 大 的 灵 能 漩 涡， 持 续 %d 回 合。 每 回 合 漩 涡 会 将 半 径 %d 码 内 的 目 标 吸 向 中 心 并 造 成 %0.2f 物 理 伤 害。 
		 此 技 能 会 扭 曲 目 标，减 少 对 方 物 理 抗 性 %d%% ，并 使 其 在 2 回 合 内 受 到 扭 曲 效 果 时 会 产 生 额 外 的 负 面 影 响。
		 在 该 技 能 投 入 点 数 会 增 加 你 所 有 扭 曲 效 果 的 降 抗 效 果。
		 受 精 神 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(duration, radius, damDesc(self, DamageType.PHYSICAL, damage), distort)
	end,
}


return _M
