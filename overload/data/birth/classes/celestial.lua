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

newBirthDescriptor{
	type = "class",
	name = "Celestial",
	display_name= " 天空系 ",
	locked = function() return profile.mod.allow_build.divine end,
	locked_desc = "    天 空 魔 法 很 少 被 人 了 解， 这 些 知 识 在 失 落 的 远 东 大 陆。 ",
	desc = {
		" 天 空 系 职 业 是 具 有 神 圣 之 体 的 奥 术 使 用 者。 ",
		" 大 部 分 都 是 从 太 阳 和 月 亮 汲 取 能 量。 ",
	},
	descriptor_choices =
	{
		subclass =
		{
			__ALL__ = "disallow",
			['Sun Paladin'] = "allow-nochange",
			Anorithil = "allow-nochange",
		},
	},
	copy = {
		class_start_check = function(self)
			if self.descriptor.world == "Maj'Eyal" and (self.descriptor.race == "Human" or self.descriptor.race == "Elf") and not self._forbid_start_override then
				self.celestial_race_start_quest = self.starting_quest
				self.default_wilderness = {"zone-pop", "ruined-gates-of-morning"}
				self.starting_zone = "town-gates-of-morning"
				self.starting_quest = "start-sunwall"
				self.starting_intro = "sunwall"
				self.faction = "sunwall"
			end
		end,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Sun Paladin",
	display_name= " 太 阳 骑 士 ",
	locked = function() return profile.mod.allow_build.divine_sun_paladin end,
	locked_desc = "    东 方 升 起 的 太 阳 充 满 荣 耀， 但 你 首 先 得 从 黑 暗 之 地 寻 找 到 它。 ",
	desc = {
		"    太 阳 骑 士 出 生 于 晨 曦 之 门， 在 遥 远 东 方 自 由 生 活 人 们 的 最 后 堡 垒 里。 ",
		"    他 们 的 事 业 受 人 尊 敬， 他 们 的 座 右 铭 是： 太 阳 赐 予 我 们 力 量、 圣 洁 和 精 华。 我 们 为 黑 暗 带 去 光 明， 任 何 反 抗 我 们 的 力 量 都 休 想 通 过。 ",
		"    他 们 能 施 展 太 阳 之 力 将 任 何 试 图 破 坏 太 阳 堡 垒 的 力 量 击 退。 ",
		"    同 时 精 通 武 器 和 盾 战 术 并 熟 悉 魔 法， 在 近 身 猛 击 对 手 之 前 他 们 通 常 在 远 处 就 可 以 灼 烧 敌 人。 ",
		" 他 们 最 重 要 的 属 性 是： 力 量 和 魔 法。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +5 力 量， +0 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +4 魔 法， +0 意 志， +0 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# +2",
	},
	power_source = {technique=true, arcane=true},
	stats = { mag=4, str=5, },
	talents_types = {
		["technique/shield-offense"]={true, 0.1},
		["technique/2hweapon-assault"]={true, 0.1},
		["technique/combat-techniques-active"]={false, 0.1},
		["technique/combat-techniques-passive"]={true, 0.1},
		["technique/combat-training"]={true, 0.1},
		["cunning/survival"]={false, 0.1},
		["celestial/sun"]={true, 0.3},
		["celestial/chants"]={true, 0.3},
		["celestial/combat"]={true, 0.3},
		["celestial/light"]={true, 0.3},
		["celestial/guardian"]={false, 0.3},
		["celestial/radiance"]={false, 0.3},
		["celestial/crusader"]={false, 0.3},
	},
	birth_example_particles = "golden_shield",
	talents = {
		[ActorTalents.T_SUN_BEAM] = 1,
		[ActorTalents.T_WEAPON_OF_LIGHT] = 1,
		[ActorTalents.T_CHANT_OF_FORTITUDE] = 1,
		[ActorTalents.T_ARMOUR_TRAINING] = 2,
	},
	copy = {
		max_life = 110,
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="mace", name="iron mace", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="shield", name="iron shield", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="heavy", name="iron mail armour", autoreq=true, ego_chance=-1000},
		},
		resolvers.inventorybirth{ id=true,
			{type="weapon", subtype="greatsword", name="iron greatsword", autoreq=true, ego_chance= -1000},
		},

	},
	copy_add = {
		life_rating = 2,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Anorithil",
	display_name= " 星 月 术 士 ",
	locked = function() return profile.mod.allow_build.divine_anorithil end,
	locked_desc = "    平 衡 天 空 的 力 量 是 一 件 令 人 望 而 生 畏 的 任 务。 他 们 站 在 黎 明 深 处 同 时 掌 控 着 黑 暗 与 光 明 的 力 量。 ",
	desc = {
		"    星 月 术 士 出 生 于 晨 曦 之 门， 在 遥 远 东 方 自 由 生 活 人 们 的 最 后 堡 垒 里。 ",
		"    他 们 的 事 业 受 人 尊 敬， 他 们 的 座 右 铭 是： 我 们 站 在 太 阳 与 月 亮 之 间， 光 暗 交 替 之 界。 在 灰 色 的 黎 明 中 寻 找 我 们 的 使 命。 ",
		"    他 们 可 以 施 展 太 阳、 月 亮 的 法 术 将 任 何 试 图 破 坏 太 阳 堡 垒 的 人 消 灭。 ",
		"    他 们 掌 握 日 月 魔 法， 通 常 在 使 用 星 怒 之 前 他 们 就 可 以 用 太 阳 射 线 灼 烧 他 们 的 对 手。 ",
		" 他 们 最 重 要 的 属 性 是： 魔 法 和 灵 巧。 ",
		"#GOLD# 属 性 修 正 ",
		"#LIGHT_BLUE# * +0 力 量， +0 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +6 魔 法， +0 意 志， +3 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# +0",
	},
	power_source = {arcane=true},
	stats = { mag=6, cun=3, },
	talents_types = {
		["cunning/survival"]={false, 0.1},
		["celestial/sunlight"]={true, 0.3},
		["celestial/chants"]={true, 0.3},
		["celestial/glyphs"]={false, 0.3},
		["celestial/circles"]={false, 0.3},
		["celestial/eclipse"]={true, 0.3},
		["celestial/light"]={true, 0.3},
		["celestial/twilight"]={true, 0.3},
		["celestial/hymns"]={true, 0.3},
		["celestial/star-fury"]={true, 0.3},
	},
	birth_example_particles = "darkness_shield",
	talents = {
		[ActorTalents.T_SEARING_LIGHT] = 1,
		[ActorTalents.T_MOONLIGHT_RAY] = 1,
		[ActorTalents.T_HYMN_OF_SHADOWS] = 1,
		[ActorTalents.T_TWILIGHT] = 1,
	},
	copy = {
		max_life = 90,
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="staff", name="elm staff", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="cloth", name="linen robe", autoreq=true, ego_chance=-1000}
		},
	},
}
