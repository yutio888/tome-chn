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
	name = "Psionic",
	display_name= " 超能力系 ",
	locked = function() return profile.mod.allow_build.psionic end,
	locked_desc = "    肉 体 的 软 弱 可 以 被 精 神 的 强 大 所 克 服。 寻 找 一 条 能 够 进 入 你 精 神 世 界 的 路。 ",
	desc = {
		" 超 能 力 者 发 掘 自 身 的 潜 在 力 量。 他 们 经 过 高 度 开 发 的 精 神 力 能 够 利 用 许 多 不 同 的 能 量 源 吸 收 能 量 并 可 以 产 生 物 理 效 果。 ",
	},
	descriptor_choices =
	{
		subclass =
		{
			__ALL__ = "disallow",
			Mindslayer = "allow",
			Solipsist = "allow",
		},
	},
	copy = {
		psi_regen = 0.2,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Mindslayer",
	display_name= " 心 灵 杀 手 ",
	locked = function() return profile.mod.allow_build.psionic_mindslayer end,
	locked_desc = "    思 想 可 以 被 鼓 舞， 思 想 也 能 杀 人， 在 几 个 世 纪 的 压 抑、 数 年 的 监 禁 之 后， 我 们 心 中 的 复 仇 思 想 会 从 我 们 最 黑 暗 的 梦 境 中 爆 发。 ",
	desc = {
		"    心 灵 杀 手 专 门 使 用 直 接 而 残 酷 的 精 神 力 量 来 对 付 周 围 的 敌 人。 ",
		"    心 灵 杀 手 在 战 斗 时， 他 们 总 是 在 战 场 中 心， 大 量 的 敌 人 包 围 他 们， 他 们 以 心 灵 感 应 控 制 武 器 极 快 地 挥 砍 敌 人。 ",
		" 他 们 最 重 要 的 属 性 是： 意 志 和 灵 巧。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +1 力 量， +0 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +0 魔 法， +4 意 志， +4 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# -2",
	},
	power_source = {psionic=true},
	stats = { str=1, wil=4, cun=4, },
	birth_example_particles = {
		function(actor)
			if core.shader.active(4) then actor:addParticles(Particles.new("shader_shield", 1, {size_factor=1.1, img="shield5"}, {type="shield", ellipsoidalFactor=1, time_factor=-10000, llpow=1, aadjust=3, color={1, 0, 0.3}}))
			else actor:addParticles(Particles.new("generic_shield", 1, {r=1, g=0, b=0.3, a=0.5}))
			end
		end,
		function(actor)
			if core.shader.active(4) then actor:addParticles(Particles.new("shader_shield", 1, {size_factor=1.1, img="shield5"}, {type="shield", ellipsoidalFactor=1, time_factor=-10000, llpow=1, aadjust=3, color={0.3, 1, 1}}))
			else actor:addParticles(Particles.new("generic_shield", 1, {r=0.3, g=1, b=1, a=0.5}))
			end
		end,
		function(actor)
			if core.shader.active(4) then actor:addParticles(Particles.new("shader_shield", 1, {size_factor=1.1, img="shield5"}, {type="shield", ellipsoidalFactor=1, time_factor=-10000, llpow=1, aadjust=3, color={0.8, 1, 0.2}}))
			else actor:addParticles(Particles.new("generic_shield", 1, {r=0.8, g=1, b=0.2, a=0.5}))
			end
		end,
	},
	talents_types = {
		--Level 0 trees:
		["psionic/absorption"]={true, 0.3},
		["psionic/projection"]={true, 0.3},
		["psionic/psi-fighting"]={true, 0.3},
		["psionic/focus"]={true, 0.3},
		["psionic/voracity"]={true, 0.3},
		["psionic/augmented-mobility"]={true, 0.3},
		["psionic/augmented-striking"]={true, 0.3},
		["psionic/finer-energy-manipulations"]={true, 0.3},
		--Level 10 trees:
		["psionic/kinetic-mastery"]={false, 0.3},
		["psionic/thermal-mastery"]={false, 0.3},
		["psionic/charged-mastery"]={false, 0.3},
		--Miscellaneous trees:
		["cunning/survival"]={true, 0},
		["technique/combat-training"]={true, 0},
	},
	talents = {
		[ActorTalents.T_KINETIC_SHIELD] = 1,
		[ActorTalents.T_KINETIC_AURA] = 1,
		[ActorTalents.T_SKATE] = 1,
		[ActorTalents.T_TELEKINETIC_SMASH] = 1,
	},
	copy = {
		max_life = 110,
		resolvers.equipbirth{ id=true,
			{type="armor", subtype="cloth", name="linen robe", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="greatsword", name="iron greatsword", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="greatsword", name="iron greatsword", autoreq=true, ego_chance=-1000, force_inven = "PSIONIC_FOCUS"}
		},
		resolvers.inventorybirth{ id=true,
			{type="weapon", subtype="mindstar", name="mossy mindstar", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="mindstar", name="mossy mindstar", autoreq=true, ego_chance=-1000},
			{type="gem",},
		},
	},
	copy_add = {
		life_rating = -2,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Solipsist",
	display_name= " 织 梦 者 ",
	locked = function() return profile.mod.allow_build.psionic_solipsist end,
	locked_desc = "    有 些 人 认 为 世 界 由 许 多 个 梦 境 组 成， 而 我 们 生 活 在 这 些 梦 境 里。 寻 找 并 唤 醒 沉 睡 者， 你 可 以 打 开 通 往 梦 境 之 门。 ",
	desc = {
		"      织 梦 者 们 相 信 现 实 具 有 可 塑 性， 而 没 有 任 何 方 面 能 比 的 过 幻 想 对 这 个 世 界 的 重 塑 能 力。 ",
		"    他 们 依 靠 此 理 论 进 行 创 造 和 毁 灭， 侵 入 他 人 的 思 维 并 操 纵 他 人 的 梦 境。 ",
		"    使 用 此 理 论 需 要 付 出 巨 大 的 代 价， 织 梦 者 必 须 对 自 己 的 思 维 有 很 强 的 控 制 力， 否 则 他 将 会 失 去 自 我， 世 界 于 他 而 言 将 成 为 虚 幻。 ",
		" 他 们 最 重 要 的 属 性 是 : 意 志 和 灵 巧 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +0 力 量 , +0 敏 捷 , +0 体 质 ",
		"#LIGHT_BLUE# * +0 魔 法 , +5 意 志 , +4 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# -4 (* 特 殊 *)",
	},
	power_source = {psionic=true},
--	not_on_random_boss = true,
	random_rarity = 3,
	stats = { str=0, wil=5, cun=4, },
	birth_example_particles = {
		function(actor)
			if core.shader.active(4) then actor:addParticles(Particles.new("shader_shield", 1, {size_factor=1.1}, {type="shield", time_factor=-8000, llpow=1, aadjust=7, color={1, 1, 0}}))
			else actor:addParticles(Particles.new("generic_shield", 1, {r=1, g=1, b=0, a=1}))
			end
		end,
	},
	talents_types = {
		-- class
		["psionic/distortion"]={true, 0.3},
		["psionic/dream-smith"]={true, 0.3},
		["psionic/psychic-assault"]={true, 0.3},
		["psionic/slumber"]={true, 0.3},
		["psionic/solipsism"]={true, 0.3},
		["psionic/thought-forms"]={true, 0.3},

		-- generic
		["psionic/dreaming"]={true, 0.3},
		["psionic/feedback"]={true, 0.3},
		["psionic/mentalism"]={true, 0.3},
		["cunning/survival"]={true, 0},

		-- locked trees
		["psionic/discharge"]={false, 0.3},
		["psionic/dream-forge"]={false, 0.3},
		["psionic/nightmare"]={false, 0.3},
	},
	talents = {
		[ActorTalents.T_SLEEP] = 1,

		[ActorTalents.T_MIND_SEAR] = 1,
		[ActorTalents.T_SOLIPSISM] = 1,
		[ActorTalents.T_THOUGHT_FORMS] = 1,
	},
	copy = {
		max_life = 90,
		resolvers.equipbirth{ id=true,
			{type="armor", subtype="cloth", name="linen robe", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="mindstar", name="mossy mindstar", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="mindstar", name="mossy mindstar", autoreq=true, ego_chance=-1000},
		},
	},
	copy_add = {
		life_rating = -4,
	},
}
