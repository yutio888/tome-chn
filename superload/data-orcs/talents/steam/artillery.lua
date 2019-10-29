local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ROCKET_POD",
	name = "火箭发射器",
	info = function(self, t)
		return ([[你装备着一款全自动的，肩抗式的火箭发射器。每个回合，他会自动向武器范围内的 %d 个敌人发射火箭，造成 %d%% 的火焰蒸汽枪伤害。
		火箭可以安全地穿过盟友。]]):format(t.getNb(self,t), t.getDamage(self,t)*100)
	end,
}

registerTalentTranslation{
	id = "T_INCENDIARY_POWDER",
	name = "燃烧粉末",
	info = function(self, t)
		local dam = t.getDamage(self,t)
		local apr = t.getApr(self,t)
		local fear = t.getFear(self,t)
		return ([[用高度易燃的物质强化你的火箭，让它们可以引燃目标，在 3 回合内造成 %0.2f 火焰伤害，并降低他们 %d 护甲值。继续击中被引燃的目标会刷新效果的持续时间，并造成 %0.2f 额外火焰伤害。
被这一燃烧效果影响的目标若生命值降低到 25%% 以下，将会陷入恐慌的状态，他们每回合有 %d%% 的几率在恐慌中逃离你。
火焰伤害和护甲降低效果受蒸汽强度加成。]]):
		format(damDesc(self, DamageType.FIRE, dam), apr, damDesc(self, DamageType.FIRE, dam/2), fear)
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
	name = "制导弹头",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local dam = t.getDamage(self,t)
		local dur = t.getDuration(self,t)
		return ([[发射一枚强大的制导导弹，你可以直接控制它。这颗导弹持续 2 回合，拥有 1000%% 的移动速度，并且可以闪避任何负面效果。
在它遭受攻击或者你手动激活它的时候，导弹会立刻引爆。这会在半径 %d 码范围内造成一次毁灭性的爆炸，对范围内的目标造成 %0.2f 火焰伤害，震慑目标 %d 回合，并点燃地面，每回合造成 %0.2f 火焰伤害。
当你操控导弹的时候，你的注意力完全集中在目标上，这会让你无法进行任何行动，但同样也处于无敌状态。
警告——爆炸可能会到你造成伤害！]]):
		format(rad, damDesc(self, DamageType.FIRE, dam), dur, damDesc(self, DamageType.FIRE, dam/5))
	end,
}

registerTalentTranslation{
	id = "T_DETONATE_MISSILE",
	name = "引爆",
	info = function(self, t)
		return ([[引爆导弹！]]):format()
	end,
}

return _M