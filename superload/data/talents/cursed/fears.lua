local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_INSTILL_FEAR",
	name = "恐惧灌输",
	info = function(self, t)
		return ([[将 恐 惧 注 入 你 的 目 标， 在 %d 回 合 内 触 发 一 种 恐 惧 效 果。 同 时 有 25%% 概 率 将 恐 惧 注 入 %d 码 范 围 内 的 所 有 敌 人。 
		 目 标 将 与 你 的 精 神 强 度 进 行 豁 免 鉴 定， 并 且 可 以 被 多 种 恐 惧 效 果 影 响。 
		 你 习 得 2 种 新 的 恐 惧 效 果： 妄 想 症 使 目 标 有 %d%% 概 率 以 物 理 攻 击 附 近 一 个 友 善 或 非 友 善 目 标， 被 击 中 者 也 会 被 传 染 妄 想 症。 绝 望 效 果 使 目 标 对 所 有 伤 害 抵 抗 减 少 %d%% 。 
		 受 精 神 强 度 影 响， 恐 惧 效 果 有 额 外 加 成。]]):format(t.getDuration(self, t), self:getTalentRadius(t),
		t.getParanoidAttackChance(self, t),
		-t.getDespairResistAllChange(self, t))
	end,
}

registerTalentTranslation{
	id = "T_HEIGHTEN_FEAR",
	name = "恐惧深化",
	info = function(self, t)
		local tInstillFear = self:getTalentFromId(self.T_INSTILL_FEAR)
		local range = self:getTalentRange(t)
		local turnsUntilTrigger = t.getTurnsUntilTrigger(self, t)
		local duration = tInstillFear.getDuration(self, tInstillFear)
		return ([[ 加 深 你 周 围 所 有 人 的 恐 惧 。 被 你 的 恐 惧 效 果 影 响 的 敌 人、 和 你 距 离 不 超 过 %d 且 在 你 视 野 内 不 少 于 %d 回 合 的 敌 人 ， 将 会 得 到 一 种 新 的 恐 惧 效 果 ， 持 续 %d 回 合。 目 标 的 精 神 豁 免 抵 抗 你 的 精 神 强 度 后 可 能 会 抵 抗 该 效 果， 且 每 个 已 有 的 恐 惧 效 果 会 减 少 10%% 新 的 恐 惧 效 果 产 生 概 率。
		 你 习 得 2 种 新 的 恐 惧 效 果： 惊 恐 效 果 使 其 技 能 或 攻 击 失 败 %d%% 。 痛 苦 效 果 使 其 所 有 豁 免 值 降 低 %d 。 
		 受 精 神 强 度 影 响， 恐 惧 效 果 有 额 外 加 成。]]):format(range, turnsUntilTrigger, duration,
		t.getTerrifiedActionFailureChance(self, t),
		-t.getDistressedSaveChange(self, t))
	end,
}

registerTalentTranslation{
	id = "T_TYRANT",
	name = "精神专制",
	info = function(self, t)
		return ([[提 高 对 恐 惧 的 目 标 的 精 神 专 制， 对 那 些 试 图 摆 脱 你 恐 惧 效 果 的 目 标 你 的 精 神 强 度 增 加 %d ， 你 习 得 2 种 新 的 恐 惧 效 果： 纠 缠 效 果 使 得 每 一 种 恐 惧 效 果 产 生 %d 精 神 伤 害， 痛 苦 折 磨 效 果 产 生 %d 个 幻 觉 攻 击 目 标， 产 生 %d 精 神 伤 害 直 至 幻 觉 消 失。 
		 受 精 神 强 度 影 响， 恐 惧 效 果 有 额 外 加 成。]]):format(t.getMindpowerChange(self, t),
		t.getHauntedDamage(self, t),
		t.getTormentedCount(self, t), t.getTormentedDamage(self, t))
	end,
}

registerTalentTranslation{
	id = "T_PANIC",
	name = "惊慌失措",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		return ([[使 %d 范 围 内 的 敌 人 惊 慌 失 措， 持 续 %d 回 合， 任 何 未 通 过 精 神 豁 免 的 敌 人 每 回 合 将 有 %d%% 概 率 从 你 身 边 吓 走。]]):format(range, duration, chance)
	end,
}



return _M
