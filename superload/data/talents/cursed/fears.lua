local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_INSTILL_FEAR",
	name = "恐惧灌输",
	info = function(self, t)
		local damInstil = t.getDamage(self, t) / 2
		local damTerri = t.getTerrifiedDamage(self, t) / 2
		local damHaunt = t.getHauntedDamage(self, t) / 2
		return ([[将 恐 惧 注 入 目 标 %d 半 径 范 围 内 的 敌 人 中 ， 造 成 %0.2f 精 神 和 %0.2f 暗 影 伤 害 ， 并 随 机 造 成 4 种 可 能 的恐 惧 效 果 之 一 ， 持 续 %d 回 合。
		目 标 可 以 与 你 的 精 神 强 度 对 抗 ， 以 抵 抗 恐 惧 效 果。
		恐 惧 效 果 受 精 神 强 度 加 成。
		
		可 能 的 恐 惧 效 果 如 下 所 示：
		#ORANGE#妄想症:#LAST# 目 标 有 %d%% 几 率 使 用 物 理 攻 击 附 近 的 生 物 ， 不 管 它 是 敌 对 还 是 友 方 生 物 。 如 果 击 中 了 目 标 ， 目 标 也 会 感 染 妄 想 症。
		#ORANGE#绝望:#LAST# 精 神 伤 害 抵 抗 ， 精 神 豁 免 ， 护 甲 值 和 闪 避 各 降 低 %d 。
		#ORANGE#惊惧:#LAST# 每 回 合 受 到 %0.2f 精 神 和 %0.2f 暗 影 伤 害 ， 技 能 冷 却 时 间 增 加  %d%% 。
		#ORANGE#恶灵缠身:#LAST# 目 标 每 有 一 个 负 面 精 神 效 果 ， 则 每 回 合 受 到 %0.2f 精 神 和 %0.2f 暗 影 伤 害。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.MIND, damInstil), damDesc(self, DamageType.DARKNESS, damInstil), t.getDuration(self, t),
		t.getParanoidAttackChance(self, t),
		-t.getDespairStatChange(self, t),
		damDesc(self, DamageType.MIND, damTerri), damDesc(self, DamageType.DARKNESS, damTerri), t.getTerrifiedPower(self, t),
		damDesc(self, DamageType.MIND, damHaunt), damDesc(self, DamageType.DARKNESS, damHaunt)
	)
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
		local damage = t.getDamage(self, t)
		return ([[加 深 你 周 围 敌 人 的 恐 惧 。 所 有 被 你 灌 注 恐 惧 的 目 标 若 停 留 在 你 视 野 内， 并 且 和 你 距 离 不 超 过 %d ， 这 样 累 计 达 到 %d 回 合 时，受 到 %0.2f 精 神 和  %0.2f 暗 影 伤 害 ， 并 获 得 一 个 新 的 持 续 %d  回 合 的 恐 惧 效 果 。
		这 一 效 果 无 视 恐 惧 免 疫 ， 但 可 以 被 豁 免。]]):
			format(range, turnsUntilTrigger, damDesc(self, DamageType.MIND, t.getDamage(self, t) / 2), damDesc(self, DamageType.DARKNESS, t.getDamage(self, t) / 2 ), duration)
	end,
}

registerTalentTranslation{
	id = "T_TYRANT",
	name = "精神专制",
	info = function(self, t)
		return ([[提 高 对 被 你 恐 惧 的 目 标 的 精 神 专 制 。 当 一 个 敌 人 获 得 了 一 个 新 的 恐 惧 效 果 ， 你 有 %d%%  的 几 率 增 加 这 一 效 果 和 另 一 个 随 机 的 已 有 恐 惧 效 果 的 持 续 时 间 %d 回 合 ， 最 多 8 回 合 。
		 此 外 ， 每 当 你 恐 惧 一 个 目 标 ， 你 获 得 %d 精 神 强 度 和 物 理 强 度 ， 持 续 5 回 合 ， 最 多 叠 加 %d 层]]):format(t. getExtendChance(self, t), t.getExtendFear(self, t), t.getTyrantPower(self, t), t.getMaxStacks(self, t))
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
