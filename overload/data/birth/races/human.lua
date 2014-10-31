-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2014 Nicolas Casalini
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

---------------------------------------------------------
--                       Humans                        --
---------------------------------------------------------
newBirthDescriptor{
	type = "race",
	name = "Human",
	display_name = " 人类 ",
	desc = {
		"    人 类 与 半 身 人 一 起 是 马 基 · 埃 亚 尔 的 主 要 种 族， 他 们 曾 互 相 争 战 了 几 千 年， 直 到 在 领 袖 们 的 伟 大 领 导 下， 人 类 和 半 身 人 的 国 度 再 度 联 合 起 来。 ",
		"    联 合 王 国 的 人 们 已 经 保 持 了 一 个 世 纪 的 和 平。 ",
		"    人 类 被 分 为 两 个 亚 种： 高 等 人 类 和 普 通 人 类。 高 等 人 类 体 内 流 淌 着 魔 法 的 血 液， 他 们 拥 有 额 外 的 属 性 和 感 知 能 力 并 更 长 寿。 ",
		"    其 他 人 类 天 生 有 更 强 的 学 习 能 力， 他 们 能 做 任 何 他 们 想 做 的 事 成 为 任 何 他 们 想 成 为 的 人。 ",
	},
	descriptor_choices =
	{
		subrace =
		{
			["Cornac"] = "allow",
			["Higher"] = "allow",
			__ALL__ = "disallow",
		},
		subclass =
		{
			-- Only human and elves make sense to play celestials
			['Sun Paladin'] = "allow",
			['Anorithil'] = "allow",
			-- Only human, elves, halflings and undeads are supposed to be archmages
			Archmage = "allow",
		},
	},
	talents = {},
	copy = {
		faction = "allied-kingdoms",
		type = "humanoid", subtype="human",
		resolvers.inscription("INFUSION:_REGENERATION", {cooldown=10, dur=5, heal=60}),
		resolvers.inscription("INFUSION:_WILD", {cooldown=12, what={physical=true}, dur=4, power=14}),
		resolvers.inventory{ id=true, {defined="ORB_SCRYING"} },
	},
	random_escort_possibilities = { {"tier1.1", 1, 2}, {"tier1.2", 1, 2}, {"daikara", 1, 2}, {"old-forest", 1, 4}, {"dreadfell", 1, 8}, {"reknor", 1, 2}, },

	moddable_attachement_spots = "race_human",
	cosmetic_unlock = {
		cosmetic_race_human_redhead = {
			{name="Redhead [donator only]", donator=true, on_actor=function(actor) if actor.moddable_tile then actor.moddable_tile_base = "base_redhead_01.png" end end},
			{name="Red braids [donator only]", donator=true, on_actor=function(actor) if actor.moddable_tile then actor.moddable_tile_ornament = {female="braid_redhead_01"} end end, check=function(birth) return birth.descriptors_by_type.sex == "Female" end},
		},
		cosmetic_bikini =  {
			{name="Bikini [donator only]", donator=true, on_actor=function(actor, birther, last)
				if not last then local o = birther.obj_list_by_name.Bikini if not o then print("No bikini found!") return end actor:getInven(actor.INVEN_BODY)[1] = o:cloneFull()
				else actor:registerOnBirthForceWear("FUN_BIKINI") end
			end, check=function(birth) return birth.descriptors_by_type.sex == "Female" end},
			{name="Mankini [donator only]", donator=true, on_actor=function(actor, birther, last)
				if not last then local o = birther.obj_list_by_name.Mankini if not o then print("No mankini found!") return end actor:getInven(actor.INVEN_BODY)[1] = o:cloneFull()
				else actor:registerOnBirthForceWear("FUN_MANKINI") end
			end, check=function(birth) return birth.descriptors_by_type.sex == "Male" end},
		},
	},
}

---------------------------------------------------------
--                       Humans                        --
---------------------------------------------------------
newBirthDescriptor
{
	type = "subrace",
	name = "Higher",
	display_name = " 高等人类 ",
	desc = {
		"    自 厄 流 纪 起， 高 等 人 类 就 是 人 类 种 族 的 一 支 特 殊 分 支， 他 们 的 身 体 里 潜 藏 着 魔 力。 ",
		"    为 了 保 持 血 统 的 纯 正， 他 们 一 般 不 和 普 通 人 类 通 婚。 ",
		"    他 们 天 生 掌 握 #GOLD# 纯 血 之 礼 #WHITE#， 允 许 他 们 在 短 暂 的 时 间 内 治 疗 伤 口。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +1 力 量， +1 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +1 魔 法， +1 意 志， +0 灵 巧 ",
		"#GOLD# 每 等 级 增 加 生 命 值： #LIGHT_BLUE# 11",
		"#GOLD# 经 验 惩 罚： #LIGHT_BLUE# 15%",
	},
	inc_stats = { str=1, mag=1, dex=1, wil=1 },
	experience = 1.15,
	talents_types = { ["race/higher"]={true, 0} },
	talents = {
		[ActorTalents.T_HIGHER_HEAL]=1,
	},
	copy = {
		moddable_tile = "human_#sex#",
		moddable_tile_base = "base_higher_01.png",
		random_name_def = "higher_#sex#",
		life_rating = 11,
		default_wilderness = {"playerpop", "allied"},
		starting_zone = "trollmire",
		starting_quest = "start-allied",
		starting_intro = "higher",
	},
}

newBirthDescriptor
{
	type = "subrace",
	name = "Cornac",
	display_name = " 普 通 人 类 ",
	desc = {
		"    普 通 人 类 是 来 自 联 合 王 国 北 部 的 普 通 人。 ",
		"    人 类 天 生 适 应 性 强， 他 们 可 以 在 出 生 时 获 得 1 点 天 赋 解 锁 点（ 其 他 种 族 只 能 在 10、 20 和 36 级 时 获 得 1 点）。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +0 力 量， +0 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +0 魔 法， +0 意 志， +0 灵 巧 ",
		"#GOLD# 每 等 级 增 加 生 命 值： #LIGHT_BLUE# 10",
		"#GOLD# 经 验 惩 罚： #LIGHT_BLUE# 0%",
	},
	experience = 1.0,
	copy = {
		moddable_tile = "human_#sex#",
		moddable_tile_base = "base_cornac_01.png",
		random_name_def = "cornac_#sex#",
		unused_talents_types = 1,
		life_rating = 10,
		default_wilderness = {"playerpop", "allied"},
		starting_zone = "trollmire",
		starting_quest = "start-allied",
		starting_intro = "cornac",
	},
}
