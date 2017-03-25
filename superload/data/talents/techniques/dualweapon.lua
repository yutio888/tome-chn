local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DUAL_WEAPON_TRAINING",
	name = "双持专精",
	info = function(self, t)
		return ([[副 手 武 器 伤 害 增 加 至 %d%% 。]]):format(100 * t.getoffmult(self,t))
	end,
}

registerTalentTranslation{
	id = "T_DUAL_WEAPON_DEFENSE",
	name = "抵挡训练",
	info = function(self, t)
		return ([[你 已 经 学 会 用 你 的 武 器 招 架 攻 击。 当 你 双 持 时， 增 加 %d 点 近 身 闪 避。
		每 回 合 最 多 %0.1f 次，你 有 %d%% 概 率 抵 挡 至 多 %d 点 伤 害 （基 于 副 手 伤 害  ）。 
		抵 挡 的 减 伤 类 似 护 甲 ，且 被 抵 挡 的 攻 击 不 会 暴 击。 很 难 抵 挡 未 发 现 的 敌 人 的 攻 击 ， 且 不 能 使 用 灵 晶 抵 挡 攻 击 。
		受 敏 捷 影 响， 闪 避 增 益 按 比 例 加 成。 
		受 灵 巧 影 响， 抵 挡 次 数 有 额 外 加 成。
		]]):format(t.getDefense(self, t), t.getDeflects(self, t, true), t.getDeflectChance(self,t), t.getDamageChange(self, t, true))
	end,
}

registerTalentTranslation{
	id = "T_CLOSE_COMBAT_MANAGEMENT",
	name = "近战训练",
	info = function (self,t)
		return ([[你 近 战 格 斗 的 技 巧 更 加 精 湛 了。
		用 双 持 武 器 命 中 对 手 时， 你 每 命 中 一 个 敌 人 获 得 %d 伤 害 减 免 （受 敏 捷 加 成，灵 晶 无 效）。
		此 外， 该 技 能 开 启 时 ，你 能 反 弹 %d%% 伤 害。]]):
		format(t.getReflectArmour(self, t), t.getPercent(self, t))
	end,
}

registerTalentTranslation{
	id = "T_OFFHAND_JAB",
	name = "副手猛击",
	info = function (self,t)
		local dam = 100 * t.getDamage(self, t)
		return ([[你 迅 速 移 动 ，用 徒 手 攻 击 敌 人。
		造 成 %d%% 主 手 武 器 伤 害 ，%d%% 徒 手 伤 害 。
		若 徒 手 攻 击 命 中 ， 敌 人 将 被 混 乱 （ %d%% 强 度 ） %d 回 合 。
		混 乱 几 率 受 命 中 加 成 。]])
		:format(dam, dam*1.25, t.getConfusePower(self, t), t.getConfuseDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DUAL_STRIKE",
	name = "双持打击",
	info = function(self, t)
		return ([[用 副 手 武 器 造 成 %d%% 伤 害。 
		如 果 攻 击 命 中， 目 标 将 会 被 震 慑 %d 回 合 并 且 你 会 使 用 主 武 器 对 目 标 造 成 %d%% 伤 害。 
		受 命 中 影 响， 震 慑 概 率 有 额 外 加 成。 ]])
		:format(100 * self:combatTalentWeaponDamage(t, 0.7, 1.5), t.getStunDuration(self, t), 100 * self:combatTalentWeaponDamage(t, 0.7, 1.5))
	end,
}

registerTalentTranslation{
	id = "T_FLURRY",
	name = "疾风连刺",
	info = function(self, t)
		return ([[对 目 标 进 行 快 速 的 连 刺， 每 把 武 器 进 行 3 次 打 击， 每 次 打 击 造 成 %d%% 的 伤 害。]]):format(100 * self:combatTalentWeaponDamage(t, 0.4, 1.0))
	end,
}
registerTalentTranslation{
	id = "T_HEARTSEEKER",
	name = "追心刺",
	info = function(self, t)
		dam = t.getDamage(self,t)*100
		crit = t.getCrit(self,t)
		return ([[迅 速 跃 向 目 标 ， 用 双 手 武 器 发 动 一 次 强 力 的 突 刺 攻 击 ， 造 成 %d%% 武 器 伤 害 ， 该 次 攻 击 暴 击 伤 害 系 数 增 加 %d%% 。]]):
		format(dam, crit)
	end,
}	
registerTalentTranslation{
	id = "T_SWEEP",
	name = "拔刀斩",
	info = function(self, t)
		return ([[对 你 正 前 方 锥 形 范 围 的 敌 人 造 成 %d%% 武 器 伤 害 并 使 目 标 进 入 流 血 状 态， 每 回 合 造 成 %d 点 伤 害， 持 续 %d 回 合。
		 受 主 手 武 器 伤 害 和 敏 捷 影 响， 流 血 伤 害 有 额 外 加 成。 ]]):
		format(100 * self:combatTalentWeaponDamage(t, 1, 1.7), damDesc(self, DamageType.PHYSICAL, t.cutPower(self, t)), t.cutdur(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WHIRLWIND",
	name = "旋风斩",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local range = self:getTalentRange(t)
		return ([[你 迅 速 跳 跃 至 %d 格 内 的 敌 人 身 边 并 在 移 动 中 用 2 把 武 器 对 路 径 周 围 的 所 有 敌 人 造 成 %d%% 伤 害，并 使 其 流 血 5 回 合 受 到 额 外 50%% 伤 害 。]]):
		format(range, damage*100)
	end,
}


return _M
