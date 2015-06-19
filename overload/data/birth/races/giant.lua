-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2015 Nicolas Casalini
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
--                       Giants                         --
---------------------------------------------------------
newBirthDescriptor{
	type = "race",
	name = "Giant",
	display_name = "巨人",
	locked = function() return profile.mod.allow_build.race_giant end,
	locked_desc = "庞然的巨物傲视着渺小的生灵。然而须知，高处不胜寒，站得越高，跌得越深……",
	desc = {
		[[#{italic}#"巨 人"#{normal}# 是 对 那 些 身 高 超 过 八 英 尺 的 人 型 生 物 的 统 称 。他 们 的 起 源 、 文 化 和 关 系 与 其 他 种 族 迥 异 。他 们 被 其 他 矮 小 的 种 族 视 为 威 胁 而 躲 避， 作 为 避 难 的 流 浪 者 而 生 存 。]],
	},
	descriptor_choices =
	{
		subrace =
		{
			Ogre = "allow",
			__ALL__ = "disallow",
		},
	},
	copy = {
		type = "giant", subtype="giant",
	},
}

---------------------------------------------------------
--                       Ogres                         --
---------------------------------------------------------
newBirthDescriptor
{
	type = "subrace",
	name = "Ogre",
	display_name = " 食 人 魔 ",
	locked = function() return profile.mod.allow_build.race_ogre end,
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
	moddable_attachement_spots = "race_ogre",
	inc_stats = { str=3, mag=2, wil=-2, cun=2, dex=-1, con=0 },
	experience = 1.3,
	talents_types = { ["race/ogre"]={true, 0} },
	talents = { [ActorTalents.T_OGRE_WRATH]=1 },
	copy = {
		moddable_tile = "ogre_#sex#",
		random_name_def = "shalore_#sex#", random_name_max_syllables = 4,
		default_wilderness = {"playerpop", "shaloren"},
		starting_zone = "scintillating-caves",
		starting_quest = "start-shaloren",
		faction = "shalore",
		starting_intro = "ogre",
		life_rating = 13,
		size_category = 4,
		resolvers.inscription("RUNE:_SHIELDING", {cooldown=14, dur=5, power=100}),
		resolvers.inscription("RUNE:_PHASE_DOOR", {cooldown=7, range=10, dur=5, power=15}),
		resolvers.inventory({id=true, transmo=false, alter=function(o) o.inscription_data.cooldown=18 o.inscription_data.apply=15 o.inscription_data.power=25 end, {type="scroll", subtype="rune", name="biting gale rune", ego_chance=-1000, ego_chance=-1000}}),
		resolvers.inventory{ id=true, {defined="ORB_SCRYING"} },
	},
	experience = 1.3,
	random_escort_possibilities = { {"tier1.1", 1, 2}, {"tier1.2", 1, 2}, {"daikara", 1, 2}, {"old-forest", 1, 4}, {"dreadfell", 1, 8}, {"reknor", 1, 2}, },

	cosmetic_unlock = {
		cosmetic_race_human_redhead = {
			{name="Redhead [donator only]", donator=true, on_actor=function(actor) if actor.moddable_tile then actor.moddable_tile_base = "base_redhead_01.png" end end},
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
