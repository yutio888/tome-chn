local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_BOW_MASTERY",
	name = "弓术专精",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		local reloads = t.ammo_mastery_reload(self, t)
		return ([[当使用弓时，增加 %d%% 弓箭伤害，提高 30 物理强度。
		同时，增加 %d 装填效果。]]):format(inc * 100, reloads)
	end,
}

registerTalentTranslation{
	id = "T_PIERCING_ARROW",
	name = "穿透箭",
	info = function(self, t)
		return ([[你射出一支能穿透任何东西的箭，可以穿透多个目标并对目标造成 %d%% 无视护甲的穿透伤害。]]):format(100 * self:combatTalentWeaponDamage(t, 1, 1.5))
	end,
}

registerTalentTranslation{
	id = "T_DUAL_ARROWS",
	name = "双重射击",
	info = function(self, t)
		return ([[你向目标同时射出 2 支箭，对目标及其周围的一个敌人造成 %d%% 伤害。 
		此技能不消耗体力值。 ]]):format(100 * self:combatTalentWeaponDamage(t, 1.2, 1.9))
	end,
}

registerTalentTranslation{
	id = "T_VOLLEY_OF_ARROWS",
	name = "箭雨",
	info = function(self, t)
		return ([[你向 %d 码半径区域内射出多支箭，每只箭造成 %d%% 伤害。 ]])
		:format(self:getTalentRadius(t), 100 * self:combatTalentWeaponDamage(t, 0.6, 1.3))
	end,
}


return _M
