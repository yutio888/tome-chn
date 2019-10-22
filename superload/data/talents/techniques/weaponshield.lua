local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHIELD_PUMMEL",
	name = "盾牌连击",
	info = function(self, t)
		return ([[连续使用 2 次盾牌攻击敌人并分别造成 %d%% 和 %d%% 盾牌伤害。
		如果此技能连续命中目标 2 次则目标会被震慑 %d 回合。
		受命中和力量影响，震慑几率有额外加成。]])
		:format(100 * self:combatTalentWeaponDamage(t, 1, 1.7, self:getTalentLevel(self.T_SHIELD_EXPERTISE)),
		100 * self:combatTalentWeaponDamage(t, 1.2, 2.1, self:getTalentLevel(self.T_SHIELD_EXPERTISE)),
		t.getStunDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_RIPOSTE",
	name = "还击",
	info = function(self, t)
		local inc = t.getDurInc(self, t)
		return ([[通过以下方法提高你的反击能力：
		当你不完全格挡时，也可以进行反击。
		增加攻击者反击DEBUFF的持续时间 %d 。
		你对可反击目标的反击次数增加 %d 次。
		增加 %d%% 反击暴击率。
		受敏捷影响，此暴击率按比例加成。]]):format(inc, inc, t.getCritInc(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHIELD_SLAM",
	name = "拍击",
	info = function(self, t)
		local damage = t.getShieldDamage(self, t)*100
		return ([[用盾牌拍击目标 3 次，造成 %d%% 武器伤害，然后迅速进入格挡状态。
		该格挡不占用盾牌的格挡技能 CD。]])
		:format(damage)
	end,
}

registerTalentTranslation{
	id = "T_ASSAULT",
	name = "强袭",
	info = function(self, t)
		return ([[用你的盾牌攻击目标并造成 %d%% 伤害，如果此次攻击命中，那么你将会发动 2 次武器暴击，每击分别造成 %d%% 基础伤害。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.8, 1.3, self:getTalentLevel(self.T_SHIELD_EXPERTISE)), 100 * self:combatTalentWeaponDamage(t, 0.8, 1.3))
	end,
}

registerTalentTranslation{
	id = "T_SHIELD_WALL",
	name = "盾墙",
	info = function (self,t)
		return ([[进入一个保护性的战斗姿态，让你在使用盾牌的同时更熟练地保护自己。
		提升护甲值 %d ，格挡值 %d ，减少格挡冷却 2 回合。
		提升眩晕和击退抗性 %d%% 。
		护甲和格挡值加成受你的敏捷和力量值影响。]]):
		format(t.getArmor(self, t), t.getBlock(self, t), 100*t.stunKBresist(self, t))
	end,

}

registerTalentTranslation{
	id = "T_REPULSION",
	name = "盾牌猛击",
	info = function(self, t)
		return ([[用盾牌猛击周围  所有敌人，造成 %d%% 盾牌伤害并击退 %d 格。
		此外所有怪物被击退时也会被眩晕 %d 回合。 
		该技能命中时将刷新冲锋的冷却。
		击退距离受技能等级加成。
		眩晕时间受力量加成。]]):format(t.getShieldDamage(self, t)*100, t.getDist(self, t), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHIELD_EXPERTISE",
	name = "盾牌专精",
	info = function(self, t)
		return ([[当你用盾牌攻击时提高你的伤害，并提高法术豁免（ +%d ）和物理豁免（ +%d ）。]]):format(t.getSpell(self, t), t.getPhysical(self, t))
	end,
}

registerTalentTranslation{
	id = "T_LAST_STAND",
	name = "破釜沉舟",
	info = function(self, t)
		local hp = self:isTalentActive(self.T_LAST_STAND)
		if hp then
			hp = t.lifebonus(self, t, hp.base_life)
		else
			hp = t.lifebonus(self,t)
		end
		return ([[在走投无路的局面下，你鼓舞自己，提高 %d 点闪避与护甲，提高 %d 点当前及最大生命值，但是这会使你无法移动。 
		你的坚守让你集中精力于对手的每一次进攻，让你能承受原本致命的伤害。你只有在生命值下降到 -%d 时才会死亡。
		受敏捷影响，闪避和护甲有额外加成。
		受体质和最大生命值影响，生命值增益有额外加成。]]):
		format(t.getDefense(self, t), hp, hp)
	end,
}


return _M
