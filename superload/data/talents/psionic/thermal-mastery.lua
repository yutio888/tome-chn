local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TRANSCENDENT_PYROKINESIS",
	name = "卓越热能",
	info = function(self, t)
		return ([[在 %d 回合中你的热能突破极限，增加你的火焰和寒冷伤害 %d%% ，火焰和寒冷抗性穿透 %d%% 。
		额外效果：
		重置热能护盾，热能吸取，热能光环和意念风暴的冷却时间。
		根据情况，热能光环获得其中一种强化：热能光环的半径增加为 2 格。你的所有武器获得热能光环的伤害加成。
		你的热能护盾获得 100%% 的吸收效率，并可以吸收两倍伤害。
		意念风暴附带火焰冲击效果。
		热能吸取将会降低敌人的伤害 %d%% 。
		热能打击的第二次寒冷 / 冻结攻击将会产生半径为 1 的爆炸。
		受精神强度影响，伤害和抗性穿透有额外加成。
		同一时间只有一个超能系技能产生效果。]]):format(t.getDuration(self, t), t.getPower(self, t), t.getPenetration(self, t), t.getDamagePenalty(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BRAINFREEZE",
	name = "锁脑极寒",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[迅速的抽取敌人大脑的热量，造成 %0.1f 寒冷伤害。
		受到技能影响的生物将被锁脑四回合，随机技能进入冷却，并冻结冷却时间。
		受精神强度影响，伤害和锁脑几率有额外加成。]]):
		format(damDesc(self, DamageType.COLD, dam))
	end,
}

registerTalentTranslation{
	id = "T_HEAT_SHIFT",
	name = "热能转移",
	info = function(self, t)
		local dur = t.getDuration(self, t)
		local rad = self:getTalentRadius(t)
		local dam = t.getDamage(self, t)
		return ([[在半径 %d 范围内，将所有敌人身上的热量转移到武器上，把敌人冻僵在地面，多余的热量则令他们无法使用武器和盔甲。 
		造成 %0.1f 寒冷伤害和 %0.1f 火焰伤害，并对敌人施加定身（冻足）和缴械状态，持续 %d 回合。
		受到两种伤害影响的单位也会降低 %d 护甲和豁免。
		受精神强度影响，施加状态的几率和持续时间有额外加成。]]):
		format(rad, damDesc(self, DamageType.COLD, dam), damDesc(self, DamageType.FIRE, dam), dur, t.getArmor(self, t))
	end,
}

registerTalentTranslation{
	id = "T_THERMAL_BALANCE",
	name = "热能平衡",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local dam1 = dam * (self:getMaxPsi() - self:getPsi()) / self:getMaxPsi()
		local dam2 = dam * self:getPsi() / self:getMaxPsi()
		return ([[根据当前的意念力水平，你在火焰和寒冷中寻求平衡。
		你对敌人施放一次爆炸，根据当前的意念力造成 %0.1f 火焰伤害，根据意念力最大值与当前值的差值造成 %0.1f 寒冷伤害，爆炸半径为 %d 。
		这个技能会使你当前的意念力变为最大值的一半。
		受精神强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.FIRE, dam2), damDesc(self, DamageType.COLD, dam1), self:getTalentRadius(t))
	end,
}


return _M
