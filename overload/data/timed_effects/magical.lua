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

local Stats = require "engine.interface.ActorStats"
local Particles = require "engine.Particles"
local Shader = require "engine.Shader"
local Entity = require "engine.Entity"
local Chat = require "engine.Chat"
local Map = require "engine.Map"
local Level = require "engine.Level"


---------- Item specific 
newEffect{
	name = "ITEM_NUMBING_DARKNESS", image = "effects/bane_blinded.png",
	desc = "Numbing Darkness",
	long_desc = function(self, eff) return ("目 标 失 去 希 望 ， 它 造 成 的 伤 害 减 少 %d%%。"):format(eff.reduce) end,
	type = "magical",
	subtype = { darkness=true,}, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10, reduce=5},
	on_gain = function(self, err) return "#Target# is weakened by the darkness!", "+Numbing Poison" end,
	on_lose = function(self, err) return "#Target# regains their energy.", "-Darkness" end,
	on_timeout = function(self, eff)

	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("numbed", eff.reduce)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("numbed", eff.tmpid)
	end,
}

-- Use a word other than disease because diseases are associated with damage
-- Add dummy power/dam parameters to try to stay in line with other diseases for subtype checks
newEffect{
	name = "ITEM_BLIGHT_ILLNESS", image = "talents/decrepitude_disease.png",
	desc = "Illness",
	long_desc = function(self, eff) return ("目 标 被 疾 病 感 染 ， 减 少 敏 捷 、 力 量 、 体 质 各 %d 点 ."):format(eff.reduce) end,
	type = "magical",
	subtype = {disease=true, blight=true},
	status = "detrimental",
	parameters = {reduce = 1, dam = 0, power = 0},
	on_gain = function(self, err) return "#Target# is afflicted by a crippling illness!" end,
	on_lose = function(self, err) return "#Target# is free from the illness." end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("inc_stats", {
			[Stats.STAT_DEX] = -eff.reduce,
			[Stats.STAT_STR] = -eff.reduce,
			[Stats.STAT_CON] = -eff.reduce,
		})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_stats", eff.tmpid)
	end,
}


newEffect{
	name = "ITEM_ACID_CORRODE", image = "talents/acidic_skin.png",
	desc = "Armor Corroded",
	long_desc = function(self, eff) return ("目 标 被 酸 液 覆 盖 ， 护 甲 减 少 %d%%（#RED#%d#LAST#）."):format(eff.pct*100 or 0, eff.reduce or 0) end,
	type = "magical",
	subtype = { acid=true, sunder=true },
	status = "detrimental",
	parameters = {pct = 0.3},
	on_gain = function(self, err) return "#Target#'s armor corrodes!" end,
	on_lose = function(self, err) return "#Target# is fully armored again." end,
	on_timeout = function(self, eff)
	end,
	activate = function(self, eff)
		local armor = self.combat_armor * eff.pct
		eff.reduce = armor
		self:effectTemporaryValue(eff, "combat_armor", -armor)
	end,
	deactivate = function(self, eff)

	end,
}

newEffect{
	name = "MANASURGE", image = "talents/rune__manasurge.png",
	desc = "Surging mana",
	long_desc = function(self, eff) return ("法 力 潮 汐 淹 没 目 标， 每 回 合 回 复 %0.2f 法 力 值。"):format(eff.power) end,
	type = "magical",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# starts to surge mana.", "+Manasurge" end,
	on_lose = function(self, err) return "#Target# stops surging mana.", "-Manasurge" end,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the mana
		local olddam = old_eff.power * old_eff.dur
		local newdam = new_eff.power * new_eff.dur
		local dur = math.ceil((old_eff.dur + new_eff.dur) / 2)
		old_eff.dur = dur
		old_eff.power = (olddam + newdam) / dur

		self:removeTemporaryValue("mana_regen", old_eff.tmpid)
		old_eff.tmpid = self:addTemporaryValue("mana_regen", old_eff.power)
		return old_eff
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("mana_regen", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("mana_regen", eff.tmpid)
	end,
}

newEffect{
	name = "MANA_OVERFLOW", image = "talents/aegis.png",
	desc = "Mana Overflow",
	long_desc = function(self, eff) return ("法 力 溢 出， 提 升 你 的 法 力 上 限 %d%% 。"):format(eff.power) end,
	type = "magical",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# starts to overflow mana.", "+Mana Overflow" end,
	on_lose = function(self, err) return "#Target# stops overflowing mana.", "-Mana Overflow" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("max_mana", eff.power * self:getMaxMana() / 100)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("max_mana", eff.tmpid)
	end,
}

newEffect{
	name = "STONED", image = "talents/stone_touch.png",
	desc = "Stoned",
	long_desc = function(self, eff) return "目 标 被 石 化， 易 于 被 击 碎， 但 提 高 物 理 抵 抗（ +20% ） 火 焰 抵 抗（ + 80% ） 和 闪 电 抵 抗（ + 50% ）。" end,
	type = "magical",
	subtype = { earth=true, stone=true, stun = true},
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# turns to stone!", "+Stoned" end,
	on_lose = function(self, err) return "#Target# is not stoned anymore.", "-Stoned" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("stoned", 1)
		eff.resistsid = self:addTemporaryValue("resists", {
			[DamageType.PHYSICAL]=20,
			[DamageType.FIRE]=80,
			[DamageType.LIGHTNING]=50,
		})
	end,
	on_timeout = function(self, eff)
		if eff.dur > 7 then eff.dur = 7 end -- instakilling players is dumb and this is still lethal at 7s
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("stoned", eff.tmpid)
		self:removeTemporaryValue("resists", eff.resistsid)
	end,
}

newEffect{
	name = "ARCANE_STORM", image = "talents/disruption_shield.png",
	desc = "Arcane Storm",
	long_desc = function(self, eff) return ("目 标 处 于 巨 大 奥 术 风 暴 的 中 心， 增 加 +%d%% 奥 术 抵 抗。"):format(eff.power) end,
	type = "magical",
	subtype = { arcane=true},
	status = "beneficial",
	parameters = {power=50},
	activate = function(self, eff)
		eff.resistsid = self:addTemporaryValue("resists", {
			[DamageType.ARCANE]=eff.power,
		})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.resistsid)
	end,
}

newEffect{
	name = "EARTHEN_BARRIER", image = "talents/earthen_barrier.png",
	desc = "Earthen Barrier",
	long_desc = function(self, eff) return ("减 少 物 理 伤 害 %d%% 。"):format(eff.power) end,
	type = "magical",
	subtype = { earth=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# hardens its skin.", "+Earthen barrier" end,
	on_lose = function(self, err) return "#Target#'s skin returns to normal.", "-Earthen barrier" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("stone_skin", 1, {density=4}))
		eff.tmpid = self:addTemporaryValue("resists", {[DamageType.PHYSICAL]=eff.power})
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("resists", eff.tmpid)
	end,
}

newEffect{
	name = "MOLTEN_SKIN", image = "talents/golem_molten_skin.png",
	desc = "Molten Skin",
	long_desc = function(self, eff) return ("减 少 火 焰 伤 害 %d%% 。"):format(eff.power) end,
	type = "magical",
	subtype = { fire=true, earth=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target#'s skin turns into molten lava.", "+Molten Skin" end,
	on_lose = function(self, err) return "#Target#'s skin returns to normal.", "-Molten Skin" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("wildfire", 1))
		eff.tmpid = self:addTemporaryValue("resists", {[DamageType.FIRE]=eff.power})
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("resists", eff.tmpid)
	end,
}

newEffect{
	name = "REFLECTIVE_SKIN", image = "talents/golem_reflective_skin.png",
	desc = "Reflective Skin",
	long_desc = function(self, eff) return ("反 射 %d%% 魔 法 伤 害。"):format(eff.power) end,
	type = "magical",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target#'s skin starts to shimmer.", "+Reflective Skin" end,
	on_lose = function(self, err) return "#Target#'s skin returns to normal.", "-Reflective Skin" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("reflect_damage", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("reflect_damage", eff.tmpid)
	end,
}

newEffect{
	name = "VIMSENSE", image = "talents/vimsense.png",
	desc = "Vimsense",
	long_desc = function(self, eff) return ("降 低 枯 萎 抵 抗 %d%% 。"):format(eff.power) end,
	type = "magical",
	subtype = { blight=true },
	status = "detrimental",
	parameters = { power=10 },
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("resists", {[DamageType.BLIGHT]=-eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.tmpid)
	end,
}

newEffect{
	name = "INVISIBILITY", image = "effects/invisibility.png",
	desc = "Invisibility",
	long_desc = function(self, eff) return ("提 升 / 获 得 隐 形 状 态（ %d 隐 形 等 级）。"):format(eff.power) end,
	type = "magical",
	subtype = { phantasm=true },
	status = "beneficial",
	parameters = { power=10, penalty=0, regen=false },
	on_gain = function(self, err) return "#Target# vanishes from sight.", "+Invis" end,
	on_lose = function(self, err) return "#Target# is no longer invisible.", "-Invis" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("invisible", eff.power)
		eff.penaltyid = self:addTemporaryValue("invisible_damage_penalty", eff.penalty)
		if eff.regen then
			eff.regenid = self:addTemporaryValue("no_life_regen", 1)
			eff.healid = self:addTemporaryValue("no_healing", 1)
		end
		if not self.shader then
			eff.set_shader = true
			self.shader = "invis_edge"
			self:removeAllMOs()
			game.level.map:updateMap(self.x, self.y)
		end
	end,
	deactivate = function(self, eff)
		if eff.set_shader then
			self.shader = nil
			self:removeAllMOs()
			game.level.map:updateMap(self.x, self.y)
		end
		self:removeTemporaryValue("invisible", eff.tmpid)
		self:removeTemporaryValue("invisible_damage_penalty", eff.penaltyid)
		if eff.regen then
			self:removeTemporaryValue("no_life_regen", eff.regenid)
			self:removeTemporaryValue("no_healing", eff.healid)
		end
		self:resetCanSeeCacheOf()
	end,
}

newEffect{
	name = "SENSE_HIDDEN", image = "talents/keen_senses.png",
	desc = "Sense Hidden",
	long_desc = function(self, eff) return ("提 升 / 获 得 侦 测 隐 形 或 者 潜 行 生 物（ %d 侦 测 等 级）"):format(eff.power) end,
	type = "magical",
	subtype = { sense=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target#'s eyes tingle." end,
	on_lose = function(self, err) return "#Target#'s eyes tingle no more." end,
	activate = function(self, eff)
		eff.invisid = self:addTemporaryValue("see_invisible", eff.power)
		eff.stealthid = self:addTemporaryValue("see_stealth", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("see_invisible", eff.invisid)
		self:removeTemporaryValue("see_stealth", eff.stealthid)
	end,
}

newEffect{
	name = "BANE_BLINDED", image = "effects/bane_blinded.png",
	desc = "Bane of Blindness",
	long_desc = function(self, eff) return ("目 标 被 致 盲， 不 能 看 到 任 何 东 西 并 每 回 合 受 到 %0.2f 暗 影 伤 害。"):format(eff.dam) end,
	type = "magical",
	subtype = { bane=true, blind=true },
	status = "detrimental",
	parameters = { dam=10},
	on_gain = function(self, err) return "#Target# loses sight!", "+Blind" end,
	on_lose = function(self, err) return "#Target# recovers sight.", "-Blind" end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.DARKNESS).projector(eff.src, self.x, self.y, DamageType.DARKNESS, eff.dam)
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("blind", 1)
		if game.level then
			self:resetCanSeeCache()
			if self.player then for uid, e in pairs(game.level.entities) do if e.x then game.level.map:updateMap(e.x, e.y) end end game.level.map.changed = true end
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("blind", eff.tmpid)
		if game.level then
			self:resetCanSeeCache()
			if self.player then for uid, e in pairs(game.level.entities) do if e.x then game.level.map:updateMap(e.x, e.y) end end game.level.map.changed = true end
		end
	end,
}

newEffect{
	name = "BANE_CONFUSED", image = "effects/bane_confused.png",
	desc = "Bane of Confusion",
	long_desc = function(self, eff) return ("目 标 处 于 混 乱， 随 机 行 动 ( %d%% 几 率 )， 不 能 完 成 复 杂 的 动 作， 每 回 合 受 到 %0.2f 暗 影 伤 害。"):format(eff.power, eff.dam) end,
	type = "magical",
	subtype = { bane=true, confusion=true },
	status = "detrimental",
	parameters = { power=50, dam=10 },
	on_gain = function(self, err) return "#Target# wanders around!.", "+Confused" end,
	on_lose = function(self, err) return "#Target# seems more focused.", "-Confused" end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.DARKNESS).projector(eff.src, self.x, self.y, DamageType.DARKNESS, eff.dam)
	end,
	activate = function(self, eff)
		eff.power = math.floor(math.max(eff.power - (self:attr("confusion_immune") or 0) * 100, 10))
		eff.power = util.bound(eff.power, 0, 50)
		eff.tmpid = self:addTemporaryValue("confused", eff.power)
		if eff.power <= 0 then eff.dur = 0 end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("confused", eff.tmpid)
	end,
}

newEffect{
	name = "SUPERCHARGE_GOLEM", image = "talents/supercharge_golem.png",
	desc = "Supercharge Golem",
	long_desc = function(self, eff) return ("目 标 被 超 载， 增 加 %0.2f 生 命 回 复 并 增 加 20％ 伤 害。"):format(eff.regen) end,
	type = "magical",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { regen=10 },
	on_gain = function(self, err) return "#Target# is overloaded with power.", "+Supercharge" end,
	on_lose = function(self, err) return "#Target# seems less dangerous.", "-Supercharge" end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("inc_damage", {all=25})
		eff.lid = self:addTemporaryValue("life_regen", eff.regen)
		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1.5, y=-0.3, img="healarcane"}, {type="healing", time_factor=4000, noup=2.0, beamColor1={0x8e/255, 0x2f/255, 0xbb/255, 1}, beamColor2={0xe7/255, 0x39/255, 0xde/255, 1}, circleColor={0,0,0,0}, beamsCount=5}))
			eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1.5, y=-0.3, img="healarcane"}, {type="healing", time_factor=4000, noup=1.0, beamColor1={0x8e/255, 0x2f/255, 0xbb/255, 1}, beamColor2={0xe7/255, 0x39/255, 0xde/255, 1}, circleColor={0,0,0,0}, beamsCount=5}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
		self:removeTemporaryValue("inc_damage", eff.pid)
		self:removeTemporaryValue("life_regen", eff.lid)
	end,
}

newEffect{
	name = "POWER_OVERLOAD",
	desc = "Power Overload",
	long_desc = function(self, eff) return ("目 标 辐 射 出 超 强 的 力 量， 提 升 %d%% 所 有 伤 害。"):format(eff.power) end,
	type = "magical",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is overloaded with power.", "+Overload" end,
	on_lose = function(self, err) return "#Target# seems less dangerous.", "-Overload" end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("inc_damage", {all=eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.pid)
	end,
}

newEffect{
	name = "LIFE_TAP", image = "talents/life_tap.png",
	desc = "Life Tap",
	long_desc = function(self, eff) return ("目 标 发 掘 生 命 中 的 隐 藏 力 量， 提 升 造 成 的 伤 害 %d%% 。"):format(eff.power) end,
	type = "magical",
	subtype = { blight=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is overloaded with power.", "+Life Tap" end,
	on_lose = function(self, err) return "#Target# seems less dangerous.", "-Life Tap" end,
	activate = function(self, eff)
		eff.pid = self:addTemporaryValue("inc_damage", {all=eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.pid)
	end,
}

newEffect{
	name = "ARCANE_EYE", image = "talents/arcane_eye.png",
	desc = "Arcane Eye",
	long_desc = function(self, eff) return ("你 召 唤 奥 术 之 眼 侦 查 %d 码 区 域。"):format(eff.radius) end,
	type = "magical",
	subtype = { sense=true },
	status = "beneficial",
	cancel_on_level_change = true,
	parameters = { range=10, actor=1, object=0, trap=0 },
	activate = function(self, eff)
		game.level.map.changed = true
		eff.particle = Particles.new("image", 1, {image="shockbolt/npc/arcane_eye", size=64})
		eff.particle.x = eff.x
		eff.particle.y = eff.y
		eff.particle.always_seen = true
		game.level.map:addParticleEmitter(eff.particle)
	end,
	on_timeout = function(self, eff)
		-- Track an actor if it's not dead
		if eff.track and not eff.track.dead then
			eff.x = eff.track.x
			eff.y = eff.track.y
			eff.particle.x = eff.x
			eff.particle.y = eff.y
			game.level.map.changed = true
		end
	end,
	deactivate = function(self, eff)
		game.level.map:removeParticleEmitter(eff.particle)
		game.level.map.changed = true
	end,
}

newEffect{
	name = "ARCANE_EYE_SEEN", image = "talents/arcane_eye.png",
	desc = "Seen by Arcane Eye",
	long_desc = function(self, eff) return "奥 术 之 眼 发 现 了 该 生 物。" end,
	type = "magical",
	subtype = { sense=true },
	no_ct_effect = true,
	status = "detrimental",
	parameters = {},
	activate = function(self, eff)
		if eff.true_seeing then
			eff.inv = self:addTemporaryValue("invisible", -(self:attr("invisible") or 0))
			eff.stealth = self:addTemporaryValue("stealth", -((self:attr("stealth") or 0) + (self:attr("inc_stealth") or 0)))
		end
	end,
	deactivate = function(self, eff)
		if eff.inv then self:removeTemporaryValue("invisible", eff.inv) end
		if eff.stealth then self:removeTemporaryValue("stealth", eff.stealth) end
	end,
}

newEffect{
	name = "ALL_STAT", image = "effects/all_stat.png",
	desc = "All stats increase",
	long_desc = function(self, eff) return ("目 标 所 有 基 础 属 性 提 升 %d 。"):format(eff.power) end,
	type = "magical",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { power=1 },
	activate = function(self, eff)
		eff.stat = self:addTemporaryValue("inc_stats",
		{
			[Stats.STAT_STR] = eff.power,
			[Stats.STAT_DEX] = eff.power,
			[Stats.STAT_MAG] = eff.power,
			[Stats.STAT_WIL] = eff.power,
			[Stats.STAT_CUN] = eff.power,
			[Stats.STAT_CON] = eff.power,
		})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_stats", eff.stat)
	end,
}

newEffect{
	name = "DISPLACEMENT_SHIELD", image = "talents/displacement_shield.png",
	desc = "Displacement Shield",
	long_desc = function(self, eff) return ("目 标 被 一 层 扭 曲 空 间 包 围， %d%% 几 率 偏 转 伤 害 至 另 一 目 标（ %s ）。 吸 收 %d/%d 伤 害。"):format(eff.chance, eff.target and eff.target.name or "unknown", self.displacement_shield, eff.power) end,
	type = "magical",
	subtype = { teleport=true, shield=true },
	status = "beneficial",
	parameters = { power=10, target=nil, chance=25 },
	on_gain = function(self, err) return "The very fabric of space alters around #target#.", "+Displacement Shield" end,
	on_lose = function(self, err) return "The fabric of space around #target# stabilizes to normal.", "-Displacement Shield" end,
	on_aegis = function(self, eff, aegis)
		self.displacement_shield = self.displacement_shield + eff.power * aegis / 100
		if core.shader.active(4) then
			self:removeParticles(eff.particle)
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.3, img="runicshield"}, {type="runicshield", shieldIntensity=0.14, ellipsoidalFactor=1.2, time_factor=4000, bubbleColor={0.5, 1, 0.2, 1.0}, auraColor={0.4, 1, 0.2, 1}}))
		end		
	end,
	damage_feedback = function(self, eff, src, value)
		if eff.particle and eff.particle._shader and eff.particle._shader.shad and src and src.x and src.y then
			local r = -rng.float(0.2, 0.4)
			local a = math.atan2(src.y - self.y, src.x - self.x)
			eff.particle._shader:setUniform("impact", {math.cos(a) * r, math.sin(a) * r})
			eff.particle._shader:setUniform("impact_tick", core.game.getTime())
		end
	end,
	activate = function(self, eff)
		if self:attr("shield_factor") then eff.power = eff.power * (100 + self:attr("shield_factor")) / 100 end
		if self:attr("shield_dur") then eff.dur = eff.dur + self:attr("shield_dur") end
		self.displacement_shield = eff.power
		self.displacement_shield_max = eff.power
		self.displacement_shield_chance = eff.chance
		--- Warning there can be only one time shield active at once for an actor
		self.displacement_shield_target = eff.target
		if core.shader.active(4) then
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {img="shield6"}, {type="shield", shieldIntensity=0.08, horizontalScrollingSpeed=-1.2, time_factor=6000, color={0.5, 1, 0.2}}))
		else
			eff.particle = self:addParticles(Particles.new("displacement_shield", 1))
		end
	end,
	on_timeout = function(self, eff)
		if not eff.target or eff.target.dead then
			eff.target = nil
			return true
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self.displacement_shield = nil
		self.displacement_shield_max = nil
		self.displacement_shield_chance = nil
		self.displacement_shield_target = nil
	end,
}

newEffect{
	name = "DAMAGE_SHIELD", image = "talents/barrier.png",
	desc = "Damage Shield",
	long_desc = function(self, eff) return ("目 标 被 一 层 魔 法 护 盾 包 围， 吸 收 %d/%d 伤 害。"):format(self.damage_shield_absorb, eff.power) end,
	type = "magical",
	subtype = { arcane=true, shield=true },
	status = "beneficial",
	parameters = { power=100 },
	on_gain = function(self, err) return "A shield forms around #target#.", "+Shield" end,
	on_lose = function(self, err) return "The shield around #target# crumbles.", "-Shield" end,
	on_aegis = function(self, eff, aegis)
		self.damage_shield_absorb = self.damage_shield_absorb + eff.power * aegis / 100
		if core.shader.active(4) then
			self:removeParticles(eff.particle)
			local bc = {0.4, 0.7, 1.0, 1.0}
			local ac = {0x21/255, 0x9f/255, 0xff/255, 1}
			if eff.color then
				bc = table.clone(eff.color) bc[4] = 1
				ac = table.clone(eff.color) ac[4] = 1
			end
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.3, img="runicshield"}, {type="runicshield", shieldIntensity=0.14, ellipsoidalFactor=1.2, time_factor=5000, bubbleColor=bc, auraColor=ac}))
		end		
	end,
	damage_feedback = function(self, eff, src, value)
		if eff.particle and eff.particle._shader and eff.particle._shader.shad and src and src.x and src.y then
			local r = -rng.float(0.2, 0.4)
			local a = math.atan2(src.y - self.y, src.x - self.x)
			eff.particle._shader:setUniform("impact", {math.cos(a) * r, math.sin(a) * r})
			eff.particle._shader:setUniform("impact_tick", core.game.getTime())
		end
	end,
	activate = function(self, eff)
		self:removeEffect(self.EFF_PSI_DAMAGE_SHIELD)
		if self:attr("shield_factor") then eff.power = eff.power * (100 + self:attr("shield_factor")) / 100 end
		if self:attr("shield_dur") then eff.dur = eff.dur + self:attr("shield_dur") end
		eff.tmpid = self:addTemporaryValue("damage_shield", eff.power)
		if eff.reflect then eff.refid = self:addTemporaryValue("damage_shield_reflect", eff.reflect) end
		--- Warning there can be only one time shield active at once for an actor
		self.damage_shield_absorb = eff.power
		self.damage_shield_absorb_max = eff.power
		if core.shader.active(4) then
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, nil, {type="shield", shieldIntensity=0.2, color=eff.color or {0.4, 0.7, 1.0}}))
		else
			eff.particle = self:addParticles(Particles.new("damage_shield", 1))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:removeTemporaryValue("damage_shield", eff.tmpid)
		if eff.refid then self:removeTemporaryValue("damage_shield_reflect", eff.refid) end
		self.damage_shield_absorb = nil
		self.damage_shield_absorb_max = nil
	end,
}

newEffect{
	name = "MARTYRDOM", image = "talents/martyrdom.png",
	desc = "Martyrdom",
	long_desc = function(self, eff) return ("目 标 造 成 伤 害 的 同 时 对 自 身 造 成 %d%% 伤 害。"):format(eff.power) end,
	type = "magical",
	subtype = { light=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is a martyr.", "+Martyr" end,
	on_lose = function(self, err) return "#Target# is no longer influenced by martyrdom.", "-Martyr" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("martyrdom", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("martyrdom", eff.tmpid)
	end,
}

-- This only exists to mark a timer for Radiance being consumed
newEffect{
	name = "RADIANCE_DIM", image = "talents/curse_of_vulnerability.png",
	desc = "Radiance Lost",
	long_desc = function(self, eff) return ("你 身 边 的 光 亮 变 得 暗 淡 了。"):format() end,
	type = "other",
	subtype = { radiance=true },
	parameters = { },
	on_gain = function(self, err) return "#Target#'s aura dims.", "+Dim" end,
	on_lose = function(self, err) return "#Target# shines with renewed light.", "-Dim" end,
	activate = function(self, eff)
		self:callTalent(self.T_SEARING_SIGHT, "updateParticle")
	end,
	deactivate = function(self, eff)
		self:callTalent(self.T_SEARING_SIGHT, "updateParticle")
	end,
}

newEffect{
	name = "CURSE_VULNERABILITY", image = "talents/curse_of_vulnerability.png",
	desc = "Curse of Vulnerability",
	long_desc = function(self, eff) return ("目 标 被 诅 咒， 所 有 抵 抗 降 低 %d%% 。"):format(eff.power) end,
	type = "magical",
	subtype = { curse=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is cursed.", "+Curse" end,
	on_lose = function(self, err) return "#Target# is no longer cursed.", "-Curse" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("resists", {
			all = -eff.power,
		})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.tmpid)
	end,
}

newEffect{
	name = "CURSE_IMPOTENCE", image = "talents/curse_of_impotence.png",
	desc = "Curse of Impotence",
	long_desc = function(self, eff) return ("目 标 被 诅 咒， 所 有 伤 害 降 低 %d%% 。"):format(eff.power) end,
	type = "magical",
	subtype = { curse=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is cursed.", "+Curse" end,
	on_lose = function(self, err) return "#Target# is no longer cursed.", "-Curse" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("inc_damage", {
			all = -eff.power,
		})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.tmpid)
	end,
}

newEffect{
	name = "CURSE_DEFENSELESSNESS", image = "talents/curse_of_defenselessness.png",
	desc = "Curse of Defenselessness",
	long_desc = function(self, eff) return ("目 标 被 诅 咒， 降 低 闪 避 和 所 有 豁 免 %d 。"):format(eff.power) end,
	type = "magical",
	subtype = { curse=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is cursed.", "+Curse" end,
	on_lose = function(self, err) return "#Target# is no longer cursed.", "-Curse" end,
	activate = function(self, eff)
		eff.def = self:addTemporaryValue("combat_def", -eff.power)
		eff.mental = self:addTemporaryValue("combat_mentalresist", -eff.power)
		eff.spell = self:addTemporaryValue("combat_spellresist", -eff.power)
		eff.physical = self:addTemporaryValue("combat_physresist", -eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_def", eff.def)
		self:removeTemporaryValue("combat_mentalresist", eff.mental)
		self:removeTemporaryValue("combat_spellresist", eff.spell)
		self:removeTemporaryValue("combat_physresist", eff.physical)
	end,
}

newEffect{
	name = "CURSE_DEATH", image = "talents/curse_of_death.png",
	desc = "Curse of Death",
	long_desc = function(self, eff) return ("目 标 被 诅 咒， 每 回 合 受 到 %0.2f 暗 影 伤 害 并 停 止 自 然 生 命 回 复。"):format(eff.dam) end,
	type = "magical",
	subtype = { curse=true, darkness=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is cursed.", "+Curse" end,
	on_lose = function(self, err) return "#Target# is no longer cursed.", "-Curse" end,
	-- Damage each turn
	on_timeout = function(self, eff)
		DamageType:get(DamageType.DARKNESS).projector(eff.src, self.x, self.y, DamageType.DARKNESS, eff.dam)
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("no_life_regen", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("no_life_regen", eff.tmpid)
	end,
}

newEffect{
	name = "CURSE_HATE", image = "talents/curse_of_the_meek.png",
	desc = "Curse of Hate",
	long_desc = function(self, eff) return ("目 标 被 诅 咒， 强 制 所 有 5 码 内 目 标 攻 击 他。") end,
	type = "magical",
	subtype = { curse=true },
	status = "detrimental",
	parameters = { },
	on_gain = function(self, err) return "#Target# is cursed.", "+Curse" end,
	on_lose = function(self, err) return "#Target# is no longer cursed.", "-Curse" end,
	on_timeout = function(self, eff)
		if self.dead or not self.x then return end
		local tg = {type="ball", range=0, radius=5, friendlyfire=false}
		self:project(tg, self.x, self.y, function(tx, ty)
			local a = game.level.map(tx, ty, Map.ACTOR)
			if a and not a.dead and a:reactionToward(self) < 0 then a:setTarget(self) end
		end)
	end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "BLOODLUST", image = "talents/bloodlust.png",
	desc = "Bloodlust",
	long_desc = function(self, eff) return ("目 标 进 入 魔 法 狂 暴 状 态， 提 升 法 术 强 度 %d 。"):format(eff.power) end,
	type = "magical",
	subtype = { frenzy=true },
	status = "beneficial",
	parameters = { power=1 },
	on_timeout = function(self, eff)
		if eff.refresh_turn + 10 < game.turn then -- Decay only if it's not refreshed
			eff.power = math.max(0, eff.power*(100-eff.decay)/100)
		end
	end,
	on_merge = function(self, old_eff, new_eff)
		local dur = new_eff.dur
		local max_turn, maxDur = self:callTalent(self.T_BLOODLUST, "getParams")
		local maxSP = max_turn * 6 -- max total sp
		local power = new_eff.power

		if old_eff.last_turn + 10 <= game.turn then -- clear limits every game turn (10 ticks)
			old_eff.used_this_turn = 0
			old_eff.last_turn = game.turn
		end
		if old_eff.used_this_turn >= max_turn then
			dur = 0
			power = 0
		else
			power = math.min(max_turn-old_eff.used_this_turn, power)
			old_eff.power = math.min(old_eff.power + power, maxSP)
			old_eff.used_this_turn = old_eff.used_this_turn + power
		end

		old_eff.decay = 100/maxDur
		old_eff.dur = math.min(old_eff.dur + dur, maxDur)
		old_eff.refresh_turn = game.turn
		return old_eff
	end,
	activate = function(self, eff)
		eff.last_turn = game.turn
		local SPbonus, maxDur = self:callTalent(self.T_BLOODLUST, "getParams")
		eff.used_this_turn = eff.power
		eff.decay = 100/maxDur
		eff.refresh_turn = game.turn
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ACID_SPLASH", image = "talents/acidic_skin.png",
	desc = "Acid Splash",
	long_desc = function(self, eff) return ("目 标 被 酸 液 飞 溅， 造 成 每 回 合 %0.2f 酸 性 伤 害。 降 低 %d 护 甲 值 和 %d 伤 害。"):format(eff.dam, eff.armor or 0, eff.atk) end,
	type = "magical",
	subtype = { acid=true, sunder=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is covered in acid!" end,
	on_lose = function(self, err) return "#Target# is free from the acid." end,
	-- Damage each turn
	on_timeout = function(self, eff)
		DamageType:get(DamageType.ACID).projector(eff.src, self.x, self.y, DamageType.ACID, eff.dam)
	end,
	activate = function(self, eff)
		eff.atkid = self:addTemporaryValue("combat_atk", -eff.atk)
		if eff.armor then eff.armorid = self:addTemporaryValue("combat_armor", -eff.armor) end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_atk", eff.atkid)
		if eff.armorid then self:removeTemporaryValue("combat_armor", eff.armorid) end
	end,
}

newEffect{
	name = "BLOOD_FURY", image = "talents/blood_fury.png",
	desc = "Bloodfury",
	long_desc = function(self, eff) return ("目 标 的 酸 性 和 枯 萎 伤 害 增 加 %d%% 。"):format(eff.power) end,
	type = "magical",
	subtype = { frenzy=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("inc_damage", {[DamageType.BLIGHT] = eff.power, [DamageType.ACID] = eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.tmpid)
	end,
}

newEffect{
	name = "PHOENIX_EGG", image = "effects/phoenix_egg.png",
	desc = "Reviving Phoenix",
	long_desc = function(self, eff) return "目 标 重 生。" end,
	type = "magical",
	subtype = { fire=true },
	status = "beneficial",
	parameters = { life_regen = 25, mana_regen = -9.75, never_move = 1, silence = 1 },
	on_gain = function(self, err) return "#Target# is consumed in a burst of flame. All that remains is a fiery egg.", "+Phoenix" end,
	on_lose = function(self, err) return "#Target# bursts out from the egg.", "-Phoenix" end,
	activate = function(self, eff)
		self.display = "O"						             -- change the display of the phoenix to an egg, maybe later make it a fiery orb image
		eff.old_image = self.image
		self.image = "object/egg_dragons_egg_06_64.png"
		self:removeAllMOs()
		eff.life_regen = self:addTemporaryValue("life_regen", 25)	         -- gives it a 10 life regen, should I increase this?
		eff.mana_regen = self:addTemporaryValue("mana_regen", -9.75)          -- makes the mana regen realistic
		eff.never_move = self:addTemporaryValue("never_move", 1)	 -- egg form should not move
		eff.silence = self:addTemporaryValue("silence", 1)		          -- egg should not cast spells
		eff.combat = self.combat
		self.combat = nil						               -- egg shouldn't melee
		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1.5, y=-0.3, img="healarcane"}, {type="healing", time_factor=2000, noup=2.0, beamColor1={0xff/255, 0xd1/255, 0x22/255, 1}, beamColor2={0xfd/255, 0x94/255, 0x3f/255, 1}, circleColor={0,0,0,0}, beamsCount=12}))
			eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1.5, y=-0.3, img="healarcane"}, {type="healing", time_factor=2000, noup=1.0, beamColor1={0xff/255, 0xd1/255, 0x22/255, 1}, beamColor2={0xfd/255, 0x94/255, 0x3f/255, 1}, circleColor={0,0,0,0}, beamsCount=12}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
		self.display = "B"
		self.image = eff.old_image
		self:removeAllMOs()
		self:removeTemporaryValue("life_regen", eff.life_regen)
		self:removeTemporaryValue("mana_regen", eff.mana_regen)
		self:removeTemporaryValue("never_move", eff.never_move)
		self:removeTemporaryValue("silence", eff.silence)
		self.combat = eff.combat
	end,
}

newEffect{
	name = "HURRICANE", image = "effects/hurricane.png",
	desc = "Hurricane",
	long_desc = function(self, eff) return ("目 标 处 于 闪 电 飓 风 中 心， 使 自 身 和 周 围 目 标 每 回 合 受 到 %0.2f ～ %0.2f 闪 电 伤 害。"):format(eff.dam / 3, eff.dam) end,
	type = "magical",
	subtype = { lightning=true },
	status = "detrimental",
	parameters = { dam=10, radius=2 },
	on_gain = function(self, err) return "#Target# is caught inside a Hurricane.", "+Hurricane" end,
	on_lose = function(self, err) return "The Hurricane around #Target# dissipates.", "-Hurricane" end,
	on_timeout = function(self, eff)
		local tg = {type="ball", x=self.x, y=self.y, radius=eff.radius, selffire=false}
		local dam = eff.dam
		eff.src:project(tg, self.x, self.y, DamageType.LIGHTNING, rng.avg(dam / 3, dam, 3))

		if core.shader.active() then game.level.map:particleEmitter(self.x, self.y, tg.radius, "ball_lightning_beam", {radius=tg.radius}, {type="lightning"})
		else game.level.map:particleEmitter(self.x, self.y, tg.radius, "ball_lightning_beam", {radius=tg.radius}) end

		game:playSoundNear(self, "talents/lightning")
	end,
}

newEffect{
	name = "RECALL", image = "effects/recall.png",
	desc = "Recalling",
	long_desc = function(self, eff) return "目 标 等 待 被 召 回 至 世 界 地 图。" end,
	type = "magical",
	subtype = { unknown=true },
	status = "beneficial",
	cancel_on_level_change = true,
	parameters = { },
	activate = function(self, eff)
		eff.leveid = game.zone.short_name.."-"..game.level.level
	end,
	deactivate = function(self, eff)
		if (eff.allow_override or (self:canBe("worldport") and not self:attr("never_move"))) and eff.dur <= 0 then
			game:onTickEnd(function()
				if eff.leveid == game.zone.short_name.."-"..game.level.level and game.player.can_change_zone then
					game.logPlayer(self, "You are yanked out of this place!")
					game:changeLevel(1, eff.where or game.player.last_wilderness)
				end
			end)
		else
			game.logPlayer(self, "Space restabilizes around you.")
		end
	end,
}

newEffect{
	name = "TELEPORT_ANGOLWEN", image = "talents/teleport_angolwen.png",
	desc = "Teleport: Angolwen",
	long_desc = function(self, eff) return "目 标 等 待 被 传 送 至 安 格 利 文。" end,
	type = "magical",
	subtype = { teleport=true },
	status = "beneficial",
	cancel_on_level_change = true,
	parameters = { },
	activate = function(self, eff)
		eff.leveid = game.zone.short_name.."-"..game.level.level
	end,
	deactivate = function(self, eff)
		local seen = false
		-- Check for visible monsters, only see LOS actors, so telepathy wont prevent it
		core.fov.calc_circle(self.x, self.y, game.level.map.w, game.level.map.h, 20, function(_, x, y) return game.level.map:opaque(x, y) end, function(_, x, y)
			local actor = game.level.map(x, y, game.level.map.ACTOR)
			if actor and actor ~= self then seen = true end
		end, nil)
		if seen then
			game.log("There are creatures that could be watching you; you cannot take the risk of teleporting to Angolwen.")
			return
		end

		if self:canBe("worldport") and not self:attr("never_move") and eff.dur <= 0 then
			game:onTickEnd(function()
				if eff.leveid == game.zone.short_name.."-"..game.level.level and game.player.can_change_zone then
					game.logPlayer(self, "You are yanked out of this place!")
					game:changeLevel(1, "town-angolwen")
				end
			end)
		else
			game.logPlayer(self, "Space restabilizes around you.")
		end
	end,
}

newEffect{
	name = "TELEPORT_POINT_ZERO", image = "talents/teleport_point_zero.png",
	desc = "Timeport: Point Zero",
	long_desc = function(self, eff) return "目 标 等 待 被 传 送 回 零 点 圣 域。" end,
	type = "magical",
	subtype = { timeport=true },
	status = "beneficial",
	cancel_on_level_change = true,
	parameters = { },
	activate = function(self, eff)
		eff.leveid = game.zone.short_name.."-"..game.level.level
	end,
	deactivate = function(self, eff)
		local seen = false
		-- Check for visible monsters, only see LOS actors, so telepathy wont prevent it
		core.fov.calc_circle(self.x, self.y, game.level.map.w, game.level.map.h, 20, function(_, x, y) return game.level.map:opaque(x, y) end, function(_, x, y)
			local actor = game.level.map(x, y, game.level.map.ACTOR)
			if actor and actor ~= self then seen = true end
		end, nil)
		if seen then
			game.log("There are creatures that could be watching you; you cannot take the risk of timeporting to Point Zero.")
			return
		end

		if self:canBe("worldport") and not self:attr("never_move") and eff.dur <= 0 then
			game:onTickEnd(function()
				if eff.leveid == game.zone.short_name.."-"..game.level.level and game.player.can_change_zone then
					game.logPlayer(self, "You are yanked out of this time!")
					game:changeLevel(1, "town-point-zero")
				end
			end)
		else
			game.logPlayer(self, "Time restabilizes around you.")
		end
	end,
}

newEffect{
	name = "PREMONITION_SHIELD", image = "talents/premonition.png",
	desc = "Premonition Shield",
	long_desc = function(self, eff) return ("降 低 受 到 的 %s 伤 害 %d%% 。"):format(DamageType:get(eff.damtype).name, eff.resist) end,
	type = "magical",
	subtype = { sense=true },
	status = "beneficial",
	parameters = { },
	on_gain = function(self, err) return "#Target# casts a protective shield just in time!", "+Premonition Shield" end,
	on_lose = function(self, err) return "The protective shield of #Target# disappears.", "-Premonition Shield" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("resists", {[eff.damtype]=eff.resist})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.tmpid)
	end,
}

newEffect{
	name = "CORROSIVE_WORM", image = "talents/corrosive_worm.png",
	desc = "Corrosive Worm",
	long_desc = function(self, eff) return ("目 标 被 感 染 腐 蚀 蠕 虫 造 成 每 回 合 %0.2f 酸 性 伤 害。"):format(eff.dam) end,
	type = "magical",
	subtype = { acid=true },
	status = "detrimental",
	parameters = { dam=1, explosion=10 },
	on_gain = function(self, err) return "#Target# is infected by a corrosive worm.", "+Corrosive Worm" end,
	on_lose = function(self, err) return "#Target# is free from the corrosive worm.", "-Corrosive Worm" end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.ACID).projector(eff.src or self, self.x, self.y, DamageType.ACID, eff.dam)
	end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("circle", 1, {base_rot=0, oversize=0.7, a=255, appear=8, speed=0, img="blight_worms", radius=0}))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "WRAITHFORM", image = "talents/wraithform.png",
	desc = "Wraithform",
	long_desc = function(self, eff) return ("进 入 幽 灵 形 态， 可 以 穿 墙（ 但 不 能 穿 过 其 他 障 碍 物）， 获 得 %d 闪 避 和 %d 护 甲 值。"):format(eff.def, eff.armor) end,
	type = "magical",
	subtype = { darkness=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# turns into a wraith.", "+Wraithform" end,
	on_lose = function(self, err) return "#Target# returns to normal.", "-Wraithform" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("can_pass", {pass_wall=20})
		eff.defid = self:addTemporaryValue("combat_def", eff.def)
		eff.armid = self:addTemporaryValue("combat_armor", eff.armor)
		if not self.shader then
			eff.set_shader = true
			self.shader = "moving_transparency"
			self.shader_args = { a_min=0.3, a_max=0.8, time_factor = 3000 }
			self:removeAllMOs()
			game.level.map:updateMap(self.x, self.y)
		end
	end,
	deactivate = function(self, eff)
		if eff.set_shader then
			self.shader = nil
			self:removeAllMOs()
			game.level.map:updateMap(self.x, self.y)
		end
		self:removeTemporaryValue("can_pass", eff.tmpid)
		self:removeTemporaryValue("combat_def", eff.defid)
		self:removeTemporaryValue("combat_armor", eff.armid)
		if not self:canMove(self.x, self.y, true) then
			self:teleportRandom(self.x, self.y, 50)
		end
	end,
}

newEffect{
	name = "EMPOWERED_HEALING", image = "effects/empowered_healing.png",
	desc = "Empowered Healing",
	long_desc = function(self, eff) return ("提 升 目 标 受 到 的 所 有 治 疗 效 果 %d%% 。"):format(eff.power * 100) end,
	type = "magical",
	subtype = { light=true },
	status = "beneficial",
	parameters = { power = 0.1 },
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("healing_factor", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("healing_factor", eff.tmpid)
	end,
}

newEffect{
	name = "PROVIDENCE", image = "talents/providence.png",
	desc = "Providence",
	long_desc = function(self, eff) return ("目 标 受 到 保 护 并 且 生 命 回 复 增 加 %d 。"):format(eff.power) end,
	type = "magical",
	subtype = { light=true, shield=true },
	status = "beneficial",
	parameters = {},
	on_timeout = function(self, eff)
		local effs = {}
		-- Go through all spell effects
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.status == "detrimental" and e.type ~= "other" then
				effs[#effs+1] = {"effect", eff_id}
			end
		end

		if #effs > 0 then
			local eff = rng.tableRemove(effs)
			if eff[1] == "effect" then
				self:removeEffect(eff[2])
			end
		end
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("life_regen", eff.power)
		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1.5, y=-0.3, img="healcelestial"}, {type="healing", time_factor=4000, noup=2.0, beamColor1={0xd8/255, 0xff/255, 0x21/255, 1}, beamColor2={0xf7/255, 0xff/255, 0x9e/255, 1}, circleColor={0,0,0,0}, beamsCount=5}))
			eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1.5, y=-0.3, img="healcelestial"}, {type="healing", time_factor=4000, noup=1.0, beamColor1={0xd8/255, 0xff/255, 0x21/255, 1}, beamColor2={0xf7/255, 0xff/255, 0x9e/255, 1}, circleColor={0,0,0,0}, beamsCount=5}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
		self:removeTemporaryValue("life_regen", eff.tmpid)
	end,
}

newEffect{
	name = "TOTALITY", image = "talents/totality.png",
	desc = "Totality",
	long_desc = function(self, eff) return ("目 标 的 光 系 和 黑 暗 法 术 穿 透 增 加 %d%% 。"):format(eff.power) end,
	type = "magical",
	subtype = { darkness=true, light=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		eff.penet = self:addTemporaryValue("resists_pen", {
			[DamageType.DARKNESS] = eff.power,
			[DamageType.LIGHT] = eff.power,
		})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists_pen", eff.penet)
	end,
}

-- Circles
newEffect{
	name = "SANCTITY", image = "talents/circle_of_sanctity.png",
	desc = "Sanctity",
	long_desc = function(self, eff) return ("目 标 免 疫 沉 默。") end,
	type = "magical",
	subtype = { circle=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		eff.silence = self:addTemporaryValue("silence_immune", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("silence_immune", eff.silence)
	end,
}

newEffect{
	name = "SHIFTING_SHADOWS", image = "talents/circle_of_shifting_shadows.png",
	desc = "Shifting Shadows",
	long_desc = function(self, eff) return ("目 标 闪 避 增 加 %d 。"):format(eff.power) end,
	type = "magical",
	subtype = { circle=true, darkness=true },
	status = "beneficial",
	parameters = {power = 1},
	activate = function(self, eff)
		eff.defense = self:addTemporaryValue("combat_def", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_def", eff.defense)
	end,
}

newEffect{
	name = "BLAZING_LIGHT", image = "talents/circle_of_blazing_light.png",
	desc = "Blazing Light",
	long_desc = function(self, eff) return ("目 标 每 回 合 获 得 %d 正 能 量。"):format(eff.power) end,
	type = "magical",
	subtype = { circle=true, light=true },
	status = "beneficial",
	parameters = {power = 1},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "positive_regen_ref", -eff.power)
		self:effectTemporaryValue(eff, "positive_at_rest_disable", 1)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "WARDING", image = "talents/circle_of_warding.png",
	desc = "Warding",
	long_desc = function(self, eff) return ("目 标 受 到 的 投 射 物 减 速 %d%% 。"):format (eff.power) end,
	type = "magical",
	subtype = { circle=true, light=true, darkness=true },
	status = "beneficial",
	parameters = {power = 1},
	activate = function(self, eff)
		eff.ward = self:addTemporaryValue("slow_projectiles", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("slow_projectiles", eff.ward)
	end,
}

newEffect{
	name = "TURN_BACK_THE_CLOCK", image = "talents/turn_back_the_clock.png",
	desc = "Turn Back the Clock",
	long_desc = function(self, eff) return ("目 标 被 倒 退 回 幼 儿 时 代， 降 低 %d 所 有 属 性 值。"):format(eff.power) end,
	type = "magical",
	subtype = { temporal=true },
	status = "detrimental",
	parameters = { },
	on_gain = function(self, err) return "#Target# is returned to a much younger state!", "+Turn Back the Clock" end,
	on_lose = function(self, err) return "#Target# has regained its natural age.", "-Turn Back the Clock" end,
	activate = function(self, eff)
		eff.stat = self:addTemporaryValue("inc_stats", {
				[Stats.STAT_STR] = -eff.power,
				[Stats.STAT_DEX] = -eff.power,
				[Stats.STAT_CON] = -eff.power,
				[Stats.STAT_MAG] = -eff.power,
				[Stats.STAT_WIL] = -eff.power,
				[Stats.STAT_CUN] = -eff.power,
		})
		-- Make sure the target doesn't have more life then it should
		if self.life > self.max_life then
			self.life = self.max_life
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_stats", eff.stat)
	end,
}

newEffect{
	name = "WASTING", image = "talents/ashes_to_ashes.png",
	desc = "Wasting",
	long_desc = function(self, eff) return ("消 耗 目 标 使 其 受 到 每 回 合 %0.2f 时 空 伤 害。"):format(eff.power) end,
	type = "magical",
	subtype = { temporal=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is wasting away!", "+Wasting" end,
	on_lose = function(self, err) return "#Target# stops wasting away.", "-Wasting" end,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the flames!
		local olddam = old_eff.power * old_eff.dur
		local newdam = new_eff.power * new_eff.dur
		local dur = math.ceil((old_eff.dur + new_eff.dur) / 2)
		old_eff.dur = dur
		old_eff.power = (olddam + newdam) / dur
		return old_eff
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.TEMPORAL).projector(eff.src, self.x, self.y, DamageType.TEMPORAL, eff.power)
	end,
}

newEffect{
	name = "PRESCIENCE", image = "talents/moment_of_prescience.png",
	desc = "Prescience",
	long_desc = function(self, eff) return ("目 标 对 当 前 状 况 了 如 指 掌， 增 加 隐 形 和 潜 行 侦 测 等 级、 命 中、 近 身 闪 避 %d 。"):format(eff.power) end,
	type = "magical",
	subtype = { sense=true, temporal=true },
	status = "beneficial",
	parameters = { power = 1 },
	on_gain = function(self, err) return "#Target# has found the present moment!", "+Prescience" end,
	on_lose = function(self, err) return "#Target#'s awareness returns to normal.", "-Prescience" end,
	activate = function(self, eff)
		eff.defid = self:addTemporaryValue("combat_def", eff.power)
		eff.atkid = self:addTemporaryValue("combat_atk", eff.power)
		eff.invis = self:addTemporaryValue("see_invisible", eff.power)
		eff.stealth = self:addTemporaryValue("see_stealth", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("see_invisible", eff.invis)
		self:removeTemporaryValue("see_stealth", eff.stealth)
		self:removeTemporaryValue("combat_def", eff.defid)
		self:removeTemporaryValue("combat_atk", eff.atkid)
	end,
}

newEffect{
	name = "INVIGORATE", image = "talents/invigorate.png",
	desc = "Invigorate",
	long_desc = function(self, eff) return ("目 标 每 回 合 回 复 %d 体 力 值 并 且 以 两 倍 正 常 速 度 刷 新 技 能。 "):format(eff.power) end,
	type = "magical",
	subtype = { temporal=true },
	status = "beneficial",
	parameters = {power = 10},
	on_gain = function(self, err) return "#Target# is invigorated.", "+Invigorate" end,
	on_lose = function(self, err) return "#Target# is no longer invigorated.", "-Invigorate" end,
	on_timeout = function(self, eff)
		if not self:attr("no_talents_cooldown") then
			for tid, _ in pairs(self.talents_cd) do
				local t = self:getTalentFromId(tid)
				if t and t.name ~= "Invigorate" then
					self.talents_cd[tid] = self.talents_cd[tid] - 1
				end
			end
		end
	end,
	activate = function(self, eff)
		self.stamina_regen = self.stamina_regen + eff.power
	end,
	deactivate = function(self, eff)
		self.stamina_regen = self.stamina_regen - eff.power
	end,
}

newEffect{
	name = "GATHER_THE_THREADS", image = "talents/gather_the_threads.png",
	desc = "Gather the Threads",
	long_desc = function(self, eff) return ("目 标 法 术 强 度 已 提 高 %d ， 每 回 合 进 一 步 提 高 %d 。"):
	format(eff.cur_power or eff.power, eff.power/5) end,
	type = "magical",
	subtype = { temporal=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is gathering energy from other timelines.", "+Gather the Threads" end,
	on_lose = function(self, err) return "#Target# is no longer manipulating the timestream.", "-Gather the Threads" end,
	on_merge = function(self, old_eff, new_eff)
		self:removeTemporaryValue("combat_spellpower", old_eff.tmpid)
		old_eff.cur_power = (old_eff.cur_power + new_eff.power)
		old_eff.tmpid = self:addTemporaryValue("combat_spellpower", old_eff.cur_power)

		old_eff.dur = old_eff.dur
		return old_eff
	end,
	on_timeout = function(self, eff)
		local threads = eff.power / 5
		self:incParadox(- eff.reduction)
		self:setEffect(self.EFF_GATHER_THE_THREADS, 1, {power=threads})
	end,
	activate = function(self, eff)
		eff.cur_power = eff.power
		eff.tmpid = self:addTemporaryValue("combat_spellpower", eff.power)
		eff.particle = self:addParticles(Particles.new("time_shield", 1))
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_spellpower", eff.tmpid)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "FLAWED_DESIGN", image = "talents/flawed_design.png",
	desc = "Flawed Design",
	long_desc = function(self, eff) return ("改 变 目 标 的 过 去， 降 低 所 有 抵 抗 %d%% 。"):format(eff.power) end,
	type = "magical",
	subtype = { temporal=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is flawed.", "+Flawed" end,
	on_lose = function(self, err) return "#Target# is no longer flawed.", "-Flawed" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("resists", {
			all = -eff.power,
		})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.tmpid)
	end,
}

newEffect{
	name = "MANAWORM", image = "effects/manaworm.png",
	desc = "Manaworm",
	long_desc = function(self, eff) return ("目 标 被 法 力 蠕 虫 感 染， 每 回 合 被 吸 取 %0.2f 法 力 值 并 对 宿 主 造 成 相 应 数 量 的 奥 术 伤 害。"):format(eff.power) end,
	type = "magical",
	subtype = { arcane=true },
	status = "detrimental",
	parameters = {power=10},
	on_gain = function(self, err) return "#Target# is infected by a manaworm!", "+Manaworm" end,
	on_lose = function(self, err) return "#Target# is no longer infected.", "-Manaworm" end,
	on_timeout = function(self, eff)
		local dam = eff.power
		if dam > self:getMana() then dam = self:getMana() end
		self:incMana(-dam)
		DamageType:get(DamageType.ARCANE).projector(eff.src, self.x, self.y, DamageType.ARCANE, dam)
	end,
}

newEffect{
	name = "SURGE_OF_UNDEATH", image = "talents/surge_of_undeath.png",
	desc = "Surge of Undeath",
	long_desc = function(self, eff) return ("增 加 目 标 %d 攻 击 强 度、 法 术 强 度 和 命 中 , 增 加 %d 护 甲 穿 透 并 提 高 %d 暴 击 率。"):format(eff.power, eff.apr, eff.crit) end,
	type = "magical",
	subtype = { frenzy=true },
	status = "beneficial",
	parameters = { power=10, crit=10, apr=10 },
	on_gain = function(self, err) return "#Target# is engulfed in dark energies.", "+Undeath Surge" end,
	on_lose = function(self, err) return "#Target# seems less powerful.", "-Undeath Surge" end,
	activate = function(self, eff)
		eff.damid = self:addTemporaryValue("combat_dam", eff.power)
		eff.spellid = self:addTemporaryValue("combat_spellpower", eff.power)
		eff.accid = self:addTemporaryValue("combat_atk", eff.power)
		eff.aprid = self:addTemporaryValue("combat_apr", eff.apr)
		eff.pcritid = self:addTemporaryValue("combat_physcrit", eff.crit)
		eff.scritid = self:addTemporaryValue("combat_spellcrit", eff.crit)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_dam", eff.damid)
		self:removeTemporaryValue("combat_spellpower", eff.spellid)
		self:removeTemporaryValue("combat_atk", eff.accid)
		self:removeTemporaryValue("combat_apr", eff.aprid)
		self:removeTemporaryValue("combat_physcrit", eff.pcritid)
		self:removeTemporaryValue("combat_spellcrit", eff.scritid)
	end,
}

newEffect{
	name = "BONE_SHIELD", image = "talents/bone_shield.png",
	desc = "Bone Shield",
	long_desc = function(self, eff) return ("有 超 过 你 生 命 值 %d%% 的 伤 害 都 会 被 降 低 至 %d%% 。"):format(eff.power, eff.power) end,
	type = "magical",
	subtype = { arcane=true, shield=true },
	status = "beneficial",
	parameters = { power=30 },
	on_gain = function(self, err) return "#Target# protected by flying bones.", "+Bone Shield" end,
	on_lose = function(self, err) return "#Target# flying bones crumble.", "-Bone Shield" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("flat_damage_cap", {all=eff.power})
		if core.shader.active(4) then
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.4, img="runicshield"}, {type="runicshield", shieldIntensity=0.2, ellipsoidalFactor=1, scrollingSpeed=1, time_factor=10000, bubbleColor={0.3, 0.3, 0.3, 1.0}, auraColor={0.1, 0.1, 0.1, 1}}))
		else
			eff.particle = self:addParticles(Particles.new("time_shield_bubble", 1))
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("flat_damage_cap", eff.tmpid)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "REDUX", image = "talents/redux.png",
	desc = "Redux",
	long_desc = function(self, eff) return "下 一 次 目 标 使 用 时 空 技 能 时 将 释 放 两 次 该 法 术。" end,
	type = "magical",
	subtype = { temporal=true },
	status = "beneficial",
	parameters = { power=1},
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "TEMPORAL_DESTABILIZATION_START", image = "talents/destabilize.png",
	desc = "Temporal Destabilization",
	long_desc = function(self, eff) return ("目 标 被 扰 动， 在 %d 回 合 受 到 每 回 合 %0.2f 时 空 伤 害。 若 目 标 在 效 果 持 续 中 因 该 伤 害 死 亡 则 会 发 生 爆 炸。"):format(eff.dur, eff.dam) end,
	type = "magical",
	subtype = { temporal=true },
	status = "detrimental",
	parameters = { dam=1, explosion=10 },
	on_gain = function(self, err) return "#Target# is unstable.", "+Temporal Destabilization" end,
	on_lose = function(self, err) return "#Target# has regained stability.", "-Temporal Destabilization" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("destabilized", 1))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self:setEffect(self.EFF_TEMPORAL_DESTABILIZATION, 5, {src=eff.src, dam=eff.dam, explosion=eff.explosion})
	end,
}

newEffect{
	name = "TEMPORAL_DESTABILIZATION", image = "talents/destabilize.png",
	desc = "Temporal Destabilization",
	long_desc = function(self, eff) return ("目 标 失 去 时 间 平 衡 并 每 回 合 受 到 %0.2f 时 空 伤 害。 如 果 目 标 在 效 果 持 续 时 死 亡 则 会 爆 炸。"):format(eff.dam) end,
	type = "magical",
	subtype = { temporal=true },
	status = "detrimental",
	parameters = { dam=1, explosion=10 },
	on_gain = function(self, err) return "#Target# is unstable.", "+Temporal Destabilization" end,
	on_lose = function(self, err) return "#Target# has regained stability.", "-Temporal Destabilization" end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.TEMPORAL).projector(eff.src or self, self.x, self.y, DamageType.TEMPORAL, eff.dam)
	end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("destabilized", 1))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "HASTE", image = "talents/haste.png",
	desc = "Haste",
	long_desc = function(self, eff) return ("提 升 整 体 速 度 %d%% 。"):format(eff.power * 100) end,
	type = "magical",
	subtype = { temporal=true },
	status = "beneficial",
	parameters = { power=0.1 },
	on_gain = function(self, err) return "#Target# speeds up.", "+Haste" end,
	on_lose = function(self, err) return "#Target# slows down.", "-Haste" end,
	activate = function(self, eff)
		eff.glbid = self:addTemporaryValue("global_speed_add", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.glbid)
	end,
}

newEffect{
	name = "CEASE_TO_EXIST", image = "talents/cease_to_exist.png",
	desc = "Cease to Exist",
	long_desc = function(self, eff) return ("目 标 被 尝 试 移 出 时 间 线， 减 少 %d%% 抵 抗。"):format(eff.power) end,
	type = "magical",
	subtype = { temporal=true },
	status = "detrimental",
	parameters = { power = 1 },
	on_gain = function(self, err) return "#Target# is being removed from the timeline.", "+Cease to Exist" end,
	activate = function(self, eff)
		eff.resists = self:addTemporaryValue("resists", { all = -eff.power})
	end,
	deactivate = function(self, eff)
		if game._chronoworlds then
			game._chronoworlds = nil
		end
		self:removeTemporaryValue("resists", eff.resists)
	end,
}

newEffect{
	name = "IMPENDING_DOOM", image = "talents/impending_doom.png",
	desc = "Impending Doom",
	long_desc = function(self, eff) return ("目 标 的 末 日 已 经 临 近，治疗 系 数 降 低 100%% 并 且 每 回 合 受 到 %0.2f 奥 术 伤 害。 施 法 者 死 亡 时 本 效 果 消 失。"):format(eff.dam) end,
	type = "magical",
	subtype = { arcane=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is doomed!", "+Doomed" end,
	on_lose = function(self, err) return "#Target# is freed from the impending doom.", "-Doomed" end,
	activate = function(self, eff)
		eff.healid = self:addTemporaryValue("healing_factor", -1)
	end,
	on_timeout = function(self, eff)
		if eff.src.dead or not game.level:hasEntity(eff.src) then return true end
		DamageType:get(DamageType.ARCANE).projector(eff.src, self.x, self.y, DamageType.ARCANE, eff.dam)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("healing_factor", eff.healid)
	end,
}

newEffect{
	name = "RIGOR_MORTIS", image = "talents/rigor_mortis.png",
	desc = "Rigor Mortis",
	long_desc = function(self, eff) return (" 目 标 受 到 死 灵 随 从 的 伤 害 增 加 %d%% 。"):format(eff.power) end,
	type = "magical",
	subtype = { arcane=true },
	status = "detrimental",
	parameters = {power=20},
	on_gain = function(self, err) return "#Target# feels death coming!", "+Rigor Mortis" end,
	on_lose = function(self, err) return "#Target# is freed from the rigor mortis.", "-Rigor Mortis" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("inc_necrotic_minions", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_necrotic_minions", eff.tmpid)
	end,
}

newEffect{
	name = "ABYSSAL_SHROUD", image = "talents/abyssal_shroud.png",
	desc = "Abyssal Shroud",
	long_desc = function(self, eff) return ("目 标 光 照 范 围 减 少 %d ， 暗 影 抵 抗 下 降 %d%% 。"):format(eff.lite, eff.power) end,
	type = "magical",
	subtype = { darkness=true },
	status = "detrimental",
	parameters = {power=20},
	on_gain = function(self, err) return "#Target# feels closer to the abyss!", "+Abyssal Shroud" end,
	on_lose = function(self, err) return "#Target# is free from the abyss.", "-Abyssal Shroud" end,
	activate = function(self, eff)
		eff.liteid = self:addTemporaryValue("lite", -eff.lite)
		eff.darkid = self:addTemporaryValue("resists", { [DamageType.DARKNESS] = -eff.power })
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("lite", eff.liteid)
		self:removeTemporaryValue("resists", eff.darkid)
	end,
}

newEffect{
	name = "SPIN_FATE", image = "talents/spin_fate.png",
	desc = "Spin Fate",
	long_desc = function(self, eff) return ("目 标 所 有 豁 免 增 加 %d 。"):
	format(eff.cur_save_bonus or eff.save_bonus) end,
	type = "magical",
	subtype = { temporal=true },
	status = "beneficial",
	parameters = { save_bonus, max_bonus = 10},
	on_gain = function(self, err) return "#Target# takes fate by the hand.", "+Spin Fate" end,
	on_lose = function(self, err) return "#Target#'s fate is no longer being spun.", "-Spin Fate" end,
	on_merge = function(self, old_eff, new_eff)
		-- remove the four old values
		self:removeTemporaryValue("combat_physresist", old_eff.physid)
		self:removeTemporaryValue("combat_spellresist", old_eff.spellid)
		self:removeTemporaryValue("combat_mentalresist", old_eff.mentalid)
		-- combine the old and new values
		old_eff.cur_save_bonus = math.min(new_eff.max_bonus, old_eff.cur_save_bonus + new_eff.save_bonus)
		-- and apply the current values
		old_eff.physid = self:addTemporaryValue("combat_physresist", old_eff.cur_save_bonus)
		old_eff.spellid = self:addTemporaryValue("combat_spellresist", old_eff.cur_save_bonus)
		old_eff.mentalid = self:addTemporaryValue("combat_mentalresist", old_eff.cur_save_bonus)

		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		-- track the current values
		eff.cur_save_bonus = eff.save_bonus
		-- apply current values
		eff.physid = self:addTemporaryValue("combat_physresist", eff.save_bonus)
		eff.spellid = self:addTemporaryValue("combat_spellresist", eff.save_bonus)
		eff.mentalid = self:addTemporaryValue("combat_mentalresist", eff.save_bonus)
		eff.particle = self:addParticles(Particles.new("arcane_power", 1))
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_physresist", eff.physid)
		self:removeTemporaryValue("combat_spellresist", eff.spellid)
		self:removeTemporaryValue("combat_mentalresist", eff.mentalid)
		self:removeParticles(eff.particle)
	end,
}


newEffect{
	name = "SPELLSHOCKED",
	desc = "Spellshocked",
	long_desc = function(self, eff) return string.format("势 不 可 挡 的 魔 法 暂 时 性 扰 乱 所 有 伤 害 抵 抗， 降 低 伤 害 抵 抗 %d%% 。", eff.power) end,
	type = "magical",
	subtype = { ["cross tier"]=true },
	status = "detrimental",
	parameters = { power=20 },
	on_gain = function(self, err) return nil, "+Spellshocked" end,
	on_lose = function(self, err) return nil, "-Spellshocked" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("resists", {
			all = -eff.power,
		})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.tmpid)
	end,
}

newEffect{
	name = "ROTTING_DISEASE", image = "talents/rotting_disease.png",
	desc = "Rotting Disease",
	long_desc = function(self, eff) return ("目 标 被 感 染 疾 病， 降 低 %d 体 质 并 每 回 合 造 成 %0.2f 枯 萎 伤 害。"):format(eff.con, eff.dam) end,
	type = "magical",
	subtype = {disease=true, blight=true},
	status = "detrimental",
	parameters = {con = 1, dam = 0},
	on_gain = function(self, err) return "#Target# is afflicted by a rotting disease!" end,
	on_lose = function(self, err) return "#Target# is free from the rotting disease." end,
	-- Damage each turn
	on_timeout = function(self, eff)
		if self:attr("purify_disease") then self:heal(eff.dam, eff.src)
		else if eff.dam > 0 then DamageType:get(DamageType.BLIGHT).projector(eff.src, self.x, self.y, DamageType.BLIGHT, eff.dam, {from_disease=true})
		end end
	end,
	-- Lost of CON
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("inc_stats", {[Stats.STAT_CON] = -eff.con})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_stats", eff.tmpid)
	end,
}

newEffect{
	name = "DECREPITUDE_DISEASE", image = "talents/decrepitude_disease.png",
	desc = "Decrepitude Disease",
	long_desc = function(self, eff) return ("目 标 被 感 染 疾 病， 降 低 %d 敏 捷 并 每 回 合 受 到 %0.2f 枯 萎 伤 害。"):format(eff.dex, eff.dam) end,
	type = "magical",
	subtype = {disease=true, blight=true},
	status = "detrimental",
	parameters = {dex = 1, dam = 0},
	on_gain = function(self, err) return "#Target# is afflicted by a decrepitude disease!" end,
	on_lose = function(self, err) return "#Target# is free from the decrepitude disease." end,
	-- Damage each turn
	on_timeout = function(self, eff)
		if self:attr("purify_disease") then self:heal(eff.dam, eff.src)
		else if eff.dam > 0 then DamageType:get(DamageType.BLIGHT).projector(eff.src, self.x, self.y, DamageType.BLIGHT, eff.dam, {from_disease=true})
		end end
	end,
	-- Lost of CON
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("inc_stats", {[Stats.STAT_DEX] = -eff.dex})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_stats", eff.tmpid)
	end,
}

newEffect{
	name = "WEAKNESS_DISEASE", image = "talents/weakness_disease.png",
	desc = "Weakness Disease",
	long_desc = function(self, eff) return ("目 标 被 感 染 疾 病， 降 低 %d 力 量 并 每 回 合 受 到 %0.2f 枯 萎 伤 害。"):format(eff.str, eff.dam) end,
	type = "magical",
	subtype = {disease=true, blight=true},
	status = "detrimental",
	parameters = {str = 1, dam = 0},
	on_gain = function(self, err) return "#Target# is afflicted by a weakness disease!" end,
	on_lose = function(self, err) return "#Target# is free from the weakness disease." end,
	-- Damage each turn
	on_timeout = function(self, eff)
		if self:attr("purify_disease") then self:heal(eff.dam, eff.src)
		else if eff.dam > 0 then DamageType:get(DamageType.BLIGHT).projector(eff.src, self.x, self.y, DamageType.BLIGHT, eff.dam, {from_disease=true})
		end end
	end,
	-- Lost of CON
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("inc_stats", {[Stats.STAT_STR] = -eff.str})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_stats", eff.tmpid)
	end,
}

newEffect{
	name = "EPIDEMIC", image = "talents/epidemic.png",
	desc = "Epidemic",
	long_desc = function(self, eff) return ("目 标 被 感 染 疾 病， 每 回 合 受 到 %0.2f 枯 萎 伤 害 并 降 低 治 疗 效 果 %d%% 。 \n 未 感 染 疾 病 的 目 标 受 到 枯 萎 伤 害 时 会 被 传 染 该 疫 病。"):format(eff.dam, eff.heal_factor) end,
	type = "magical",
	subtype = {disease=true, blight=true},
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is afflicted by an epidemic!" end,
	on_lose = function(self, err) return "#Target# is free from the epidemic." end,
	-- Damage each turn
	on_timeout = function(self, eff)
		if self:attr("purify_disease") then self:heal(eff.dam, eff.src)
		else DamageType:get(DamageType.BLIGHT).projector(eff.src, self.x, self.y, DamageType.BLIGHT, eff.dam, {from_disease=true})
		end
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("diseases_spread_on_blight", 1)
		eff.healid = self:addTemporaryValue("healing_factor", -eff.heal_factor / 100)
		eff.immid = self:addTemporaryValue("disease_immune", -eff.resist / 100)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("diseases_spread_on_blight", eff.tmpid)
		self:removeTemporaryValue("healing_factor", eff.healid)
		self:removeTemporaryValue("disease_immune", eff.immid)
	end,
}

newEffect{
	name = "WORM_ROT", image = "talents/worm_rot.png",
	desc = "Worm Rot",
	long_desc = function(self, eff) return ("目 标 被 腐 肉 幼 虫 感 染， 每 回 合 会 丢 失 一 个 物 理 增 益 效 果 并 受 到 %0.2f 枯 萎 和 酸 性 伤 害。 \n 5 回 合 后 再 会 造 成 %0.2f 枯 萎 伤 害 并 孵 化 一 条 成 熟 腐 肉 虫。"):format(eff.dam, eff.burst) end,
	type = "magical",
	subtype = {disease=true, blight=true, acid=true},
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is afflicted by a terrible worm rot!" end,
	on_lose = function(self, err) return "#Target# is free from the worm rot." end,
	-- Damage each turn
	on_timeout = function(self, eff)
		eff.rot_timer = eff.rot_timer - 1

		-- disease damage
		if self:attr("purify_disease") then
			self:heal(eff.dam, eff.src)
		else
			DamageType:get(DamageType.BLIGHT).projector(eff.src, self.x, self.y, DamageType.BLIGHT, eff.dam, {from_disease=true})
		end
		-- acid damage from the larvae
		DamageType:get(DamageType.ACID).projector(eff.src, self.x, self.y, DamageType.ACID, eff.dam)

		local effs = {}
		-- Go through all physical effects
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.status == "beneficial" and e.type == "physical" then
				effs[#effs+1] = {"effect", eff_id}
			end
		end
		-- remove a random physical effect
		if #effs > 0 then
			local eff = rng.tableRemove(effs)
			if eff[1] == "effect" then
				self:removeEffect(eff[2])
			end
		end

		-- burst and spawn a worm mass
		if eff.rot_timer == 0 then
			DamageType:get(DamageType.BLIGHT).projector(eff.src, self.x, self.y, DamageType.BLIGHT, eff.burst, {from_disease=true})
			local t = eff.src:getTalentFromId(eff.src.T_WORM_ROT)
			t.spawn_carrion_worm(eff.src, self, t)
			game.logSeen(self, "#LIGHT_RED#A carrion worm mass bursts out of %s!", self.name:capitalize())
			self:removeEffect(self.EFF_WORM_ROT)
		end
	end,
}

newEffect{
	name = "GHOUL_ROT", image = "talents/gnaw.png",
	desc = "Ghoul Rot",
	long_desc = function(self, eff)
		local ghoulify = ""
		if eff.make_ghoul > 0 then ghoulify = "  如 果 目 标 在 效 果 持 续 期 间 死 亡， 则 会 重 生 为 食 尸 鬼。" end
		return ("目 标 感 染 疾 病， 降 低 力 量 值 %d ， 敏 捷 值 %d ， 体 质 值 %d ， 并 造 成 每 回 合 %0.2f 枯 萎 伤 害。%s"):format(eff.str, eff.dex, eff.con, eff.dam, ghoulify)
	end,
	type = "magical",
	subtype = {disease=true, blight=true},
	status = "detrimental",
	parameters = {str = 0, con = 0, dex = 0, make_ghoul = 0},
	on_gain = function(self, err) return "#Target# is afflicted by ghoul rot!" end,
	on_lose = function(self, err) return "#Target# is free from the ghoul rot." end,
	-- Damage each turn
	on_timeout = function(self, eff)
		if self:attr("purify_disease") then self:heal(eff.dam, eff.src)
		else DamageType:get(DamageType.BLIGHT).projector(eff.src, self.x, self.y, DamageType.BLIGHT, eff.dam, {from_disease=true})
		end
	end,
	-- Lost of CON
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("inc_stats", {[Stats.STAT_STR] = -eff.str, [Stats.STAT_DEX] = -eff.dex, [Stats.STAT_CON] = -eff.con})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_stats", eff.tmpid)
	end,
}

newEffect{
	name = "BLOODCASTING", image = "talents/bloodcasting.png",
	desc = "Bloodcasting",
	long_desc = function(self, eff) return ("堕 落 者 消 耗 生 命 值 来 取 代 活 力 值。") end,
	type = "magical",
	subtype = {corruption=true},
	status = "beneficial",
	parameters = {},
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("bloodcasting", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("bloodcasting", eff.tmpid)
	end,
}

newEffect{
	name = "ARCANE_SUPREMACY", image = "talents/arcane_supremacy.png",
	desc = "Arcane Supremacy",
	long_desc = function(self, eff) return ("目 标 法 术 强 度 及 法 术 豁 免 提 升 %d"):	format(eff.power) end,
	type = "magical",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is surging with arcane energy.", "+Arcane Supremacy" end,
	on_lose = function(self, err) return "#The arcane energy around Target# has dissipated.", "-Arcane Supremacy" end,
	activate = function(self, eff)
		eff.spell_save = self:addTemporaryValue("combat_spellresist", eff.power)
		eff.spell_power = self:addTemporaryValue("combat_spellpower", eff.power)
		eff.particle = self:addParticles(Particles.new("arcane_power", 1))
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_spellpower", eff.spell_power)
		self:removeTemporaryValue("combat_spellresist", eff.spell_save)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "WARD", image = "talents/ward.png",
	desc = "Ward",
	long_desc = function(self, eff) return ("完 全 吸 收 %d 次 %s 攻 击。"):format(#eff.particles, DamageType.dam_def[eff.d_type].name) end,
	type = "magical",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { nb=3 },
	on_gain = function(self, eff) return ("#Target# warded against %s!"):format(DamageType.dam_def[eff.d_type].name), "+Ward" end,
	on_lose = function(self, eff) return ("#Target#'s %s ward fades"):format(DamageType.dam_def[eff.d_type].name), "-Ward" end,
	absorb = function(type, dam, eff, self, src)
		if eff.d_type ~= type then return dam end
		game.logPlayer(self, "Your %s ward absorbs the damage!", DamageType.dam_def[eff.d_type].name)
		local pid = table.remove(eff.particles)
		if pid then self:removeParticles(pid) end
		if #eff.particles <= 0 then
			--eff.dur = 0
			self:removeEffect(self.EFF_WARD)
		end
		return 0
	end,
	activate = function(self, eff)
		local nb = eff.nb
		local ps = {}
		for i = 1, nb do ps[#ps+1] = self:addParticles(Particles.new("ward", 1, {color=DamageType.dam_def[eff.d_type].color})) end
		eff.particles = ps
	end,
	deactivate = function(self, eff)
		for i, particle in ipairs(eff.particles) do self:removeParticles(particle) end
	end,
}

newEffect{
	name = "SPELLSURGE", image = "talents/gather_the_threads.png",
	desc = "Spellsurge",
	long_desc = function(self, eff) return ("目 标 的 法 术 强 度 提 升 %d 。"):
	format(eff.cur_power or eff.power) end,
	type = "magical",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is surging arcane power.", "+Spellsurge" end,
	on_lose = function(self, err) return "#Target# is no longer surging arcane power.", "-Spellsurge" end,
	on_merge = function(self, old_eff, new_eff)
		self:removeTemporaryValue("combat_spellpower", old_eff.tmpid)
		old_eff.cur_power = math.min(old_eff.cur_power + new_eff.power, new_eff.max)
		old_eff.tmpid = self:addTemporaryValue("combat_spellpower", old_eff.cur_power)

		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		eff.cur_power = eff.power
		eff.tmpid = self:addTemporaryValue("combat_spellpower", eff.power)
		eff.particle = self:addParticles(Particles.new("arcane_power", 1))
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_spellpower", eff.tmpid)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "OUT_OF_PHASE", image = "talents/phase_door.png",
	desc = "Out of Phase",
	long_desc = function(self, eff) return ("目 标 脱 离 了 相 位 现 实， 增 加 %d 闪 避， %d%% 所 有 抵 抗 以 及 %d%% 所 有 负 面 状 态 的 持 续 时 间"):
	format(eff.defense or 0, eff.resists or 0, eff.effect_reduction or 0) end,
	type = "magical",
	subtype = { teleport=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is out of phase.", "+Phased" end,
	on_lose = function(self, err) return "#Target# is no longer out of phase.", "-Phased" end,
	activate = function(self, eff)
		eff.defid = self:addTemporaryValue("combat_def", eff.defense)
		eff.resid= self:addTemporaryValue("resists", {all=eff.resists})
		eff.durid = self:addTemporaryValue("reduce_detrimental_status_effects_time", eff.effect_reduction)
		eff.particle = self:addParticles(Particles.new("phantasm_shield", 1))
	end,
	on_merge = function(self, old_eff, new_eff)
		old_eff.defense = math.min(50, math.max(old_eff.defense, new_eff.defense)) or 0
		old_eff.resists = math.min(40, math.max(old_eff.resists, new_eff.resists)) or 0
		old_eff.effect_reduction = math.min(60, math.max(old_eff.effect_reduction, new_eff.effect_reduction)) or 0

		self:removeTemporaryValue("combat_def", old_eff.defid)
		self:removeTemporaryValue("resists", old_eff.resid)
		self:removeTemporaryValue("reduce_detrimental_status_effects_time", old_eff.durid)

		old_eff.defid = self:addTemporaryValue("combat_def", old_eff.defense)
		old_eff.resid= self:addTemporaryValue("resists", {all=old_eff.resists})
		old_eff.durid = self:addTemporaryValue("reduce_detrimental_status_effects_time", old_eff.effect_reduction)
		old_eff.dur = math.max(old_eff.dur, new_eff.dur)
		return old_eff
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_def", eff.defid)
		self:removeTemporaryValue("resists", eff.resid)
		self:removeTemporaryValue("reduce_detrimental_status_effects_time", eff.durid)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "BLOOD_LOCK", image = "talents/blood_lock.png",
	desc = "Blood Lock",
	long_desc = function(self, eff) return ("受 到 治 疗 时， 生 命 值 维 持 在 %d 点 以 下。"):format(eff.power) end,
	type = "magical",
	subtype = { blood=true },
	status = "detrimental",
	parameters = { },
	on_gain = function(self, err) return "#Target# is blood locked.", "+Blood Lock" end,
	on_lose = function(self, err) return "#Target# is no longer blood locked.", "-Blood Lock" end,
	activate = function(self, eff)
		eff.power = self.life
		eff.tmpid = self:addTemporaryValue("blood_lock", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("blood_lock", eff.tmpid)
	end,
}

newEffect{
	name = "CONGEAL_TIME", image = "talents/congeal_time.png",
	desc = "Congeal Time",
	long_desc = function(self, eff) return ("减 少 %d%% 整 体 速 度 和 %d%% 周 围 的 抛 射 物 速 度。"):format(eff.slow * 100, eff.proj) end,
	type = "magical",
	subtype = { temporal=true, slow=true },
	status = "detrimental",
	parameters = { slow=0.1, proj=15 },
	on_gain = function(self, err) return "#Target# slows down.", "+Congeal Time" end,
	on_lose = function(self, err) return "#Target# speeds up.", "-Congeal Time" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", -eff.slow)
		eff.prjid = self:addTemporaryValue("slow_projectiles_outgoing", eff.proj)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
		self:removeTemporaryValue("slow_projectiles_outgoing", eff.prjid)
	end,
}

newEffect{
	name = "ARCANE_VORTEX", image = "talents/arcane_vortex.png",
	desc = "Arcane Vortex",
	long_desc = function(self, eff) return ("一 个 奥 术 漩 涡 跟 随 着 目 标。 每 回 合 一 个 随 机 的 法 术 射 线 从 它 身 上 释 放 出 来， 对 附 近 视 野 内 的 目 标 造 成 %0.2f 奥 术 伤 害。 如 果 视 野 内 没 有 任 何 其 他 目 标， 则 该 回 合 会 对 初 始 目 标 附 加 150％ 奥 术 伤 害。"):format(eff.dam) end,
	type = "magical",
	subtype = { arcane=true },
	status = "detrimental",
	parameters = { dam=10 },
	on_gain = function(self, err) return "#Target# is focused by an arcane vortex!", "+Arcane Vortex" end,
	on_lose = function(self, err) return "#Target# is free from the arcane vortex.", "-Arcane Vortex" end,
	on_timeout = function(self, eff)
		if not self.x then return end
		local l = {}
		self:project({type="ball", x=self.x, y=self.y, radius=7, selffire=false}, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and target ~= self and eff.src:reactionToward(target) < 0 then l[#l+1] = target end
		end)

		if #l == 0 then
			DamageType:get(DamageType.ARCANE).projector(eff.src, self.x, self.y, DamageType.ARCANE, eff.dam * 1.5)
		else
			DamageType:get(DamageType.ARCANE).projector(eff.src, self.x, self.y, DamageType.ARCANE, eff.dam)
			local act = rng.table(l)
			eff.src:project({type="beam", x=self.x, y=self.y}, act.x, act.y, DamageType.ARCANE, eff.dam, nil)
			game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(act.x-self.x), math.abs(act.y-self.y)), "mana_beam", {tx=act.x-self.x, ty=act.y-self.y})
		end

		game:playSoundNear(self, "talents/arcane")
	end,
	on_die = function(self, eff)
		local tg = {type="ball", radius=2, selffire=false, x=self.x, y=self.y}
		eff.src:project(tg, self.x, self.y, DamageType.ARCANE, eff.dam * eff.dur)
		if core.shader.active(4) then
			game.level.map:particleEmitter(self.x, self.y, 2, "shader_ring", {radius=4, life=12}, {type="sparks", zoom=1, time_factor=400, hide_center=0, color1={0.6, 0.3, 0.8, 1}, color2={0.8, 0, 0.8, 1}})
		else
			game.level.map:particleEmitter(self.x, self.y, 2, "generic_ball", {rm=150, rM=180, gm=20, gM=60, bm=180, bM=200, am=80, aM=150, radius=2})
		end
	end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("arcane_vortex", 1))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "AETHER_BREACH", image = "talents/aether_breach.png",
	desc = "Aether Breach",
	long_desc = function(self, eff) return ("造 成 一 个 奥 术 爆 炸， 1 码 范 围 内 每 回 合 %0.2f 奥 术 伤 害。"):format(eff.dam) end,
	type = "magical",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { dam=10 },
	on_timeout = function(self, eff)
		if game.zone.short_name.."-"..game.level.level ~= eff.level then return end

		local spot = rng.table(eff.list)
		if not spot or not spot.x then return end
		self:project({type="ball", x=spot.x, y=spot.y, radius=2, selffire=self:spellFriendlyFire()}, spot.x, spot.y, DamageType.ARCANE, eff.dam)
		game.level.map:particleEmitter(spot.x, spot.y, 2, "generic_sploom", {rm=150, rM=180, gm=20, gM=60, bm=180, bM=200, am=80, aM=150, radius=2, basenb=120})

		game:playSoundNear(self, "talents/arcane")
	end,
	activate = function(self, eff)
		eff.particle = Particles.new("circle", eff.radius, {a=150, speed=0.15, img="aether_breach", radius=eff.radius})
		eff.particle.zdepth = 6
		game.level.map:addParticleEmitter(eff.particle, eff.x, eff.y)
	end,
	deactivate = function(self, eff)
		if game.zone.short_name.."-"..game.level.level ~= eff.level then return end
		game.level.map:removeParticleEmitter(eff.particle)
	end,
}

newEffect{
	name = "AETHER_AVATAR", image = "talents/aether_avatar.png",
	desc = "Aether Avatar",
	long_desc = function(self, eff) return ("充 满 以 太 力 量。") end,
	type = "magical",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.ARCANE]=25})
		self:effectTemporaryValue(eff, "max_mana", self:getMaxMana() * 0.33)
		self:effectTemporaryValue(eff, "use_only_arcane", (self:isTalentActive(self.T_PURE_AETHER) and self:getTalentLevel(self.T_PURE_AETHER) >= 5) and 2 or 1)
		self:effectTemporaryValue(eff, "arcane_cooldown_divide", 3)

		if not self.shader then
			eff.set_shader = true
			self.shader = "shadow_simulacrum"
			self.shader_args = { color = {0.5, 0.1, 0.8}, base = 0.5, time_factor = 500 }
			self:removeAllMOs()
			game.level.map:updateMap(self.x, self.y)
		end
	end,
	deactivate = function(self, eff)
		if eff.set_shader then
			self.shader = nil
			self:removeAllMOs()
			game.level.map:updateMap(self.x, self.y)
		end
	end,
}

newEffect{
	name = "ELEMENTAL_SURGE_ARCANE", image = "talents/elemental_surge.png",
	desc = "Elemental Surge: Arcane",
	long_desc = function(self, eff) return ("施 法 速 度 提 升 20%") end,
	type = "magical",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_spellspeed", 0.2)
	end,
}

newEffect{
	name = "ELEMENTAL_SURGE_COLD", image = "talents/elemental_surge.png",
	desc = "Elemental Surge: Cold",
	long_desc = function(self, eff) return ("寒 冰 皮 肤 ： 减 少 30%% 物 理 伤 害 ， 增 加 %d 护 甲 ， 受 到 近 战 攻 击 时 造 成 %d 点 冰 冻 伤 害。"):format(eff.armor, eff.dam) end,
	type = "magical",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = {physresist=30, armor=0, dam=100 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.PHYSICAL]=eff.physresist})
		self:effectTemporaryValue(eff, "combat_armor", eff.armor)
		self:effectTemporaryValue(eff, "on_melee_hit", {[DamageType.ICE]=eff.dam})
	end,
}

newEffect{
	name = "ELEMENTAL_SURGE_LIGHTNING", image = "talents/elemental_surge.png",
	desc = "Elemental Surge: Lightning",
	long_desc = function(self, eff) return ("被 击 中 时 在 所 在 地 附 近 闪 现， 躲 避 攻 击。") end,
	type = "magical",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "phase_shift", 1)
	end,
}

newEffect{
	name = "VULNERABILITY_POISON", image = "talents/vulnerability_poison.png",
	desc = "Vulnerability Poison",
	long_desc = function(self, eff) return ("目 标 中 毒 并 得 病， 遭 受 %0.2f 奥 术 伤 害， 所 有 抗 性 下 降 %d%% 。"):format(eff.power, eff.res) end,
	type = "magical",
	subtype = { poison=true, arcane=true },
	status = "detrimental",
	parameters = {power=10, res=15},
	on_gain = function(self, err) return "#Target# is poisoned!", "+Vulnerability Poison" end,
	on_lose = function(self, err) return "#Target# is no longer poisoned.", "-Vulnerability Poison" end,
	-- Damage each turn
	on_timeout = function(self, eff)
		if self:attr("purify_poison") then self:heal(eff.power, eff.src)
		else DamageType:get(DamageType.ARCANE).projector(eff.src, self.x, self.y, DamageType.ARCANE, eff.power)
		end
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("resists", {all=-eff.res})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.tmpid)
	end,
}

newEffect{
	name = "IRRESISTIBLE_SUN", image = "talents/irresistible_sun.png",
	desc = "Irresistible Sun",
	long_desc = function(self, eff) return ("所 有 目 标 被 拉 向 它， 每 回 合 造 成 火 焰、 光 系 和 物 理 伤 害。"):format() end,
	type = "magical",
	subtype = { sun=true },
	status = "beneficial",
	parameters = {dam=100},
	on_gain = function(self, err) return "#Target# starts to attract all creatures around!", "+Irresistible Sun" end,
	on_lose = function(self, err) return "#Target# is no longer attracting creatures.", "-Irresistible Sun" end,
	activate = function(self, eff)
		local particle = Particles.new("generic_vortex", 5, {rm=230, rM=230, gm=20, gM=250, bm=250, bM=80, am=80, aM=150, radius=5, density=50})
		if core.shader.allow("distort") then particle:setSub("vortex_distort", 5, {radius=5}) end
		eff.particle = self:addParticles(particle)
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
	on_timeout = function(self, eff)
		local tgts = {}
		self:project({type="ball", range=0, friendlyfire=false, radius=5}, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			if not tgts[target] then
				tgts[target] = true
				if not target:attr("ignore_irresistible_sun") then
					local ox, oy = target.x, target.y
					target:pull(self.x, self.y, 1)
					if target.x ~= ox or target.y ~= oy then 
						game.logSeen(target, "%s is pulled in!", target.name:capitalize()) 
					end

					if self:reactionToward(target) < 0 then
						local dam = eff.dam * (1 + (5 - core.fov.distance(self.x, self.y, target.x, target.y)) / 8)
						DamageType:get(DamageType.FIRE).projector(self, target.x, target.y, DamageType.FIRE, dam/3)
						DamageType:get(DamageType.LIGHT).projector(self, target.x, target.y, DamageType.LIGHT, dam/3)
						DamageType:get(DamageType.PHYSICAL).projector(self, target.x, target.y, DamageType.PHYSICAL, dam/3)
					end
				end
			end
		end)
	end,
}

newEffect{
	name = "TEMPORAL_FORM", image = "talents/temporal_form.png",
	desc = "Temporal Form",
	long_desc = function(self, eff) return ("目 标 呈 现 出 泰 鲁 戈 洛 斯 形 态 "):format() end,
	type = "magical",
	subtype = { temporal=true },
	status = "beneficial",
	parameters = {},
	on_gain = function(self, err) return "#Target# threads time as a shell!", "+Temporal Form" end,
	on_lose = function(self, err) return "#Target# is no longer embeded in time.", "-Temporal Form" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "all_damage_convert", DamageType.TEMPORAL)
		self:effectTemporaryValue(eff, "all_damage_convert_percent", 50)
		self:effectTemporaryValue(eff, "stun_immune", 1)
		self:effectTemporaryValue(eff, "pin_immune", 1)
		self:effectTemporaryValue(eff, "cut_immune", 1)
		self:effectTemporaryValue(eff, "blind_immune", 1)

		local highest = self.inc_damage.all or 0
		for kind, v in pairs(self.inc_damage) do
			if kind ~= "all" then
				local inc = (self.inc_damage.all or 0) + v
				highest = math.max(highest, inc)
			end
		end
		self.auto_highest_inc_damage = self.auto_highest_inc_damage or {}
		self:effectTemporaryValue(eff, "auto_highest_inc_damage", {[DamageType.TEMPORAL] = 30})
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.TEMPORAL] = 0.00001}) -- 0 so that it shows up in the UI
		self:effectTemporaryValue(eff, "resists", {[DamageType.TEMPORAL] = 30})
		self:effectTemporaryValue(eff, "resists_pen", {[DamageType.TEMPORAL] = 20})
		self:effectTemporaryValue(eff, "talent_cd_reduction", {[self.T_ANOMALY_REARRANGE] = -4, [self.T_ANOMALY_TEMPORAL_STORM] = -4})
		self:effectTemporaryValue(eff, "paradox_reduce_fails", 400)
		self:learnTalent(self.T_ANOMALY_REARRANGE, true)
		self:learnTalent(self.T_ANOMALY_TEMPORAL_STORM, true)
		self:incParadox(400)

		self.replace_display = mod.class.Actor.new{
			image = "npc/elemental_temporal_telugoroth.png",
			shader = "shadow_simulacrum",
			shader_args = { color = {0.2, 0.1, 0.8}, base = 0.5, time_factor = 500 },
		}
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)
	end,
	deactivate = function(self, eff)
		self:incParadox(-400)
		self:unlearnTalent(self.T_ANOMALY_REARRANGE)
		self:unlearnTalent(self.T_ANOMALY_TEMPORAL_STORM)
		self.replace_display = nil
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)
	end,
}

newEffect{
	name = "CORRUPT_LOSGOROTH_FORM", image = "shockbolt/npc/elemental_void_losgoroth_corrupted.png",
	desc = "Corrupted Losgoroth Form",
	long_desc = function(self, eff) return ("目 标 呈 现 出 堕 落 的 罗 斯 戈 洛 斯 形 态。"):format() end,
	type = "magical",
	subtype = { blight=true, arcane=true },
	status = "beneficial",
	parameters = {},
	on_gain = function(self, err) return "#Target# turns into a losgoroth!", "+Corrupted Losgoroth Form" end,
	on_lose = function(self, err) return "#Target# is no longer transformed.", "-Corrupted Losgoroth Form" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "all_damage_convert", DamageType.DRAINLIFE)
		self:effectTemporaryValue(eff, "all_damage_convert_percent", 50)
		self:effectTemporaryValue(eff, "no_breath", 1)
		self:effectTemporaryValue(eff, "poison_immune", 1)
		self:effectTemporaryValue(eff, "disease_immune", 1)
		self:effectTemporaryValue(eff, "cut_immune", 1)
		self:effectTemporaryValue(eff, "confusion_immune", 1)

		self.replace_display = mod.class.Actor.new{
			image = "npc/elemental_void_losgoroth_corrupted.png",
		}
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)

		eff.particle = self:addParticles(Particles.new("blight_power", 1, {density=4}))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
		self.replace_display = nil
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)
	end,
}

newEffect{
	name = "SHIVGOROTH_FORM", image = "talents/shivgoroth_form.png",
	desc = "Shivgoroth Form",
	long_desc = function(self, eff) return ("目 标 呈 现 出 西 弗 戈 洛 斯 形 态。"):format() end,
	type = "magical",
	subtype = { ice=true },
	status = "beneficial",
	parameters = {},
	on_gain = function(self, err) return "#Target# turns into a shivgoroth!", "+Shivgoroth Form" end,
	on_lose = function(self, err) return "#Target# is no longer transformed.", "-Shivgoroth Form" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "damage_affinity", {[DamageType.COLD]=50 + 100 * eff.power})
		self:effectTemporaryValue(eff, "resists", {[DamageType.COLD]=100 * eff.power / 2})
		self:effectTemporaryValue(eff, "no_breath", 1)
		self:effectTemporaryValue(eff, "cut_immune", eff.power)
		self:effectTemporaryValue(eff, "stun_immune", eff.power)
		self:effectTemporaryValue(eff, "is_shivgoroth", 1)

		if self.hotkey and self.isHotkeyBound then
			local pos = self:isHotkeyBound("talent", self.T_SHIVGOROTH_FORM)
			if pos then
				self.hotkey[pos] = {"talent", self.T_ICE_STORM}
			end
		end

		local ohk = self.hotkey
		self.hotkey = nil -- Prevent assigning hotkey, we just did
		self:learnTalent(self.T_ICE_STORM, true, eff.lvl, {no_unlearn=true})
		self.hotkey = ohk

		self.replace_display = mod.class.Actor.new{
			image="invis.png", add_mos = {{image = "npc/elemental_ice_greater_shivgoroth.png", display_y = -1, display_h = 2}},
		}
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)
	end,
	deactivate = function(self, eff)
		if self.hotkey and self.isHotkeyBound then
			local pos = self:isHotkeyBound("talent", self.T_ICE_STORM)
			if pos then
				self.hotkey[pos] = {"talent", self.T_SHIVGOROTH_FORM}
			end
		end

		self:unlearnTalent(self.T_ICE_STORM, eff.lvl, nil, {no_unlearn=true})
		self.replace_display = nil
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)
	end,
}

--Duplicate for Frost Lord's Chain
newEffect{
	name = "SHIVGOROTH_FORM_LORD", image = "talents/shivgoroth_form.png",
	desc = "Shivgoroth Form",
	long_desc = function(self, eff) return ("目 标 呈 现 出 西 弗 戈 洛 斯 形 态。"):format() end,
	type = "magical",
	subtype = { ice=true },
	status = "beneficial",
	parameters = {},
	on_gain = function(self, err) return "#Target# turns into a shivgoroth!", "+Shivgoroth Form" end,
	on_lose = function(self, err) return "#Target# is no longer transformed.", "-Shivgoroth Form" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "damage_affinity", {[DamageType.COLD]=50 + 100 * eff.power})
		self:effectTemporaryValue(eff, "resists", {[DamageType.COLD]=100 * eff.power / 2})
		self:effectTemporaryValue(eff, "no_breath", 1)
		self:effectTemporaryValue(eff, "cut_immune", eff.power)
		self:effectTemporaryValue(eff, "stun_immune", eff.power)
		self:effectTemporaryValue(eff, "is_shivgoroth", 1)

		if self.hotkey and self.isHotkeyBound then
			local pos = self:isHotkeyBound("talent", self.T_SHIV_LORD)
			if pos then
				self.hotkey[pos] = {"talent", self.T_ICE_STORM}
			end
		end

		local ohk = self.hotkey
		self.hotkey = nil -- Prevent assigning hotkey, we just did
		self:learnTalent(self.T_ICE_STORM, true, eff.lvl, {no_unlearn=true})
		self.hotkey = ohk

		self.replace_display = mod.class.Actor.new{
			image="invis.png", add_mos = {{image = "npc/elemental_ice_greater_shivgoroth.png", display_y = -1, display_h = 2}},
		}
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)
	end,
	deactivate = function(self, eff)
		if self.hotkey and self.isHotkeyBound then
			local pos = self:isHotkeyBound("talent", self.T_ICE_STORM)
			if pos then
				self.hotkey[pos] = {"talent", self.T_SHIV_LORD}
			end
		end

		self:unlearnTalent(self.T_ICE_STORM, eff.lvl, nil, {no_unlearn=true})
		self.replace_display = nil
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)
	end,
}

newEffect{
	name = "KEEPER_OF_REALITY", image = "effects/continuum_destabilization.png",
	desc = "Keepers of Reality Rally Call",
	long_desc = function(self, eff) return "现 实 守 护 者 召 唤 一 切 可 能 的 防 护 来 守 卫 零 点 圣 域， 生 命 值 提 高 5000 ， 伤 害 增 加 300% 。" end,
	type = "magical",
	decrease = 0,
	subtype = { temporal=true },
	status = "beneficial",
	cancel_on_level_change = true,
	parameters = { },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "max_life", 5000)
		self:heal(5000)
		self:effectTemporaryValue(eff, "inc_damage", {all=300})
	end,
	deactivate = function(self, eff)
		self:heal(1)
	end,
}

newEffect{
	name = "RECEPTIVE_MIND", image = "talents/rune__vision.png",
	desc = "Receptive Mind",
	long_desc = function(self, eff) return (" 你 能 感 知 周 围 的 %s"):
		format(eff.what:gsub("Humanoid"," 人 形 怪 "):gsub("Horror"," 恐 魔 "):gsub("Demon"," 恶 魔 ")
		               :gsub("Dragon"," 龙 "):gsub("Animal"," 动 物 "):gsub("Undead"," 不 死 族 ")
			       :gsub("All"," 全 体 怪 物 "))
	end,
	type = "magical",
	subtype = { rune=true },
	status = "beneficial",
	parameters = { what="humanoid" },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "esp", {[eff.what]=1})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "BORN_INTO_MAGIC", image = "talents/born_into_magic.png",
	desc = "Born into Magic",
	long_desc = function(self, eff) return ("%s 伤 害 增 加 15%%."):format(DamageType:get(eff.damtype).name:capitalize()) end,
	type = "magical",
	subtype = { race=true },
	status = "beneficial",
	parameters = { eff=DamageType.ARCANE },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_damage", {[eff.damtype]=15})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ESSENCE_OF_THE_DEAD", image = "talents/essence_of_the_dead.png",
	desc = "Essence of the Dead",
	long_desc = function(self, eff) return ("目 标 消 耗 灵 魂 来 获 取 额 外 力 量 ，   %d 个 法 术 受 到 影 响 。"):format(eff.nb) end,
	type = "magical",
	decrease = 0,
	subtype = { necrotic=true },
	status = "beneficial",
	parameters = { nb=1 },
	charges = function(self, eff) return eff.nb end,
	activate = function(self, eff)
		self:addShaderAura("essence_of_the_dead", "awesomeaura", {time_factor=4000, alpha=0.6}, "particles_images/darkwings.png")
	end,
	deactivate = function(self, eff)
		self:removeShaderAura("essence_of_the_dead")
	end,
}

newEffect{
	name = "ICE_ARMOUR", image = "talents/ice_armour.png",
	desc = "Ice Armour",
	long_desc = function(self, eff) return (" 目 标 被 冰 覆 盖 ， 增 加 %d 护 甲 ， 对 攻 击 者 造 成 %0.1f 点 寒 冷 伤 害 , 同 时 将 50%% 伤 害 转 化 为 寒 冷 伤 害 。"):format(eff.armor, self:damDesc(DamageType.COLD, eff.dam)) end,
	type = "magical",
	subtype = { cold=true, armour=true, },
	status = "beneficial",
	parameters = {armor=10, dam=10},
	on_gain = function(self, err) return "#Target# is covered in icy armor!" end,
	on_lose = function(self, err) return "#Target#'s ice coating crumbles away." end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_armor", eff.armor)
		self:effectTemporaryValue(eff, "on_melee_hit", {[DamageType.COLD]=eff.dam})
		self:effectTemporaryValue(eff, "all_damage_convert", DamageType.COLD)
		self:effectTemporaryValue(eff, "all_damage_convert_percent", 50)
		self:addShaderAura("ice_armour", "crystalineaura", {}, "particles_images/spikes.png")
		eff.particle = self:addParticles(Particles.new("snowfall", 1))
	end,
	deactivate = function(self, eff)
		self:removeShaderAura("ice_armour")
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "CAUSTIC_GOLEM", image = "talents/caustic_golem.png",
	desc = "Caustic Golem",
	long_desc = function(self, eff) return (" 目 标 被 酸 液 覆 盖 。 当 被 近 战 攻 击 时 ，有 %d%% 几 率 喷 射 锥 形 酸 液 造 成 %0.1f 伤 害 。"):format(eff.chance, self:damDesc(DamageType.ACID, eff.dam)) end,
	type = "magical",
	subtype = { acid=true, coating=true, },
	status = "beneficial",
	parameters = {chance=10, dam=10},
	on_gain = function(self, err) return "#Target# is coated in acid!" end,
	on_lose = function(self, err) return "#Target#'s acid coating is diluted." end,
	callbackOnMeleeHit = function(self, eff, src)
		if self.turn_procs.caustic_golem then return end
		if not rng.percent(eff.chance) then return end
		self.turn_procs.caustic_golem = true

		self:project({type="cone", cone_angle=25, range=0, radius=4}, src.x, src.y, DamageType.ACID, eff.dam)
		game.level.map:particleEmitter(self.x, self.y, 4, "breath_acid", {radius=4, tx=src.x-self.x, ty=src.y-self.y, spread=20})
	end,
	activate = function(self, eff)
		if core.shader.active(4) then
			eff.particle = self:addParticles(Particles.new("shader_ring_rotating", 1, {z=5, rotation=0, radius=1.1, img="alchie_acid"}, {type="lightningshield"}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "SUN_VENGEANCE", image = "talents/sun_vengeance.png",
	desc = "Sun's Vengeance",
	long_desc = function(self, eff) return (" 目 标 充 满 了 阳 光 的 愤 怒 ！ 下 一 发 阳 光 烈 焰 变 为 瞬 发 。"):format() end,
	type = "magical",
	subtype = { sun=true, },
	status = "beneficial",
	parameters = {},
	on_gain = function(self, err) return "#Target# is filled with the Sun's fury!", "+Sun's Vengeance" end,
	on_lose = function(self, err) return "#Target#'s solar fury subsides.", "-Sun's Vengeance" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "amplify_sun_beam", 25)
	end
}

newEffect{
	name = "PATH_OF_THE_SUN", image = "talents/path_of_the_sun.png",
	desc = "Path of the Sun",
	long_desc = function(self, eff) return ("目 标 能 在 阳 光 大 道 上 行 走 而 不 消 耗 时 间。"):format() end,
	type = "magical",
	subtype = { sun=true, },
	status = "beneficial",
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "walk_sun_path", 1)
	end
}

newEffect{
	name = "SUNCLOAK", image = "talents/suncloak.png",
	desc = "Suncloak",
	long_desc = function(self, eff) return (" 目 标 被 太 阳 之 力 保 护 ， 增 加 %d%% 施 法 速 度 ,减 少 %d%% 法 术 冷 却 时 间 ， 同 时 一 次 伤 害 最 多 带 走 你 %d%% 最 大 生 命 。"):
		format(eff.haste*100, eff.cd*100, eff.cap) end,
	type = "magical",
	subtype = { light=true, },
	status = "beneficial",
	parameters = {cap = 1, haste = 0.1, cd = 0.1},
	on_gain = function(self, err) return "#Target# is energized and protected by the Sun!", "+Suncloak" end,
	on_lose = function(self, err) return "#Target#'s solar fury subsides.", "-Suncloak" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "flat_damage_cap", {all=eff.cap})
		self:effectTemporaryValue(eff, "combat_spellspeed", eff.haste)
		self:effectTemporaryValue(eff, "spell_cooldown_reduction", eff.cd)
		eff.particle = self:addParticles(Particles.new("suncloak", 1))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "MARK_OF_LIGHT", image = "talents/mark_of_light.png",
	desc = "Mark of Light",
	long_desc = function(self, eff) return ("目 标 被 光 之 印 记 标 记 ， 任 何 对 它 近 战 攻 击 的 生 物 受 到 %d%% 伤 害 的 治 疗。"):format(eff.power) end,
	type = "magical",
	subtype = { light=true, },
	status = "detrimental",
	parameters = { power = 10 },
	on_gain = function(self, err) return "#Target# is marked by light!", "+Mark of Light" end,
	on_lose = function(self, err) return "#Target#'s mark disappears.", "-Mark of Light" end,
	callbackOnMeleeHit = function(self, eff, src, dam)
		if eff.src == src then
			src:heal(dam * eff.power / 100, self)
			if core.shader.active(4) then
				eff.src:addParticles(Particles.new("shader_shield_temp", 1, {toback=true, size_factor=1.5, y=-0.3, img="healcelestial", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0, beamColor1={0xd8/255, 0xff/255, 0x21/255, 1}, beamColor2={0xf7/255, 0xff/255, 0x9e/255, 1}, circleDescendSpeed=3}))
				eff.src:addParticles(Particles.new("shader_shield_temp", 1, {toback=false,size_factor=1.5, y=-0.3, img="healcelestial", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0, beamColor1={0xd8/255, 0xff/255, 0x21/255, 1}, beamColor2={0xf7/255, 0xff/255, 0x9e/255, 1}, circleDescendSpeed=3}))
			end
		end
	end,
}

newEffect{
	name = "RIGHTEOUS_STRENGTH", image = "talents/righteous_strength.png",
	desc = "Righteous Strength",
	long_desc = function(self, eff) return ("增 加%d%% 物 理 和 光 系 伤 害 。"):format(eff.power) end,
	type = "magical",
	subtype = { sun=true, },
	status = "beneficial",
	parameters = { power = 10 },
	on_gain = function(self, err) return "#Target# shines with light!", "+Righteous Strength" end,
	on_lose = function(self, err) return "#Target# stops shining.", "-Righteous Strength" end,
	charges = function(self, eff) return eff.charges end,
	on_merge = function(self, old_eff, new_eff)
		new_eff.charges = math.min(old_eff.charges + 1, 3)
		new_eff.power = math.min(new_eff.power + old_eff.power, new_eff.max_power)
		self:removeTemporaryValue("inc_damage", old_eff.tmpid)
		new_eff.tmpid = self:addTemporaryValue("inc_damage", {[DamageType.PHYSICAL] = new_eff.power, [DamageType.LIGHT] = new_eff.power})
		return new_eff
	end,
	activate = function(self, eff)
		eff.charges = 1
		eff.tmpid = self:addTemporaryValue("inc_damage", {[DamageType.PHYSICAL] = eff.power, [DamageType.LIGHT] = eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.tmpid)
	end,
}

newEffect{
	name = "LIGHTBURN", image = "talents/righteous_strength.png",
	desc = "Lightburn",
	long_desc = function(self, eff) return ("目 标 被 光 明 灼 烧 ， 每 回 合 受 到 %0.2f 点 光 系 伤 害 ， 同 时 护 甲 降 低 %d。"):format(eff.dam, eff.armor) end,
	type = "magical",
	subtype = { sun=true, },
	status = "detrimental",
	parameters = { armor = 10, dam = 10 },
	on_gain = function(self, err) return "#Target# burns with light!", "+Lightburn" end,
	on_lose = function(self, err) return "#Target# stops burning.", "-Lightburn" end,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the flames!
		local olddam = old_eff.dam * old_eff.dur
		local newdam = new_eff.dam * new_eff.dur
		local dur = math.ceil((old_eff.dur + new_eff.dur) / 2)
		old_eff.dur = dur
		old_eff.dam = (olddam + newdam) / dur
		return old_eff
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_armor", -eff.armor)
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.LIGHT).projector(eff.src, self.x, self.y, DamageType.LIGHT, eff.dam)
	end,
}

newEffect{
	name = "ILLUMINATION",
	desc = "Illumination ", image = "talents/illumination.png",
	long_desc = function(self, eff) return (" 目 标 在 光 明 中 显 形 ， 减 少 %d 潜 行 与 隐 身 强 度 ，减 少 %d 闪 避 ， 同 时 失 去 不 可 见 带 来 的 闪 避 加 成 。"):format(eff.power, eff.def) end,
	type = "magical",
	subtype = { sun=true },
	status = "detrimental",
	parameters = { power=20, def=20 },
	on_gain = function(self, err) return nil, "+Illumination" end,
	on_lose = function(self, err) return nil, "-Illumination" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_stealth", -eff.power)
		if self:attr("invisible") then self:effectTemporaryValue(eff, "invisible", -eff.power) end
		self:effectTemporaryValue(eff, "combat_def", -eff.def)
		self:effectTemporaryValue(eff, "blind_fighted", 1)
	end,
}

newEffect{
	name = "LIGHT_BURST",
	desc = "Light Burst ", image = "talents/light_burst.png",
	long_desc = function(self, eff) return ("当 使 用 灼 烧 时 被 激 发。"):format() end,
	type = "magical",
	subtype = { sun=true },
	status = "beneficial",
	parameters = { max=1 },
	on_gain = function(self, err) return nil, "+Light Burst" end,
	on_lose = function(self, err) return nil, "-Light Burst" end,
}

newEffect{
	name = "LIGHT_BURST_SPEED",
	desc = "Light Burst Speed ", image = "effects/light_burst_speed.png",
	long_desc = function(self, eff) return ("当 使 用 灼 烧 时 被 激 发, 增 加 %d%% 移 动 速 度。"):format(eff.charges * 10) end,
	type = "magical",
	subtype = { sun=true },
	status = "beneficial",
	parameters = {},
	charges = function(self, eff) return eff.charges end,
	on_gain = function(self, err) return nil, "+Light Burst Speed" end,
	on_lose = function(self, err) return nil, "-Light Burst Speed" end,
	on_merge = function(self, old_eff, new_eff)
		local p = self:hasEffect(self.EFF_LIGHT_BURST)
		if not p then p = {max=1} end

		new_eff.charges = math.min(old_eff.charges + 1, p.max)
		self:removeTemporaryValue("movement_speed", old_eff.tmpid)
		new_eff.tmpid = self:addTemporaryValue("movement_speed", new_eff.charges * 0.1)
		return new_eff
	end,
	activate = function(self, eff)
		eff.charges = 1
		eff.tmpid = self:addTemporaryValue("movement_speed", eff.charges * 0.1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("movement_speed", eff.tmpid)
	end,
}

newEffect{
	name = "HEALING_INVERSION",
	desc = "Healing Inversion", image = "talents/healing_inversion.png",
	long_desc = function(self, eff) return ("目 标 受 到 的 所 有 治 疗 会 逆 转 为 %d%% 枯 萎 伤 害."):format(eff.power) end,
	type = "magical",
	subtype = { heal=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return nil, "+Healing Inversion" end,
	on_lose = function(self, err) return nil, "-Healing Inversion" end,
	callbackOnHeal = function(self, eff, value, src)
		local dam = value * eff.power / 100
		DamageType:get(DamageType.BLIGHT).projector(eff.src or self, self.x, self.y, DamageType.BLIGHT, dam)
		return {value=0}
	end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("circle", 1, {oversize=0.7, a=90, appear=8, speed=-2, img="necromantic_circle", radius=0}))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
}

newEffect{
	name = "SHOCKED",
	desc = "Shocked",
	long_desc = function(self, eff) return ("目 标 被 强 力 的 闪 电 所 震 撼 ， 震 慑 与 定 身 免 疫 减 半."):format() end,
	type = "magical",
	subtype = { lightning=true },
	status = "detrimental",
	on_gain = function(self, err) return nil, "+Shocked" end,
	on_lose = function(self, err) return nil, "-Shocked" end,
	activate = function(self, eff)
		if self:attr("stun_immune") then
			self:effectTemporaryValue(eff, "stun_immune", -self:attr("stun_immune") / 2)
		end
		if self:attr("pin_immune") then
			self:effectTemporaryValue(eff, "pin_immune", -self:attr("pin_immune") / 2)
		end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "WET",
	desc = "Wet",
	long_desc = function(self, eff) return ("目 标 全 身 湿 透 了 ， 震 慑 抗 性 减 半 。"):format() end,
	type = "magical",
	subtype = { water=true, ice=true },
	status = "detrimental",
	on_gain = function(self, err) return nil, "+Wet" end,
	on_lose = function(self, err) return nil, "-Wet" end,
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		if self:attr("stun_immune") then
			self:effectTemporaryValue(eff, "stun_immune", -self:attr("stun_immune") / 2)
		end
		eff.particle = self:addParticles(Particles.new("circle", 1, {shader=true, oversize=0.7, a=155, appear=8, speed=0, img="water_drops", radius=0}))
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)
	end,
}

