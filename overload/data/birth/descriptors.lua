-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2017 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

setAuto("subclass", false)
setAuto("subrace", false)

setStepNames{
	world = "Campaign",
	race = "Race Category",
	subrace = "Race",
	class = "Class Category",
	subclass = "Class",
}

newBirthDescriptor{
	type = "base",
	name = "base",
	desc = {
	},
	descriptor_choices =
	{
		difficulty =
		{
			Tutorial = "disallow",
		},
		world =
		{
			["Maj'Eyal"] = "allow",
			Infinite = "allow",
			Arena = "allow",
		},
		class =
		{
			-- Specific to some races
			None = "disallow",
		},
	},
	talents = {},
	experience = 1.0,
	body = { INVEN = 1000, QS_MAINHAND = 1, QS_OFFHAND = 1, MAINHAND = 1, OFFHAND = 1, FINGER = 2, NECK = 1, LITE = 1, BODY = 1, HEAD = 1, CLOAK = 1, HANDS = 1, BELT = 1, FEET = 1, TOOL = 1, QUIVER = 1, QS_QUIVER = 1 },

	copy = {
		-- Some basic stuff
		move_others = true,
		no_auto_resists = true, no_auto_saves = true,
		no_auto_high_stats = true,
		resists_cap = {all=70},
		keep_inven_on_death = true,
		can_change_level = true,
		can_change_zone = true,
		save_hotkeys = true,

		-- Mages are unheard of at first, nobody but them regenerates mana
		mana_rating = 6,
		mana_regen = 0,

		max_level = 50,
		money = 15,
		resolvers.equip{ id=true,
			{type="lite", subtype="lite", name="brass lantern", ignore_material_restriction=true, ego_chance=-1000},
		},
		make_tile = function(e)
			if not e.image then e.image = "player/"..e.descriptor.subrace:lower():gsub("[^a-z0-9_]", "_").."_"..e.descriptor.sex:lower():gsub("[^a-z0-9_]", "_")..".png" end
		end,
	},
	game_state = {
		force_town_respec = 1,
	}
}


--------------- Difficulties
newBirthDescriptor{
	type = "difficulty",
	name = "Tutorial",
	never_show = true,
	desc =
	{
		"#GOLD##{bold}# 教 程 模 式 ",
		"#WHITE# 以 一 个 简 化 的 人 物 开 始 游 戏 并 通 过 一 个 简 单 的 任 务 来 探 索 这 个 游 戏。 #{normal}#",
		" 角 色 所 受 伤 害 减 少 20%。 ",
		" 角 色 治 疗 效 果 增 加 10%。 ",
		" 无 需 达 成 任 何 成 就 即 可 进 入。 ",
	},
	descriptor_choices =
	{
		race =
		{
			__ALL__ = "forbid",
			["Tutorial Human"] = "allow",
		},
		subrace =
		{
			__ALL__ = "forbid",
			["Tutorial Human"] = "allow",
		},
		class =
		{
			__ALL__ = "forbid",
			["Tutorial Adventurer"] = "allow",
		},
		subclass =
		{
			__ALL__ = "forbid",
			["Tutorial Adventurer"] = "allow",
		},
	},
	copy = {
		auto_id = 2,
		no_birth_levelup = true,
		infinite_lifes = 1,
		__game_difficulty = 1,
		__allow_rod_recall = false,
		__allow_transmo_chest = false,
		instakill_immune = 1,
	},
	game_state = {
		grab_online_event_forbid = true,
		always_learn_birth_talents = true,
		force_town_respec = false,
	},
}
newBirthDescriptor{
	type = "difficulty",
	name = "Easy",
	display_name = "简单",
	selection_default = config.settings.tome.default_birth and config.settings.tome.default_birth.difficulty == "Easy",
	desc =
	{
		"#GOLD##{bold}#简单模式#WHITE##{normal}#",
		" 提 供 一 个 较 简 单 的 游 戏 体 验。 ",
		" 其 他 难 度 游 戏 困 难 时 请 选 择 此 模 式。 ",
		" 角 色 所 受 所 有 伤 害 减 少 30%。 ",
		" 角 色 所 受 所 有 治 疗 增 加 30%。 ",
		" 所 有 负 面 状 态 持 续 时 间 减 少 50%。 ",
		" 不 能 完 成 游 戏 成 就。 ",
	},
	descriptor_choices =
	{
		race = { ["Tutorial Human"] = "forbid", },
		class = { ["Tutorial Adventurer"] = "forbid", },
	},
	copy = {
		instakill_immune = 1,
		__game_difficulty = 1,
	},
}
newBirthDescriptor{
	type = "difficulty",
	name = "Normal",
	display_name = "普通",
	selection_default = (config.settings.tome.default_birth and config.settings.tome.default_birth.difficulty == "Normal") or (not config.settings.tome.default_birth) or (config.settings.tome.default_birth and not config.settings.tome.default_birth.difficulty),

	desc =
	{
		"#GOLD##{bold}#普通模式#WHITE##{normal}#",
		" 普 通 难 度 的 挑 战。 ",
		" 你 杀 死 生 物 2  回 合 内 不 能 使 用 楼 梯",
	},
	descriptor_choices =
	{
		race = { ["Tutorial Human"] = "forbid", },
		class = { ["Tutorial Adventurer"] = "forbid", },
	},
	copy = {
		instakill_immune = 1,
		__game_difficulty = 2,
	},
}
newBirthDescriptor{
	type = "difficulty",
	name = "Nightmare",
	display_name = "噩梦",
	selection_default = config.settings.tome.default_birth and config.settings.tome.default_birth.difficulty == "Nightmare",

	desc =
	{
		"#GOLD##{bold}#噩梦模式#WHITE##{normal}#",
		" 高 难 度 游 戏 设 定 ",
		" 所 有 地 区 等 级 提 高 50% ",
		" 所 有 生 物 技 能 等 级 提 高 30%",
		" 稀 有 生 物 出 现 率 略 微 增 加",
		" 你 杀 死 生 物 3  回 合 内 不 能 使 用 楼 梯",
	        " 玩 家 如 果 同 时 选 择 永 久 死 亡 模 式 或 冒 险 模 式 可 以 达 成 噩 梦 模 式 成 就。 ",
	},
	descriptor_choices =
	{
		race = { ["Tutorial Human"] = "forbid", },
		class = { ["Tutorial Adventurer"] = "forbid", },
	},
	copy = {
		instakill_immune = 1,
		__game_difficulty = 3,
		money = 100,
	},
	game_state = {
		default_random_rare_chance = 15,
	},
}
newBirthDescriptor{
	type = "difficulty",
	name = "Insane",
	display_name = "疯狂",
	locked = function() return profile.mod.allow_build.difficulty_insane end,
	locked_desc = " 简 单 模 式， 菜 鸟！ \n 普 通 模 式， 菜 鸟！ \n 噩 梦 模 式， 弱 爆 了！ \n 想 成 为 王 者 领 略 最 强 的 挑 战 吗？ \n 解 锁 疯 狂 模 式！ ",
	selection_default = config.settings.tome.default_birth and config.settings.tome.default_birth.difficulty == "Insane",
	desc =
	{
		"#GOLD##{bold}#疯狂模式#WHITE##{normal}#",
		" 和 噩 梦 规 则 相 似 ，但 随 机 boss 出 现 更 加 频 繁 ！",
		" 所 有 区 域 难 度 增 加 相 当 于 人 物 等 级 的 50% + 1级。 ",
		" 所 有 生 物 天 赋 等 级 增 加 50%。 ",
		" 稀 有 怪 出 现 频 率 大 幅 增 加， 同 时 出 现 随 机 Boss。 ",
		" 固 定 boss 拥 有 随 机 技 能",
		" 所 有 敌 人 血 量 增 加 20%",
		" 你 杀 死 生 物 5 回 合 内 不 能 使 用 楼 梯",
		" 玩 家 如 果 同 时 选 择 永 久 死 亡 或 冒 险 模 式 可 以 达 成 疯 狂 模 式 成 就。 ",
	},
	descriptor_choices =
	{
		race = { ["Tutorial Human"] = "forbid", },
		class = { ["Tutorial Adventurer"] = "forbid", },
	},
	copy = {
		instakill_immune = 1,
		__game_difficulty = 4,
		money = 250,
		start_level = 2,
	},
	game_state = {
		default_random_rare_chance = 3,
		default_random_boss_chance = 20,
	},
}
newBirthDescriptor{
	type = "difficulty",
	name = "Madness",
	display_name = "绝望",
	locked = function() return profile.mod.allow_build.difficulty_madness end,
	locked_desc = " 疯 狂 弱 爆 了！ 来 体 验 真 正 让 大 脑 崩 溃 的 感 觉 吧！",
	selection_default = config.settings.tome.default_birth and config.settings.tome.default_birth.difficulty == "Madness",
	desc =
	{
		"#GOLD##{bold}# 绝望模式#WHITE##{normal}#",
		" 绝 对 不 公 平 的 游 戏 设 定。 选 这 个 模 式 的 都 是 疯 子！ ",
		" 所 有 区 域 难 度 增 加 相 当 于 人 物 等 级 的 150% + 1 级。 ",
		" 所 有 生 物 天 赋 等 级 增 加 170%。 ",
		" 稀 有 怪 出 现 频 率 大 幅 增 加， 同 时 出 现 随 机 Boss。 ",
		" 固 定 boss 拥 有 随 机 技 能",
		" 你 杀 死 生 物 9  回 合 内 不 能 使 用 楼 梯",
		" 玩 家 处 于 被 捕 猎 的 状 态， 一 定 半 径 内 所 有 生 物 都 能 感 知 到 你 的 位 置。 ",
		" 玩 家 如 果 同 时 选 择 永 久 死 亡 模 式 或 冒 险 模 式 可 以 达 成 绝 望 模 式 成 就。 ",
	},
	descriptor_choices =
	{
		race = { ["Tutorial Human"] = "forbid", },
		class = { ["Tutorial Adventurer"] = "forbid", },
	},
	talents = {
		[ActorTalents.T_HUNTED_PLAYER] = 1,
	},
	copy = {
		instakill_immune = 1,
		__game_difficulty = 5,
		money = 500,
		start_level = 3,
	},
	game_state = {
		default_random_rare_chance = 3,
		default_random_boss_chance = 20,
	},
}

--------------- Permadeath
newBirthDescriptor{
	type = "permadeath",
	name = "Exploration",
	display_name = "探索模式",
	locked = function(birther) return birther:isDonator() end,
	locked_desc = "Exploration mode: Infinite lives (donator feature)",
	locked_select = function(birther) birther:selectExplorationNoDonations() end,
	selection_default = config.settings.tome.default_birth and config.settings.tome.default_birth.permadeath == "Exploration",
	desc =
	{
		"#GOLD##{bold}#探 索 模 式#WHITE#",
		" 拥 有 无 限 次 生 命。 #{normal}#",
		" 这 不 是 本 游 戏 推 荐 的 游 戏 方 式， 不 过 也 能 让 你 有 一 个 更 难 忘 的 经 历。 ",
		" 请 记 住 死 亡 作 为 游 戏 的 一 部 分 是 为 了 让 你 成 为 一 个 更 好 的 玩 家。 ",
		" 此 模 式 你 可 以 完 成 探 索 模 式 成 就。 ",
		" 此 模 式 下 你 可 以 无 限 洗 点 。",
	},
	game_state = {
		force_town_respec = false,
	},
	copy = {
		infinite_respec = 1,
		infinite_lifes = 1,
	},
}
newBirthDescriptor{
	type = "permadeath",
	name = "Adventure",
	display_name = "冒险模式",
	selection_default = (not config.settings.tome.default_birth) or (config.settings.tome.default_birth and config.settings.tome.default_birth.permadeath == "Adventure"),
	desc =
	{
		"#GOLD##{bold}#冒险模式#WHITE#",
		" 你 拥 有 有 限 的 额 外 生 命。 ",
		" 如 果 还 没 有 准 备 好 一 条 命 通 关 就 用 这 个 模 式 进 行。 #{normal}#",
		" 在 达 到 1,2,5,7,14,24,35 级 时 你 分 别 可 以 得 到 额 外 一 次 生 命 的 奖 励。 ",
	},
	copy = {
		easy_mode_lifes = 1,
	},
}
newBirthDescriptor{
	type = "permadeath",
	name = "Roguelike",
	display_name = "永久死亡模式",
	selection_default = config.settings.tome.default_birth and config.settings.tome.default_birth.permadeath == "Roguelike",
	desc =
	{
		"#GOLD##{bold}#永久死亡模式#WHITE#",
		" 经 典 的 Roguelike 模 式。 ",
		" 你 只 有 一 次 生 命 机 会。 #{normal}#",
		" 除 非 你 在 游 戏 内 找 到 某 些 原 地 复 活 的 能 力。 ",
	},
}


-- Worlds
load("/data/birth/worlds.lua")

-- Races
load("/data/birth/races/tutorial.lua")
load("/data/birth/races/human.lua")
load("/data/birth/races/elf.lua")
load("/data/birth/races/halfling.lua")
load("/data/birth/races/dwarf.lua")
load("/data/birth/races/yeek.lua")
load("/data/birth/races/giant.lua")
load("/data/birth/races/undead.lua")
load("/data/birth/races/construct.lua")

-- Sexes
load("/data/birth/sexes.lua")

-- Classes
load("/data/birth/classes/tutorial.lua")
load("/data/birth/classes/warrior.lua")
load("/data/birth/classes/rogue.lua")
load("/data/birth/classes/mage.lua")
load("/data/birth/classes/wilder.lua")
load("/data/birth/classes/celestial.lua")
load("/data/birth/classes/corrupted.lua")
load("/data/birth/classes/afflicted.lua")
load("/data/birth/classes/chronomancer.lua")
load("/data/birth/classes/psionic.lua")
load("/data/birth/classes/adventurer.lua")
load("/data/birth/classes/none.lua")
