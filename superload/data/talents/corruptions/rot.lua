local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_INFECTIOUS_BITE",
	name = "传染性啃咬",
	message = "@Source@ 将瘟疫病毒注入 @target@.",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local poison = t.getPoisonDamage(self, t)
		return ([[啃咬目标，造成 %d%% 武器伤害。  
		如果攻击击中目标你会注入瘟疫病毒,  造成 %0.2f 枯萎伤害并在 4 回合内造成 %0.2f 枯萎伤害。
		伤害受法术强度加成。]])
		:format(damage, damDesc(self, DamageType.BLIGHT, poison/4), damDesc(self, DamageType.BLIGHT, poison) )
	end,
}

registerTalentTranslation{
	id = "T_INFESTATION",
	name = "侵扰",
	info = function(self, t)
	local resist = t.getResist(self,t)
	local affinity = t.getAffinity(self,t)
	local dam = t.getDamage(self,t)
	local reduction = t.getDamageReduction(self,t)*100
		return ([[你的身体已经腐败 ,增加 %d%% 枯萎和酸性抗性 , %d%% 枯萎伤害吸收。
		每次生命值损失大于 15%% 时,伤害将减少 %d%% ，同时在相邻的格子生成蠕虫, 攻击你的敌人 5 回合。
		你同时只能拥有 5 只蠕虫。。
		蠕虫死亡时将爆炸，产生半径 2 的枯萎毒池，持续 5 回合，造成 %0.2f 枯萎伤害并治疗你 33%% 伤害量。]]):
		format(resist, affinity, reduction, damDesc(self, DamageType.BLIGHT, dam), dam)
	end,
}

registerTalentTranslation{
	id = "T_WORM_WALK",
	name = "蠕虫行走",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local heal = t.getHeal(self, t) 
		local vim = t.getVim(self, t)

		return ([[你解体为蠕虫，并在目标处合并。（误差 %d ）
如果对蠕虫团使用，你和它合体  ，治疗 %d 生命值 , 回复 %d 活力。]]):
format (radius, heal, vim)
	end,
}

registerTalentTranslation{
	id = "T_PESTILENT_BLIGHT",
	name = "致命枯萎",
	info = function(self, t)
	local chance = t.getChance(self,t)
	local duration = t.getDuration(self,t)
		return ([[每次造成枯萎伤害，有 %d%% 几率令目标腐烂，沉默、致盲、缴械或者定身 %d 回合。该效果有冷却时间。
技能等级 4 时，该效果对半径 1 内所有目标有效。
同时，你的蠕虫在近战攻击中有 %d%% 几率附加沉默、致盲、缴械或定身效果，持续 2 回合。
负面状态施加成功率受法术强度影响。]]):
		format(chance, duration, chance/2)
	end,
}

registerTalentTranslation{
	id = "T_WORM_ROT",
	name = "腐烂蠕虫",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local burst = t.getBurstDamage(self, t)
		local chance = t.getChance(self,t)
		return ([[使目标感染腐肉寄生幼虫持续 5 回合。每回合会移除目标一个物理增益效果并造成 %0.2f 酸系和 %0.2f 枯萎伤害。 
		如果 5 回合后未被清除则幼虫会孵化造成 %0.2f 枯萎伤害，移除这个效果但是会在目标处成长为一条成熟的腐肉虫。
		即使这个疾病被移除了，腐肉虫仍然有%d%%的几率腐化。
		伤害受法术强度加成。]]):
		format(damDesc(self, DamageType.ACID, (damage/2)), damDesc(self, DamageType.BLIGHT, (damage/2)), damDesc(self, DamageType.BLIGHT, (burst)), chance)
	end,
}


return _M
