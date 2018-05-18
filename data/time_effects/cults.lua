local DamageType = require "engine.DamageType"
--cults
timeEffectCHN:newEffect{
		id = "SMACK_ENTROPIC_WORMHOLE",
		enName = "S.M.A.C.K.",
		chName = "S.M.A.C.K.",
		desc = function(self, eff) return "攻 击 敌 人 ！ 堡 垒 会 保 护 你 。" end,
		type = "其它",
		subtype = " other ",
}
timeEffectCHN:newEffect{
		id = "DREM_FRENZY",
		enName = "Frenzy",
		chName = "狂热",
		desc = function(self, eff) return "第 一 次 使 用 的 职 业 技 能 不 进 入 冷 却 。" end,
		type = "精神",
		subtype = " frenzy ",
}
timeEffectCHN:newEffect{
		id = "SPIKESKIN_BLACK_BLOOD",
		enName = "Black Blood Bleeding",
		chName = "黑血横流",
		desc = function(self, eff) return ("黑 血 横 流 ，每 回 合  造 成 %0.2f 暗 影 伤 害 。"):format(eff.power) end,
		type = "魔法",
		subtype = " bleed ",
}
timeEffectCHN:newEffect{
		id = "SPIKESKIN",
		enName = "Spikeskin",
		chName = "尖刺皮肤",
		desc = function(self, eff) return ("被 黑 血 强 化 ，获 得 %d%% 全 体 抗 性 。"):format(eff.power) end,
		type = "魔法",
		subtype = " blood ",
}
timeEffectCHN:newEffect{
		id = "SLIMY_TENDRIL",
		enName = "Slimy Tendril",
		chName = "黏稠触须",
		desc = function(self, eff) return ("被 触 须 抓 住 ，造 成 的 所 有 伤 害 降 低 %d%% 。"):format(eff.power) end,
		type = "魔法",
		subtype = " slime/ corrupted ",
}
timeEffectCHN:newEffect{
		id = "TENTACLE_CONSTRICT",
		enName = "Tentacle Constriction",
		chName = "触手纠缠",
		desc = function(self, eff) return ("被 %s 的 触 手 纠 缠 ， 每 回 合 造 成 %d%% 触 手 伤 害 并 将 你 拉 近 一 格。"):format(npcCHN:getName(eff.src.name), eff.dam * 100) end,
		type = "其它",
		subtype = " ",
}
timeEffectCHN:newEffect{
		id = "CARRION_FEET",
		enName = "Carrion Feet",
		chName = "蠕动之足",
		desc = function(self, eff) return ("被 恶 心 的 蠕 虫 抓 住 ，造 成 的 伤 害 减 少 %d%%。 "):format(eff.power) end,
		type = "魔法",
		subtype = " slime/ corrupted ",
}
timeEffectCHN:newEffect{
		id = "CULTS_OVERGROWTH",
		enName = "Overgrowth",
		chName = "巨型变异",
		desc = function(self, eff) return ("能 走 过 墙 体 并 且 每 回 合 引 发 地 震 。 增 加 %d%% 伤 害 并 获 得 %d%% 伤 害 抗 性。"):format(eff.dam, eff.resist) end,
		type = "魔法",
		subtype = " growth/ corrupted/ massive ",
}
timeEffectCHN:newEffect{
		id = "DECAYING_GUTS",
		enName = "Decaying Guts",
		chName = "腐化",
		desc = function(self, eff) return ("整 体 速 度 减 少 %d%% 。"):format(eff.power * 100) end,
		type = "魔法",
		subtype = " corruption/ slow ",
}
timeEffectCHN:newEffect{
		id = "WTW_OFS",
		enName = "Worm that Walks out of sight",
		chName = "蠕虫合体在视野外",
		desc = function(self, eff) return "蠕 虫 合 体 在 主 人 的 视 野 外 ； 无 法 直 接 控 制 它 ！" end,
		type = "其它",
		subtype = " miscellaneous ",
}
timeEffectCHN:newEffect{
		id = "WTW_SHARED_INSANITY",
		enName = "Shared Insanity",
		chName = "共享疯狂",
		desc = function(self, eff) return ("和 恐 魔 建 立 链 接， 获 得 %d%% 全 体 伤 害 抗 性。"):format(eff.resist) end,
		type = "其它",
		subtype = " miscellaneous ",
}
timeEffectCHN:newEffect{
		id = "WTW_TERRIBLE_SIGHT",
		enName = "Terrible Sight",
		chName = "恐怖景象",
		desc = function(self, eff) return ("被 两 个 恐 魔 惊 恐， 闪 避 和 法 术 豁 免 降 低 %d 。"):format(eff.save) end,
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
		desc = function(self, eff) return ("%d 脓 包 ， 增 加 %d%% 抗性 。"):format(eff.stacks, eff.stacks * eff.power) end,
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
		desc = function(self, eff) return ("20%% 吸 血 几 率 ，%d%% 强 度。"):format(eff.power) end,
		type = "魔法",
		subtype = " pain/ torture/ tentacles/ leech ",
}
timeEffectCHN:newEffect{
		id = "HORRIFIC_DISPLAY",
		enName = "Horrific Display",
		chName = "恐魔具现化",
		desc = function(self, eff) return ("外 貌 变 化 为 恐 魔 ， 令 其 他 人 和 它 敌 对 。"):format() end,
		type = "魔法",
		subtype = " horror/ morph ",
}
timeEffectCHN:newEffect{
		id = "DISOLVED_FACE",
		enName = "Dissolved Face",
		chName = "溶解之脸",
		desc = function(self, eff) return ("目 标 被 血 肉 覆 盖， 每 回 合 每 种 疾 病 额 外 造 成 %0.2f 暗 影 和 %0.2f 枯 萎 伤 害。"):format(eff.dam, eff.dam * 0.7) end,
		type = "魔法",
		subtype = " darkness/ blight/ gore ",
}
timeEffectCHN:newEffect{
		id = "GLIMPSE_OF_TRUE_HORROR",
		enName = "Glimpse of True Horror",
		chName = "恐怖无边",
		desc = function(self, eff) return ("目 标 被 真 正 的 恐 惧 吓 倒， %d%% 几 率 使 用 技 能 失 败。"):format(eff.fail) end,
		type = "魔法",
		subtype = " darkness/ blight/ horror/ fear ",
}
timeEffectCHN:newEffect{
		id = "GLIMPSE_OF_TRUE_HORROR_SELF",
		enName = "Glimpse of True Horror",
		chName = "恐怖无边",
		desc = function(self, eff) return ("被 敌 人 的 恐 惧 强 化， 获 得 %d%% 黑 暗 和 枯 萎 抗 性 穿 透。"):format(eff.pen) end,
		type = "魔法",
		subtype = " darkness/ blight/ horror ",
}
timeEffectCHN:newEffect{
		id = "WRITHING_HAIRS",
		enName = "Writhing Hairs",
		chName = "苦痛之发",
		desc = function(self, eff) return ("半 石 化 中 ， 移 动 速 度 降 低 %d%%， 35%% 几 率 增 加 %d%% 受 到 的 伤 害。"):format(eff.speed * 100, eff.brittle) end,
		type = "魔法",
		subtype = " stone ",
}
timeEffectCHN:newEffect{
		id = "SPLIT",
		enName = "Split",
		chName = "命运裂解",
		desc = function(self, eff) return ("从 时 间 线 上 消 失 ，减 少 %d%% 受 到 的 伤 害 和 %d%% 造 成 的 伤 害 。"):format(eff.power, eff.dam) end,
		type = "魔法",
		subtype = " temporal/ ",
}
-- mark
timeEffectCHN:newEffect{
		id = "HALO_OF_RUIN",
		enName = "Halo of Ruin",
		chName = "Halo of Ruin",
		desc = function(self, eff) return ("Increases spell critical chance by %d%%. At 5 stacks, next Nether spell is empowered."):format(eff.power * eff.charges) end,
		type = "魔法",
		subtype = " blight ",
}
timeEffectCHN:newEffect{
		id = "VOIDBURN",
		enName = "Voidburn",
		chName = "Voidburn",
		desc = function(self, eff) return ("The target has been seared by the void, taking %0.2f darkness and %0.2f temporal damage each turn."):format(math.floor(eff.power/2), math.floor(eff.power/2)) end,
		type = "魔法",
		subtype = " temporal/ darkness ",
}
timeEffectCHN:newEffect{
		id = "DARK_WHISPERS",
		enName = "Dark Whispers",
		chName = "Dark Whispers",
		desc = function(self, eff) return ("The target is being driven mad by the void, taking %0.2f darkness damage per turn and reducing all powers by %d."):format(eff.dam, eff.power) end,
		type = "魔法",
		subtype = " darkness ",
}
timeEffectCHN:newEffect{
		id = "HIDEOUS_VISIONS",
		enName = "Hideous Visions",
		chName = "Hideous Visions",
		desc = function(self, eff) return ("The target is being distracted by a hallucination, reducing all damage dealt to non-hallucinations targets by %d%%."):format(eff.power) end,
		type = "其它",
		subtype = " darkness ",
}
timeEffectCHN:newEffect{
		id = "CACOPHONY",
		enName = "Cacophony",
		chName = "Cacophony",
		desc = function(self, eff) return ("The target is overwhelmed by voices from the void, giving them a 20%% higher chance to spawn hallucinations from Dark Whispers and causing them to take an additional %d%% temporal damage from Dark Whispers and Hideous Visions."):format(eff.power) end,
		type = "魔法",
		subtype = " temporal ",
}
timeEffectCHN:newEffect{
		id = "ENTROPIC_WASTING",
		enName = "Entropic Wasting",
		chName = "Entropic Wasting",
		desc = function(self, eff) return ("The target is wasting away from entropic forces, taking %d damage per turn."):format(eff.power) end,
		type = "其它",
		subtype = " temporal/ darkness ", no_ct_effect = true,
}
timeEffectCHN:newEffect{
		id = "ENTROPIC_GIFT",
		enName = "Entropic Gift",
		chName = "Entropic Gift",
		desc = function(self, eff) return ("The full force of entropy has been brought to bear on the target, inflicting %0.2f darkness and %0.2f temporal damage each turn."):format(eff.power/2, eff.power/2) end,
		type = "魔法",
		subtype = " temporal/ darkness ",
}
timeEffectCHN:newEffect{
		id = "PROPHECY_OF_MADNESS",
		enName = "Prophecy of Madness",
		chName = "Prophecy of Madness",
		desc = function(self, eff) return ("The target is doomed to madness. All talent cooldowns are increased by %d%%."):format(eff.power*100) end,
		type = "魔法",
		subtype = " darkness/ prophecy ",
}
timeEffectCHN:newEffect{
		id = "PROPHECY_OF_RUIN",
		enName = "Prophecy of Ruin",
		chName = "Prophecy of Ruin",
		desc = function(self, eff) return ("The target is doomed to ruin.  On falling below 75%%, 50%% or 25%% life all enemies in radius %d will take %d darkness damage"):format(eff.rad, eff.dam) end,
		type = "魔法",
		subtype = " darkness/ prophecy ",
}
timeEffectCHN:newEffect{
		id = "PROPHECY_OF_TREASON",
		enName = "Prophecy of Treason",
		chName = "Prophecy of Treason",
		desc = function(self, eff) return ("The target is doomed to treason. Each turn they have a %d%% chance to attack an adjacent creature.  If no creatures are adjacent they will attack themself."):format(eff.power) end,
		type = "魔法",
		subtype = " darkness/ prophecy ",
}
timeEffectCHN:newEffect{
		id = "MARK_OF_TREASON",
		enName = "Mark of Treason",
		chName = "Mark of Treason",
		desc = function(self, eff) return ("When this target is damaged %d%% of the damage will also be done to the source of this effect."):format(eff.power) end,
		type = "魔法",
		subtype = " darkness/ prophecy ",
}
timeEffectCHN:newEffect{
		id = "NIHIL",
		enName = "Nihil",
		chName = "Nihil",
		desc = function(self, eff) return ("The target is engulfed in entropy, reducing the duration of new beneficial effects and increasing the duration of new negative effects by %d%%."):format(eff.power*100) end,
		type = "其它",
		subtype = " temporal/ darkness ",
}
timeEffectCHN:newEffect{
		id = "ATROPHY",
		enName = "Atrophy",
		chName = "Atrophy",
		desc = function(self, eff) return ("The target's mind and body is wasting away, reducing all stats by %d."):format(eff.power*eff.charges) end,
		type = "其它",
		subtype = " temporal ",
}
timeEffectCHN:newEffect{
		id = "TEMPORAL_FEAST",
		enName = "Temporal Feast",
		chName = "Temporal Feast",
		desc = function(self, eff) return ("Increases spellcast speed by %d%%."):format(eff.power * 100 * eff.charges) end,
		type = "魔法",
		subtype = " speed/ temporal ",
}
timeEffectCHN:newEffect{
		id = "VOID_RIFT",
		enName = "Void Rift",
		chName = "Void Rift",
		desc = function(self, eff) return ("The target has %d active void rift(s)."):format(eff.charges) end,
		type = "其它",
		subtype = " darkness/ temporal ",
}
timeEffectCHN:newEffect{
		id = "NETHER_BREACH",
		enName = "Nether Breach",
		chName = "Nether Breach",
		desc = function(self, eff) return ("The target has a nether breach open firing beams at nearby enemies."):format() end,
		type = "其它",
		subtype = " darkness/ temporal ",
}
timeEffectCHN:newEffect{
		id = "TEMPORAL_VORTEX",
		enName = "Temporal Vortex",
		chName = "Temporal Vortex",
		desc = function(self, eff) return ("The target has a temporal vortex open slowing nearby enemies."):format() end,
		type = "其它",
		subtype = " darkness/ temporal ",
}
timeEffectCHN:newEffect{
		id = "DIMENSIONAL_GATEWAY",
		enName = "Dimensional Gateay",
		chName = "Dimensional Gateay",
		desc = function(self, eff) return ("The target has a dimensional gateway open summoning Void Skitterers."):format() end,
		type = "其它",
		subtype = " darkness/ temporal ",
}
timeEffectCHN:newEffect{
		id = "ACCELERATE",
		enName = "Accelerate",
		chName = "Accelerate",
		desc = function(self, eff) return ("Moving at extreme speed (%d%% faster).  Any action other than movement will cancel it."):format(eff.power) end,
		type = "魔法",
		subtype = " temporal/ speed ",
}
timeEffectCHN:newEffect{
		id = "SUSPEND_DET",
		enName = "Suspend",
		chName = "Suspend",
		desc = function(self, eff) return "The target is removed from the normal time stream, unable to act but unable to take any damage. Each turn, beneficial effects decrease in duration." end,
		type = "其它",
		subtype = " temporal ",
}
timeEffectCHN:newEffect{
		id = "SUSPEND_BEN",
		enName = "Suspend",
		chName = "Suspend",
		desc = function(self, eff) return "The target is removed from the normal time stream, unable to act but unable to take any damage. Each turn, negative effects and cooldowns will decrease in duration." end,
		type = "其它",
		subtype = " temporal ",
}
timeEffectCHN:newEffect{
		id = "JINX",
		enName = "Jinxed",
		chName = "Jinxed",
		desc = function(self, eff)
		local desc = "The target has %d reduced saves and defense, and %d%% reduced critical chance."
		if eff.stacks > 6 and eff.fail then desc = "The target has %d reduced saves and defense, %d%% reduced critical chance, and %d%% chance to fail talent use." end
		return desc:format(eff.power * eff.stacks, eff.crit * eff.stacks, (eff.stacks - 7) * eff.fail)
	end,
		type = "其它",
		subtype = " temporal ",
}
timeEffectCHN:newEffect{
		id = "FORTUNE",
		enName = "Fortune",
		chName = "Fortune",
		desc = function(self, eff) return ("The target has %d increased saves and defense, and %d%% increased critical chance."):format(eff.power * eff.stacks, eff.crit * eff.stacks) end,
		type = "其它",
		subtype = " temporal ",
}
timeEffectCHN:newEffect{
		id = "UNRAVEL_EXISTENCE",
		enName = "Unravelling",
		chName = "Unravelling",
		desc = function(self, eff) return ("The target is being erased from reality. Each time a magical effect is applied, they will take %0.2f darkness damage and %0.2f temporal damage. If 5 effects are applied, a powerful void horror will appear."):format(eff.power, eff.power) end,
		type = "魔法",
		subtype = " temporal/ darkness ",
}
timeEffectCHN:newEffect{
		id = "FATEBREAKER",
		enName = "Fatebreaker",
		chName = "Fatebreaker",
		desc = function(self, eff) return ("The target has tied itself to the fate of another. If it dies, it's chosen target will die in it's place and it will be healed by %d for each stack of Fortune and Jinx."):format(eff.power) end,
		type = "魔法",
		subtype = " temporal/ darkness ",
}
timeEffectCHN:newEffect{
		id = "FATEBREAKER_TEMP",
		enName = "Fatebreaker",
		chName = "Fatebreaker",
		desc = function(self, eff) return ("Redirecting all damage as temporal and darkness to %s."):format(eff.target.name) end,
		type = "其它",
		subtype = " temporal/ darkness ",
}
timeEffectCHN:newEffect{
		id = "DECAYING_GROUND",
		enName = "Decaying Ground",
		chName = "Decaying Ground",
		desc = function(self, eff) return ("All cooldowns increased by %d%%."):format(eff.power * 100) end,
		type = "魔法",
		subtype = " blight/ corrupted ",
}
timeEffectCHN:newEffect{
		id = "CRIPPLING_DISEASE",
		enName = "Crippling Disease",
		chName = "Crippling Disease",
		desc = function(self, eff) return ("The target is infected by a disease, reducing its speed by %d%% and doing %0.2f blight damage per turn."):format(eff.speed*100, eff.dam) end,
		type = "魔法",
		subtype = "slow/ disease/ blight",
}
timeEffectCHN:newEffect{
		id = "DEFILED_BLOOD",
		enName = "Defiled Blood",
		chName = "Defiled Blood",
		desc = function(self, eff) return ("Covered in defiled blood, healing the source for %d%% of all damage done."):format(eff.power) end,
		type = "魔法",
		subtype = "blood/ leech",
}
timeEffectCHN:newEffect{
		id = "TELEPORT_KROSHKKUR",
		enName = "Teleport: Kroshkkur",
		chName = "Teleport: Kroshkkur",
		desc = function(self, eff) return "The target is waiting to be recalled back to Kroshkkur." end,
		type = "魔法",
		subtype = " teleport ",
}
timeEffectCHN:newEffect{
		id = "CULTS_BOOK_TIMEOUT",
		enName = "Forbidden Tome",
		chName = "Forbidden Tome",
		desc = function(self, eff) return "Slowly transfered to a Forbidden Tome." end,
		type = "魔法",
		subtype = "book",
}
timeEffectCHN:newEffect{
		id = "CULTS_BOOK_HOME_TIMEOUT",
		enName = "Forbidden Tome",
		chName = "Forbidden Tome",
		desc = function(self, eff) return ("Inside Forbidden Tome: \"Home, Horrific Home\" for %d turns."):format(eff.dur) end,
		type = "其它",
		subtype = "book",
}
timeEffectCHN:newEffect{
		id = "KROG_WRATH",
		enName = "Wrath of the Wilds",
		chName = "Wrath of the Wilds",
		desc = function(self, eff) return ("%d%% chance to stun any foes hit."):format(eff.power) end,
		type = "精神",
		subtype = " frenzy ",
}
timeEffectCHN:newEffect{
		id = "WARBORN",
		enName = "Warborn",
		chName = "Warborn",
		desc = function(self, eff) return ("Reduces all damage taken by %d%%."):format(eff.power) end,
		type = "物理",
		subtype = " protection ",
}
timeEffectCHN:newEffect{
		id = "HYPOSTASIS_AWAKEN",
		enName = "Awoken",
		chName = "Awoken",
		desc = function(self, eff) return ("True power is revealed!") end,
		type = "其它",
		subtype = " opness ",
}
timeEffectCHN:newEffect{
		id = "TOTAL_COLLAPSE",
		enName = "Total Collapse",
		chName = "Total Collapse",
		desc = function(self, eff) return ("Your body can not function properly here, it is slowly wasting away. Each turn you take %0.2f void damage and any new debuff on you lasts %d%% longer. Each turn those penalties increase until the effect is removed."):format(eff.dam, eff.debuffdur) end,
		type = "其它",
		subtype = " entropy ",
}
timeEffectCHN:newEffect{
		id = "SAVE_KROSHKKUR",
		enName = "Save Kroshkkur",
		chName = "Save Kroshkkur",
		desc = function(self, eff) return ("Kroshkkur is still under threat from %s."):format(eff.threat) end,
		type = "其它",
		subtype = " threat ",
}
timeEffectCHN:newEffect{
		id = "GASTRIC_WAVE_BUFF",
		enName = "Covered in Gastric Fluids",
		chName = "Covered in Gastric Fluids",
		desc = function(self, eff) return ("Reduces all damage taken by %d%% and remove all detrimental effects on application."):format(eff.power) end,
		type = "魔法",
		subtype = " protection ",
}
timeEffectCHN:newEffect{
		id = "GASTRIC_WAVE_DEBUFF",
		enName = "Covered in Gastric Fluids",
		chName = "Covered in Gastric Fluids",
		desc = function(self, eff) return ("Reduces all damage done by %d%% and increase all detrimental effects durations by 6 turns on application."):format(eff.power) end,
		type = "魔法",
		subtype = " debilitate ",
}
timeEffectCHN:newEffect{
		id = "GODFEASTER_EVENT_BLINDED",
		enName = "Blinded",
		chName = "Blinded",
		desc = function(self, eff) return "The target is blinded, unable to see anything." end,
		type = "其它",
		subtype = " blind ",
}
timeEffectCHN:newEffect{
		id = "ILLUSORY_CASTLE_MADNESS",
		enName = "Lost in a weird place",
		chName = "Lost in a weird place",
		desc = function(self, eff) return ("The target is starting to get mad (%d stacks), reducing mind damage resistance by %d%%, mental save by %d, confusion resistance by %d%%, generating %0.1f insanity per turn."):format(eff.stacks, eff.stacks * 6, eff.stacks * 5, eff.stacks * 4, eff.stacks * 0.5) end,
		type = "其它",
		subtype = " insanity/ confusion/ madness ",
}
timeEffectCHN:newEffect{
		id = "GLASS_SPLINTERS",
		enName = "Glass Splinters",
		chName = "Glass Splinters",
		desc = function(self, eff) return ("Nasty glass splinters that make you bleed, doing %0.2f arcane damage per turn. Deals %0.2f arcane damage on move. Talents have %d%% chances to fail."):format(eff.bleed, eff.move, eff.fail) end,
		type = "魔法",
		subtype = " wound/ cut/ bleed/ fail ",
}
timeEffectCHN:newEffect{
		id = "PERSISTANT_WILL",
		enName = "Persistant Will",
		chName = "Persistant Will",
		desc = function(self, eff) return ("Convinced that arcane users are filth to be destroyed."):format() end,
		type = "精神",
		subtype = " will/ domination ",
}
timeEffectCHN:newEffect{
		id = "TWISTED_SPEED",
		enName = "Twisted Evolution: Speed",
		chName = "Twisted Evolution: Speed",
		desc = function(self, eff) return ("The target is evolved increasing its global speed by %d%%."):format(eff.speed*100) end,
		type = "其它",
		subtype = "speed",
}
timeEffectCHN:newEffect{
		id = "TWISTED_FORM",
		enName = "Twisted Evolution: Form",
		chName = "Twisted Evolution: Form",
		desc = function(self, eff) return ("The target is evolved increasing all its stats by %d."):format(eff.stat) end,
		type = "其它",
		subtype = "",
}
timeEffectCHN:newEffect{
		id = "TWISTED_POWER",
		enName = "Twisted Evolution: Power",
		chName = "Twisted Evolution: Power",
		desc = function(self, eff) return ("The target is evolved increasing its damage by %d%%."):format(eff.dam) end,
		type = "其它",
		subtype = "",
}
timeEffectCHN:newEffect{
		id = "SHOES_SLOWLY",
		enName = "Shoes of Moving Slowly",
		chName = "Shoes of Moving Slowly",
		desc = function(self, eff) return ("Stay put, increasing your armour and defense by %d."):format(eff.stacks * 2) end,
		type = "魔法",
		subtype = " speed ",
}
timeEffectCHN:newEffect{
		id = "ENTROPIC_ROD",
		enName = "Entropic Feedback",
		chName = "Entropic Feedback",
		desc = function(self, eff) return ("The target healing is distorted by entropy for %d%% of the healing done over 8 turns."):format(eff.power) end,
		type = "魔法",
		subtype = "",
}
