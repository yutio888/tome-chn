local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GREATER_WEAPON_FOCUS",
	name = "专注打击",
	info = function(self, t)
		return ([[专注于你的攻击，每次攻击有 %d%% 概率对目标造成一次类似的附加伤害，持续 %d 回合。 
		此效果对所有攻击，甚至是技能攻击或盾击都有效果，但每回合每把武器最多获得一次额外攻击。 
		受敏捷影响，概率有额外加成。]]):format(t.getchance(self, t), t.getdur(self, t))
	end,
}

registerTalentTranslation{
	id = "T_STEP_UP",
	name = "步步为营",
	info = function(self, t)
		return ([[每杀死 1 个敌人你有 %d%% 概率增加 1000%% 移动速度，持续一个标准游戏回合。 
		此效果在你执行除移动外其他动作后立刻结束。 
		注意：由于你的移动非常迅速，游戏回合会过的很慢。]]):format(math.min(100, self:getTalentLevelRaw(t) * 20))
	end,
}

registerTalentTranslation{
	id = "T_BLEEDING_EDGE",
	name = "撕裂鞭笞",
	info = function(self, t)
		local heal = t.healloss(self,t)
		return ([[割裂目标并造成 %d%% 武器伤害。 
		如果攻击命中目标，则目标会持续流血 7 回合， 
		造成总计 %d%% 武器伤害。在此过程中，任何对目标的治疗效果减少 %d%% 。]]):
		format(100 * self:combatTalentWeaponDamage(t, 1, 1.7), 100 * self:combatTalentWeaponDamage(t, 2, 3.2), heal)
	end,
}

registerTalentTranslation{
	id = "T_TRUE_GRIT",
	name = "刚毅",
	info = function(self, t)
		local drain = t.drain_stamina(self, t)
		local resistC = t.resistCoeff(self, t)
		return ([[采取一个防守姿态并抵抗敌人的猛攻.
		当你受伤后，你获得相当于 %d%% 损失生命值百分比的全体伤害抗性。
		例如：当你损失 70%% 生命时获得 %d%% 抗性。
		同时，你的全体伤害抗性上限相比于 100%% 的差距将减少 %0.1f%% 。
		该技能消耗体力迅速，体力值基础消耗 %0.1f ，每回合增加 0.3 。
		抗性效果在每回合开始时刷新。]]):
		format(resistC, resistC*0.7, t.getCapApproach(self, t)*100, drain)
	end,
}


return _M
