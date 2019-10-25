local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STUNNING_BLOW_ASSAULT",
	name = "震慑打击",
	info = function(self, t)
		return ([[用你的双持武器攻击目标两次并造成 %d%% 伤害。每次攻击都会试图震慑目标 %d 回合。 
		受物理强度影响，震慑概率有加成。]])
		:format(100 * self:combatTalentWeaponDamage(t, 0.5, 0.7), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_FEARLESS_CLEAVE",
	name = "无畏跳斩",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[向前跳一步，用这股力量对周围的目标造成 %d%% 武器伤害。]])
		:format(damage)
	end,
}

registerTalentTranslation{
	id = "T_DEATH_DANCE_ASSAULT",
	name = "死亡之舞",
	info = function(self, t)
		return ([[原地旋转，伸展你的武器，伤害你周围半径 %d 范围内的所有目标，造成 %d%% 武器伤害。
		等级 3 时，所有伤害会引发额外 %d%% 流血伤害，持续 5 回合。]]):format(self:getTalentRadius(t), 100 * self:combatTalentWeaponDamage(t, 1.4, 2.1), t.getBleed(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_EXECUTION",
	name = "致命斩杀",
	info = function(self, t)
		return ([[试图斩杀目标。目标每损失 1%% 生命，你造成额外 %d%% 武器伤害。（剩余 30%% 生命时造成 %d%% 武器伤害）
		该攻击必定暴击。
		如果这一攻击杀死了敌人，你的两个技能的冷却时间减少两个回合，致命斩杀技能的冷却时间归零。]]):
		format(t.getPower(self, t), 100 + t.getPower(self, t) * 70)
	end,
}


return _M
