local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_BOW_MASTERY",
	name = "弓术专精",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		local reloads = t.ammo_mastery_reload(self, t)
		return ([[提 高 %d 物 理 强 度。 同 时 增 加 %d%% 弓 箭 伤 害。 
		同 时 ， 增 加 % d 装 填 效 果。]]):format(damage, inc * 100, reloads)
	end,
}

registerTalentTranslation{
	id = "T_PIERCING_ARROW",
	name = "穿透箭",
	info = function(self, t)
		return ([[你 射 出 一 支 能 穿 透 任 何 东 西 的 箭， 可 以 穿 透 多 个 目 标 并 对 目 标 造 成 %d%% 无 视 护 甲 的 穿 透 伤 害。]]):format(100 * self:combatTalentWeaponDamage(t, 1, 1.5))
	end,
}

registerTalentTranslation{
	id = "T_DUAL_ARROWS",
	name = "双重射击",
	info = function(self, t)
		return ([[你 向 目 标 同 时 射 出 2 支 箭， 对 目 标 及 其 周 围 的 一 个 敌 人 造 成 %d%% 伤 害。 
		此 技 能 不 消 耗 体 力 值。 ]]):format(100 * self:combatTalentWeaponDamage(t, 1.2, 1.9))
	end,
}

registerTalentTranslation{
	id = "T_VOLLEY_OF_ARROWS",
	name = "箭雨",
	info = function(self, t)
		return ([[你 向 %d 码 半 径 区 域 内 射 出 多 支 箭， 每 只 箭 造 成 %d%% 伤 害。 ]])
		:format(self:getTalentRadius(t), 100 * self:combatTalentWeaponDamage(t, 0.6, 1.3))
	end,
}


return _M
