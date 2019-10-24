local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MULTIPLY",
	name = "繁殖",
	info = function(self, t)
		return ([[复制你自身！ (最多 %d 次)]]):format(self.can_multiply or 0)
	end,
}

registerTalentTranslation{
	id = "T_CRAWL_POISON",
	name = "毒爪",
	message = "@Source@ 用毒液覆盖 @target@ 。",
	info = function(self, t)
		return ([[爪击你的目标造成 %d%% 毒素伤害并使目标中毒。]]):
		format(100*t.getMult(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CRAWL_ACID",
	name = "酸爪",
	message = "@Source@ 用酸液覆盖 @target@ 。",
	info = function(self, t)
		return ([[爪击你的目标并附带酸性效果。]])
	end,
}

registerTalentTranslation{
	id = "T_SPORE_BLIND",
	name = "致盲孢子",
	message = "@Source@ 向 @target@ 喷射致盲孢子。",
	info = function(self, t)
		return ([[向目标喷射孢子，使目标致盲 %d 回合。]]):
		format(t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SPORE_POISON",
	name = "毒性喷射",
	message = "@Source@ 向 @target@ 喷射毒性孢子。",
	info = function(self, t)
		return ([[向目标喷射毒性孢子，造成 %d%% 伤害并使其中毒。]]):
		format(100 * t.getMult(self, t))
	end,
}

registerTalentTranslation{
	id = "T_STUN",
	name = "震慑",
	info = function(self, t)
		return ([[攻击目标造成 %d%% 伤害。如果攻击命中则可震慑目标 %d 回合。 
		受物理强度影响，震慑几率有额外加成。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 1), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DISARM",
	name = "缴械",
	info = function(self, t)
		return ([[攻击目标造成 %d%% 伤害，并试图缴械目标 %d 回合。 
		受物理强度影响，缴械几率有额外加成。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 1), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CONSTRICT",
	name = "压迫",
	info = function(self, t)
		return ([[攻击目标造成 %d%% 伤害，如果攻击命中则可令目标进入压迫状态 %d 回合。 
		受物理强度影响，压迫强度有额外加成]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 1), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_KNOCKBACK",
	name = "击退",
	info = function(self, t)
		return ([[使用武器打击目标造成 %d%% 伤害，如果攻击命中则可击退目标至多 4 格。 
		受物理强度影响，击退几率有额外加成。]]):format(100 * self:combatTalentWeaponDamage(t, 1.5, 2))
	end,
}

registerTalentTranslation{
	id = "T_BITE_POISON",
	name = "毒性撕咬",
	message = "@Source@ 向 @target@ 注入毒液。",
	info = function(self, t)
		return ([[撕咬目标，造成 %d%% 徒手伤害并使其中毒。]]):format(100 * t.getMult(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SUMMON",
	name = "召唤",
	info = function(self, t)
		return ([[召唤随从。]])
	end,
}

registerTalentTranslation{
	id = "T_ROTTING_DISEASE",
	name = "腐烂疫病",
	message = "@Source@ 向@target@传播疾病。",
	info = function(self, t)
		return ([[打击目标造成 %d%% 伤害，如果攻击命中可使目标感染疾病，造成每回合 %0.2f 枯萎伤害持续 %d 回合并降低其体质。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 1),damDesc(self, DamageType.BLIGHT,t.getDamage(self, t)),t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DECREPITUDE_DISEASE",
	name = "衰老疫病",
	message = "@Source@ 向@target@传播疾病。",
	info = function(self, t)
		return ([[打击目标造成 %d%% 伤害，如果攻击命中可使目标感染疾病，造成每回合 %0.2f 枯萎伤害持续 %d 回合并降低其敏捷。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 1),damDesc(self, DamageType.BLIGHT,t.getDamage(self, t)),t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WEAKNESS_DISEASE",
	name = "衰弱疫病",
	message = "@Source@ 向@target@传播疾病。",
	info = function(self, t)
		return ([[打击目标造成 %d%% 伤害，如果攻击命中可使目标感染疾病，造成每回合 %0.2f 枯萎伤害持续 %d 回合并降低其力量。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.5, 1),damDesc(self, DamageType.BLIGHT,t.getDamage(self, t)),t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_MIND_DISRUPTION",
	name = "精神崩溃",
	info = function(self, t)
		return ([[试图使目标混乱 %d 回合 (强度 %d%%)。]]):format(t.getDuration(self, t), t.getConfusion(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WATER_BOLT",
	name = "水弹",
	info = function(self, t)
		return ([[浓缩周围的水份形成水弹攻击目标造成 %0.1f 冰冻伤害。
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.COLD,t.getDamage(self, t)))
	end,
}

name = "Flame Bolt"
registerTalentTranslation{
	id = "T_FLAME_BOLT",
	name = "火焰箭",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[释放火焰箭，在 3 回合内对目标造成 %0.2f 点伤害。
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.FIRE, damage))
	end,
}

registerTalentTranslation{
	id = "T_ICE_BOLT",
	name = "寒冰箭",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[释放寒冰箭，对目标造成 %0.2f 点冰冻伤害。
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.COLD, damage))
	end,
}

registerTalentTranslation{
	id = "T_BLIGHT_BOLT",
	name = "枯萎箭",
	info = function(self, t)
		return ([[释放枯萎箭，对目标造成 %0.2f 点枯萎伤害。
		该法术的暴击率增加 %0.2f%% 。
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 1, 180)), t.getCritChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WATER_JET",
	name = "水之喷射",
	info = function(self, t)
		return ([[浓缩周围的水份喷射目标造成 %0.1f 冰冻伤害并震慑目标 4 回合。 
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.COLD,t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_VOID_BLAST",
	name = "虚空爆炸",
	info = function(self, t)
		return ([[施放虚空能量形成爆炸气旋向目标缓慢移动，对途径目标造成 %0.2f 奥术伤害。 
		受法术强度影响，伤害有额外加成。]]):format(damDesc(self, DamageType.ARCANE, self:combatTalentSpellDamage(t, 15, 240)))
	end,
}

registerTalentTranslation{
	id = "T_RESTORATION",
	name = "自然治愈",
	info = function(self, t)
		local curecount = t.getCureCount(self, t)
		return ([[召唤自然的力量治愈你的身体，移除 %d 个毒素和疫病不良效果。]]):
		format(curecount)
	end,
}

registerTalentTranslation{
	id = "T_REGENERATION",
	name = "再生",
	info = function(self, t)
		local regen = t.getRegeneration(self, t)
		return ([[召唤自然的力量治愈你的身体，每回合回复 %d 生命值持续 10 回合。 
		受法术强度影响，治疗量有额外加成。]]):
		format(regen)
	end,
}

registerTalentTranslation{
	id = "T_GRAB",
	name = "抓取",
	info = function(self, t)
		return ([[攻击目标造成 %d%% 伤害，如果攻击命中可定身目标 %d 回合，定身几率受物理强度影响。]]):format(100 * self:combatTalentWeaponDamage(t, 0.8, 1.4), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BLINDING_INK",
	name = "致盲墨汁",
	message = "@Source@ 喷射墨水！",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[向目标喷射黑色墨汁，致盲 %d 锥形范围内目标 %d 回合，致盲几率受物理强度影响。]]):format(t.radius(self, t), duration)
	end,
}

registerTalentTranslation{
	id = "T_SPIT_POISON",
	name = "毒性喷吐",
	info = function(self, t)
		return ([[向目标喷射毒液造成共计 %0.2f 毒素伤害，持续 6 回合。 
		受力量或敏捷（取较高值）影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.POISON, t.getDamage(self,t)))
	end,
}

registerTalentTranslation{
	id = "T_POISON_STRIKE",
	name = "毒性打击",
	info = function(self, t)
		return ([[用毒素攻击目标，在六回合内造成 %0.2f 毒素伤害。
		伤害受精神强度加成]]):
		format(damDesc(self, DamageType.POISON, t.getDamage(self,t)))
	end,
}

registerTalentTranslation{
	id = "T_SPIT_BLIGHT",
	name = "枯萎喷吐",
	info = function(self, t)
		return ([[喷吐目标造成 %0.2f 枯萎伤害。 
		受魔法影响，伤害有额外加成。]]):format(t.getDamage(self,t))
	end,
}

registerTalentTranslation{
	id = "T_RUSHING_CLAWS",
	name = "冲锋抓击",
	info = function(self, t)
		return ([[快速向目标冲锋，并使用爪子将目标定身 5 回合。 
		至少距离目标 2 码以外才能施放。]])
	end,
}

registerTalentTranslation{
	id = "T_THROW_BONES",
	name = "投掷白骨",
	info = function(self, t)
		return ([[向目标投掷白骨造成 %0.2f 物理流血伤害，最远距离 %d 。
		受力量影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_LAY_WEB",
	name = "撒网",
	info = function(self, t)
		local dur = t.getDuration(self, t)
		return ([[投掷一个隐形的蜘蛛网(侦察强度 %d , 解除强度 %d )，持续 %d 回合，困住所有经过它的非蜘蛛生物 %d 回合。]]):
		format(t.getDetect(self, t), t.getDisarm(self, t), dur*5, dur)
	end,
}

registerTalentTranslation{
	id = "T_DARKNESS",
	name = "黑暗",
	info = function(self, t)
		return ([[制造黑暗，阻挡所有光线（强度 %d 范围 %d 码），并能使你传送一小段距离。 
		受敏捷影响，伤害有额外加成。]]):
		format(t.darkPower(self, t), self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_THROW_BOULDER",
	name = "投掷巨石",
	info = function(self, t)
		return ([[向目标投掷一块巨大的石头，造成 %0.2f 伤害并将其击退 %d 码,投掷半径 %d 。 
		受力量影响，伤害有额外加成。]]):format(damDesc(self, DamageType.PHYSICAL, t.getDam(self, t)), t.getDist(self, t), self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_HOWL",
	name = "嚎叫",
	message = "@Source@ 嚎叫",
	info = function(self, t)
		return ([[呼唤同伴回援（范围 %d 码）。]]):
		format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_SHRIEK",
	name = "尖啸",
	message = "@Source@ 尖啸",
	info = function(self, t)
		return ([[呼唤同伴（范围 %d 码）。]]):
		format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_CRUSH",
	name = "压碎",
	info = function(self, t)
		return ([[对目标的腿部进行重击，造成 %d%% 武器伤害，如果攻击命中，则目标无法移动，持续 %d 回合。]]):
		format(100 * self:combatTalentWeaponDamage(t, 1, 1.4), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SILENCE",
	name = "沉默",
	info = function(self, t)
		return ([[施放念力攻击沉默目标 %d 回合，沉默几率受精神强度加成。]]):
		format(t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_TELEKINETIC_BLAST",
	name = "念力爆炸",
	info = function(self, t)
		return ([[施放念力攻击击退目标至多 3 格并造成 %0.2f 物理伤害。 
		受精神强度影响，伤害有额外加成。]]):format(self:damDesc(engine.DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_BLIGHTZONE",
	name = "枯萎区域",
	info = function(self, t)
		return ([[蒸腾目标区域（ 4 码范围）造成每回合 %0.2f 枯萎伤害持续 %d 回合。 
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, engine.DamageType.BLIGHT, self:combatTalentSpellDamage(t, 5, 65)), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_INVOKE_TENTACLE",
	name = "召唤触须",
	info = function(self, t)
		return ([[召唤触须攻击目标。触须死亡时，你受到触须 2/3 生命值的伤害。]])
	end,
}

registerTalentTranslation{
	id = "T_EXPLODE",
	name = "爆炸",
	message = "@Source@ 爆炸! @target@ 被耀眼光芒笼罩。",
	info = function(self, t)
		return ([[使目标爆炸并放出耀眼光芒造成 %d 伤害。]]):
		format(damDesc(self, DamageType.LIGHT, t.getDamage(self, t)))
	end,
}


registerTalentTranslation{
	id = "T_ELEMENTAL_BOLT",
	name = "元素弹",
	message = "@Source@ 释放元素弹!",
	info = function(self, t)
		return ([[发射一枚随机元素属性的魔法飞弹缓慢飞行攻击目标造成 %d 伤害，受魔法影响，伤害有额外加成。]]):
		format(t.getDamage(self, t))
	end,
}

registerTalentTranslation{
	id = "T_VOLCANO",
	name = "火山爆发",
	message = "火山爆发!",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[召唤一个小型火山持续 %d 回合。每回合它会朝你的目标喷射 %d 熔岩，造成 %0.2f 火焰伤害和 %0.2f 物理伤害。 
		受法术强度影响，伤害有额外加成。]]):
		format(t.getDuration(self, t), t.nbProj(self, t), damDesc(self, DamageType.FIRE, dam/2), damDesc(self, DamageType.PHYSICAL, dam/2))
	end,
}

registerTalentTranslation{
	id = "T_SPEED_SAP",
	name = "减速",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[降低目标 30%% 速度，增加你等量的速度，并在 3 回合内造成 %0.2f 时空伤害。]]):format(damDesc(self, DamageType.TEMPORAL, damage))
	end,
}

registerTalentTranslation{
	id = "T_DREDGE_FRENZY",
	name = "挖掘魔狂乱",
	info = function(self, t)
		local range = t.radius(self,t)
		local power = t.getPower(self,t) * 100
		return ([[使 %d 码内的挖掘魔陷入狂乱 %d 回合。
		狂乱会使其全体速度上升 %d%% , 物理暴击提升 %d%% , 生命值直至 -%d%% 才会死亡。]]):		
		format(range, t.getDuration(self, t), power, power, power)
	end,
}

registerTalentTranslation{
	id = "T_SEVER_LIFELINE",
	name = "生命离断",
	info = function(self, t)
		return ([[引导法术离断目标的生命线，如果 4 回合之后目标仍然在视线内则会立即死亡( %d 时空伤害 )。]]):format(damDesc(self, "TEMPORAL", t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_CALL_OF_AMAKTHEL",
	name = "阿玛克塞尔的召唤",
	info = function(self, t)
		return ([[将 10 格内所有敌人往身边拉 1 格。]])
	end,
}

registerTalentTranslation{
	id = "T_GIFT_OF_AMAKTHEL",
	name = "阿玛克塞尔的礼物",
	info = function(self, t)
		return ([[召唤一只黏糊糊的爬虫 10 回合。]])
	end,
}

registerTalentTranslation{
	id = "T_STRIKE",
	name = "怒火石拳",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[制造一个石拳造成 %0.2f 物理伤害并击退目标 3 格。 
		受法术强度影响，伤害有额外加成。]]):format(damDesc(self, DamageType.PHYSICAL, damage))
	end,
}

registerTalentTranslation{
	id = "T_CORROSIVE_VAPOUR",
	name = "腐蚀酸雾",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[在 3 码半径范围内升起一片腐蚀性的酸雾，造成 %0.2f 毒系伤害，持续 %d 回合。 
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.ACID, damage), duration)
	end,
}

registerTalentTranslation{
	id = "T_MANAFLOW",
	name = "法力涌动",
	info = function(self, t)
		local restoration = t.getManaRestoration(self, t)
		return ([[将自己包围在法力的河水中，每回合回复 %d 点法力值，持续 10 回合。 
		受法术强度影响，法力回复有额外加成。]]):
		format(restoration)
	end,
}

registerTalentTranslation{
	id = "T_INFERNAL_BREATH",
	name = "炼狱吐息",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[对 %d 码范围吐出黑暗之火。所有非恶魔生物受到 %0.2f 火焰伤害，并在接下来继续造成每回合 %0.2f 的持续火焰伤害。恶魔则会治疗同等数值的生命值。 
		受力量影响，伤害有额外加成。]]):
		format(radius, damDesc(self, DamageType.FIRE, self:combatTalentStatDamage(t, "str", 30, 350)), damDesc(self, DamageType.FIRE, self:combatTalentStatDamage(t, "str", 30, 70)))
	end,
}

registerTalentTranslation{
	id = "T_FROST_HANDS",
	name = "霜冻之手",
	info = function(self, t)
		local icedamage = t.getIceDamage(self, t)
		local icedamageinc = t.getIceDamageIncrease(self, t)
		return ([[将你的双手笼罩在寒冰之中每次近战攻击造成 %0.2f 冰冷伤害，并提高 %d%% 冰冷伤害。 
		受法术强度影响，效果有额外加成。]]):
		format(damDesc(self, DamageType.COLD, icedamage), icedamageinc, self:getTalentLevel(t) / 3)
	end,
}

registerTalentTranslation{
	id = "T_METEOR_RAIN",
	name = "流星雨",
	info = function(self, t)
		local dam = t.getDamage(self, t)/2
		return ([[使用奥术力量召唤 %d 个陨石，冲击地面对 2 码范围内造成 %0.2f 火焰和 %0.2f 物理伤害。 
		被击中的地面同时形成熔岩持续 8 回合。 
		受法术强度影响，效果有额外加成。]]):
		format(t.getNb(self, t), damDesc(self, DamageType.FIRE, dam), damDesc(self, DamageType.PHYSICAL, dam))
	end,
}

registerTalentTranslation{
	id = "T_HEAL_NATURE",
	name = "自然治愈",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[使身体吸收自然能量，治疗 %d 生命值。 
		受精神强度影响，治疗量有额外加成。]]):
		format(heal)
	end,
}

registerTalentTranslation{
	id = "T_CALL_LIGHTNING",
	name = "召唤闪电",
	message = "@Source@ 朝@target@发射闪电!",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[召唤一股强烈的闪电束造成 %0.2f 至 %0.2f 伤害（平均 %0.2f ）。 
		受精神强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.LIGHTNING, damage / 3),
		damDesc(self, DamageType.LIGHTNING, damage),
		damDesc(self, DamageType.LIGHTNING, (damage + damage / 3) / 2))
	end,
}

registerTalentTranslation{
	id = "T_KEEPSAKE_FADE",
	name = "消隐",
	info = function(self, t)
		return ([[你淡出视野，使你隐形至下一回合。]])
	end,
}

registerTalentTranslation{
	id = "T_KEEPSAKE_PHASE_DOOR",
	name = "相位之门",
	info = function(self, t)
		return ([[在小范围内传送你。]])
	end,
}

registerTalentTranslation{
	id = "T_KEEPSAKE_BLINDSIDE",
	name = "灵异打击",
	info = function(self, t)
		local multiplier = self:combatTalentWeaponDamage(t, 1.1, 1.9)
		return ([[你以难以分辨的速度闪现到 %d 码范围内的某个目标面前，造成 %d%% 伤害。]]):format(self:getTalentRange(t), multiplier)
	end,
}

registerTalentTranslation{
	id = "T_SUSPENDED",
	name = "停滞",
	info = function(self, t)
		return ([[除非受到伤害，否则目标无法行动。]])
	end,
}

registerTalentTranslation{
	id = "T_FROST_GRAB",
	name = "冰霜飞爪",
	info = function(self, t)
		return ([[抓住目标并使其传送至你身边，冰冻目标使其移动速度 50%% 持续 %d 回合。
		冰同时也会造成 %0.2f 冰冷伤害。
		伤害受你的法术强度加成。]]):
		format(t.getDuration(self, t), damDesc(self, DamageType.COLD, self:combatTalentSpellDamage(t, 5, 140)))
	end,
}

registerTalentTranslation{
	id = "T_BODY_SHOT",
	name = "崩拳",
	message = "@Source@施展崩拳",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local drain = self:getTalentLevel(t) * 2
		local daze = t.getDuration(self, t, 0)
		local dazemax = t.getDuration(self, t, 5)
		return ([[对目标的身体发出强烈的一击，造成 %d%% 伤害，每点连击点消耗 %d 目标体力并眩晕目标 %d 到 %d 回合（由你的连击点数决定）。 
		受物理强度影响，眩晕概率有额外加成。 
		使用此技能会消耗当前所有连击点。]])
		:format(damage, drain, daze, dazemax)
	end,
}


registerTalentTranslation{
	id = "T_COMBO_STRING",
	name = "强化连击",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		return ([[当获得 1 个连击点时有 %d%% 概率 
		额外获得 1 个连击点。 
		此外你的连击点持续时间会延长 %d 回合。 
		受灵巧影响，额外连击点获得概率有额外加成。]]):
		format(chance, duration)
	end,
}

registerTalentTranslation{
	id = "T_STEADY_MIND",
	name = "冷静思维",
	info = function(self, t)
		local defense = t.getDefense(self, t)
		local saves = t.getMental(self, t)
		return ([[大量的训练使你能保持清醒的头脑，增加 %d 近身闪避和 %d 精神豁免。 
		受敏捷影响，闪避按比例加成； 
		受灵巧影响，精神豁免按比例加成。]]):
		format(defense, saves)
	end,
}

registerTalentTranslation{
	id = "T_MAIM",
	name = "关节技：碎骨",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		local maim = t.getMaim(self, t)
		return ([[抓取目标并给予其 %0.2f 物理伤害。 
		如果目标已被抓取，则目标会被致残，减少 %d 伤害和 30%% 整体速度持续 %d 回合。 
		抓取效果受你已有的抓取技能影响。 
		受物理强度影响，伤害按比例加成。]])
		:format(damDesc(self, DamageType.PHYSICAL, (damage)), maim, duration)
	end,
}

registerTalentTranslation{
	id = "T_BLOODRAGE",
	name = "血怒",
	info = function(self, t)
		return ([[每当你让一个敌人扑街，你会漏出一股汹涌的霸气，增加你 2 点力量，上限 %d ，持续 %d 回合。]]):
		format(math.floor(self:getTalentLevel(t) * 6), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_OVERPOWER",
	name = "压制",
	info = function(self, t)
		return ([[用你的武器和盾牌压制目标并分别造成 %d%% 武器和 %d%% 2 次盾牌反击伤害。
		如果上述攻击命中，那么目标会被击退。
		受命中影响，击退的概率有额外加成。]])
		:format(100 * self:combatTalentWeaponDamage(t, 0.8, 1.3), 100 * self:combatTalentWeaponDamage(t, 0.8, 1.3, self:getTalentLevel(self.T_SHIELD_EXPERTISE)))
	end,
}

registerTalentTranslation{
	id = "T_PERFECT_CONTROL",
	name = "完美控制",
	info = function(self, t)
		local boost = t.getBoost(self, t)
		local dur = t.getDuration(self, t)
		return ([[用灵能围绕你的身体，通过思想高效控制身体，允许你不使用肌肉和神经操纵身体。 
		增加 %d 点命中和 %0.2f%% 暴击概率，持续 %d 回合。]]):
		format(boost, 0.5*boost, dur)
	end,
}

registerTalentTranslation{
	id = "T_SHATTERING_CHARGE",
	name = "毁灭冲锋",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDam(self, t))
		return ([[冲锋 %d 码。
		路径上的敌人会被击退并受到 %d 至 %d 点物理伤害。
		技能等级 5 时你能冲过墙壁。]]):
		format(range, 2*dam/3, dam)
	end,
}

		
registerTalentTranslation{
	id = "T_TELEKINETIC_THROW",
	name = "动能投掷",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t))
		return ([[Use your telekinetic power to enhance your strength, allowing you to pick up an adjacent enemy and hurl it anywhere within radius %d. 
		Upon landing, your target takes %0.1f Physical damage and is stunned for 4 turns.  All other creatures within radius 2 of the landing point take %0.1f Physical damage and are knocked away from you.
		This talent ignores %d%% of the knockback resistance of the thrown target, which takes half damage if it resists being thrown.
		The damage improves with your Mindpower and the range increases with both Mindpower and Strength.]]):
		format(range, dam, dam/2, t.getKBResistPen(self, t))
	end,
}

registerTalentTranslation{
	id = "T_REACH",
	name = "意念扩展",
	info = function(self, t)
		return ([[]])
	end,
}

registerTalentTranslation{
	id = "T_RELOAD",
	name = "装填弹药",
	info = function(self, t)
		return ([[立刻装填 %d 弹药。之后缴械 2 回合。
		装填弹药不会打破潜行。]])
		:format(self:reloadRate())
	end,
}

registerTalentTranslation{
	id = "T_BONE_NOVA",
	name = "白骨新星",
	info = function(self, t)
		return ([[向所有方向射出骨矛，对 %d 码范围内所有敌人造成 %0.2f 物理伤害,同时在 5 回合内造成 %0.2f 流血伤害。  
		受法术强度影响，伤害有额外加成。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)/2))
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_AMBUSH",
	name = "暗影伏击",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[你向目标甩出 1 道影之绳索，将目标拉向你并沉默它 %d 回合，同时眩晕目标 2 回合。 
		受命中影响，技能命中率有额外加成。]]):
		format(duration)
	end,
}

registerTalentTranslation{
	id = "T_AMBUSCADE",
	name = "影分身",
	info = function(self, t)
		return ([[你在 %d 回合内完全控制你的影子。 
		你的影子继承了你的天赋和属性，拥有你 %d%% 的生命值并造成等同于你 %d%% 的伤害， -30%% 所有抵抗， -100%% 光属性抵抗并增加 100%% 暗影抵抗。 
		你的影子处于永久潜行状态（ %d 潜行强度）并且它所造成的所有近战伤害均会转化为暗影伤害。 
		如果你提前解除控制或者它离开你的视野时间过长，你的影分身会自动消失。]]):
		format(t.getDuration(self, t), t.getHealth(self, t) * 100, t.getDam(self, t) * 100, t.getStealthPower(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_LEASH",
	name = "暗影束缚",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[使你的武器立刻转化为暗影之缚形态，夺取目标武器，缴械目标 %d 回合。 
		受命中影响，技能命中率有额外加成。]]):
		format(duration)
	end,
}


registerTalentTranslation{
	id = "T_DISMAY",
	name = "黑暗痛苦",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local duration = t.getDuration(self, t)
		return ([[在黑暗光环里的每一个目标每回合必须与你的精神强度进行豁免鉴定，未通过鉴定则有 %0.1f%% 概率受到黑暗痛苦持续 %d 回合，你对受黑暗痛苦折磨的目标进行的首次近战攻击必定暴击。]]):format(chance, duration)
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_EMPATHY",
	name = "阴影链接",
	info = function(self, t)
		local power = t.getPower(self, t)
		local duration = t.getDur(self, t)
		return ([[ 你连接到你的阴影，持续 %d 回合，将你受到的伤害的 %d%% 转移至随机某个阴影上。
		受精神强度影响，效果有额外加成。]]):
		format(duration, power)
	end,
}


registerTalentTranslation{
	id = "T_CIRCLE_OF_BLAZING_LIGHT",
	name = "炽焰之阵",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在你的脚下制造一个 %d 码半径的法阵，它会照亮范围区域，每回合增加 %d 正能量并造成 %0.2f 光系伤害和 %0.2f 火焰伤害。 
		阵法持续 %d 回合。 
		受法术强度影响，伤害有额外加成。]]):
		format(radius, 1 + (damage / 4), (damDesc (self, DamageType.LIGHT, damage)), (damDesc (self, DamageType.FIRE, damage)), duration)
	end,
}

return _M
