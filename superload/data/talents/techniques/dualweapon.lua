local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DUAL_WEAPON_TRAINING",
	name = "双持专精",
	info = function(self, t)
		return ([[副手武器伤害增加至 %d%% 。]]):format(100 * t.getoffmult(self,t))
	end,
}

registerTalentTranslation{
	id = "T_DUAL_WEAPON_DEFENSE",
	name = "抵挡训练",
	info = function(self, t)
		return ([[你已经学会用你的武器招架攻击。当你双持时，增加 %d 点近身闪避。
		每回合最多 %0.1f 次，你有 %d%% 概率抵挡至多 %d 点伤害（基于副手伤害）。 
		抵挡的减伤类似护甲，且被抵挡的攻击不会暴击。很难抵挡未发现的敌人的攻击，且不能使用灵晶抵挡攻击。
		受敏捷影响，闪避增益按比例加成。 
		受灵巧影响，抵挡次数有额外加成。
		]]):format(t.getDefense(self, t), t.getDeflects(self, t, true), t.getDeflectChance(self,t), t.getDamageChange(self, t, true))
	end,
}

registerTalentTranslation{
	id = "T_CLOSE_COMBAT_MANAGEMENT",
	name = "近战训练",
	info = function (self,t)
		return ([[你近战格斗的技巧更加精湛了。
		用双持武器命中对手时，你每命中一个敌人获得 %d 伤害减免（受敏捷加成，灵晶无效）。
		此外，该技能开启时，你能反弹 %d%% 伤害。]]):
		format(t.getReflectArmour(self, t), t.getPercent(self, t))
	end,
}

registerTalentTranslation{
	id = "T_OFFHAND_JAB",
	name = "副手猛击",
	info = function (self,t)
		local dam = 100 * t.getDamage(self, t)
		return ([[你迅速移动，用徒手攻击敌人。
		造成 %d%% 主手武器伤害， %d%% 徒手伤害。
		若徒手攻击命中，敌人将被混乱（ %d%% 强度） %d 回合。
		混乱几率受命中加成。]])
		:format(dam, dam*1.25, t.getConfusePower(self, t), t.getConfuseDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DUAL_STRIKE",
	name = "双持打击",
	info = function(self, t)
		return ([[用副手武器造成 %d%% 伤害。 
		如果攻击命中，目标将会被震慑 %d 回合并且你会使用主武器对目标造成 %d%% 伤害。 
		受命中影响，震慑概率有额外加成。]])
		:format(100 * self:combatTalentWeaponDamage(t, 0.7, 1.5), t.getStunDuration(self, t), 100 * self:combatTalentWeaponDamage(t, 0.7, 1.5))
	end,
}

registerTalentTranslation{
	id = "T_FLURRY",
	name = "疾风连刺",
	info = function(self, t)
		return ([[对目标进行快速的连刺，每把武器进行 3 次打击，每次打击造成 %d%% 的伤害。]]):format(100 * self:combatTalentWeaponDamage(t, 0.4, 1.0))
	end,
}
registerTalentTranslation{
	id = "T_HEARTSEEKER",
	name = "追心刺",
	info = function(self, t)
		dam = t.getDamage(self,t)*100
		crit = t.getCrit(self,t)
		return ([[迅速跃向目标，用双手武器发动一次强力的突刺攻击，造成 %d%% 武器伤害，该次攻击暴击伤害系数增加 %d%% 。]]):
		format(dam, crit)
	end,
}	
registerTalentTranslation{
	id = "T_SWEEP",
	name = "拔刀斩",
	info = function(self, t)
		return ([[对你正前方锥形范围的敌人造成 %d%% 武器伤害并使目标进入流血状态，每回合造成 %d 点伤害，持续 %d 回合。
		受主手武器伤害和敏捷影响，流血伤害有额外加成。]]):
		format(100 * self:combatTalentWeaponDamage(t, 1, 1.7), damDesc(self, DamageType.PHYSICAL, t.cutPower(self, t)), t.cutdur(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WHIRLWIND",
	name = "旋风斩",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local range = self:getTalentRange(t)
		return ([[你迅速跳跃至 %d 格内的敌人身边并在移动中用 2 把武器对路径周围的所有敌人造成 %d%% 伤害，并使其流血 5 回合受到额外 50%% 伤害。]]):
		format(range, damage*100)
	end,
}


return _M
