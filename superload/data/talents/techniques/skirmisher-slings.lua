local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SKIRMISHER_SLING_SUPREMACY",
	name = "投石索精通",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		local reloads = t.ammo_mastery_reload(self, t)
		return ([[使用投石索时增加武器伤害 %d%% ，增加物理强度30。
		同时增加每回合的装填量 %d 。]]):format(inc * 100, reloads)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_SWIFT_SHOT",
	name = "快速投射",
	info = function(self, t)
		return ([[发射一枚快速的石弹，造成 %d%% 伤害，攻击速度是你普通攻击的两倍。增加你攻击速度 %d%% ，持续5回合。
		移动将会降低技能冷却 1 回合。]])
		:format(t.getDamage(self, t) * 100, t.getAttackSpeed(self,t))
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_HURRICANE_SHOT",
	name = "飓风连射",
	info = function(self, t)
		return ([[最多发射 %d 颗弹矢，每颗对锥形范围内的敌人造成 %d%% 武器伤害。每个敌人只能被攻击 1 次（当技能等级在 3 级或更高时为 2 次）。使用快速投射技能会降低冷却时间 1 回合。]]):format(t.limit_shots(self, t),t.damage_multiplier(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_BOMBARDMENT",
	name = "连环炮击",
	info = function(self, t)
		return ([[你的基础射击技能消耗 %d 体力，发射 %d 石弹，每颗造成 %d%% 伤害。]])
		:format(t.shot_stamina(self, t), t.bullet_count(self, t), t.damage_multiplier(self, t) * 100 )
	end,
}


return _M
