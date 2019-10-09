local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GRAPPLING_STANCE",
	name = "抓取姿态",
	info = function(self, t)
		local save = t.getSave(self, t)
		local damage = t.getDamage(self, t)
		return ([[增加你的物理豁免 %d 和你的物理强度 %d 。 
		受力量影响，增益按比例加成。]])
		:format(save, damage)
	end,
}

registerTalentTranslation{
	id = "T_CLINCH",
	name = "关节技：锁钳",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local power = t.getPower(self, t)
		local drain = t.getDrain(self, t)
		local share = t.getSharePct(self, t)*100
		local damage = t.getDamage(self, t)*100
		return ([[对目标造成 %d%% 武器伤害并抓取目标（可抓取目标的身材最多比你大 1 级）持续 %d 回合。 1 个被钳住的对手将无法移动,每回合受到 %d 伤害，同时你受到的伤害的 %d%% 将转移至它身上。 
		任何目标或你的移动将会打破抓取。维持抓取每回合消耗 %d 体力。 
		同时你只能抓取 1 个目标，并且对任意 1 个你没有抓取的目标使用非抓取徒手技能均会打破抓取。 ]])
		:format(damage, duration, power, share, drain)
	end,
}

registerTalentTranslation{
	id = "T_CRUSHING_HOLD",
	name = "关节技：折颈",
	info = function(self, t)
		local reduction = t.getDamageReduction(self, t)
		local slow = t.getSlow(self, t)
		
		return ([[增强你的抓取，获得额外效果，所有效果不需通过其他豁免或抵抗鉴定。
		#RED# 等级 1 ：减少 %d 物理强度
		等级 3 ：沉默 
		等级 5 ：目标减速 %d%% ]])
		:format(reduction, slow*100)
	end,
}

registerTalentTranslation{
	id = "T_TAKE_DOWN",
	name = "关节技：抱摔",
	info = function(self, t)
		local takedown = t.getDamage(self, t)*100
		local slam = t.getSlam(self, t)
		return ([[冲向目标，试图将他掀翻在地，造成 %d%% 伤害然后抓取之。如果已经抓取，则将他掀翻，制造冲击波，在半径 5 的范围内造成 %d 物理伤害并解除抓取。
		 抓取效果和持续时间基于抓取技能。伤害受物理强度加成。]])
		:format(damDesc(self, DamageType.PHYSICAL, (takedown)), damDesc(self, DamageType.PHYSICAL, (slam)))
	end,
}

registerTalentTranslation{
	id = "T_HURRICANE_THROW",
	name = "关节技：飓风投",
	info = function(self, t)
		return ([[你使出全力将抓取的目标扔到空中，对他和着陆点周围半径 %d 的生物造成 %d%% 伤害。
		如果至少有一个敌人被击中，被投掷的敌人将会因为冲击而失去一个回合。
		 你只能投掷那些可以移动的敌人。]]):format(self:getTalentRadius(t), t.getDamage(self, t)*100)
	end,
}


return _M
