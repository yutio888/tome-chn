local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SLING_MASTERY",
	name = "投石索专精",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		local reloads = t.ammo_mastery_reload(self, t)
		return ([[提 高 %d 点 物 理 强 度。 同 时 提 高 %d%% 投 石 索 伤 害。 
		同 时 增 加 %d 装 填 效 果 。]]):format(damage, inc * 100, reloads)
	end,
}

registerTalentTranslation{
	id = "T_EYE_SHOT",
	name = "致盲射击",
	info = function(self, t)
		return ([[你 对 目 标 的 眼 睛 射 出 一 发 子 弹， 致 盲 目 标 %d 回 合 并 造 成 %d%% 伤 害。 
		受 命 中 影 响， 致 盲 概 率 有 额 外 加 成。]])
		:format(t.getBlindDur(self, t),	100 * self:combatTalentWeaponDamage(t, 1, 1.5))
	end,
}

registerTalentTranslation{
	id = "T_INERTIAL_SHOT",
	name = "惯性射击",
	info = function(self, t)
		return ([[你 射 出 一 发 强 力 的 子 弹， 对 目 标 造 成 %d%% 伤 害 并 击 退 目 标。 
		受 命 中 影 响， 击 退 概 率 有 额 外 加 成。]]):format(100 * self:combatTalentWeaponDamage(t, 1, 1.5))
	end,
}

registerTalentTranslation{
	id = "T_MULTISHOT",
	name = "多重射击",
	info = function(self, t)
		return ([[你 向 目 标 射 出 平 均 %0.1f 子 弹， 每 发 子 弹 造 成 %d%% 伤 害。 ]]):format(t.getShots(self, t, true), 100 * self:combatTalentWeaponDamage(t, 0.3, 0.7))
	end,
}


return _M
