local _M = loadPrevious(...)

local function aura_mastery(self, t)
	return 0.5 --9 + self:getTalentLevel(t) * 2
end

registerTalentTranslation{
	id = "T_KINETIC_AURA",
	name = "动能光环",
	info = function(self, t)
		local dam = t.getAuraStrength(self, t)
		local spikedam = t.getAuraSpikeStrength(self, t)
		local mast = aura_mastery(self, t)
		local spikecost = t.getSpikeCost(self, t)
		return ([[将你周围的空气充满能量力场。
		 如果你的灵能武器槽佩戴的是宝石或者灵晶，会对所有接近的目标造成 %0.1f 的物理伤害。
		 动能光环造成的伤害会吸收能量，每造成 %0.1f 点伤害就吸收一点能量。
		 如果你的灵能武器槽佩戴的是武器，每次攻击附加 %0.1f 的物理伤害。
		 当关闭该技能时，如果你拥有最少 %d 点能量，巨大的动能会释放为一个射程为 %d 的射线，击打目标，造成高达 %d 的物理伤害，并击飞他们。
		 #{bold#激活光环是不消耗时间的，但是关闭它则需要消耗时间。#{normal#
		 如果要关闭光环且不发射射线，关闭它并选择你自己为目标。伤害随着精神强度而增长。]]):
		format(damDesc(self, DamageType.PHYSICAL, dam), mast, damDesc(self, DamageType.PHYSICAL, dam), spikecost, t.getSpikedRange(self, t),
		damDesc(self, DamageType.PHYSICAL, spikedam))
	end,
}

registerTalentTranslation{
	id = "T_THERMAL_AURA",
	name = "热能光环",
	info = function(self, t)
		local dam = t.getAuraStrength(self, t)
		local rad = t.getSpikedRadius(self,t)
		local spikedam = t.getAuraSpikeStrength(self, t)
		local mast = aura_mastery(self, t)
		local spikecost = t.getSpikeCost(self, t)
		return ([[将你周围的空气充满火炉般的热量。
		 如果你的灵能武器槽佩戴的是宝石或灵晶，会对所有接近的目标造成 %0.1f 的火焰伤害。
		 热能光环造成的伤害会吸收能量，每造成 %0.1f 点伤害吸收一点能量。
		 如果你的灵能武器槽佩戴的是武器，每次攻击附加 %0.1f 的火焰伤害。
		 当关闭该技能时，如果你拥有最少 %d 点能量，巨大的热能会释放为一个范围为 %d 的锥形冲击。范围内的任意目标在数轮中受到高达 %d 的火焰伤害。
		#{bold#激活光环是不消耗时间的，但是关闭它则需要消耗时间。#{normal#
		 如果要关闭光环且不发射射线，关闭它并选择你自己为目标。伤害随着精神强度而增长。]]):
		format(damDesc(self, DamageType.FIRE, dam), mast, damDesc(self, DamageType.FIRE, dam), spikecost, rad,
		damDesc(self, DamageType.FIRE, spikedam))
	end,
}

registerTalentTranslation{
	id = "T_CHARGED_AURA",
	name = "充能光环",
	info = function(self, t)
		local dam = t.getAuraStrength(self, t)
		local spikedam = t.getAuraSpikeStrength(self, t)
		local mast = aura_mastery(self, t)
		local spikecost = t.getSpikeCost(self, t)
		local nb = t.getNumSpikeTargets(self, t)
		return ([[将你周围的空气充满噼啪响的电能。
		 如果你的灵能武器槽佩戴的是宝石或灵晶，会对所有接近的目标造成 %0.1f 的闪电伤害。
		 电能光环造成的伤害会吸收能量，每造成 %0.1f 点伤害吸收一点能量。
		 如果你的灵能武器槽佩戴的是武器，每次攻击附加 %0.1f 的闪电伤害。
		 当关闭该技能时，如果你拥有最少 %d 点能量，巨大的电能会释放为在最多 %d 个邻近目标间跳跃的闪电，对每个目标造成 %0.1f 的闪电伤害，且 50%% 的概率令他们眩晕。
		#{bold#激活光环是不消耗时间的，但是关闭它则需要消耗时间。#{normal#
		 如果要关闭光环且不发射射线，关闭它并选择你自己为目标。伤害随着精神强度而增长。]]):
		format(damDesc(self, DamageType.LIGHTNING, dam), mast, damDesc(self, DamageType.LIGHTNING, dam), spikecost, nb, damDesc(self, DamageType.LIGHTNING, spikedam))
	end,
}

registerTalentTranslation{
	id = "T_FRENZIED_FOCUS",
	name = "灵能狂热",
	info = function(self, t)
		local targets = t.getTargNum(self,t)
		local dur = t.duration(self,t)
		return ([[超载你的心灵聚焦 %d 轮，造成特殊效果。
		 心灵传动武器进入狂怒中，每轮最多攻击 %d 个目标，同时增加 %d 格攻击范围。
		 灵晶和宝石会对一个距离 6 以内的随机敌人发射一个能量球，造成每轮 %0.1f 的伤害。伤害类型取决于宝石的颜色。伤害随着精神强度增长。]]):
		format(dur, targets, targets, t.getDamage(self,t))
	end,
}


return _M
