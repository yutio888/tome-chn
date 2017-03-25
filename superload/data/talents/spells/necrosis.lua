local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_BLURRED_MORTALITY",
	name = "模糊死亡",
	info = function(self, t)
		return ([[对 你 而 言， 生 死 之 别 变 的 模 糊， 你 只 有 在 生 命 值 下 降 到 -%d 时 才 会 死 亡。 ]]):
		format(t.lifeBonus(self, t))
	end,
}

registerTalentTranslation{
	id = "T_IMPENDING_DOOM",
	name = "灾厄降临",
	info = function(self, t)
		return ([[你 使 目 标 厄 运 临 头。 目 标 的 治 疗 加 成 减 少 80%% 且 会 对 目 标 造 成 它 %d%% 剩 余 生 命 值 的 奥 术 伤 害（ 或 %0.2f ， 取 最 小 伤 害 值）， 持 续 10 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(t.getDamage(self, t), t.getMax(self, t))
	end,
}

registerTalentTranslation{
	id = "T_UNDEATH_LINK",
	name = "亡灵分流",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[[吸 收 你 所 有 亡 灵 随 从 %d%% 的 最 大 生 命 值（ 可 能 会 杀 死 它 们） 并 使 用 这 股 能 量 治 愈 你。
		 受 法 术 强 度 影 响， 治 疗 量 有 额 外 加 成。]]):
		format(heal)
	end,
}

registerTalentTranslation{
	id = "T_LICHFORM",
	name = "巫妖转生",
	info = function(self, t)
		return ([[你 的 终 极 目 标。 所 有 亡 灵 法 师 的 目 标， 就 是 变 成 一 个 强 大 且 永 生 的 巫 妖！ 
		 当 此 技 能 激 活 时， 如 果 你 被 杀 死， 你 的 身 体 会 被 转 化 为 巫 妖。 
		 所 有 的 巫 妖 会 增 加 以 下 天 赋： 
		* 中 毒、 流 血、 恐 惧 免 疫 
		*100%% 疾 病 和 震 慑 抵 抗 
		*20%% 冰 冷 和 暗 影 抵 抗 
		* 不 需 要 呼 吸 
		* 纹 身 不 起 作 用 
		 同 时： 
		* 等 级 1 ： -3 所 有 属 性， -10%% 所 有 抵 抗。 
		 如 此 微 小 的 代 价！ 
		* 等 级 2 ： 无 
		* 等 级 3 ： +3 魔 法 和 意 志， +1 每 等 级 增 加 生 命 值（ 不 追 加 前 面 等 级 的 生 命 值）。 
		* 等 级 4 ： +3 魔 法 和 意 志， +2 每 等 级 增 加 生 命 值（ 不 追 加 前 面 等 级 的 生 命 值）， +10 法 术 和 精 神 豁 免， 天 空 / 星 怒 系 技 能 树（ 0.7 ） 和 每 回 合 0.1 负 能 量 回 复。 
		* 等 级 5 ： +5 魔 法 和 意 志， +2 每 等 级 增 加 生 命 值（ 不 追 加 前 面 等 级 的 生 命 值）， +10 法 术 和 精 神 豁 免， 所 有 抵 抗 上 限 增 加 10%% ， 天 空 / 星 怒 系 技 能 树（ 0.9 ） 和 每 回 合 0.5 负 能 量 回 复。 
		* 等 级 6 ： +6 魔 法、 意 志 和 灵 巧， +3 每 等 级 增 加 生 命 值（ 不 追 加 前 面 等 级 的 生 命 值）， +15 法 术 和 精 神 豁 免， 所 有 抵 抗 上 限 增 加 15%% ， 天 空 / 星 怒 系 技 能 树（ 1.1 ） 和 每 回 合 1.0 负 能 量 回 复。 
		* 等 级 7 ： #CRIMSON##{bold}#你 的 力 量 无 比 强 大 !#{normal}##LAST# +12 魔 法, 意 志 和 灵 巧 ， 60%% 几 率 无 视 暴 击，+4 每 等 级 增 加 生 命 值（ 不 追 加 前 面 等 级 的 生 命 值）， +35 法 术 和 精 神 豁 免, 所 有 抵 抗 上 限 增 加 15%% ， 天 空 / 星 怒 系 技 能 树（ 1.3 ） 和 每 回 合 1.0 负 能 量 回 复。
		 不 死 族 无 法 使 用 此 天 赋。 
		 当 此 技 能 激 活 时， 每 回 合 消 耗 4 法 力 值。]]):
		format()
	end,
}


return _M
