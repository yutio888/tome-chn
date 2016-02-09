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
	name = "Mage",
	display_name= " 法师系 ",
	desc = {
		"    法 师 们 用 魔 法 来 武 装 自 己， 能 够 释 放 破 坏 性 的 法 术 同 时 也 能 利 用 冥 想 来 治 疗 自 己。 ",
	},
	descriptor_choices =
	{
		subclass =
		{
			__ALL__ = "disallow",
			Alchemist = "allow",
			Archmage = "allow-nochange",
			Necromancer = "allow-nochange",
		},
	},
	copy = {
		mana_regen = 0.5,
		mana_rating = 7,
		resolvers.inscription("RUNE:_MANASURGE", {cooldown=25, dur=10, mana=620}),
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Alchemist",
	display_name= " 炼 金 术 士 ",
	desc = {
		"    炼 金 术 士 使 用 魔 法 来 操 纵 物 质。 ",
		"    他 们 不 使 用 那 些 远 古 的 被 禁 止 的 法 术， 那 些 法 术 自 从 魔 法 大 爆 炸 之 后 就 被 封 印。 ",
		"    炼 金 术 士 可 以 将 元 素 力 量 输 入 各 种 宝 石， 使 它 们 变 成 火 球、 酸 液 和 其 他 效 果。 另 外 他 们 也 可 以 利 用 宝 石 来 强 化 装 甲 并 使 用 法 杖 发 射 能 量 球。 ",
		"    炼 金 术 士 自 身 非 常 脆 弱， 通 过 召 唤 炼 金 傀 儡 来 保 护 他 们。 傀 儡 服 从 主 人 的 意 志 并 依 靠 主 人 来 强 化 它 们 的 力 量。 ",
		" 他 们 最 重 要 的 属 性 是： 魔 法 和 体 质。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +0 力 量， +0 敏 捷， +3 体 质 ",
		"#LIGHT_BLUE# * +5 魔 法， +1 意 志， +0 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# -1",
	},
	power_source = {arcane=true},
	stats = { mag=5, con=3, wil=1, },
	birth_example_particles = {
		function(actor)
			actor:addShaderAura("body_of_fire", "awesomeaura", {time_factor=3500, alpha=1, flame_scale=1.1}, "particles_images/wings.png")
		end,
		function(actor)
			actor:addShaderAura("body_of_ice", "crystalineaura", {}, "particles_images/spikes.png")
		end,
	},
	talents_types = {
		["spell/explosives"]={true, 0.3},
		["spell/golemancy"]={true, 0.3},
		["spell/advanced-golemancy"]={false, 0.3},
		["spell/stone-alchemy"]={true, 0.3},
		["spell/fire-alchemy"]={true, 0.3},
		["spell/acid-alchemy"]={true, 0.3},
		["spell/frost-alchemy"]={true, 0.3},
		["spell/energy-alchemy"]={false, 0.3},
		["spell/staff-combat"]={true, 0.3},
		["cunning/survival"]={false, -0.1},
	},
	talents = {
		[ActorTalents.T_CREATE_ALCHEMIST_GEMS] = 1,
		[ActorTalents.T_REFIT_GOLEM] = 1,
		[ActorTalents.T_THROW_BOMB] = 1,
		[ActorTalents.T_FIRE_INFUSION] = 1,
		[ActorTalents.T_CHANNEL_STAFF] = 1,
	},
	copy = {
		max_life = 90,
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="staff", name="elm staff", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="cloth", name="linen robe", autoreq=true, ego_chance=-1000}
		},
		resolvers.inventory{ id=true,
			{type="gem",},
			{type="gem",},
			{type="gem",},
		},
		resolvers.generic(function(self) self:birth_create_alchemist_golem() end),
		innate_alchemy_golem = true,
		birth_create_alchemist_golem = function(self)
			-- Make and wield some alchemist gems
			local t = self:getTalentFromId(self.T_CREATE_ALCHEMIST_GEMS)
			local gem = t.make_gem(self, t, "GEM_AGATE")
			self:wearObject(gem, true, true)
			self:sortInven()

			-- Invoke the golem
			if not self.alchemy_golem then
				local t = self:getTalentFromId(self.T_REFIT_GOLEM)
				t.invoke_golem(self, t)
			end
		end,
	},
	copy_add = {
		life_rating = -1,
	},
	cosmetic_unlock = {
		cosmetic_class_alchemist_drolem = {
			{name="Golem becomes a Drolem [donator only]", on_actor=function(actor) actor.alchemist_golem_is_drolem = true end},
		},
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Archmage",
	display_name= " 元 素 法 师 ",
	locked = function() return profile.mod.allow_build.mage end,
	locked_desc = " 憎 恨、 折 磨、 追 捕、 隐 藏 … … 我 们 的 道 路 被 禁 止， 但 是 我 们 的 事 业 是 公 正 的。 在 我 们 隐 藏 的 山 谷 里 我 们 自 由 学 习 我 们 自 己 的 魔 法 艺 术， 从 这 个 世 界 的 愤 怒 中 寻 求 安 慰。 只 有 友 谊 和 宽 容 才 能 获 得 我 们 的 信 任。 ",
	desc = {
		"    对 一 个 元 素 法 师 来 说 魔 法 超 越 一 切， 他 们 倾 尽 一 生 学 习 魔 法。 ",
		"    元 素 法 师 缺 乏 最 基 本 的 物 理 格 斗 技 能， 他 们 用 魔 法 取 而 代 之。 ",
		"    元 素 法 师 从 学 院 里 获 取 魔 法 知 识， 他 们 通 常 拒 绝 任 何 死 灵 法 术。 ",
		"    元 素 法 师 在 一 个 名 叫 安 格 利 文 的 秘 密 小 镇 接 受 训 练， 并 拥 有 一 个 直 接 传 送 到 那 里 的 独 特 技 能。 ",
		" 他 们 最 重 要 的 属 性 是： 魔 法 和 意 志。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +0 力 量， +0 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +5 魔 法， +3 意 志， +1 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# -4",
	},
	power_source = {arcane=true},
	stats = { mag=5, wil=3, cun=1, },
	birth_example_particles = {
		function(actor)
			if core.shader.active(4) then local x, y = actor:attachementSpot("back", true) actor:addParticles(Particles.new("shader_wings", 1, {x=x, y=y, infinite=1}))
			else actor:addParticles(Particles.new("wildfire", 1))
			end
		end,
		function(actor)
			if core.shader.active(4) then actor:addParticles(Particles.new("shader_ring_rotating", 1, {toback=true, rotation=0, radius=2, img="arcanegeneric", a=0.7}, {type="sunaura", time_factor=5000}))
			else actor:addParticles(Particles.new("ultrashield", 1, {rm=180, rM=220, gm=10, gM=50, bm=190, bM=220, am=120, aM=200, radius=0.4, density=100, life=8, instop=20}))
			end
		end,
		function(actor)
			if core.shader.active(4) then 
				local p1 = actor:addParticles(Particles.new("shader_ring_rotating", 1, {rotation=0, radius=1.1, img="coldgeneric"}, {type="circular_flames", ellipsoidalFactor={1,2}, time_factor=22000, noup=2.0}))
				p1.toback = true
				actor:addParticles(Particles.new("shader_ring_rotating", 1, {rotation=0, radius=1.1, img="coldgeneric"}, {type="circular_flames", ellipsoidalFactor={1,2}, time_factor=22000, noup=1.0}))
			else actor:addParticles(Particles.new("uttercold", 1))
			end
		end,
		function(actor)
			if core.shader.active(4) then actor:addParticles(Particles.new("shader_ring_rotating", 1, {rotation=-0.01, radius=1.1}, {type="stone", hide_center=1, xy={0, 0}}))
			else actor:addParticles(Particles.new("crystalline_focus", 1))
			end
		end,
		function(actor)
			if core.shader.active(4) then actor:addParticles(Particles.new("shader_ring_rotating", 1, {rotation=0, radius=1.1, img="lightningshield"}, {type="lightningshield"}))
			else actor:addParticles(Particles.new("tempest", 1))
			end
		end,
	},
	talents_types = {
		["spell/arcane"]={true, 0.3},
		["spell/aether"]={false, 0.3},
		["spell/fire"]={true, 0.3},
		["spell/earth"]={true, 0.3},
		["spell/water"]={true, 0.3},
		["spell/air"]={true, 0.3},
		["spell/phantasm"]={true, 0.3},
		["spell/temporal"]={false, 0.3},
		["spell/meta"]={false, 0.3},
		["spell/divination"]={true, 0.3},
		["spell/conveyance"]={true, 0.3},
		["spell/aegis"]={true, 0.3},
		["cunning/survival"]={false, -0.1},
	},
	unlockable_talents_types = {
		["spell/wildfire"]={false, 0.3, "mage_pyromancer"},
		["spell/ice"]={false, 0.3, "mage_cryomancer"},
		["spell/stone"]={false, 0.3, "mage_geomancer"},
		["spell/storm"]={false, 0.3, "mage_tempest"},
	},
	talents = {
		[ActorTalents.T_ARCANE_POWER] = 1,
		[ActorTalents.T_FLAME] = 1,
		[ActorTalents.T_LIGHTNING] = 1,
		[ActorTalents.T_PHASE_DOOR] = 1,
	},
	copy = {
		-- Mages start in angolwen
		class_start_check = function(self)
			if self.descriptor.world == "Maj'Eyal" and (self.descriptor.race == "Human" or self.descriptor.race == "Elf" or self.descriptor.race == "Halfling" or (self.descriptor.race == "Giant" and self.descriptor.subrace == "Ogre")) and not self._forbid_start_override then
				self.archmage_race_start_quest = self.starting_quest
				self.default_wilderness = {"zone-pop", "angolwen-portal"}
				self.starting_zone = "town-angolwen"
				self.starting_quest = "start-archmage"
				self.starting_intro = "archmage"
				self.faction = "angolwen"
				self:learnTalent(self.T_TELEPORT_ANGOLWEN, true, nil, {no_unlearn=true})
			end
			self:triggerHook{"BirthStartZone:archmage"}
		end,

		max_life = 90,
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="staff", name="elm staff", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="cloth", name="linen robe", autoreq=true, ego_chance=-1000},
		},
	},
	copy_add = {
		life_rating = -4,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Necromancer",
	display_name= " 死 灵 法 师 ",
	locked = function() return profile.mod.allow_build.mage_necromancer end,
	locked_desc = " 通 往 死 灵 法 师 的 道 路 是 极 其 可 怕 的， 与 死 亡 相 伴 随 并 沉 溺 在 他 们 的 黑 暗 知 识 之 中。 ",
	desc = {
		"    自 从 魔 法 大 爆 炸 以 来， 大 部 分 魔 法 受 到 质 疑， 自 远 古 以 来， 死 灵 法 师 的 黑 暗 魔 法 始 终 背 负 着 骂 名。 ",
		"    这 些 黑 暗 的 施 法 者 泯 灭 生 命、 扭 曲 死 亡、 召 唤 不 死 亡 灵 作 为 他 们 的 军 队 来 满 足 他 们 对 力 量 的 渴 求， 达 到 他 们 的 最 终 目 标： 永 垂 不 朽。 ",
		" 他 们 最 重 要 的 属 性： 魔 法 和 意 志。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +0 力 量， +0 敏 捷， +0 体 质 ",
		"#LIGHT_BLUE# * +5 魔 法， +3 意 志， +1 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# -3",
	},
	power_source = {arcane=true},
	stats = { mag=5, wil=3, cun=1, },
	talents_types = {
		["spell/conveyance"]={true, 0.2},
		["spell/divination"]={true, 0.2},
		["spell/necrotic-minions"]={true, 0.3},
		["spell/advanced-necrotic-minions"]={false, 0.3},
		["spell/shades"]={false, 0.3},
		["spell/necrosis"]={true, 0.3},
		["spell/nightfall"]={true, 0.3},
		["spell/grave"]={true, 0.3},
		["spell/animus"]={true, 0.3},
		["cunning/survival"]={true, -0.1},
	},
	unlockable_talents_types = {
		["spell/ice"]={false, 0.2, "mage_cryomancer"},
	},
	birth_example_particles = {
		"necrotic-aura",
		function(actor)
			if core.shader.active(4) then local x, y = actor:attachementSpot("back", true) actor:addParticles(Particles.new("shader_wings", 1, {x=x, y=y, infinite=1, img="darkwings"}))
			end
		end,
		function(actor)
			if core.shader.active(4) then 
				local p1 = actor:addParticles(Particles.new("shader_ring_rotating", 1, {rotation=0, radius=1.1, img="spinningwinds_black"}, {type="spinningwinds", ellipsoidalFactor={1,1}, time_factor=6000, noup=2.0}))
				p1.toback = true
				actor:addParticles(Particles.new("shader_ring_rotating", 1, {rotation=0, radius=1.1, img="spinningwinds_black"}, {type="spinningwinds", ellipsoidalFactor={1,1}, time_factor=6000, noup=1.0}))
			else actor:addParticles(Particles.new("ultrashield", 1, {rm=0, rM=0, gm=0, gM=0, bm=10, bM=100, am=70, aM=180, radius=0.4, density=60, life=14, instop=20}))
			end
		end,
	},
	talents = {
		[ActorTalents.T_NECROTIC_AURA] = 1,
		[ActorTalents.T_CREATE_MINIONS] = 1,
		[ActorTalents.T_ARCANE_EYE] = 1,
		[ActorTalents.T_INVOKE_DARKNESS] = 1,
		[ActorTalents.T_BLURRED_MORTALITY] = 1,
	},
	copy = {
		soul = 1,
		max_life = 90,
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="staff", name="elm staff", autoreq=true, ego_chance=-1000},
--			{type="weapon", subtype="dagger", name="iron dagger", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="cloth", name="linen robe", autoreq=true, ego_chance=-1000},
		},
	},
	copy_add = {
		life_rating = -3,
	},
}
