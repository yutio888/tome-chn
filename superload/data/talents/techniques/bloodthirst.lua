local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MORTAL_TERROR",
	name = "致命恐惧",
	info = function(self, t)
		return ([[你 强 力 的 攻 击 引 发 敌 人 深 深 的 恐 惧。 
		任 何 你 对 目 标 造 成 的 超 过 其 %d%% 总 生 命 值 的 近 身 打 击 会 使 目 标 陷 入 深 深 的 恐 惧 中， 眩 晕 目 标 5 回 合。 
		你 的 暴 击 率 同 时 增 加 %d%% 。 
		受 物 理 强 度 影 响， 眩 晕 概 率 有 额 外 加 成。 ]]):
		format(t.threshold(self, t), self:getTalentLevelRaw(t) * 2.8)
	end,
}

registerTalentTranslation{
	id = "T_BLOODBATH",
	name = "浴血奋战",
	info = function(self, t)
		local regen = t.getRegen(self, t)
		local max_regen = t.getMax(self, t)
		local max_health = t.getHealth(self,t)
		return ([[沐 浴 着 敌 人 的 鲜 血 令 你 感 到 兴 奋。 
		在 成 功 打 出 一 次 暴 击 后， 会 增 加 你 %d%% 的 最 大 生 命 值、 %0.2f 每 回 合 生 命 回 复 点 数 和 %0.2f 每 回 合 体 力 回 复 点 数 持 续 %d 回 合。  
		生 命 与 体 力 回 复 可 以 叠 加 5 次 直 至 %0.2f 生 命 和 %0.2f 体 力 回 复 / 回 合。]]):
		format(t.getHealth(self, t), regen, regen/5, t.getDuration(self, t),max_regen, max_regen/5)
	end,
}

registerTalentTranslation{
	id = "T_BLOODY_BUTCHER",
	name = "血之屠夫",
	info = function(self, t)
		return ([[你 沉 醉 于 撕 裂 伤 口 的 兴 奋 中，增 加 %d 物 理 强 度。
		同 时 ， 每 次 你 让 敌 人流 血 时 ， 它 的 物 理 抗 性 下 降 %d%% （但 不 会 小 于 0 ）
		物 理 强 度 加 成 受 力 量 影 响。]]):
		format(t.getDam(self, t), t.getResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_UNSTOPPABLE",
	name = "天下无双",
	info = function(self, t)
		return ([[你 进 入 疯 狂 战 斗 状 态 %d 回 合。 
		在 这 段 时 间 内 你 不 能 使 用 物 品， 并 且 治 疗 无 效， 此 时 你 的 生 命 值 无 法 低 于 1 点。 
		状 态 结 束 后 你 每 杀 死 一 个 敌 人 可 以 回 复 %d%% 最 大 生 命 值。
		当 进 入 无 双 状 态 时 ， 由 于 你 失 去 了 死 亡 的 威 胁 ， 狂 战 之 怒 不 能 提 供 暴 击 加 成。]]):
		format(t.getDuration(self, t), t.getHealPercent(self,t))
	end,
}


return _M
