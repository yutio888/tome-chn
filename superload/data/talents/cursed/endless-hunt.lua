local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STALK",
	name = "跟踪",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[当你连续两回合持续近战攻击同一个目标时，你将憎恨目标并追踪目标，效果持续 %d 回合或直到目标死亡。 
		 你每回合攻击追踪目标都将获得可叠加增益效果，该效果在你不攻击会减少 1 重效果。 
		1 重增益 : +%d 命中， +%d%% 近战伤害，当目标被击中时，每回合增加 +%0.2f 仇恨值。 
		2 重增益 : +%d 命中， +%d%% 近战伤害，当目标被击中时，每回合增加 +%0.2f 仇恨值。 
		3 重增益 : +%d 命中， +%d%% 近战伤害，当目标被击中时，每回合增加 +%0.2f 仇恨值。 
		 受意志影响，命中有额外加成。 
		 受力量影响，近战伤害有额外加成。]]):format(duration,
		t.getAttackChange(self, t, 1), t.getStalkedDamageMultiplier(self, t, 1) * 100 - 100, t.getHitHateChange(self, t, 1),
		t.getAttackChange(self, t, 2), t.getStalkedDamageMultiplier(self, t, 2) * 100 - 100, t.getHitHateChange(self, t, 2),
		t.getAttackChange(self, t, 3), t.getStalkedDamageMultiplier(self, t, 3) * 100 - 100, t.getHitHateChange(self, t, 3))
	end,
}

registerTalentTranslation{
	id = "T_HARASS_PREY",
	name = "痛苦折磨",
	info = function(self, t)
		local damageMultipler = t.getDamageMultiplier(self, t)
		local cooldownDuration = t.getCooldownDuration(self, t)
		local targetDamageChange = t.getTargetDamageChange(self, t)
		local duration = t.getDuration(self, t)
		return ([[用两次快速的攻击折磨你追踪的目标 , 每次攻击造成 %d%% （ 0 仇恨）～ %d%% （ 100+ 仇恨）的伤害。并且每次攻击都将干扰目标某项技能、纹身或符文，持续 %d 回合。目标会因为你的攻击而气馁，它的伤害降低 %d%% ，持续 %d 回合。 
		 受意志影响，伤害降低有额外加成。
		 
		如果你装备了盾牌，这一技能也会用你的盾牌攻击。]]):format(t.getDamageMultiplier(self, t, 0) * 100, t.getDamageMultiplier(self, t, 100) * 100, cooldownDuration, -targetDamageChange, duration)
	end,
}


registerTalentTranslation{
	id = "T_BECKON",
	name = "引诱思维",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		local spellpowerChange = t.getSpellpowerChange(self, t)
		local mindpowerChange = t.getMindpowerChange(self, t)
		return ([[捕猎者和猎物之间的联系能让你给予目标思想暗示 , 引诱他们更靠近你。 
		 在 %d 回合内，目标会试图接近你，甚至推开路径上的其他单位。 
		 每回合有 %d%% 的几率，它们会取消原有动作并直接向你走去。 
		 目标受到致命攻击时可能会打断该效果，此效果会减少目标注意力，在它们到达你所在位置之前，降低其 %d 点法术强度和精神强度。 
		 受意志影响，法术强度和精神强度的降低效果有额外加成。]]):format(duration, chance, -spellpowerChange)
	end,
}

registerTalentTranslation{
	id = "T_SURGE",
	name = "杀意涌动",
	info = function(self, t)
		local movementSpeedChange = t.getMovementSpeedChange(self, t)
		local defenseChange = t.getDefenseChange(self, t, true)
		return ([[让杀意激发你敏捷的身手 , 提高你 %d%% 移动速度。不顾一切的移动会带给你厄运 (-3 幸运 )。 
		 分裂攻击、杀意涌动和无所畏惧不能同时开启，并且激活其中一个也会使另外两个进入冷却。 
		双持武器时，杀意涌动还会提高你 %d 的闪避。
		 受意志影响，移动速度和双持时的闪避增益有额外加成。]]):format(movementSpeedChange * 100, defenseChange)
	end,
}



return _M
