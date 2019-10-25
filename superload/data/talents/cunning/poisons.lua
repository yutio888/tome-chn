local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_APPLY_POISON",
	name = "涂毒",
	info = function (self,t)
		return ([[学会如何在近战武器、飞刀、弹药上涂毒，命中后有  %d%%  几率使目标中毒，每回合受到 %d  自然伤害，持续 %d  回合。毒素效果可以叠加至 %d  伤害每回合。
		伤害受灵巧加成。]]):
		format(t.getChance(self,t), damDesc(self, DamageType.NATURE, t.getDamage(self, t)), t.getDuration(self, t), damDesc(self, DamageType.NATURE, t.getDamage(self, t)*4))
	end,
}
registerTalentTranslation{
	id = "T_TOXIC_DEATH",
	name = "致命毒素",
	info = function(self, t)
		return ([[当你杀死携带毒素的生物时，将毒素传播至 %d 半径内的敌人 .]]):format(t.getRadius(self, t))
	end,
}

registerTalentTranslation{
	id = "T_VILE_POISONS",
	name = "邪恶毒素",
	info = function(self, t)
		return ([[你学会增强你致命毒素的效果。根据技能等级可以开启新的效果： 
		等级 1 ：麻木毒剂 
		等级 2 ：阴险毒剂 
		等级 3 ：致残毒剂 
		等级 4 ：水蛭毒剂 
		等级 5 ：传染毒剂 
		同时你还可以向世界上特定的人学习新毒剂。 
		同时提高你 %d%% 的毒素效果。
		在你的武器上涂毒不会打破潜行状态。 
		每次只能同时使用 2 种毒剂效果。使用第三种毒剂效果会随机取消一种已启用的效果。]]):
		format(self:getTalentLevel(t) * 20)
	end,
}

registerTalentTranslation{
	id = "T_VENOMOUS_STRIKE",
	name = "毒素爆发",
	effectsDescription = function(self, t)
		local power = t.getPower(self,t)
		local idam = t.getSecondaryDamage(self,t)
		local nb = t.getNb(self,t)
		local heal = t.getSecondaryDamage(self,t)
		local vdam = t.getSecondaryDamage(self,t)*0.6
		return ([[麻木毒素 - 整体速度减少 %d%% ，持续5回合。
		阴险毒素 - 在 5 回合内造成 %0.2f 自然伤害。
		致残毒素 - 令 %d 个技能进入 %d 回合冷却。
		水蛭毒素 - 自己获得 %d 治疗。
		传染毒素 - 额外 %0.2f 自然伤害，伤害半径 %d 。
		]]):
		format(power*100, damDesc(self, DamageType.NATURE, idam), nb, math.floor(nb*1.5), heal, damDesc(self, DamageType.NATURE, vdam), nb)
	end,
	info = function(self, t)
		local dam = 100 * t.getDamage(self,t)
		local desc = t.effectsDescription(self, t)
		return ([[你攻击目标，造成  %d%%  自然武器伤害，并基于目标当前毒素触发额外效果 :
		
		%s 
		学习该技能后，你能学习剧毒飞刀，但使用该技能会使其进入冷却。
		]]):
		format(dam, desc)
	end,
}
registerTalentTranslation{
	id = "T_NUMBING_POISON",
	name = "麻木毒剂",
	info = function(self, t)
		return ([[在你的武器上涂上麻木毒剂，  中毒目标造成的伤害降低 %d%% 。]]):
	format(t.getEffect(self, t))
	end,
}
registerTalentTranslation{
	id = "T_INSIDIOUS_POISON",
	name = "阴险毒剂",
	info = function(self, t)
		return ([[在你的武器上涂上阴险毒剂，  中毒目标受到的治疗效果减少 %d%% 。]]):
	format(t.getEffect(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CRIPPLING_POISON",
	name = "致残毒剂",
	info = function(self, t)
		return ([[在你的武器上涂上致残毒剂, 中毒目标每次使用技能都有 %d%% 概率失败并流失 1 回合时间。]]):
	format(t.getEffect(self, t))
	end,
}
registerTalentTranslation{
	id = "T_LEECHING_POISON",
	name = "水蛭毒素",
	info = function (self,t)
	return ([[在你的武器上涂上水蛭毒剂, 你受到中毒伤害 %d%% 的治疗。]]):
	format(t.getEffect(self, t))
	end,
}
registerTalentTranslation{
	id = "T_VOLATILE_POISON",
	name = "传染毒素",
	info = function (self,t)
	return ([[在你的武器上涂上传染毒剂, 毒素造成额外 %d%% 伤害，且会对周围敌人造成 50%% 的伤害。]]):
	format(t.getEffect(self, t))
	end,
}

registerTalentTranslation{
	id = "T_VULNERABILITY_POISON",
	name = "奥术毒剂",
	info = function(self, t)
		return ([[在你的武器上涂上奥术毒剂，每回合造成每轮 %0.2f 点奥术伤害且所有伤害抗性将被减少 10%% ，毒素免疫减少 50%% 。]]):
	format(damDesc(self, DamageType.ARCANE, t.getDamage(self,t)))
	end,
}

registerTalentTranslation{
	id = "T_STONING_POISON",
	name = "石化毒剂",
	info = function(self, t)
		local dam = damDesc(self, DamageType.NATURE, t.getDOT(self, t))
		return ([[在你的武器上涂上石化毒剂，额外造成每轮 %d 点自然伤害（可叠加至 %d ），持续 %d 回合。。 
		%d 回合后或者毒素效果结束后目标将被石化 %d 回合。 
		受灵巧影响，伤害按比例加成。]]):
		format(dam, dam*4, t.getDuration(self, t), t.stoneTime(self, t), t.getEffect(self, t))
	end,
}



return _M
