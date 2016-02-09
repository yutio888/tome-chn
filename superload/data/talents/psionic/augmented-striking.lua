local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_KINETIC_STRIKE",
	name = "动能打击",
	info = function(self, t)
		return ([[聚 焦 动 能 打 击 敌 人 造 成 %d%% 武 器 伤 害 
		敌 人 将 被 这 次 攻 击 的 力 量 定 身 %d 回 合 。
		任 何 处 于 冻 结 状 态 的 目 标 受 到 额 外 %0.2f 物 理 伤 害。
		额 外 伤 害 受 精 神 强 度 加 成 。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 2.0), t.getDur(self, t), damDesc(self, DamageType.PHYSICAL, t.getDam(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_THERMAL_STRIKE",
	name = "热能打击",
	info = function(self, t)
		return ([[聚 焦 热 能 打 击 敌 人 造 成 %d%% 寒 冷 武 器 伤 害 .
		之 后，一 股 寒 冰 能 量 将 爆 发 并 吞 噬 他 们 ，造 成 额 外 %0.1f 寒 冷 伤 害 并 冻 结 他 们 %d 回 合 。
		如 果 被 冻 结 的 目 标 已 经 被 定 身 ， 则 会 在 周 围 爆 发 寒 冰 能 量 ， 组 成 冰 墙 ，持 续 3 回 合。
		爆 发 的 寒 冷 伤 害 受 精 神 强 度 加 成 .]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 2.0), damDesc(self, DamageType.COLD, t.getDam(self, t)), t.getDur(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CHARGED_STRIKE",
	name = "电能打击",
	info = function(self, t)
		return ([[聚 焦 充 能 打 击 敌 人 造 成 %d%% 闪 电 武 器 伤 害 。
		之 后 ，从 武 器 释 放 一 股 能 量 ，造 成 额 外 %0.2f  闪 电 伤 害 并 减 半 他 们 的 震 慑 和 定 身 免 疫 %d 回 合 
		如 果 电 能 护 盾 开 启 ， 并 且 目 标 已 被 定 身 ， 则 护 盾 吸 收 量 增 加 %0.2f.
		如 果 目 标 被 冻 结，冰 块 会 粉 碎 ， 击 退 半 径 2 以 内 的 所 有 生 物。
		释 放 的 伤 害 受 精 神 强 度 加 成 .]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 2.0), damDesc(self, DamageType.LIGHTNING, t.getDam(self, t)), t.getDur(self, t), 1.5 * damDesc(self, DamageType.LIGHTNING, t.getDam(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_PSI_TAP",
	name = "能量吸取",
	info = function(self, t)
		return ([[用 灵 能 强 化 武 器 ， 获 得 %d 护 甲 穿 透，同 时 吸 取 每 次 武 器 攻 击 中 剩 余 的 的 能 量 ，每 次 武 器 命 中 时 获 得 %0.1f  点 超 能 力 值。]]):format(t.getPsiRecover(self, t)*3, t.getPsiRecover(self, t))
	end,
}


return _M
