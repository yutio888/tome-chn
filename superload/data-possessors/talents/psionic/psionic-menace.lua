local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_MIND_WHIP",
	name = "心灵鞭打",
	info = function (self,t)
		return ([[对一个生物释放你的灵能怒气造成 %0.2f 精神伤害。
		鞭子可同时对目标身边的一个敌人造成伤害。
		如果你没有双持灵晶，但是在副手栏里装备了，你会立刻自动切换。此技能与心灵利刃不兼容。]]):
		format(damDesc(self, DamageType.MIND, t.getDam(self, t)))
	end,
}
registerTalentTranslation{
	id = "T_PSYCHIC_WIPE",
	name = "精神鞭打",
	info = function (self,t)
		return ([[你在目标脑中投射空灵的手指。
		持续 %d 回合总共造成 %0.2f 精神伤害并减少 %d 精神豁免。
		这个强大的效果尝试使用 130%% 你的精神强度去对抗目标的精神豁免。
		如果你没有双持灵晶，但是在副手栏里装备了，你会立刻自动切换。此技能与心灵利刃不兼容。]]):
		format(t.getDur(self,t), damDesc(self, DamageType.MIND, t.getDam(self, t)), t.getReduct(self, t))
	end,
}
registerTalentTranslation{
	id = "T_GHASTLY_WAIL",
	name = "恐怖嚎叫",
	info = function (self,t)
		return ([[释放你的心灵力量，把你身边半径 %d 内的敌人击退 3 格。
		没有通过精神豁免的生物会眩晕 %d 回合并受到 %0.2f 精神伤害。
		如果你没有双持灵晶，但是在副手栏里装备了，你会立刻自动切换。此技能与心灵利刃不兼容。]]):
		format(self:getTalentRadius(t), t.getDur(self, t), t.getDam(self, t))
	end,
}
registerTalentTranslation{
	id = "T_FINGER_OF_DEATH",
	name = "死亡一指",
	info = function (self,t)
		return ([[用手指对受到恐怖嚎叫效果影响的敌人射出一道冲击波。
		对目标已造成 %d%% 已损失生命值的精神伤害。
		对 boss 或者更高阶级的目标伤害最高为 %d.
		如果目标从死亡，并且是你经可以占有类型，则直接吸收到你的身体储备中。
		如果你没有双持灵晶，但是在副手栏里装备了，你会立刻自动切换。此技能与心灵利刃不兼容。]]):
		format(t.getDam(self, t), t.getBossMax(self, t))
	end,
}
return _M