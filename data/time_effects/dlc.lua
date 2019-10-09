local DamageType = require "engine.DamageType"
timeEffectCHN:newEffect{
	id = "DEMON_BLADE",
	enName = "Demon blade",
	chName = "恶魔之刃",
	type = "魔法",
	subtype = "恶魔",
	desc = function(self,eff) return("近战攻击将附加半径 1 的火球，伤害 %0.2f"):format(eff.dam)
	end,
}

timeEffectCHN:newEffect{
	id = "FIERY_TORMENT",
	enName = "Fiery Torment",
	chName = "灼魂之罚",
	desc = function(self, eff) return ("目标的火焰抗性下降 %d%% , 并会被恶魔空间的火焰灼伤。效果结束时将受到 %d 火焰伤害，并追加 %d%% 效果期间受到的总伤害。"):format(eff.power, eff.finaldam, eff.rate*100) end,
	type = "魔法",
	subtype = "诅咒",
}

timeEffectCHN:newEffect{
	id = "DESTROYER_FORM",
	enName = "Destroyer",
	chName = "毁灭者",
	desc = function(self, eff) return ("目标变形为强大的恶魔。"):format() end,
	type = "魔法",
	subtype = "火焰",
}

timeEffectCHN:newEffect{
	id = "VORACIOUS_BLADE", 
	enName = "Voracious Blade",
	chName = "饕鬄之刃",
	desc = function(self, eff) return ("接下来的 %d 次近战攻击必定暴击。效果期间增加 %d%% 暴击系数。"):format(eff.hits, eff.power) end,
	type = "魔法",
	subtype = "堕落",
}

timeEffectCHN:newEffect{
	id = "RAGING_FLAMES",
	enName = "Raging flames",
	chName = "熊熊烈焰",
	desc = function(self, eff) return ("接下来一次近战攻击必定触发焚尽强击，且焚尽强击伤害增加 %d%% 。"):format(eff.power * 100) end,
	type = "魔法",
	subtype = "堕落",
}

timeEffectCHN:newEffect{
	id = "CURSED_FLAMES",
	enName = "Devouring flames",
	chName = "吞噬之焰",
	desc = function(self, eff) return ("该生物身上的火焰正向来源生物提供能量，每回合给予其 %d 生命与 %d 活力。"):format(eff.heal, eff.vim) end,
	type = "魔法",
	subtype = "堕落",
}

timeEffectCHN:newEffect{
	id = "INFERNAL_FEAR",
	enName = "Overwhelming Fear",
	chName = "无尽恐惧",
	desc = function(self, eff) return ("目标对打败你失去信心，伤害减少 %d%%，速度减慢 %d%% 。"):format(eff.power*eff.stacks, eff.slow_power*eff.stacks*100) end,
	type = "精神",
	subtype = "堕落",
}

timeEffectCHN:newEffect{
	id = "HOPELESS",
	enName = "Abandoned hope",
	chName = "绝望",
	desc = function(self, eff) return ("目标精神破碎，不能行动。") end,
	type = "其他",
	subtype = "恐惧",
}

timeEffectCHN:newEffect{
	id = "SUFFERING_IMMUNE",
	enName = "Suffered",
	chName = "被折磨",
	desc = function(self, eff) return ("目标最近被折磨过，暂时不能继续折磨。") end,
	type = "其他",
	subtype = "堕落",
}

timeEffectCHN:newEffect{
	id = "PURIFIED_BY_FIRE",
	enName = "Cleansing flames",
	chName = "净化之焰",
	desc = function(self, eff) return ("目标被火焰净化，每回合损失 %0.2f%% 最大生命值的生命。"):format(eff.power*100) end,
	type = "其他",
	subtype = "火焰",
}

timeEffectCHN:newEffect{
	id = "REBIRTH_BY_FIRE",
	enName = "Blazing Rebirth",
	chName = "烈焰重生",
	desc = function(self, eff) return ("目标正在燃烧，每回合损失 %d 生命值，和半径 %d 内的正在燃烧的敌人分摊。"):format(eff.power, eff.radius) end,
	type = "其他",
	subtype = "火焰",
}

timeEffectCHN:newEffect{
	id = "FIERY_GRASP",
	enName = "Fiery Grasp",
	chName = "炙炎之牢",
	desc = function(self, eff)
		if eff.silence == 1 then
			return ("目标着火了，每回合受到 %0.2f 点火焰伤害并被沉默。"):format(eff.power, text) 
		else
			return ("目标着火了，每回合受到 %0.2f 点火焰伤害。"):format(eff.power, text) 
		end
	end,
	type = "物理",
	subtype = "火焰/定身",
	status = "detrimental",
}
timeEffectCHN:newEffect{
	id = "FIRE_SHIELD",
	enName = "Fiery Aegis",
	chName = "火焰守护",
	desc = function(self, eff) return ("目标被一层魔法护盾包围，吸收 %d/%d 伤害。护盾破碎时在半径 %d 范围内造成 %d 伤害。"):format(self.fiery_aegis_damage_shield_absorb, eff.power, eff.radius, eff.power) end,
	type = "魔法",
	subtype = "奥术/护盾",
}
timeEffectCHN:newEffect{
	id = "SURGE_OF_POWER",
	enName = "Surge of Power",
	chName = "力量之潮",
	desc = function(self, eff) return ("目标直到 -%d 生命才会死去。 "):format(eff.power) end,
	type = "物理",
	subtype = "堕落",
}

timeEffectCHN:newEffect{
	id = "RECKLESS_PEN",
	enName = "Recklessness",
	chName = "舍身",
	desc = function(self, eff) return ("目标获得 %d%% 全体抗性穿透。"):format(eff.power) end,
	type = "魔法",
	subtype = "堕落",
}

timeEffectCHN:newEffect{
	id = "DEMON_SEED",
	enName = "Demon Seed",
	chName = "恶魔之种",
	desc = function(self, eff) return ("目标被恶魔之种感染，死亡时施法者将得到成熟的种子。"):format() end,
	type = "魔法",
	subtype = "堕落",
}

timeEffectCHN:newEffect{
	id = "OSMOSIS_REGEN",
	enName = "Osmosis Regeneration",
	chName = "渗透吸收",
	desc = function(self, eff) return ("效果期间，你总计回复 %0.2f 生命。"):format(eff.power) end,
	type = "魔法",
	subtype = "治疗",
}

timeEffectCHN:newEffect{
	id = "ACIDIC_BATH",
	enName = "Acidic Bath",
	chName = "酸浴",
	desc = function(self, eff) return ("获得%d%% 酸性抗性与 %d%%酸性伤害吸收。"):format(eff.res, eff.aff) end,
	type = "魔法",
	subtype = "抗性/治疗",
}

timeEffectCHN:newEffect{
	id = "BURNING_PLAGUE",
	enName = "Plaguefire",
	chName = "瘟疫之焰",
	desc = function(self, eff) return ("目标着火，每回合受到 %0.2f 火焰伤害。死亡时火焰将爆炸。"):format(eff.power) end,
	type = "物理",
	subtype = "火焰",
}

timeEffectCHN:newEffect{
	id = "DEMON_SEED_CORRUPT_LIGHT",
	enName = "Corrupted Light",
	chName = "腐化之光",
	desc = function(self, eff) return ("目标能量溢出，增加 %d%% 全体伤害。"):format(eff.power) end,
	type = "魔法",
	subtype = "黑暗",
}

timeEffectCHN:newEffect{
	id = "DEMON_SEED_ARMOURED_LEVIATHAN",
	enName = "Armoured Leviathan",
	chName = "重装上阵",
	desc = function(self, eff) return ("增加 %d 力量与魔法。"):format(eff.power) end,
	type = "魔法",
	subtype = "护甲",
}

timeEffectCHN:newEffect{
	id = "DEMON_SEED_DOOMED_NATURE",
	enName = "Doomed Nature",
	chName = "自然末日",
	desc = function(self, eff) return ("目标被枯萎力量感染，使用自然技能时有 %d%% 几率失败并释放半径 1 的火球，伤害 %0.2f。"):format(eff.chance, eff.dam) end,
	type = "魔法",
	subtype = "枯萎/诅咒",
}

timeEffectCHN:newEffect{
	id = "DEMONIC_CUT",
	enName = "Demonic Cut",
	chName = "恶魔伤口",
	desc = function(self, eff) return ("巨大的恶魔伤口每回合造成 %0.2f 暗影伤害。当伤害来源击中目标时将会恢复 %d 生命。"):format(eff.dam, eff.heal) end,
	type = "魔法",
	subtype = "伤口/切割/流血/黑暗",
}

timeEffectCHN:newEffect{
	id = "LINK_OF_PAIN",
	enName = "Link of Pain",
	chName = "苦痛链接",
	desc = function(self, eff) return ("当目标受伤害时，牺牲生物也会承受 %d%% 的伤害。"):format(eff.power) end,
	type = "魔法",
	subtype = "仪式/黑暗",
}

timeEffectCHN:newEffect{
	id = "ONLY_ASHES_LEFT",
	enName = "Only Ashes Left",
	chName = "唯余灰烬",
	desc = function(self, eff) return ("目标被黑暗灼烧，每回合受到 %0.2f 伤害直到死亡或离开。"):format(eff.power) end,
	type = "魔法",
	subtype = "黑暗",
}

timeEffectCHN:newEffect{
	id = "SHATTERED_MIND",
	enName = "Shattered Mind",
	chName = "精神破碎",
	desc = function(self, eff) return ("目标使用技能时有 %d%% 几率失败。目标全体豁免下降 %d 点。"):format(eff.fail, eff.save) end,
	type = "魔法",
}

timeEffectCHN:newEffect{
	id = "DARK_REIGN",
	enName = "Dark Reign",
	chName = "黑暗支配",
	long_desc = function(self, eff) local p = 1 for i = 1, eff.stacks do p = p * 0.92 end p = 100 * (1 - p)
		return ("全体伤害吸收增加 %d%%.\n直到 %d 生命不会死亡。"):format(p, -((eff.die_at or 0) * eff.stacks)) end,

	type = "魔法",
	subtype = "黑暗",
}

timeEffectCHN:newEffect{
	id = "BLOOD_PACT",
	enName = "Blood Pact",
	chName = "鲜血契约",
	desc = function(self, eff) return ("你的所有伤害转化为暗影伤害。"):format() end,
	type = "魔法",
	subtype = "黑暗",
}

timeEffectCHN:newEffect{
	id = "BLACKICE",
	enName = "Blackice",
	chName = "黑冰",
	desc = function(self, eff) return ("剩余次数：%d"):format(eff.stacks) end,
	type = "魔法",
	subtype = "黑暗/寒冷",
}

timeEffectCHN:newEffect{
	id = "BLACKICE_DET",
	enName = "Blackice",
	chName = "黑冰",
	desc = function(self, eff) return ("火焰抗性下降%d%% 。"):format(eff.power) end,
	type = "魔法",
	subtype = "黑暗/寒冷",
	status = "detrimental",
}


timeEffectCHN:newEffect{
	id = "FIRE_HAVEN",
	enName = "Fire Haven",
	chName = "火焰庇护",
	desc = "目标被火焰围绕，获得 40%% 火焰伤害吸收，但减少 15%% 枯萎抗性。 ",
	type = "其他",
	subtype = "地面",

}

timeEffectCHN:newEffect{
	id = "BLEAK_OUTCOME",
	enName = "Bleak Outcome",
	chName = "悲惨结局",
	desc = function(self, eff) return ("死亡后提供 %d 倍活力。"):format(eff.stacks) end,
	type = "魔法",
	subtype = "活力/枯萎/诅咒",
}

timeEffectCHN:newEffect{
	id = "STRIPPED_LIFE",
	enName = "Stripped Life",
	chName = "生命剥夺",
	desc = function(self, eff) return ("法术强度增加 %d。"):format(eff.power) end,
	type = "魔法",
	subtype = "活力/枯萎",
}

timeEffectCHN:newEffect{
	id = "OMINOUS_SHADOW_CHARGES",
	enName = "Ominous Shadow Charges",
	chName = "不祥黑影-累积",
	desc = function(self, eff) return ("剩余数目：%d 。"):format(eff.stacks) end,
	type = "魔法",
	subtype = "黑暗",
}


timeEffectCHN:newEffect{
	id = "OMINOUS_SHADOW",
	enName = "Ominous Shadow",
	chName = "不详黑影",
	desc = function(self, eff) return ("提供隐形 (强度 %d)"):format(eff.power) end,
	type = "魔法",
	subtype = "黑暗",
}

timeEffectCHN:newEffect{
	id = "CORRUPTION_OF_THE_DOOMED",
	enName = "Corruption of the Doomed",
	chName = "腐化形态",
	desc = function(self, eff) return ("目标变形为多瑟顿。"):format() end,
	type = "魔法",
	subtype = "枯萎/奥术",
}

timeEffectCHN:newEffect{
	id = "STONE_VINE",
	enName = "Stone Vine",
	chName = "岩石藤蔓",
	desc = function(self, eff) return ("岩石藤蔓将目标钉在地上，每回合造成 %0.1f 点物理 %s 伤害。"):format(eff.dam, eff.arcanedam and (" 和 %0.1f 点奥术 "):format(eff.arcanedam) or "") end,
	type = "物理",
	subtype = "大地/定身",
}

timeEffectCHN:newEffect{
	id = "DWARVEN_RESILIENCE",
	enName = "Dwarven Resilience",
	chName = "矮人防御",
	desc = function(self, eff)
		if eff.mid_ac then
			return (" 目标皮肤石化，提升 %d 护甲值，提升 %d 物理豁免和 %d 法术豁免。同时所有非物理伤害减免 %d 点。"):format(eff.armor, eff.physical, eff.spell, eff.mid_ac)
		else
			return (" 目标皮肤石化，提升 %d 护甲值，提升 %d 物理豁免和 %d 法术豁免。"):format(eff.armor, eff.physical, eff.spell)
		end
	end,
	type = "物理",
	subtype = "大地",
}
timeEffectCHN:newEffect{
	id = "ELDRITCH_STONE",
	enName = "Eldritch Stone Shield",
	chName = "岩石护盾",
	desc = function(self, eff)
		return ("目标被一层岩石护盾围绕，吸收 %d/%d 伤害。当护盾消失时，破碎的岩石会产生一次爆炸，造成至多 %d（当前 %d）点伤害，爆炸半径为 %d。"):
		format(eff.power, eff.max, eff.maxdam, math.min(eff.maxdam, self:getEquilibrium() - self:getMinEquilibrium()), eff.radius)
	end,
	type = "魔法",
	subtype = "大地/护盾",
}
timeEffectCHN:newEffect{
	id = "STONE_LINK_SOURCE",
	enName = "Stone Link",
	chName = "岩石链接",
	desc = function(self, eff) return ("目标保护身边半径 %d 内所有友方生物，将伤害转移至自身。"):format(eff.rad) end,
	type = "魔法",
	subtype = "大地/护盾",
}
timeEffectCHN:newEffect{
	id = "DEEPROCK_FORM",
	enName = "Deeprock Form",
	chName = "深岩形态",
	desc = function(self, eff)
		local xs = ""
		if eff.arcaneDam and eff.arcanePen then
			xs = xs..(", %d%% 奥术伤害与 %d%% 奥术抗性穿透 "):format(eff.arcaneDam, eff.arcanePen)
		end
		if eff.natureDam and eff.naturePen then
			xs = (", %d%% 自然伤害与 %d%% 自然抗性穿透"):format(eff.natureDam, eff.naturePen)..xs
		end
		if eff.immune then
			xs = (", %d%% 流血、毒素、疾病和震慑免疫"):format(eff.immune*100)..xs
		end
		return ("目标变成巨型深岩元素，增加两点体型%s，%d%% 物理伤害与 %d%% 物理抗性穿透。%s"):format(xs, eff.dam, eff.pen, eff.useResist and " 同时，将使用物理抗性代替所有伤害抗性。" or "")
	end,
	type = "魔法",
	subtype = "大地/元素",
}
--Orc DLC
timeEffectCHN:newEffect{
	id = "STRAFING",
	enName = "Strafing",
	chName = "扫射中",
	desc = function(self, eff) return ("目标在移动中射击，效果结束后恢复 %s 弹药。"):format(self.player and self:callTalent(self.T_STRAFE, "getReload", eff.turns).." " or "") end,
	type = "物理",
	subtype ="策略",
}

timeEffectCHN:newEffect{
	id = "STARTLING_SHOT",
	enName = "Startled",
	chName = "惊讶",
	desc = function(self, eff) return ("目标因一发未射中它的子弹而惊讶，下次被攻击将受到 %d%% 伤害。"):format(eff.power*100) end,
	type = "物理",
	subtype ="策略",
}

timeEffectCHN:newEffect{
	id = "IRON_GRIP",
	enName = "Iron Grip",
	chName = "铁腕",
	desc = function(self, eff) return ("目标被碾压，处于定身状态，护甲和闪避下降 %d。"):format(eff.power) end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "ENHANCED_BULLETS_OVERHEAT",
	enName = "Bullet Mastery: Overheated",
	chName = "子弹掌握：过热",
	desc = function(self, eff) return ("子弹处于过热状态：在 5 回合内造成 %d 火焰伤害"):format(self:damDesc(DamageType.FIRE, eff.power)) end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "ENHANCED_BULLETS_SUPERCHARGE",
	enName = "Bullet Mastery: Supercharged",
	chName = "子弹掌握：超速",
	desc = function(self, eff) return ("子弹处于超速状态：能够穿透多个目标 , 同时提高护甲穿透 %d 点。"):format(eff.power) end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "ENHANCED_BULLETS_PERCUSIVE",
	enName = "Bullet Mastery: Percussive",
	chName = "子弹掌握：冲击",
	desc = function(self, eff) return ("子弹处于冲击状态：%d%% 概率击退， %d%% 概率震慑。"):format(eff.power, eff.stunpower) end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "ENHANCED_BULLETS_COMBUSTIVE",
	enName = "Bullet Mastery: Combustive",
	chName = "子弹掌握：爆炸",
	desc = function(self, eff) return ("子弹处于爆炸状态: 对 2 码范围内的敌人造成 %d 火焰伤害"):format(self:damDesc(DamageType.FIRE, eff.power)) end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "UNCANNY_RELOAD",
	enName = "Uncanny Reload",
	chName = "神秘装填术",
	desc = function(self, eff) return ("蒸汽枪不消耗子弹。"):format() end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "CLOAK",
	enName = "Cloak",
	chName = "潜行披风",
	desc = function(self, eff) return ("目标被暗影披风包裹，获得潜行能力。 ") end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "PAIN_SUPPRESSOR_SALVE",
	enName = "Pain Suppressor Salve",
	chName = "痛苦压制药剂",
	desc = function(self, eff) return ("获得 -%d 生命下限和 %d%% 全体伤害抗性。"):format(eff.die_at, eff.resists) end,
	type = "物理",
	subtype ="自然",
}

timeEffectCHN:newEffect{
	id = "FROST_SALVE",
	enName = "Frost Salve",
	chName = "寒霜药剂",
	desc = function(self, eff) return ("获得 %d%% 寒冷、暗影和自然伤害吸收。"):format(eff.power) end,
	type = "物理",
	subtype ="冰霜",
}

timeEffectCHN:newEffect{
	id = "FIERY_SALVE",
	enName = "Fiery Salve",
	chName = "烈火药剂",
	desc = function(self, eff) return ("获得 %d%% 火焰、光明和闪电伤害吸收。"):format(eff.power) end,
	type = "物理",
	subtype ="火焰",
}

timeEffectCHN:newEffect{
	id = "WATER_SALVE",
	enName = "Water Salve",
	chName = "静水药剂",
	desc = function(self, eff) return ("获得 %d%% 枯萎、精神和酸性伤害吸收。"):format(eff.power) end,
	type = "物理",
	subtype ="水",
}

timeEffectCHN:newEffect{
	id = "UNSTOPPABLE_FORCE_SALVE",
	enName = "Unstoppable Force Salve",
	chName = "势不可挡药剂",
	desc = function(self, eff) return ("增加全豁免 %d ，增加治疗系数 %d%% ."):format(eff.power, eff.power / 2) end,
	type = "物理",
	subtype ="科技",
}

timeEffectCHN:newEffect{
	id = "SLOW_TALENT",
	enName = "Slow Talents",
	chName = "技能减速",
	desc = function(self, eff) return ("攻击，施法和精神速度下降 %d%% 。"):format(eff.power * 100) end,
	type = "物理",
	subtype ="减速",
}

timeEffectCHN:newEffect{
	id = "SUPERCHARGE_TINKERS",
	enName = "Supercharge Tinkers",
	chName = "插件超频",
	desc = function(self, eff) return ("获得 %d 蒸汽强度和 %d 蒸汽技能暴击率。"):format(eff.power, eff.crit) end,
	type = "物理",
	subtype ="科技",
}

timeEffectCHN:newEffect{
	id = "OVERCHARGE_SAWS",
	enName = "Overcharge Saws",
	chName = "链锯过载",
	desc = function(self, eff) return ("增加 %d%% 链锯相关技能有效等级"):format(eff.power) end,
	type = "物理",
	subtype ="科技",
}

timeEffectCHN:newEffect{
	id = "ALGID_RAGE",
	enName = "Algid Rage",
	chName = "霜寒暴怒",
	desc = function(self, eff) return ("你有 %d%% 几率把目标冻在冰块中 3 回合"):format(eff.power) end,
	type = "物理",
	subtype ="ice",
}

timeEffectCHN:newEffect{
	id = "RITCH_LARVA_EGGS",
	enName = "Larvae Infestation",
	chName = "里奇幼虫寄生",
	desc = function(self, eff)
		local source = eff.src or self
		return ("目标被 %d 个里奇幼虫寄生%s. 在发育期结束后，幼虫会从寄主体内钻出，每个幼虫造成 %0.2f 物理和 %0.2f 火焰伤害。"):format(eff.nb,
		eff.turns < eff.gestation and ("，每回合受到 %0.2f 物理伤害( 随回合递增)"):format(
		source:damDesc("PHYSICAL", self.tempeffect_def.EFF_RITCH_LARVA_EGGS.gestation_damage(self, eff, eff.turns + 1))) or "",
		eff.gestation, source:damDesc("PHYSICAL", eff.dam/2), source:damDesc("FIRE", eff.dam/2))
	end,
	type = "物理",
	subtype ="疾病",
}

timeEffectCHN:newEffect{
	id = "TECH_OVERLOAD",
	enName = "Tech Overload",
	chName = "系统过载",
	desc = function(self, eff) return ("蒸汽容量翻倍，蒸汽回复速度下降。 "):format() end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "CONTINUOUS_BUTCHERY",
	enName = "Continuous Butchery",
	chName = "无尽屠戮",
	desc = function(self, eff) return ("链锯伤害增加 %d%%。"):format(eff.power) end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "EXPLOSIVE_WOUND",
	enName = "Explosive Saw",
	chName = "爆炸飞锯",
	desc = function(self, eff) return ("你被飞锯击伤，每回合受到 %0.2f 物理伤害 %s。持续时间结束后，链锯爆炸，造成 %0.2f 的火焰伤害并飞回，并将你拉扯 %d 格。"):format(eff.power, eff.silence and " 并被沉默" or "", eff.src:damDesc(DamageType.FIRE, eff.power_final), eff.range) end,
	type = "物理",
	subtype ="伤口/切割/流血",
}

timeEffectCHN:newEffect{
	id = "SUBCUTANEOUS_METALLISATION",
	enName = "Subcutaneous Metallisation",
	chName = "金属内皮",
	desc = function(self, eff) return ("全伤害减免 %d."):format(eff.power) end,
	type = "物理",
	subtype ="蒸汽科技/抗性",
}

timeEffectCHN:newEffect{
	id = "PAIN_ENHANCEMENT_SYSTEM",
	enName = "Pain Enhancement System",
	chName = "痛苦强化系统",
	desc = function(self, eff) return ("全属性增加 %d。"):format(eff.power) end,
	type = "物理",
	subtype ="蒸汽科技/power",
}

timeEffectCHN:newEffect{
	id = "NET_PROJECTOR",
	enName = "Net Projector",
	chName = "束网弹射器",
	desc = function(self, eff) return ("你被电网定身，全抗性下降 %d%%。"):format(eff.power) end,
	type = "物理",
	subtype ="蒸汽科技/定身",
}

timeEffectCHN:newEffect{
	id = "FURNACE_MOLTEN_POINT",
	enName = "Molten Point",
	chName = "融化点数",
	desc = function(self, eff) return ("%d 点。"):format(eff.stacks) end,
	type = "其他",
	subtype ="火焰",
}

timeEffectCHN:newEffect{
	id = "PRESSURE_SUIT",
	enName = "Pressure-enhanced Slashproof Combat Suit",
	chName = "抗压战斗服",
	desc = function(self, eff) return ("当你被击中时，这套服装下隐藏的引擎将使你迅速切换位置，完全避免被攻击。") end,
	type = "物理",
	subtype ="蒸汽",
}

timeEffectCHN:newEffect{
	id = "MOLTEN_IRON_BLOOD",
	enName = "Molten Iron Blood",
	chName = "液态钢铁",
	desc = function(self, eff) return ("全体伤害抗性增加 %d%% ，新负面状态持续时间下降 %d%%， %0.2f 火焰反击伤害。 "):format(eff.resists, eff.reduction, eff.dam) end,
	type = "物理",
	subtype ="蒸汽科技/超能/火焰/抗性",
}

timeEffectCHN:newEffect{
	id = "SEARED",
	enName = "Seared",
	chName = "烧焦",
	desc = function(self, eff) return ("火焰抗性下降 %d%% ，精神豁免下降 %d."):format(eff.power, eff.power) end,
	type = "物理",
	subtype ="灵能/火焰",
}

timeEffectCHN:newEffect{
	id = "AWESOME_TOSS",
	enName = "Awesome Toss",
	chName = "致命翻转",
	desc = function(self, eff) return ("全抗性增加 %d%%，每回合随机攻击两名敌人。"):format(eff.resist) end,
	type = "物理",
	subtype ="蒸汽科技/致命/抗性",
}

timeEffectCHN:newEffect{
	id = "MARKED_LONGARM",
	enName = "Marked for Death",
	chName = "死亡印记",
	desc = function(self, eff) return ("远程闪避减少 %d, 受到额外 %d%% 伤害。"):format(eff.def, eff.dam) end,
	type = "物理",
	subtype ="蒸汽",
}

timeEffectCHN:newEffect{
	id = "ITCHING_POWDER",
	enName = "Itching Powder",
	chName = "痒痒粉",
	desc = function(self, eff) return ("太痒了，行动会失败。"):format() end,
	type = "物理",
	subtype ="粉末",
}

timeEffectCHN:newEffect{
	id = "SMOKE_COVER",
	enName = "Smoke Cover",
	chName = "烟雾覆盖",
	desc = function(self, eff) return ("%d%% 几率吸收伤害， %d 潜行强度。"):format(eff.power, eff.stealth) end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "MAGNETISED",
	enName = "Magnetised",
	chName = "磁化",
	desc = function(self, eff) return ("你被磁化，闪避下降 %d，疲劳增加 %d。"):format(eff.power, eff.power) end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "BLOODSTAR",
	enName = "Bloodstar",
	chName = "血液灵晶",
	desc = function(self, eff) return ("持续吸血，每回合受到 %0.2f 物理伤害并治疗攻击者一半伤害值。"):format(eff.dam) end,
	type = "物理",
	subtype ="血液/吸取/治疗",
}

timeEffectCHN:newEffect{
	id = "HEART_CUT",
	enName = "Heartrended",
	chName = "心脏切割",
	desc = function(self, eff) return ("恶毒的伤口在流血，每回合造成 %0.2f 物理伤害。 "):format(eff.power) end,
	type = "物理",
	subtype ="伤口/切割/流血",
}

timeEffectCHN:newEffect{
	id = "METAL_POISONING",
	enName = "Metal Poisoning",
	chName = "金属中毒",
	desc = function(self, eff) return ("目标重金属中毒，每回合受到 %0.2f 枯萎伤害，整体速度下降 %d%% 。"):format(eff.power, eff.speed) end,
	type = "物理",
	subtype ="毒素/枯萎",
}

timeEffectCHN:newEffect{
	id = "MOSS_TREAD",
	enName = "Moss Tread",
	chName = "苔藓之踏",
	desc = function(self, eff) return ("脚下长出苔藓。"):format() end,
	type = "物理",
	subtype ="苔藓",
}

timeEffectCHN:newEffect{
	id = "STIMPAK",
	enName = "Stimulus",
	chName = "兴奋剂",
	desc = function(self, eff) return ("抵抗疼痛，受到的伤害减少 %0.2f。效果结束后受到 %d 点不可阻挡的伤害。"):format(eff.power, (eff.power/3)*0.05 * self.max_life) end,
	type = "物理",
	subtype ="蒸汽科技",
}

timeEffectCHN:newEffect{
	id = "TO_THE_ARMS",
	enName = "To The Arms",
	chName = "切臂",
	desc = function(self, eff) return ("你造成的伤害减少 %d%% 。"):format(eff.power) end,
	type = "物理",
	subtype ="残废",
}

timeEffectCHN:newEffect{
	id = "CELESTIAL_ACCELERATION",
	enName = "Celestial Acceleration",
	chName = "天体加速",
	desc = function(self, eff)
		local strings = {}
		if eff.move then
			strings[#strings + 1] = ("移动速度增加 %d%%。"):format(eff.move * 100)
		end 
		if eff.cast then
			strings[#strings + 1] = ("施法速度增加 %d%%。"):format(eff.cast * 100)
		end 
		if eff.attack then
			strings[#strings + 1] = ("攻击速度增加 %d%%。"):format(eff.attack * 100)
		end 
		if eff.mind then
			strings[#strings + 1] = ("精神速度增加 %d%%。"):format(eff.mind * 100)
		end 
		if eff.power then
			strings[#strings + 1] = ("整体速度增加 %d%%。"):format(eff.power * 100)
		end
		
		return table.concat(strings, " ")
	end,
	type = "其他",
	subtype ="加速",
}

timeEffectCHN:newEffect{
	id = "OUTSIDE_THE_STARSCAPE",
	enName = "Outside the Starscape",
	chName = "星界之外",
	desc = function(self, eff) return ("该单位处于星界外，不能被星界内单位伤害。") end,
	type = "其他",
	subtype = "空间",
}

timeEffectCHN:newEffect{
	id = "MINDWALL_CONFUSED",
	enName = "Mindblasted",
	chName = "精神震爆",
	desc = function(self, eff) return ("目标混乱， %d%% 几率随机行动，不能完成复杂行为。"):format(eff.power) end,
	type = "其他",
	subtype ="混乱",
}

timeEffectCHN:newEffect{
	id = "AERYN_SUN_SHIELD",
	enName = "Shield of the Sun",
	chName = "日光之盾",
	desc = function(self, eff) return ("太阳的力量保护着目标。") end,
	type = "其他",
	subtype = "太阳",
}

timeEffectCHN:newEffect{
	id = "AERYN_SUN_REZ",
	enName = "A Light in the Darkness",
	chName = "黑暗之光",
	desc = function(self, eff) return ("太阳的力量充盈着目标。") end,
	type = "其他",
	subtype = "太阳",
}

timeEffectCHN:newEffect{
	id = "X_RAY",
	enName = "X-Ray Vision",
	chName = "X光视觉",
	desc = function(self, eff) return ("能看见 *任何 *事物。") end,
	type = "其他",
	subtype = "其他",
}

timeEffectCHN:newEffect{
	id = "NEKTOSH_WAND",
	enName = "Aiming!",
	chName = "瞄准!",
	desc = function(self, eff) return ("正瞄准发射强力激光。离开！") end,
	type = "其他",
	subtype = "其他",
}

timeEffectCHN:newEffect{
	id = "GESTALT_STEAM",
	enName = "Gestalt",
	chName = "格式塔",
	desc = function(self, eff) return ("获得 %d 蒸汽强度."):format(eff.power) end,
	type = "精神",
	subtype = "超能/格式塔",
}

timeEffectCHN:newEffect{
	id = "FORCED_GESTALT",
	enName = "Forced Gestalt",
	chName = "强力格式塔",
	desc = function(self, eff) return ("获得 %d 全体强度."):format(eff.power) end,
	type = "精神",
	subtype = "超能/格式塔",
}

timeEffectCHN:newEffect{
	id = "FORCED_GESTALT_FOE",
	enName = "Forced Gestalt",
	chName = "强力格式塔",
	desc = function(self, eff) return ("全体强度下降 %d."):format(eff.power) end,
	type = "精神",
	subtype = "超能/格式塔",
}

timeEffectCHN:newEffect{
	id = "MIND_DRONE",
	enName = "Mind Drone",
	chName = "精神雄蜂",
	desc = function(self, eff) return ("技能失败率 %d%%, 恐惧和睡眠免疫下降 %d%%."):format(eff.fail, eff.reduction) end,
	type = "精神",
	subtype = "超能/蒸汽/干扰",
}

timeEffectCHN:newEffect{
	id = "NEGATIVE_BIOFEEDBACK",
	enName = "Negative Biofeedback",
	chName = "负反馈",
	desc = function(self, eff) return ("物理豁免下降 %d,护甲和闪避下降 %d."):format(eff.save * eff.stacks, eff.power * eff.stacks) end,
	type = "精神",
	subtype = "超能/生物/物理/豁免",
}

timeEffectCHN:newEffect{
	id = "LUCID_SHOT",
	enName = "Unclear Thoughts",
	chName = "不清醒",
	desc = function(self, eff) return ("不能区分敌人和盟友。"):format() end,
	type = "精神",
	subtype = "混乱",
}

timeEffectCHN:newEffect{
	id = "PSY_WORM",
	enName = "Psy Worm",
	chName = "超能蠕虫",
	desc = function(self, eff) return ("被超能蠕虫感染 , 每回合受到 %0.2f 精神伤害。若处于震慑或恐惧状态，伤害加倍。能传播至周围生物。"):format(eff.power) end,
	type = "精神",
	subtype = "超能",
}

timeEffectCHN:newEffect{
	id = "NO_HOPE",
	enName = "No Hope",
	chName = "绝望",
	desc = function(self, eff) return ("伤害减少 40%%."):format() end,
	type = "精神",
	subtype = "超能/恐惧",
}

timeEffectCHN:newEffect{
	id = "ALL_SIGHT",
	enName = "All Seeing",
	chName = "看穿一切",
	desc = function(self, eff) return ("能看见周围的一切存在。"):format() end,
	type = "精神",
	subtype = "超能",
}

timeEffectCHN:newEffect{
	id = "CURSE_OF_AMAKTHEL",
	enName = "Curse of Amakthel",
	chName = "阿马克泰尔的诅咒",
	desc = function(self, eff) return ("所有新负面状态持续时间加倍。"):format() end,
	type = "精神",
	subtype ="超能/诅咒",
}

timeEffectCHN:newEffect{
	id = "TINKER_VIRAL",
	enName = "Viral Injection",
	chName = "病毒注射",
	desc = function(self, eff) return ("目标被疾病感染， %d 属性下降 %d ，每回合受到 %0.2f 枯萎伤害。"):format(eff.num_stats, eff.power, eff.dam) end,
	type = "魔法",
	subtype = "疾病/枯萎",
}

timeEffectCHN:newEffect{
	id = "STEAM_SHIELD",
	enName = "Steam Shield",
	chName = "蒸汽护盾",
	desc = function(self, eff) return ("目标被魔法蒸气护盾包围，吸收 %d/%d 伤害，获得 %d 火焰反击伤害。"):format(self.damage_shield_absorb, eff.power, self:damDesc(DamageType.FIRE, eff.retaliate)) end,
	type = "魔法",
	subtype ="奥术/护盾",
}

timeEffectCHN:newEffect{
	id = "TWILIT_ECHOES",
	enName = "Twilit Echoes",
	chName = "微光回响",
	desc = function(self, eff) return ([[目标感受到光暗伤害的回响。每点光明伤害减速 %0.2f%% ,最高 %d%% （ %d 伤害）。暗影伤害在该地格 %d 回合内每回合造成 %d%% 伤害，每次受到伤害时将刷新效果。]])
		:format(eff.slow_per * 100, eff.slow_max * 100, eff.slow_max / eff.slow_per, eff.echo_dur, eff.dam_factor * 100) end,
	type = "魔法",
	subtype ="黑暗/光明",
}

timeEffectCHN:newEffect{
	id = "ECHOED_LIGHT",
	enName = "Echoed Light",
	chName = "光明回响",
	desc = function(self, eff) return ([[目标减速 %d%%。（上限 %d%%）]])
		:format(eff.power * 100, eff.max * 100) end,
	type = "魔法",
	subtype ="减速",
}

timeEffectCHN:newEffect{
	id = "FLIP_SWAP",
	enName = "Mirror Worlded",
	chName = "镜像世界",
	desc = function(self, eff) return ("该单位即将切换空间。") end,
	type = "魔法",
	subtype ="时空",
}

timeEffectCHN:newEffect{
	id = "STARSCAPE",
	enName = "Starscape",
	chName = "星界",
	desc = function(self, eff) return ("召唤星界，减速所有生物 67%%。") end,
	type = "魔法",
	subtype = "天体",
}

timeEffectCHN:newEffect{
	id = "VAMPIRIC_SURGE",
	enName = "Vampiric Surge",
	chName = "吸血",
	desc = function(self, eff) return ("将 %d%% 伤害值转化为治疗。"):format(eff.power) end,
	type = "魔法",
	subtype ="堕落",
}

timeEffectCHN:newEffect{
	id = "TEMPORAL_RIPPLES",
	enName = "Temporal Ripples",
	chName = "时空涟漪",
	desc = function(self, eff) return ("攻击者将 %d%% 伤害值转化为治疗。"):format(eff.power) end,
	type = "魔法",
	subtype ="时空/时间",
}

timeEffectCHN:newEffect{
	id = "DEATH_MOMENTUM",
	enName = "Death Momentum",
	chName = "死亡波动",
	desc = function(self, eff) return ("层数 %d"):format(eff.stacks) end,
	type = "魔法",
	subtype ="亡灵",
}
timeEffectCHN:newEffect{
	id = "CAMPFIRE",
	enName = "Warm",
	chName = "温暖",
	desc = function(self, eff) return "目标被营火温暖。蒸汽回复 +6 ，震慑免疫 +30% ，体力回复 + 4." end,
	type = "其他",
	subtype = "地面",
}

timeEffectCHN:newEffect{
	enName = "Sun Radiance",
	id = "SUNWELL",
	chNmae = "日光",
	desc = function(self, eff) return "目标处于阳光的效果下。增加 2 点照明和视野， 3 0 % 目盲免疫 , 2 0 看穿潜行能力和 3 0 % 光明抗性。"end,
	type = "其他",
	subtype = "地面",
}

timeEffectCHN:newEffect{
	enName = "Moon Radiance", id = "MOONWELL",
	chName = "月光",
	desc = function(self, eff) return"目标处于月光的效果下。减少 1 点照明和视野，获得 3 0 % 震慑免疫 , 10 潜行能力和 3 0 % 暗影抗性."end,
	type = "其他",
	subtype = "地面",

}



--possessor
timeEffectCHN:newEffect{
	id = "OMINOUS_FORM",
	enName = "Ominous Form",
	chName = "不详躯体",
	desc = function (self, eff) return "你偷取了当前形态，并和它共享伤害与治疗。" end,
	type = "其他",
	subtype = "超能/支配",
}
timeEffectCHN:newEffect{
	id = "POSSESSION",
	enName = "Assume Form",
	chName = "附身",
	desc = function (self, eff) return "你使用你最近消灭的敌人的身体。在这个状态下你不能被治疗。" end,
	type = "其他",
	subtype = "超能/支配",
}
timeEffectCHN:newEffect{
	id = "POSSESSION_AFTERSHOCK",
	enName = "Possession Aftershock",
	chName = "支配余震",
	desc = function (self, eff) return ("目标正承受支配身体被摧毁的余震，伤害减少 60%%, 移动速度减少 50%%."):format() end,
	type = "其他",
	subtype = "震慑/支配/超能",
}
timeEffectCHN:newEffect{
	id = "POSSESS",
	enName = "Possess",
	chName = "支配",
	desc = function (self, eff) return ("目标被超能力网困住，将会被支配，每回合受到 %0.2f 精神伤害。"):format(eff.power) end,
	type = "其他",
	subtype = "超能/支配/精神",
}
timeEffectCHN:newEffect{
	id = "PSYCHIC_WIPE",
	enName = "Psychic Wipe",
	chName = "精神鞭打",
	desc = function (self, eff) return ("空灵手指摧毁目标大脑，每回合造成 %0.2f 精神伤害，并减少 %d 精神豁免。"):format(eff.dam, eff.reduct) end,
	type = "精神",
	subtype = "超能/精神",
}
timeEffectCHN:newEffect{
	id = "GHASTLY_WAIL",
	enName = "Ghastly Wail",
	chName = "恐怖嚎叫",
	desc = function (self, eff) return "目标被眩晕，不能移动，减半伤害、闪避、豁免、命中、强度，受伤害后解除。" end,
	type = "精神",
	subtype = "震慑/超能",
}
timeEffectCHN:newEffect{
	id = "MIND_STEAL_REMOVE",
	enName = "Mind Steal",
	chName = "精神窃取",
	desc = function (self, eff) return ("偷取技能: %s"):format(self:getTalentFromId(eff.tid).name) end,
	type = "其他",
	subtype = "超能",
}
timeEffectCHN:newEffect{
	id = "MIND_STEAL",
	enName = "Mind Steal",
	chName = "精神窃取",
	desc = function (self, eff) return ("偷取技能: %s"):format(self:getTalentFromId(eff.tid).name) end,
	type = "其他",
	subtype = "超能",
}
timeEffectCHN:newEffect{
	id = "WRITHING_PSIONIC_MASS",
	enName = "Writhing Psionic Mass",
	chName = "扭曲装甲",
	desc = function (self, eff) return ("所有抗性增加 %d%%, 被暴击率减少 %d%%。"):format(eff.resists, eff.crit) end,
	type = "物理",
	subtype = "超能",
}
timeEffectCHN:newEffect{
	id = "PSIONIC_DISRUPTION",
	enName = "Psionic Disruption",
	chName = "灵能瓦解",
	desc = function (self, eff) return ("%d 层。每层效果每回合造成 %0.2f 精神伤害。"):format(eff.stacks, eff.dam) end,
	type = "精神",
	subtype = "超能/伤害",
}
timeEffectCHN:newEffect{
	id = "PSIONIC_BLOCK",
	enName = "Psionic Block",
	chName = "灵能格挡",
	desc = function (self, eff) return ("%d%% 几率无视伤害并反击 %0.2f 精神伤害。"):format(eff.chance, eff.dam) end,
	type = "精神",
	subtype = "超能/伤害",
}
timeEffectCHN:newEffect{
	id = "SADIST",
	enName = "Sadist",
	chName = "虐待狂",
	desc = function (self, eff) return ("精神强度 ( 原始值 ) 增加 %d。"):format(eff.stacks * eff.power) end,
	type = "精神",
	subtype = "超能",
}
timeEffectCHN:newEffect{
	id = "RADIATE_AGONY",
	enName = "Radiate Agony",
	chName = "痛苦辐射",
	desc = function (self, eff) return ("所有伤害减少 %d%%."):format(eff.power) end,
	type = "精神",
	subtype = "超能",
}
timeEffectCHN:newEffect{
	id = "TORTURE_MIND",
	enName = "Tortured Mind",
	chName = "精神拷打",
	desc = function (self, eff) return ("%d 项技能不能使用。"):format(eff.nb) end,
	type = "精神",
	subtype = "超能/锁定",
}
