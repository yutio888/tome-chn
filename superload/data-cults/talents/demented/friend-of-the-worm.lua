local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WORM_THAT_WALKS_LINK",
	name = "蠕虫合体链接",
	info = function(self, t) return ([[链 接 至 召 唤 者]]) end,
}

registerTalentTranslation{
	id = "T_WORM_THAT_WALKS",
	name = "蠕虫合体",
	info = function(self, t)
		return ([[你 激 活 同 蠕 虫 合 体 的 契 约， 令 其 帮 助 你。
		你 可 以 完 全 控 制 它， 装 备 它。
		使 用 该 法 术 将 复 活 已 死 亡 的 单 位 ， 使 其 获 得 %d%% 生 命。
		原 始 技 能 等 级 提 升 将 带 来 更 多 装 备 格 ：
		等 级 1 ： 主 手 /副 手 武器
		等 级 2 ： 躯 体
		等 级 3 ： 腰 带
		等 级 4 ： 戒 指 /戒 指
		等 级 5 ： 戒 指 /戒 指/ 饰 品
		
		试 图 改 变 其 装 备 时， 先 将 装 备 交 给 它 ，再 切 换 控 制。]]):
		format(t.getPower(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WORM_THAT_STABS",
	name = "夹击", 
	info = function(self, t)
		return ([[你 和 蠕 虫 合 体 同 时 传 送 至 %d 内 的 目 标 处， 造 成 %d%% 近 战 伤 害。
		你 的 蠕 虫 合 体 的 闪 电 突 袭 技 能 冷 却 时 间 减 少 %d 。]])
		:format(10, t.getDamage(self, t) * 100, t.getBlindside(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHARED_INSANITY",
	name = "共享疯狂",
	info = function(self, t)
		return ([[ 你 和 蠕 虫 合 体 建 立 强 大 的 精 神 链 接。
		只 要 你 和 它 的 距 离 不 超 过 3 格， 你 们 均 获 得 持 续 3 回 合 的 %d%% 全 体 抗 性。
		该 技 能 每 增 加 两 级 原 始 等 级 ，你 的 蠕 虫 合 体 获 得 一 个 纹 身 位 （ 当 前 ： %d ）。 ]])
		:format(t.getResist(self, t), t.getInscriptions(self, t))
	end,
}
	
registerTalentTranslation{
	id = "T_TERRIBLE_SIGHT",
	name = "恐怖景象",
	info = function(self, t)
		return ([[ 当 你 处 于 蠕 虫 合 体 3 格 范 围 内 时 ，你 可 以 制 造 恐 怖 光 环。
		看 到 两 个 疯 狂 恐 魔 并 肩 作 战 将 令 周 围 %d 格 的 敌 人 震 慑 %d 回 合， 除 非 它 们 的 物 理 豁 免 成 功 对 抗 了 你 的 法 术 强 度。
		此 外， 你 的 共 享 疯 狂 效 果 将 令 3 格 内 的 敌 人 在 3 回 合 里 失 去 %d 法 术 豁 免 和 %d 闪 避 。]]):
		format(self:getTalentRange(t), t.getDur(self, t), t.getSave(self, t), t.getSave(self, t))
	end,
}

return _M
