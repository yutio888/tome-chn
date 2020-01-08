registerBirthDescriptorTranslation{
	type = "race",
	name = "Giant",
	display_name = "巨人",
	locked = function() return profile.mod.allow_build.race_giant end,
	locked_desc = "庞然的巨物傲视着渺小的生灵。然而须知，高处不胜寒，站得越高，跌得越深……",
	desc = {
		[[#{italic}#"巨人"#{normal}# 是对那些身高超过八英尺的人型生物的统称。他们的起源、文化和关系与其他种族迥异。他们被其他矮小的种族视为威胁而躲避，作为避难的流浪者而生存。]],
	},
}

registerBirthDescriptorTranslation{
	type = "subrace",
	name = "Ogre",
	display_name = " 食人魔 ",
	locked_desc = [[他们铸造于数千年的仇恨之中，
为一场现在已经结束的战争而造。
他们被遗忘的诞生地深埋于地下，
那些隧道已经腐朽，无处寻觅。
过去的窃贼失败了，但他们的数据将永远保存；
要想找到他们，请寻找那些摆弄传送门的半身人……]],
	desc = {
		"食人魔是变种人类，在厄流纪被孔克雷夫作为工人和战士而制造。",
		"符文给他们超过自然界限的强大力量，但他们对符文魔法的依赖使之成为猎魔行动绝佳的目标，而不得不依附于永恒精灵。",
		"他们简单的喜好与直接的方式令他们获得了哑巴和野兽的蔑称，尽管他们在法术和符文上有惊人的亲和力。",
		"他们拥有 #GOLD#怒火中烧 #WHITE# 技能，能提供暴击几率和伤害，并提供震慑定身免疫。",
		"#GOLD#属性修正:",
		"#LIGHT_BLUE# * +3 力量, -1 敏捷, +0 体质",
		"#LIGHT_BLUE# * +2 魔法, -2 意志, +2 灵巧",
		"#GOLD#生命加值:#LIGHT_BLUE# 13",
		"#GOLD#经验惩罚:#LIGHT_BLUE# 15%",
	},
}
