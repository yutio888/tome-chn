local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_REPULSION_BLAST",
	name = "排斥冲击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在半径  %d  码的锥形范围内释放一股爆炸性的重力冲击波，造成  %0.2f  物理 (重力 )伤害并击退范围内目标。
		 被击飞至墙上或其他单位的目标受到额外  25%%  伤害，并对被击中的单位造成  25%%  伤害。
		 离你越近的目标将会被击飞得更远。受法术强度影响，伤害按比例加成。]]):
		format(radius, damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}

	
registerTalentTranslation{
	id = "T_GRAVITY_SPIKE",
	name = "重力钉刺",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在半径  %d  范围内制造一个重力钉刺，将所有目标牵引至法术中心，造成  %0.2f  物理 (重力 )伤害。
		 从第二个单位起，每牵引一个单位将会使伤害增加  %0.2f (最多增加  %0.2f  额外伤害 )。
		 离法术中心越远，目标收到的伤害越少  (每格减少  20%%)。
		 受法术强度影响，伤害按比例加成。]])
		:format(radius, damDesc(self, DamageType.PHYSICAL, damage), damDesc(self, DamageType.PHYSICAL, damage/8), damDesc(self, DamageType.PHYSICAL, damage/2))
	end,
}

registerTalentTranslation{
	id = "T_GRAVITY_LOCUS",
	name = "重力核心"	,
	info = function(self, t)
		local conv = t.getConversion(self, t)
		local proj = t.getSlow(self, t)
		local anti = t.getAnti(self, t)
		return ([[在你身边制造一个重力场，将你造成伤害的  %d%%  转化为物理伤害，使向你发射的飞行物减速  %d%% ，并使你免受重力伤害和效果的影响。
		 此外，排斥冲击对目标造成伤害之后，有  %d%%  的几率将目标的击退抗性减半两回合。]])
		 :format(conv, proj, anti)
	end,
}

registerTalentTranslation{
	id = "T_GRAVITY_WELL",
	name = "重力之井",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		local slow = t.getSlow(self, t)
		return ([[增加半径 %d 范围内的重力 %d 回合，造成 %0.2f 物理 ( 重力 ) 伤害，并降低所有目标的整体速度 %d%% 。
		受法术强度影响，伤害按比例加成。]]):format(radius, duration, damDesc(self, DamageType.PHYSICAL, damage), slow*100)
	end,
}


return _M
