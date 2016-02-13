local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ACIDIC_SPRAY",
	name = "酸雾喷射",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[向 你 的 敌 人 喷 出 一 团 酸 雾。 
		 目 标 会 受 到 %0.2f 点 基 于 精 神 强 度 的 酸 性 伤 害。 
		 受 到 攻 击 的 敌 人 有 25 ％ 几 率 被 缴 械 3 回 合， 因 为 酸 雾 将 他 们 的 武 器 给 腐 蚀 了。 
		 在 等 级 5 时， 这 团 酸 雾 可 以 穿 透 一 条 线 上 的 敌 人。 
		 每 点 技 能 等 级 增 加 精 神 强 度 4 点。
		 每 一 点 毒 龙 系 技 能 同 时 也 能 增 加 你 的 酸 性 抵 抗 1%% 。]]):format(damDesc(self, DamageType.ACID, damage))
	end,
}

registerTalentTranslation{
	id = "T_CORROSIVE_MIST",
	name = "腐蚀酸雾",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local cordur = t.getCorrodeDur(self, t)
		local atk = t.getAtk(self, t)
		local radius = self:getTalentRadius(t)
		return ([[吐 出 一 股 浓 厚 的 酸 雾， 每 回 合 造 成 %0.2f 酸 性 伤 害， 范 围 为 %d 码 半 径， 持 续 %d 回 合。 
		 在 这 团 酸 雾 里 的 敌 人 会 被 腐 蚀， 持 续 %d 回 合， 降 低 他 们 %d 点 命 中、 护 甲 和 闪 避。 
		 受 精 神 强 度 影 响， 伤 害 和 持 续 时 间 有 额 外 加 成； 受 技 能 等 级 影 响， 范 围 有 额 外 加 成。 
		 每 一 点 毒 龙 系 技 能 同 时 也 能 增 加 你 的 酸 性 抵 抗 1%% 。]]):format(damDesc(self, DamageType.ACID, damage), radius, duration, cordur, atk)
	end,
}

registerTalentTranslation{
	id = "T_DISSOLVE",
	name = "腐蚀连击",
	info = function(self, t)
		return ([[你 对 敌 人 挥 出 暴 风 般 的 酸 性 攻 击。 你 对 敌 人 造 成 四 次 酸 性 伤 害。 每 击 造 成 %d%% 点 伤 害。 
		 每 拥 有 2 个 天 赋 等 级， 你 的 其 中 一 次 攻 击 就 会 成 附 带 致 盲 的 酸 性 攻 击， 若 击 中 则 有 25%% 几 率 致 盲 目 标。
		 每 一 点 毒 龙 系 技 能 同 时 也 能 增 加 你 的 酸 性 抵 抗 1%% 。]]):format(100 * self:combatTalentWeaponDamage(t, 0.1, 0.6))
	end,
}

registerTalentTranslation{
	id = "T_CORROSIVE_BREATH",
	name = "腐蚀吐息",
	info = function(self, t)
		local disarm = t.getDisarm(self, t)
		return ([[向 前 方 %d 码 范 围 施 放 一 个 锥 形 酸 雾 吐 息， 范 围 内 所 有 目 标 受 到 %0.2f 酸 性 伤 害， 并 有 %d%% 几 率 被 缴 械 3 回 合。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成。 
		 技 能 暴 击 率 基 于 精 神 暴 击 值 计 算。
		 每 一 点 毒 龙 系 技 能 同 时 也 能 增 加 你 的 酸 性 抵 抗 1%% 。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.ACID, self:combatTalentStatDamage(t, "str", 30, 520)), disarm)
	end,
}


return _M
