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
--                       Dwarves                       --
---------------------------------------------------------
newBirthDescriptor{
	type = "race",
	name = "Dwarf",
	display_name = " 矮人 ",
	desc = {
		"    矮 人 是 一 支 隐 秘 的 种 族， 生 活 于 地 下 世 界 钢 铁 王 座。 ",
		"    他 们 是 支 强 壮 的 种 族 并 以 大 师 级 手 艺 而 闻 名， 但 是， 由 于 在 过 去 的 战 乱 中 为 了 自 身 利 益 抛 弃 了 其 他 种 族， 他 们 仍 然 不 受 欢 迎。 ",
		"    矮 人 们 出 于 对 金 钱 的 热 衷 和 他 们 对 王 国 的 热 爱 而 联 合 在 一 起。 ",
	},
	descriptor_choices =
	{
		subrace =
		{
			__ALL__ = "disallow",
			Dwarf = "allow",
		},
	},
	copy = {
		faction = "iron-throne",
		type = "humanoid", subtype="dwarf",
		calendar = "dwarf",
		default_wilderness = {"playerpop", "dwarf"},
		starting_zone = "reknor-escape",
		starting_quest = "start-dwarf",
		starting_intro = "dwarf",
		resolvers.inscription("INFUSION:_REGENERATION", {cooldown=10, dur=5, heal=60}),
		resolvers.inscription("INFUSION:_WILD", {cooldown=12, what={physical=true}, dur=4, power=14}),
		resolvers.inventory({id=true, transmo=false, alter=function(o) o.inscription_data.cooldown=12 o.inscription_data.heal=50 end, {type="scroll", subtype="infusion", name="healing infusion", ego_chance=-1000, ego_chance=-1000}}),
		resolvers.inventory{ id=true, {defined="ORB_SCRYING"} },
	},
	random_escort_possibilities = { {"tier1.1", 1, 2}, {"tier1.2", 1, 2}, {"daikara", 1, 2}, {"old-forest", 1, 4}, {"dreadfell", 1, 8}, {"reknor", 1, 2}, },

	moddable_attachement_spots = "race_dwarf",
	cosmetic_unlock = {
		cosmetic_race_dwarf_female_beard = {
			{priority=2, name="Beard [donator only]", donator=true, on_actor=function(actor) if actor.moddable_tile then actor.moddable_tile_ornament={female="beard_"..(actor.is_redhead and "redhead_" or "").."01"} end end, check=function(birth) return birth.descriptors_by_type.sex == "Female" end},
			{priority=2, name="Sideburns [donator only]", donator=true, on_actor=function(actor) if actor.moddable_tile then actor.moddable_tile_ornament={female="sideburners_"..(actor.is_redhead and "redhead_" or "").."01"} end end, check=function(birth) return birth.descriptors_by_type.sex == "Female" end},
			{priority=2, name="Mustache [donator only]", donator=true, on_actor=function(actor) if actor.moddable_tile then actor.moddable_tile_ornament={female="mustache_"..(actor.is_redhead and "redhead_" or "").."01"} end end, check=function(birth) return birth.descriptors_by_type.sex == "Female" end},
			{priority=2, name="Flip [donator only]", donator=true, on_actor=function(actor) if actor.moddable_tile then actor.moddable_tile_ornament={female="flip_"..(actor.is_redhead and "redhead_" or "").."01"} end end, check=function(birth) return birth.descriptors_by_type.sex == "Female" end},
			{priority=2, name="Donut [donator only]", donator=true, on_actor=function(actor) if actor.moddable_tile then actor.moddable_tile_ornament={female="donut_"..(actor.is_redhead and "redhead_" or "").."01"} end end, check=function(birth) return birth.descriptors_by_type.sex == "Female" end},
		},
		cosmetic_race_human_redhead = {
			{priority=1, name="Redhead [donator only]", donator=true, reset=function(actor) actor.is_redhead=false end, on_actor=function(actor) if actor.moddable_tile then actor.is_redhead = true actor.moddable_tile_base = "base_redhead_01.png" actor.moddable_tile_ornament2={male="beard_redhead_02"} end end, check=function(birth) return birth.descriptors_by_type.sex == "Male" end},
			{priority=1, name="Redhead [donator only]", donator=true, reset=function(actor) actor.is_redhead=false end, on_actor=function(actor) if actor.moddable_tile then actor.is_redhead = true actor.is_redhead = true actor.moddable_tile_base = "base_redhead_01.png" actor.moddable_tile_ornament2={female="braid_redhead_01"} end end, check=function(birth) return birth.descriptors_by_type.sex == "Female" end},
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
--                       Dwarves                       --
---------------------------------------------------------
newBirthDescriptor
{
	type = "subrace",
	name = "Dwarf",
	display_name = " 矮 人 ",
	desc = {
		"    矮 人 是 一 支 隐 秘 的 种 族， 生 活 于 地 下 世 界 钢 铁 王 座。 ",
		"    他 们 是 支 强 壮 的 种 族 并 以 大 师 级 手 艺 而 闻 名， 但 是， 由 于 在 过 去 的 战 乱 中 为 了 自 身 利 益 抛 弃 了 其 他 种 族， 他 们 仍 然 不 受 欢 迎。 ",
		"    他 们 天 生 掌 握 #GOLD# 钢 筋 铁 骨 #WHITE#， 允 许 他 们 在 短 时 间 内 提 高 护 甲 和 抵 抗。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +4 力 量， -2 敏 捷， +3 体 质 ",
		"#LIGHT_BLUE# * -2 魔 法， +3 意 志， +0 灵 巧 ",
		"#GOLD# 每 等 级 增 加 生 命 值： #LIGHT_BLUE# 12",
		"#GOLD# 经 验 惩 罚： #LIGHT_BLUE# 25%",
	},
	inc_stats = { str=4, con=3, wil=3, mag=-2, dex=-2 },
	talents_types = { ["race/dwarf"]={true, 0} },
	talents = {
		[ActorTalents.T_DWARF_RESILIENCE]=1,
	},
	copy = {
		moddable_tile = "dwarf_#sex#",
		moddable_tile_ornament2 = {male="beard_02", female="braid_01"},
		random_name_def = "dwarf_#sex#",
		life_rating=12,
	},
	experience = 1.25,
}
