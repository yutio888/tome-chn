local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DEPLOY_TURRET",
	name = "部署炮台",
	info = function(self, t)
		return ([[你学会了部署炮台的能力。炮台是固定的建筑物，可以帮助你作战。炮台持续 10 回合，部署任何一个炮台，都会让其他炮台技能进入 5 回合冷却时间。
学习该技能还会让你学会新的炮台类型。
技能等级 1 时，你可以使用蒸汽枪炮台。
技能等级 3 时，你可以使用火焰炮台。
技能等级 5 时，你可以使用医疗炮台。
这一技能同时会增加你所有炮台 %d 的敏捷、体质和灵巧值。额外属性值受蒸汽强度加成。]]):
		format(t.getStatBonus(self,t))
end,
}

registerTalentTranslation{
	id = "T_STEAMGUN_TURRET",
	name = "蒸汽枪炮台",
	info = function(self, t)
		local stat = t.getStatBonus(self,t)
		return ([[部署一个装备蒸汽枪的炮台，会自动射击射程内的敌人。炮台具有 +%d 额外敏捷、体质和灵巧值。]]):
		format(stat)
	end,
}


registerTalentTranslation{
	id = "T_TURRET_ROCKET_LAUNCHER",
	name = "火箭发射器",
	info = function(self, t)
		return ([[发射导弹，在 2 码范围内造成火焰蒸汽枪伤害。]]):
		format()
	end,
}

registerTalentTranslation{
	id = "T_TURRET_DUAL_STEAMGUN",
	name = "炮台双枪",
	info = function(self, t)
		return ([[获得第二把蒸汽枪，可以用平常两倍的速度射击。]]):
		format()
	end,
}


registerTalentTranslation{
	id = "T_FLAME_TURRET",
	name = "火焰炮台",
	info = function(self, t)
		local stat = t.getStatBonus(self,t)
		return ([[部署一个装备喷火器的炮台，会灼烧和嘲讽周围的敌人。炮台具有 +%d 额外敏捷、体质和灵巧值。]]):
		format(stat)
	end,
}

registerTalentTranslation{
	id = "T_TURRET_FLAMETHROWER",
	name = "火焰喷射",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[喷射出半径 %d 码扇形的火焰，造成 %0.2f 火焰伤害，并嘲讽敌人。
		伤害受蒸汽强度加成。]]):
		format(radius, damDesc(self, DamageType.FIRE, damage))
	end,
}

registerTalentTranslation{
	id = "T_TURRET_FLAME_VORTEX",
	name = "火焰旋涡",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在半径 %d 码范围内喷出灼热空气构成的漩涡，造成 %0.2f 火焰伤害，把所有敌人拉近你。
		伤害受蒸汽强度加成。]]):
		format(radius, damDesc(self, DamageType.FIRE, damage))
	end,
}

registerTalentTranslation{
	id = "T_MEDIC_TURRET",
	name = "医疗炮台",
	info = function(self, t)
		local stat = t.getStatBonus(self,t)
		return ([[部署一个在 3 码范围内喷出治疗之雾的炮台。炮台具有 +%d 额外敏捷、体质和灵巧值。]]):
		format(stat)
	end,
}

registerTalentTranslation{
	id = "T_OVERCLOCK",
	name = "炮台超载",
	info = function(self, t)
		return ([[向视野内所有炮台注入能量，增加他们 %d 回合的持续时间，并且让他们获得一个吸收 %d 伤害的护盾，持续 10 回合。在护盾消失之前，每个炮台都会向半径 6 码内的随机敌人发射闪电弹，造成 %0.2f 闪电伤害，并有 25%% 的几率震慑敌人。
		这一效果随蒸汽强度提升。]]):
		format(t.getDuration(self,t), t.getShield(self,t), damDesc(self, DamageType.FIRE, t.getDamage(self,t)))
	end,
}

registerTalentTranslation{
	id = "T_UPGRADE",
	name = "炮台升级",
	info = function(self, t)
		local power = t.getPower(self,t)
		local range = t.getRange(self,t)
		return ([[升级目标炮台，使其获得 %d%% 最大生命值，并根据其类型，获得以下的特殊能力：
		蒸汽枪炮台: 获得第二把造成 %d%% 伤害的蒸汽枪，每 3 回合会发射一枚火箭，在 2 码半径内造成 %d%% 蒸汽枪伤害。
		火焰炮台: 增加 %d%% 伤害和 %d 射程，每过 3 回合，会在 %d 码范围内喷出灼热蒸汽的漩涡，将所有敌人拉向炮台，并造成标准喷火伤害。
		医疗炮台: 增加对目标的治疗量 %d%% ，且每回合有 %d%% 几率清除目标身上一个负面效果。]]):
		format(power, power/2, power*3, power/2, range/2, range, power/2, power/3)
	end,
}

registerTalentTranslation{
	id = "T_HUNKER_DOWN",
	name = "炮台守卫",
	info = function(self, t)
		local dam = t.getPower(self,t)
		local dur = t.getDuration(self,t)
		return ([[进入守备模式，在身边召唤 2 个守卫炮台，持续 %d 回合。守卫炮台会将身边盟友（不包括其他守卫炮台）所受到所有伤害的 %d%% 转移到自己身上，并且它们装备有强力的电磁炮，可以发射贯穿敌人的子弹。]]):
		format(dur, dam)
	end,
}

registerTalentTranslation{
	id = "T_TURRET_GAUSS_CANNON",
	name = "电磁炮",
	info = function(self, t)
		return ([[发射你的双联电磁炮，在一条贯穿直线上造成 100%% 闪电蒸汽枪伤害，无视护甲。这一效果不会伤害友好目标。]]):format()
	end,
}

return _M