local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_NIHIL",
	name = "虚无",
	info = function(self, t)
		local targetcount = t.getTargetCount(self, t)
		local power = t.getPower(self, t)*100
		return ([[将 你 身 体 上 的 熵 能 向 周 围 辐 射 。 每 当 你 受 到 熵 能 反 冲 时 ， 在 你 1 0  码 距 离 内 随 机 的 %d 个 可 见 敌 人 都  将 被 熵 能 侵 蚀 4 回 合 。
		增 加 ( 减 少 ) 它 们 受 到 的 新 的 负 面 ( 正 面 ) 效 果 %d%% 的 持 续 时 间。]]):
		format(targetcount, power)
	end,
}

registerTalentTranslation{
	id = "T_UNRAVEL_EXISTENCE",
	name = "拆解",
	info = function(self, t)
		local dur = t.getDuration(self,t)
		return ([[虚 无 能 解 构 目 标 的 存 在 并 通 过 熵 能 将 其 摧 毁 。
		在 熵 能 侵 蚀 效 果 结 束 之 前 ， 如 果 目 标 身 上 同 时 存 在 6 个 效 果 ， 将 召 唤 出 持 续 %d 回 合 的 湮 灭 使 者。
		湮 灭 使 者 的 全 部 属 性 点 提 升 你 魔 法 属 性 的 相 同 数 值 。 其 他 属 性 根 据 本 身 等 级 提 升。
		湮 灭 使 者 会 继 承 你 的 伤 害 加 成 、 伤 害 穿 透 、 暴 击 几 率 和 暴 击 倍 率 加 成 。]]):
		format(dur)
	end,
}

registerTalentTranslation{
	id = "T_ERASE",
	name = "抹除",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local power = t.getNumb(self, t)
		return ([[受 到 你 虚 无 之 力 影 响 的 生 物 逐 渐 被 从 现 实 中 被 抹 除 ， 造 成 的 伤 害 降 低 %d%% ， 同 时 每 具 有 一 个 负 面 魔 法 效 果 ， 每 回 合 受 到 %0.2f 时 空 伤 害。 
		伤 害 受 到 法 术 强 度 加 成。]])
		:format(power, damDesc(self, DamageType.TEMPORAL, dam))
	end
}


registerTalentTranslation{
	id = "T_ALL_IS_DUST",
	name = "尽归尘土",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[在 目 标 区 域 召 唤 出 范 围 4 码 、 持 续 %d 回 合 的 湮 灭 风 暴 ， 使 受 到 影 响 的 物 质 化 为 虚 无 ， 每 回 合 造 成 %0.2f 暗 影 %0.2f 时 空 伤 害 。
		范 围 内 的 墙 壁 和 部 分 其 他 地 形 将 被 粉 粹。
		每 次 受 到 风 暴 伤 害 时 ， 敌  人 身 上 不 足 3 回 合 的 负 面 魔 法 效 果 都 将 重 置 为 3 回 合 。 风 暴 范 围 内 敌 人 的 投 射 物 都 将 被 扯 碎。
		伤 害 受 到 法 术 强 度 加 成 。]]):format(duration, damDesc(self, DamageType.DARKNESS, damage), damDesc(self, DamageType.TEMPORAL, damage))
	end,
}

registerTalentTranslation{
	id = "T_VOID_CRASH",
	name = "虚空破碎",
	info = function(self, t)
		return ([[用 武 器 撞 击 地 面 ,   产 生 2 码 的 虚 空 爆 炸 ， 造 成 %d%% 虚 空 武 器 伤 害（暗 影 时 空 各 50%%）。]]):
		format(t.getDamage(self, t) * 100)
	end,
}

return _M
