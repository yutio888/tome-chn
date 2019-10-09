local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_AUTOMATED_CLOAK_TESSELLATION",
	name = "披风护甲",
	info = function(self, t)
		return ([[在披风上布满小块金属，对所有攻击提供 %d 的伤害减免。
	大量的金属碎片同时对远程打击提供偏移抵抗，有 %d%% 的概率将投射物反射至附近的其他位置。]])
		:format(t.getArmor(self, t), t.getEvasion(self, t))
	end,}

registerTalentTranslation{
	id = "T_CLOAK_GESTURE",
	name = "披风花招",
	info = function(self, t)
		return ([[在抖动披风的同时，在面前扔下一个小型的爆燃设备，产生一堵长度为 %d 的浓密蒸汽墙。对穿越的生物造成 %0.2f 的火焰伤害，并且阻挡生物视线。效果持续 5 回合。
	技能等级 5 时，敌人会完全丧失你的行踪，仇恨丢失。
	伤害随蒸汽强度提高增加。]])
		:format(t.getLength(self, t), damDesc(self, DamageType.FIRE, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_EMBEDDED_RESTORATION_SYSTEMS",
	name = "嵌入式回复系统",
	info = function(self, t)
		return ([[为披风加装嵌入式回复系统，周围没有可见敌人时自动触发，回复 %d 生命值。
	技能等级 3 时，同时会消除一个物理负面效果。
	该系统每 %d 回合自动触发一次。]])
		:format(t.getHeal(self, t), t.getCD(self, t))
	end,}

registerTalentTranslation{
	id = "T_CLOAK",
	name = "屏蔽设备",
	info = function(self, t)
		return ([[在披风上布满细小的反射镜阵列，反射照射到你身上的所有光线，让你直接潜形。
		 获得 %d 潜行强度，持续 10 回合。
		 潜行强度随蒸汽强度提高增加。]]):
		format(t.getStealth(self, t))
	end,}
return _M