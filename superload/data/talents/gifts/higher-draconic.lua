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
		此 外， 无 论 你 的 元 素 攻 击 是 否 命 中 敌 人 你 都 会 对 %d 码 半 径 范 围 内 的 生物 造 成 %0.2f 伤 害。 
		五 灵 挥 击 还会 增 加 你 的 物 理、 法 术 和 精 神 速 度 %d%% 。
		如果你装备了盾牌，这一技能也会用你的盾牌攻击。]]):format(100 * self:combatTalentWeaponDamage(t, 1.2, 2.0), radius,burstdamage , 100*speed)
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
		return ([[你 熟 练 掌 握 了 巨 龙 的 本 性。 
		你 的 力 量 和 意 志 增 加 %d 。
		你 获 得 %d%% 击 退 抵 抗 和 %d%% 致 盲、 震 慑 抵 抗。]]):format(t.getStat(self, t), 100*t.resistKnockback(self, t), 100*t.resistBlindStun(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CHROMATIC_FURY",
	name = "天龙之怒",
	info = function(self, t)
		return ([[你 获 得 了 世 界 中 数 不 清 的 龙 的 力 量 传 承 ，你 对 物 理 、火 焰 、寒 冷 、酸 性 、自 然 、枯 萎 和 暗 影 属 性 伤 害 的 抵 抗 力 和 适 应 力 增 强 了 。
		 你 对 这 些 属 性 的  %0.1f%%  ，使 用 这 些 属 性 的 时 候 伤 害 提 升  %0.1f%%  ，获 得  %0.1f%%  伤 害 穿 透 。

		 学 习 这 一 技 能 还 会 给 你 的 吐 息 技 能 伤 害 增 加 意 志 值 加 成 。若 你 的 这 两 项 属 性 相 等 ，则 这 相 当 于 加 成 值 翻 倍 。]]) 
		:format(t.getResists(self, t), t.getDamageIncrease(self, t), t.getResistPen(self, t))
	end,
}


return _M
