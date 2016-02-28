local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_LUNAR_ORB",
	name = "月光之球",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local restore = t.getNegative(self, t)
		return ([[向 目 标 方 向 射 出 一 道 宇 宙 能 量. 直 到 碰 到 墙 或 者 到 达 地 图 边 缘, 对 敌 人 造 成 %0.2f 的 暗 影 伤 害 并 回 复 %d 负 能 量. 负 能 量 回 复 量 最 大 为 %d, 每 击 中 一 个 敌 人 将 少 回 复 25%% 的 负 能 量, 被 击 中 的 敌 人 将 注 意 到 你.]]):
		format(damDesc(self, DamageType.DARKNESS, damage), restore, restore * 4)
	end,}

registerTalentTranslation{
	id = "T_ASTRAL_PATH",
	name = "星光大道",
	info = function(self, t)
		return ([[在 %d 码 内 发 射 一 个 负 能 量 球.
		当 负 能 量 球 到 达 目 的 地 时, 会 将 你 传 送 到 其 位 置.
		其 飞 行 速 度 (%d%%) 将 随 着 你 的 移 动 速 度 增 加.]]):format(t.range(self, t), t.proj_speed(self, t)*100)
	end,}

registerTalentTranslation{
	id = "T_GALACTIC_PULSE",
	name = "银河脉冲",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[在 8 码 内 发 出 一 个 缓 慢 移 动 的 螺 旋 宇 宙 能 量.
		当 它 移 动 时, 会 把 相 邻 的 目 标 拉 向 它, 造 成 %0.2f 暗 影 伤 害 并 每 击 中 一 次 回 复 1 点 负 能 量.]]):
		format(damDesc(self, DamageType.DARKNESS, damage))
	end,}

registerTalentTranslation{
	id = "T_SUPERNOVA",
	name = "超新星",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local pin = t.getPinDuration(self, t)
		return ([[释 放 你 所 有 的 负 能 量 在 %d 码 范 围 内 造 成 (范 围 %d) 的 大 规 模 暗 能 量 爆 发.
		造 成 %0.2f 的 暗 影 伤 害 并 定 身 被 击 中 的 敌 人 %d 回合.
		伤 害 及 定 身 机 率 随 法 术 强 度 增 加, 伤 害、 范 围、和 定 身 持 续 时 间 全 部 随 着 负 能 量 和 技 能 等 级 增 加.]]):
		format(radius, self:getTalentRange(t), damDesc(self, DamageType.DARKNESS, damage), pin)
	end,}
return _M