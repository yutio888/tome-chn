local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DISTORTION_BOLT",
	name = "扭曲之球",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local distort = DistortionCount(self)
		return ([[射出一枚无视抵抗的扭曲之球并造成 %0.2f 物理伤害。此技能会扭曲目标，减少对方物理抗性 %d%% ，并使其在 2 回合内受到扭曲效果时会产生额外的负面影响。
		如果目标身上已存在扭曲效果，则会在 %d 码范围内产生 150 ％基础伤害的爆炸。 
		在该技能投入点数会增加你所有扭曲效果的降抗效果。
		在等级 5 时，你学会控制你的扭曲效果，防止扭曲效果攻击到你或友军。 
		受精神强度影响，伤害按比例加成。]]):format(damDesc(self, DamageType.PHYSICAL, damage), distort, radius)
	end,
}

registerTalentTranslation{
	id = "T_DISTORTION_WAVE",
	name = "扭曲之涛",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local power = t.getPower(self, t)
		local distort = DistortionCount(self)
		return ([[在 %d 码锥形半径范围内创建一股扭曲之涛，造成 %0.2f 物理伤害，并击退扭曲之涛中的目标。 
		此技能会扭曲目标，减少对方物理抗性 %d%% ，并使其在 2 回合内受到扭曲效果时会产生额外的负面影响。
		在该技能投入点数会增加你所有扭曲效果的降抗效果。
		如果目标身上已存在扭曲效果，则会被震慑 %d 回合。 
		受精神强度影响，伤害按比例加成。]]):format(radius, damDesc(self, DamageType.PHYSICAL, damage), distort, power)
	end,
}

registerTalentTranslation{
	id = "T_RAVAGE",
	name = "疯狂扭曲",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local distort = DistortionCount(self)
		return ([[疯狂扭曲目标，造成每轮 %0.2f 物理伤害，持续 %d 回合。 
		此技能会扭曲目标，减少对方物理抗性 %d%% ，并使其在 2 回合内受到扭曲效果时会产生额外的负面影响。
		如果目标身上已存在扭曲效果，则伤害提升 50 ％，并且目标每回合会丢失一种物理增益效果或持续技能效果。 
		在该技能投入点数会增加你所有扭曲效果的降抗效果。
		受精神强度影响，伤害按比例加成。]]):format(damDesc(self, DamageType.PHYSICAL, damage), duration, distort)
	end,
}

registerTalentTranslation{
	id = "T_MAELSTROM",
	name = "灵能漩涡",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local distort = DistortionCount(self)
		return ([[创造一个强大的灵能漩涡，持续 %d 回合。每回合漩涡会将半径 %d 码内的目标吸向中心并造成 %0.2f 物理伤害。 
		此技能会扭曲目标，减少对方物理抗性 %d%% ，并使其在 2 回合内受到扭曲效果时会产生额外的负面影响。
		在该技能投入点数会增加你所有扭曲效果的降抗效果。
		受精神强度影响，伤害按比例加成。]]):format(duration, radius, damDesc(self, DamageType.PHYSICAL, damage), distort)
	end,
}


return _M
