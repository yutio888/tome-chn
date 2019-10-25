local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_HIGHER_HEAL",
	name = "高等人类之怒",
	info = function(self, t)
		return ([[召唤高等人类的力量，增加所有伤害 %d%% ，减少受到的所有伤害 %d%% ，持续5回合。
		增益效果受魔法值加成。]]):
		format(t.getPower(self, t), t.getPower(self, t))
	end,
}

registerTalentTranslation{
	id = "T_OVERSEER_OF_NATIONS",
	name = "远见卓识",
	info = function(self, t)
		return ([[虽然高贵血统并不意味着统治他人（当然也没有特别的意愿去那样做），但是他们经常承担更高的义务。 
		他们的本能使得他们比别人有更强的直觉。 
		增加 %d%% 目盲免疫 , 提高 %d 点最大视野范围并提高 %d 光照、夜视及感应范围。
		技能等级 5 时，每次你命中目标，你将获得 15 格范围内同类型生物感知能力，持续 5 回合。]]):
		format(t.getImmune(self, t) * 100, t.getSight(self, t), t.getESight(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BORN_INTO_MAGIC",
	name = "魔法亲和",
	info = function(self, t)
		local netpower = t.power(self, t)
		return ([[高等人类们最初是在厄流纪前由红衣主神们创造的。他们天生具有魔法天赋。 
		提高 %d 点法术豁免和 %d%% 奥术抵抗。
		每次释放伤害法术时， 5 回合内该伤害类型获得 20%% 伤害加成。（该效果有冷却时间。）]]):
		format(t.getSave(self, t), netpower)
	end,
}

registerTalentTranslation{
	id = "T_HIGHBORN_S_BLOOM",
	name = "生命绽放",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[激活你的内在潜力，以提高你的能力。 
		在接下来 %d 回合中可无消耗使用技能。 
		你的能量值仍需要满足使用这些技能的最低能量需求，且技能仍有几率会失败。]]):format(duration)
	end,
}

registerTalentTranslation{
	id = "T_SHALOREN_SPEED",
	name = "不朽的恩赐",
	info = function(self, t)
		return ([[召唤不朽的恩赐之力来增加你 %d%% 的整体速度，持续 5 回合。 
		受敏捷和魔法中较高一项影响，速度会有额外的提升。]]):
		format(t.getSpeed(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_MAGIC_OF_THE_ETERNALS",
	name = "不朽的魔法",
	info = function(self, t)
		return ([[因为永恒精灵的自然魔法，现实发生了轻微的扭曲。 
		提高 %d%% 的暴击概率和 %d%% 暴击伤害。]]):
		format(t.critChance(self, t), t.critPower(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SECRETS_OF_THE_ETERNALS",
	name = "不朽的秘密",
	info = function(self, t)
		return ([[作为埃亚尔仅存的古老种族，永恒精灵在漫长的岁月里学习到如何用他们与生俱来的精神魔法保护自己。 
		%d%% 的概率使自身进入隐形状态（ %d 点隐形等级），当承受至少 10%% 总生命值的伤害时触发，持续 5 回合。]]):
		format(t.getChance(self, t), t.getInvis(self, t))
	end,
}

registerTalentTranslation{
	id = "T_TIMELESS",
	name = "超越永恒",
	info = function(self, t)
		return ([[世界在不断的变老，而你似乎永恒不变。对于你来说，时间是不同寻常的。 
		减少 %d 回合负面状态的持续时间，减少技能 %d 回合冷却时间直至冷却并增加 %d 回合增益状态的持续时间（至多延长为剩余时间的两倍）。]]):
		format(t.getEffectBad(self, t), t.getEffectGood(self, t), t.getEffectGood(self, t))
	end,
}

registerTalentTranslation{
	id = "T_THALOREN_WRATH",
	name = "森林的恩赐",
	info = function(self, t)
		return ([[召唤自然的力量，每回合恢复 %d 生命值，治疗系数增加 %d%% ，持续 10 回合。
		生命恢复量受意志值加成。]]):format(5 + self:getWil() * 0.5, t.getHealMod(self, t))
	end,
}

registerTalentTranslation{
	id = "T_UNSHACKLED",
	name = "亲近自然",
	info = function(self, t)
		return ([[自然精灵对自然元素有亲和力，这让它们在受到伤害时可以获得一定的治疗。
		获得  %d%%  自然和酸性伤害吸收。]]):
		format(t.getAffinity(self, t))
	end,
}

registerTalentTranslation{
	id = "T_GUARDIAN_OF_THE_WOOD",
	name = "森林守护",
	info = function(self, t)
		return ([[自然精灵是森林的一部分，森林保护他们免受侵蚀。 
		提高 %d%% 疾病抵抗、 %0.1f%% 枯萎抵抗和 %0.1f%% 所有抵抗。]]):
		format(t.getDiseaseImmune(self, t)*100, t.getBResist(self, t), t.getAllResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_NATURE_S_PRIDE",
	name = "自然的骄傲",
	info = function(self, t)
		local base_stats = self:combatScale(self:getWil() * self:getTalentLevel(t), 25, 0, 125, 500, 0.75)
		return ([[自然与自然精灵同在，你他们可以时刻感受到森林的召唤。 
		召唤 2 个精英树人，持续 8 回合。 
		树人的所有抵抗取决于你的枯萎抵抗，并且可以震慑、击退并嘲讽你的敌人。 
		你的意志值 (%d)将会被加到它们的所有非魔法主要属性值上，他们的技能等级受到你自然的骄傲技能等级的加成。
		你的伤害加成，伤害穿透和其他许多属性会被继承。]]):format(self:getWil())
	end,
}

registerTalentTranslation{
	id = "T_DWARF_RESILIENCE",
	name = "钢筋铁骨",
	info = function(self, t)
		local params = t.getParams(self, t)
		return ([[召唤矮人一族的传奇血统来增加你 +%d 点护甲值， +%d%% 护甲硬度， +%d 点法术豁免和 +%d 物理豁免，持续 8 回合。 
		受你的体质影响，此效果有额外加成。]]):
		format(params.armor, params.armor_hardiness, params.physical, params.spell)
	end,
}

registerTalentTranslation{
	id = "T_STONESKIN",
	name = "石化皮肤",
	info = function(self, t)
		return ([[矮人皮肤是一种复杂的结构，它可以在受到打击后自动硬化。 
		当被击打时有 15%% 的概率增加 %d 点护甲值，持续 5 回合，同时无视触发该效果的攻击。
		该效果无冷却时间，可重复触发。]]):
		format(t.armor(self, t))
	end,
}

registerTalentTranslation{
	id = "T_POWER_IS_MONEY",
	name = "金钱就是力量",
	info = function(self, t)
		return ([[金钱是矮人王国的心脏，它控制了所有其他决策。 
		基于你的金币持有量，增加物理、精神和法术抵抗。 
		+1 豁免值每 %d 单位金币，最大 +%d (当前 +%d )。]]):
		format(t.getGold(self, t), t.getMaxSaves(self, t), t.getSaves(self, t))
	end,
}

registerTalentTranslation{
	id = "T_STONE_WALKING",
	name = "穿墙术",
	info = function(self, t)
		local range = t.getRange(self, t)
		return ([[虽然矮人的起源对其他种族来说始终是不解之谜，但是很显然他们的起源与石头密不可分。 
		你可以指定任何一堵墙并立刻穿过它，出现在另一侧。 
		穿墙距离最大 %d 码（受体质和分类天赋等级影响有额外加成）]]):
		format(range)
	end,
}

registerTalentTranslation{
	id = "T_HALFLING_LUCK",
	name = "小不点的幸运",
	info = function(self, t)
		local params = t.getParams(self, t)
		return ([[召唤小不点的幸运和机智来提高你 %d%%  暴击率和 %d  豁免 5 回合。 
		受灵巧影响，此效果有额外增益。]]):
		format(params.crit, params.save)
	end,
}

registerTalentTranslation{
	id = "T_DUCK_AND_DODGE",
	name = "闪避",
	info = function(self, t)
		local threshold = t.getThreshold(self, t)
		local evasion = t.getEvasionChance(self, t)
		local duration = t.getDuration(self, t)
		return ([[半身人强大的人品在关键时刻总能保他们一命。 
		每当一次攻击对你造成 %d%% 生命值或更多伤害时，你可以获得额外 %d%% 闪避率和 %d 点闪避（基于幸运和其他闪避相关数值），持续 %d 回合。]]):
		format(threshold * 100, evasion, t.getDefense(self), duration)
	end,
}

registerTalentTranslation{
	id = "T_MILITANT_MIND",
	name = "英勇",
	info = function(self, t)
		return ([[半身人曾是一个有组织纪律的种族，敌人越多他们越团结。 
		如果有 2 个或多个敌人在你的视野里，每个敌人都会使你的所有强度和豁免提高 %0.1f 。（最多 5 个敌人）]]):
		format(self:getTalentLevel(t) * 2)
	end,
}

registerTalentTranslation{
	id = "T_INDOMITABLE",
	name = "不屈意志",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local count = t.getRemoveCount(self, t)
		return ([[半身人以骁勇善战闻名于世，他们曾经在战场上对抗其他种族上千年。 
		立刻移除 2 种震慑、眩晕和定身状态，并使你对震慑、眩晕和定身免疫 %d 回合。 
		使用此技能不消耗回合。]]):format(duration, count)
	end,
}

registerTalentTranslation{
	id = "T_ORC_FURY",
	name = "兽族之怒",
	info = function(self, t)
		return ([[激活你对杀戮和破坏的渴望，尤其是当你孤军奋战之时。
		你视野中每有一个敌人，增加所有伤害 10 %% + %0.1f%% （最多5个敌人， %0.1f%% ），持续 3 回合。
		受体质影响，增益有额外加成。]]):
		format(t.getPower(self, t), 10 + t.getPower(self, t) * 5)
	end,
}

registerTalentTranslation{
	id = "T_HOLD_THE_GROUND",
	name = "兽族忍耐",
	info = function(self, t)
		return ([[其他种族对兽族的猎杀持续了上千年，不管是否正义。他们已经学会忍受那些会摧毁弱小种族的灾难。 
		当你的生命值降低到 50%% 以下，你强大的意志移除你身上最多 %d 个精神状态（基于技能等级和意志）。该效果每 12 回合最多触发一次。
		额外增加 %d 物理和精神豁免。]]):
		format(t.getDebuff(self, t), t.getSaves(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER",
	name = "杀戮者",
	info = function(self, t)
		return ([[兽人们经历了许多次战争，并获胜了许多次。 
		你陶醉于杀戮你的敌人，每次杀死敌人你将获得 %d%% 的伤害抗性，持续 2 回合。
		增加的抗性基于你的技能等级和意志。
		被动增加 %d%% 所有伤害穿透。]]):
		format(t.getResist(self, t), t.getPen(self, t))
	end,
}

registerTalentTranslation{
	id = "T_PRIDE_OF_THE_ORCS",
	name = "兽族荣耀",
	info = function(self, t)
		return ([[呼唤兽族荣耀来和敌人拼搏。 
		移除 %d 个负面状态并治疗 %d 生命值。
		受意志影响，治疗量有额外加成。]]):
		format(t.remcount(self,t), t.heal(self, t))
	end,
}

registerTalentTranslation{
	id = "T_YEEK_WILL",
	name = "主导意志",
	info = function(self, t)
		return ([[粉碎目标的意志，使你可以完全控制它的行动 %s 回合。（受你的意志值加成） 
		当技能结束时，你的意志会脱离而目标会因大脑崩溃而死亡。 
		稀有等级即以上的目标必须要在其最大生命值的 80%% 以下才能被控制，在持续时间内不会受到伤害，并且在 3 回合后不会死亡 ,而会脱离控制。
		这一效果无法被豁免，但需要通过即死免疫。]]):format(t.getduration(self))
	end,
}

registerTalentTranslation{
	id = "T_UNITY",
	name = "强化思维",
	info = function(self, t)
		return ([[你的思维和维网变的更加协调并且增强对负面效果的抵抗。 
		增加 %d%% 混乱和沉默抵抗并增加你 +%d 点精神豁免。]]):
		format(100*t.getImmune(self, t), t.getSave(self, t))
	end,
}

registerTalentTranslation{
	id = "T_QUICKENED",
	name = "迅捷",
	info = function(self, t)
		return ([[基于“维网”，夺心魔新陈代谢很快，思维很快并且献祭也很快。 
		你的整体速度增加 %0.1f%% 。
		当你的生命值降低到 30%% 以下时，你获得 1.5 个回合。该效果每 %d 回合最多触发一次。]]):format(100*t.speedup(self, t), self:getTalentCooldown(t))
	end,
}

registerTalentTranslation{
	id = "T_WAYIST",
	name = "快速支援",
	info = function(self, t)
		local base_stats = self:combatScale(self:getWil() * self:getTalentLevel(t), 25, 0, 125, 500, 0.75)
		return ([[通过夺心魔的维网，迅速召集帮手。 
		在你周围召唤 3 个夺心魔精英，持续 6 回合。
		他们的所有主要属性会被设置为 %d (基于你的意志值和技能等级）
		你的伤害加成，伤害穿透和许多其他属性都会被继承。]]):format(base_stats)
	end,
}

registerTalentTranslation{
	id = "T_YEEK_ID",
	name = "维网的力量",
	info = function(self, t)
		return ([[你将精神与维网链接，能暂时获得你们一族所有的知识，让你能鉴定所有物品。]])
	end,
}

registerTalentTranslation{
	id = "T_OGRE_WRATH",
	name = "食人魔之怒",
	info = function(self, t)
		return ([[你进入愤怒状态 %d 回合，获得 20%% 震慑和定身免疫，全体伤害增加 10%% 。
		同时，每当你使用符文或纹身、攻击未命中或伤害被护盾等效果削减时，你获得一层食人魔之怒效果，持续 7 回合，效果可叠加至最多 5 层。
		每层提供 20%% 暴击伤害和 5%% 暴击率。
		每次暴击时减少一层食人魔之怒效果。
		持续时间受力量加成。]]):format(t.getduration(self))
	end,
}

	
registerTalentTranslation{
	id = "T_GRISLY_CONSTITUTION",
	name = "强大体魄",
	info = function(self, t)
		return ([[食人魔的身体对法术和符文亲和力很强。
		增加 %d 法术豁免，增加纹身和符文的属性加成效果 %d%% 。
		技能等级 5 时，你的身体变得如此强壮，能在主手持有双手武器的同时，副手持有其他副手武器。
		这样做的话，你的命中、物理、法术、精神强度会下降 20%% ，体型超过 'Big'时，每增加一体型，惩罚减少 5%% 。同时你的武器附加伤害减少 50%% 。]]):
		format(t.getSave(self, t), t.getMult(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_SCAR_SCRIPTED_FLESH",
	name = "血肉伤痕",
	info = function(self, t)
		return ([[每次暴击时有 %d%% 几率减少随机一个纹身或符文 1 回合冷却时间，或减少符文紊乱或纹身紊乱 1 回合持续时间。
		该效果每回合最多触发一次。]]):
		format(t.getChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WRIT_LARGE",
	name = "符文亲和",
	info = function(self, t)
		return ([[立刻解除纹身紊乱和符文紊乱。
		接下来 %d 回合内，你的纹身和符文冷却速度加倍。
		技能等级 5 时，你能解锁一个新的纹身位  。]]):
		format(t.getDuration(self, t))
	end,
}


return _M
