local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SPACETIME_STABILITY",
	name = "时空稳定",
	info = function(self, t)
		local tune = t.getTuning(self, t)
		return ([[当 时 空 调 谐 处 于 非 激 活 状 态 时 ，你 的 紊 乱 值 每 回 合 自 动 向 设 定 值 调 整  %0.2f  点 。
		处 于 激 活 状 态 时 ， 该 效 果 加 倍 。]]):
		format(tune)
	end,
}

registerTalentTranslation{
	id = "T_CHRONO_TIME_SHIELD",
	name = "时间盾",
	info = function(self, t)
		local maxabsorb = t.getMaxAbsorb(self, t)
		local duration = t.getDuration(self, t)
		local time_reduc = t.getTimeReduction(self,t)
		return ([[这 个 复 杂 的 法 术 会 立 刻 在 施 法 者 身 边 制 造 一 个 时 空 屏 障 ，阻 止 受 到 的 一 切 伤 害 ，并 将 其 送 到 将 来 。		 一 旦 护 盾 吸 收 伤 害 达 到 最 大 值 ( %d )，或 者 持 续 时 间 结 束 ( %d  回 合 )，储 存 的 伤 害 将 会 返 回 变 为 一 个 时 空 回 复 场 ，持 续 五 回 合 。
		 每 回 合 回 复 场 可 以 为 你 回 复 吸 收 伤 害 的  10%%  。
		 当 激 活 时 光 之 盾 时 ，所 有 新 附 加 的 魔 法 、物 理 和 精 神 状 态 的 持 续 时 间 减 少  %d%%  。		 受 法 术 强 度 影 响 ，护 盾 的 最 大 吸 收 值 有 额 外 加 成 。]]):
		format(maxabsorb, duration, time_reduc)
	end,
}

registerTalentTranslation{
	id = "T_STOP",
	name = "时间静止",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		return ([[造 成  %0.2f  时 空 伤 害 ，并 试 图 震 慑 半 径  %d  码  范 围 内 所 有 目 标  %d  回 合 。
		 受 法 术 强 度 影 响 ，伤 害 按 比 例 加 成 。]]):
		format(damDesc(self, DamageType.TEMPORAL, damage), radius, duration)
	end,
}

registerTalentTranslation{
	id = "T_STATIC_HISTORY",
	name = "静态历史",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[接 下 来 的  %d  回 合 中 ，你 不 会 产 生 微 小 异 变 。   当 随 机 异 变 正 常 发 生 时 ，不 会 导 致 你 获 得 紊 乱 值 或 者 施 法 失 败 。
		 这 个 技 能 对 重 大 异 变 没 有 影 响 。]]):
		format(duration)
	end,
}

return _M
