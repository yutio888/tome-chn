local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SLING_MASTERY",
	name = "投石索专精",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		local reloads = t.ammo_mastery_reload(self, t)
		return ([[使用投石索时提高 %d%% 武器伤害，获得 30 物理强度。
		同时增加 %d 装填效果。]]):format(inc * 100, reloads)
	end,
}

registerTalentTranslation{
	id = "T_EYE_SHOT",
	name = "致盲射击",
	info = function(self, t)
		return ([[你对目标的眼睛射出一发子弹，致盲目标 %d 回合并造成 %d%% 伤害。 
		受命中影响，致盲概率有额外加成。]])
		:format(t.getBlindDur(self, t),	100 * self:combatTalentWeaponDamage(t, 1, 1.5))
	end,
}

registerTalentTranslation{
	id = "T_INERTIAL_SHOT",
	name = "惯性射击",
	info = function(self, t)
		return ([[你射出一发强力的子弹，对目标造成 %d%% 伤害并击退目标。 
		受命中影响，击退概率有额外加成。]]):format(100 * self:combatTalentWeaponDamage(t, 1, 1.5))
	end,
}

registerTalentTranslation{
	id = "T_MULTISHOT",
	name = "多重射击",
	info = function(self, t)
		return ([[你向目标射出平均 %0.1f 子弹，每发子弹造成 %d%% 伤害。 ]]):format(t.getShots(self, t, true), 100 * self:combatTalentWeaponDamage(t, 0.3, 0.7))
	end,
}


return _M
