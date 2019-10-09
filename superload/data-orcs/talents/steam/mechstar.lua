local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_METALSTAR",
	name = "金属灵晶",
	info = function(self, t)
		return ([[迅速将金属粒子聚集在灵晶周围，并将灵能聚焦于  其中。
		金属粒子将产生大爆炸，击退（ %d 码）并眩晕（ %d 回合）半径 %d 内所有敌人。
		]])	
		:format(t.getKnockback(self, t), t.getDur(self, t), self:getTalentRadius(t))
	end,}

registerTalentTranslation{
	id = "T_BLOODSTAR",
	name = "血液灵晶",
	info = function(self, t)
		local mt = self:getTalentFromId(self.T_METALSTAR)
		return ([[每次你使用灵晶射击时，你将与灵晶碎片建立血液  超能力联系，持  续 %d 回合。
		每回合目标将受到 %0.2f 物理伤害，一半伤害值将转化为治疗。
		每增加一名额外目标，其带来的治疗量进一步减半。
		当目标距离超过金属灵晶范围（当前 %d ）的两倍时，效果中止。
		该伤害不会打断眩晕效果，受蒸汽强度加成。]])
		:format(t.getDur(self, t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), self:getTalentRadius(mt) * 2)
	end,}

registerTalentTranslation{
	id = "T_STEAMSTAR",
	name = "蒸汽灵晶",
	info = function(self, t)
		local mt = self:getTalentFromId(self.T_METALSTAR)
		return ([[你的血液灵晶效果同时造成 %0.2f 火焰伤害。
		火焰同时产生蒸汽，每回合提供 %d 蒸汽，从每个额外目标处获得的蒸汽数量减少 66%%。
		该伤害不会打断眩晕效果，受蒸汽强度加成。]])
		:format(damDesc(self, DamageType.FIRE, t.getDamage(self, t)), t.getSteam(self, t))
	end,}

registerTalentTranslation{
	id = "T_DEATHSTAR",
	name = "死亡灵晶",
	info = function(self, t)
		return ([[每次你使用射击类技能命中一个被血液灵晶影响的目标时，随机另一项冷却中的射击类技能冷却时间减少 %d 回合。]])
		:format(t.getReduct(self, t))
	end,}
return _M