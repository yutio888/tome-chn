
timeEffectCHN:newEffect{
	id = "ETHEREAL_FORM", 
	enName = "Ethereal Form",
	chName = "虚幻形态",
	desc = function(self, eff) return ("虚 幻 形 态 的 效 果 减 少 %d%%"):format(eff.stacks * 5) end,
	type = "其他",
	subtype = "",
}

timeEffectCHN:newEffect{
	id = "ELEMENTAL_SURGE_ARCANE", 
	enName = "Elemental Surge: Arcane",
	chName = "元素涌动： 奥术",
	desc = function(self, eff) return ("法 术 和 精 神 速 度 增 加 30%%") end,
	type = "其他",
	subtype = "元素",
}

timeEffectCHN:newEffect{
	id = "ELEMENTAL_SURGE_PHYSICAL", 
	enName = "Elemental Surge: Physical",
	chName = "元素涌动： 物理",
	desc = function(self, eff) return ("对 物 理 负 面 状 态 免 疫") end,
	type = "其他",
	subtype = "元素",
}

timeEffectCHN:newEffect{
	id = "ELEMENTAL_SURGE_NATURE", 
	enName = "Elemental Surge: Nature",
	chName = "元素涌动：自然",
	desc = function(self, eff) return ("对 魔 法 负 面 状 态 免 疫") end,
	type = "其他",
	subtype = "元素",
}

timeEffectCHN:newEffect{
	id = "ELEMENTAL_SURGE_FIRE", 
	enName = "Elemental Surge: Fire",
	chName = "元素涌动： 火焰",
	desc = function(self, eff) return ("全 部 伤 害 增 加 %d%%"):format(eff.damage) end,
	type = "其他",
	subtype = "元素",
}

timeEffectCHN:newEffect{
	id = "ELEMENTAL_SURGE_COLD", 
	enName = "Elemental Surge: Cold",
	chName = "元素涌动： 寒冷",
	desc = function(self, eff) return ("护 甲 增 加 %d, 获 得 %d 冰 系 近 战 反 伤"):format(eff.armor, eff.dam) end,
	type = "其他",
	subtype = "元素",
}

timeEffectCHN:newEffect{
	id = "ELEMENTAL_SURGE_LIGHTNING", 
	enName = "Elemental Surge: Lightning",
	chName = "元素涌动： 闪电",
	desc = function(self, eff) return ("移 动 速 度 增 加 %d%%"):format(eff.move) end,
	type = "其他",
	subtype = "元素",
}

timeEffectCHN:newEffect{
	id = "ELEMENTAL_SURGE_LIGHT", 
	enName = "Elemental Surge: Light",
	chName = "元素涌动： 光明",
	desc = function(self, eff) return ("技 能 冷 却 减 少 %d%%"):format(eff.cooldown) end,
	type = "其他",
	subtype = "元素",
}

timeEffectCHN:newEffect{
	id = "SURGING_CIRCLES", 
	enName = "Circle Surge",
	chName = "法阵潮涌",
	desc = function(self, eff) return [[法 阵 散 发 着 潮 涌 的 残 存 能 量。
		暗 影 之 阵 ： 获 得 +1 负 能 量 。
		圣 洁 之 阵 ： 获 得 +1 正 能 量 。
		守 护 之 阵 ： 获 得 +0.5 正 能 量 和 负 能 量 。]] end,
	type = "其他",
	subtype = "",
}

timeEffectCHN:newEffect{
	id = "FLASH_SHIELD",
	enName = "Protected by the sun",
	chName = "阳光保护",
	type = "其他",
	subtype = "",
}

timeEffectCHN:newEffect{
	id = "ABSORPTION_STRIKE",
	enName = "Absorbtion Strike",
	chName = "吸能一击",
	type = "其他",
	subtype = "太阳",
}

timeEffectCHN:newEffect{
	id = "ITEM_CHARM_PIERCING", 
	enName = "Charm:  Piercing",
	chName = "附魔：穿透",
	desc =  function(self, eff) return ("抗性穿透增加 %d%%."):format(eff.penetration) end,
	type = "其他",
	subtype = "",
}

timeEffectCHN:newEffect{
	id = "ITEM_CHARM_POWERFUL", 
	enName = "Charm:  Damage",
	chName = "附魔：伤害",
	desc =  function(self, eff) return ("伤害增加 %d%%."):format(eff.damage) end,
	type = "其他",
	subtype = "",
}

timeEffectCHN:newEffect{
	id = "ITEM_CHARM_SAVIOR", 
	enName = "Charm:  Saves",
	chName = "附魔：豁免",
	desc =  function(self, eff) return ("豁免增加 by %d."):format(eff.save) end,
	type = "其他",
	subtype = "",
}

timeEffectCHN:newEffect{
	id = "ITEM_CHARM_EVASIVE", 
	enName = "Charm:  Evasion",
	chName = "附魔：闪避",
	desc =  function(self, eff) return ("%d%% 几率闪避武器攻击"):format(eff.chance) end,
	type = "其他",
	subtype = "",
}

timeEffectCHN:newEffect{
	id = "ITEM_CHARM_INNERVATING", 
	enName = "Charm:  Innervating",
	chName = "附魔：激励",
	desc =  function(self, eff) return ("疲劳减少%d%%"):format(eff.fatigue) end,
	type = "其他",
	subtype = "",
}

timeEffectCHN:newEffect{
	id = "TREE_OF_LIFE",
	enName = "You have taken root!",
	chName = "扎根！",
	type = "其他",
	subtype = "自然",
}

timeEffectCHN:newEffect{
	id = "INFUSION_COOLDOWN",
	enName = "Infusion Saturation",
	chName = "纹身饱和",
	type = "其他",
	subtype = "纹身",
}


timeEffectCHN:newEffect{
	id = "INFUSION_COOLDOWN",
	enName = "Infusion Saturation",
	chName = "纹身饱和",
	type = "其他",
	subtype = "纹身",
}

timeEffectCHN:newEffect{
	id = "RUNE_COOLDOWN",
	enName = "Runic Saturation",
	chName = "符文饱和",
	type = "其他",
	subtype = "符文",
}

timeEffectCHN:newEffect{
	id = "TAINT_COOLDOWN",
	enName = "Tainted",
	chName = "印记饱和",
	type = "其他",
	subtype = "印记",
}

timeEffectCHN:newEffect{
	id = "PATH_OF_THE_SUN",
	enName = "Path of the sun",
	chName = "阳光大道",
	desc = function(self, eff) return ("目 标 在 阳 光 大 道 上 行 走 不 消 耗 时 间。"):format() end,
	type = "其他",
	subtype = "太阳",
}

timeEffectCHN:newEffect{
	id = "TIME_PRISON",
	enName = "Time Prison",
	chName = "时间牢笼",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "TIME_SHIELD",
	enName = "Time Shield",
	chName = "时间护盾",
	type = "其他",
	subtype = "时间/护盾",
}

timeEffectCHN:newEffect{
	id = "TIME_DOT",
	enName = "Temporal Restoration Field",
	chName = "时间储能",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "GOLEM_OFS",
	enName = "Golem out of sight",
	chName = "傀儡在视线外",
	type = "其他",
	subtype = "混合",
}
timeEffectCHN:newEffect{
	id = "AMBUSCADE_OFS",
	enName = "Shadow out of sight",
	chName = "阴影在视线外",
	type = "其他",
	subtype = "混合",
}
timeEffectCHN:newEffect{
	id = "HUSK_OFS",
	enName = "Husk out of sight",
	chName = "傀儡在视线外",
	type = "其他",
	subtype = "混合",
}

timeEffectCHN:newEffect{
	id = "CONTINUUM_DESTABILIZATION",
	enName = "Continuum Destabilization",
	chName = "连续紊乱",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "SUMMON_DESTABILIZATION",
	enName = "Summoning Destabilization",
	chName = "召唤紊乱",
	type = "其他",
	subtype = "混合",
}

timeEffectCHN:newEffect{
	id = "DAMAGE_SMEARING",
	enName = "Damage Smearing",
	chName = "时空转化",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "SMEARED",
	enName = "Smeared",
	chName = "转化",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "PRECOGNITION",
	enName = "Precognition",
	chName = "预知未来",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "SEE_THREADS",
	enName = "See the Threads",
	chName = "时空抉择",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "IMMINENT_PARADOX_CLONE",
	enName = "Imminent Paradox Clone",
	chName = "无序克隆迫近",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "PARADOX_CLONE",
	enName = "Paradox Clone",
	chName = "无序克隆",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "MILITANT_MIND",
	enName = "Militant Mind",
	chName = "好斗精神",
	type = "其他",
	subtype = "混合",
}

timeEffectCHN:newEffect{
	id = "SEVER_LIFELINE",
	enName = "Sever Lifeline",
	chName = "生命离断",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "SPACETIME_STABILITY",
	enName = "Spacetime Stability",
	chName = "时空稳固",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "FADE_FROM_TIME",
	enName = "Fade From Time",
	chName = "时光消逝",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "SHADOW_VEIL",
	enName = "Shadow Veil",
	chName = "暗影面纱",
	type = "其他",
	subtype = "暗影",
}

timeEffectCHN:newEffect{
	id = "ZERO_GRAVITY",
	enName = "Zero Gravity",
	chName = "失重",
	type = "其他",
	subtype = "时空",
}

timeEffectCHN:newEffect{
	id = "CURSE_OF_CORPSES",
	enName = "Curse of Corpses",
	chName = "尸体诅咒",
	type = "其他",
	subtype = "诅咒",
}

timeEffectCHN:newEffect{
	id = "CURSE_OF_MADNESS",
	enName = "Curse of Madness",
	chName = "疯狂诅咒",
	type = "其他",
	subtype = "诅咒",
}

timeEffectCHN:newEffect{
	id = "CURSE_OF_SHROUDS",
	enName = "Curse of Shrouds",
	chName = "屏障诅咒",
	type = "其他",
	subtype = "诅咒",
}

timeEffectCHN:newEffect{
	id = "SHROUD_OF_WEAKNESS",
	enName = "Shroud of Weakness",
	chName = "虚弱屏障",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "SHROUD_OF_PASSING",
	enName = "Shroud of Passing",
	chName = "屏障穿越",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "SHROUD_OF_DEATH",
	enName = "Shroud of Death",
	chName = "死亡屏障",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "CURSE_OF_NIGHTMARES",
	enName = "Curse of Nightmares",
	chName = "噩梦诅咒",
	type = "其他",
	subtype = "诅咒",
}

timeEffectCHN:newEffect{
	id = "CURSE_OF_MISFORTUNE",
	enName = "Curse of Misfortune",
	chName = "厄运诅咒",
	type = "其他",
	subtype = "诅咒",
}

timeEffectCHN:newEffect{
	id = "RELOADING",
	enName = "Reloading",
	chName = "装填弹药",
	type = "其他",
	subtype = "混合",
}

timeEffectCHN:newEffect{
	id = "PROB_TRAVEL_UNSTABLE",
	enName = "Time Prison",
	chName = "时空牢笼",
	type = "其他",
	subtype = "时间/空间",
}

timeEffectCHN:newEffect{
	id = "CURSED_FORM",
	enName = "Cursed Form",
	chName = "诅咒形态",
	type = "其他",
	subtype = "诅咒",
}

timeEffectCHN:newEffect{
	id = "FADED",
	enName = "Faded",
	chName = "隐匿",
	type = "其他",
	subtype = "无",
}

timeEffectCHN:newEffect{
	id = "POSSESSION",
	enName = "Psionic Consume",
	chName = "超能灌注",
	type = "其他",
	subtype = "超能力/支配",
}

timeEffectCHN:newEffect{
	id = "HIGHBORN_S_BLOOM",
	enName = "Highborn's Bloom",
	chName = "生命绽放",
	type = "其他",
	subtype = "奥术",
}

timeEffectCHN:newEffect{
	id = "VICTORY_RUSH_ZIGUR",
	enName = "Victory Rush",
	chName = "胜利冲锋",
	type = "其他",
	subtype = "奥术",
}

timeEffectCHN:newEffect{
	id = "SOLIPSISM",
	enName = "Solipsism",
	chName = "唯我主义",
	type = "其他",
	subtype = "超能力",
}

timeEffectCHN:newEffect{
	id = "CLARITY",
	enName = "Clarity",
	chName = "唯我论：明晰",
	type = "其他",
	subtype = "超能力",
}

timeEffectCHN:newEffect{
	id = "DREAMSCAPE",
	enName = "Dreamscape",
	chName = "梦境空间",
	type = "其他",
	subtype = "超能力",
}

timeEffectCHN:newEffect{
	id = "DISTORTION",
	enName = "Distortion",
	chName = "扭曲",
	type = "其他",
	subtype = "扭曲",
}

timeEffectCHN:newEffect{
	id = "REVISIONIST_HISTORY",
	enName = "Revisionist History",
	chName = "修正历史",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_FIRE",
	enName = "Oil mist",
	chName = "油雾",
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_COLD",
	enName = "Grave chill",
	chName = "墓地深寒",
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_LIGHTNING",
	enName = "Static discharge",
	chName = "静电放射",
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_ACID",
	enName = "Noxious fumes",
	chName = "毒性气体",
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_DARKNESS",
	enName = "Echoes of the void",
	chName = "虚空回音",
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_MIND",
	enName = "Eerie silence",
	chName = "恐惧噤声",
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_LIGHT",
	enName = "Aura of light",
	chName = "圣光光环",
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_ARCANE",
	enName = "Aether residue",
	chName = "以太残渣",
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_TEMPORAL",
	enName = "Impossible geometries",
	chName = "扭曲空间",
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_PHYSICAL",
	enName = "Uncontrolled anger",
	chName = "无边愤怒",
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_BLIGHT",
	enName = "Miasma",
	chName = "瘴气",
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_NATURE",
	enName = "Slimy floor",
	chName = "泥泞之地",
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "VAULTED",
	enName = "In Vault",
	chName = "陷入迷宫",
	type = "其他",
	subtype = "迷宫",
}

timeEffectCHN:newEffect{
	id = "CAUTERIZE",
	enName = "Cauterize",
	chName = "灼烧",
	type = "其他",
	subtype = "火焰",
}

timeEffectCHN:newEffect{
	id = "EIDOLON_PROTECT",
	enName = "Protected by the Eidolon",
	chName = "受艾德隆保护",
	type = "其他",
	subtype = "艾德隆",
}

timeEffectCHN:newEffect{
	id = "CLOAK_OF_DECEPTION",
	enName = "Cloak of Deception",
	chName = "欺诈斗篷",
	type = "其他",
	subtype = "亡灵",
}
 
timeEffectCHN:newEffect{
	id = "SUFFOCATING",
	enName = "Suffocating",
	chName = "窒息",
	type = "其他",
	subtype = "窒息",
}
timeEffectCHN:newEffect{
	id = "ANTIMAGIC_DISRUPTION",
	enName = "Antimagic Disruption",
	chName = "反魔干扰",
	type = "其他",
	subtype = "反魔",
}
timeEffectCHN:newEffect{
	id = "SWIFT_HANDS_CD",
	enName = "Swift Hands",
	chName = "无影手冷却",
	type = "其他",
	subtype = "觉醒技",
}
timeEffectCHN:newEffect{
	id = "HUNTER_PLAYER",
	enName = "Hunter!",
	chName = "捕猎中！",
	type = "其他",
	subtype = "绝望",
}

timeEffectCHN:newEffect{
	id = "THROUGH_THE_CROWD",
	enName = "Through The Crowd",
	chName = "穿梭人群",
	type = "其他",
	subtype = "觉醒技",
}

timeEffectCHN:newEffect{
	id = "RELOAD_DISARMED",
	enName = "Reloading",
	chName = "装弹",
	type = "其他",
	subtype = "缴械",
}

timeEffectCHN:newEffect{
	id = "SPACETIME_TUNING",
	enName = "Spacetime Tuning",
	chName = "时空调谐",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "TIME_STOP",
	enName = "Time Stop",
	chName = "时间停止",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "TEMPORAL_REPRIEVE",
	enName = "Temporal Reprieve",
	chName = "时间避难所",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "TEMPORAL_FUGUE",
	enName = "Temporal Fugue",
	chName = "时间复制体",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "REALITY_SMEARING",
	enName = "Reality Smearing",
	chName = "弥散现实",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "AEONS_STASIS",
	enName = "Aeons Statis",
	chName = "静态时空",
	type = "其他",
	subtype = "时间",
}


timeEffectCHN:newEffect{
	id = "2H_PENALTY",
	enName = "Hit Penalty",
	chName = "双手惩罚",
	type = "其他",
	subtype = "战斗/惩罚",
}

timeEffectCHN:newEffect{
	id = "TWIST_FATE",
	enName = "Twist Fate",
	chName = "扭曲命运",
	type = "其他",
	subtype = "时间",
}

timeEffectCHN:newEffect{
	id = "WARDEN_S_TARGET",
	enName = "Warden's Focus Target",
	chName = "选定的目标",
	type = "其他",
	subtype = "策略",
}

timeEffectCHN:newEffect{
	id = "DEATH_DREAM",
	enName = "Death in a Dream",
	chName = "梦中死亡",
	type = "其他",
	subtype = "精神",
}
timeEffectCHN:newEffect{
	id = "ZONE_AURA_GORBAT",
	enName = "Natural Aura",
	chName = "自然光环",
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_VOR",
	enName = "Sorcerous Aura",
	chName = "魔法光环",
	type = "其他",
	subtype = "光环",
}



timeEffectCHN:newEffect{
	id = "ZONE_AURA_GRUSHNAK",
	enName = "Disciplined Aura",
	chName = "纪律光环",
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_RAKSHOR",
	enName = "Sinister Aura",
	chName = "危险光环",	
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_UNDERWATER",
	enName = "Underwater Zone",
	chName = "水下区域",	
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_FEARSCAPE",
	enName = "Fearscape Zone",
	chName = "恐惧空间",
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_OUT_OF_TIME",
	enName = "Out of Time Zone",
	chName = "异常时空",
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_SPELLBLAZE",
	enName = "Spellblaze Aura",
	chNmae = "魔法大爆炸区域",
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_CALDERA",
	enName = "Heady Scent",
	chName = "催眠区域",
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_THUNDERSTORM",
	enName = "Thunderstorm",
	chNmae = "雷暴区域",
	type = "其他",
	subtype = "光环",
}

timeEffectCHN:newEffect{
	id = "ZONE_AURA_ABASHED",
	enName = "Abashed Expanse",
	chName = "不稳区域",
	type = "其他",
	subtype = "光环",
}


timeEffectCHN:newEffect{
	id ="DEMI_GODMODE",
	enName ="Demigod Mode", 
	desc =function(self, eff) return ("DEMI-GODMODE: Target has 10000 additional life and regenerates 2000 life per turn.  It deals +500%% damage, and has full ESP."):format() end,
	type = "其他",
	subtype = "作弊",
}

timeEffectCHN:newEffect{
	id ="GODMODE",
	enName ="God Mode", 
	desc =function(self, eff) return ("GODMODE: Target is invulnerable to damage, immune to bad status effects, deals +10000%% damage (100%% penetration), does not need to breathe, and has full ESP."):format() end,
	type = "其他",
	subtype = "作弊",
}

timeEffectCHN:newEffect{
	id ="SLIPPERY_GROUND", 
	enName ="Slippery Ground",
	chName ="地面光滑",
	desc =function(self, eff) return ("很 难 保 持 平 衡 ， 每 次 使 用 技 能 有 %d%% 几 率 失 败 。"):format(eff.fail) end,
	type = "其他",
	subtype = "自然",
}

timeEffectCHN:newEffect{
	id ="FROZEN_GROUND", 
	enName ="Frozen Ground",
	chName = "地面冻结",
	desc =function(self, eff) return ("目 标 获 得 20%% 寒 冷 伤 害 加 成。"):format(eff.fail) end,
	type = "其他",
	subtype = { nature=true },
	status = "beneficial",
	parameters = {},
	on_gain = function(self, err) return "#Target# is energized by the cold!", "+Frozen Ground" end,
	on_lose = function(self, err) return "#Target# regains balance.", "-Frozen Ground" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_damage", {[engine.DamageType.COLD] = 20})
	end,
	deactivate = function(self, eff)
	end,
}

timeEffectCHN:newEffect{
	id ="RECALL", 
	enName ="Recalling",
	chName = "召回",
	desc = function(self, eff) return "目 标 等 待 被 召 回 至 世 界 地 图。" end,
	type = "魔法",
	subtype = "未知力量",
}

timeEffectCHN:newEffect{
	id ="STEALTH_SKEPTICAL", 
	enName ="Skeptical",
	chName = "怀疑",
	desc =function(self, eff) return "目 标 不 相 信 同 伴 在 黑 暗 中 看 到 了 任 何 东 西。" end,
	type = "其他",
	subtype = "",
}

timeEffectCHN:newEffect{
	id ="UNLIT_HEART", 
	enName ="Empowered by the shadows",
	chName = "黑暗强化",
	desc =function(self, eff) return (" 全体伤害增加 %d%% ， 全体伤害抗性增加 %d%% "):format(eff.dam, eff.res) end,
	type = "其他",
	subtype = "黑暗",
}

timeEffectCHN:newEffect{
	id ="INTIMIDATED",
	enName ="Intimidated",
	chName = "胆怯",
	desc =function(self, eff) return ("目 标 士 气 低 落 ， 物 理 、 法 术 和 精 神 强 度 减 少 %d"):format(eff.power) end,
	charges = function(self, eff) return math.round(eff.power) end,	
	type = "其他",
	subtype = "",
}

