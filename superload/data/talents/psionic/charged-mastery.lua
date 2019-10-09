local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TRANSCENDENT_ELECTROKINESIS",
	name = "卓越电能",
	info = function(self, t)
		return ([[在 %d 回合中你的电能突破极限，增加你的闪电伤害 %d%% ，闪电抗性穿透 %d%% 。
		额外效果：
		重置电能护盾，电能吸取，充能光环和头脑风暴的冷却时间。
		根据情况，充能光环获得其中一种强化：充能光环的半径增加为 2 格。你的所有武器获得充能光环的伤害加成。
		你的电能护盾获得 100%% 的吸收效率，并可以吸收两倍伤害。
		头脑风暴附带致盲效果。
		电能吸取附带混乱效果（ %d%% 概率）。
		电能打击的第二次闪电 / 致盲攻击将会对半径 3 格之内的最多 3 名敌人产生连锁反应。
		受精神强度影响，伤害和抗性穿透有额外加成。
		同一时间只有一个卓越技能产生效果。]]):format(t.getDuration(self, t), t.getPower(self, t), t.getPenetration(self, t), t.getConfuse(self, t))
	end,
}

registerTalentTranslation{
	id = "T_THOUGHT_SENSE",
	name = "心电感应",
	info = function(self, t)
		return ([[感知半径 %d 范围内生物的精神活动，效果持续 %d 回合。
		这个技能暴露他们的位置，并增加你的防御 %d 。
		受精神强度影响，持续时间、闪避、和半径有额外加成。]]):format(t.radius(self, t), t.getDuration(self, t), t.getDefense(self, t))
	end,
}

registerTalentTranslation{
	id = "T_STATIC_NET",
	name = "静电网络",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[在半径 %d 范围中散布一个持续 %d 回合的静电捕网。
		站在网中的敌人受到 %0.1f 的闪电伤害并被减速 %d%% 。
		当你在网中穿梭，你的武器上会逐渐累加静电充能，让你的下一次攻击造成额外 %0.1f 的闪电伤害。
		受精神强度影响，技能效果有额外加成。]]):
		format(self:getTalentRadius(t), duration, damDesc(self, DamageType.LIGHTNING, damage), t.getSlow(self, t), damDesc(self, DamageType.LIGHTNING, t.getWeaponDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_HEARTSTART",
	name = "心跳复苏",
	info = function(self, t)
		return ([[储存一次电力充能用来在之后挽救你的生命。
		当这个技能激活时，如果你的生命值被减低到 0 以下，这个技能将会进入冷却，解除你的震慑 / 晕眩 / 冰冻状态，使你的生命值最多为 - %d 时不会死亡，效果持续 %d 回合。
		受精神强度和最大生命值影响，承受的致命伤害有额外加成。.]]):
		format(t.getPower(self, t), t.getDuration(self, t))
	end,
}


return _M
