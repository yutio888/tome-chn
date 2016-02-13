local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GRAPPLING_STANCE",
	name = "抓取姿态",
	info = function(self, t)
		local save = t.getSave(self, t)
		local damage = t.getDamage(self, t)
		return ([[增 加 你 的 物 理 豁 免 %d 和 你 的 物 理 强 度 %d 。 
		受 力 量 影 响， 增 益 按 比 例 加 成。]])
		:format(save, damage)
	end,
}

registerTalentTranslation{
	id = "T_CLINCH",
	name = "关节技：锁钳",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local power = t.getPower(self, t)
		local drain = t.getDrain(self, t)
		local share = t.getSharePct(self, t)*100
		local damage = t.getDamage(self, t)*100
		return ([[对 目 标 造 成 %d%% 武 器 伤 害 并 抓 取 目 标（ 可 抓 取 目 标 的 身 材 最 多 比 你 大 1 级） 持 续 %d 回 合。 1 个 被 钳 住 的 对 手 将 无 法 移 动,每 回 合 受 到 %d 伤 害， 同 时 你 受 到 的 伤 害 的 %d%% 将 转 移 至 它 身 上。 
		任 何 目 标 或 你 的 移 动 将 会 打 破 抓 取。 维 持 抓 取 每 回 合 消 耗 %d 体 力。 
		同 时 你 只 能 抓 取 1 个 目 标， 并 且 对 任 意 1 个 你 没 有 抓 取 的 目 标 使 用 非 抓 取 徒 手 技 能 均 会 打 破 抓 取。 ]])
		:format(damage, duration, power, share, drain)
	end,
}

registerTalentTranslation{
	id = "T_CRUSHING_HOLD",
	name = "关节技：折颈",
	info = function(self, t)
		local reduction = t.getDamageReduction(self, t)
		local slow = t.getSlow(self, t)
		
		return ([[增 强 你 的 抓 取 ， 获 得 额 外 效 果 ， 所 有 效 果 不 需 通 过 其 他 豁 免 或 抵 抗 鉴 定。
		#RED# 等 级 1 ： 减 少 %d 基 础 武 器 伤 害
		等 级 3 ： 沉 默 
		等 级 5 ： 目 标 减 速 %d%% ]])
		:format(reduction, slow*100)
	end,
}

registerTalentTranslation{
	id = "T_TAKE_DOWN",
	name = "关节技：抱摔",
	info = function(self, t)
		local takedown = t.getDamage(self, t)*100
		local slam = t.getSlam(self, t)
		return ([[冲 向 目 标 ， 试 图 将 他 掀 翻 在 地 ， 造 成 %d%% 伤 害 然 后 抓 取 之 。 如 果 已 经 抓 取 ， 则 将 他 掀 翻 ， 制 造 冲 击 波 ， 在 半 径 5 的 范 围 内 造 成 %d 物 理 伤 害 并 解 除 抓 取。
		 抓 取 效 果 和 持 续 时 间 基 于 抓 取 技 能 。 伤 害 受 物 理 强 度 加 成。]])
		:format(damDesc(self, DamageType.PHYSICAL, (takedown)), damDesc(self, DamageType.PHYSICAL, (slam)))
	end,
}

registerTalentTranslation{
	id = "T_HURRICANE_THROW",
	name = "关节技：飓风投",
	info = function(self, t)
		return ([[你 使 出 全 力 将 抓 取 的 目 标 扔 到 空 中 ， 对 他 和 着 陆 点 周 围 的 生 物 造 成 %d%% 伤 害 。]]):format(t.getDamage(self, t)*100)	
	end,
}


return _M
