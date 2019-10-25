local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_KINETIC_STRIKE",
	name = "动能打击",
	info = function(self, t)
		return ([[聚焦动能打击敌人造成 %d%% 武器伤害 
		敌人将被这次攻击的力量定身 %d 回合。
		任何处于冻结状态的目标受到额外 %0.2f 物理伤害。
		额外伤害受精神强度加成。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 2.0), t.getDur(self, t), damDesc(self, DamageType.PHYSICAL, t.getDam(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_THERMAL_STRIKE",
	name = "热能打击",
	info = function(self, t)
		return ([[聚焦热能打击敌人造成 %d%% 寒冷武器伤害 .
		之后，一股寒冰能量将爆发并吞噬他们，造成额外 %0.1f 寒冷伤害并冻结他们 %d 回合。
		如果被冻结的目标已经被定身，则会在周围爆发寒冰能量，组成冰墙，持续 3 回合。
		爆发的寒冷伤害受精神强度加成 .]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 2.0), damDesc(self, DamageType.COLD, t.getDam(self, t)), t.getDur(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CHARGED_STRIKE",
	name = "电能打击",
	info = function(self, t)
		return ([[聚焦充能打击敌人造成 %d%% 闪电武器伤害。
		之后，从武器释放一股能量，造成额外 %0.2f 闪电伤害并减半他们的震慑和定身免疫 %d 回合 
		如果电能护盾开启，并且目标已被定身，则护盾吸收量增加 %0.2f.
		如果目标被冻结，冰块会粉碎，击退半径 2 以内的所有生物。
		释放的伤害受精神强度加成 .]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 2.0), damDesc(self, DamageType.LIGHTNING, t.getDam(self, t)), t.getDur(self, t), 1.5 * damDesc(self, DamageType.LIGHTNING, t.getDam(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_PSI_TAP",
	name = "能量吸取",
	info = function(self, t)
		return ([[用灵能强化武器，获得 %d 护甲穿透，同时吸取每次武器攻击中剩余的的能量，每次武器命中时获得 %0.1f 点超能力值。]]):format(t.getPsiRecover(self, t)*3, t.getPsiRecover(self, t))
	end,
}


return _M
