-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2017 Nicolas Casalini
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
local Entity = require "engine.Entity"
local Chat = require "engine.Chat"
local Map = require "engine.Map"
local Level = require "engine.Level"

local function floorEffect(t)
	t.name = t.name or t.desc
	t.name = t.name:upper():gsub("[ ']", "_")
	local d = t.long_desc
	if type(t.long_desc) == "string" then t.long_desc = function() return d end end
	t.type = "other"
	t.subtype = { floor=true }
	t.status = "neutral"
	t.on_gain = function(self, err) return nil, "+"..t.desc end
	t.on_lose = function(self, err) return nil, "-"..t.desc end

	newEffect(t)
end

floorEffect{
	desc = "Icy Floor", image = "talents/ice_storm.png",
	long_desc = [[目 标 行 走 在 冰 面 上。 增 加 20％ 移 动 速 度， 提 供 20％ 的 冰 冷 伤 害 穿 透， 同 时 减 少 30％ 的 震 慑 免 疫。]],
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists_pen", {[DamageType.COLD] = 20})
		self:effectTemporaryValue(eff, "movement_speed", 0.2)
		self:effectTemporaryValue(eff, "stun_immune", -0.3)
	end,
}

floorEffect{
	desc = "Font of Life", image = "talents/grand_arrival.png",
	long_desc = function(self, eff) return ([[目 标 靠 近 生 命 之 泉， 增 加 +%0.2f 生 命 回 复， +%0.2f 失 衡 值 回 复， +%0.2f 体 力 回 复 和 +%0.2f 超 能 力 回 复。 不 死 族 无 法 获 得 此 效 果。]]):format(eff.power, eff.equilibrium, eff.stamina, eff.psi) end,
	parameters = {power=1, equilibrium=0, stamina=0, psi=0},
	activate = function(self, eff)
		if not self:checkClassification("living") then eff.power = 0 return end
		eff.power = 3 + game.zone:level_adjust_level(game.level, game.zone, "object") / 2
		eff.psi = (eff.power/5)^.75
		eff.stamina = eff.psi
		eff.equilibrium = -eff.psi
		self:effectTemporaryValue(eff, "life_regen", eff.power)
		self:effectTemporaryValue(eff, "stamina_regen", eff.stamina)
		self:effectTemporaryValue(eff, "psi_regen", eff.psi)
		self:effectTemporaryValue(eff, "equilibrium_regen", eff.equilibrium)
	end,
}

floorEffect{
	desc = "Spellblaze Scar", image = "talents/blood_boil.png",
	long_desc = [[目 标 接 近 奥 术 之 痕， 获 得 25％ 法 术 暴 击 率， 增 加 10％ 火 焰 和 枯 萎 伤 害， 但 是 法 术 暴 击 会 消 耗 法 力 值。]],
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_spellcrit", 25)
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.FIRE]=10,[DamageType.BLIGHT]=10})
		self:effectTemporaryValue(eff, "mana_on_crit", -15)
		self:effectTemporaryValue(eff, "vim_on_crit", -10)
		self:effectTemporaryValue(eff, "paradox_on_crit", 20)
		self:effectTemporaryValue(eff, "positive_on_crit", -10)
		self:effectTemporaryValue(eff, "negative_on_crit", -10)
	end,
}

floorEffect{
	desc = "Blighted Soil", image = "talents/blightzone.png",
	long_desc = [[目 标 行 走 在 荒 芜 之 地 上， 减 少 60％ 疾 病 抵 抗 并 且 对 目 标 的 所 有 攻 击 有 40％ 的 几 率 使 其 感 染 某 种 疾 病。（ 每 回 合 只 能 触 发 一 次）]],
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "disease_immune", -0.6)
		self:effectTemporaryValue(eff, "blighted_soil", 40)
	end,
}

floorEffect{
	desc = "Glimmerstone", image = "effects/dazed.png", name = "DAZING_DAMAGE",
	long_desc = "目 标 被 闪 光 石 影 响， 它 的 下 一 次 攻 击 可 能 造 成 眩 晕。",
	activate = function(self, eff)
	end,
}

floorEffect{
	desc = "Protective Aura", image = "talents/barrier.png",
	long_desc = function(self, eff) return ([[目 标 靠 近 防 御 光 环， 获 得 +%d 点 护 甲 和 +%d 物 理 豁 免。]]):format(eff.armor, eff.power) end,
	parameters = {power=1, armor=1},
	activate = function(self, eff)
		local power = 3 + game.zone:level_adjust_level(game.level, game.zone, "object") / 2
		eff.power = power
		eff.armor = power^.75
		self:effectTemporaryValue(eff, "combat_armor", eff.power)
		self:effectTemporaryValue(eff, "combat_physresist", eff.armor)
	end,
}

floorEffect{
	desc = "Antimagic Bush", image = "talents/fungal_growth.png",
	long_desc = function(self, eff) return ([[目 标 靠 近 反 魔 灌 木， 增 加 20％ 自 然 伤 害， 20％ 自 然 抵 抗 穿 透。 同 时 -%d 法 术 强 度。]]):format(eff.power) end,
	activate = function(self, eff)
		eff.power = 10 + game.zone:level_adjust_level(game.level, game.zone, "object") / 1.5
		self:effectTemporaryValue(eff, "combat_spellpower", -eff.power)
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.NATURE]=20})
		self:effectTemporaryValue(eff, "resists_pen", {[DamageType.NATURE]=20})
	end,
}

floorEffect{
	desc = "Necrotic Air", image = "talents/repression.png",
	long_desc = [[目 标 位 于 死 灵 瘴 气 中， 减 少 40％ 治 疗 效 果。 不 死 族 则 增 加 15％ 所 有 抵 抗。]],
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "healing_factor", -0.4)
		if self:attr("undead") then self:effectTemporaryValue(eff, "resists", {all=15}) end
	end,
}

floorEffect{
	desc = "Whistling Vortex", image = "talents/shadow_blast.png",
	long_desc = function(self, eff) return ([[目 标 靠 近 尖 啸 漩 涡， 增 加 +%d 远 程 闪 避， 同 时 -%d 远 程 命 中， 并 且 抛 射 物 减 缓 30％。]]):format(eff.power, eff.power) end,
	activate = function(self, eff)
		eff.power = 10 + game.zone:level_adjust_level(game.level, game.zone, "object") / 2
		self:effectTemporaryValue(eff, "combat_def_ranged", eff.power)
		self:effectTemporaryValue(eff, "combat_atk_ranged", -eff.power)
		self:effectTemporaryValue(eff, "slow_projectiles", 30)
	end,
}

floorEffect{
	desc = "Fell Aura", image = "talents/shadow_mages.png",
	long_desc = [[目 标 被 毁 灭 光 环 所 包 围， 增 加 40％ 暴 击 伤 害， 同 时 减 少 20％ 所 有 抵 抗。]],
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_critical_power", 40)
		self:effectTemporaryValue(eff, "resists", {all=-20})
	end,
}

floorEffect{
	desc = "Slimey Pool", image = "talents/acidic_skin.png",
	long_desc = [[目 标 行 走 在 史 莱 姆 上。 减 少 20％ 移 动 速 度 并 对 任 何 攻 击 它 的 目 标 造 成 20 点 史 莱 姆 伤 害。]],
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "on_melee_hit", {[DamageType.SLIME] = 20})
		self:effectTemporaryValue(eff, "movement_speed", -0.2)
	end,
}
