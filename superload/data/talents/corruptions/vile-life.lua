local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_BLOOD_SPLASH",
	name = "鲜血飞溅",
	info = function(self, t)
		return ([[制造痛苦和死亡让你充满活力。
		每次暴击时回复 %d 生命。
		每次杀死生物时回复 %d 生命。
		每个效果每回合只能触发一次。]]):
		format(t.heal(self, t), t.heal(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ELEMENTAL_DISCORD",
	name = "元素狂乱",
	info = function(self, t)
		return ([[ 每次受到元素伤害时对造成伤害的生物触发以下效果：
		- 火焰：灼烧目标 5 回合，造成 %0.2f 火焰伤害。
		- 寒冷：冻结目标 3 回合，冰块强度 %d 。
		- 酸性：致盲 %d 回合。
		- 闪电：眩晕 %d 回合。
		- 自然：减速 %d%% 四回合。
		每种伤害类型的效果每 10 回合只能触发一次。]]):
		format(
			damDesc(self, DamageType.FIRE, t.getFire(self, t)),
			t.getCold(self, t),
			t.getAcid(self, t),
			t.getLightning(self, t),
			t.getNature(self, t)
		)
	end,
}

registerTalentTranslation{
	id = "T_HEALING_INVERSION",
	name = "治疗逆转",
	info = function(self, t)
		return ([[你操控%d码范围内所有敌人的活力，临时将所有治疗转化为伤害。（生命值自然回复除外）	
		5 回合内目标受到的所有治疗将变成 %d%% 治疗量的枯萎伤害。
		效果受法术强度加成。]]):format(self:getTalentRadius(t), t.getPower(self,t))
	end,
}

registerTalentTranslation{
	id = "T_VILE_TRANSPLANT",
	name = "邪恶移植",
	info = function(self, t)
		return ([[你将至多 %d 个物理与魔法负面状态转移给附近的一个生物，每转移一个消耗%d活力值。
		状态免疫不会阻止转移。
		转移成功率受法术强度影响。]]):
		format(t.getNb(self, t), t.getVim(self, t))
	end,
}



return _M
