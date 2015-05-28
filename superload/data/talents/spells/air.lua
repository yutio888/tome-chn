local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_LIGHTNING",
	name = "闪电术",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[用 魔 法 召 唤 一 次 强 力 的 闪 电 造 成 %0.2f ～ %0.2f 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.LIGHTNING, damage / 3),
		damDesc(self, DamageType.LIGHTNING, damage))
	end,
}

registerTalentTranslation{
	id = "T_CHAIN_LIGHTNING",
	name = "连锁闪电",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local targets = t.getTargetCount(self, t)
		return ([[召 唤 一 次 叉 状 闪 电 造 成 %0.2f ～ %0.2f 伤 害 并 连 锁 到 另 外 一 个 目 标。 
		 它 最 多 可 以 连 锁 10 码 范 围 内 %d 个 目 标 并 且 不 会 对 同 一 目 标 伤 害 2 次， 同 样 它 不 会 伤 害 到 施 法 者。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.LIGHTNING, damage / 3),
			damDesc(self, DamageType.LIGHTNING, damage),
			targets)
	end,
}

registerTalentTranslation{
	id = "T_FEATHER_WIND",
	name = "风之羽翼",
	info = function(self, t)
		local encumberance = t.getEncumberance(self, t)
		local rangedef = t.getRangedDefence(self, t)
		return ([[一 股 温 柔 的 风 围 绕 着 施 法 者， 增 加 %d 点 负 重 能 力 并 增 加 %d 点 对 抛 射 物 的 闪 避。 
		 在 等 级 4 时， 它 会 使 你 轻 微 的 漂 浮 在 空 中， 可 忽 略 部 分 陷 阱。 
		 在 等 级 5 时， 同 时 还 会 提 升 你 %d%% 的 移 动 速 度 并 且 移 除 %d 点 负 重。]]):
		format(encumberance, rangedef, t.getSpeed(self, t) * 100, t.getFatigue(self, t))
	end,
}

registerTalentTranslation{
	id = "T_THUNDERSTORM",
	name = "闪电风暴",
	info = function(self, t)
		local targetcount = t.getTargetCount(self, t)
		local damage = t.getDamage(self, t)
		local manadrain = t.getManaDrain(self, t)
		return ([[当 此 技 能 激 活 时， 在 6 码 半 径 范 围 内 召 唤 一 阵 强 烈 的 闪 电 风 暴 跟 随 你。 
		 每 回 合 闪 电 风 暴 会 随 机 伤 害 %d 个 敌 方 单 位， 对 1 码 半 径 范 围 造 成 1 ～ %0.2f 伤 害。 
		 这 个 强 力 的 技 能 每 击 会 减 少 你 %0.2f 法 力 值。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(targetcount, damDesc(self, DamageType.LIGHTNING, damage),-manadrain)
	end,
}


return _M
