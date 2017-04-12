local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHADOW_LEASH",
	name = "暗影束缚",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[使 你 的 武 器 立 刻 转 化 为 暗 影 之 缚 形 态， 夺 取 目 标 武 器， 缴 械 目 标 %d 回 合。 
		 受 命 中 影 响， 技 能 命 中 率 有 额 外 加 成。]]):
		format(duration)
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_AMBUSH",
	name = "暗影伏击",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 向 目 标 甩 出 1 道 影 之 绳 索， 将 目 标 拉 向 你 并 沉 默 它 %d 回 合， 同 时 眩 晕 目 标 2 回 合。 
		 受 命 中 影 响， 技 能 命 中 率 有 额 外 加 成。]]):
		format(duration)
	end,
}

registerTalentTranslation{
	id = "T_AMBUSCADE",
	name = "影分身",
	info = function(self, t)
		return ([[你 在 %d 回 合 内 完 全 控 制 你 的 影 子。 
		 你 的 影 子 继 承 了 你 的 天 赋 和 属 性， 拥 有 你 %d%% 的 生 命 值 并 造 成 等 同 于 你 %d%% 的 伤 害， -30%% 所 有 抵 抗， -100%% 光 属 性 抵 抗 并 增 加 100%% 暗 影 抵 抗。 
		 你 的 影 子 处 于 永 久 潜 行 状 态（ %d 潜 行 强 度） 并 且 它 所 造 成 的 所 有 近 战 伤 害 均 会 转 化 为 暗 影 伤 害。 
		 如 果 你 提 前 解 除 控 制 或 者 它 离 开 你 的 视 野 时 间 过 长， 你 的 影 分 身 会 自 动 消 失。]]):
		format(t.getDuration(self, t), t.getHealth(self, t) * 100, t.getDam(self, t) * 100, t.getStealthPower(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_VEIL",
	name = "暗影面纱",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local res = t.getDamageRes(self, t)
		return ([[你 融 入 阴 影 并 被 其 支 配， 持 续 %d 回 合。 
		 当 你 笼 罩 在 阴 影 里 时， 你 对 所 有 状 态 免 疫 并 减 少 %d%% 所 有 伤 害。 每 回 合 你 可 以 闪 烁 到 附 近 的 1 个 敌 人 面 前( 半 径 %d 以 内 )， 对 其 造 成 %d%% 暗 影 武 器 伤 害。 
		 阴 影 不 能 被 传 送。 
		 当 此 技 能 激 活 时， 除 非 你 死 亡 否 则 无 法 被 打 断， 并 且 你 也 无 法 控 制 你 的 角 色。]]):
		format(duration, res, t.getBlinkRange(self, t) ,100 * damage)
	end,
}




return _M
