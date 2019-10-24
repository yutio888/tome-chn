local DamageType = require "engine.DamageType"
--cults
timeEffectCHN:newEffect{
		id = "SMACK_ENTROPIC_WORMHOLE",
		enName = "S.M.A.C.K.",
		chName = "S.M.A.C.K.",
		desc = function(self, eff) return "攻击敌人！堡垒会保护你。" end,
		type = "其它",
		subtype = " other ",
}
timeEffectCHN:newEffect{
		id = "DREM_FRENZY",
		enName = "Frenzy",
		chName = "狂热",
		desc = function(self, eff) return "第一次使用的职业技能不进入冷却。" end,
		type = "精神",
		subtype = " frenzy ",
}
timeEffectCHN:newEffect{
		id = "SPIKESKIN_BLACK_BLOOD",
		enName = "Black Blood Bleeding",
		chName = "黑血横流",
		desc = function(self, eff) return ("黑血横流，每回合造成 %0.2f 暗影伤害。"):format(eff.power) end,
		type = "魔法",
		subtype = " bleed ",
}
timeEffectCHN:newEffect{
		id = "SPIKESKIN",
		enName = "Spikeskin",
		chName = "尖刺皮肤",
		desc = function(self, eff) return ("被黑血强化，获得 %d%% 全体抗性。"):format(eff.power) end,
		type = "魔法",
		subtype = " blood ",
}
timeEffectCHN:newEffect{
		id = "SLIMY_TENDRIL",
		enName = "Slimy Tendril",
		chName = "黏稠触须",
		desc = function(self, eff) return ("被触须抓住，造成的所有伤害降低 %d%% 。"):format(eff.power) end,
		type = "魔法",
		subtype = " slime/ corrupted ",
}
timeEffectCHN:newEffect{
		id = "TENTACLE_CONSTRICT",
		enName = "Tentacle Constriction",
		chName = "触手纠缠",
		desc = function(self, eff) return ("被 %s 的触手纠缠，每回合造成 %d%% 触手伤害并将你拉近一格。"):format(npcCHN:getName(eff.src.name), eff.dam * 100) end,
		type = "其它",
		subtype = " ",
}
timeEffectCHN:newEffect{
		id = "CARRION_FEET",
		enName = "Carrion Feet",
		chName = "蠕动之足",
		desc = function(self, eff) return ("被恶心的蠕虫抓住，造成的伤害减少 %d%%。"):format(eff.power) end,
		type = "魔法",
		subtype = " slime/ corrupted ",
}
timeEffectCHN:newEffect{
		id = "CULTS_OVERGROWTH",
		enName = "Overgrowth",
		chName = "巨型变异",
		desc = function(self, eff) return ("能走过墙体并且每回合引发地震。增加 %d%% 伤害并获得 %d%% 伤害抗性。"):format(eff.dam, eff.resist) end,
		type = "魔法",
		subtype = " growth/ corrupted/ massive ",
}
timeEffectCHN:newEffect{
		id = "DECAYING_GUTS",
		enName = "Decaying Guts",
		chName = "腐化",
		desc = function(self, eff) return ("整体速度减少 %d%% 。"):format(eff.power * 100) end,
		type = "魔法",
		subtype = " corruption/ slow ",
}
timeEffectCHN:newEffect{
		id = "WTW_OFS",
		enName = "Worm that Walks out of sight",
		chName = "蠕虫合体在视野外",
		desc = function(self, eff) return "蠕虫合体在主人的视野外；无法直接控制它！" end,
		type = "其它",
		subtype = " miscellaneous ",
}
timeEffectCHN:newEffect{
		id = "WTW_SHARED_INSANITY",
		enName = "Shared Insanity",
		chName = "共享疯狂",
		desc = function(self, eff) return ("和恐魔建立链接，获得 %d%% 全体伤害抗性。"):format(eff.resist) end,
		type = "其它",
		subtype = " miscellaneous ",
}
timeEffectCHN:newEffect{
		id = "WTW_TERRIBLE_SIGHT",
		enName = "Terrible Sight",
		chName = "恐怖景象",
		desc = function(self, eff) return ("被两个恐魔惊恐，闪避和法术豁免降低 %d 。"):format(eff.save) end,
		type = "其它",
		subtype = " ",
}
timeEffectCHN:newEffect{
		id = "CHAOS_ORBS",
		enName = "Chaos Orbs",
		chName = "混沌之球",
		desc = function(self, eff) return ("%d 层, +%d%% 伤害。"):format(eff.stacks, eff.stacks*3) end,
		type = "魔法",
		subtype = " chaos/ damage/ insanity ",
}
timeEffectCHN:newEffect{
		id = "PUTRESCENT_PUSTULE",
		enName = "Putrescent Pustule",
		chName = "脓包",
		desc = function(self, eff) return ("%d 脓包，增加 %d%% 抗性。"):format(eff.stacks, eff.stacks * eff.power) end,
		type = "魔法",
		subtype = " horror/ blight ",
}
timeEffectCHN:newEffect{
		id = "DIGEST",
		enName = "Digesting",
		chName = "消化中",
		desc = function(self, eff) return ("消化 %s 中."):format(npcCHN:getName(eff.victim.name)) end,
		type = "魔法",
		subtype = " eat/ digest ",
}
timeEffectCHN:newEffect{
		id = "INNER_TENTACLES",
		enName = "Inner Tentacles",
		chName = "内部触手",
		desc = function(self, eff) return ("%d%% 吸血几率，%d%% 强度。"):format(eff.chance, eff.power) end,
		type = "魔法",
		subtype = " pain/ torture/ tentacles/ leech ",
}
timeEffectCHN:newEffect{
		id = "HORRIFIC_DISPLAY",
		enName = "Horrific Display",
		chName = "恐魔具现化",
		desc = function(self, eff) return ("外貌变化为恐魔，令其他人和它敌对。"):format() end,
		type = "魔法",
		subtype = " horror/ morph ",
}
timeEffectCHN:newEffect{
		id = "DISOLVED_FACE",
		enName = "Dissolved Face",
		chName = "溶解之脸",
		desc = function(self, eff) return ("目标被血肉覆盖，每回合每种疾病额外造成 %0.2f 暗影和 %0.2f 枯萎伤害。"):format(eff.dam, eff.dam * 0.7) end,
		type = "魔法",
		subtype = " darkness/ blight/ gore ",
}
timeEffectCHN:newEffect{
		id = "GLIMPSE_OF_TRUE_HORROR",
		enName = "Glimpse of True Horror",
		chName = "恐怖无边",
		desc = function(self, eff) return ("目标被真正的恐惧吓倒， %d%% 几率使用技能失败。"):format(eff.fail) end,
		type = "魔法",
		subtype = " darkness/ blight/ horror/ fear ",
}
timeEffectCHN:newEffect{
		id = "GLIMPSE_OF_TRUE_HORROR_SELF",
		enName = "Glimpse of True Horror",
		chName = "恐怖无边",
		desc = function(self, eff) return ("被敌人的恐惧强化，获得 %d%% 黑暗和枯萎抗性穿透。"):format(eff.pen) end,
		type = "魔法",
		subtype = " darkness/ blight/ horror ",
}
timeEffectCHN:newEffect{
		id = "WRITHING_HAIRS",
		enName = "Writhing Hairs",
		chName = "苦痛之发",
		desc = function(self, eff) return ("半石化中，移动速度降低 %d%%， 35%% 几率增加 %d%% 受到的伤害。"):format(eff.speed * 100, eff.brittle) end,
		type = "魔法",
		subtype = " stone ",
}
timeEffectCHN:newEffect{
		id = "SPLIT",
		enName = "Split",
		chName = "命运裂解",
		desc = function(self, eff) return ("从时间线上消失，减少 %d%% 受到的伤害和 %d%% 造成的伤害。"):format(eff.power, eff.dam) end,
		type = "魔法",
		subtype = " temporal/ ",
}
-- mark
timeEffectCHN:newEffect{
		id = "HALO_OF_RUIN",
		enName = "Halo of Ruin",
		chName = "毁灭光环",
		desc = function(self, eff) return ("增加法术暴击率 %d%% ，在 5 层时，下一个虚境法术获得加成。"):format(eff.power * eff.charges) end,
		type = "魔法",
		subtype = " blight ",
}
timeEffectCHN:newEffect{
		id = "VOIDBURN",
		enName = "Voidburn",
		chName = "虚空灼烧",
		desc = function(self, eff) return ("目标被虚空折磨，每回合造成 %0.2f 暗影和 %0.2f 时空伤害。"):format(math.floor(eff.power/2), math.floor(eff.power/2)) end,
		type = "魔法",
		subtype = " temporal/ darkness ",
}
timeEffectCHN:newEffect{
		id = "DARK_WHISPERS",
		enName = "Dark Whispers",
		chName = "黑暗低语",
		desc = function(self, eff) return ("目标被虚空压迫至疯狂，每回合受到 %0.2f 点暗影伤害并且降低 %d 点全部强度。"):format(eff.dam, eff.power) end,
		type = "魔法",
		subtype = " darkness ",
}
timeEffectCHN:newEffect{
		id = "HIDEOUS_VISIONS",
		enName = "Hideous Visions",
		chName = "惊骇幻象",
		desc = function(self, eff) return ("目标被幻觉所困 , 降低其对非幻觉单位造成的伤害 %d%% 。"):format(eff.power) end,
		type = "其它",
		subtype = " darkness ",
}
timeEffectCHN:newEffect{
		id = "CACOPHONY",
		enName = "Cacophony",
		chName = "心灵尖啸",
		desc = function(self, eff) return ("目标被虚空之声淹没 , 让他们从黑暗低语中产生幻觉的几率增加 20%% ，并使他们从黑暗低语和丑恶幻视中受到额外 %d%% 点时空伤害。"):format(eff.power) end,
		type = "魔法",
		subtype = " temporal ",
}
timeEffectCHN:newEffect{
		id = "ENTROPIC_WASTING",
		enName = "Entropic Wasting",
		chName = "熵能冲击",
		desc = function(self, eff) return ("目标被熵能冲击中，每回合受到 %d 伤害。"):format(eff.power) end,
		type = "其它",
		subtype = " temporal/ darkness ", no_ct_effect = true,
}
timeEffectCHN:newEffect{
		id = "ENTROPIC_GIFT",
		enName = "Entropic Gift",
		chName = "熵能掌控",
		desc = function(self, eff) return ("熵能冲击被施加给目标，每回合造成 %0.2f 暗影和 %0.2f 时空伤害。"):format(eff.power/2, eff.power/2) end,
		type = "魔法",
		subtype = " temporal/ darkness ",
}
timeEffectCHN:newEffect{
		id = "PROPHECY_OF_MADNESS",
		enName = "Prophecy of Madness",
		chName = "疯狂预言",
		desc = function(self, eff) return ("目标被诅咒进入疯狂状态。技能冷却时间增加 %d%%。"):format(eff.power*100) end,
		type = "魔法",
		subtype = " darkness/ prophecy ",
}
timeEffectCHN:newEffect{
		id = "PROPHECY_OF_RUIN",
		enName = "Prophecy of Ruin",
		chName = "毁灭预言",
		desc = function(self, eff) return ("目标被诅咒进入毁灭状态。当生命值下降至 75%%, 50%% 或 25%% life 时， %d 格内敌人将受到 %d 暗影伤害。"):format(eff.rad, eff.dam) end,
		type = "魔法",
		subtype = " darkness/ prophecy ",
}
timeEffectCHN:newEffect{
		id = "PROPHECY_OF_TREASON",
		enName = "Prophecy of Treason",
		chName = "背叛预言",
		desc = function(self, eff) return ("目标被诅咒进入背叛状态。每回合由 %d%%几率攻击友方单位，若无临近友方单位则攻击自身。"):format(eff.power) end,
		type = "魔法",
		subtype = " darkness/ prophecy ",
}
timeEffectCHN:newEffect{
		id = "MARK_OF_TREASON",
		enName = "Mark of Treason",
		chName = "背叛印记",
		desc = function(self, eff) return ("当目标受伤时，效果来源将受到 %d%% 伤害。"):format(eff.power) end,
		type = "魔法",
		subtype = " darkness/ prophecy ",
}
timeEffectCHN:newEffect{
		id = "NIHIL",
		enName = "Nihil",
		chName = "虚无",
		desc = function(self, eff) return ("目标被熵覆盖，缩短新有益状态并延长新负面状态 %d%% 持续时间。\n若目标脱离视野 2 回合，则该效果会消失。"):format(eff.power*100) end,
		type = "其它",
		subtype = " temporal/ darkness ",
}
timeEffectCHN:newEffect{
		id = "ATROPHY",
		enName = "Atrophy",
		chName = "衰亡",
		desc = function(self, eff) return ("目标的身体和精神迅速老化、凋零，所有属性降低 %d 。\n若目标脱离视野 2 回合，则该效果会消失。"):format(eff.power*eff.charges) end,
		type = "其它",
		subtype = " temporal ",
}
timeEffectCHN:newEffect{
		id = "TEMPORAL_FEAST",
		enName = "Temporal Feast",
		chName = "盛宴",
		desc = function(self, eff) return ("施法速度增加%d%%."):format(eff.power * 100 * eff.charges) end,
		type = "魔法",
		subtype = " speed/ temporal ",
}
timeEffectCHN:newEffect{
		id = "VOID_RIFT",
		enName = "Void Rift",
		chName = "虚空裂口",
		desc = function(self, eff) return ("目标拥有 %d 个激活的虚空裂口。"):format(eff.charges) end,
		type = "其它",
		subtype = " darkness/ temporal ",
}
timeEffectCHN:newEffect{
		id = "NETHER_BREACH",
		enName = "Nether Breach",
		chName = "深渊裂隙",
		desc = function(self, eff) return ("目标拥有一个深渊裂隙，朝周围敌人发射光束。"):format() end,
		type = "其它",
		subtype = " darkness/ temporal ",
}
timeEffectCHN:newEffect{
		id = "TEMPORAL_VORTEX",
		enName = "Temporal Vortex",
		chName = "时空漩涡",
		desc = function(self, eff) return ("目标拥有一个时空漩涡，减速周围敌人。"):format() end,
		type = "其它",
		subtype = " darkness/ temporal ",
}
timeEffectCHN:newEffect{
		id = "DIMENSIONAL_GATEWAY",
		enName = "Dimensional Gateay",
		chName = "维度之门",
		desc = function(self, eff) return ("目标拥有一个维度之门，可以召唤虚空造物。"):format() end,
		type = "其它",
		subtype = " darkness/ temporal ",
}
timeEffectCHN:newEffect{
		id = "ACCELERATE",
		enName = "Accelerate",
		chName = "窃速神偷",
		desc = function(self, eff) return ("移动速度加快 %d%% 。任何移动外的行动将取消该效果。"):format(eff.power) end,
		type = "魔法",
		subtype = " temporal/ speed ",
}
timeEffectCHN:newEffect{
		id = "SUSPEND_DET",
		enName = "Suspend",
		chName = "窃命凝固",
		desc = function(self, eff) return "目标从常规时间流中移除，无法行动，免疫伤害。每回合有益效果正常衰减。" end,
		type = "其它",
		subtype = " temporal ",
}
timeEffectCHN:newEffect{
		id = "SUSPEND_BEN",
		enName = "Suspend",
		chName = "窃命凝固",
		desc = function(self, eff) return "目标从常规时间流中移除，无法行动，免疫伤害。每回合负面效果和技能冷却正常衰减。" end,
		type = "其它",
		subtype = " temporal ",
}
timeEffectCHN:newEffect{
		id = "JINX",
		enName = "Jinxed",
		chName = "不幸",
		desc = function(self, eff)
		local desc = "目标豁免和闪避降低 %d , 暴击率降低 %d%%。\n若目标脱离视野 2 回合，则该效果会消失。"
		if eff.stacks > 6 and eff.fail then desc = "目标豁免和闪避降低 %d , 暴击率降低 %d%%，使用技能有 %d%% 几率失败。\n若目标脱离视野 2 回合，则该效果会消失。" end
		return desc:format(eff.power * eff.stacks, eff.crit * eff.stacks, (eff.stacks - 7) * eff.fail)
	end,
		type = "其它",
		subtype = " temporal ",
}
timeEffectCHN:newEffect{
		id = "FORTUNE",
		enName = "Fortune",
		chName = "幸运",
		desc = function(self, eff) return ("目标豁免和闪避增加 %d , 暴击率增加 %d%%."):format(eff.power * eff.stacks, eff.crit * eff.stacks) end,
		type = "其它",
		subtype = " temporal ",
}
timeEffectCHN:newEffect{
		id = "UNRAVEL_EXISTENCE",
		enName = "Unravelling",
		chName = "拆解",
		desc = function(self, eff) return ("目标正被从现实中抹去。每次受到魔法效果时，它承受 %0.2f 暗影 %0.2f 时空伤害。当承受 5 次效果后，强大的虚空恐魔将出现。"):format(eff.power, eff.power) end,
		type = "魔法",
		subtype = " temporal/ darkness ",
}
timeEffectCHN:newEffect{
		id = "FATEBREAKER",
		enName = "Fatebreaker",
		chName = "打破命运",
		desc = function(self, eff) return ("目标将自身的命运和另一个人相连，当它死亡时，选择的目标将出现在它当前位置并代替它死亡。 此时，它和目标身上每一层幸运和不幸将转化为 %d 点治疗。"):format(eff.power) end,
		type = "魔法",
		subtype = " temporal/ darkness ",
}
timeEffectCHN:newEffect{
		id = "FATEBREAKER_TEMP",
		enName = "Fatebreaker",
		chName = "打破命运",
		desc = function(self, eff) return ("所有伤害转为时空和暗影类型，转移至 %s。"):format(npcCHN:getName(eff.target.name)) end,
		type = "其它",
		subtype = " temporal/ darkness ",
}
timeEffectCHN:newEffect{
		id = "DECAYING_GROUND",
		enName = "Decaying Ground",
		chName = "腐朽之地",
		desc = function(self, eff) return ("冷却时间增加 %d%%。"):format(eff.power * 100) end,
		type = "魔法",
		subtype = " blight/ corrupted ",
}
timeEffectCHN:newEffect{
		id = "CRIPPLING_DISEASE",
		enName = "Crippling Disease",
		chName = "致残疾病",
		desc = function(self, eff) return ("目标被疾病感染，速度降低 %d%% ，每轮受到 %0.2f 枯萎伤害。"):format(eff.speed*100, eff.dam) end,
		type = "魔法",
		subtype = "slow/ disease/ blight",
}
timeEffectCHN:newEffect{
		id = "DEFILED_BLOOD",
		enName = "Defiled Blood",
		chName = "污血",
		desc = function(self, eff) return ("目标被污血覆盖，造成的伤害的 %d%% 将治疗效果来源。"):format(eff.power) end,
		type = "魔法",
		subtype = "blood/ leech",
}
timeEffectCHN:newEffect{
		id = "TELEPORT_KROSHKKUR",
		enName = "Teleport: Kroshkkur",
		chName = "传送: 克诺什库尔",
		desc = function(self, eff) return "目标在等待传送至克诺什库尔。" end,
		type = "魔法",
		subtype = " teleport ",
}
timeEffectCHN:newEffect{
		id = "CULTS_BOOK_TIMEOUT",
		enName = "Forbidden Tome",
		chName = "禁忌之书",
		desc = function(self, eff) return "缓慢地转移至禁忌之书。" end,
		type = "魔法",
		subtype = "book",
}
timeEffectCHN:newEffect{
		id = "CULTS_BOOK_HOME_TIMEOUT",
		enName = "Forbidden Tome",
		chName = "禁忌之书",
		desc = function(self, eff) return ("进入禁忌之书中：\"家，可怕的家 \" %d 回合。"):format(eff.dur) end,
		type = "其它",
		subtype = "book",
}

timeEffectCHN:newEffect{
	id = "CULTS_BOOK_COOLDOWN",
	enName = "Forbidden Tome Cooldown",
	chName = "禁忌之书冷却",
	desc = function(self, eff) return "无法进入禁忌之书。" end,
	type = "其它",
	subtype = "book",
}
timeEffectCHN:newEffect{
		id = "KROG_WRATH",
		enName = "Wrath of the Wilds",
		chName = "自然之怒",
		desc = function(self, eff) return ("%d%% 几率震慑被击中的敌人。"):format(eff.power) end,
		type = "精神",
		subtype = " frenzy ",
}
timeEffectCHN:newEffect{
		id = "WARBORN",
		enName = "Warborn",
		chName = "为战而生",
		desc = function(self, eff) return ("减少 %d%%受到的伤害。"):format(eff.power) end,
		type = "物理",
		subtype = " protection ",
}
timeEffectCHN:newEffect{
		id = "HYPOSTASIS_AWAKEN",
		enName = "Awoken",
		chName = "觉醒",
		desc = function(self, eff) return ("真正的力量正被揭示！\n\n移除所有负面效果，所有技能冷却时间被重置。\n\n每回合，一个半径 2 码的爆炸将会在周围的空间爆发， 造成 %0.2f 暗影和时空伤害，并摧毁所有可摧毁的墙。"):format(self:getStat("mag") * 5 / 2) end,
		type = "其它",
		subtype = " opness ",
}
timeEffectCHN:newEffect{
		id = "TOTAL_COLLAPSE",
		enName = "Total Collapse",
		chName = "完全崩溃",
		desc = function(self, eff) return ("你的身体无法正常运转，被逐渐损耗。每回合你受到 %0.2f 虚空伤害，任何新的负面效果持续时间延长 %d%%。每回合这些惩罚都会增长，直到效果结束。"):format(eff.dam, eff.debuffdur) end,
		type = "其它",
		subtype = " entropy ",
}
timeEffectCHN:newEffect{
		id = "SAVE_KROSHKKUR",
		enName = "Save Kroshkkur",
		chName = "拯救克诺什库尔",
		desc = function(self, eff) return ("克诺什库尔仍处于 %s 威胁中。"):format(eff.threat) end,
		type = "其它",
		subtype = " threat ",
}
timeEffectCHN:newEffect{
		id = "GASTRIC_WAVE_BUFF",
		enName = "Covered in Gastric Fluids",
		chName = "被胃液覆盖",
		desc = function(self, eff) return ("降低受到的伤害 %d%%。该 b u f f 施加时解除所有负面状态"):format(eff.power) end,
		type = "魔法",
		subtype = " protection ",
}
timeEffectCHN:newEffect{
		id = "GASTRIC_WAVE_DEBUFF",
		enName = "Covered in Gastric Fluids",
		chName = "被胃液覆盖",
		desc = function(self, eff) return ("降低造成的伤害 %d%%。该 d e b u f f 施加时所有负面状态延长 6 回合。"):format(eff.power) end,
		type = "魔法",
		subtype = " debilitate ",
}
timeEffectCHN:newEffect{
		id = "GODFEASTER_EVENT_BLINDED",
		enName = "Blinded",
		chName = "致盲",
		desc = function(self, eff) return "目标被致盲，什么也看不见。" end,
		type = "其它",
		subtype = " blind ",
}
timeEffectCHN:newEffect{
		id = "ILLUSORY_CASTLE_MADNESS",
		enName = "Lost in a weird place",
		chName = "迷失在奇怪的地方",
		desc = function(self, eff) return ("目标开始疯狂 (%d 层), 降低 %d%% 精神伤害抗性 , %d 精神豁免,%d%% 混乱免疫，每回合获得 %0.1f 疯狂值。"):format(eff.stacks, eff.stacks * 6, eff.stacks * 5, eff.stacks * 4, eff.stacks * 0.5) end,
		type = "其它",
		subtype = " insanity/ confusion/ madness ",
}
timeEffectCHN:newEffect{
		id = "GLASS_SPLINTERS",
		enName = "Glass Splinters",
		chName = "玻璃碎片",
		desc = function(self, eff) return ("令人讨厌的玻璃碎片令你流血，每回合造成 %0.2f 奥术伤害。行走时造成 %0.2f 奥术伤害。技能失败率增加 %d%% 。"):format(eff.bleed, eff.move, eff.fail) end,
		type = "魔法",
		subtype = " wound/ cut/ bleed/ fail ",
}
timeEffectCHN:newEffect{
		id = "PERSISTANT_WILL",
		enName = "Persistant Will",
		chName = "坚定意志",
		desc = function(self, eff) return ("相信奥术使用者应该被消灭。"):format() end,
		type = "精神",
		subtype = " will/ domination ",
}
timeEffectCHN:newEffect{
		id = "TWISTED_SPEED",
		enName = "Twisted Evolution: Speed",
		chName = "扭曲进化: 速度",
		desc = function(self, eff) return ("整体速度增加 %d%%."):format(eff.speed*100) end,
		type = "其它",
		subtype = "speed",
}
timeEffectCHN:newEffect{
		id = "TWISTED_FORM",
		enName = "Twisted Evolution: Form",
		chName = "扭曲进化：形态",
		desc = function(self, eff) return ("全属性增加 %d."):format(eff.stat) end,
		type = "其它",
		subtype = "",
}
timeEffectCHN:newEffect{
		id = "TWISTED_POWER",
		enName = "Twisted Evolution: Power",
		chName = "扭曲形态：力量",
		desc = function(self, eff) return ("全伤害增加 %d%%."):format(eff.dam) end,
		type = "其它",
		subtype = "",
}
timeEffectCHN:newEffect{
		id = "SHOES_SLOWLY",
		enName = "Shoes of Moving Slowly",
		chName = "慢速移动之鞋",
		desc = function(self, eff) return ("保持装备，增加 %d 护甲和闪避."):format(eff.stacks * 2) end,
		type = "魔法",
		subtype = " speed ",
}
timeEffectCHN:newEffect{
		id = "ENTROPIC_ROD",
		enName = "Entropic Feedback",
		chName = "熵能反馈",
		desc = function(self, eff) return ("目标受到的 %d%% 治疗将被扭曲为持续 8 回合的熵能冲击。"):format(eff.power) end,
		type = "魔法",
		subtype = "",
}
