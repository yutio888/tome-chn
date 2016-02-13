local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DREAM_HAMMER",
	name = "梦之巨锤",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local weapon_damage = useDreamHammer(self).dam
		local weapon_range = useDreamHammer(self).dam * useDreamHammer(self).damrange
		local weapon_atk = useDreamHammer(self).atk
		local weapon_apr = useDreamHammer(self).apr
		local weapon_crit = useDreamHammer(self).physcrit
		return ([[在 梦 境 熔 炉 中 将 武 器 锻 造 成 一 柄 巨 锤 砸 向 附 近 某 个 目 标， 造 成 %d%% 武 器 伤 害。 如 果 攻 击 命 中， 它 会 使 梦 境 锻 造 系 的 某 个 随 机 技 能 冷 却 完 毕。 
		 在 等 级 5 时， 此 技 能 会 使 2 个 随 机 技 能 冷 却 完 毕。 
		 受 精 神 强 度 影 响， 武 器 的 基 础 攻 击 力、 命 中、 护 甲 穿 透 和 暴 击 率 按 比 例 加 成。 

		 当 前 梦 之 巨 锤 属 性： 
		 攻 击 力 : %0.2f - %0.2f
		 加 成 属 性 : 120 ％ 意 志 
		 伤 害 类 型 : 物 理 
		 此 武 器 的 命 中 率 基 于 意 志 计 算。 
		 命 中 加 成 : +%d
		 护 甲 穿 透 : +%d
		 物 理 暴 击 率 : +%d]]):format(damage * 100, weapon_damage, weapon_range, weapon_atk, weapon_apr, weapon_crit)
	end,
}

registerTalentTranslation{
	id = "T_HAMMER_TOSS",
	name = "回旋投掷",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local attack_bonus = t.getAttack(self, t)
		return ([[将 你 的 梦 之 巨 锤 扔 向 远 处， 对 沿 途 所 有 敌 方 单 位 造 成 %d%% 武 器 伤 害。 在 到 达 目 标 点 后， 梦 之 巨 锤 会 自 动 返 回， 再 次 对 沿 途 目 标 造 成 伤 害。 
		 学 习 此 技 能 会 增 加 梦 之 巨 锤 %d 点 命 中。]]):format(damage * 100, attack_bonus)
	end,
}

registerTalentTranslation{
	id = "T_DREAM_CRUSHER",
	name = "雷霆一击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local power = t.getMasteryDamage(self, t)
		local percent = t.getPercentInc(self, t)
		local stun = t.getStun(self, t)		
		return ([[用 你 的 梦 之 巨 锤 碾 碎 敌 人， 造 成 %d%% 武 器 伤 害。 如 果 攻 击 命 中， 则 目 标 会 被 震 慑 %d 回 合。 
		 受 精 神 强 度 影 响， 震 慑 几 率 有 额 外 加 成。 
		 学 习 此 技 能 会 增 加 %d 点 你 使 用 梦 之 巨 锤 时 的 物 理 强 度， 同 时 使 梦 之 巨 锤 造 成 的 所 有 伤 害 提 升 %d%% 。]]):format(damage * 100, stun, power, percent * 100)
	end,
}

registerTalentTranslation{
	id = "T_FORGE_ECHOES",
	name = "回音击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local project = t.getProject(self, t) /2
		return ([[用 梦 之 巨 锤 对 目 标 挥 出 强 力 的 一 击， 造 成 %d%% 武 器 伤 害。 如 果 攻 击 命 中， 挥 击 所 产 生 的 回 音 会 伤 害 %d 码 范 围 内 的 所 有 目 标。 
		 学 习 此 技 能 会 使 你 的 梦 之 巨 锤 附 加 %0.2f 精 神 伤 害 和 %0.2f 燃 烧 伤 害。 
		 受 精 神 强 度 影 响， 梦 之 巨 锤 附 加 的 精 神 伤 害 和 燃 烧 伤 害 按 比 例 加 成。]]):format(damage * 100, radius, damDesc(self, DamageType.MIND, project), damDesc(self, DamageType.FIRE, project))
	end,
}


return _M
