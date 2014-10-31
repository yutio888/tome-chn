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
	name = "Rogue",
	display_name= " 盗贼系 ",
	desc = {
		"    盗 贼 是 诡 计 大 师， 他 们 可 以 从 阴 影 中 发 动 攻 击， 也 可 以 引 诱 怪 物 到 他 们 的 死 亡 陷 阱 里。 ",
	},
	descriptor_choices =
	{
		subclass =
		{
			__ALL__ = "disallow",
			Rogue = "allow",
			Shadowblade = "allow",
			Marauder = "allow",
			Skirmisher = "allow",
		},
	},
	copy = {
		max_life = 100,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Rogue",
	display_name= " 盗 贼 ",
	desc = {
		"    盗 贼 是 诡 计 专 家。 盗 贼 可 以 潜 行 到 你 背 后 而 不 被 发 现， 然 后 通 过 背 后 刺 杀 中 造 成 巨 大 伤 害。 ",
		"    盗 贼 通 常 双 持 匕 首， 他 们 同 样 可 以 成 为 陷 阱 专 家， 除 了 安 装 陷 阱 以 外 他 们 可 以 侦 测 并 拆 除 陷 阱。 ",
		" 他 们 最 重 要 的 属 性 是： 敏 捷 和 灵 巧。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +1 力 量， +3 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +0 魔 法， +0 意 志， +5 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# +0",
	},
	power_source = {technique=true},
	stats = { dex=3, str=1, cun=5, },
	talents_types = {
		["technique/dualweapon-attack"]={true, 0.3},
		["technique/dualweapon-training"]={true, 0.3},
		["technique/combat-techniques-active"]={false, 0.3},
		["technique/combat-techniques-passive"]={false, 0.3},
		["technique/combat-training"]={true, 0.3},
		["technique/field-control"]={false, 0},
		["technique/acrobatics"]={true, 0.3},
		["cunning/stealth"]={true, 0.3},
		["cunning/trapping"]={true, 0.3},
		["cunning/dirty"]={true, 0.3},
		["cunning/lethality"]={true, 0.3},
		["cunning/survival"]={true, 0.3},
		["cunning/scoundrel"]={true, 0.3},
	},
	unlockable_talents_types = {
		["cunning/poisons"]={false, 0.3, "rogue_poisons"},
	},
	talents = {
		[ActorTalents.T_SHOOT] = 1,
		[ActorTalents.T_STEALTH] = 1,
		[ActorTalents.T_TRAP_MASTERY] = 1,
		[ActorTalents.T_LETHALITY] = 1,
		[ActorTalents.T_DUAL_STRIKE] = 1,
		[ActorTalents.T_KNIFE_MASTERY] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
	},
	copy = {
		equipment = resolvers.equipbirth{ id=true,
			{type="weapon", subtype="dagger", name="iron dagger", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="dagger", name="iron dagger", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="light", name="rough leather armour", autoreq=true, ego_chance=-1000}
		},
		resolvers.inventorybirth{ id=true, inven="QS_MAINHAND",
			{type="weapon", subtype="sling", name="rough leather sling", autoreq=true, ego_chance=-1000},
		},
		resolvers.inventorybirth{ id=true, inven="QS_QUIVER",
			{type="ammo", subtype="shot", name="pouch of iron shots", autoreq=true, ego_chance=-1000},
		},
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Shadowblade",
	display_name= " 影 舞 者 ",
	desc = {
		"    影 舞 者 是 拥 有 魔 法 天 赋 的 特 殊 盗 贼， 他 们 可 以 在 阴 影 之 中 发 动 偷 袭 同 时 可 以 施 展 魔 法 来 强 化 他 们 的 攻 击 和 生 存 能 力。 ",
		"    他 们 的 魔 法 并 非 习 得 而 是 与 生 俱 来 的， 因 此 他 们 不 能 依 靠 自 然 的 法 力 恢 复 而 必 须 依 靠 额 外 的 道 具 来 恢 复 法 力 值。 ",
		"    他 们 使 用 幻 觉、 时 间、 预 知 和 传 送 技 能 来 增 强 他 们 的 行 动。 ",
		" 他 们 最 重 要 的 属 性 是： 敏 捷、 灵 巧 和 魔 法。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +0 力 量， +3 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +3 魔 法， +0 意 志， +3 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# +0",
	},
	power_source = {technique=true, arcane=true},
	stats = { dex=3, mag=3, cun=3, },
	talents_types = {
		["spell/phantasm"]={true, 0},
		["spell/temporal"]={false, 0},
		["spell/divination"]={false, 0},
		["spell/conveyance"]={true, 0},
		["technique/dualweapon-attack"]={true, 0.2},
		["technique/dualweapon-training"]={true, 0.2},
		["technique/combat-techniques-active"]={true, 0.3},
		["technique/combat-techniques-passive"]={false, 0.3},
		["technique/combat-training"]={true, 0.2},
		["cunning/stealth"]={false, 0.3},
		["cunning/survival"]={true, 0.1},
		["cunning/lethality"]={true, 0.3},
		["cunning/dirty"]={true, 0.3},
		["cunning/shadow-magic"]={true, 0.3},
		["cunning/ambush"]={false, 0.3},
	},
	talents = {
		[ActorTalents.T_DUAL_STRIKE] = 1,
		[ActorTalents.T_SHADOW_COMBAT] = 1,
		[ActorTalents.T_PHASE_DOOR] = 1,
		[ActorTalents.T_LETHALITY] = 1,
		[ActorTalents.T_KNIFE_MASTERY] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
	},
	copy = {
		resolvers.inscription("RUNE:_MANASURGE", {cooldown=25, dur=10, mana=620}),
		equipment = resolvers.equipbirth{ id=true,
			{type="weapon", subtype="dagger", name="iron dagger", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="dagger", name="iron dagger", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="light", name="rough leather armour", autoreq=true, ego_chance=-1000}
		},
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Marauder",
	display_name= " 掠 夺 者 ",
	locked = function() return profile.mod.allow_build.rogue_marauder end,
	locked_desc = "    我 不 会 隐 藏 也 不 潜 行， 与 我 的 双 刀 起 舞 看 看 谁 才 是 最 终 的 强 者， 撕 碎 骨 头 敲 碎 头 颅， 战 斗 的 声 响 让 生 活 丰 富 多 彩！ ",
	desc = {
		"    马 基 · 埃 亚 尔 的 野 外 不 是 个 安 全 的 地 方。 野 兽 和 到 处 游 荡 的 龙 似 乎 是 巨 大 的 威 胁， 然 而 真 正 危 险 的 是 两 条 腿 的 人。 窃 贼、 强 盗、 刺 客 投 机 冒 险 家、 疯 狂 的 巫 师 甚 至 狂 热 的 猎 魔 者 都 会 让 那 些 走 出 安 全 的 城 墙 之 外 的 冒 险 者 丧 命。 ",
		"    在 这 混 乱 之 中 诞 生 了 一 种 特 殊 的 盗 贼， 他 们 擅 于 正 面 交 锋 而 不 是 使 用 诡 计。 拥 有 精 准 特 技、 灵 巧 步 伐 和 锋 利 刀 刃 的 掠 夺 者 搜 寻 他 的 目 标 并 直 接 消 灭 他 们。 他 们 通 过 高 等 战 斗 训 练 使 双 持 武 器 更 加 有 效， 情 形 不 利 时 他 们 不 会 忌 讳 使 用 肮 脏 的 手 段 取 得 胜 利。 ",
		" 他 们 最 重 要 的 技 能 是： 力 量、 敏 捷 和 灵 巧。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +4 力 量， +4 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +0 魔 法， +0 意 志， +1 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# +0",
	},
	stats = { dex=4, str=4, cun=1, },
	talents_types = {
		["technique/dualweapon-attack"]={true, 0.2},
		["technique/dualweapon-training"]={true, 0.2},
		["technique/combat-techniques-active"]={true, 0.3},
		["technique/combat-techniques-passive"]={true, 0.0},
		["technique/combat-training"]={true, 0.3},
		["technique/field-control"]={true, 0.3},
		["technique/battle-tactics"]={false, 0.2},
		["technique/mobility"]={true, 0.3},
		["technique/thuggery"]={true, 0.3},
		["technique/conditioning"]={true, 0.3},
		["technique/bloodthirst"]={false, 0.1},
		["cunning/dirty"]={true, 0.3},
		["cunning/tactical"]={false, 0.2},
		["cunning/survival"]={true, 0.3},
	},
	unlockable_talents_types = {
		["cunning/poisons"]={false, -0.1, "rogue_poisons"},
	},
	talents = {
		[ActorTalents.T_DIRTY_FIGHTING] = 1,
		[ActorTalents.T_SKULLCRACKER] = 1,
		[ActorTalents.T_HACK_N_BACK] = 1,
		[ActorTalents.T_DUAL_STRIKE] = 1,
		[ActorTalents.T_ARMOUR_TRAINING] = 1,
	},
	copy = {
		equipment = resolvers.equipbirth{ id=true,
			{type="weapon", subtype="dagger", name="iron dagger", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="dagger", name="iron dagger", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="light", name="rough leather armour", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="head", name="iron helm", autoreq=true, ego_chance=-1000},
		},
	},
}


newBirthDescriptor{
	type = "subclass",
	name = "Skirmisher",
	display_name = "散兵",
	locked = function() return profile.mod.allow_build.rogue_skirmisher end,
	locked_desc = "脚 底 抹 油， 百 发 百 中， 散 兵 可 以 从 远 处 压 制 敌 人， 然 后 在 混 战 中 给 予 敌 人 痛 击。 ",
	desc = {
		" 灵 活 的 移 动 让 散 兵 甩 开 试 图 接 近 的 对 手， 并 得 以 最 大 程 度 地 发 挥 投 石 索 的 威 力， 这 让 他 们 在 与 其 他 远 程 职 业 作 战 时 也 占 据 优 势。 ",
		" 他 们 也 精 通 盾 牌 的 使 用， 这 让 他 们 在 持 久 战 中 也 几 乎 处 于 不 败 之 地。 ",
		" 他 们 最 重 要 的 属 性 是： 敏 捷 和 灵 巧 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +0 力 量， +4 敏 捷， +0 体 质",
		"#LIGHT_BLUE# * +0 魔 法， +1 意 志， +4 灵 巧",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# +0",
	},
	power_source = {technique=true},
	stats = {dex = 4, cun = 4, wil = 1},
	talents_types = {
		-- class
		["technique/skirmisher-slings"]={true, 0.3},
		["technique/buckler-training"]={true, 0.3},
		["cunning/called-shots"]={true, 0.3},
		["technique/tireless-combatant"]={true, 0.3},
		["cunning/trapping"]={false, 0.1},

		-- generic
		["technique/acrobatics"]={true, 0.3},
		["cunning/survival"]={true, 0.3},
		["technique/combat-training"]={true, 0.3},
		["technique/field-control"]={false, 0.1},
	},
	unlockable_talents_types = {
		["cunning/poisons"]={false, 0.2, "rogue_poisons"},
	},
	talents = {
		[ActorTalents.T_SKIRMISHER_VAULT] = 1,
		[ActorTalents.T_SHOOT] = 1,
		[ActorTalents.T_SKIRMISHER_KNEECAPPER] = 1,
		[ActorTalents.T_SKIRMISHER_SLING_SUPREMACY] = 1,
		[ActorTalents.T_SKIRMISHER_BUCKLER_EXPERTISE] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
	},
	copy = {
		resolvers.equipbirth{
			id=true,
			{type="armor", subtype="light", name="rough leather armour", autoreq=true,ego_chance=-1000},
			{type="weapon", subtype="sling", name="rough leather sling", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="shield", name="iron shield", autoreq=false, ego_chance=-1000, ego_chance=-1000},
			{type="ammo", subtype="shot", name="pouch of iron shots", autoreq=true, ego_chance=-1000},
		},
		resolvers.generic(function(e)
			e.auto_shoot_talent = e.T_SHOOT
		end),
	},
	copy_add = {
		life_rating = 0,
	},
}
