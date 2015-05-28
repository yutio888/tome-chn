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
		return ([[使 周 身 围 绕 着 奥 术 能 量， 阻 止 任 何 伤 害 并 回 复 法 力 值。 
		 每 受 到 1 点 伤 害 得 到 %0.2f 点 法 力 值（ 奥 术 护 盾 影 响 此 系 数）。 
		 如 果 你 的 法 力 值 因 为 该 护 盾 而 回 复 过 多， 则 它 会 中 断 并 在 3 码 半 径 范 围 内 释 放 一 股 持 续 10 回 合 的 致 命 奥 术 风 暴， 每 回 合 造 成 10%% 已 吸 收 伤 害 值, 最 多 造 成 共 计 %d 点 伤 害。  
		 当 奥 术 风 暴 激 活 时， 你 同 样 会 增 加 %d%% 奥 术 抵 抗。 
		 只 有 在 法 力 值 低 于 25 ％ 时 方 可 使 用。 
		 受 法 术 强 度 影 响， 每 点 伤 害 可 回 复 更 少 法 力 值。]]):
		format(t.getManaRatio(self, t), t.getMaxDamage(self, t), t.getArcaneResist(self, t))
	end,
}


return _M
