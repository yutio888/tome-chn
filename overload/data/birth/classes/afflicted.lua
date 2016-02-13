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

local Particles = require "engine.Particles"

newBirthDescriptor{
	type = "class",
	name = "Afflicted",
	display_name= " 痛苦系 ",
	locked = function() return profile.mod.allow_build.afflicted end,
	locked_desc = "    他 们 是 一 群 漫 步 于 阴 影 中、 孤 独 的、 讨 人 厌 的、 被 遗 弃 的 人。 他 们 的 力 量 或 许 很 强 大， 但 他 们 的 名 字 永 远 被 诅 咒 着。 ",
	desc = {
		"    痛 苦 系 因 为 他 们 使 用 了 恶 魔 的 力 量 而 变 得 扭 曲。 ",
		"    他 们 能 将 这 股 力 量 转 化 为 优 势， 但 会 为 此 付 出 一 定 的 代 价 … … ",
	},
	descriptor_choices =
	{
		subclass =
		{
			__ALL__ = "disallow",
			Cursed = "allow",
			Doomed = "allow",
		},
	},
	copy = {
		chooseCursedAuraTree = true,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Cursed",
	display_name= " 被 诅 咒 者 ",
	locked = function() return profile.mod.allow_build.afflicted_cursed end,
	locked_desc = "    诅 咒 可 以 深 入 灵 魂， 使 某 人 充 满 憎 恨。 战 胜 另 外 一 个 人 的 憎 恨 诅 咒 来 领 会 这 种 可 怕 的 力 量。 ",
	desc = {
		"    被 诅 咒 者 通 过 无 知、 贪 婪 或 者 愚 昧 的 黑 暗 指 示 让 那 些 罪 恶 受 到 审 判。 ",
		"    他 们 唯 一 的 主 人 是 那 些 生 者 心 中 的 憎 恨。 ",
		"    从 他 们 遇 到 的 死 亡 中 吸 取 力 量 使 被 诅 咒 者 成 为 恐 怖 的 战 士。 ",
		"    更 可 怕 的 是， 任 何 接 近 被 诅 咒 者 的 人 对 受 可 怕 光 环 的 影 响 而 发 狂。 ",
		" 他 们 最 重 要 的 属 性 是： 力 量 和 意 志。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +5 力 量， +0 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +0 魔 法， +4 意 志， +0 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# +2",
	},
	power_source = {psionic=true, technique=true},
	stats = { wil=4, str=5, },
	birth_example_particles = {
		function(actor)
			if not actor:addShaderAura("rampage", "awesomeaura", {time_factor=5000, alpha=0.7}, "particles_images/bloodwings.png") then
				actor:addParticles(Particles.new("rampage", 1))
			end
		end,
	},
	talents_types = {
		["cursed/gloom"]={true, 0.3},
		["cursed/slaughter"]={true, 0.3},
		["cursed/endless-hunt"]={true, 0.3},
		["cursed/strife"]={true, 0.3},
		["cursed/cursed-form"]={true, 0.0},
		["cursed/unyielding"]={true, 0.0},
		["technique/combat-training"]={true, 0.3},
		["cunning/survival"]={false, 0.0},
		["cursed/rampage"]={false, 0.0},
		["cursed/predator"]={false, 0.0},
		["cursed/fears"]={false, 0.0},
	},
	talents = {
		[ActorTalents.T_UNNATURAL_BODY] = 1,
		[ActorTalents.T_GLOOM] = 1,
		[ActorTalents.T_SLASH] = 1,
		[ActorTalents.T_WEAPONS_MASTERY] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
		[ActorTalents.T_ARMOUR_TRAINING] = 1,
	},
	copy = {
		max_life = 110,
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="battleaxe", name="iron battleaxe", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="heavy", name="iron mail armour", autoreq=true, ego_chance=-1000, ego_chance=-1000}
		},
	},
	copy_add = {
		life_rating = 2,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Doomed",
	display_name= " 末 日 使 者 ",
	locked = function() return profile.mod.allow_build.afflicted_doomed end,
	locked_desc = "    在 一 个 未 知 的 地 方 你 必 须 战 胜 你 自 己 并 看 到 你 自 己 的 末 日。 ",
	desc = {
		"    末 日 使 者 是 一 些 堕 落 的 法 师， 他 们 曾 使 用 的 是 黑 暗 契 约 类 法 术 和 具 有 侵 略 性 的 魔 法。 ",
		"    被 黑 暗 剥 夺 了 魔 法 力 量 的 他 们， 开 始 学 习 如 何 驱 使 他 们 精 神 上 燃 烧 的 憎 恨 力 量。 ",
		"    只 有 时 间 会 证 明 他 们 是 选 择 了 一 条 新 的 道 路 还 是 一 条 永 远 的 末 日 惩 罚 之 路。 ",
		"    末 日 使 者 从 黑 暗 阴 影 中 发 动 攻 击。 ",
		"    他 们 通 过 控 制 遭 遇 到 敌 人 的 精 神 来 汲 取 对 方 的 灵 魂。 ",
		" 他 们 最 重 要 的 属 性 是： 意 志 和 灵 巧。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +0 力 量， +0 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +0 魔 法， +4 意 志， +5 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# +0",
	},
	power_source = {psionic=true},
	random_rarity = 2,
	stats = { wil=4, cun=5, },
	talents_types = {
		["cursed/dark-sustenance"]={true, 0.3},
		["cursed/force-of-will"]={true, 0.3},
		["cursed/gestures"]={true, 0.3},
		["cursed/punishments"]={true, 0.3},
		["cursed/shadows"]={true, 0.3},
		["cursed/darkness"]={true, 0.3},
		["cursed/cursed-form"]={true, 0.0},
		["cunning/survival"]={false, 0.0},
		["cursed/fears"]={false, 0.3},
		["cursed/one-with-shadows"]={false, 0.3},
		["cursed/advanced-shadowmancy"]={false, 0.3},
	},
	talents = {
		[ActorTalents.T_UNNATURAL_BODY] = 1,
		[ActorTalents.T_FEED] = 1,
		[ActorTalents.T_GESTURE_OF_PAIN] = 1,
		[ActorTalents.T_WILLFUL_STRIKE] = 1,
		[ActorTalents.T_CALL_SHADOWS] = 1,
	},
	copy = {
		max_life = 90,
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="mindstar", name="mossy mindstar", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="mindstar", name="mossy mindstar", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="cloth", name="linen robe", autoreq=true, ego_chance=-1000},
		},
	},
	copy_add = {
	},
}
