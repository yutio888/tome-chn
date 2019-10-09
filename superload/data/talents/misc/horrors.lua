local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FRENZIED_BITE",
	name = "狂乱撕咬",
	message = "@Source@ 在狂乱中撕咬了 @Target@!",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local bleed = t.getBleedDamage(self, t) * 100
		local heal_penalty = t.getHealingPenalty(self, t)
		return ([[撕咬目标造成 %d%% 武器伤害。减少目标治疗效果 %d%% 并造成 %d%% 武器伤害的流血伤害持续 5 回合。 
		 只有在狂乱状态下可以使用。]]):format(damage, heal_penalty, bleed)
	end,
}

registerTalentTranslation{
	id = "T_FRENZIED_LEAP",
	name = "狂乱跳跃",
	message = "@Source@ 在狂乱中跳跃!",
	info = function(self, t)
		return ([[跳向范围内目标。只有在狂乱状态下可以使用。]])
	end,
}

registerTalentTranslation{
	id = "T_GNASHING_TEETH",
	name = "咬牙切齿",
	message = "@Source@ 用尖牙利齿咬向 @Target@ !",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local bleed = t.getBleedDamage(self, t) * 100
		local power = t.getPower(self, t) *100
		return ([[ 咬伤目标，造成 %d%% 武器伤害，可能让目标进入流血状态，在五回合内造成 %d%% 武器伤害。 
		 如果目标进入流血状态，吞噬者会进入狂热状态 %d 回合（也会让周围的其他吞噬者进入狂热状态）。
		 狂热状态会增加整体速度 %d%% , 物理暴击率 %d%% , 同时降至 -%d%% 生命时才会死去。]]):
		format(damage, bleed, t.getDuration(self, t), power, power, power)
	end,
}

registerTalentTranslation{
	id = "T_ABYSSAL_SHROUD",
	name = "堕入深渊",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		local light_reduction = t.getLiteReduction(self, t)
		local darkness_resistance = t.getDarknessPower(self, t)
		return ([[制造一个 3 码范围的黑暗深渊持续 %d 回合。深渊会造成每回合 %0.2f 黑暗伤害并降低 %d 光照范围，同时使其中生物的暗影抵抗减少 %d%% 。]]):
		format(duration, damDesc(self, DamageType.DARKNESS, (damage)), light_reduction, darkness_resistance)
	end,
}

registerTalentTranslation{
	id = "T_ECHOES_FROM_THE_VOID",
	name = "虚空回音",
	message = "@Source@ 向 @Target@ 展示了虚空的混乱。",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[ 释放虚空的混乱，使目标每回合强制进行精神豁免鉴定，持续 6 回合，未通过豁免则在原伤害基础上造成 %0.2f 精神伤害（由精神和自然伤害基础伤害决定）。]]):
		format(damDesc(self, DamageType.MIND, (damage)))
	end,
}

registerTalentTranslation{
	id = "T_VOID_SHARDS",
	name = "虚空碎片",
	message = "@Source@ 召唤出虚空碎片。",
	info = function(self, t)
		local number = self:getTalentLevelRaw(t)
		local damage = t.getDamage(self, t)
		local explosion = t.getExplosion(self, t)
		return ([[召唤 %d 个虚空碎片。碎片会进入不稳定状态，造成每回合 %0.2f 时空伤害持续 5 回合。它们在不稳定状态下死亡会发生爆炸造成 4 码范围 %0.2f 时空和 %0.2f 物理伤害。]]):
		format(number, damDesc(self, DamageType.TEMPORAL, (damage)), damDesc(self, DamageType.TEMPORAL, (explosion/2)), damDesc(self, DamageType.PHYSICAL, (explosion/2)))
	end,
}

--registerTalentTranslation{
--	id = "T_WORM_ROT",
--	name = "腐烂蠕虫",
--	info = function(self, t)
--		local duration = t.getDuration(self, t)
--		local damage = t.getDamage(self, t)
--		local burst = t.getBurstDamage(self, t)
--		return ([[使目标感染腐肉寄生幼虫持续 %d 回合。每回合会移除目标一个物理增益效果并造成 %0.2f 酸系和 %0.2f 枯萎伤害。 
--		 如果 5 回合后未被清除则幼虫会孵化造成 %0.2f 酸系伤害，移除这个效果但是会在目标处成长为一条成熟的腐肉虫。]]):
--		format(duration, damDesc(self, DamageType.ACID, (damage/2)), damDesc(self, DamageType.BLIGHT, (damage/2)), damDesc(self, DamageType.ACID, (burst)))
--	end,
--}

registerTalentTranslation{
	id = "T_KNIFE_STORM",
	name = "刀刃风暴",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[ 召唤旋转剑刃风暴将敌人切成碎片，对进入风暴的敌人造成 %d 点物理伤害并令其流血 %d 回合。 
		 受精神强度影响，伤害和流血持续时间有额外加成。 ]]):format(damDesc(self, DamageType.PHYSICAL, damage), duration)
	end,
}

registerTalentTranslation{
	id = "T_PSIONIC_PULL",
	name = "念力牵引",
	info = function(self, t)
		return ([[将 5 码范围内的目标拉向你并造成 %d 物理伤害。 
		 受精神强度影响，伤害有额外加成。]]):format(damDesc(self, DamageType.PHYSICAL, self:combatTalentMindDamage(t, 20, 120)))
	end,
}

registerTalentTranslation{
	id = "T_RAZOR_KNIFE",
	name = "刀锋之刃",
	info = function(self, t)
		return ([[对一条直线目标发射一把锋利的刀刃造成 %0.2f 物理伤害。 
		 受精神强度影响，伤害有额外加成。]]):format(damDesc(self, DamageType.PHYSICAL, self:combatTalentMindDamage(t, 20, 200)))
	end,
}

registerTalentTranslation{
	id = "T_SLIME_WAVE",
	name = "史莱姆冲击波",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 1 码范围内形成一个史莱姆墙，每隔 2 回合范围会扩大，直至 %d 码，造成 %0.2f 史莱姆伤害持续 %d 回合。 
		 受精神强度影响，伤害及持续时间有额外加成。]]):
		format(radius, damDesc(self, DamageType.NATURE, damage), duration)
	end,
}

registerTalentTranslation{
	id = "T_TENTACLE_GRAB",
	name = "触须之握",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[抓住一个目标并将其拉至身边，并抓取 %d 回合。需要呼吸的非亡灵类生物还会被窒息。
		 同时每回合造成 %0.2f 史莱姆伤害。 
		 受精神强度影响，伤害有额外加成。]]):
		format(duration, damDesc(self, DamageType.SLIME, damage))
	end,
}

registerTalentTranslation{
	id = "T_OOZE_SPIT",
	name = "凝胶喷射",
	info = function(self, t)
		return ([[向目标喷射毒液造成 %0.2f 自然伤害并降低其 30%% 移动速度持续 3 回合。 
		 受敏捷影响，伤害有额外加成。]]):format(damDesc(self, DamageType.NATURE, self:combatTalentStatDamage(t, "dex", 30, 290)))
	end,
}

registerTalentTranslation{
	id = "T_OOZE_ROOTS",
	name = "史莱姆迁移",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local radius = self:getTalentRadius(t)
		return ([[变成史莱姆遁入地下，并在 %d 至 %d 范围内重新出现。]]):format(range, radius)
	end,
}

registerTalentTranslation{
	id = "T_ANIMATE_BLADE",
	name = "虚空利刃",
	info = function(self, t)
		return ([[划破空间，从异次元召唤出一把虚空利刃，持续 10 回合。]])
	end,
}


registerTalentTranslation{
	id = "T_DRENCH",
	name = "浸湿",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在你身边 %d 范围内制造水流，令所有生物湿润。
		效果受法术强度加成。]]):format(radius)
	end,
}

registerTalentTranslation{
	id = "T_BLOOD_SUCKERS",
	name = "吸血者",
	message = "@Source@ 尝试吸取血液!",
	info = function(self, t)
		local Pdam, Fdam = self:damDesc(DamageType.PHYSICAL, self.level/2), self:damDesc(DamageType.ACID, self.level/2)
		return ([[抓住目标，吸取他们的血液，每回合造成 %0.2f 物理和 %0.2f 酸性伤害。
		5 回合后脱落并繁殖。
		伤害随等级上升。
		]]):format(Pdam, Fdam)
	end,
}

return _M
