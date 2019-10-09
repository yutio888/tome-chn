local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_THREAD_WALK",
	name = "空间行走",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local defense = t.getDefense(self, t)
		local resist = t.getResist(self, t)
		return ([[使用弓或双持武器攻击，造成 %d%% 武器伤害。
		如果使用弓箭，则你被传送到目标附近。否则传送到和目标距离等于弓的射程的位置。
		同时，你获得传送后加成：增加 %d 闪避和 %d%% 全体抗性。
		传送后加成受魔法加成。]])
		:format(damage, defense, resist)
	end,
}

registerTalentTranslation{
	id = "T_BLENDED_THREADS",
	name = "混合螺旋",
	info = function(self, t)
		local count = t.getCount(self, t)
		return ([[每次你的箭命中时，减少一个螺旋灵刃系技能一回合的冷却。
		每次你的近战武器命中时，减少一个螺旋灵弓系技能一回合的冷却。
		这个效果一回合最多触发 %d 次。]])
		:format(count)
	end,
}

	
registerTalentTranslation{
	id = "T_THREAD_THE_NEEDLE",
	name = "针型聚焦",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[使用弓箭或者双持武器攻击造成 %d%% 武器伤害。
		如果使用弓箭，你的箭将成为具有穿透性的射线。
		如果使用双持武器，则攻击你周围半径 1 的所有目标。]])
		:format(damage)
	end,
}

	
	
registerTalentTranslation{
	id = "T_WARDEN_S_CALL",
	name = "守卫呼唤",
	info = function(self, t)
		return ([[当你用弓箭或近战武器攻击时，有 %d%% 几率让一个时空守卫从另一个时空线穿越过来帮助你，攻击或者射击目标。
		守卫处于相位空间外，伤害减少 %d%% ，守卫的弓箭能穿过友方生物。
		这个效果每回合只能触发一次，守卫在攻击后会消失。]])
		:format(t.getChance(self, t), t.getDamagePenalty(self, t))
	end,

}

return _M
