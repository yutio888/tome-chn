local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SPACETIME_TUNING",
	name = "时空协调",
	info = function(self, t)
		local tune = t.getTuning(self, t)
		local preference = self.preferred_paradox
		local sp_modifier = getParadoxModifier(self, t) * 100
		local spellpower = getParadoxSpellpower(self, t)
		local after_will, will_modifier, sustain_modifier = self:getModifiedParadox()
		local anomaly = self:paradoxFailChance()
		return ([[设置自己的紊乱值。
		休息或等待时，你每回合将自动调节 %d 点紊乱值趋向于你的设定值。
		你的紊乱值会修正所有时空法术的持续时间和法术强度。
		设定的紊乱值:  %d
		紊乱值修正率:  %d%%
		时空法术强度:  %d
		意志修正数值: -%d
		紊乱维持数值: +%d
		修正后紊乱值:  %d
		当前异常几率:  %d%%]]):format(tune, preference, sp_modifier, spellpower, will_modifier, sustain_modifier, after_will, anomaly)
	end,
}

-- Talents from older versions to keep save files compatable
registerTalentTranslation{
	id = "T_SLOW",
	name = "扭曲力场",
	info = function(self, t)
		local slow = t.getSlow(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		return ([[在 %d 码半径范围内制造 1 个时间扭曲力场，持续 %d 回合。同时减少 %d%% 目标整体速度，持续 3 回合，当目标处于此范围内时每回合造成 %0.2f 时空伤害。 
		 受法术强度影响，减速效果和伤害有额外加成。]]):
		format(radius, duration, 100 * slow, damDesc(self, DamageType.TEMPORAL, damage))
	end,
}

registerTalentTranslation{
	id = "T_SPACETIME_MASTERY",
	name = "时空掌握",
	info = function(self, t)
		local cooldown = t.cdred(self, t, 10)
		local wormhole = t.cdred(self, t, 20)
		return ([[你对时空的掌握让你减少空间跳跃、时空放逐、时空交换、时空觉醒的冷却时间 %d 个回合，减少虫洞跃迁的冷却时间 %d 个  回合。同时当你对目标使用可能造成连续紊乱的技能（时空放逐、时间跳跃）时增加 %d%% 的法术强度。]]):
		format(cooldown, wormhole, t.getPower(self, t)*100)

	end,
}

registerTalentTranslation{
	id = "T_QUANTUM_FEED",
	name = "量子充能",
	info = function(self, t)
		local power = t.getPower(self, t)
		return ([[你已经学会通过控制时空的流动来增强魔力。 
		 增加 %d 点魔法和法术豁免。 
		 受意志影响，效果按比例加成。]]):format(power)
	end,
}

registerTalentTranslation{
	id = "T_MOMENT_OF_PRESCIENCE",
	name = "预知之门",
	info = function(self, t)
		local power = t.getPower(self, t)
		local duration = t.getDuration(self, t)
		return ([[你集中意识提升你的潜行侦测、隐形侦测、闪避和命中几率 %d 持续 %d 回合。 
		 如果你已经激活了命运之网技能，你将得到一个基于 50%% 命运之网获得提升点数的增益。 
		 此技能不需要施法时间。]]):
		format(power, duration)
	end,
}

registerTalentTranslation{
	id = "T_GATHER_THE_THREADS",
	name = "聚集螺旋",
	info = function(self, t)
		local primary = t.getThread(self, t)
		local reduction = t.getReduction(self, t)
		return ([[你开始从其他时间线搜集能量，初始增加 %0.2f 法术强度并且每回合逐渐增加 %0.2f 法术强度。 
		 此效果会因为使用技能而中断，否则此技能会在 5 回合后结束。 
		 当此技能激活时，每回合你的紊乱值会降低 %d 点。 
		 此技能不会打断时空调谐，激活时空调谐技能也同样不会打断此技能。]]):format(primary + (primary/5), primary/5, reduction)
	end,
}

registerTalentTranslation{
	id = "T_ENTROPIC_FIELD",
	name = "熵光领域",
	info = function(self, t)
		local power = t.getPower(self, t)
		return ([[制造一个领域围绕自己，减少所有抛射物 %d%% 的速度并增加 %d%% 物理伤害抵抗。 
		 受法术强度影响，效果按比例加成。]]):format(power, power / 2)
	end,
}

registerTalentTranslation{
	id = "T_FADE_FROM_TIME",
	name = "时光凋零",
	info = function(self, t)
		local resist = t.getResist(self, t)
		local dur = t.getdurred(self,t)
		return ([[你将部分身体移出时间线，持续 10 回合.
		 增加你 %d%% 所有伤害抵抗，减少 %d%% 负面状态持续时间并减少 20%% 你造成的伤害。 
		 抵抗加成、状态减少值和伤害惩罚会随法术持续时间的增加而逐渐减少。 
		 受法术强度影响，效果按比例加成。]]):
		format(resist, dur)
	end,
}

registerTalentTranslation{
	id = "T_PARADOX_CLONE",
	name = "无序克隆",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[你召唤未来的自己和你一起战斗，持续 %d 回合。当技能结束后，在未来的某个时间点，你会被拉回到过去，协助你自己战斗。 
		 这个法术会使时间线分裂，所以其他同样能使时间线分裂的技能在此期间不能成功释放。 ]]):format(duration)
	end,
}

registerTalentTranslation{
	id = "T_DISPLACE_DAMAGE",
	name = "伤害转移",
	info = function(self, t)
		local displace = t.getDisplaceDamage(self, t) * 100
		return ([[空间在你身边折叠，转移 %d%% 伤害到范围内随机 1 个敌人身上。
		]]):format(displace)
	end,
}

registerTalentTranslation{
	id = "T_REPULSION_FIELD",
	name = "排斥之环",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[你用 %d 码半径范围的重力吸收光环围绕自己，击退所有单位并造成 %0.2f 物理伤害。此效果持续 %d 回合。对定身状态目标额外造成 50%% 伤害。 
		 这股爆炸性冲击波可能会对目标造成多次伤害，这取决于攻击半径和击退效果。 
		 受法术强度影响，伤害按比例加成。]]):format(radius, damDesc(self, DamageType.PHYSICAL, damage), duration)
	end,
}

registerTalentTranslation{
	id = "T_TEMPORAL_CLONE",
	name = "时空复制",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage_penalty = t.getDamagePenalty(self, t)
		return ([[你复制目标，从其他时间线上召唤出复制体，持续 %d 回合。持续时间将会除以目标分级的一半，且复制体只拥有目标 %d%% 的生命，造成的伤害减少 %d%% 。
		如果你复制了一个敌人，复制体会立刻瞄准那个被你复制的敌人。 
		受法术强度加成，生命值和伤害惩罚按比例减小。]]):
		format(duration, 100 - damage_penalty, damage_penalty)
	end,
}

registerTalentTranslation{
	id = "T_DAMAGE_SMEARING",
	name = "时空转化",
	info = function(self, t)
		local percent = t.getPercent(self, t) * 100
		local duration = t.getDuration(self, t)
		return ([[你转化所有受到的 %d%% 的非时空伤害为持续 %d 回合的时空伤害释放出去。 
		 造成的伤害无视抗性和伤害吸收。]]):format(percent, duration)
	end,
}

registerTalentTranslation{
	id = "T_PHASE_SHIFT",
	name = "相位切换",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[切换你的相位 %d 回合；任何将会对你造成超过你最大生命值 10%% 伤害的攻击会把你传送到一个相邻的格子里，并且这次伤害减少50%% （每回合只能发生一次）。]]):
		format(duration)
	end,
}

registerTalentTranslation{
	id = "T_SWAP",
	name = "时空交换",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local duration = t.getConfuseDuration(self, t)
		local power = t.getConfuseEfficency(self, t)
		return ([[你控制时间的流动来使你和 %d 码范围内的某个怪物交换位置。目标会混乱（ %d%% 强度） %d 回合。 
		 受法术强度影响，法术命中率有额外加成。]]):format (range, power, duration)
	end,
}

registerTalentTranslation{
	id = "T_TEMPORAL_WAKE",
	name = "时空苏醒",
	info = function(self, t)
		local stun = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[暴力地折叠你和另外一个点之间的空间。你传送到目标地点并造成时空的苏醒，震慑路径上的所有目标 %d 回合并造成 %0.2f 时空伤害和 %0.2f 物理（折叠）伤害 
		 受法术强度影响，伤害按比例加成。]]):
		format(stun, damDesc(self, DamageType.TEMPORAL, damage/2), damDesc(self, DamageType.PHYSICAL, damage/2))
	end,
}

registerTalentTranslation{
	id = "T_CARBON_SPIKES",
	name = "碳化钉刺",
	info = function(self, t)
		local damage = t.getDamageOnMeleeHit(self, t)
		local armor = t.getArmor(self, t)
		return ([[脆弱的碳化钉刺从你的肉体、衣服和护甲中伸出来，增加 %d 点护甲值。同时，在 6 回合内对攻击者造成总计 %0.2f 点流血伤害。每次你受到攻击时，护甲增益效果减少 1 点。每回合会自动回复 1 点护甲增益至初始效果。 
		 如果护甲增益降到 1 点以下，则技能会被中断，效果结束。 
		 受法术强度影响，护甲增益和流血伤害有额外加成。]]):
		format(armor, damDesc(self, DamageType.PHYSICAL, damage))
	end,
}

registerTalentTranslation{
	id = "T_DESTABILIZE",
	name = "时空裂隙",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local explosion = t.getExplosion(self, t)
		return ([[使目标所处的时空出现裂隙，每回合造成 %0.2f 时空伤害，持续 10 回合。如果目标在被标记时死亡，则会产生 4 码半径范围的时空爆炸，造成 %0.2f 时空伤害和 %0.2f 物理伤害。 
		 如果目标死亡时处于连续紊乱状态，则爆炸产生的所有伤害会转化为时空伤害。 
		 受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.TEMPORAL, damage), damDesc(self, DamageType.TEMPORAL, explosion/2), damDesc(self, DamageType.PHYSICAL, explosion/2))
	end,
}

registerTalentTranslation{
	id = "T_QUANTUM_SPIKE",
	name = "量子钉刺",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[试图将目标分离为分子状态，造成 %0.2f 时空伤害和 %0.2f 物理伤害 , 技能结束后若目标生命值不足 20%% 则可能会被立刻杀死。 
		 量子钉刺对受时空紊乱和 / 或连续紊乱的目标会多造成 50％的伤害。 
		 受和法术强度影响，伤害按比例加成。]]):format(damDesc(self, DamageType.TEMPORAL, damage/2), damDesc(self, DamageType.PHYSICAL, damage/2))
	end,
}

return _M
