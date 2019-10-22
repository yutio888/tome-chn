local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RADIANCE",
	name = "光辉",
	info = function(self, t)
		return ([[你的体内充满了阳光，你的身体会发光，半径 %d 。
		你的眼睛适应了光明，获得 %d%% 目盲免疫。
		光照超过你的灯具时取代之，不与灯具叠加光照。
		]]):
		format(radianceRadius(self), t.getResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ILLUMINATION",
	name = "照明",
	info = function(self, t)
		return ([[你的光辉让你能看见平时看不见的东西。
		所有在你光辉范围内的敌人减少 %d 点潜行和隐身强度，减少 %d 闪避，同时不可见带来的闪避加成无效。 
		效果受法术强度加成。]]):
		format(t.getPower(self, t), t.getDef(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SEARING_SIGHT",
	name = "灼烧",
	info = function(self, t)
		return ([[ 你的光辉变得如此强烈，所有光照范围内的敌人都会被灼伤，受到 %0.1f 点光系伤害。
		被照耀的敌人有 %d%% 几率被眩晕5回合。
		效果受法术强度加成。]]):
		format(damDesc(self, DamageType.LIGHT, t.getDamage(self, t)), t.getDaze(self, t))
	end,
}

registerTalentTranslation{
	id = "T_JUDGEMENT",
	name = "裁决",
	info = function(self, t)
		return ([[向光辉覆盖的敌人发射光明球，每个球会缓慢移动，直到命中，同时对路径上的障碍物造成 %d 点光系伤害。
		当击中目标时，球体会爆炸，在半径1的范围内造成 %d 点光系伤害，同时 50%% 的伤害会治疗你。]]):
		format(t.getMoveDamage(self, t), t.getExplosionDamage(self, t))
	end,
}

return _M
