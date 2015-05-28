local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RAMPAGE",
	name = "暴走",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local maxDuration = t.getMaxDuration(self, t)
		local movementSpeedChange = t.getMovementSpeedChange(self, t)
		local combatPhysSpeedChange = t.getCombatPhysSpeedChange(self, t)
		return ([[你 进 入 暴 走 状 态 %d 回 合（ 最 多 %d 回 合）， 摧 毁 在 你 路 径 上 的 所 有 东 西， 该 技 能 瞬 发， 同 时 也 有 较 小 几 率 在 你 受 到 8%% 最 大 生 命 值 以 上 的 伤 害 时 自 动 激 活。 暴 走 状 态 下 你 使 用 任 何 技 能、 符 文 或 纹 身 都 无 法 专 心 使 得 技 能 效 果 持 续 时 间 缩 短 1 回 合， 暴 走 状 态 下 的 第 一 次 移 动 可 延 长 暴 走 效 果 1 回 合。 
		 暴 走 加 成： +%d%% 移 动 速 度。 
		 暴 走 加 成： +%d%% 攻 击 速 度。]]):format(duration, maxDuration, movementSpeedChange * 100, combatPhysSpeedChange * 100)
	end,
}

registerTalentTranslation{
	id = "T_BRUTALITY",
	name = "无情",
	info = function(self, t)
		local physicalDamageChange = t.getPhysicalDamageChange(self, t)
		local combatPhysResistChange = t.getCombatPhysResistChange(self, t)
		local combatMentalResistChange = t.getCombatMentalResistChange(self, t)
		return ([[使 你 的 暴 走 更 加 无 情， 暴 走 状 态 下 的 第 一 次 暴 击 可 延 长 暴 走 效 果 1 回 合。 
		 暴 走 加 成： 你 的 物 理 伤 害 增 加 %d%% 。 
		 暴 走 加 成： 你 的 物 理 豁 免 增 加 %d ， 精 神 豁 免 增 加 %d 。]]):format(physicalDamageChange, combatPhysResistChange, combatMentalResistChange)
	end,
}

registerTalentTranslation{
	id = "T_TENACITY",
	name = "不屈不挠",
	info = function(self, t)
		local damageShield = t.getDamageShield(self, t)
		local damageShieldBonus = t.getDamageShieldBonus(self, t)
		return ([[你 的 暴 走 变 得 势 不 可 挡。 
		 暴 走 加 成： 暴 走 状 态 下 每 回 合 你 最 多 可 以 无 视 %d 伤 害， 当 你 无 视 超 过 %d 伤 害 时， 暴 走 效 果 延 长 1 回 合。 
		 受 力 量 加 成， 你 无 视 的 伤 害 有 额 外 加 成。]]):format(damageShield, damageShieldBonus)
	end,
}

registerTalentTranslation{
	id = "T_SLAM",
	name = "猛力抨击",
	info = function(self, t)
		local hitCount = t.getHitCount(self, t)
		local stunDuration = t.getStunDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[暴 走 状 态 中， 你 可 以 攻 击 到 最 多 %d 个 邻 近 目 标， 震 慑 他 们 %d 回 合， 并 造 成 %d ～ %d 物 理 伤 害， 首 次 同 时 对 两 个 以 上 目 标 造 成 的 攻 击 可 以 延 长 暴 走 效 果 1 回 合。 
		 受 物 理 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(hitCount, stunDuration, damage * 0.5, damage)
	end,
}



return _M
