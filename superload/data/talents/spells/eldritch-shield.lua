local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ELDRITCH_BLOW",
	name = "奥术盾击",
	info = function(self, t)
		return ([[调用奥术能量，激发近战攻击，使用武器和盾牌攻击目标造成 %d%% 奥术武器伤害。
		只要有一次命中，将震慑目标 %d 回合，并且你会进入格挡状态。
		由于这次攻击视为魔法攻击，震慑成功率由己方物理强度和目标法术豁免（非物理豁免）决定。
		伤害受法术强度加成。]])
		:format(100 * self:combatTalentWeaponDamage(t, 0.6, (100 + self:combatTalentSpellDamage(t, 50, 300)) / 100), t.getDuration(self, t))
	end,
}

  
registerTalentTranslation{
	id = "T_ELDRITCH_INFUSION",
	name = "奥术充能",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[用奥术能量给盾牌冲能，每次近战攻击附加 %0.1f 奥术伤害，同时每次受到近战攻击时反击 %0.1f 点奥术伤害。
		当你不完全格挡时，也可以进行反击。格挡技能的冷却时间降低 %d 回合。
		伤害受法术强度加成。]]):
		format(damDesc(self, DamageType.ARCANE, dam), damDesc(self, DamageType.ARCANE, dam * 0.7), t.getBlockCD(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ELDRITCH_FURY",
	name = "奥术连击",
	info = function(self, t)
		return ([[调用奥术能量，激发近战攻击，用盾牌攻击目标三次，造成 %d%% 自然武器伤害。
		只要有一次命中，将眩晕目标 %d 回合，你的格挡技能冷却将会被重置。
		由于这次攻击视为魔法攻击，震慑成功率由己方物理强度和目标法术豁免（非物理豁免）决定。	]])
		:format(100 * self:combatTalentWeaponDamage(t, 0.6, 1.6), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ELDRITCH_SLAM",
	name = "奥术猛击",
	info = function(self, t)
		return ([[用盾牌猛击地面，制造冲击波。
		对半径 %d 内的生物造成 %d%% 奥术武器伤害。
		所有被击中的目标将会进入可以反击的状态 3 回合，就像你格挡了它们的攻击那样。
		在等级 5 时，你的格挡技能冷却也会被重置。]])
		:format(self:getTalentRadius(t),100 * self:combatTalentWeaponDamage(t, 1.3, 2.6))
	end,
}


return _M
