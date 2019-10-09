local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_NETHERBLAST",
	name = "虚空爆炸",
	info = function(self, t)
		local dam = t.getDamage(self,t)/2
		local backlash = t.getBacklash(self,t)
		return ([[发射一束不稳定的虚空能量，造成 %0.2f 暗影 %0.2f 时空伤害。
		该法术会对你产生熵能反冲，在 8 回合内造成 %d 伤害。
		伤害受法术强度加成。]]):
		format(damDesc(self, DamageType.DARKNESS, dam), damDesc(self, DamageType.TEMPORAL, dam), backlash)
	end,
}

registerTalentTranslation{
	id = "T_RIFT_CUTTER",
	name = "裂缝切割",
	info = function(self, t)
		return ([[发射一束扫射大地的能量，造成 %0.2f 暗影伤害，并产生不稳定的裂缝。 3 回合后裂缝湮灭并对周围敌人造成 %0.2f 时空伤害。
		一次湮灭不能多次伤害同一目标。
		该法术会对你产生熵能反冲，在 8 回合内造成 %d 伤害。
		伤害受法术强度加成。]]):
		format(damDesc(self, DamageType.DARKNESS, t.getDamage(self,t)), damDesc(self, DamageType.TEMPORAL, t.getDamage(self,t)), t.getBacklash(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SPATIAL_DISTORTION",
	name = "空间扭曲",
	info = function(self, t)
		local dam = t.getDamage(self,t)/2
		local backlash = t.getBacklash(self,t)
		local dur = t.getDuration(self,t)
		local rad = self:getTalentRadius(t)
		return ([[ 在时空中临时打开半径 %d 的裂缝，将范围内目标传送至指定位置。
		敌人将受到 %0.2f 暗影 %0.2f 时空伤害。
		该法术会对你产生熵能反冲，在 8 回合内造成 %d 伤害。
		伤害受法术强度加成。]]):format(rad, damDesc(self, DamageType.DARKNESS, dam), damDesc(self, DamageType.TEMPORAL, dam), backlash)
	end,
}

registerTalentTranslation{
	id = "T_HALO_OF_RUIN",
	name = "毁灭光环",
	info = function(self, t)
		return ([[ 每次你释放疯狂法术时，一次虚空火花将环绕在你周围 10 回合，上限为 5 个。
		每个火花增加你 %d%% 暴击率。当你拥有 5 个火花时，你的下一次虚空法术将消耗所有火花来获得强化效果。
#PURPLE#虚空爆炸：#LAST# 成为穿透性虚空能量  ，并在 5 回合内造成额外 %d%% 伤害。
#PURPLE#裂缝切割:#LAST# 裂缝内的敌人将定身 %d 回合，每回合受到 %0.2f 时空伤害。裂缝湮灭时爆炸半径增加 %d 。
#PURPLE#空间扭曲:#LAST# 裂缝出口处产生一个持续 %d 回合的熵之胃，能用触须拉近敌人。
伤害受法术强度加成。
熵之胃的属性受等级和魔法属性加成。]]):
		format(t.getCrit(self,t), t.getSpikeDamage(self,t)*100, t.getPin(self, t), damDesc(self, DamageType.TEMPORAL, t.getRiftDamage(self,t)), t.getRiftRadius(self,t), t.getSpatialDuration(self,t))
	end,
}

registerTalentTranslation{
	id = "T_GRASPING_TENDRILS",
	name = "触须抓取",
	info = function(self, t)
		return ([[抓住目标，将其拉到身边，造成 %d%% 武器伤害并嘲讽之。]]):
		format(t.getDamage(self,t)*100)
	end,
}
return _M
