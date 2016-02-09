local _M = loadPrevious(...)

registerTalentTranslation{
    id = "T_REND",
    name = "撕裂",
	info = function(self, t)
		return ([[向 目 标 挥 舞 2 把 武 器， 每 次 攻 击 造 成 %d%% 伤 害。 每 次 攻 击 会 使 目 标 流 血， 每 回 合 造 成 %0.2f 伤 害， 持 续 5 回 合。 
		 受 法 术 强 度 影 响， 流 血 效 果 有 额 外 加 成。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.8, 1.6), self:combatTalentSpellDamage(t, 5, 40))
	end,
}

registerTalentTranslation{
    id = "T_RUIN",
    name = "毁伤",
	info = function(self, t)
		local dam = damDesc(self, DamageType.BLIGHT, t.getDamage(self, t))
		return ([[专 注 于 你 带 来 的 瘟 疫， 每 次 近 战 攻 击 会 造 成 %0.2f 枯 萎 伤 害（ 同 时 每 击 恢 复 你 %0.2f 生 命 值）。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(dam, dam * 0.4)
	end,
}

registerTalentTranslation{
    id = "T_ACID_STRIKE",
    name = "酸性打击",
	info = function(self, t)
		return ([[用 每 把 武 器 打 击 目 标， 每 次 攻 击 造 成 %d%% 酸 性 武 器 伤 害。 
		 如 果 有 至 少 一 次 攻 击 命 中 目 标， 则 会 产 生 酸 系 溅 射， 对 临 近 目 标 的 敌 人 造 成 %0.2f 酸 性 伤 害。 
		 受 法 术 强 度 影 响， 溅 射 伤 害 有 额 外 加 成。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.8, 1.6), damDesc(self, DamageType.ACID, self:combatTalentSpellDamage(t, 10, 130)))
	end,
}

registerTalentTranslation{
    id = "T_DARK_SURPRISE",
    name = "黑暗连击",
	info = function(self, t)
		return ([[用 你 的 主 武 器 打 击 目 标 并 造 成 %d%% 暗 影 武 器 伤 害。 
		 如 果 主 武 器 命 中， 则 你 会 使 用 副 武 器 打 击 目 标 并 造 成 %d%% 枯 萎 武 器 伤 害， 此 次 攻 击 必 定 暴 击。 
		 如 果 副 武 器 命 中， 则 目 标 会 被 致 盲 4 回 合。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.6, 1.4), 100 * self:combatTalentWeaponDamage(t, 0.6, 1.4))
	end,
}


return _M
