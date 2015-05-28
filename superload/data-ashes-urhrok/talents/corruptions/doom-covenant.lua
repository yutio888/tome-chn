local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DARK_REIGN",
	name = "黑暗支配",
	info = function(self, t)
		return ([[你 与 阴 影 的 联 系 更 加 紧 密 了 。
		 每 次 你 用 暗 影 伤 害 杀 死 生 物 或 造 成 超 过 %d%% 最 大 生 命 的 伤 害 时 ，你 获 得 8%% 全 体 伤 害 吸 收 ，持 续 10 回 合 。
		 这 个 效 果 能 叠 加 至 最 多 %d 层 ，每 回 合 至 多 叠 加 1 层 。]]):
		format(t.getThreshold(self, t)*100,t.getStack(self, t))
	end,
}


registerTalentTranslation{
	id = "T_DREAD_END",
	name = "黑暗终结",
	info = function(self, t)
		return ([[你 学 会 利 用 死 亡 来 获 取 力 量 。
		 当 黑 暗 支 配 开 启 ，每 次 你 使 用 非 暗 影 伤 害 杀 死 生 物 或 造 成 超 过 %d%% 最 大 生 命 的 伤 害 时 ，产 生 半 径 1 的 黑 暗 能 量 池 ，持 续 5 回 合 。
		 能 量 池 将 在 半 径 %d 范 围 内 的 随 机 敌 人 处 生 成。
		 任 何 站 在 里 面 的 敌 人 每 回 合 将 受 到 %0.2f 点 暗 影 伤 害 。
		 这 个 效 果 每 回 合 最 多 触 发 一 次 。
		 伤 害 受 法 术 强 度 加 成 。
		 技 能 等 级 3 或 以 上 时，当 你 处 于 黑 暗 支 配 状 态 下 ， 每 一 层 状 态 使 你 获 得 -%d 生 命 底 限。]])
		:format(t.getThreshold(self, t)*100, t.getTargetRadius(self, t), t.getDamage(self, t), t.getDieAt(self, t) )
	end,
}

registerTalentTranslation{
	id = "T_BLOOD_PACT",
	name = "鲜血契约",
	info = function(self, t)
		return ([[支 付 %d%% 当 前 生 命 值 ， 1 回 合 内 你 造 成 的 所 有 伤 害 转 化 为 黑 暗 伤 害。
		 如 果 黑 暗 支 配 开 启 ，每 有 一 层 ， 你 获 得 %d 体 力 与 %d 活 力 。]]):
		format(t.getLifeCost(self, t)*100, t.getStamina(self, t),t.getVim(self, t))		
	end,
}


registerTalentTranslation{
	id = "T_ERUPTING_DARKNESS",
	name = "黑暗爆发",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[当 黑 暗 终 结 制 造 出 黑 暗 能 量 池 时 ，你 能 将 愤 怒 集 中 在 内 ，将 其 转 变 为 火 山 。
		 半 径 %d 内 至 多 %d 个 能 量 池 将 会 喷 发 ，转 化 为 火 山 ，持 续 %d 回 合 。
		 每 回 合 火 山 将 喷 射 火 焰 巨 石 ，造 成 %0.2f 火 焰 与 %0.2f 物 理 伤 害 。
		 效 果 受 法 术 强 度 加 成 。]]):
		format(self:getTalentRadius(t), t.getNb(self, t), t.getDuration(self, t), dam/2,dam/2)
	end,
}


return _M
