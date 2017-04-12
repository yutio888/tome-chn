local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_BODIES_RESERVE",
	name = "躯 体 储 备",
	info = function (self,t)
		return ([[你 的 头 脑 是 如 此 强 大 ，它 可 以 扭 曲 现 实 ，为 你 提 供 一 个 非 自 然 的 #{italic}#仓 库#{normal}# 让 你 储 存 抢 夺 过 来 的 身 体 。
		仓 库 容 量 增 加 %d 。]]):
		format(t.getMax(self, t))
	end,
}
registerTalentTranslation{
	id = "T_PSIONIC_MINION",
	name = "灵 能 奴 役",
	info = function (self,t)
		return ([[你 将 自 己 的 心 灵 的 一 部 分 融 入 一 个 身 体 ，而 不 会 实 际 上 表 现 出 来 。
		身 体 会 作 为 你 的 仆 从 工 作 %d 回 合 。
		灵 能 仆 从 无 法 被 任 何 方 法 治 疗 。
		当 效 果 结 束 时 ，身 体 永 久 丢 失。]]):
		format(t.getDur(self, t))
	end,
}
registerTalentTranslation{
	id = "T_PSIONIC_DUPLICATION",
	name = "灵 能 复 制",
	info = function (self,t)
		return ([[当 你 获 得 一 个 身 体 时 复 制 %d 个 克 隆 体.
		当 你 获 得  稀有/史诗/Boss 或 者 更 高 阶级 的 身 体 时 ，复 制 的 数 量 除 以 3 (至 少 一 个).]]):
		format(t.getNb(self, t))
	end,
}
registerTalentTranslation{
	id = "T_CANNIBALIZE",
	name = "合 并",
	info = function (self,t)
		return ([[合 并 一 个 身 体 ，用 来 补 充 现 在 使 用 的 身 体 。
		你 只 能 合 并 同 阶 级 或 者 更 高 阶 级 的 身 体 且 每 次 治 疗 效 果 降 低 33%% 。
		生 命 值 恢 复 被 合 并 的 身 体 的 最 大 血 量 %d%% 且 你 的 灵 能 值 恢 复 这 个 数 值 的 50%% 。
		该 治 疗 不 会 被 其 他 效 果 减 低 ，合 并 是 治 疗 身 体 的 唯 一 方 法 。]]):
		format(t.getHeal(self, t))
	end,
}
return _M