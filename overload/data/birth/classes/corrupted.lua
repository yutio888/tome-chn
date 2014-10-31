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
local Particles = require "engine.Particles"

newBirthDescriptor{
	type = "class",
	name = "Defiler",
	display_name= " 堕落系 ",
	locked = function() return profile.mod.allow_build.corrupter end,
	locked_desc = "    黑 暗 的 思 想、 黑 色 的 血 液、 卑 鄙 的 行 为 … … 那 些 背 信 弃 义 的 人 会 发 现 他 们 的 力 量 所 在。 ",
	desc = {
		"    堕 落 者 身 上 有 魔 鬼 的 印 记， 他 们 是 世 界 的 祸 害， 为 魔 鬼 卖 命， 服 务 于 他 们 的 主 人， 或 者 他 们 自 己 成 为 主 人。 ",
	},
	descriptor_choices =
	{
		subclass =
		{
			__ALL__ = "disallow",
			Reaver = "allow",
			Corruptor = "allow",
		},
	},
	copy = {
		max_life = 120,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Reaver",
	display_name= " 收 割 者 ",
	locked = function() return profile.mod.allow_build.corrupter_reaver end,
	locked_desc = "    收 割 敌 人 的 灵 魂 ， 你 会 发 现 黑 暗 的 力 量 涌 入 体 内。 ",
	desc = {
		"    收 割 者 是 一 个 恐 怖 的 对 手， 他 可 以 向 敌 人 挥 舞 每 只 手 的 武 器。 ",
		"    他 们 可 以 驾 驭 魔 鬼 的 枯 萎 术， 将 恐 怖 的 疾 病 传 染 给 目 标， 然 后 击 碎 他 们 的 头 颅。 ",
		" 他 们 最 重 要 的 属 性 是： 力 量 和 魔 法。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +4 力 量， +1 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +4 魔 法， +0 意 志， +0 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# +2",
	},
	birth_example_particles = {
		function(actor)
			if core.shader.allow("adv") then actor:addParticles(Particles.new("shader_ring_rotating", 1, {toback=true, a=0.5, rotation=0, radius=1.5, img="bone_shield"}, {type="boneshield", chargesCount=4})) end
		end,
	},
	power_source = {arcane=true, technique=true},
	stats = { str=4, mag=4, dex=1, },
	talents_types = {
		["technique/combat-training"]={true, 0.3},
		["cunning/survival"]={false, 0.1},
		["corruption/sanguisuge"]={true, 0.3},
		["corruption/reaving-combat"]={true, 0.3},
		["corruption/scourge"]={true, 0.3},
		["corruption/plague"]={true, 0.3},
		["corruption/hexes"]={false, 0.3},
		["corruption/curses"]={false, 0.3},
		["corruption/bone"]={true, 0.3},
		["corruption/torment"]={true, 0.3},
		["corruption/vim"]={true, 0.3},
	},
	talents = {
		[ActorTalents.T_CORRUPTED_STRENGTH] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
		[ActorTalents.T_DRAIN] = 1,
		[ActorTalents.T_REND] = 1,
	},
	copy = {
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="waraxe", name="iron waraxe", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="waraxe", name="iron waraxe", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="light", name="rough leather armour", autoreq=true, ego_chance=-1000}
		},
	},
	copy_add = {
		life_rating = 2,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Corruptor",
	display_name= " 堕 落 者 ",
	locked = function() return profile.mod.allow_build.corrupter_corruptor end,
	locked_desc = "    枯 萎 和 邪 恶 组 成 了 强 大 的 力 量。 接 受 诱 惑 成 为 堕 落 者 中 的 一 员 吧。 ",
	desc = {
		"    堕 落 者 是 一 个 恐 怖 的 对 手， 使 用 黑 暗 魔 法 并 汲 取 目 标 的 灵 魂。 ",
		"    他 们 驾 驭 魔 鬼 的 枯 萎 术， 压 制 灵 魂， 偷 取 生 命 力 量 来 恢 复 自 己。 ",
		"    最 强 大 的 堕 落 者 甚 至 可 以 召 唤 恶 魔 来 守 护 他 们。 ",
		" 他 们 最 重 要 的 属 性 是： 魔 法 和 意 志。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +0 力 量， +0 敏 捷， +2 体 质 ",
		"#LIGHT_BLUE# * +4 魔 法， +3 意 志， +0 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# +0",
	},
	power_source = {arcane=true},
	stats = { mag=4, wil=3, con=2, },
	birth_example_particles = {
		function(actor)	if core.shader.active(4) then actor:addParticles(Particles.new("shadowfire", 1)) end end,
		function(actor) if core.shader.active(4) then local x, y = actor:attachementSpot("back", true) actor:addParticles(Particles.new("shader_wings", 1, {infinite=1, x=x, y=y, img="bloodwings", flap=28, a=0.6})) end
		end,
	},
	talents_types = {
		["cunning/survival"]={false, 0},
		["corruption/sanguisuge"]={true, 0.3},
		["corruption/hexes"]={true, 0.3},
		["corruption/curses"]={true, 0.3},
		["corruption/bone"]={false, 0.3},
		["corruption/plague"]={true, 0.3},
		["corruption/shadowflame"]={false, 0.3},
		["corruption/blood"]={true, 0.3},
		["corruption/vim"]={true, 0.3},
		["corruption/blight"]={true, 0.3},
		["corruption/torment"]={false, 0.3},
	},
	talents = {
		[ActorTalents.T_DRAIN] = 1,
		[ActorTalents.T_BLOOD_SPRAY] = 1,
		[ActorTalents.T_SOUL_ROT] = 1,
		[ActorTalents.T_PACIFICATION_HEX] = 1,
	},
	copy = {
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="staff", name="elm staff", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="cloth", name="linen robe", autoreq=true, ego_chance=-1000}
		},
	},
}
