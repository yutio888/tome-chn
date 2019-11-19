local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_LIGHTNING_SPEED",
	name = "闪电加速",
	info = function(self, t)
		return ([[你转化为闪电，增加 %d%% 移动速度，持续 %d 回合。 
		同时提供 30%% 物理伤害抵抗和 100%% 闪电抵抗。 
		除了移动外，任何动作都会打断此效果。 
		注意：由于你的移动速度非常快，游戏回合时间会显得非常慢。 
		这个技能还能被动提升你 %d%% 移动速度。 
		每点雷龙系的天赋可以使你增加闪电抵抗 1%% 。]])
		:format(t.getSpeed(self, t), t.getDuration(self, t), t.getPassiveSpeed(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_STATIC_FIELD",
	name = "静电力场",
	info = function(self, t)
		local percent = t.getPercent(self, t)
		local litdam = t.getDamage(self, t)
		return ([[制造一个 %d 码范围的静电力场。任何范围内的目标至多会丢失 %0.1f%% 当前生命值（精英或稀有 %0.1f%% 史诗或 Boss %0.1f%% 精英 Boss %0.1f%% ）该伤害不能抵抗，但可以被物理豁免减少。 
		之后，会造成额外 %0.2f 闪电伤害，无视怪物阶级。
		受精神强度影响，生命丢失量和闪电伤害有额外加成。闪电伤害可以暴击。 
		每点雷龙系的天赋可以使你增加闪电抵抗 1%% 。]]):format(self:getTalentRadius(t), percent, percent/1.5, percent/2, percent/2.5, damDesc(self, DamageType.LIGHTNING, litdam))
	end,
}

registerTalentTranslation{
	id = "T_TORNADO",
	name = "龙卷风",
	info = function(self, t)
		local rad = t.getRadius(self, t)
		return ([[召唤一个龙卷风，它会向着目标极为缓慢地移动，并在目标移动时跟随目标，最多移动20次。
		每当它移动时，半径2范围内的所有敌人会受到 %0.2f 闪电伤害，并被击退2格。
		当它碰到目标的时候，会在 %d码范围内引发爆炸，击退目标，并造成 %0.2f 闪电和 %0.2f 物理伤害。
		受精神强度影响，伤害有额外加成。 
		每点雷龙系的天赋可以使你增加闪电抵抗 1%% 。]]):format(
			damDesc(self, DamageType.LIGHTNING, t.getMoveDamage(self, t)),
			rad,
			damDesc(self, DamageType.LIGHTNING, t.getDamage(self, t)),
			damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t))
		)
	end,
}

registerTalentTranslation{
	id = "T_LIGHTNING_BREATH",
	name = "闪电吐息",
	message = "@Source@ 呼出闪电!",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你在前方 %d 码锥形范围内喷出闪电。 
		此范围内的目标会受到 %0.2f ～ %0.2f 闪电伤害（平均 %0.2f ）并被震慑 3 回合。 
		受力量影响，伤害有额外加成。技能暴击率基于精神暴击值计算。
		每点雷龙系的天赋可以使你增加闪电抵抗 1%% 。]]):format(
			self:getTalentRadius(t),
			damDesc(self, DamageType.LIGHTNING, damage / 3),
			damDesc(self, DamageType.LIGHTNING, damage),
			damDesc(self, DamageType.LIGHTNING, (damage + damage / 3) / 2))
	end,
}


return _M
