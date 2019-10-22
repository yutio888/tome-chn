local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_AETHER_BEAM",
	name = "以太螺旋",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[你凝聚以太能量，释放出一个以太螺旋，对周围目标造成 %0.2f 奥术伤害并且有 25 ％几率沉默目标。 
		以太螺旋每回合也会对中心点造成 10 ％的伤害（但是不会沉默目标）。 
		螺旋会以难以置信的速度旋转。（ 1600 ％基础速度），对每个单位最多一个回合击中3次。 
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.ARCANE, dam))
	end,
}

registerTalentTranslation{
	id = "T_AETHER_BREACH",
	name = "以太裂隙",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[撕裂位面，暂时产生通往以太空间的裂隙，在目标区域造成 %d 个随机魔法爆炸。 
		每个爆炸在 2 码范围内造成 %0.2f 奥术伤害，并且每回合只能触发一次爆炸。 
		受法术强度影响，伤害有额外加成。]]):
		format(t.getNb(self, t), damDesc(self, DamageType.ARCANE, damage))
	end,
}

registerTalentTranslation{
	id = "T_AETHER_AVATAR",
	name = "以太之体",
	info = function(self, t)
		return ([[你的身体与以太能量相融，持续 %d 回合。 
		当此技能激活时，你每回合第一次使用非持续，非奥术或以太系技能都会失去 50 点法力值。你的奥术系和以太系技能冷却时间除以 3 ，你的奥术伤害加成和抗性穿透增加 25%%，你的干扰护盾的半径增加到 10 ，你的最大法力值增加 33%%。]]):
		format(t.getNb(self, t))
	end,
}

registerTalentTranslation{
	id = "T_PURE_AETHER",
	name = "以太掌握",
	info = function(self, t)
		local damageinc = t.getDamageIncrease(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		return ([[纯净的以太能量环绕着你，增加 %0.1f%% 奥术伤害并且无视目标 %d%% 奥术抵抗。 
		在等级 4 时，允许你在以太之体的形态下使用防护系技能而不受任何惩罚。]])
		:format(damageinc, ressistpen)
	end,
}


return _M
