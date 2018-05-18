local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_JINXED_TOUCH",	
	name = "厄运之触",
	info = function(self, t)
		local saves = t.getSaves(self,t)
		local crit = t.getCrit(self,t)
		return ([[你 的 触 碰 伴 随 着 熵 之 诅 咒 ， 为 目 标 带 来 悲 惨 的 命 运 。 每 当 你 对 目 标 造 成 伤 害 时， 目 标 将 被 厄 运 诅 咒 1 0 回 合 。 厄 运 可 以 叠 加  1 0 层， 每 层 减 少 %d 豁 免 和 防 御 ， %d%% 暴 击 率 。
		每 个 目 标 每 回 合 只 能 受 到 一 层 诅 咒。
		如 果 在 过 去 2 回 合 里 你 没 有 对 目 标 造 成 伤 害 ， 目 标 每 回 合 将 会 失 去 一 层 诅 咒。]]):
		format(saves, crit)
	end,
}
registerTalentTranslation{
	id = "T_PREORDAIN",	
	name = "命中注定",
	info = function(self, t)
		local chance = t.getChance(self,t)
		return ([[你 微 妙 地 影 响 因 果 ，让 你 的 敌 人 更 加 不 幸。 六 层 以 上 的 每 层 厄运 诅 咒 将 使 敌 人 获 得 %d%% 技 能 失 败 率 。]]):
		format(chance)
	end,
}
registerTalentTranslation{
	id = "T_LUCKDRINKER",	
	name = "幸运汲取",
	info = function(self, t)
		local chance = t.getChance(self,t)
		local saves = t.getSaves(self,t)
		local crit = t.getCrit(self,t)
		local avoid = t.getAvoid(self,t)
		return ([[每 当 你 向 敌 人 施 加 厄 运 诅 咒， 有 %d%% 几 率 吸 取 敌 人 的 运 气 为 你 所 用 ， 持 续 1  0 回 合 。 这 个 效 果 最 多 叠 加 1 0 层 ， 每 层 增 加 %d 豁 免 和 防 御 ， %d%% 暴 击 率。
		如 果 你 同 时 学  会 了 命 中 注 定 ， 六 层 以 上 的 每 层 幸 运 使 你 获 得 %d%% 几 率 完 全 避 免 受 到 的 伤 害。]]):
		format(chance, saves, crit, avoid)
	end,
}
registerTalentTranslation{
	id = "T_FATEBREAKER",	
	name = "打破宿命",
	info = function(self, t)
		local dur = t.getDuration(self,t)
		local life = t.getLife(self,t)
		return ([[在 你 和 目 标 之 间 建 立 一 个 持 续 %d 回 合 的 命 运 链 接 。 如 果 在 这 期 间 你 收 到 了 致 命 的 伤 害 ， 你 将 条 件 反 射 般 扭 曲 现 实 ，尝 试 迫 使 目 标 在 你 的 位 置 死 亡 并 中 断 连 接。 
		这 个 技 能 使 你 在 那 一 回 合 中 免 受 所 有 的 伤 害 ， 并 将 伤 害 重 新 指 向 你 的 目 标， 伤 害 类 型 转 化 为 时 空 和 虚 空。
		同 时 ， 你 身 上 的 幸 运 效 果 和 目 标 携 带 的 厄 运 效 果 将 被 消 耗 ， 每 层  效 果 将 会 治 疗 %d 点 生 命 值。]]):
		format(dur, life)
	end,
}
return _M
