local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MERGE",
	name = "融合",
	info = function(self, t)
		return ([[指定附近的一个阴影，命令它和附近的一个敌人融合，降低其伤害 %d%% ，持续 5 回合。
杀死阴影释放了你的憎恨，回复 8 点仇恨值。]]):
		format(t.getReduction(self, t))
	end,
}

registerTalentTranslation{
	id = "T_STONE",
	name = "石化",
	info = function(self, t)
		return ([[指定附近的一个阴影，令其攻击附近的一个敌人，造成 %0.1f 物理伤害。
你的阴影将把那个敌人设为目标，而敌人也会攻击那个阴影。
伤害受精神强度加成。]]):
		format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id	= "T_SHADOW_S_PATH",
	name = "阴影之路",
	info = function(self, t)
		return ([[命令所有视野内阴影传送至目标处，对所有经过的敌人造成 %0.1f 物理伤害。
阴影能穿过墙壁来到达目的地。
伤害受精神强度加成。]]):
		format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_CURSED_BOLT",
	name = "诅咒之球",
	info = function(self, t)
		return ([[和视野内的阴影共享仇恨，获得临时控制。
每个阴影将发射纯粹的仇恨之球，对附近的一个敌人造成 %0.1f 精神伤害。
一旦发射了一个仇恨之球，该技能不能取消。
伤害受精神强度加成。]]):
		format(damDesc(self, DamageType.MIND, t.getDamage(self, t)))
	end,
}

return _M