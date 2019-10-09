-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2019 Nicolas Casalini
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
	long_desc = [[目标行走在冰面上。增加 20％移动速度，提供 20％的冰冷伤害穿透，同时减少 30％的震慑免疫。]],
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists_pen", {[DamageType.COLD] = 20})
		self:effectTemporaryValue(eff, "movement_speed", 0.2)
		self:effectTemporaryValue(eff, "stun_immune", -0.3)
	end,
}

floorEffect{
	desc = "Font of Life", image = "talents/grand_arrival.png",
	long_desc = function(self, eff) return ([[目标靠近生命之泉，增加 +%0.2f 生命回复， +%0.2f 失衡值回复， +%0.2f 体力回复和 +%0.2f 超能力回复。不死族无法获得此效果。]]):format(eff.power, eff.equilibrium, eff.stamina, eff.psi) end,
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
	long_desc = [[目标接近奥术之痕，获得 25％法术暴击率，增加 10％火焰和枯萎伤害，但是法术暴击会消耗法力值。]],
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
	long_desc = [[目标行走在荒芜之地上，减少 60％疾病抵抗并且对目标的所有攻击有 40％的几率使其感染某种疾病。（每回合只能触发一次）]],
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "disease_immune", -0.6)
		self:effectTemporaryValue(eff, "blighted_soil", 40)
	end,
}

floorEffect{
	desc = "Glimmerstone", image = "effects/dazed.png", name = "DAZING_DAMAGE",
	long_desc = "目标被闪光石影响，它的下一次攻击可能造成眩晕。",
	activate = function(self, eff)
	end,
}

floorEffect{
	desc = "Protective Aura", image = "talents/barrier.png",
	long_desc = function(self, eff) return ([[目标靠近防御光环，获得 +%d 点护甲和 +%d 物理豁免。]]):format(eff.armor, eff.power) end,
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
	long_desc = function(self, eff) return ([[目标靠近反魔灌木，增加 20％自然伤害， 20％自然抵抗穿透。同时 -%d 法术强度。]]):format(eff.power) end,
	activate = function(self, eff)
		eff.power = 10 + game.zone:level_adjust_level(game.level, game.zone, "object") / 1.5
		self:effectTemporaryValue(eff, "combat_spellpower", -eff.power)
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.NATURE]=20})
		self:effectTemporaryValue(eff, "resists_pen", {[DamageType.NATURE]=20})
	end,
}

floorEffect{
	desc = "Necrotic Air", image = "talents/repression.png",
	long_desc = [[目标位于死灵瘴气中，减少 40％治疗效果。不死族则增加 15％所有抵抗。]],
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "healing_factor", -0.4)
		if self:attr("undead") then self:effectTemporaryValue(eff, "resists", {all=15}) end
	end,
}

floorEffect{
	desc = "Whistling Vortex", image = "talents/shadow_blast.png",
	long_desc = function(self, eff) return ([[目标靠近尖啸漩涡，增加 +%d 远程闪避，同时 -%d 远程命中，并且抛射物减缓 30％。]]):format(eff.power, eff.power) end,
	activate = function(self, eff)
		eff.power = 10 + game.zone:level_adjust_level(game.level, game.zone, "object") / 2
		self:effectTemporaryValue(eff, "combat_def_ranged", eff.power)
		self:effectTemporaryValue(eff, "combat_atk_ranged", -eff.power)
		self:effectTemporaryValue(eff, "slow_projectiles", 30)
	end,
}

floorEffect{
	desc = "Fell Aura", image = "talents/shadow_mages.png",
	long_desc = [[目标被毁灭光环所包围，增加 40％暴击伤害，同时减少 20％所有抵抗。]],
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_critical_power", 40)
		self:effectTemporaryValue(eff, "resists", {all=-20})
	end,
}

floorEffect{
	desc = "Slimey Pool", image = "talents/acidic_skin.png",
	long_desc = [[目标行走在史莱姆上。减少 20％移动速度并对任何攻击它的目标造成 20 点史莱姆伤害。]],
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "on_melee_hit", {[DamageType.SLIME] = 20})
		self:effectTemporaryValue(eff, "movement_speed", -0.2)
	end,
}
