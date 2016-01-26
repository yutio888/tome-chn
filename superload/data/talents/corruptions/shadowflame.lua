local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WRAITHFORM",
	name = "鬼魂形态",
	info = function(self, t)
		return ([[转 化 为 鬼 魂， 允 许 你 穿 墙（ 但 不 会 免 疫 窒 息）， 持 续 %d 回 合。 
		 同 时 增 加 闪 避 %d 和 护 甲 值 %d 。 
		 效 果 结 束 时 若 你 处 于 墙 内， 你 将 被 随 机 传 送。
		 受 法 术 强 度 影 响， 增 益 效 果 有 额 外 加 成。]]):
		format(t.getDuration(self, t), t.getDefs(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DARKFIRE",
	name = "黑暗之炎",
	info = function(self, t)
		return ([[向 目 标 发 射 一 团 黑 暗 之 炎， 产 生 爆 炸 并 造 成 %0.2f 火 焰 伤 害 和 %0.2f 暗 影 伤 害（ %d 码 半 径 范 围 内）。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(
			damDesc(self, DamageType.FIRE, self:combatTalentSpellDamage(t, 28, 220) / 2),
			damDesc(self, DamageType.DARKNESS, self:combatTalentSpellDamage(t, 28, 220) / 2),
			self:getTalentRadius(t)
		)
	end,
}

registerTalentTranslation{
	id = "T_FLAME_OF_URH_ROK",
	name = "乌鲁洛克之焰",
	info = function(self, t)
		return ([[召 唤 伟 大 的 恶 魔 领 主 乌 鲁 洛 克 的 实 体， 转 化 为 恶 魔。 
		 当 你 处 于 恶 魔 形 态 时， 你 增 加 %d%% 火 焰 抵 抗， %d%% 暗 影 抵 抗 并 且 增 加 %d%% 整 体 速 度。 
		 当 你 处 于 恶 魔 形 态 时， 恐 惧 空 间 的 火 焰 会 治 疗 你。 
		 受 法 术 强 度 影 响， 抵 抗 和 治 疗 量 有 额 外 加 成。]]):
		format(self:combatTalentSpellDamage(t, 20, 30), self:combatTalentSpellDamage(t, 20, 35), t.getSpeed(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_DEMON_PLANE",
	name = "恐惧空间",
	info = function(self, t)
		return ([[召 唤 一 部 分 恐 惧 空 间 与 现 有 空 间 交 叉。 
		 你 的 目 标 和 你 自 己 都 会 被 带 入 恐 惧 空 间， 只 有 当 你 中 断 技 能 或 目 标 死 亡 时， 限 制 解 除。 
		 在 恐 惧 空 间 内， 永 恒 之 焰 会 燃 烧 你（ 治 疗 恶 魔） 和 目 标， 造 成 %0.2f 火 焰 伤 害。 
		 当 技 能 中 断 时， 只 有 你 和 目 标（ 如 果 还 活 着） 会 被 带 回 原 来 空 间， 所 有 的 召 唤 物 会 停 留 在 恐 惧 空 间。 
		 当 你 已 处 于 恐 惧 空 间 时， 此 技 能 施 放 无 效 果。 
		 这 个 强 大 的 法 术 每 回 合 消 耗 5 点 活 力（每 回 合 增 加 1 点）， 当 活 力 值 归 零 时 技 能 终 止 。
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.FIRE, self:combatTalentSpellDamage(t, 12, 140)))
	end,
}



return _M
