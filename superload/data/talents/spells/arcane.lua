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
		return ([[你的身边充满奥术力量，阻止你受到的伤害，并将其改为扣减法力值。
		你受到的25%%的伤害将会被改为扣减法力值，每点伤害扣减%0.2f点法力值。伤害护盾会降低这一消耗。
		当你解除干扰护盾时，你会获得100点法力值，并在你周围产生半径为%d的致命的奥数风暴，持续10回合，每回合造成10%%的吸收的总伤害，共造成%d点伤害。
		当你的法力值不足10%%时，你会自动解除这一技能。
		伤害到魔法的比例受你的法术强度加成。]]):
		format(t.getManaRatio(self, t), radius, damDesc(self, DamageType.ARCANE, t.getMaxDamage(self, t)))
	end,
}


return _M
