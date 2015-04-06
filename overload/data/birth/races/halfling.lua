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
--                      Halflings                      --
---------------------------------------------------------
newBirthDescriptor{
	type = "race",
	name = "Halfling",
	display_name = " 半身人 ",
	desc = {
		"    半 身 人 是 一 个 身 材 十 分 矮 小 的 种 族， 高 度 很 少 有 超 过 4 英 尺。 ",
		"    只 要 愿 意， 他 们 可 以 像 人 类 一 样 做 到 任 何 事 情， 并 且 更 有 纪 律， 更 擅 长 学 习。 ",
		"    半 身 人 军 队 已 经 征 服 了 很 多 国 家， 并 且 在 厄 流 纪 时 他 们 可 以 和 人 类 联 合 王 国 制 衡。 ",
		"    半 身 人 身 手 敏 捷， 好 运， 但 缺 少 力 量。 ",
	},
	descriptor_choices =
	{
		subrace =
		{
			__ALL__ = "disallow",
			Halfling = "allow",
		},
		subclass = {
			-- Only human, elves, halflings and undeads are supposed to be archmages
			Archmage = "allow",
		},
	},
	copy = {
		faction = "allied-kingdoms",
		type = "humanoid", subtype="halfling",
		default_wilderness = {"playerpop", "allied"},
		starting_zone = "trollmire",
		starting_quest = "start-allied",
		starting_intro = "halfling",
		size_category = 2,
		resolvers.inscription("INFUSION:_REGENERATION", {cooldown=10, dur=5, heal=60}),
		resolvers.inscription("INFUSION:_WILD", {cooldown=12, what={physical=true}, dur=4, power=14}),
		resolvers.inventory({id=true, transmo=false, alter=function(o) o.inscription_data.cooldown=12 o.inscription_data.heal=50 end, {type="scroll", subtype="infusion", name="healing infusion", ego_chance=-1000, ego_chance=-1000}}),
		resolvers.inventory{ id=true, {defined="ORB_SCRYING"} },
	},
	random_escort_possibilities = { {"tier1.1", 1, 2}, {"tier1.2", 1, 2}, {"daikara", 1, 2}, {"old-forest", 1, 4}, {"dreadfell", 1, 8}, {"reknor", 1, 2}, },

	moddable_attachement_spots = "race_halfling",
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

---------------------------------------------------------
--                      Halflings                      --
---------------------------------------------------------
newBirthDescriptor
{
	type = "subrace",
	name = "Halfling",
	display_name = " 半 身 人 ",
	desc = {
		"    半 身 人 是 一 个 身 材 十 分 矮 小 的 种 族， 高 度 很 少 有 超 过 4 英 尺。 ",
		"    只 要 愿 意， 他 们 可 以 像 人 类 一 样 做 到 任 何 事 情， 并 且 更 有 纪 律， 更 擅 长 学 习。 ",
		"    半 身 人 军 队 已 经 征 服 了 很 多 国 家， 并 且 在 厄 流 纪 时 他 们 可 以 和 人 类 联 合 王 国 制 衡。 ",
		"    他 们 天 生 掌 握 #GOLD# 小 不 点 的 幸 运 #WHITE# 技 能 可 以 使 他 们 在 几 个 回 合 内 提 高 暴 击 几 率。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * -3 力 量， +3 敏 捷， +1 体 质 ",
		"#LIGHT_BLUE# * +0 魔 法， +0 意 志， +3 灵 巧 ",
		"#LIGHT_BLUE# * +5 幸 运 ",
		"#GOLD# 每 等 级 增 加 生 命 值： #LIGHT_BLUE# 12",
		"#GOLD# 经 验 惩 罚： #LIGHT_BLUE# 20%",
	},
	inc_stats = { str=-3, dex=3, con=1, cun=3, lck=5, },
	experience = 1.20,
	talents_types = { ["race/halfling"]={true, 0} },
	talents = {
		[ActorTalents.T_HALFLING_LUCK]=1,
	},
	copy = {
		moddable_tile = "halfling_#sex#",
		random_name_def = "halfling_#sex#",
		life_rating = 12,
	},
}
