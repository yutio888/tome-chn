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
--                       Ghouls                        --
---------------------------------------------------------
newBirthDescriptor{
	type = "race",
	name = "Undead",
	display_name = " 不死族 ",
	locked = function() return profile.mod.allow_build.undead end,
	locked_desc = "    死 亡 的 力 量， 恐 惧 的 意 志， 这 些 肉 体 无 法 保 存。 国 王 去 世， 大 师 陨 落， 我 们 才 是 永 生。 ",
	desc = {
		"    不 死 族 是 被 堕 落 魔 法 复 活 的 人 形 生 物。 ",
		"    不 死 族 有 多 种 形 态， 从 食 尸 鬼、 吸 血 鬼 到 丧 尸。 ",
	},
	descriptor_choices =
	{
		subrace =
		{
			__ALL__ = "disallow",
			Ghoul = "allow",
			Skeleton = "allow",
			Vampire = "allow",
			Wight = "allow",
		},
		class =
		{
			Wilder = "disallow",
		},
		subclass =
		{
			Necromancer = "nolore",
			-- Only human, elves, halflings and undeads are supposed to be archmages
			Archmage = "allow",
		},
	},
	talents = {
		[ActorTalents.T_UNDEAD_ID]=1,
	},
	copy = {
		-- Force undead faction to undead
		resolvers.genericlast(function(e) e.faction = "undead" end),
		starting_zone = "blighted-ruins",
		starting_level = 3, starting_level_force_down = true,
		starting_quest = "start-undead",
		undead = 1,
		forbid_nature = 1,
		inscription_restrictions = { ["inscriptions/runes"] = true, ["inscriptions/taints"] = true, },
		resolvers.inscription("RUNE:_SHIELDING", {cooldown=14, dur=5, power=130}),
		--resolvers.inscription("RUNE:_PHASE_DOOR", {cooldown=7, range=10, dur=5, power=15}),
		resolvers.inscription("RUNE:_HEAT_BEAM", {cooldown=18, range=8, power=40}), -- yeek and undead starts are unfun to the point of absurdity
		resolvers.inventory({id=true, transmo=false,
			{type="scroll", subtype="rune", name="phase door rune", ego_chance=-1000, ego_chance=-1000}}), -- keep this in inventory incase people actually want it, can't add it baseline because some classes start with 3 inscribed
	},

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
	
	random_escort_possibilities = { {"tier1.1", 1, 2}, {"tier1.2", 1, 2}, {"daikara", 1, 2}, {"old-forest", 1, 4}, {"dreadfell", 1, 8}, {"reknor", 1, 2}, },
}

newBirthDescriptor
{
	type = "subrace",
	name = "Ghoul",
	display_name = " 食 尸 鬼 ",
	locked = function() return profile.mod.allow_build.undead_ghoul end,
	locked_desc = "    动 如 磐 石， 撕 咬 如 火， 跟 随 主 人， 平 定 江 山！ ",
	desc = {
		"    食 尸 鬼 是 不 能 说 话、 身 体 腐 烂， 不 知 疲 倦 的 不 死 生 物， 适 合 成 为 战 士。 ",
		"    他 们 天 生 有 独 特 的 #GOLD# 食 尸 鬼 #WHITE# 天 赋 和 一 系 列 不 死 系 天 赋： ",
		"- 极 高 的 毒 素 抗 性 ",
		"- 流 血 免 疫 ",
		"- 震 慑 抵 抗 ",
		"- 恐 惧 免 疫 ",
		"- 独 特 食 尸 鬼 天 赋： 定 向 跳 跃， 侵 蚀 和 亡 灵 唾 液 ",
		" 食 尸 鬼 腐 烂 的 身 体 同 时 使 它 比 别 的 生 物 行 动 要 慢 一 些。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +3 力 量， +1 敏 捷， +5 体 质 ",
		"#LIGHT_BLUE# * +0 魔 法， -2 意 志， -2 灵 巧 ",
		"#GOLD# 每 等 级 增 加 生 命 值： #LIGHT_BLUE# 14",
		"#GOLD# 经 验 惩 罚： #LIGHT_BLUE# 25%",
		"#GOLD# 速 度 惩 罚： #LIGHT_BLUE# -20%",
	},
	moddable_attachement_spots = "race_ghoul", moddable_attachement_spots_sexless=true,
	descriptor_choices =
	{
		sex =
		{
			__ALL__ = "disallow",
			Male = "allow",
		},
	},
	inc_stats = { str=3, con=5, wil=-2, mag=0, dex=1, cun=-2 },
	talents_types = {
		["undead/ghoul"]={true, 0.1},
	},
	talents = {
		[ActorTalents.T_GHOUL]=1,
	},
	copy = {
		type = "undead", subtype="ghoul",
		default_wilderness = {"playerpop", "low-undead"},
		starting_intro = "ghoul",
		life_rating=14,
		poison_immune = 0.8,
		cut_immune = 1,
		stun_immune = 0.5,
		fear_immune = 1,
		global_speed_base = 0.8,
		moddable_tile = "ghoul",
		moddable_tile_nude = 1,
	},
	experience = 1.25,
}

newBirthDescriptor
{
	type = "subrace",
	name = "Skeleton",
	display_name = " 骷 髅 ",
	locked = function() return profile.mod.allow_build.undead_skeleton end,
	locked_desc = "    行 进 之 骨， 咯 吱 有 声； 奴 役 不 再， 战 士 永 存！ ",
	desc = {
		"    骷 髅 是 由 有 灵 性 的 骨 头 组 成 的 强 壮 而 敏 捷 的 不 死 生 物。 ",
		"    它 们 天 生 具 有 独 特 的 #GOLD# 骷 髅 #WHITE# 天 赋 和 一 系 列 不 死 系 天 赋： ",
		"- 毒 素 免 疫 ",
		"- 流 血 免 疫 ",
		"- 恐 惧 免 疫 ",
		"- 不 需 要 呼 吸 ",
		"- 独 特 骷 髅 天 赋： 骨 质 盔 甲、 弹 力 骨 骼、 重 组 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +3 力 量， +4 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +0 魔 法， +0 意 志， +0 灵 巧 ",
		"#GOLD# 每 等 级 增 加 生 命 值： #LIGHT_BLUE# 12",
		"#GOLD# 经 验 惩 罚： #LIGHT_BLUE# 40%",
	},
	moddable_attachement_spots = "race_skeleton", moddable_attachement_spots_sexless=true,
	descriptor_choices =
	{
		sex =
		{
			__ALL__ = "disallow",
			Male = "allow",
		},
	},
	inc_stats = { str=3, con=0, wil=0, mag=0, dex=4, cun=0 },
	talents_types = {
		["undead/skeleton"]={true, 0.1},
	},
	talents = {
		[ActorTalents.T_SKELETON]=1,
	},
	copy = {
		type = "undead", subtype="skeleton",
		default_wilderness = {"playerpop", "low-undead"},
		starting_intro = "skeleton",
		life_rating=12,
		poison_immune = 1,
		cut_immune = 1,
		fear_immune = 1,
		no_breath = 1,
		blood_color = colors.GREY,
		moddable_tile = "skeleton",
		moddable_tile_nude = 1,
	},
	experience = 1.4,
}
