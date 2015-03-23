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
	name = "Chronomancer",
	display_name = " 时空系 ",
	locked = function() return profile.mod.allow_build.chronomancer end,
	locked_desc = "    他 们 是 一 些 另 辟 蹊 径 的 人， 在 平 凡 的 道 路 上 寻 找 出 一 条 隐 藏 的 路。 ",
	desc = {
		"    由 于 可 以 自 由 穿 梭 于 过 去 和 未 来， 时 空 法 师 可 以 随 意 控 制 现 在， 掌 控 着 只 需 遵 循 自 然 平 衡 需 要 的 力 量。 他 们 穿 梭 时 空 时 遗 留 的 痕 迹 使 时 空 技 能 更 加 强 大 和 难 以 控 制。 睿 智 的 时 空 法 师 需 要 学 会 如 何 在 对 无 限 力 量 的 渴 望 和 维 持 世 界 正 常 运 行 之 间 寻 求 平 衡。 因 为 谁 也 不 知 道 为 了 增 强 力 量 撕 裂 的 时 空 虫 洞 会 不 会 在 某 一 天 吞 噬 自 己。 ",
	},
	descriptor_choices =
	{
		subclass =
		{
			__ALL__ = "disallow",
			["Paradox Mage"] = "allow",
			["Temporal Warden"] = "allow",
		},
	},
	copy = {
		-- Chronomancers start in Point Zero
		class_start_check = function(self)
			if self.descriptor.world == "Maj'Eyal" and (self.descriptor.race ~= "Undead" and self.descriptor.race ~= "Dwarf" and self.descriptor.race ~= "Yeek") and not self._forbid_start_override then
				self.chronomancer_race_start_quest = self.starting_quest
				self.default_wilderness = {"zone-pop", "angolwen-portal"}
				self.starting_zone = "town-point-zero"
				self.starting_quest = "start-point-zero"
				self.starting_intro = "chronomancer"
				self.faction = "keepers-of-reality"
				self:learnTalent(self.T_TELEPORT_POINT_ZERO, true, nil, {no_unlearn=true})
			end
			self:triggerHook{"BirthStartZone:chronomancer"}
		end,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Paradox Mage",
	display_name = " 时 光 法 师 ",
	locked = function() return profile.mod.allow_build.chronomancer_paradox_mage end,
	locked_desc = "    如 果 一 只 手 能 拍 到 过 去 的 自 己 那 么 就 可 以 单 手 鼓 掌， 去 寻 找 时 空 的 力 量 吧。 ",
	desc = {
		"    时 光 法 师 学 习 时 空 的 构 造， 不 仅 仅 是 扭 曲 时 空 而 且 还 能 重 塑 时 空。 ",
		"    大 多 数 时 光 法 师 没 有 基 本 的 格 斗 技 能， 但 他 们 可 以 利 用 宇 宙 的 力 量 来 进 行 战 斗。 ",
		"    时 光 法 师 掌 握 各 种 知 识， 并 从 时 光 学 院 里 学 习 更 多 复 杂 的 内 容。 ",
		" 他 们 最 重 要 的 属 性 时： 魔 法 和 意 志。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +0 力 量， +0 敏 捷， +2 体 质 ",
		"#LIGHT_BLUE# * +5 魔 法， +2 意 志， +0 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# 0",
	},
	power_source = {arcane=true},
	random_rarity = 2,
	stats = { mag=5, wil=2, con=2, },
	birth_example_particles = {
		function(actor)
			if core.shader.active(4) then
				actor:addParticles(Particles.new("shader_ring_rotating", 1, {rotation=-0.01, radius=1.2}, {type="stone", hide_center=1, zoom=0.6, color1={0.4, 0.4, 0, 1}, color2={0.5, 0.5, 0, 1}, xy={0, 0}}))
			else
				actor:addParticles(Particles.new("generic_shield", 1, {r=0.4, g=0.4, b=0, a=1}))
			end
		end,
		function(actor)
			if core.shader.allow("adv") then
				actor:addParticles3D("volumetric", {kind="transparent_cylinder", twist=1, shineness=10, density=10, radius=1.4, growSpeed=0.004, img="coggy_00"})
			else
				actor:addParticles(Particles.new("generic_shield", 1, {r=1, g=1, b=0, a=1}))
			end
		end,
		function(actor)
			if core.shader.allow("adv") then
				actor:addParticles3D("volumetric", {kind="fast_sphere", appear=10, radius=1.6, twist=30, density=30, growSpeed=0.004, scrollingSpeed=-0.004, img="continuum_01_3"})
			else
				actor:addParticles(Particles.new("generic_shield", 1, {r=1, g=0, b=0, a=0.5}))
			end
		end,
	},
	talents_types = {
		-- class
		["chronomancy/gravity"]={true, 0.3},
		["chronomancy/matter"]={true, 0.3},
		["chronomancy/spacetime-folding"]={true, 0.3},
		["chronomancy/speed-control"]={true, 0.3},
		["chronomancy/timetravel"]={true, 0.3},
		
		-- locked class
		["chronomancy/flux"]={false, 0.3},
		["chronomancy/spellbinding"]={false, 0.3},
		["chronomancy/stasis"]={false, 0.3},
		["chronomancy/timeline-threading"]={false, 0.3},

		-- generic
		["chronomancy/chronomancy"]={true, 0.3},
		["chronomancy/fate-weaving"]={true, 0.3},
		["chronomancy/spacetime-weaving"]={true, 0.3},

		-- locked generic
		["chronomancy/energy"]={false, 0.3},
		["cunning/survival"]={false, 0},	
	},
	talents = {
		[ActorTalents.T_TEMPORAL_BOLT] = 1,
		[ActorTalents.T_DIMENSIONAL_STEP] = 1,
		[ActorTalents.T_REPULSION_BLAST] = 1,
		[ActorTalents.T_PRECOGNITION] = 1,
	},
	copy = {
		max_life = 90,
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="staff", name="elm staff", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="cloth", name="linen robe", autoreq=true, ego_chance=-1000},
		},
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Temporal Warden",
	display_name = " 时 空 守 卫 ",
	locked = function() return profile.mod.allow_build.chronomancer_temporal_warden end,
	locked_desc = "    我 用 平 衡 过 去 守 护 未 来， 我 们 用 战 斗 来 维 持 时 间 的 秩 序。 ",
	desc = {
		"    时 空 守 卫 学 习 混 合 箭 术， 双 武 器 战 斗 和 时 空 法 术。 ",
		"    通 过 他 们 对 时 空 法 术 的 使 用， 他 们 控 制 战 斗 使 他 们 敌 人 笼 罩 在 箭 雨 或 者 近 身 格 斗 之 中。 ",
		"    他 们 对 时 空 法 术 的 学 习 使 他 们 能 够 放 大 自 身 的 物 理、 魔 法 能 力 同 时 控 制 自 身 和 周 围 的 速 度。 ",
		" 他 们 最 重 要 的 属 性 是： 魔 法 、敏 捷 和 意 志。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +0 力 量， +3 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +4 魔 法， +2 意 志， +0 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# +2",
	},
	power_source = {technique=true, arcane=true},
	random_rarity = 2,
	stats = { wil=2, dex=3, mag=4},
	birth_example_particles = {
		function(actor)
			if core.shader.allow("adv") then
				actor:addParticles3D("volumetric", {kind="fast_sphere", shininess=40, density=40, radius=1.4, scrollingSpeed=0.001, growSpeed=0.004, img="squares_x3_01"})
			else
				actor:addParticles(Particles.new("arcane_power", 1))
			end
		end,
		function(actor)
			if core.shader.active(4) then
				actor:addParticles(Particles.new("shader_shield", 1, {toback=true ,size_factor=1.5, y=-0.3, img="healparadox", life=25}, {type="healing", time_factor=3000, beamsCount=15, noup=2.0, beamColor1={0xb6/255, 0xde/255, 0xf3/255, 1}, beamColor2={0x5c/255, 0xb2/255, 0xc2/255, 1}}))
				actor:addParticles(Particles.new("shader_shield", 1, {toback=false,size_factor=1.5, y=-0.3, img="healparadox", life=25}, {type="healing", time_factor=3000, beamsCount=15, noup=1.0, beamColor1={0xb6/255, 0xde/255, 0xf3/255, 1}, beamColor2={0x5c/255, 0xb2/255, 0xc2/255, 1}}))
			end
		end,
	},
	talents_types = {
		-- class
		["chronomancy/blade-threading"]={true, 0.3},
		["chronomancy/bow-threading"]={true, 0.3},
		["chronomancy/guardian"]={true, 0.3},
		["chronomancy/spacetime-folding"]={true, 0.3},
		["chronomancy/speed-control"]={true, 0.3},
		["chronomancy/temporal-combat"]={true, 0.3},
		
		-- class locked
		["chronomancy/stasis"]={false, 0.1},
		["chronomancy/threaded-combat"]={false, 0.3},
		["chronomancy/temporal-hounds"]={false, 0.3},
		
		-- generic
		["technique/combat-training"]={true, 0.3},
		["chronomancy/chronomancy"]={true, 0.3},
		["chronomancy/spacetime-weaving"]={true, 0.3},
		
		-- generic locked
		["chronomancy/fate-weaving"]={false, 0.1},
		["cunning/survival"]={false, 0},
	},
	talents = {
		[ActorTalents.T_SHOOT] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
		
		[ActorTalents.T_WARP_BLADE] = 1,
		[ActorTalents.T_ARROW_STITCHING] = 1,
		[ActorTalents.T_DIMENSIONAL_STEP] = 1,
		[ActorTalents.T_STRENGTH_OF_PURPOSE] = 1,
	},
	copy = {
		max_life = 100,
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="longbow", name="elm longbow", autoreq=true, ego_chance=-1000},
			{type="ammo", subtype="arrow", name="quiver of elm arrows", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="light", name="rough leather armour", autoreq=true, ego_chance=-1000}
		},
		resolvers.inventorybirth{ id=true, inven="QS_MAINHAND",
			{type="weapon", subtype="longsword", name="iron longsword", autoreq=true, ego_chance=-1000},
		},
		resolvers.inventorybirth{ id=true, inven="QS_OFFHAND",
			{type="weapon", subtype="dagger", name="iron dagger", autoreq=true, ego_chance=-1000},	
		},
	},
	copy_add = {
		life_rating = 2,
	},
}
