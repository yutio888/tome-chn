local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ARCANE_POWER",
	name = "奥术能量",
	info = function(self, t)
		local resist = self.sustain_talents[t.id] and self.sustain_talents[t.id].display_resist or t.getArcaneResist(self, t)
		return ([[你 对 魔 法 的 理 解 使 你 进 入 精 神 集 中 状 态， 增 加 %d 点 法 术 强 度 和 %d%% 奥 术 抗 性 。]]):
		format(t.getSpellpowerIncrease(self, t), resist)
	end,
}

registerTalentTranslation{
	id = "T_MANATHRUST",
	name = "奥术射线",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[制 造 出 一 个 强 大 的 奥 术 之 球 对 目 标 造 成 %0.2f 奥 术 伤 害。 
		 在 等 级 3 时， 它 会 有 穿 透 效 果。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.ARCANE, damage))
	end,
}

registerTalentTranslation{
	id = "T_ARCANE_VORTEX",
	name = "奥术漩涡",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[在 目 标 身 上 放 置 一 个 持 续 6 回 合 的 奥 术 漩 涡。 
		 每 回 合， 奥 术 漩 涡 会 随 机 寻 找 视 野 内 的 另 一 个 敌 人， 并 且 释 放 一 次 奥 术 射 线， 对 一 条 线 上 的 所 有 敌 人 造 成 %0.2f 奥 术 伤 害。 
		 若 没 有 发 现 其 他 敌 人， 则 目 标 会 承 受 150 ％ 额 外 奥 术 伤 害。 
		 若 目 标 死 亡， 则 奥 术 漩 涡 爆 炸 并 释 放 所 有 的 剩 余 奥 术 伤 害， 在 2 码 半 径 范 围 内 形 成 奥 术 爆 炸。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.ARCANE, dam))
	end,
}

registerTalentTranslation{
	id = "T_DISRUPTION_SHIELD",
	name = "干扰护盾",
	info = function(self, t)
		local radius = self:hasEffect(self.EFF_AETHER_AVATAR) and 10 or 3
		return ([[你 的 身 边 充 满 奥 术 力 量 ，阻 止 你 受 到 的 伤 害 ，并 将 其 改 为 扣 减 法 力 值 。
		 你 受 到 的 伤 害 的  25%%  将 会 被 改 为 扣 减 法 力 值 ，每 点 伤 害 扣 减  %0.2f  点 法 力 值 。伤 害 护 盾 会 降 低 这 一 消 耗 。
		 当 你 解 除 干 扰 护 盾 时 ，你 会 获 得  100  点 法 力 值 ，并 在 你 周 围 产 生 半 径 为  %d  的 致 命 的 奥 数 风 暴 ，持 续  10  回 合 ，每 回 合 造 成  10%%  的 吸 收 的 总 伤 害 ，共 造 成  %d  点 伤 害 。
		 当 你 的 法 力 值 不 足  10%%  时 ，你 会 自 动 解 除 这 一 技 能 。
		 伤 害 到 魔 法 的 比 例 受 你 的 法 术 强 度 加 成 。]]):
		format(t.getManaRatio(self, t), radius, damDesc(self, DamageType.ARCANE, t.getMaxDamage(self, t)))
	end,
}


return _M
