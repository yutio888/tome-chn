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
		chName = "毁灭光环",
		desc = function(self, eff) return ("增 加 法 术 暴 击 率 %d%% ， 在 5 层 时 ，下 一 个 虚 境 法 术 获 得 加 成 。"):format(eff.power * eff.charges) end,
		type = "魔法",
		subtype = " blight ",
}
timeEffectCHN:newEffect{
		id = "VOIDBURN",
		enName = "Voidburn",
		chName = "虚空灼烧",
		desc = function(self, eff) return ("目 标 被 虚 空 折 磨 ， 每 回 合 造 成 %0.2f 暗 影 和 %0.2f 时 空 伤 害 。 "):format(math.floor(eff.power/2), math.floor(eff.power/2)) end,
		type = "魔法",
		subtype = " temporal/ darkness ",
}
timeEffectCHN:newEffect{
		id = "DARK_WHISPERS",
		enName = "Dark Whispers",
		chName = "黑暗低语",
		desc = function(self, eff) return ("目 标 被 虚 空 压 迫 至 疯 狂 ，每 回 合 受 到 %0.2f 点 暗 影 伤 害 并 且 降 低 %d 点 全 部 强 度。"):format(eff.dam, eff.power) end,
		type = "魔法",
		subtype = " darkness ",
}
timeEffectCHN:newEffect{
		id = "HIDEOUS_VISIONS",
		enName = "Hideous Visions",
		chName = "惊骇幻象",
		desc = function(self, eff) return ("目 标 被 幻 觉 所 困 , 降 低 其 对 非 幻 觉 单 位 造 成 的 伤 害  %d%% 。"):format(eff.power) end,
		type = "其它",
		subtype = " darkness ",
}
timeEffectCHN:newEffect{
		id = "CACOPHONY",
		enName = "Cacophony",
		chName = "心灵尖啸",
		desc = function(self, eff) return ("目 标 被 虚 空 之 声 淹 没 , 让 他 们 从 黑 暗 低 语 中 产 生 幻 觉 的 几 率 增 加 20%% ，并 使 他 们 从 黑 暗 低 语 和 丑 恶 幻 视 中 受 到 额 外 %d%% 点 时 空 伤 害 。"):format(eff.power) end,
		type = "魔法",
		subtype = " temporal ",
}
timeEffectCHN:newEffect{
		id = "ENTROPIC_WASTING",
		enName = "Entropic Wasting",
		chName = "熵能冲击",
		desc = function(self, eff) return ("目 标 被 熵 能 冲 击 中， 每 回 合 受 到 %d 伤 害。"):format(eff.power) end,
		type = "其它",
		subtype = " temporal/ darkness ", no_ct_effect = true,
}
timeEffectCHN:newEffect{
		id = "ENTROPIC_GIFT",
		enName = "Entropic Gift",
		chName = "熵能掌控",
		desc = function(self, eff) return ("熵 能 冲 击 被 施 加 给 目 标 ， 每 回 合 造 成 %0.2f 暗 影 和 %0.2f 时 空 伤 害。"):format(eff.power/2, eff.power/2) end,
		type = "魔法",
		subtype = " temporal/ darkness ",
}
timeEffectCHN:newEffect{
		id = "PROPHECY_OF_MADNESS",
		enName = "Prophecy of Madness",
		chName = "疯狂预言",
		desc = function(self, eff) return ("目 标 被 诅 咒 进入 疯 狂 状 态 。 技 能 冷 却 时 间 增 加 %d%%。"):format(eff.power*100) end,
		type = "魔法",
		subtype = " darkness/ prophecy ",
}
timeEffectCHN:newEffect{
		id = "PROPHECY_OF_RUIN",
		enName = "Prophecy of Ruin",
		chName = "毁灭预言",
		desc = function(self, eff) return ("目 标 被 诅 咒 进 入 毁 灭 状 态 。 当 生 命 值 下 降 至 75%%, 50%% 或 25%% life 时， %d 格 内 敌 人 将 受 到 %d 暗 影 伤 害。"):format(eff.rad, eff.dam) end,
		type = "魔法",
		subtype = " darkness/ prophecy ",
}
timeEffectCHN:newEffect{
		id = "PROPHECY_OF_TREASON",
		enName = "Prophecy of Treason",
		chName = "背叛预言",
		desc = function(self, eff) return ("目 标 被 诅 咒 进 入 背 叛 状 态。 每 回 合 由 %d%%几 率 攻 击 友 方 单 位 ， 若 无 临 近 友 方 单 位 则 攻 击 自 身。"):format(eff.power) end,
		type = "魔法",
		subtype = " darkness/ prophecy ",
}
timeEffectCHN:newEffect{
		id = "MARK_OF_TREASON",
		enName = "Mark of Treason",
		chName = "背叛印记",
		desc = function(self, eff) return ("当 目 标 受 伤 时 ， 效 果 来 源 将 受 到 %d%% 伤 害。"):format(eff.power) end,
		type = "魔法",
		subtype = " darkness/ prophecy ",
}
timeEffectCHN:newEffect{
		id = "NIHIL",
		enName = "Nihil",
		chName = "虚无",
		desc = function(self, eff) return ("目 标 被 熵 覆 盖 ， 缩 短 新 有 益 状 态 并 延 长 新 负 面 状 态 %d%% 持 续 时 间 。"):format(eff.power*100) end,
		type = "其它",
		subtype = " temporal/ darkness ",
}
timeEffectCHN:newEffect{
		id = "ATROPHY",
		enName = "Atrophy",
		chName = "衰亡",
		desc = function(self, eff) return ("目 标 的 身 体 和 精 神 迅 速 老 化、凋 零 ，所 有 属 性 降 低 %d 。"):format(eff.power*eff.charges) end,
		type = "其它",
		subtype = " temporal ",
}
timeEffectCHN:newEffect{
		id = "TEMPORAL_FEAST",
		enName = "Temporal Feast",
		chName = "盛宴",
		desc = function(self, eff) return ("施 法 速 度 增 加%d%%."):format(eff.power * 100 * eff.charges) end,
		type = "魔法",
		subtype = " speed/ temporal ",
}
timeEffectCHN:newEffect{
		id = "VOID_RIFT",
		enName = "Void Rift",
		chName = "虚空裂口",
		desc = function(self, eff) return ("目 标 拥 有 %d 个 激 活 的 虚 空 裂 口。"):format(eff.charges) end,
		type = "其它",
		subtype = " darkness/ temporal ",
}
timeEffectCHN:newEffect{
		id = "NETHER_BREACH",
		enName = "Nether Breach",
		chName = "深渊裂隙",
		desc = function(self, eff) return ("目 标 拥 有 一 个 深 渊 裂 隙， 朝 周 围 敌 人 发 射 光 束。"):format() end,
		type = "其它",
		subtype = " darkness/ temporal ",
}
timeEffectCHN:newEffect{
		id = "TEMPORAL_VORTEX",
		enName = "Temporal Vortex",
		chName = "时空漩涡",
		desc = function(self, eff) return ("目 标 拥 有 一 个 时 空 漩 涡  ，减 速 周 围 敌人 。"):format() end,
		type = "其它",
		subtype = " darkness/ temporal ",
}
timeEffectCHN:newEffect{
		id = "DIMENSIONAL_GATEWAY",
		enName = "Dimensional Gateay",
		chName = "维度之门",
		desc = function(self, eff) return ("目 标 拥 有 一 个 维 度 之 门 ， 可 以 召 唤 虚 空 造 物。"):format() end,
		type = "其它",
		subtype = " darkness/ temporal ",
}
timeEffectCHN:newEffect{
		id = "ACCELERATE",
		enName = "Accelerate",
		chName = "窃速神偷",
		desc = function(self, eff) return ("移 动 速 度 加 快 %d%% 。任 何 移 动 外 的 行 动 将 取 消 该 效 果。"):format(eff.power) end,
		type = "魔法",
		subtype = " temporal/ speed ",
}
timeEffectCHN:newEffect{
		id = "SUSPEND_DET",
		enName = "Suspend",
		chName = "窃命凝固",
		desc = function(self, eff) return "目 标 从 常 规 时 间 流 中 移 除 ， 无 法 行 动 ， 免 疫 伤害 。 每 回 合 有 益 效 果 正 常 衰 减。" end,
		type = "其它",
		subtype = " temporal ",
}
timeEffectCHN:newEffect{
		id = "SUSPEND_BEN",
		enName = "Suspend",
		chName = "窃命凝固",
		desc = function(self, eff) return "目 标 从 常 规 时 间 流 中 移 除 ， 无 法 行 动 ， 免 疫 伤害 。 每 回 合 负 面 效 果 和 技 能 冷 却 正 常 衰 减 。" end,
		type = "其它",
		subtype = " temporal ",
}
timeEffectCHN:newEffect{
		id = "JINX",
		enName = "Jinxed",
		chName = "不幸",
		desc = function(self, eff)
		local desc = "目 标 豁 免 和 闪 避 降 低 %d , 暴 击 率 降 低 %d%%。"
		if eff.stacks > 6 and eff.fail then desc = "目 标 豁 免 和 闪 避 降 低 %d , 暴 击 率 降 低 %d%%，使 用 技 能 有 %d%% 几 率 失 败 。" end
		return desc:format(eff.power * eff.stacks, eff.crit * eff.stacks, (eff.stacks - 7) * eff.fail)
	end,
		type = "其它",
		subtype = " temporal ",
}
timeEffectCHN:newEffect{
		id = "FORTUNE",
		enName = "Fortune",
		chName = "幸运",
		desc = function(self, eff) return ("目 标 豁 免 和 闪 避 增 加 %d , 暴 击 率 增 加 %d%%."):format(eff.power * eff.stacks, eff.crit * eff.stacks) end,
		type = "其它",
		subtype = " temporal ",
}
timeEffectCHN:newEffect{
		id = "UNRAVEL_EXISTENCE",
		enName = "Unravelling",
		chName = "拆解",
		desc = function(self, eff) return ("目 标 正 被 从 现 实 中 抹 去。 每 次 受 到 魔 法 效 果 时， 它 承 受 %0.2f 暗 影 %0.2f 时 空 伤 害。当 承 受 5 次 效 果 后 ， 强 大 的 虚 空 恐 魔 将 出  现。"):format(eff.power, eff.power) end,
		type = "魔法",
		subtype = " temporal/ darkness ",
}
timeEffectCHN:newEffect{
		id = "FATEBREAKER",
		enName = "Fatebreaker",
		chName = "打破命运",
		desc = function(self, eff) return ("目 标 将 自 身 的 命 运 和 另 一 个 人 相 连 ， 当 它 死 亡 时 ， 选 择 的 目 标 将 出 现 在 它 当 前 位 置 并 代 替 它 死 亡 。   此 时 ， 它 和 目 标 身 上 每 一 层 幸 运 和 不 幸 将 转 化 为 %d 点 治 疗 。"):format(eff.power) end,
		type = "魔法",
		subtype = " temporal/ darkness ",
}
timeEffectCHN:newEffect{
		id = "FATEBREAKER_TEMP",
		enName = "Fatebreaker",
		chName = "打破命运",
		desc = function(self, eff) return ("所 有 伤 害 转 为 时 空 和 暗 影 类 型， 转 移 至 %s。"):format(npcCHN:getName(eff.target.name)) end,
		type = "其它",
		subtype = " temporal/ darkness ",
}
timeEffectCHN:newEffect{
		id = "DECAYING_GROUND",
		enName = "Decaying Ground",
		chName = "腐朽之地",
		desc = function(self, eff) return ("冷 却 时 间 增 加 %d%%。"):format(eff.power * 100) end,
		type = "魔法",
		subtype = " blight/ corrupted ",
}
timeEffectCHN:newEffect{
		id = "CRIPPLING_DISEASE",
		enName = "Crippling Disease",
		chName = "致残疾病",
		desc = function(self, eff) return ("目 标 被 疾 病 感 染 ， 速 度 降 低 %d%% ， 每 轮 受 到 %0.2f 枯 萎 伤 害 。"):format(eff.speed*100, eff.dam) end,
		type = "魔法",
		subtype = "slow/ disease/ blight",
}
timeEffectCHN:newEffect{
		id = "DEFILED_BLOOD",
		enName = "Defiled Blood",
		chName = "污血",
		desc = function(self, eff) return ("目 标 被 污 血 覆 盖， 造 成 的 伤 害 的 %d%% 将 治 疗 效 果 来 源。"):format(eff.power) end,
		type = "魔法",
		subtype = "blood/ leech",
}
timeEffectCHN:newEffect{
		id = "TELEPORT_KROSHKKUR",
		enName = "Teleport: Kroshkkur",
		chName = "传送: 克诺什库尔",
		desc = function(self, eff) return "目 标 在 等 待 传 送 至 克诺什库尔 。" end,
		type = "魔法",
		subtype = " teleport ",
}
timeEffectCHN:newEffect{
		id = "CULTS_BOOK_TIMEOUT",
		enName = "Forbidden Tome",
		chName = "禁忌之书",
		desc = function(self, eff) return "缓 慢 地 转 移 至 禁 忌 之 书。" end,
		type = "魔法",
		subtype = "book",
}
timeEffectCHN:newEffect{
		id = "CULTS_BOOK_HOME_TIMEOUT",
		enName = "Forbidden Tome",
		chName = "禁忌之书",
		desc = function(self, eff) return ("进 入 禁 忌 之 书 中：\"家 ，可 怕 的 家 \" %d 回 合。"):format(eff.dur) end,
		type = "其它",
		subtype = "book",
}
timeEffectCHN:newEffect{
		id = "KROG_WRATH",
		enName = "Wrath of the Wilds",
		chName = "自然之怒",
		desc = function(self, eff) return ("%d%% 几 率 震 慑 被 击 中 的 敌 人。"):format(eff.power) end,
		type = "精神",
		subtype = " frenzy ",
}
timeEffectCHN:newEffect{
		id = "WARBORN",
		enName = "Warborn",
		chName = "为战而生",
		desc = function(self, eff) return ("减 少 %d%%受 到 的 伤 害。"):format(eff.power) end,
		type = "物理",
		subtype = " protection ",
}
timeEffectCHN:newEffect{
		id = "HYPOSTASIS_AWAKEN",
		enName = "Awoken",
		chName = "觉醒",
		desc = function(self, eff) return ("真 正 的 力 量 正 被 揭 示 ！") end,
		type = "其它",
		subtype = " opness ",
}
timeEffectCHN:newEffect{
		id = "TOTAL_COLLAPSE",
		enName = "Total Collapse",
		chName = "完全崩溃",
		desc = function(self, eff) return ("你 的 身 体 无 法 正 常 运 转 ， 被 逐 渐 损 耗 。 每 回 合 你 受 到 %0.2f 虚 空 伤 害 ， 任 何 新 的 负 面 效 果 持 续 时 间 延 长 %d%%  。   每 回 合 这 些 惩 罚 都会 增 长 ， 直 到 效 果 结 束 。"):format(eff.dam, eff.debuffdur) end,
		type = "其它",
		subtype = " entropy ",
}
timeEffectCHN:newEffect{
		id = "SAVE_KROSHKKUR",
		enName = "Save Kroshkkur",
		chName = "拯救克诺什库尔",
		desc = function(self, eff) return ("克诺什库尔 仍 处于 %s 威胁 中。"):format(eff.threat) end,
		type = "其它",
		subtype = " threat ",
}
timeEffectCHN:newEffect{
		id = "GASTRIC_WAVE_BUFF",
		enName = "Covered in Gastric Fluids",
		chName = "被胃液覆盖",
		desc = function(self, eff) return ("降 低 受 到 的 伤 害 %d%%。 该 b u f f 施 加 时 解 除 所 有 负 面 状 态"):format(eff.power) end,
		type = "魔法",
		subtype = " protection ",
}
timeEffectCHN:newEffect{
		id = "GASTRIC_WAVE_DEBUFF",
		enName = "Covered in Gastric Fluids",
		chName = "被胃液覆盖",
		desc = function(self, eff) return ("降 低 造 成 的 伤 害 %d%%。 该 d e b u f f 施 加 时 所 有 负 面 状 态 延 长 6 回 合。"):format(eff.power) end,
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
		desc = function(self, eff) return ("目 标 开 始 疯 狂 (%d 层), 降 低 %d%% 精 神 伤 害 抗 性 , %d 精 神 豁 免,%d%% 混 乱 免 疫， 每 回 合 获 得 %0.1f 疯 狂 值 。"):format(eff.stacks, eff.stacks * 6, eff.stacks * 5, eff.stacks * 4, eff.stacks * 0.5) end,
		type = "其它",
		subtype = " insanity/ confusion/ madness ",
}
timeEffectCHN:newEffect{
		id = "GLASS_SPLINTERS",
		enName = "Glass Splinters",
		chName = "玻璃碎片",
		desc = function(self, eff) return ("令 人 讨 厌 的 玻 璃 碎 片 令 你 流 血，每 回 合 造 成 %0.2f 奥 术 伤害 。 行 走 时 造 成 %0.2f 奥 术 伤害。 技 能 失 败 率 增 加 %d%% 。"):format(eff.bleed, eff.move, eff.fail) end,
		type = "魔法",
		subtype = " wound/ cut/ bleed/ fail ",
}
timeEffectCHN:newEffect{
		id = "PERSISTANT_WILL",
		enName = "Persistant Will",
		chName = "坚定意志",
		desc = function(self, eff) return ("相 信 奥 术 使 用 者 应 该 被 消 灭。"):format() end,
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
		desc = function(self, eff) return ("保持装备， 增加 %d 护甲和闪避."):format(eff.stacks * 2) end,
		type = "魔法",
		subtype = " speed ",
}
timeEffectCHN:newEffect{
		id = "ENTROPIC_ROD",
		enName = "Entropic Feedback",
		chName = "熵能反馈",
		desc = function(self, eff) return ("目 标 受 到 的 %d%% 治 疗 将 被 扭 曲 为 持 续 8 回 合 的 熵 能 冲 击 。"):format(eff.power) end,
		type = "魔法",
		subtype = "",
}
