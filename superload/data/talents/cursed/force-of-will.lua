local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WILLFUL_STRIKE",
	name = "偏执打击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local knockback = t.getKnockback(self, t)
		return ([[专 注 你 的 仇 恨， 你 用 无 形 的 力 量 打 击 敌 人 造 成 %d 点 伤 害 和 %d 码 击 退 效 果。 
		 此 外， 你 灌 注 力 量 的 能 力 使 你 增 加 %d%% 所 有 暴 击 伤 害。（ 当 前： %d%% ） 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.PHYSICAL, damage), knockback, t.critpower(self, t), self.combat_critical_power or 0)
	end,
}

registerTalentTranslation{
	id = "T_DEFLECTION",
	name = "念力折射",
	info = function(self, t)
		local maxDamage = t.getMaxDamage(self, t)
		local recharge_rate = t.getRechargeRate(self, t)
		return ([[用 你 的 意 志 力 折 射 50%% 的 伤 害。 你 可 以 折 射 最 多 %d 点 伤 害， 护 盾 值 每 回 合 回 复 最 大 值 的 1/%d 。（ 技 能 激 活 时 -0.2 仇 恨 值 回 复）。 
		 你 灌 注 力 量 的 能 力 使 你 增 加 %d%% 所 有 暴 击 伤 害。（ 当 前： %d%% ） 
		 受 精 神 强 度 影 响， 最 大 伤 害 折 射 值 有 额 外 加 成。]]):format(maxDamage, recharge_rate, t.critpower(self, t),self.combat_critical_power or 0)
	end,
}

registerTalentTranslation{
	id = "T_BLAST",
	name = "怒火爆炸",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		local knockback = t.getKnockback(self, t)
		local dazeDuration = t.getDazeDuration(self, t)
		return ([[你 将 愤 怒 聚 集 在 一 点， 然 后 向 %d 码 范 围 内 所 有 方 向 炸 开。 爆 炸 造 成 %d 点 伤 害， 在 中 心 点 处 造 成 %d 码 击 退 效 果， 距 离 越 远 效 果 越 弱。 
		 在 爆 炸 范 围 内 的 任 何 目 标 将 会 被 眩 晕 3 回 合。 
		 你 灌 注 力 量 的 能 力 使 你 每 点 增 加 %d%% 所 有 暴 击 伤 害。（ 当 前： %d%% ） 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(radius, damDesc(self, DamageType.PHYSICAL, damage), knockback, t.critpower(self, t), self.combat_critical_power or 0)
	end,
}

registerTalentTranslation{
	id = "T_UNSEEN_FORCE",
	name = "怒意鞭笞",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		local knockback = t.getKnockback(self, t)
		local secondHitChance = t.getSecondHitChance(self, t)
		local hits = 1 + math.floor(secondHitChance/100)
		local chance = secondHitChance - math.floor(secondHitChance/100)*100
		return ([[你 的 愤 怒 变 成 一 股 无 形 之 力， 猛 烈 鞭 笞 你 附 近 的 随 机 敌 人。在 %d 回 合 内， 你 将 攻 击 %d （ %d%% 概 率 攻 击 %d ） 个 半 径 5  以 内 的 敌 人， 造 成 %d 点 伤 害 并 击 退 %d 码。 额 外 攻 击 的 数 目 随 技 能 等 级 增 长。 
		 你 灌 注 力 量 的 能 力 使 你 增 加 %d%% 所 有 暴 击 伤 害。（ 当 前： %d%% ） 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(duration, hits, chance, hits+1, damDesc(self, DamageType.PHYSICAL, damage), knockback, t.critpower(self, t), self.combat_critical_power or 0)
	end,
}



return _M
