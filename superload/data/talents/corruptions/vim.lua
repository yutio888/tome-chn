local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SOUL_ROT",
	name = "灵魂腐蚀",
	info = function(self, t)
		return ([[向 目 标 发 射 一 枚 纯 粹 的 枯 萎 弹， 造 成 %0.2f 枯 萎 伤 害。 
		 此 技 能 的 暴 击 率 增 加 +%0.2f%% 。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 20, 250)), t.getCritChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_VIMSENSE",
	name = "活力感知",
	info = function(self, t)
		return ([[感 受 你 周 围 10 码 半 径 范 围 内 怪 物 的 位 置， 持 续 %d 回 合。 
		 这 个 邪 恶 的 力 量 同 时 会 降 低 目 标 %d%% 枯 萎 抵 抗， 但 也 会 使 它 们 察 觉 到 你。 
		 受 法 术 强 度 影 响， 抵 抗 的 降 低 效 果 有 额 外 加 成。]]):
		format(t.getDuration(self,t), t.getResistPenalty(self,t))
	end,
}

registerTalentTranslation{
	id = "T_LEECH",
	name = "活力吸取",
	info = function(self, t)
		return ([[每 当 被 活 力 感 知 发 现 的 敌 人 攻 击 你 时， 你 回 复 %0.2f 活 力 值 和 %0.2f 生 命 值。]]):
		format(t.getVim(self,t),t.getHeal(self,t))
	end,
}

registerTalentTranslation{
	id = "T_DARK_PORTAL",
	name = "黑暗之门",
	info = function(self, t)
		return ([[开 启 一 扇 通 往 目 标 地 点 的 黑 暗 之 门。 所 有 在 目 标 地 点 的 怪 物 将 和 你 调 换 位 置。 
		 所 有 怪 物（ 除 了 你） 在 传 送 过 程 中 都 会 随 机 感 染 一 种 疾 病， 每 回 合 受 到 %0.2f 枯 萎 伤 害， 持 续 6 回 合。 
		 同 时， 减 少 其 某 项 物 理 属 性（ 力 量， 体 质 或 敏 捷） %d 点。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 12, 80)), self:combatTalentSpellDamage(t, 5, 25))
	end,
}



return _M
