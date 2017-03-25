local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TACTICAL_EXPERT",
	name = "战术大师",
	info = function(self, t)
		local defense = t.getDefense(self, t)
		local maximum = t.getMaximum(self, t)
		return ([[每 个 可 见 的 相 邻 敌 人 可 以 使 你 的 闪 避 增 加 %d 点， 最 大 增 加 +%d 点 闪 避。 
		 受 灵 巧 影 响， 闪 避 增 益 和 增 益 最 大 值 按 比 例 加 成。]]):format(defense, maximum)
	end,
}

registerTalentTranslation{
	id = "T_COUNTER_ATTACK",
	name = "相位反击",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[当 你 闪 避 一 次 紧 靠 着 你 的 对 手 的 近 战 攻 击 时 你 有 %d%% 的 概 率 对 对 方 造 成 一 次 %d%% 伤 害 的 反 击 , 每 回 合 最 多 触 发 %0.1f 次。 
		 徒 手 格 斗 时 会 尝 试 将 敌 人 掀 翻 在 地，眩 晕 两 回 合 ， 如 果 处 于 抓 取 状 态 改 为 震 慑 。 
		 受 灵 巧 影 响， 反 击 概 率 和 反 击 数 目 有 额 外 加 成。]]):format(t.counterchance(self,t), damage,  t.getCounterAttacks(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SET_UP",
	name = "致命闪避",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local power = t.getPower(self, t)
		local defense = t.getDefense(self, t)
		return ([[增 加 %d 点 闪 避， 持 续 %d 回 合。 当 你 闪 避 1 次 近 战 攻 击 时， 你 可 以 架 起 目 标， 有 %d%% 概 率 使 你 对 目 标 进 行 1 次 暴 击 并 减 少 它 们 %d 点 豁 免。 
		 受 灵 巧 影 响， 效 果 按 比 例 加 成。]])
		:format(defense, duration, power, power)
	end,
}

registerTalentTranslation{
	id = "T_EXPLOIT_WEAKNESS",
	name = "弱点感知",
	info = function(self, t)
		local reduction = t.getReductionMax(self, t)
		return ([[感 知 对 手 的 物 理 弱 点， 代 价 是 你 减 少 10%% 物 理 伤 害。 每 次 你 击 中 对 手 时， 你 会 减 少 它 们 5%% 物 理 伤 害 抵 抗， 最 多 减 少 %d%% 。]]):format(reduction)
	end,
}



return _M
