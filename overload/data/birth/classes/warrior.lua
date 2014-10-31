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
	name = "Warrior",
	display_name = " 战士系 ",
	desc = {
		"    战 士 精 通 于 各 种 物 理 系 战 斗 技 能， 他 们 可 以 手 持 双 手 大 剑 造 成 成 吨 的 打 击， 也 可 以 身 穿 重 甲 手 持 盾 牌 成 为 一 个 强 大 的 护 卫。 ",
	},
	descriptor_choices =
	{
		subclass =
		{
			__ALL__ = "disallow",
			Berserker = "allow",
			Bulwark = "allow",
			Archer= "allow",
			Brawler = "allow",
			["Arcane Blade"] = "allow",
		},
	},
	copy = {
		max_life = 120,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Berserker",
	display_name = " 狂 战 士 ",
	desc = {
		"    狂 战 士 手 持 双 手 武 器， 以 毁 灭 性 的 伤 害 将 他 的 敌 人 砍 成 两 半。 ",
		"    狂 战 士 通 常 专 注 于 造 成 伤 害 而 忽 视 自 我 防 御。 ",
		" 他 们 最 重 要 的 属 性 是 力 量 和 体 质。 ",
		"#GOLD# 属 性 修 正： :",
		"#LIGHT_BLUE# * +5 力 量， +1 敏 捷， +3 体 质 ",
		"#LIGHT_BLUE# * +0 魔 法， +0 意 志， +0 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# +3",
	},
	power_source = {technique=true},
	stats = { str=5, con=3, dex=1, },
	talents_types = {
		["technique/archery-training"]={false, 0.1},
		["technique/shield-defense"]={false, -0.1},
		["technique/2hweapon-assault"]={true, 0.3},
		["technique/strength-of-the-berserker"]={true, 0.3},
		["technique/combat-techniques-active"]={true, 0.3},
		["technique/combat-techniques-passive"]={true, 0.3},
		["technique/combat-training"]={true, 0.3},
		["technique/conditioning"]={true, 0.3},
		["technique/superiority"]={false, 0.3},
		["technique/warcries"]={false, 0.3},
		["technique/field-control"]={false, 0},
		["technique/bloodthirst"]={false, 0.2},
		["cunning/survival"]={true, 0},
		["cunning/dirty"]={false, 0},
	},
	talents = {
		[ActorTalents.T_WARSHOUT_BERSERKER] = 1,
		[ActorTalents.T_STUNNING_BLOW_ASSAULT] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
		[ActorTalents.T_ARMOUR_TRAINING] = 1,
	},
	copy = {
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="greatsword", name="iron greatsword", autoreq=true, ego_chance=-1000, ego_chance=-1000},
			{type="armor", subtype="heavy", name="iron mail armour", autoreq=true, ego_chance=-1000, ego_chance=-1000},
		},
	},
	copy_add = {
		life_rating = 3,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Bulwark",
	display_name = " 盾 战 士 ",
	desc = {
		"    盾 战 士 精 通 于 武 器 和 使 用 盾 牌 格 斗 并 拥 有 极 高 的 防 御 技 能。 ",
		"    一 个 好 的 盾 战 士 能 够 使 用 盾 牌 承 受 来 自 各 方 的 攻 击， 当 时 机 一 到 就 立 即 将 对 手 置 于 死 地。 ",
		" 他 们 最 重 要 的 属 性 是： 力 量 和 敏 捷。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +5 力 量， +2 敏 捷， +2 体 质 ",
		"#LIGHT_BLUE# * +0 魔 法， +0 意 志， +0 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# +2",
	},
	power_source = {technique=true},
	stats = { str=5, con=2, dex=2, },
	talents_types = {
		["technique/archery-training"]={false, 0.1},
		["technique/shield-offense"]={true, 0.3},
		["technique/shield-defense"]={true, 0.3},
		["technique/2hweapon-offense"]={false, -0.1},
		["technique/combat-techniques-active"]={true, 0.3},
		["technique/combat-techniques-passive"]={true, 0.3},
		["technique/combat-training"]={true, 0.3},
		["technique/conditioning"]={true, 0.3},
		["technique/superiority"]={false, 0.3},
		["technique/warcries"]={false, 0.3},
		["technique/battle-tactics"]={false, 0.3},
		["technique/field-control"]={false, 0},
		["cunning/survival"]={true, 0},
		["cunning/dirty"]={false, 0},
	},
	talents = {
		[ActorTalents.T_SHIELD_PUMMEL] = 1,
		[ActorTalents.T_SHIELD_WALL] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
		[ActorTalents.T_ARMOUR_TRAINING] = 2,
		[ActorTalents.T_WEAPONS_MASTERY] = 1,
	},
	copy = {
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="longsword", name="iron longsword", autoreq=true, ego_chance=-1000, ego_chance=-1000},
			{type="armor", subtype="shield", name="iron shield", autoreq=true, ego_chance=-1000, ego_chance=-1000},
			{type="armor", subtype="heavy", name="iron mail armour", autoreq=true, ego_chance=-1000, ego_chance=-1000}
		},
	},
	copy_add = {
		life_rating = 2,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Archer",
	display_name = " 弓 箭 手 ",
	desc = {
		"    弓 箭 手 是 身 手 矫 健 的 远 程 战 士， 能 将 他 的 敌 人 钉 在 原 地 再 射 出 如 雨 般 的 箭 矢 消 灭 对 手。 ",
		"    高 等 级 的 弓 箭 手 可 以 射 出 特 殊 的 箭 矢， 可 以 是 射 穿 目 标， 减 速 或 者 使 目 标 钉 在 原 地。 ",
		"    弓 箭 手 可 以 使 用 长 弓 和 投 石 索。 ",
		" 他 们 最 重 要 的 属 性 是： 敏 捷 和 力 量 （ 装 备 弓 时） 或 灵 巧 ( 装 备 投 石 索 )",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +2 力 量， +5 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +0 魔 法， +0 意 志， +2 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# +0",
	},
	power_source = {technique=true, technique_ranged=true},
	stats = { dex=5, str=2, cun=2, },
	talents_types = {
		["technique/archery-training"]={true, 0.3},
		["technique/archery-utility"]={true, 0.3},
		["technique/archery-bow"]={true, 0.3},
		["technique/archery-sling"]={true, 0.3},
		["technique/archery-excellence"]={false, 0.3},
		["technique/combat-techniques-active"]={false, -0.1},
		["technique/combat-techniques-passive"]={true, -0.1},
		["technique/combat-training"]={true, 0.3},
		["technique/field-control"]={true, 0},
		["cunning/trapping"]={false, 0.2},
		["cunning/survival"]={true, 0},
		["cunning/dirty"]={false, 0},
	},
	unlockable_talents_types = {
		["cunning/poisons"]={false, 0.2, "rogue_poisons"},
	},
	talents = {
		[ActorTalents.T_FLARE] = 1,
		[ActorTalents.T_STEADY_SHOT] = 1,
		[ActorTalents.T_BOW_MASTERY] = 1,
		[ActorTalents.T_SLING_MASTERY] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
	},
	copy = {
		max_life = 110,
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="longbow", name="elm longbow", autoreq=true, ego_chance=-1000},
			{type="ammo", subtype="arrow", name="quiver of elm arrows", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="light", name="rough leather armour", autoreq=true, ego_chance=-1000},
		},
		resolvers.inventorybirth{ id=true, inven="QS_MAINHAND",
			{type="weapon", subtype="sling", name="rough leather sling", autoreq=true, ego_chance=-1000},
		},
		resolvers.inventorybirth{ id=true, inven="QS_QUIVER",
			{type="ammo", subtype="shot", name="pouch of iron shots", autoreq=true, ego_chance=-1000},
		},
		resolvers.generic(function(e)
			e.auto_shoot_talent = e.T_SHOOT
		end),
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Arcane Blade",
	display_name = " 奥 术 之 刃 ",
	desc = {
		"    奥 术 之 刃 是 一 个 拥 有 魔 法 的 战 士。 ",
		"    他 们 的 魔 法 并 非 习 得 而 是 与 生 俱 来 的， 因 此 他 们 不 能 依 靠 法 力 恢 复 而 必 须 依 靠 额 外 的 道 具 来 恢 复 法 力 值。 ",
		"    他 们 能 施 展 一 些 有 限 的 法 术 同 时 也 能 将 法 术 融 合 在 他 们 的 近 战 攻 击 中。 ",
		"    他 们 能 使 用 各 种 武 器 来 造 成 伤 害。 ",
		" 他 们 最 重 要 的 属 性 是： 力 量、 灵 巧 和 魔 法。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +3 力 量， +0 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +3 魔 法， +0 意 志， +3 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# +2",
	},
	power_source = {technique=true, arcane=true},
	stats = { mag=3, str=3, cun=3},
	talents_types = {
		["spell/fire"]={true, 0.2},
		["spell/air"]={true, 0.2},
		["spell/earth"]={true, 0.2},
		["spell/conveyance"]={true, 0.2},
		["spell/aegis"]={true, 0.1},
		["spell/enhancement"]={true, 0.2},
		--["technique/battle-tactics"]={false, 0.2},
		["technique/superiority"]={false, 0.2},
		["technique/combat-techniques-active"]={true, 0.1},
		["technique/combat-techniques-passive"]={false, 0.1},
		["technique/combat-training"]={true, 0.1},
		["technique/magical-combat"]={true, 0.3},
		["technique/shield-offense"]={false, 0},
		["technique/2hweapon-assault"]={false, 0},
		["technique/dualweapon-attack"]={false, 0},
		["cunning/survival"]={true, 0.1},
		["cunning/dirty"]={true, 0.2},
	},
	unlockable_talents_types = {
		["spell/stone"]={false, 0.1, "mage_geomancer"},
	},
	birth_example_particles = {
		function(actor) if core.shader.active(4) then
			local slow = rng.percent(50)
			local h1x, h1y = actor:attachementSpot("hand1", true) if h1x then actor:addParticles(Particles.new("shader_shield", 1, {img="fireball", a=0.7, size_factor=0.4, x=h1x, y=h1y-0.1}, {type="flamehands", time_factor=slow and 700 or 1000})) end
			local h2x, h2y = actor:attachementSpot("hand2", true) if h2x then actor:addParticles(Particles.new("shader_shield", 1, {img="fireball", a=0.7, size_factor=0.4, x=h2x, y=h2y-0.1}, {type="flamehands", time_factor=not slow and 700 or 1000})) end
		end end,
		function(actor) if core.shader.active(4) then
			local slow = rng.percent(50)
			local h1x, h1y = actor:attachementSpot("hand1", true) if h1x then actor:addParticles(Particles.new("shader_shield", 1, {img="lightningwings", a=0.7, size_factor=0.4, x=h1x, y=h1y-0.1}, {type="flamehands", time_factor=slow and 700 or 1000})) end
			local h2x, h2y = actor:attachementSpot("hand2", true) if h2x then actor:addParticles(Particles.new("shader_shield", 1, {img="lightningwings", a=0.7, size_factor=0.4, x=h2x, y=h2y-0.1}, {type="flamehands", time_factor=not slow and 700 or 1000})) end
		end end,
	},
	talents = {
		[ActorTalents.T_FLAME] = 1,
		[ActorTalents.T_ARCANE_COMBAT] = 1,
		[ActorTalents.T_DIRTY_FIGHTING] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
	},
	copy = {
		max_life = 100,
--		talent_cd_reduction={[ActorTalents.T_FLAME]=-3, [ActorTalents.T_LIGHTNING]=-3, [ActorTalents.T_EARTHEN_MISSILES]=-3, },
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="greatsword", name="iron greatsword", autoreq=true, ego_chance=-1000, ego_chance=-1000},
			{type="armor", subtype="light", name="rough leather armour", autoreq=true, ego_chance=-1000, ego_chance=-1000},
		},
		resolvers.inscription("RUNE:_MANASURGE", {cooldown=25, dur=10, mana=620}),
	},
	copy_add = {
		life_rating = 2,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Brawler",
	display_name = " 格 斗 家 ",
	locked = function() return profile.mod.allow_build.warrior_brawler end,
	locked_desc = "    虽 然 你 击 败 了 许 多 对 手， 你 也 知 道 你 命 中 注 定 要 战 斗 至 死， 但 你 毫 不 退 缩， 在 鲜 血 之 环 你 会 知 道 只 有 依 靠 你 的 双 拳 来 面 对 这 个 世 界。 ",
	desc = {
		"    魔 法 大 爆 炸 造 成 的 物 资 匮 乏 使 得 武 器 成 为 一 种 奢 侈 品， 并 不 是 每 个 人 都 能 担 负 的 起。 ",
		"    没 有 钢 铁 打 造 的 装 备， 穷 人 们 开 始 依 靠 他 们 自 身 的 力 量 开 始 与 黑 暗 斗 争。 ",
		"    无 论 是 一 个 职 业 拳 手 还 是 个 业 余 的 门 外 汉， 格 斗 技 能 现 在 是 随 处 可 学 的。 ",
		"    格 斗 家 的 许 多 技 能 可 以 累 积 连 击 点 数 然 后 用 一 个 终 结 技 能 造 成 额 外 的 打 击 效 果。 ",
		"    格 斗 家 徒 手 战 斗 依 靠 双 手 的 灵 活 机 动 性， 所 以 他 们 无 法 学 习 装 备 重 甲、 盾 牌 或 者 武 器。 ",
		" 他 们 最 重 要 的 属 性 是： 力 量、 敏 捷 和 灵 巧 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +3 力 量， +3 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +0 魔 法， +0 意 志， +3 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# +2",
	},
	power_source = {technique=true},
	stats = { str=3, dex=3, cun=3},
	talents_types = {
		["cunning/dirty"]={false, 0},
		["cunning/tactical"]={true, 0.3},
		["cunning/survival"]={false, 0},
		["technique/combat-training"]={true, 0.1},
		["technique/field-control"]={true, 0},
		["technique/combat-techniques-active"]={true, 0.1},
		["technique/combat-techniques-passive"]={true, 0.1},
		["technique/pugilism"]={true, 0.3},
		["technique/finishing-moves"]={true, 0.3},
		["technique/grappling"]={false, 0.3},
		["technique/unarmed-discipline"]={false, 0.3},
		["technique/unarmed-training"]={true, 0.3},
		["technique/conditioning"]={true, 0.1},
		["technique/mobility"]={true, 0.2},
	},
	talents = {
		[ActorTalents.T_UPPERCUT] = 1,
		[ActorTalents.T_DOUBLE_STRIKE] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
		[ActorTalents.T_ARMOUR_TRAINING] = 1,
		[ActorTalents.T_UNARMED_MASTERY] = 1, -- early game is absolutely stupid without this
	},
	copy = {
		resolvers.equipbirth{ id=true,
			{type="armor", subtype="hands", name="iron gauntlets", autoreq=true, ego_chance=-1000, ego_chance=-1000},
			{type="armor", subtype="light", name="rough leather armour", autoreq=true, ego_chance=-1000, ego_chance=-1000},
		},
		resolvers.inventorybirth{ id=true,
			{type="armor", subtype="hands", name="rough leather gloves", ego_chance=-1000, ego_chance=-1000},
		},
	},
	copy_add = {
		life_rating = 2,
	},
}