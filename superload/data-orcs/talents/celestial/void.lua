local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_NEBULA_SPEAR",
	name = "星云之矛",
	info = function(self, t)
		local damage = damDesc(self, DamageType.DARKNESS, t.getDamage(self, t))
		local radius = self:getTalentRadius(t)
		return ([[射 出 一 个 带 有 宇 宙 能 量 的 矛. 如 果 击 中 敌 人 将 造 成 %0.2f 伤 害, 否 则 它 在 到 达 最 大 射 程 时 爆 炸 并 造 成 一 个 范 围 %d 的 锥 形 伤 害, 能 被 敌 人 阻 挡, 造 成 %0.2f 至 %0.2f 伤 害 取 决 于 有 多 少 个 敌 人 阻 挡.]]):
		format(damage * 2.5, radius, damage, damage * 2.5)
	end,}

registerTalentTranslation{
	id = "T_CRESCENT_WAVE",
	name = "新月波动",
	info = function(self, t)
		return ([[向 顺 时 针 方 向 发 射 一 个 抛 射 物. 如 果 击 中 敌 人 将 造 成 %0.2f  伤 害 并 定 身 1 回 合. 如 果 另 一 个 抛 射 物 在  %d 回 合 里 击 中 他 们, 他 们 将 只 收 到 一 半 的 伤 害 并 再 次 定 身.]])
	end,}

registerTalentTranslation{
	id = "T_TWILIT_ECHOES",
	name = "微光回响",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local echo_dur = t.getEchoDur(self, t)
		local slow_per = t.getSlowPer(self, t)
		local slow_max = t.getSlowMax(self, t)
		local echo_factor = t.getDarkEcho(self, t)
		return ([[目 标 会 受 到 你 所 有 光 暗 伤 害 的 回 响, 持 续 %d 回合. 

每 点 光  伤 害 减 速 敌 人 %0.2f%% 持 续 %d 回 合, 在 %d 伤 害 时 达 到 最 大 值, 为 %d%% .
暗 系 伤 害 创 造 一 个 持 续 %d 回 合 的 地 块, 每 回 合 造 成 伤 害 的 %d%%. 当 有 另 一 个 微 光 回 响 激 活 或 目 标 持 续 承 受 此 伤 害 时, 将 刷 新 持 续 时 间, 剩 余 伤 害 和 新 承 受 的 伤 害 将 平 分 至 新 持 续 时 间 内.
]])
		:format(duration, slow_per * 100, echo_dur, slow_max * 100, slow_max/slow_per, echo_dur, 100 * echo_factor)
	end,}

registerTalentTranslation{
	id = "T_STARSCAPE",
	name = "星界领域",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		
		return ([[在 %d 范 围 内 召 唤 一 片 星 界 领 域 . %d 回 合 内, 这 个 区 域 存 在 于 正 常 时 间 之 外, 且 重 力 为 零. 除 了 零 重 力 之 外, 抛 射 物 和 生 物 的 活 动 比 平 时 慢 3 倍. 法 术 和 攻 击 不 能 逃 脱 范 围, 直 到 效 果 结 束.]]):
		format(radius, duration)
	end,}
	
	return _M