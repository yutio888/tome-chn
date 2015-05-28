local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_UNNATURAL_BODY",
	name = "诅咒之体",
	info = function(self, t)
		local healPerKill = t.getHealPerKill(self, t)
		local maxUnnaturalBodyHeal = t.getMaxUnnaturalBodyHeal(self, t)
		local regenRate = t.getRegenRate(self, t)

		return ([[你 的 力 量 来 源 于 心 底 的 憎 恨， 这 使 得 大 部 分 治 疗 效 果 减 至 原 来 的 50%% （ 0 仇 恨） ～ 100%% （ 100+ 仇 恨）。 
		 另 外， 每 次 击 杀 敌 人 你 将 存 储 生 命 能 量 来 治 疗 自 己， 回 复 %d 点 生 命（ 受 敌 人 最 大 生 命 值 限 制， 任 何 时 候 不 能 超 过 %d 点 ）。 这 个 方 式 带 来 的 每 回 合 回 复 量 不 能 超 过 %0.1f 点 生 命， 也 不 受 仇 恨 等 级 或 治 疗 加 成 等 因 素 影 响。 
		 受 意 志 影 响， 通 过 杀 死 敌 人 获 得 的 治 疗 量 有 额 外 加 成。]]):format(healPerKill, maxUnnaturalBodyHeal, regenRate)
	end,
}

registerTalentTranslation{
	id = "T_RELENTLESS",
	name = "鲜血渴望",
	info = function(self, t)
		return ([[对 鲜 血 的 渴 望 控 制 了 你 的 行 为。 增 加 +%d%% 混 乱、 恐 惧、 击 退 和 震 慑 免 疫。]]):format(t.getImmune(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_SEETHE",
	name = "狂热沸腾",
	info = function(self, t)
		local incDamageChangeMax = t.getIncDamageChange(self, t, 5)
		return ([[你 学 会 控 制 憎 恨， 并 用 你 的 痛 苦 燃 烧 心 底 的 愤 怒。 
		 每 当 你 受 到 伤 害 时， 你 的 伤 害 会 在 5 回 合 后 增 加 至 最 大 值 +%d%% 。 
		 每 个 你 不 承 受 伤 害 的 回 合 会 降 低 该 增 益 效 果。]]):format(incDamageChangeMax)
	end,
}

registerTalentTranslation{
	id = "T_GRIM_RESOLVE",
	name = "冷酷决心",
	info = function(self, t)
		local statChangeMax = t.getStatChange(self, t, 5)
		local neutralizeChance = t.getNeutralizeChance(self, t)
		return ([[你 勇 于 面 对 其 他 人 带 给 你 的 痛 苦。 每 回 合 当 你 承 受 伤 害 时， 你 将 会 增 加 你 的 力 量 和 意 志， 直 至 在 5 回 合 后 增 加 至 最 大 值 +%d 。 
		 每 个 你 不 承 受 伤 害 的 回 合 会 降 低 该 增 益 效 果。 
		 当 此 效 果 激 活 时， 每 回 合 你 有 %d%% 的 概 率 抵 抗 毒 素 和 疾 病 效 果。]]):format(statChangeMax, neutralizeChance)
	end,
}





return _M
