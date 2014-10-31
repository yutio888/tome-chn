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
--                       Yeeks                       --
---------------------------------------------------------
newBirthDescriptor{
	type = "race",
	name = "Yeek",
	display_name = " 夺心魔 ",
	locked = function() return profile.mod.allow_build.yeek end,
	locked_desc = "    一 个 种 族， 一 种 思 想， 一 种 道 路。 我 们 的 压 抑 终 于 要 终 结， 而 我 们 将 继 承 埃 亚 尔， 不 要 认 为 我 们 很 柔 弱， 只 有 那 些 帮 助 我 们 的 人 才 能 见 识 到 我 们 真 正 的 力 量。 ",
	desc = {
		"    夺 心 魔 是 一 支 神 秘 的 种 族， 生 活 于 热 带 岛 屿 瑞 尔。 ",
		"    他 们 的 身 体 覆 盖 着 白 色 的 皮 肤， 他 们 奇 怪 的 身 材 比 例 使 他 们 看 上 去 滑 稽 可 笑。 ",
		"    尽 管 他 们 在 马 基 · 埃 亚 尔 中 几 乎 不 曾 被 提 到 过， 他 们 已 经 作 为 半 身 人 王 国 纳 格 尔 的 奴 隶 存 在 了 数 个 世 纪。 ",
		"    他 们 在 派 尔 纪 获 得 了 自 由 并 在 那 个 时 候 建 立 了 维 网 — — 一 个 由 他 们 超 能 力 思 维 组 成 的 网 络。 ",
	},
	descriptor_choices =
	{
		subrace =
		{
			__ALL__ = "disallow",
			Yeek = "allow",
		},
	},
	copy = {
		faction = "the-way",
		type = "humanoid", subtype="yeek",
		size_category = 2,
		default_wilderness = {"playerpop", "yeek"},
		starting_zone = "town-irkkk",
		starting_quest = "start-yeek",
		starting_intro = "yeek",
		blood_color = colors.BLUE,
		resolvers.inscription("INFUSION:_REGENERATION", {cooldown=10, dur=5, heal=60}),
		resolvers.inscription("INFUSION:_WILD", {cooldown=12, what={physical=true}, dur=4, power=14}),
	},
	game_state = {
		start_tier1_skip = 4,
	},
	random_escort_possibilities = { {"tier1.1", 1, 2}, {"tier1.2", 1, 2}, {"daikara", 1, 2}, {"old-forest", 1, 4}, {"dreadfell", 1, 8}, {"reknor", 1, 2}, },
	moddable_attachement_spots = "race_yeek", moddable_attachement_spots_sexless=true,

	cosmetic_unlock = {
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
--                       Yeeks                       --
---------------------------------------------------------
newBirthDescriptor
{
	type = "subrace",
	name = "Yeek",
	display_name = " 夺 心 魔 ",
	locked = function() return profile.mod.allow_build.yeek end,
	locked_desc = "    一 个 种 族， 一 种 思 想， 一 种 道 路。 我 们 的 压 抑 终 于 要 终 结， 而 我 们 将 继 承 埃 亚 尔， 不 要 认 为 我 们 很 柔 弱， 只 有 那 些 帮 助 我 们 的 人 才 能 见 识 到 我 们 的 力 量。 ",
	desc = {
		"    夺 心 魔 是 一 支 神 秘 的 种 族， 生 活 于 热 带 岛 屿 瑞 尔。 ",
		"    尽 管 他 们 在 马 基 · 埃 亚 尔 中 几 乎 不 曾 被 提 到 过， 他 们 已 经 作 为 半 身 人 王 国 纳 格 尔 的 奴 隶 存 在 了 数 个 世 纪。 ",
		"    他 们 在 派 尔 纪 获 得 了 自 由 并 在 那 个 时 候 建 立 了 维 网 — — 一 个 由 他 们 超 能 力 思 维 组 成 的 网 络。 ",
		"    他 们 天 生 掌 握 #GOLD# 主 导 思 维 #WHITE#， 允 许 他 们 在 短 时 间 内 控 制 一 个 较 弱 生 物 的 思 维。 当 效 果 结 束 时， 被 控 制 目 标 死 亡。 ",
		"    虽 然 夺 心 魔 不 是 两 栖 生 物， 但 他 们 天 生 对 水 有 种 特 殊 的 亲 和 力， 允 许 他 们 屏 息 更 长 时 间。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * -3 力 量， -2 敏 捷， -5 体 质 ",
		"#LIGHT_BLUE# * +0 魔 法， +6 意 志， +4 灵 巧 ",
		"#GOLD# 每 等 级 增 加 生 命 值： #LIGHT_BLUE# 7",
		"#GOLD# 经 验 惩 罚： #LIGHT_BLUE# -15%",
		"#GOLD# 混 乱 抗 性： #LIGHT_BLUE# 35%",
	},
	inc_stats = { str=-3, con=-5, cun=4, wil=6, mag=0, dex=-2 },
	talents_types = { ["race/yeek"]={true, 0} },
	talents = {
		[ActorTalents.T_YEEK_WILL]=1,
		[ActorTalents.T_YEEK_ID]=1,
	},
	copy = {
		life_rating=7,
		confusion_immune = 0.35,
		max_air = 200,
		moddable_tile = "yeek",
		random_name_def = "yeek_#sex#",
	},
	experience = 0.85,
}
