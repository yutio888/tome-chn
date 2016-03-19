registerBirthDescriptorTranslation{
	type = "race",
	name = "Giant",
	display_name = "巨人",
	locked = function() return profile.mod.allow_build.race_giant end,
	locked_desc = "庞然的巨物傲视着渺小的生灵。然而须知，高处不胜寒，站得越高，跌得越深……",
	desc = {
		[[#{italic}#"巨 人"#{normal}# 是 对 那 些 身 高 超 过 八 英 尺 的 人 型 生 物 的 统 称 。他 们 的 起 源 、 文 化 和 关 系 与 其 他 种 族 迥 异 。他 们 被 其 他 矮 小 的 种 族 视 为 威 胁 而 躲 避， 作 为 避 难 的 流 浪 者 而 生 存 。]],
	},
}

registerBirthDescriptorTranslation{
	type = "subrace",
	name = "Ogre",
	display_name = " 食 人 魔 ",
	locked_desc = [[Forged in the hatred of ages long passed,
made for a war that they've come to outlast.
Their forgotten birthplace lies deep underground,
its tunnels ruined so it wouldn't be found.
Past burglars have failed, but their data's immortal;
to start, look where halflings once tinkered with portals...]],
	desc = {
		"食 人 魔 是 变 种 人 类 ， 在 厄 流 纪 被 孔 克 雷 夫 作 为 工 人 和 战 士 而 制 造。",
		"符 文 给 他 们 超 过 自 然 界 限 的 强 大 力 量 ， 但 他 们 对 符 文 魔 法 的 依 赖 使 之 成 为 猎 魔 行 动 绝 佳 的 目 标 ， 而 不 得 不 依 附 于 永 恒 精 灵。",
		"他 们 简 单 的 喜 好 与 直 接 的 方 式 令 他 们 获 得 了 哑 巴 和 野 兽 的 蔑 称，尽 管 他 们 在 法 术 和 符 文 上 有 惊 人 的 亲 和 力。",
		"他 们 拥 有 #GOLD#怒火中烧 #WHITE# 技 能， 能 提 供 暴 击 几 率 和 伤 害 ， 并 提 供 震 慑 定 身 免 疫 。",
		"#GOLD#属性修正:",
		"#LIGHT_BLUE# * +3 力 量, -1 敏 捷, +0 体 质",
		"#LIGHT_BLUE# * +2 魔 法, -2 意 志, +2 灵 巧",
		"#GOLD#生命加值:#LIGHT_BLUE# 13",
		"#GOLD#经验惩罚:#LIGHT_BLUE# 30%",
	},
}
