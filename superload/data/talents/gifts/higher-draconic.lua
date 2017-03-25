local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_PRISMATIC_SLASH",
	name = "五灵挥击",
	info = function(self, t)
		local burstdamage = t.getBurstDamage(self, t)
		local radius = self:getTalentRadius(t)
		local speed = t.getPassiveSpeed(self, t)
		return ([[向 你 的 敌 人 释 放 原 始 的 混 乱 元 素 攻 击。 
		 你 有 几 率 使 用 致 盲 之 沙、 缴 械 酸 雾、 冰 结 之 息、 震 慑 闪 电 或 燃 烧 之 焰 攻 击 敌 人， 造 成 %d%% 点 对 应 伤 害 类 型 的 武 器 伤 害。 
		 此 外， 无 论 你 的 元 素 攻 击 是 否 命 中 敌 人 你 都 会 对 %d 码 半 径 范 围 内 的 敌 人 造 成 %0.2f 伤 害。 
		 每 提 升 1 级 五 灵 挥 击 会 增 加 你 的 物 理、 法 术 和 精 神 速 度 %d%% 。]]):format(100 * self:combatTalentWeaponDamage(t, 1.2, 2.0), radius,burstdamage , 100*speed)
	end,
}

registerTalentTranslation{
	id = "T_VENOMOUS_BREATH",
	name = "剧毒吐息",
	info = function(self, t)
		local effect = t.getEffect(self, t)
		return ([[你 向 %d 码 锥 形 半 径 范 围 的 敌 人 释 放 剧 毒 吐 息。 在 攻 击 范 围 内 的 敌 人， 每 回 合 会 受 到 %0.2f 自 然 伤 害， 持 续 6 回 合。 
		 剧 毒 令 目 标 有 %d%% 几 率 行 动 失 败。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成； 技 能 暴 击 率 基 于 精 神 暴 击 值 计 算。 
		 每 提 升 1 级 剧 毒 吐 息 同 样 增 加 你 4 ％ 自 然 抵 抗。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.NATURE, t.getDamage(self,t)/6), effect)
	end,
}

registerTalentTranslation{
	id = "T_WYRMIC_GUILE",
	name = "龙之狡诈",
	info = function(self, t)
		return ([[你 继 承 了 龙 族 的 狡 诈。 
		 你 的 灵 巧 增 加 %d 点， 同 时 你 的 吐 息 技 能 冷 却 减 少 %d 。 
		 你 获 得 %d%% 击 退 抵 抗 和 %d%% 致 盲、 震 慑 抵 抗。]]):format(2*self:getTalentLevelRaw(t), t.CDreduce(self, t), 100*t.resistKnockback(self, t), 100*t.resistBlindStun(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CHROMATIC_FURY",
	name = "天龙之怒",
	info = function(self, t)
		return ([[你 获 得 了 七 彩 巨 龙 的 传 承， 并 且 你 对 元 素 的 掌 控 达 到 了 新 的 高 峰。 
		 增 加 %0.1f%% 物 理、 火 焰、 寒 冷、 闪 电 和 酸 性 抗 性，增 加 %0.1f%% 相 应 伤 害 与 %d%% 对 应 抵 抗 穿 透。]]) 
		:format(t.getResists(self, t), t.getDamageIncrease(self, t), t.getResistPen(self, t))
	end,
}


return _M
