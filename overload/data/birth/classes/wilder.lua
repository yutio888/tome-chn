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
	name = "Wilder",
	display_name= " 野性系 ",
	locked = function() return profile.mod.allow_build.wilder_wyrmic or profile.mod.allow_build.wilder_summoner or profile.mod.allow_build.wilder_stone_warden end,
	locked_desc = "    自 然 能 力 超 越 了 纯 粹 的 技 能。 经 历 自 然 的 真 正 力 量 来 领 略 它 神 奇 的 恩 赐。 ",
	desc = {
		"    无 论 从 哪 一 方 面 来 说， 野 性 系 都 是 大 自 然 的 守 护 者。 根 据 种 类 的 不 同， 有 着 不 同 的 野 性 系 职 业 … … ",
		"    他 们 可 以 继 承 某 些 生 物 的 特 性 技 能， 也 可 以 召 唤 生 物， 或 感 受 德 鲁 伊 的 召 唤， … … ",
	},
	descriptor_choices =
	{
		subclass =
		{
			__ALL__ = "disallow",
			Summoner = "allow",
			Wyrmic = "allow",
			Oozemancer = "allow",
		},
	},
	copy = {
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Summoner",
	display_name= " 召 唤 师 ",
	locked = function() return profile.mod.allow_build.wilder_summoner end,
	locked_desc = "    不 是 所 有 的 力 量 来 自 于 其 中， 倾 听 自 然 的 祈 祷， 感 受 自 然 的 力 量， 从 中 发 现 我 们 真 正 的 力 量。 ",
	desc = {
		"    召 唤 师 从 不 孤 身 战 斗， 他 们 时 刻 准 备 召 唤 出 宠 物 为 他 们 而 战。 ",
		"    召 唤 师 可 以 同 时 召 唤 战 争 猎 犬 和 火 龙。 ",
		" 他 们 最 重 要 的 属 性 是： 意 志 和 灵 巧。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +0 力 量， +1 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +0 魔 法， +5 意 志， +3 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# +0",
	},
	power_source = {nature=true},
	getStatDesc = function(stat, actor)
		if stat == actor.STAT_CUN then
			return " 最 大 召 唤 数: "..math.floor(actor:getCun()/10)
		end
	end,
	stats = { wil=5, cun=3, dex=1, },
	birth_example_particles = {
		function(actor)
			if actor:addShaderAura("master_summoner", "awesomeaura", {time_factor=6200, alpha=0.7, flame_scale=0.8}, "particles_images/naturewings.png") then
			elseif core.shader.active(4) then actor:addParticles(Particles.new("shader_ring_rotating", 1, {radius=1.1}, {type="flames", zoom=2, npow=4, time_factor=4000, color1={0.2,0.7,0,1}, color2={0,1,0.3,1}, hide_center=0, xy={self.x, self.y}}))
			else actor:addParticles(Particles.new("master_summoner", 1))
			end
		end,
	},
	talents_types = {
		["wild-gift/call"]={true, 0.2},
		["wild-gift/harmony"]={false, 0.1},
		["wild-gift/summon-melee"]={true, 0.3},
		["wild-gift/summon-distance"]={true, 0.3},
		["wild-gift/summon-utility"]={true, 0.3},
		["wild-gift/summon-augmentation"]={false, 0.3},
		["wild-gift/summon-advanced"]={false, 0.3},
		["wild-gift/mindstar-mastery"]={false, 0.1},
		["cunning/survival"]={true, 0},
		["technique/combat-techniques-active"]={false, 0},
		["technique/combat-techniques-passive"]={false, 0},
		["technique/combat-training"]={true, 0},
	},
	talents = {
		[ActorTalents.T_WAR_HOUND] = 1,
		[ActorTalents.T_RITCH_FLAMESPITTER] = 1,
		[ActorTalents.T_MEDITATION] = 1,
		[ActorTalents.T_HEIGHTENED_SENSES] = 1,
	},
	copy = {
		max_life = 90,
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="mindstar", name="mossy mindstar", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="mindstar", name="mossy mindstar", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="light", name="rough leather armour", autoreq=true, ego_chance=-1000},
		},
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Wyrmic",
	display_name= " 龙 战 士 ",
	locked = function() return profile.mod.allow_build.wilder_wyrmic end,
	locked_desc = "    雄 伟、 庄 严、 强 壮 … … 在 通 往 龙 的 道 路 上 和 他 们 一 同 呼 吸， 用 你 的 眼 睛 凝 视 他 们 跳 动 的 心 脏， 在 你 的 唇 间 品 味 他 们 的 威 严。 ",
	desc = {
		"    龙 战 士 是 学 习 守 护 巨 龙 战 斗 方 式 的 战 士。 ",
		"    他 们 从 不 同 的 龙 中 学 习 技 能。 ",
		" 他 们 最 重 要 的 属 性 是： 力 量 和 意 志。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +5 力 量， +0 敏 捷， +1 体 质 ",
		"#LIGHT_BLUE# * +0 魔 法， +3 意 志， +0 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# +2",
	},
	birth_example_particles = {
		function(actor) if core.shader.active(4) then local x, y = actor:attachementSpot("back", true) actor:addParticles(Particles.new("shader_wings", 1, {x=x, y=y, life=18, fade=-0.006, deploy_speed=14})) end end,
		function(actor) if core.shader.active(4) then local x, y = actor:attachementSpot("back", true) actor:addParticles(Particles.new("shader_wings", 1, {x=x, y=y, img="lightningwings", life=18, fade=-0.006, deploy_speed=14})) end end,
		function(actor) if core.shader.active(4) then local x, y = actor:attachementSpot("back", true) actor:addParticles(Particles.new("shader_wings", 1, {x=x, y=y, img="poisonwings", life=18, fade=-0.006, deploy_speed=14})) end end,
		function(actor) if core.shader.active(4) then local x, y = actor:attachementSpot("back", true) actor:addParticles(Particles.new("shader_wings", 1, {x=x, y=y, img="acidwings", life=18, fade=-0.006, deploy_speed=14})) end end,
		function(actor) if core.shader.active(4) then local x, y = actor:attachementSpot("back", true) actor:addParticles(Particles.new("shader_wings", 1, {x=x, y=y, img="sandwings", life=18, fade=-0.006, deploy_speed=14})) end end,
		function(actor) if core.shader.active(4) then local x, y = actor:attachementSpot("back", true) actor:addParticles(Particles.new("shader_wings", 1, {x=x, y=y, img="icewings", life=18, fade=-0.006, deploy_speed=14})) end end,
	},
	power_source = {nature=true, technique=true},
	stats = { str=5, wil=3, con=1, },
	talents_types = {
		["wild-gift/call"]={true, 0.2},
		["wild-gift/harmony"]={false, 0.1},
		["wild-gift/sand-drake"]={true, 0.3},
		["wild-gift/fire-drake"]={true, 0.3},
		["wild-gift/cold-drake"]={true, 0.3},
		["wild-gift/storm-drake"]={true, 0.3},
		["wild-gift/venom-drake"]={true, 0.3},
		["wild-gift/higher-draconic"]={false, 0.3},
		["wild-gift/fungus"]={true, 0.1},
		["cunning/survival"]={false, 0},
		["technique/shield-offense"]={true, 0.1},
		["technique/2hweapon-assault"]={true, 0.1},
		["technique/combat-techniques-active"]={false, 0},
		["technique/combat-techniques-passive"]={true, 0},
		["technique/combat-training"]={true, 0},
	},
	talents = {
		[ActorTalents.T_ICE_CLAW] = 1,
		[ActorTalents.T_MEDITATION] = 1,
		[ActorTalents.T_WEAPONS_MASTERY] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
	},
	copy = {
		drake_touched = 2,
		max_life = 110,
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="battleaxe", name="iron battleaxe", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="light", name="rough leather armour", autoreq=true, ego_chance=-1000}
		},
	},
	copy_add = {
		life_rating = 2,
	},
}


newBirthDescriptor{
	type = "subclass",
	name = "Oozemancer",
	display_name = " 软 泥 使 ",
	locked = function() return profile.mod.allow_build.wilder_oozemancer end,
	locked_desc = " 魔 法 必 定 失 败， 魔 法 终 会 消 亡， 任 何 奥 术 能 量 都 不 能 对 抗 软 泥 的 力 量。 ",
	desc = {
		" 软 泥 使 将 自 己 和 正 常 文 明 割 裂， 让 自 己 与 自 然 更 加 和 谐。 他 们 拒 绝 奥 术 能 量， 同 时， 与 生 俱 来 的 自 然 和 野 性 力 量 让 他 们 成 为 了 对 抗 魔 法 使 用 者 的 中 坚 力 量。 ",
		" 他 们 能 制 造 软 泥 怪， 来 保 护 自 己 或 远 距 离 攻 击 对 方， 同 时 也 能 利 用 灵 晶 和 心 灵 利 刃 来 强 化 自 己。 ",
		" 他 们 最 重 要 的 属 性 是： 意 志 和 灵 巧。 ",
		"#GOLD# 属 性 修 正: ",
		"#LIGHT_BLUE# * +0 力 量， +0 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +0 魔 法， +5 意 志， +4 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# -3",
	},
	power_source = {nature=true, antimagic=true},
	random_rarity = 3,
	getStatDesc = function(stat, actor)
		if stat == actor.STAT_CUN then
			return "Max summons: "..math.floor(actor:getCun()/10)
		end
	end,
	birth_example_particles = {
		function(actor)
			if core.shader.active(4) then actor:addParticles(Particles.new("shader_ring_rotating", 1, {additive=true, radius=1.1}, {type="flames", zoom=5, npow=2, time_factor=9000, color1={0.5,0.7,0,1}, color2={0.3,1,0.3,1}, hide_center=0, xy={0,0}}))
			else actor:addParticles(Particles.new("master_summoner", 1))
			end
		end,
		function(actor)
			if core.shader.active(4) then actor:addParticles(Particles.new("shader_ring_rotating", 1, {additive=true, radius=1.1}, {type="flames", zoom=0.5, npow=4, time_factor=2000, color1={0.5,0.7,0,1}, color2={0.3,1,0.3,1}, hide_center=0, xy={0,0}}))
			else actor:addParticles(Particles.new("master_summoner", 1))
			end
		end,
	},
	stats = { wil=5, cun=4, },
	talents_types = {
		["cunning/survival"]={true, 0.1},
		["wild-gift/call"]={true, 0.3},
		["wild-gift/antimagic"]={true, 0.3},
		["wild-gift/mindstar-mastery"]={true, 0.3},
		["wild-gift/mucus"]={true, 0.3},
		["wild-gift/ooze"]={true, 0.3},
		["wild-gift/fungus"]={false, 0.3},
		["wild-gift/oozing-blades"]={false, 0.3},
		["wild-gift/corrosive-blades"]={false, 0.3},
		["wild-gift/moss"]={true, 0.3},
		["wild-gift/eyals-fury"]={false, 0.3},
		["wild-gift/slime"]={true, 0.3},
	},
	talents = {
		[ActorTalents.T_PSIBLADES] = 1,
		[ActorTalents.T_MITOSIS] = 1,
		[ActorTalents.T_MUCUS] = 1,
		[ActorTalents.T_SLIME_SPIT] = 1,
	},
	copy = {
		forbid_arcane = 2,
		max_life = 90,
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="mindstar", name="mossy mindstar", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="mindstar", name="mossy mindstar", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="cloth", name="linen robe", autoreq=true, ego_chance=-1000},
		},
	},
	copy_add = {
		life_rating = -3,
	},
}
