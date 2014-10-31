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
--                       Elves                         --
---------------------------------------------------------
newBirthDescriptor{
	type = "race",
	name = "Elf",
	display_name = " 精灵 ",
	desc = {
		"    精 灵 这 个 名 字 通 常 被 用 来 不 正 确 地 称 呼 整 个 精 灵 种 族。 ",
		"    精 灵 分 为 3 个 相 互 联 系 的 种 族 而 目 前 只 有 两 种 还 幸 存 着。 ",
		"    除 了 永 恒 精 灵 用 魔 法 保 持 永 生 其 他 精 灵 通 常 能 活 一 千 年。 ",
		"    在 不 同 的 精 灵 种 族 之 间 他 们 对 世 界 的 看 法 很 不 相 同。 ",
	},
	descriptor_choices =
	{
		subrace =
		{
			Shalore = "allow",
			Thalore = "allow",
			__ALL__ = "disallow",
		},
		subclass =
		{
			-- Only human and elves make sense to play celestials
			['Sun Paladin'] = "allow",
			Anorithil = "allow",
			-- Only human, elves, halflings and undeads are supposed to be archmages
			Archmage = "allow",
		},
	},
	copy = {
		type = "humanoid", subtype="elf",
		starting_zone = "trollmire",
		starting_quest = "start-allied",
		resolvers.inventory{ id=true, {defined="ORB_SCRYING"} },
	},

	moddable_attachement_spots = "race_elf",
	cosmetic_unlock = {
		cosmetic_race_human_redhead = {
			{name="Redhead [donator only]", donator=true, on_actor=function(actor) if actor.moddable_tile then actor.moddable_tile_base = "base_redhead_01.png" end end, check=function(birth) return birth.descriptors_by_type.sex == "Male" end},
			{name="Redhead [donator only]", donator=true, on_actor=function(actor) if actor.moddable_tile then actor.moddable_tile_base = "base_redhead_01.png" actor.moddable_tile_ornament={female="braid_redhead_02"} end end, check=function(birth) return birth.descriptors_by_type.sex == "Female" end},
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
--                       Elves                         --
---------------------------------------------------------
newBirthDescriptor
{
	type = "subrace",
	name = "Shalore",
	display_name = " 永 恒 精 灵 ",
	desc = {
		"    永 恒 精 灵 与 魔 法 世 界 有 着 千 丝 万 缕 的 联 系， 曾 一 度 出 现 过 许 多 伟 大 的 魔 法 师。 ",
		"    尽 管 如 此， 他 们 仍 试 图 保 持 避 世 并 隐 藏 他 们 的 魔 法 能 力。 因 为 他 们 深 深 记 得 那 一 段 血 腥 的 历 史 魔 法 大 爆 炸 还 有 紧 随 其 后 的 猎 魔 行 动。 ",
		"    他 们 天 生 掌 握 #GOLD# 不 朽 的 恩 赐 #WHITE#， 允 许 他 们 在 短 时 间 内 提 高 整 体 速 度。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * -2 力 量， +1 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +2 魔 法， +3 意 志， +1 灵 巧 ",
		"#GOLD# 每 等 级 增 加 生 命 值： #LIGHT_BLUE# 9",
		"#GOLD# 经 验 惩 罚： #LIGHT_BLUE# 25%",
	},
	inc_stats = { str=-2, mag=2, wil=3, cun=1, dex=1, con=0 },
	experience = 1.3,
	talents_types = { ["race/shalore"]={true, 0} },
	talents = { [ActorTalents.T_SHALOREN_SPEED]=1 },
	copy = {
		moddable_tile = "elf_#sex#",
		moddable_tile_base = "base_shalore_01.png",
		moddable_tile_ornament = {female="braid_02"},
		random_name_def = "shalore_#sex#", random_name_max_syllables = 4,
		default_wilderness = {"playerpop", "shaloren"},
		starting_zone = "scintillating-caves",
		starting_quest = "start-shaloren",
		faction = "shalore",
		starting_intro = "shalore",
		life_rating = 9,
		resolvers.inscription("RUNE:_SHIELDING", {cooldown=14, dur=5, power=100}),
		resolvers.inscription("RUNE:_PHASE_DOOR", {cooldown=7, range=10, dur=5, power=15}),
	},
	experience = 1.25,
	random_escort_possibilities = { {"tier1.1", 1, 2}, {"tier1.2", 1, 2}, {"daikara", 1, 2}, {"old-forest", 1, 4}, {"dreadfell", 1, 8}, {"reknor", 1, 2}, },
}

newBirthDescriptor
{
	type = "subrace",
	name = "Thalore",
	display_name = " 自 然 精 灵 ",
	desc = {
		"    在 大 部 分 岁 月 里， 自 然 精 灵 隐 藏 在 丛 林 里， 很 少 离 开。 岁 月 流 逝， 这 一 习 惯 都 没 有 改 变。 ",
		"    他 们 长 期 隐 居 在 自 然 中， 由 于 和 自 然 的 紧 密 联 系， 自 然 精 灵 成 为 自 然 秩 序 的 保 护 者， 并 与 他 们 的 近 亲 永 恒 精 灵 处 于 对 立 状 态。 ",
		"    他 们 天 生 掌 握 #GOLD# 自 然 之 怒 #WHITE#， 允 许 他 们 在 短 时 间 内 提 高 伤 害 和 抵 抗。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +2 力 量， +3 敏 捷， +1 体 质 ",
		"#LIGHT_BLUE# * -2 魔 法， +1 意 志， +0 灵 巧 ",
		"#GOLD# 每 等 级 增 加 生 命 值： #LIGHT_BLUE# 11",
		"#GOLD# 经 验 惩 罚： #LIGHT_BLUE# 35%",
	},
	inc_stats = { str=2, mag=-2, wil=1, cun=0, dex=3, con=1 },
	talents_types = { ["race/thalore"]={true, 0} },
	talents = { [ActorTalents.T_THALOREN_WRATH]=1 },
	copy = {
		moddable_tile = "elf_#sex#",
		moddable_tile_base = "base_thalore_01.png",
		moddable_tile_ornament = {female="braid_01"},
		random_name_def = "thalore_#sex#",
		default_wilderness = {"playerpop", "thaloren"},
		starting_zone = "norgos-lair",
		starting_quest = "start-thaloren",
		faction = "thalore",
		starting_intro = "thalore",
		life_rating = 11,
		resolvers.inscription("INFUSION:_REGENERATION", {cooldown=10, dur=5, heal=60}),
		resolvers.inscription("INFUSION:_WILD", {cooldown=12, what={physical=true}, dur=4, power=14}),
	},
	experience = 1.35,
	random_escort_possibilities = { {"tier1.1", 1, 2}, {"tier1.2", 1, 2}, {"daikara", 1, 2}, {"old-forest", 1, 4}, {"dreadfell", 1, 8}, {"reknor", 1, 2}, },
}
