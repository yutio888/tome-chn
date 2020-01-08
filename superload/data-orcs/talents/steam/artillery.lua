local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ROCKET_POD",
	name = "火箭发射器",
	info = function(self, t)
		return ([[你装备着一款全自动的，肩抗式的火箭发射器。每个回合，他会自动向武器范围内的 %d 个敌人发射火箭，造成 %d%% 的火焰蒸汽枪伤害。
		火箭可以安全地穿过盟友。火箭触发的武器命中效果只造成50%%的伤害。]]):format(t.getNb(self,t), t.getDamage(self,t)*100)
	end,
}

registerTalentTranslation{
	id = "T_INCENDIARY_POWDER",
	name = "燃烧粉末",
	info = function(self, t)
		local dam = t.getDamage(self,t)
		local apr = t.getApr(self,t)
		local fear = t.getFear(self,t)
		return ([[用高度易燃的物质强化你的火箭，让它们可以引燃目标，在 3 回合内造成 %0.2f 火焰伤害。继续击中被引燃的目标会刷新效果的持续时间（但不能叠加），并造成 %0.2f 额外火焰伤害。
被这一燃烧效果影响的目标若生命值降低到 25%% 以下，将会陷入恐慌的状态，他们每回合有 %d%% 的几率在恐慌中逃离你。
火焰伤害受蒸汽强度加成。]]):
		format(damDesc(self, DamageType.FIRE, dam), damDesc(self, DamageType.FIRE, dam/2), fear)
	end,
}

registerTalentTranslation{
	id = "T_LOCK_ON",
	name = "目标锁定",
	info = function(self, t)
		return ([[让你的火箭发射器锁定目标 5 回合。
当你锁定目标的时候，自动火箭发射将会被暂停。然而，每回合你会朝目标发射火箭弹幕，造成额外 %d%% 的伤害。
被锁定的目标也会失去 %d 闪避值，并且无法从隐匿和闪避效果中受益。
闪避值降低效果受蒸汽强度加成。]]):
		format(t.getDamage(self, t), t.getDefense(self,t))
	end,
}

registerTalentTranslation{
	id = "T_SEEKER_WARHEAD",
	name = "死亡天降",
	info = function(self, t)
		return ([[你启动火箭发射器，将自己发射到天空中，持续 3 回合，同时发射范围为 2 的火箭弹幕，在 2 码半径内造成 %d%% 火焰蒸汽枪伤害。
		当处在飞行状态的时候，你获得 %d%% 移动速度， %d%% 几率躲避近战和远程攻击，并且可以重新激活这个技能，再次发射火箭弹幕。使用任何火箭弹幕之外的技能都会提前终止这一效果。]]):
		format(t.getDamage(self,t)*100, t.getSpeed(self,t), t.getEvasion(self,t))
	end,
}

registerTalentTranslation{
	id = "T_ROCKET_BARRAGE",
	name = "火箭弹幕",
	info = function(self, t)
		return ([[发射火箭弹幕，在 2 码半径内造成 %d%% 火焰蒸汽枪伤害。]]):format()
	end,
}

return _M