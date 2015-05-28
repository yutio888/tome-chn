local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SOLIPSISM",
	name = "唯我论",
	info = function(self, t)
		local conversion_ratio = t.getConversionRatio(self, t)
		local psi_damage_resist, psi_damage_resist_base, psi_damage_resist_talent = t.getPsiDamageResist(self, t)
		local threshold = math.min((self.solipsism_threshold or 0),self:callTalent(self.T_CLARITY, "getClarityThreshold") or 1)
		return ([[你 相 信 你 的 心 灵 是 世 间 万 物 的 中 心。 
		 每 级 永 久 性 增 加 你 5 点 超 能 力 值， 并 减 少 你 50 ％ 的 生 命 成 长（ 影 响 升 级 时 的 生 命 增 益， 但 只 在 学 习 此 技 能 时 永 久 影 响 一 次）
		 同 时 你 学 会 用 心 灵 来 承 受 伤 害， 转 化 %d%% 生 命 削 减 为 超 能 力 值 削 减， 并 且 %d%% 的 治 疗 值 和 回 复 值 会 转 化 为 超 能 力 值 的 增 长。 
		 转 化 成 的 超 能 力 值 削 减 将 进 一 步 被 减 少 %0.1f%% （ %0.1f%% 来 自 于 人 物 等 级， %0.1f%% 来 自 于 技 能 等 级 。 ） 
		 学 习 此 技 能 时，（ 高 于 基 础 值 10 的） 每 点 意 志 会 额 外 增 加 0.5 点 超 能 力 值 上 限， 而（ 高 于 基 础 值 10 的） 每 点 体 质 会 减 少 0.25 点 生 命 上 限（ 若 低 于 基 础 值 10 则 增 加 生 命 上 限）。 
		 学 习 此 技 能 时， 你 的 唯 我 临 界 点 会 增 加 20 ％（ 当 前 %d%% ）， 你 的 超 能 力 值 每 低 于 这 个 临 界 点 1 ％， 你 的 所 有 速 度 减 少 1 ％。]]):format(conversion_ratio * 100, conversion_ratio * 100, psi_damage_resist, psi_damage_resist_base * 100, psi_damage_resist_talent, (self.solipsism_threshold or 0) * 100)
	end,
}

registerTalentTranslation{
	id = "T_BALANCE",
	name = "唯我论：均衡",
	info = function(self, t)
		local ratio = t.getBalanceRatio(self, t) * 100
		return ([[你 现 在 使 用 %d%% 精 神 豁 免 值 来 替 代 %d%% 物 理 和 法 术 豁 免（ 即 100 ％ 时 精 神 豁 免 完 全 替 代 所 有 豁 免）。 
		 学 习 此 技 能 时，（ 高 于 基 础 值 10 的） 每 点 意 志 会 额 外 增 加 0.5 点 超 能 力 值 上 限， 而（ 高 于 基 础 值 10 的） 每 点 体 质 会 减 少 0.25 点 生 命 上 限（ 若 低 于 基 础 值 10 则 增 加 生 命 上 限）。 
		 学 习 此 技 能 也 会 增 加 你 10 ％ 唯 我 临 界 点（ 当 前 %d%% ）。]]):format(ratio, ratio, math.min((self.solipsism_threshold or 0),self.clarity_threshold or 1) * 100)
	end,
}

registerTalentTranslation{
	id = "T_CLARITY",
	name = "唯我论：明晰",
	info = function(self, t)
		local threshold = t.getClarityThreshold(self, t)
		local bonus = ""
		if not self.max_level or self.max_level > 50 then
			bonus = " Exceptional focus on this talent can suppress your solipsism threshold."
		end
		return ([[当 你 的 超 能 力 值 超 过 %d%% 时， 每 超 过 1 ％ 你 增 加 1 ％ 整 体 速 度（ 最 大 值 %+d%% ）。 
		 学 习 此 技 能 时，（ 高 于 基 础 值 10 的） 每 点 意 志 会 额 外 增 加 0.5 点 超 能 力 值 上 限， 而（ 高 于 基 础 值 10 的） 每 点 体 质 会 减 少 0.25 点 生 命 上 限（ 若 低 于 基 础 值 10 则 增 加 生 命 上 限）， 增 加 你 10 ％ 唯 我 临 界 点（ 当 前 %d%% ）。]]):
		format(threshold * 100, (1-threshold)*100, math.min(self.solipsism_threshold or 0,threshold) * 100)..bonus
	end,
}

registerTalentTranslation{
	id = "T_DISMISSAL",
	name = "唯我论：豁免",
	info = function(self, t)
		local save_percentage = t.getSavePercentage(self, t)
		return ([[每 当 你 受 到 伤 害 时， 你 会 使 用 %d%% 精 神 豁 免 来 鉴 定。 鉴 定 时 精 神 豁 免 可 能 暴 击， 至 少 减 少 50%% 的 伤 害 。 
		 学 习 此 技 能 时，（ 高 于 基 础 值 10 的） 每 点 意 志 会 额 外 增 加 0.5 点 超 能 力 值 上 限， 而（ 高 于 基 础 值 10 的） 每 点 体 质 会 减 少 0.25 点 生 命 上 限（ 若 低 于 基 础 值 10 则 增 加 生 命 上 限）。 
		 学 习 此 技 能 也 会 增 加 你 10 ％ 唯 我 临 界 点（ 当 前 %d%% ）。]]):format(save_percentage * 100, math.min(self.solipsism_threshold or 0,self.clarity_threshold or 1) * 100)		
	end,
}


return _M
