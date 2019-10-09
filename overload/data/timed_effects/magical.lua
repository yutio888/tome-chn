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
local Shader = require "engine.Shader"
local Entity = require "engine.Entity"
local Chat = require "engine.Chat"
local Map = require "engine.Map"
local Level = require "engine.Level"

---------- Item specific 


-- Use a word other than disease because diseases are associated with damage
-- Add dummy power/dam parameters to try to stay in line with other diseases for subtype checks
newEffect{
	name = "ITEM_BLIGHT_ILLNESS", image = "talents/decrepitude_disease.png",
	desc = "Illness",
	long_desc = function(self, eff) return ("目标被疾病感染，减少敏捷、力量、体质各 %d 点 ."):format(eff.reduce) end,
	charges = function(self, eff) return (tostring(math.floor(eff.reduce))) end,
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
		self:removeTemporaryValue("inc_stats", eff.tmpid) eff.tmpid = nil
	end,
}


newEffect{
	name = "ITEM_ACID_CORRODE", image = "talents/acidic_skin.png",
	desc = "Armor Corroded",
	long_desc = function(self, eff) return ("目标被酸液覆盖，护甲减少 %d%%（#RED#%d#LAST#）."):format(eff.pct*100 or 0, eff.reduce or 0) end,
	charges = function(self, eff) return (tostring(math.floor(eff.reduce))) end,
	type = "magical",
	subtype = { acid=true, sunder=true },
	status = "detrimental",
	parameters = {pct = 0.3},
	on_gain = function(self, err) return "#Target#'s armor corrodes!" end,
	on_lose = function(self, err) return "#Target# is fully armored again." end,
	on_timeout = function(self, eff)
	end,
	activate = function(self, eff)
		local armor = math.max(0, self.combat_armor * eff.pct)
		eff.reduce = armor
		self:effectTemporaryValue(eff, "combat_armor", -armor)
	end,
	deactivate = function(self, eff)

	end,
}

newEffect{
	name = "MANASURGE", image = "talents/rune__manasurge.png",
	desc = "Surging mana",
	long_desc = function(self, eff) return ("法力潮汐淹没目标，每回合回复 %0.2f 法力值。"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("法力溢出，提升你的法力上限 %d%% 。"):format(eff.power) end,
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
	long_desc = function(self, eff) return "目标被石化，受到超过 30% 最大生命的伤害将被击碎，但提高物理抵抗（ +20% ）火焰抵抗（ + 80% ）和闪电抵抗（ + 50% ）。" end,
	type = "magical",
	subtype = { earth=true, stone=true, stun = true},
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# turns to #GREY#STONE#LAST#!", "+Stoned" end,
	on_lose = function(self, err) return "#Target# is no longer a #GREY#statue#LAST#.", "-Stoned" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("stoned", 1)
		eff.poison = self:addTemporaryValue("poison_immune", 1)
		eff.cut = self:addTemporaryValue("cut_immune", 1)
		eff.never_move = self:addTemporaryValue("never_move", 1)
		eff.breath = self:addTemporaryValue("no_breath", 1)
		eff.resistsid = self:addTemporaryValue("resists", {
			[DamageType.PHYSICAL]=20,
			[DamageType.FIRE]=80,
			[DamageType.LIGHTNING]=50,}
			)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("stoned", eff.tmpid)
		self:removeTemporaryValue("poison_immune", eff.poison)
		self:removeTemporaryValue("cut_immune", eff.cut)
		self:removeTemporaryValue("never_move", eff.never_move)
		self:removeTemporaryValue("no_breath", eff.breath)
		self:removeTemporaryValue("resists", eff.resistsid)
	end,
}

newEffect{
	name = "ARCANE_STORM", image = "talents/disruption_shield.png",
	desc = "Arcane Storm",
	long_desc = function(self, eff) return ("目标处于巨大奥术风暴的中心，提供 +%d%% 奥术抵抗。"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("减少物理伤害 %d%% 。"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("减少火焰伤害 %d%% 。"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("反射 %d%% 魔法伤害。"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("降低枯萎抵抗 %d%% ，所有豁免 %d 。"):format(eff.power, eff.saves) end,
	type = "magical",
	subtype = { blight=true },
	status = "detrimental",
	parameters = { power=10, saves=0 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {[DamageType.BLIGHT]=-eff.power})
		self:effectTemporaryValue(eff, "combat_mindresist",  -eff.saves)
		self:effectTemporaryValue(eff, "combat_spellresist", -eff.saves)
		self:effectTemporaryValue(eff, "combat_physresist", -eff.saves)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "INVISIBILITY", image = "effects/invisibility.png",
	desc = "Invisibility",
	long_desc = function(self, eff) return ("提升 / 获得隐形状态（ %d 隐形等级），减少其所造成的伤害%d%%%s。"):format(eff.power, eff.penalty*100, eff.regen and "并阻止治疗生命回复" or "") end,
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
	name = "ETHEREAL", image = "effects/invisibility.png",
	desc = "Ethereal",
	long_desc = function(self, eff) return ("隐形 ( 隐形等级 %d), 造成的伤害减少 %d%%, 所有抗性增加 %d%%, 移动速度增加 %d%%."):
		format(eff.power, eff.reduction * 100, eff.resist, eff.move) end,
	type = "magical",
	subtype = { phantasm=true },
	status = "beneficial",
	parameters = { power=10, resist=0, reduction=0, move=0},
	on_gain = function(self, err) return "#Target# becomes ethereal.", "+Ethereal" end,
	on_lose = function(self, err) return "#Target# is no longer ethereal.", "-Ethereal" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("invisible", eff.power)
		eff.penaltyid = self:addTemporaryValue("invisible_damage_penalty", eff.reduction)
		eff.damid = self:addTemporaryValue("resists", {all = eff.resist})
		eff.moveid = self:addTemporaryValue("movement_speed", eff.move / 100)

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
		self:removeTemporaryValue("resists", eff.damid)
		self:removeTemporaryValue("movement_speed", eff.moveid)
		self:resetCanSeeCacheOf()
	end,
}

newEffect{
	name = "STORMSHIELD", image = "talents/rune__lightning.png",
	desc = "Stormshield",
	long_desc = function(self, eff) return ("单位被一团风暴保护，可转移来自 %d 个目标的超过 %d 的伤害。"):
		format(eff.blocks, eff.threshold) end,
	type = "magical",
	subtype = { lightning=true, shield=true },
	status = "beneficial",
	charges = function(self, eff) return eff.blocks end,
	parameters = {threshold = 1, blocks = 1,},
	on_gain = function(self, err) return "#Target# summons a storm to protect him!", "+Stormshield" end,
	on_lose = function(self, err) return "#Target#'s storm dissipates.", "-Stormshield" end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
	callbackOnTakeDamage = function(self, eff, src, x, y, type, dam, state)
		if dam < eff.threshold then return end
		local d_color = DamageType:get(type).text_color or "#ORCHID#"
		game:delayedLogDamage(src, self, 0, ("%s(%d stormshielded#LAST#%s)#LAST#"):format(d_color, dam, d_color), false)
		eff.blocks = eff.blocks - 1
		if eff.blocks <= 0 then
			src:logCombat(self, "#BLUE##Target#'s stormshield is out of charges and disspitates!#LAST#.")
			self:removeEffect(self.EFF_STORMSHIELD)
		end
		return {dam = 0}
	end,
}

newEffect{
	name = "PRISMATIC_SHIELD", image = "talents/ward.png",
	desc = "Prismatic Shield",
	long_desc = function(self, eff)
		local str = ""
		for k,v in pairs(eff.wards) do
			str = str .. ", " .. v .. " " .. k:lower()
		end
		str = string.sub(str, 2)
		return ("目标受到棱彩护盾的保护，可以阻挡许多伤害。剩余时间:  %s"):format(str) -- add tooltip
	end,
	type = "magical",
	subtype = { ward=true, },
	status = "beneficial",
	parameters = { wards = {} },
	on_gain = function(self, err) return "#Target# summons a prismatic shield to protect him!", "+Prismatic" end,
	on_lose = function(self, err) return "#Target#'s prismatic shield fades.", "-Prismatic" end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
	callbackOnTakeDamage = function(self, eff, src, x, y, type, dam, state)
		if dam <= 0 then return end
		for k,v in pairs(eff.wards) do
			if k == type then
				local d_color = DamageType:get(type).text_color or "#ORCHID#" -- fix display
				game:delayedLogDamage(src, self, 0, ("%s(%d to prism#LAST#%s)#LAST#"):format(d_color, dam, d_color), false)
				eff.wards[k] = eff.wards[k] - 1
				if eff.wards[k] <= 0 then eff.wards[k] = nil end
				return {dam = 0}
			end
		end
		return {dam=dam}
	end,
}

newEffect{
	name = "PURGING", image = "talents/willful_tormenter.png", -- re-used icon
	desc = "PURGING",
	long_desc = function(self, eff) return ("目标每回合清除一项物理负面状态。"):
		format() end,
	type = "magical",
	subtype = { arcane=true, },
	status = "beneficial",
	parameters = {},
	on_gain = function(self, err) return "#Target# is being purged of his physical ailments!", "+Purging" end,
	on_lose = function(self, err) return "#Target#'s is no longer being purged.", "-Purging" end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
	on_timeout = function(self, eff)
		local cleanse = self:removeEffectsFilter({type="physical", status="detrimental"}, 1)
		if cleanse > 0 then eff.dur = eff.dur + 1 end
	end,
}
newEffect{
	name = "VIMSENSE_DETECT", image = "talents/vimsense.png",
	desc = "Sensing (Vim)",
	long_desc = function(self, eff) return "强化感知，能侦察到不可见目标." end,
	type = "magical",
	subtype = { sense=true, corruption=true },
	status = "beneficial",
	parameters = { range=10, actor=1, object=0, trap=0 },
	activate = function(self, eff)
		if core.shader.active() then
			self:effectParticles(eff, {type="shader_shield", args={toback=true,  size_factor=1.5, img="05_vimsense"}, shader={type="tentacles", appearTime=0.6, time_factor=1000, noup=2.0}})
			self:effectParticles(eff, {type="shader_shield", args={toback=false, size_factor=1.5, img="05_vimsense"}, shader={type="tentacles", appearTime=0.6, time_factor=1000, noup=1.0}})
		end
		eff.rid = self:addTemporaryValue("detect_range", eff.range)
		eff.aid = self:addTemporaryValue("detect_actor", eff.actor)
		eff.oid = self:addTemporaryValue("detect_object", eff.object)
		eff.tid = self:addTemporaryValue("detect_trap", eff.trap)
		self.detect_function = eff.on_detect
		game.level.map.changed = true
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("detect_range", eff.rid)
		self:removeTemporaryValue("detect_actor", eff.aid)
		self:removeTemporaryValue("detect_object", eff.oid)
		self:removeTemporaryValue("detect_trap", eff.tid)
		self.detect_function = nil
	end,
}

newEffect{
	name = "SENSE_HIDDEN", image = "talents/keen_senses.png",
	desc = "Sense Hidden",
	long_desc = function(self, eff) return ("提升 / 获得侦测隐形或者潜行生物（ %d 侦测等级）"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("目标被致盲，不能看到任何东西并每回合受到 %0.2f 暗影伤害。"):format(eff.dam) end,
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
	long_desc = function(self, eff) return ("目标处于混乱，随机行动 ( %d%% 几率 )，不能完成复杂的动作，每回合受到 %0.2f 暗影伤害。"):format(eff.power, eff.dam) end,
	charges = function(self, eff) return (tostring(math.floor(eff.power)).."%") end,	
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
	long_desc = function(self, eff) return ("目标被超载，增加 %0.2f 生命回复并增加 20％伤害。"):format(eff.regen) end,
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
	long_desc = function(self, eff) return ("目标辐射出超强的力量，提升 %d%% 所有伤害。"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("目标发掘血液中的隐藏力量，将其造成伤害的 %d%% 转化为治疗。"):format(eff.power) end,
	type = "magical",
	subtype = { blight=true },
	status = "beneficial",
	parameters = { power=0 },
	on_gain = function(self, err) return "#Target# looks healthier as he deals damage.", "+Life Tap" end,
	on_lose = function(self, err) return "#Target# stops leeching life.", "-Life Tap" end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
	callbackOnDealDamage = function(self, eff, value, target, dead, death_node)
		-- Lifesteal done here to avoid stacking in bad ways with other LS effects
		if value <= 0 or not target then return end
			local leech = math.min(value, target.life) * eff.power / 100
			if leech > 0 then
				self:heal(leech, self)
			end
	end,
}

newEffect{
	name = "ARCANE_EYE", image = "talents/arcane_eye.png",
	desc = "Arcane Eye",
	long_desc = function(self, eff) return ("你召唤奥术之眼侦查 %d 码区域。"):format(eff.radius) end,
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
	long_desc = function(self, eff) return "奥术之眼发现了该生物。" end,
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
	long_desc = function(self, eff) return ("目标所有基础属性提升 %d 。"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("目标被一层扭曲空间包围， %d%% 几率偏转伤害至另一目标（ %s ）。吸收 %d/%d 伤害。"):format(eff.chance, eff.target and eff.target.name or "unknown", self.displacement_shield, eff.power) end,
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
	long_desc = function(self, eff) return ("目标被一层魔法护盾（ %d / %d ）包围。"):format(self.damage_shield_absorb, eff.power, ((self.damage_shield_reflect and self.damage_shield_reflect > 0) and ("(反射 %d%% 伤害给攻击者 )"):format(self.damage_shield_reflect) or "")) end,
	type = "magical",
	subtype = { arcane=true, shield=true },
	status = "beneficial",
	parameters = { power=100 },
	charges = function(self, eff) return math.ceil(self.damage_shield_absorb) end,
	on_gain = function(self, err) return "A shield forms around #target#.", "+Shield" end,
	on_lose = function(self, err) return "The shield around #target# crumbles.", "-Shield" end,
	on_merge = function(self, old_eff, new_eff)
		local new_eff_adj = {} -- Adjust for shield modifiers
		if self:attr("shield_factor") then
			new_eff_adj.power = new_eff.power * (100 + self:attr("shield_factor")) / 100
		else
			new_eff_adj.power = new_eff.power
		end
		if self:attr("shield_dur") then
			new_eff_adj.dur = new_eff.dur + self:attr("shield_dur")
		else
			new_eff_adj.dur = new_eff.dur
		end
		-- If the new shield would be stronger than the existing one, just replace it
		if old_eff.dur > new_eff_adj.dur then return old_eff end
		if math.max(self.damage_shield_absorb, self.damage_shield_absorb_max) <= new_eff_adj.power then
			self:removeEffect(self.EFF_DAMAGE_SHIELD)
			self:setEffect(self.EFF_DAMAGE_SHIELD, new_eff.dur, new_eff)
			return self:hasEffect(self.EFF_DAMAGE_SHIELD)
		end
		if self.damage_shield_absorb <= new_eff_adj.power then
			-- Don't update a reflection shield with a normal shield
			if old_eff.reflect and not new_eff.reflect then
				return old_eff
			elseif old_eff.reflect and new_eff.reflect and math.min(old_eff.reflect, new_eff.reflect) > 0 then
				old_eff.reflect = math.min(old_eff.reflect, new_eff.reflect)
				if self:attr("damage_shield_reflect") then
					self:attr("damage_shield_reflect", old_eff.reflect, true)
				else
					old_eff.refid = self:addTemporaryValue("damage_shield_reflect", old_eff.reflect)
				end
			end
			-- Otherwise, keep the existing shield for use with Aegis, but update absorb value and maybe duration
			self.damage_shield_absorb = new_eff_adj.power -- Use adjusted values here since we bypass setEffect()
			if not old_eff.dur_extended or old_eff.dur_extended <= 20 then
				old_eff.dur = new_eff_adj.dur
				if not old_eff.dur_extended then
					old_eff.dur_extended = 1
				else
					old_eff.dur_extended = old_eff.dur_extended + 1
				end
			end
		end
		return old_eff
	end,
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
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.3, img=eff.aegis_image or "runicshield"}, {type="runicshield", shieldIntensity=0.14, ellipsoidalFactor=1.2, time_factor=5000, bubbleColor=bc, auraColor=ac}))
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
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {img=eff.image or "shield7"}, {type="shield", shieldIntensity=0.2, color=eff.color or {0.4, 0.7, 1.0}}))
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
	long_desc = function(self, eff) return ("目标造成伤害的同时对自身造成 %d%% 伤害。"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("你身边的光亮变得暗淡了，光照半径降低到1码。"):format() end,
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
	long_desc = function(self, eff) return ("目标被诅咒，所有抵抗降低 %d%% 。"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("目标被诅咒，所有伤害降低 %d%% 。"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("目标被诅咒，降低闪避和所有豁免 %d 。"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("目标被诅咒，每回合受到 %0.2f 暗影伤害并停止自然生命回复。"):format(eff.dam) end,
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
	long_desc = function(self, eff) return ("目标被诅咒，强制所有 5 码内目标攻击他。") end,
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
	name = "CORRUPTING_STRIKE", image = "talents/dark_surprise.png",
	desc = "Corrupting Strike",
	long_desc = function(self, eff) return ("The targets natural essence in corrupted reducing disease resistance by 100%%."):format() end,
	type = "magical",
	subtype = {blight=true},
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is completely vulnerable to disease!" end,
	on_lose = function(self, err) return "#Target# no longer vulnerable to disease." end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "disease_immune", -1)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "BLOODLUST", image = "talents/bloodlust.png",
	desc = "Bloodlust",
	long_desc = function(self, eff) return ("目标进入魔法狂暴状态，提升法术强度 %d 。"):format(eff.spellpower * eff.stacks) end,
	type = "magical",
	subtype = { frenzy=true },
	status = "beneficial",
	charges = function(self, eff) return math.floor(eff.spellpower * eff.stacks) end,
	parameters = { spellpower=1, stacks=1, max_stacks=1 },
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		old_eff.stacks = old_eff.stacks + 1
		old_eff.max_stacks = new_eff.max_stacks
		old_eff.stacks = math.min(old_eff.max_stacks, old_eff.stacks)
		return old_eff
	end,
	activate = function(self, eff)
		eff.stacks = 1
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ACID_SPLASH", image = "talents/acidic_skin.png",
	desc = "Acid Splash",
	long_desc = function(self, eff) return ("目标被酸液飞溅，造成每回合 %0.2f 酸性伤害。降低 %d 护甲值和 %d 伤害。"):format(eff.dam, eff.armor or 0, eff.atk) end,
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
	long_desc = function(self, eff) return ("目标的酸性和枯萎伤害增加 %d%% 。"):format(eff.power) end,
	type = "magical",
	subtype = { frenzy=true },
	status = "beneficial",
	parameters = { power=10 },
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("inc_damage", {[DamageType.BLIGHT] = eff.power, [DamageType.ACID] = eff.power})
		self:effectParticles(eff, {type="perfect_strike", args={radius=0.5, time_factor=6000, img="spinningwinds_blood_fury_triggered"}})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("inc_damage", eff.tmpid)
	end,
}

newEffect{
	name = "PHOENIX_EGG", image = "effects/phoenix_egg.png",
	desc = "Reviving Phoenix",
	long_desc = function(self, eff) return "目标重生。" end,
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
	long_desc = function(self, eff) return ("目标处于闪电飓风中心，使自身和周围目标每回合受到 %0.2f ～ %0.2f 闪电伤害。"):format(eff.dam / 3, eff.dam) end,
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
	name = "TELEPORT_ANGOLWEN", image = "talents/teleport_angolwen.png",
	desc = "Teleport: Angolwen",
	long_desc = function(self, eff) return "目标等待被传送至安格利文。" end,
	type = "magical",
	subtype = { teleport=true },
	status = "beneficial",
	cancel_on_level_change = true,
	parameters = { },
	activate = function(self, eff)
		eff.leveid = game.zone.short_name.."-"..game.level.level
	end,
	deactivate = function(self, eff)
		if self ~= game:getPlayer(true) then return end
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
	long_desc = function(self, eff) return "目标等待被传送回零点圣域。" end,
	type = "magical",
	subtype = { timeport=true },
	status = "beneficial",
	cancel_on_level_change = true,
	parameters = { },
	activate = function(self, eff)
		eff.leveid = game.zone.short_name.."-"..game.level.level
	end,
	deactivate = function(self, eff)
		if self ~= game:getPlayer(true) then return end
		local seen = false
		-- Check for visible monsters, only see LOS actors, so telepathy wont prevent it
		core.fov.calc_circle(self.x, self.y, game.level.map.w, game.level.map.h, 20, function(_, x, y) return game.level.map:opaque(x, y) end, function(_, x, y)
			local actor = game.level.map(x, y, game.level.map.ACTOR)
			if actor and actor ~= self then
				if actor.summoner and actor.summoner == self then
					seen = false
				else
					seen = true
				end
			end
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
	long_desc = function(self, eff) return ("降低受到的 %s 伤害 %d%% 。"):format(DamageType:get(eff.damtype).name, eff.resist) end,
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
	long_desc = function(self, eff) return ("目标被腐蚀蠕虫感染，减少 %d%% 酸性和枯萎抗性，效果结束后，蠕虫团将爆炸，在半径 4 范围内造成 %d 酸性伤害。在该效果下受到伤害的 %d%% 将被加成至爆炸伤害中。"):format(eff.power, eff.finaldam, eff.rate*100) end,
	type = "magical",
	subtype = { acid=true },
	status = "detrimental",
	parameters = { power=20, rate=10, finaldam=50, },
	on_gain = function(self, err) return "#Target# is infected by a corrosive worm.", "+Corrosive Worm" end,
	on_lose = function(self, err) return "#Target# is free from the corrosive worm.", "-Corrosive Worm" end,
	activate = function(self, eff)
		eff.particle = self:addParticles(Particles.new("circle", 1, {base_rot=0, oversize=0.7, a=255, appear=8, speed=0, img="blight_worms", radius=0}))
		self:effectTemporaryValue(eff, "resists", {[DamageType.BLIGHT]=-eff.power, [DamageType.ACID]=-eff.power})
	end,
	deactivate = function(self, eff)
		local tg = {type="ball", radius=4, selffire=false, x=self.x, y=self.y}
		eff.src:project(tg, self.x, self.y, DamageType.ACID, eff.finaldam, {type="acid"})
		self:removeParticles(eff.particle)
	end,
	callbackOnHit = function(self, eff, cb)
		eff.finaldam = eff.finaldam + (cb.value * eff.rate)
		return true
	end,

	on_die = function(self, eff)
		local tg = {type="ball", radius=4, selffire=false, x=self.x, y=self.y}
		eff.src:project(tg, self.x, self.y, DamageType.ACID, eff.finaldam, {type="acid"})
	end,
}

newEffect{
	name = "WRAITHFORM", image = "talents/wraithform.png",
	desc = "Wraithform",
	long_desc = function(self, eff) return ("进入幽灵形态，可以穿墙（但不能穿过其他障碍物），获得 %d 闪避和 %d 护甲值。"):format(eff.def, eff.armor) end,
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
		self:effectTemporaryValue(eff, "no_breath", 1)
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
	long_desc = function(self, eff) return ("提升目标受到的所有治疗效果 %d%% 。"):format(eff.power * 100) end,
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
	long_desc = function(self, eff) return ("目标受到保护，每回合解除一项负面效果。"):format() end,
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
		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1.5, y=-0.3, img="healcelestial"}, {type="healing", time_factor=4000, noup=2.0, beamColor1={0xd8/255, 0xff/255, 0x21/255, 1}, beamColor2={0xf7/255, 0xff/255, 0x9e/255, 1}, circleColor={0,0,0,0}, beamsCount=5}))
			eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1.5, y=-0.3, img="healcelestial"}, {type="healing", time_factor=4000, noup=1.0, beamColor1={0xd8/255, 0xff/255, 0x21/255, 1}, beamColor2={0xf7/255, 0xff/255, 0x9e/255, 1}, circleColor={0,0,0,0}, beamsCount=5}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
	end,
}

newEffect{
	name = "SOLAR_INFUSION", image = "talents/sun_flare.png",
	desc = "Solar Infusion",
	long_desc = function(self, eff) return ("The target's light, darkness, and fire resistance has been increased by %d%%."):format(eff.resist) end,
	type = "magical",
	subtype = { },
	status = "beneficial",
	parameters = { resist=10 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {
			[DamageType.DARKNESS] = eff.resist,
			[DamageType.LIGHT] = eff.resist,
			[DamageType.FIRE] = eff.resist,

		})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "TOTALITY", image = "talents/totality.png",
	desc = "Totality",
	long_desc = function(self, eff) return ("目标的光系和黑暗法术穿透增加 %d%% 。"):format(eff.power) end,
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

newEffect{
	name = "DIVINE_GLYPHS", image = "talents/glyph_of_explosion.png",
	desc = "Divine Glyphs",
	long_desc = function(self, eff)
		return ("A divine glyph recently triggered, providing %d%% light and darkness affinity and resistence."):format(math.min(eff.maxStacks, eff.glyphstacks or 1)*5)
	end,
	type = "magical",
	subtype = {light=true, darkness=true},
	status = "beneficial",
	paramters ={},
	activate = function(self, eff)
		local power = math.min(eff.maxStacks, eff.glyphstacks or 1)*5
		self:effectTemporaryValue(eff, "damage_affinity", {[DamageType.LIGHT]=power, [DamageType.DARKNESS]=power})
		self:effectTemporaryValue(eff, "resists", {[DamageType.LIGHT]=power, [DamageType.DARKNESS]=power})
	end,
	on_merge = function(self, old_eff, new_eff)
		old_eff.glyphstacks = (old_eff.glyphstacks or 0) + 1
		old_eff.dur = new_eff.dur
		return old_eff
	end,
}

newEffect{
	name = "STARLIGHT_FATIGUE", image = "talents/glyph_of_fatigue.png",
	desc = "Fatiguing Starlight",
	long_desc = function(self, eff)
		return ("Inflicted with a fatiguing starlight, taking %d darkness damage and increasing the cooldown of a cooling-down talent by 1 whenever they act"):format(eff.src.summoner:damDesc(DamageType.DARKNESS, eff.dam))
	end,
	type = "magical",
	subtype = {darkness = true},
	status = "detrimental",
	paramters = {},
	callbackOnAct = function(self, eff)
		DamageType:get(DamageType.DARKNESS).projector(eff.src, self.x, self.y, DamageType.DARKNESS, eff.dam)
		local tids = {}
		for tid, lev in pairs(self.talents) do
			local t = self:getTalentFromId(tid)
			if t and self.talents_cd[tid] and not t.fixed_cooldown then tids[#tids+1] = t end
			local t2 = rng.tableRemove(tids)
			if t2 then self.talents_cd[t2.id] = self.talents_cd[t2.id] + 1 end
		end
	end,
}

newEffect{
	name = "SUNBURST", image = "talents/sunburst.png",
	desc = "Sunburst",
	long_desc = function(self, eff)
		return ("Light damage has been increased by %d%% to +%d%%."):format(eff.damInc, self.inc_damage.LIGHT)
	end,
	type = "magical",
	subtype = {light=true, darkness=true},
	status = "beneficial",
	paramters ={},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.LIGHT]=eff.damInc})
	end,
}

newEffect{
	name = "DARKLIGHT", image = "talents/darkest_light.png",
	desc = "Shrouded in Darklight",
	long_desc = function(self, eff)
		return ("%d%% of the targets damage is being split between light and darkness and they are taking %d light and %d darkness damage each turn."):format(eff.conversion * 100, eff.src:damDesc(DamageType.LIGHT, eff.dotDam), eff.src:damDesc(DamageType.DARKNESS, eff.dotDam))
	end,
	type = "magical",
	subtype = {light=true, darkness=true},
	status = "detrimental",
	paramters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "darklight", eff.conversion)
		if core.shader.active() then
			eff.particle1 = self:addParticles(Particles.new("shader_ring_rotating", 1, {rotation=0.5, a=0.4, radius=0.8, img="healdark"}))
			eff.particle2 = self:addParticles(Particles.new("shader_ring_rotating", 1, {rotation=0.5, a=0.4, radius=0.6, img="healcelestial"}))
		end
	end,
	deactivate = function(self, eff)
		if eff.particle1 then self:removeParticles(eff.particle1) end
		if eff.particle2 then self:removeParticles(eff.particle2) end
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.LIGHT).projector(eff.src, self.x, self.y, DamageType.LIGHT, eff.dotDam)
		DamageType:get(DamageType.DARKNESS).projector(eff.src, self.x, self.y, DamageType.DARKNESS, eff.dotDam)
	end,
}

-- Circles
newEffect{
	name = "SANCTITY", image = "talents/circle_of_sanctity.png",
	desc = "Sanctity",
	long_desc = function(self, eff) return ("目标免疫沉默。") end,
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
	on_timeout = function(self, eff)
		if self:hasEffect(self.EFF_SURGING_CIRCLES) then self:incPositive(1) end
	end,
}

newEffect{
	name = "SHIFTING_SHADOWS", image = "talents/circle_of_shifting_shadows.png",
	desc = "Shifting Shadows",
	long_desc = function(self, eff) return ("目标闪避增加 %d 。"):format(eff.power) end,
	type = "magical",
	subtype = { circle=true, darkness=true },
	status = "beneficial",
	parameters = {power = 1},
	activate = function(self, eff)
		eff.defense = self:addTemporaryValue("combat_def", eff.power)
		eff.physsave = self:addTemporaryValue("combat_physresist", eff.power)
		eff.spellsave = self:addTemporaryValue("combat_spellresist", eff.power)
		eff.mentalsave = self:addTemporaryValue("combat_mentalresist", eff.power)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_def", eff.defense)
		self:removeTemporaryValue("combat_physresist", eff.physsave)
		self:removeTemporaryValue("combat_spellresist", eff.spellsave)
		self:removeTemporaryValue("combat_mentalresist", eff.mentalsave)
	end,
	on_timeout = function(self, eff)
		if self:hasEffect(self.EFF_SURGING_CIRCLES) then self:incNegative(1) end
	end,
}

newEffect{
	name = "BLAZING_LIGHT", image = "talents/circle_of_blazing_light.png",
	desc = "Blazing Light",
	long_desc = function(self, eff) return ("目标每回合获得 %d 正能量。"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("目标受到的投射物减速 %d%% 。"):format (eff.power) end,
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
	on_timeout = function(self, eff)
		if self:hasEffect(self.EFF_SURGING_CIRCLES) then self:incPositive(0.5) self:incNegative(0.5) end
	end,
}

newEffect{
	name = "TURN_BACK_THE_CLOCK", image = "talents/turn_back_the_clock.png",
	desc = "Turn Back the Clock",
	long_desc = function(self, eff) return ("目标被倒退回幼儿时代，降低 %d 所有属性值。"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("消耗目标使其受到每回合 %0.2f 时空伤害。"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("目标对当前状况了如指掌，增加隐形和潜行侦测等级、命中、近身闪避 %d 。"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("目标每回合回复 %d 体力值并且以两倍正常速度刷新技能。 "):format(eff.power) end,
	type = "magical",
	subtype = { temporal=true, regeneration=true },
	status = "beneficial",
	parameters = {power = 10},
	on_gain = function(self, err) return "#Target# is invigorated.", "+Invigorate" end,
	on_lose = function(self, err) return "#Target# is no longer invigorated.", "-Invigorate" end,
	on_timeout = function(self, eff)
		if not self:attr("no_talents_cooldown") then
			for tid, _ in pairs(self.talents_cd) do
				local t = self:getTalentFromId(tid)
				if t and not t.fixed_cooldown then
					self.talents_cd[tid] = self.talents_cd[tid] - 1
				end
			end
		end
	end,
	activate = function(self, eff)
		eff.regenid = self:addTemporaryValue("life_regen", eff.power)
		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1.5, y=-0.3, img="healcelestial"}, {type="healing", time_factor=4000, noup=2.0, beamColor1={0xd8/255, 0xff/255, 0x21/255, 1}, beamColor2={0xf7/255, 0xff/255, 0x9e/255, 1}, circleColor={0,0,0,0}, beamsCount=5}))
			eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1.5, y=-0.3, img="healcelestial"}, {type="healing", time_factor=4000, noup=1.0, beamColor1={0xd8/255, 0xff/255, 0x21/255, 1}, beamColor2={0xf7/255, 0xff/255, 0x9e/255, 1}, circleColor={0,0,0,0}, beamsCount=5}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
		self:removeTemporaryValue("life_regen", eff.regenid)
	end,
}

newEffect{
	name = "GATHER_THE_THREADS", image = "talents/gather_the_threads.png",
	desc = "Gather the Threads",
	long_desc = function(self, eff) return ("目标法术强度已提高 %d ，每回合进一步提高 %d 。"):
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
	long_desc = function(self, eff) return ("改变目标的过去，降低所有抵抗 %d%% 。"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("目标被法力蠕虫感染，每回合被吸取 %0.2f 法力值并对宿主造成相应数量的奥术伤害。"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("增加目标 %d 攻击强度、法术强度和命中 , 增加 %d 护甲穿透并提高 %d 暴击率。"):format(eff.power, eff.apr, eff.crit) end,
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
	long_desc = function(self, eff) return ("所有超过你生命值 %d%% 的伤害都会被降低至 %d%% 。"):format(eff.power, eff.power) end,
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
	long_desc = function(self, eff) return ("冷却时间低于 %d 的时空法术在释放后将不进入冷却。"):format(eff.max_cd) end,
	type = "magical",
	subtype = { temporal=true },
	status = "beneficial",
	parameters = { max_cd=1},
	activate = function(self, eff)
		if core.shader.allow("adv") then
			eff.particle1, eff.particle2 = self:addParticles3D("volumetric", {kind="transparent_cylinder", twist=1, shineness=10, density=10, radius=1.4, growSpeed=0.004, img="coggy_00"})
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
	end,
}

newEffect{
	name = "TEMPORAL_DESTABILIZATION_START", image = "talents/destabilize.png",
	desc = "Temporal Destabilization",
	long_desc = function(self, eff) return ("目标被扰动，在 %d 回合受到每回合 %0.2f 时空伤害。若目标在效果持续中因该伤害死亡则会发生爆炸。"):format(eff.dur, eff.dam) end,
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
	long_desc = function(self, eff) return ("目标失去时间平衡并每回合受到 %0.2f 时空伤害。如果目标在效果持续时死亡则会爆炸。"):format(eff.dam) end,
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
	name = "CELERITY", image = "talents/celerity.png",
	desc = "Celerity",
	long_desc = function(self, eff) return ("目标移动速度增加 %d%%"):format(eff.speed * 100 * eff.charges) end,
	type = "magical",
	display_desc = function(self, eff) return eff.charges.." Celerity" end,
	charges = function(self, eff) return eff.charges end,
	subtype = { speed=true, temporal=true },
	status = "beneficial",
	parameters = {speed=0.1, charges=1, max_charges=3},
	on_merge = function(self, old_eff, new_eff)
		-- remove the old value
		self:removeTemporaryValue("movement_speed", old_eff.tmpid)

		-- add a charge
		old_eff.charges = math.min(old_eff.charges + 1, new_eff.max_charges)

		-- and apply the current values
		old_eff.tmpid = self:addTemporaryValue("movement_speed", old_eff.speed * old_eff.charges)

		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("movement_speed", eff.speed * eff.charges)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("movement_speed", eff.tmpid)
	end,
}

newEffect{
	name = "TIME_DILATION", image = "talents/time_dilation.png",
	desc = "Time Dilation",
	long_desc = function(self, eff) return ("增加攻击、施法和精神速度 %d%%。"):format(eff.speed * 100 * eff.charges) end,
	type = "magical",
	display_desc = function(self, eff) return eff.charges.." Time Dilation" end,
	charges = function(self, eff) return eff.charges end,
	subtype = { speed=true, temporal=true },
	status = "beneficial",
	parameters = {speed=0.1, charges=1, max_charges=3},
	on_merge = function(self, old_eff, new_eff)
		-- remove the old value
		self:removeTemporaryValue("combat_physspeed", old_eff.physid)
		self:removeTemporaryValue("combat_spellspeed", old_eff.spellid)
		self:removeTemporaryValue("combat_mindspeed", old_eff.mindid)

		-- add a charge
		old_eff.charges = math.min(old_eff.charges + 1, new_eff.max_charges)

		-- and apply the current values
		old_eff.physid = self:addTemporaryValue("combat_physspeed", old_eff.speed * old_eff.charges)
		old_eff.spellid = self:addTemporaryValue("combat_spellspeed", old_eff.speed * old_eff.charges)
		old_eff.mindid = self:addTemporaryValue("combat_mindspeed", old_eff.speed * old_eff.charges)

		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		eff.physid = self:addTemporaryValue("combat_physspeed", eff.speed * eff.charges)
		eff.spellid = self:addTemporaryValue("combat_spellspeed", eff.speed * eff.charges)
		eff.mindid = self:addTemporaryValue("combat_mindspeed", eff.speed * eff.charges)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_physspeed", eff.physid)
		self:removeTemporaryValue("combat_spellspeed", eff.spellid)
		self:removeTemporaryValue("combat_mindspeed", eff.mindid)
	end,
}

newEffect{
	name = "HASTE", image = "talents/haste.png",
	desc = "Haste",
	long_desc = function(self, eff) return ("提升整体速度 %d%% 。"):format(eff.power * 100) end,
	type = "magical",
	subtype = { temporal=true, speed=true },
	status = "beneficial",
	parameters = { move=0.1, speed=0.1 },
	on_gain = function(self, err) return "#Target# speeds up.", "+Haste" end,
	on_lose = function(self, err) return "#Target# slows down.", "-Haste" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("global_speed_add", eff.power)
		if not self.shader then
			eff.set_shader = true
			self.shader = "shadow_simulacrum"
			self.shader_args = { color = {0.4, 0.4, 0}, base = 1, time_factor = 3000 }
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
		self:removeTemporaryValue("global_speed_add", eff.tmpid)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
	end,
}

newEffect{
	name = "CEASE_TO_EXIST", image = "talents/cease_to_exist.png",
	desc = "Cease to Exist",
	long_desc = function(self, eff) return ("目标被尝试移出时间线，减少 %d%% 物理与时空抵抗。"):format(eff.power) end,
	type = "magical",
	subtype = { temporal=true },
	status = "detrimental",
	parameters = { power = 1, damage=1 },
	on_gain = function(self, err) return "#Target# is being removed from the timeline.", "+Cease to Exist" end,
	activate = function(self, eff)
		eff.phys = self:addTemporaryValue("resists", { [DamageType.PHYSICAL] = -eff.power})
		eff.temp = self:addTemporaryValue("resists", { [DamageType.TEMPORAL] = -eff.power})
	end,
	deactivate = function(self, eff)
		if game._chronoworlds then
			game._chronoworlds = nil
		end
		self:removeTemporaryValue("resists", eff.phys)
		self:removeTemporaryValue("resists", eff.temp)
	end,
}

newEffect{
	name = "IMPENDING_DOOM", image = "talents/impending_doom.png",
	desc = "Impending Doom",
	long_desc = function(self, eff) return ("目标的末日已经临近，治疗系数降低 80%% 并且每回合受到 %0.2f 奥术伤害。施法者死亡时本效果消失。"):format(eff.dam) end,
	type = "magical",
	subtype = { arcane=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is doomed!", "+Doomed" end,
	on_lose = function(self, err) return "#Target# is freed from the impending doom.", "-Doomed" end,
	activate = function(self, eff)
		eff.healid = self:addTemporaryValue("healing_factor", -0.8)
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
	long_desc = function(self, eff) return (" 目标受到死灵随从的伤害增加 %d%% 。"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("目标光照范围减少 %d ，暗影抵抗下降 %d%% 。"):format(eff.lite, eff.power) end,
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
	long_desc = function(self, eff) return ("目标的闪避与豁免增加 %d 。"):format(eff.save_bonus * eff.spin) end,
	display_desc = function(self, eff) return eff.spin.." Spin" end,
	charges = function(self, eff) return eff.spin end,
	type = "magical",
	subtype = { temporal=true },
	status = "beneficial",
	parameters = { save_bonus=0, spin=0, max_spin=3},
	on_gain = function(self, err) return "#Target# spins fate.", "+Spin Fate" end,
	on_lose = function(self, err) return "#Target# stops spinning fate.", "-Spin Fate" end,
	on_merge = function(self, old_eff, new_eff)
		-- remove the four old values
		self:removeTemporaryValue("combat_def", old_eff.defid)
		self:removeTemporaryValue("combat_physresist", old_eff.physid)
		self:removeTemporaryValue("combat_spellresist", old_eff.spellid)
		self:removeTemporaryValue("combat_mentalresist", old_eff.mentalid)

		-- add some spin
		old_eff.spin = math.min(old_eff.spin + 1, new_eff.max_spin)

		-- and apply the current values
		old_eff.defid = self:addTemporaryValue("combat_def", old_eff.save_bonus * old_eff.spin)
		old_eff.physid = self:addTemporaryValue("combat_physresist", old_eff.save_bonus * old_eff.spin)
		old_eff.spellid = self:addTemporaryValue("combat_spellresist", old_eff.save_bonus * old_eff.spin)
		old_eff.mentalid = self:addTemporaryValue("combat_mentalresist", old_eff.save_bonus * old_eff.spin)

		old_eff.dur = new_eff.dur

		return old_eff
	end,
	activate = function(self, eff)
		-- apply current values
		eff.defid = self:addTemporaryValue("combat_def", eff.save_bonus * eff.spin)
		eff.physid = self:addTemporaryValue("combat_physresist", eff.save_bonus * eff.spin)
		eff.spellid = self:addTemporaryValue("combat_spellresist", eff.save_bonus * eff.spin)
		eff.mentalid = self:addTemporaryValue("combat_mentalresist", eff.save_bonus * eff.spin)

		if core.shader.allow("adv") then
			eff.particle1, eff.particle2 = self:addParticles3D("volumetric", {kind="conic_cylinder", radius=1.4, base_rotation=180, growSpeed=0.004, img="squares_x3_01"})
		else
			eff.particle1 = self:addParticles(Particles.new("arcane_power", 1))
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_def", eff.defid)
		self:removeTemporaryValue("combat_physresist", eff.physid)
		self:removeTemporaryValue("combat_spellresist", eff.spellid)
		self:removeTemporaryValue("combat_mentalresist", eff.mentalid)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
	end,
}

newEffect{
	name = "SPELLSHOCKED",
	desc = "Spellshocked",
	long_desc = function(self, eff) return string.format("势不可挡的魔法暂时性扰乱所有伤害抵抗，降低伤害抵抗 %d%% 。", eff.power) end,
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
	long_desc = function(self, eff) return ("目标被感染疾病，降低 %d 体质并每回合造成 %0.2f 枯萎伤害。"):format(eff.con, eff.dam) end,
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
		self:removeTemporaryValue("inc_stats", eff.tmpid) eff.tmpid = nil
	end,
}

newEffect{
	name = "DECREPITUDE_DISEASE", image = "talents/decrepitude_disease.png",
	desc = "Decrepitude Disease",
	long_desc = function(self, eff) return ("目标被感染疾病，降低 %d 敏捷并每回合受到 %0.2f 枯萎伤害。"):format(eff.dex, eff.dam) end,
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
		self:removeTemporaryValue("inc_stats", eff.tmpid) eff.tmpid = nil
	end,
}

newEffect{
	name = "WEAKNESS_DISEASE", image = "talents/weakness_disease.png",
	desc = "Weakness Disease",
	long_desc = function(self, eff) return ("目标被感染疾病，降低 %d 力量并每回合受到 %0.2f 枯萎伤害。"):format(eff.str, eff.dam) end,
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
		self:removeTemporaryValue("inc_stats", eff.tmpid) eff.tmpid = nil
	end,
}

-- Endless Woes prodigy effects
newEffect{
	name = "WOEFUL_DISEASE", image = "talents/weakness_disease.png",
	desc = "Woeful Disease",
	long_desc = function(self, eff) return ("The target is infected by a disease, reducing its strength, constitution, dexterity by %d and doing %0.2f blight damage per turn."):
		format(eff.str, eff.con, eff.dex, eff.dam) end,
	type = "magical",
	subtype = {disease=true, blight=true},
	status = "detrimental",
	parameters = {str = 1, con = 1, dex = 1, dam = 0},
	on_gain = function(self, err) return "#Target# is afflicted by a woeful disease!" end,
	on_lose = function(self, err) return "#Target# is free from the woeful disease." end,
	-- Damage each turn
	on_timeout = function(self, eff)
		if self:attr("purify_disease") then self:heal(eff.dam, eff.src)
		else if eff.dam > 0 then DamageType:get(DamageType.BLIGHT).projector(eff.src, self.x, self.y, DamageType.BLIGHT, eff.dam, {from_disease=true})
		end end
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_stats", {
			[Stats.STAT_STR] = math.floor(eff.str),
			[Stats.STAT_CON] = math.floor(eff.con),
			[Stats.STAT_DEX] = math.floor(eff.dex),
		})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "WOEFUL_DARKNESS", image = "effects/bane_blinded.png",
	desc = "Woeful Darkness",
	long_desc = function(self, eff) return ("The target is weakened and lost, all damage it does is reduced by %d%%."):format(eff.reduce) end,
	type = "magical",
	subtype = { darkness=true,},
	status = "detrimental",
	parameters = {power=10, reduce=5},
	on_gain = function(self, err) return "#Target# is weakened by the darkness!", "+Woeful Darkness" end,
	on_lose = function(self, err) return "#Target# looks more determined.", "-Woeful Darkness" end,
	on_timeout = function(self, eff)

	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("numbed", eff.reduce)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("numbed", eff.tmpid)
	end,
}

newEffect{
	name = "WOEFUL_CORROSION", image = "talents/acidic_skin.png",
	desc = "Woeful Corrosion",
	long_desc = function(self, eff) return ("The target has been splashed with acid, taking %0.2f acid damage per turn."):format(eff.dam) end,
	type = "magical",
	subtype = { acid=true,},
	status = "detrimental",
	parameters = {dam = 0},
	on_gain = function(self, err) return "#Target# is covered in acid!" end,
	on_lose = function(self, err) return "#Target# is free from the acid." end,
	-- Damage each turn
	on_timeout = function(self, eff)
		DamageType:get(DamageType.ACID).projector(eff.src, self.x, self.y, DamageType.ACID, eff.dam)
	end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}


newEffect{
	name = "EPIDEMIC", image = "talents/epidemic.png",
	desc = "Epidemic",
	long_desc = function(self, eff) return ("目标被感染疾病，每回合受到 %0.2f 枯萎伤害并降低治疗效果 %d%% 。 \n 未感染疾病的目标受到枯萎伤害时会被传染该疫病。"):format(eff.dam, eff.heal_factor) end,
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
		self:removeTemporaryValue("diseases_spread_on_blight", eff.tmpid) eff.tmpid = nil
		self:removeTemporaryValue("healing_factor", eff.healid) eff.healid = nil
		self:removeTemporaryValue("disease_immune", eff.immid) eff.immid = nil
	end,
}

newEffect{
	name = "WORM_ROT", image = "talents/worm_rot.png",
	desc = "Worm Rot",
	long_desc = function(self, eff) return ("目标被腐肉幼虫感染，每回合会丢失一个物理增益效果并受到 %0.2f 枯萎和酸性伤害。 \n 5 回合后再会造成 %0.2f 枯萎伤害并孵化一条成熟腐肉虫。"):format(eff.dam, eff.burst) end,
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
		local t = eff.src:getTalentFromId(eff.src.T_WORM_ROT)
		if eff.rot_timer == 0 then
			DamageType:get(DamageType.BLIGHT).projector(eff.src, self.x, self.y, DamageType.BLIGHT, eff.burst, {from_disease=true})
			t.spawn_carrion_worm(eff.src, self, t)
			game.logSeen(self, "#LIGHT_RED#A carrion worm mass bursts out of %s!", self.name:capitalize())
			self:removeEffect(self.EFF_WORM_ROT)
		end
	end,
	deactivate = function(self, eff)
		local t = eff.src:getTalentFromId(eff.src.T_WORM_ROT)
		if rng.percent(t.getChance(eff.src,t)) then
			DamageType:get(DamageType.BLIGHT).projector(eff.src, self.x, self.y, DamageType.BLIGHT, eff.burst, {from_disease=true})
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
		if eff.make_ghoul > 0 then ghoulify = "  如果目标在效果持续期间死亡，则会重生为食尸鬼。" end
		return ("目标感染疾病，每回合造成 %0.2f 点枯萎伤害。 %s"):format(eff.dam, ghoulify)
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
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "BLOODCASTING", image = "talents/bloodcasting.png",
	desc = "Bloodcasting",
	long_desc = function(self, eff) return ("堕落者消耗生命值来取代活力值。") end,
	type = "magical",
	subtype = {corruption=true},
	status = "beneficial",
	parameters = {},
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("bloodcasting", 1)
		self:effectParticles(eff, {type="circle", args={oversize=1, a=220, base_rot=180, shader=true, appear=12, img="bloodcasting_aura", speed=0, radius=0}})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("bloodcasting", eff.tmpid)
	end,
}

newEffect{
	name = "BLOOD_GRASP", image = "talents/blood_grasp.png",
	desc = "Sanguine Infusion",
	long_desc = function(self, eff) return ("最大生命值提升 %d 。"):format(eff.life) end,
	type = "magical",
	subtype = {corruption=true},
	status = "beneficial",
	parameters = {life = 0},
	on_merge = function(self, old_eff, new_eff)
		self:removeTemporaryValue("max_life", old_eff.tmpid)

		old_eff.life = math.max(old_eff.life, new_eff.life)
		old_eff.tmpid = self:addTemporaryValue("max_life", old_eff.life)
		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("max_life", eff.life)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("max_life", eff.tmpid)
	end,
}

newEffect{
	name = "ARCANE_SUPREMACY", image = "talents/arcane_supremacy.png",
	desc = "Arcane Supremacy",
	long_desc = function(self, eff) return ("目标法术强度及法术豁免提升 %d"):	format(eff.power) end,
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
	long_desc = function(self, eff) return ("完全吸收 %d 次 %s 攻击。"):format(#eff.particles, DamageType.dam_def[eff.d_type].name) end,
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
	long_desc = function(self, eff) return ("目标的法术强度提升 %d 。"):format(eff.cur_power or eff.power) end,
	charges = function(self, eff) return math.floor(eff.cur_power or eff.power) end,
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
	long_desc = function(self, eff) return ("目标脱离了现实相位，增加 %d 闪避， %d%% 所有抵抗以及 %d%% 所有负面状态的持续时间。\n最高效果为 40%%。"):format(eff.defense or 0, eff.resists or 0, eff.effect_reduction or 0) end,
	type = "magical",
	subtype = { teleport=true },
	status = "beneficial",
	parameters = { defense=0, resists=0, effect_reduction=0 },
	on_gain = function(self, err) return "#Target# is out of phase.", "+Phased" end,
	on_lose = function(self, err) return "#Target# is no longer out of phase.", "-Phased" end,
	activate = function(self, eff)
		eff.defense = math.min(40, eff.defense + (self:attr("defense_on_teleport") or 0))
		eff.resists = math.min(40, eff.resists + (self:attr("resist_all_on_teleport") or 0))
		eff.effect_reduction = math.min(40, eff.effect_reduction + (self:attr("effect_reduction_on_teleport") or 0))

		eff.defid = self:addTemporaryValue("combat_def", eff.defense)
		eff.resid= self:addTemporaryValue("resists", {all=eff.resists})
		eff.durid = self:addTemporaryValue("reduce_detrimental_status_effects_time", eff.effect_reduction)
		eff.particle = self:addParticles(Particles.new("phantasm_shield", 1))
	end,
	on_merge = function(self, old_eff, new_eff)
		old_eff.defense = math.min(40, math.max(old_eff.defense, new_eff.defense)) or 0
		old_eff.resists = math.min(40, math.max(old_eff.resists, new_eff.resists)) or 0
		old_eff.effect_reduction = math.min(40, math.max(old_eff.effect_reduction, new_eff.effect_reduction)) or 0

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
	long_desc = function(self, eff) return ("受到治疗时，生命值维持在 %d 点以下。"):format(eff.power) end,
	type = "magical",
	subtype = { blood=true },
	status = "detrimental",
	parameters = { },
	on_gain = function(self, err) return "#Target# is blood locked.", "+Blood Lock" end,
	on_lose = function(self, err) return "#Target# is no longer blood locked.", "-Blood Lock" end,
	activate = function(self, eff)
		eff.power = self.life
		eff.tmpid = self:addTemporaryValue("blood_lock", eff.power)
		self:effectParticles(eff, {type="circle", args={oversize=1, a=220, base_rot=180, shader=true, appear=12, img="blood_lock_debuff_aura", speed=0, radius=0}})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("blood_lock", eff.tmpid)
	end,
}

newEffect{
	name = "CONGEAL_TIME", image = "talents/congeal_time.png",
	desc = "Congeal Time",
	long_desc = function(self, eff) return ("减少 %d%% 整体速度和 %d%% 周围的抛射物速度。"):format(eff.slow * 100, eff.proj) end,
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
	long_desc = function(self, eff) return ("一个奥术漩涡跟随着目标。每回合一发奥术射线从它身上释放出来，随机对附近视野内的目标造成 %0.2f 奥术伤害。如果视野内没有任何其他目标，则该回合会对初始目标附加额外的 50％奥术伤害。如果目标死亡，残余伤害引发半径为 2 的奥术爆炸。"):format(eff.dam) end,
	type = "magical",
	subtype = { arcane=true },
	status = "detrimental",
	parameters = { dam=10 },
	on_gain = function(self, err) return "#Target# is focused by an arcane vortex!.", "+Arcane Vortex" end,
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
	long_desc = function(self, eff) return ("造成一个奥术爆炸， 1 码范围内每回合 %0.2f 奥术伤害。"):format(eff.dam) end,
	type = "magical",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { dam=10 },
	on_gain = function(self, err) return "#Target# begins channeling arcane through a breach in reality!", "+Aether Breach" end,
	on_lose = function(self, err) return "The aetheric breach around #Target# seals itself.", "-Aether Breach" end,
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
	long_desc = function(self, eff) return ("充满以太力量。") end,
	type = "magical",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { },
	activate = function(self, eff)
		local inc_mana = self:getMaxMana() * 0.33
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.ARCANE]=25})
		self:effectTemporaryValue(eff, "resists_pen", {[DamageType.ARCANE]=25})

		self:effectTemporaryValue(eff, "max_mana", inc_mana)
		self:effectTemporaryValue(eff, "arcane_cooldown_divide", 3)
		self:incMana(inc_mana)
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
		self.mana = math.min(self.mana, self.max_mana)
	end,
}

newEffect{
	name = "VULNERABILITY_POISON", image = "talents/vulnerability_poison.png",
	desc = "Vulnerability Poison",
	long_desc = function(self, eff)
		local poison_id = eff.__tmpvals and eff.__tmpvals[2] and eff.__tmpvals[2][2]
		local poison_effect = self:getTemporaryValue(poison_id)
		return ("目标被魔法毒素感染，每回合受到 %0.2f 奥术伤害，所有伤害抗性下降 10%% %s."):format(eff.src:damDesc("ARCANE", eff.power) , poison_effect and (" 毒素免疫下降 %s%%"):format(-100*poison_effect) or "")
	end,
	type = "magical",
	subtype = { poison=true, arcane=true },
	status = "detrimental",
	parameters = {power=10, unresistable=true},
	on_gain = function(self, err) return "#Target# is magically poisoned!", "+Vulnerability Poison" end,
	on_lose = function(self, err) return "#Target# is no longer magically poisoned.", "-Vulnerability Poison" end,
	-- Damage each turn
	on_timeout = function(self, eff)
		if self:attr("purify_poison") then self:heal(eff.power, eff.src)
		else DamageType:get(DamageType.ARCANE).projector(eff.src, self.x, self.y, DamageType.ARCANE, eff.power)
		end
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "resists", {all=-10})
		if self:attr("poison_immune") then
			self:effectTemporaryValue(eff, "poison_immune", -self:attr("poison_immune")/2)
		end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "IRRESISTIBLE_SUN", image = "talents/irresistible_sun.png",
	desc = "Irresistible Sun",
	long_desc = function(self, eff) return ("所有目标被拉向它，每回合造成火焰、光系和物理伤害。"):format() end,
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
						target:setEffect(target.EFF_WEIGHT_OF_THE_SUN, 2, {reduce = 30})  -- Quickly wears off when outside of AoE
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
	name = "WEIGHT_OF_THE_SUN", image = "talents/irresistible_sun.png",
	desc = "Weight of the Sun",
	long_desc = function(self, eff) return ("The target is struggling against immense gravity, all damage it does is reduced by %d%%."):format(eff.reduce) end,
	type = "magical",
	subtype = { sun=true,},
	status = "detrimental",
	parameters = {reduce=5},
	on_gain = function(self, err) return "#Target# can barely stand!", "+Weight of the Sun" end,
	on_lose = function(self, err) return "#Target# can move freely once more.", "-Weight of the Sun" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "numbed", eff.reduce)
	end,
}

newEffect{
	name = "TEMPORAL_FORM", image = "talents/temporal_form.png",
	desc = "Temporal Form",
	long_desc = function(self, eff) return ("目标呈现出泰鲁戈洛斯形态 "):format() end,
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
		self:learnTalent(self.T_ANOMALY_REARRANGE, true)
		self:learnTalent(self.T_ANOMALY_TEMPORAL_STORM, true)
		self:learnTalent(self.T_ANOMALY_FLAWED_DESIGN, true)
		self:learnTalent(self.T_ANOMALY_GRAVITY_PULL, true)
		self:learnTalent(self.T_ANOMALY_WORMHOLE, true)

		self.replace_display = mod.class.Actor.new{
			image = "npc/elemental_temporal_telugoroth.png",
			shader = "shadow_simulacrum",
			shader_args = { color = {0.2, 0.1, 0.8}, base = 0.5, time_factor = 500 },
		}
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)
	end,
	deactivate = function(self, eff)
		self:unlearnTalent(self.T_ANOMALY_REARRANGE)
		self:unlearnTalent(self.T_ANOMALY_TEMPORAL_STORM)
		self:unlearnTalent(self.T_ANOMALY_FLAWED_DESIGN)
		self:unlearnTalent(self.T_ANOMALY_GRAVITY_PULL)
		self:unlearnTalent(self.T_ANOMALY_WORMHOLE)
		self.replace_display = nil
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)
	end,
}

newEffect{
	name = "CORRUPT_LOSGOROTH_FORM", image = "shockbolt/npc/elemental_void_losgoroth_corrupted.png",
	desc = "Corrupted Losgoroth Form",
	long_desc = function(self, eff) return ("目标呈现出堕落的罗斯戈洛斯形态。获得毒素、疾病、流血和混乱免疫。不需要呼吸，将所造成的的一半伤害转化为枯萎吸血伤害。"):format() end,
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
	long_desc = function(self, eff) return ("目标呈现出西弗戈洛斯形态。"):format() end,
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
	long_desc = function(self, eff) return ("目标呈现出西弗戈洛斯形态。"):format() end,
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
		if self.hotkey and self.isHotkeyBound and self:knowTalent(self.T_SHIV_LORD) then
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
	long_desc = function(self, eff) return "现实守护者召唤一切可能的防护来守卫零点圣域，生命值提高 5000 ，伤害增加 300% 。" end,
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
	long_desc = function(self, eff) return (" 你能感知周围的 %s"):
		format(eff.what:gsub("Humanoid"," 人形怪 "):gsub("Horror"," 恐魔 "):gsub("Demon"," 恶魔 ")
		               :gsub("Dragon"," 龙 "):gsub("Animal"," 动物 "):gsub("Undead"," 不死族 ")
			       :gsub("All"," 全体怪物 "))
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
	long_desc = function(self, eff) return ("%s 伤害增加 20%%."):format(DamageType:get(eff.damtype).name:capitalize()) end,
	type = "magical",
	subtype = { race=true },
	status = "beneficial",
	parameters = { eff=DamageType.ARCANE },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_damage", {[eff.damtype]=20})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ESSENCE_OF_THE_DEAD", image = "talents/essence_of_the_dead.png",
	desc = "Essence of the Dead",
	long_desc = function(self, eff) return ("目标消耗灵魂来获取额外力量，   %d 个法术受到影响。"):format(eff.nb) end,
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
	long_desc = function(self, eff) return (" 目标被冰覆盖，增加 %d 护甲，对攻击者造成 %0.1f 点寒冷伤害 , 同时将 50%% 伤害转化为寒冷伤害。"):format(eff.armor, self:damDesc(DamageType.COLD, eff.dam)) end,
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
	long_desc = function(self, eff) return (" 目标被酸液覆盖。当被近战攻击时，有 %d%% 几率喷射锥形酸液造成 %0.1f 伤害。"):format(eff.chance, self:damDesc(DamageType.ACID, eff.dam)) end,
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
	long_desc = function(self, eff) return (" 目标充满了阳光的愤怒！下一发阳光烈焰变为瞬发。"):format() end,
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
	name = "SUNCLOAK", image = "talents/suncloak.png",
	desc = "Suncloak",
	long_desc = function(self, eff) return (" 目标被太阳之力保护，增加 %d%% 施法速度 ,减少 %d%% 法术冷却时间，同时一次伤害最多带走你 %d%% 最大生命。"):
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
	long_desc = function(self, eff) return ("目标被光之印记标记，标记方对它进行近战攻击将获得相当于 %d%% 伤害的治疗。"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("增加%d%% 物理和光系伤害。"):format(eff.power) end,
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
	long_desc = function(self, eff) return ("目标被光明灼烧，每回合受到 %0.2f 点光系伤害，同时护甲降低 %d。"):format(eff.dam, eff.armor) end,
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
	long_desc = function(self, eff) return (" 目标在光明中显形，减少 %d 潜行与隐身强度，减少 %d 闪避，同时失去不可见带来的闪避加成。"):format(eff.power, eff.def) end,
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
	long_desc = function(self, eff) return ("当使用灼热之矛时被激发。"):format() end,
	type = "magical",
	subtype = { sun=true },
	status = "beneficial",
	parameters = { max=1 },
	on_gain = function(self, err) return nil, "+Light Burst" end,
	on_lose = function(self, err) return nil, "-Light Burst" end,
}

newEffect{
	name = "LIGHT_BURST_SPEED",
	desc = "Light Burst Speed", image = "effects/light_burst_speed.png",
	long_desc = function(self, eff) return ("当使用灼热之矛时被激发, 增加 %d%% 移动速度。"):format(eff.charges * 10) end,
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
	long_desc = function(self, eff) return ("目标受到的所有治疗会逆转为 %d%% 枯萎伤害."):format(eff.power) end,
	type = "magical",
	subtype = { heal=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return nil, "+Healing Inversion" end,
	on_lose = function(self, err) return nil, "-Healing Inversion" end,
	callbackPriorities={callbackOnHeal = 1}, -- trigger after (most) other healing callbacks
	callbackOnHeal = function(self, eff, value, src, raw_value)
		if raw_value > 0 and not eff.projecting then -- avoid feedback; it's bad to lose out on dmg but it's worse to break the game
			eff.projecting = true
			local dam = raw_value * eff.power / 100
			eff.src.__project_source = eff
			DamageType:get(DamageType.BLIGHT).projector(eff.src, self.x, self.y, DamageType.BLIGHT, dam)
			eff.src.__project_source = nil
			eff.projecting = false
		end
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
	long_desc = function(self, eff) return ("目标被强力的闪电所震撼，震慑与定身免疫减半."):format() end,
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
	long_desc = function(self, eff) return ("目标全身湿透了，震慑抗性减半。"):format() end,
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

newEffect{
	name = "PROBABILITY_TRAVEL", image = "talents/anomaly_probability_travel.png",
	desc = "Probability Travel",
	long_desc = function(self, eff) return ("目标处于相位空间外，能穿过墙壁。"):format() end,
	type = "magical",
	subtype = { teleport=true },
	status = "beneficial",
	parameters = { power=0 },
	on_gain = function(self, err) return nil, "+Probability Travel" end,
	on_lose = function(self, err) return nil, "-Probability Travel" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "prob_travel", eff.power)
		self:effectTemporaryValue(eff, "prob_travel_penalty", eff.power)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "BLINK", image = "talents/anomaly_blink.png",
	desc = "Blink",
	long_desc = function(self, eff) return ("目标每轮都会随机传送。"):format() end,
	type = "magical",
	subtype = { teleport=true },
	status = "detrimental",
	on_gain = function(self, err) return nil, "+Blink" end,
	on_lose = function(self, err) return nil, "-Blink" end,
	on_timeout = function(self, eff)
		if self:teleportRandom(self.x, self.y, eff.power) then
			game.level.map:particleEmitter(self.x, self.y, 1, "temporal_teleport")
		end
	end,
}

newEffect{
	name = "DIMENSIONAL_ANCHOR", image = "talents/dimensional_anchor.png",
	desc = "Dimensional Anchor",
	long_desc = function(self, eff) return ("目标不能传送，试图传送时将受到 %0.2f 时空 %0.2f 物理伤害。"):format(eff.damage, eff.damage) end,
	type = "magical",
	subtype = { temporal=true, slow=true },
	status = "detrimental",
	parameters = { damage=0 },
	on_gain = function(self, err) return "#Target# is anchored.", "+Anchor" end,
	on_lose = function(self, err) return "#Target# is no longer anchored.", "-Anchor" end,
	onTeleport = function(self, eff)
		DamageType:get(DamageType.WARP).projector(eff.src or self, self.x, self.y, DamageType.WARP, eff.damage)
	end,
	activate = function(self, eff)
		-- Reduce teleport saves to zero so our damage will trigger
		eff.effid = self:addTemporaryValue("continuum_destabilization", -1000)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("continuum_destabilization", eff.effid)
	end,
}

newEffect{
	name = "BREACH", image = "talents/breach.png",
	desc = "Breach",
	long_desc = function(self, eff) return ("目标的防御被削弱了，减少 50%% 护甲硬度，震慑、定身、致盲、混乱免疫。"):format() end,
	type = "magical",
	subtype = { temporal=true },
	status = "detrimental",
	on_gain = function(self, err) return nil, "+Breach" end,
	on_lose = function(self, err) return nil, "-Breach" end,
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = new_eff.dur
		return old_eff
	end,
	activate = function(self, eff)
		if self:attr("stun_immune") then
			self:effectTemporaryValue(eff, "stun_immune", -self:attr("stun_immune") / 2)
		end
		if self:attr("confusion_immune") then
			self:effectTemporaryValue(eff, "confusion_immune", -self:attr("confusion_immune") / 2)
		end
		if self:attr("blind_immune") then
			self:effectTemporaryValue(eff, "blind_immune", -self:attr("blind_immune") / 2)
		end
		if self:attr("pin_immune") then
			self:effectTemporaryValue(eff, "pin_immune", -self:attr("pin_immune") / 2)
		end
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "BRAIDED", image = "talents/braid_lifelines.png",
	desc = "Braided",
	long_desc = function(self, eff) return ("目标从其他被切断的目标处受到额外 %d%% 伤害。"):format(eff.power) end,
	type = "magical",
	subtype = { temporal=true },
	status = "detrimental",
	parameters = { power=0 },
	on_gain = function(self, err) return "#Target#'s lifeline has been braided.", "+Braided" end,
	on_lose = function(self, err) return "#Target#'s lifeline is no longer braided.", "-Braided" end,
	doBraid = function(self, eff, dam)
		local braid_damage = dam * eff.power/ 100
		for i = 1, #eff.targets do
			local target = eff.targets[i]
			if target ~= self and not target.dead then
				game:delayedLogMessage(eff.src, target, "braided", "#CRIMSON##Source# damages #Target# through the Braid!")
				game:delayedLogDamage(eff.src, target, braid_damage, ("#PINK#%d braided #LAST#"):format(braid_damage), false)
				target:takeHit(braid_damage, eff.src)
			end
		end
	end,
	on_timeout = function(self, eff)
		local alive = false
		for i = 1, #eff.targets do
			local target = eff.targets[i]
			if target ~=self and not target.dead then
				alive = true
				break
			end
		end
		if not alive then
			self:removeEffect(self.EFF_BRAIDED)
		end
	end,
}

newEffect{
	name = "PRECOGNITION", image = "talents/precognition.png",
	desc = "Precognition",
	long_desc = function(self, eff) return ("预知未来，感知敌人，并增加 %d 闪避与 %d%% 暴击摆脱率。"):format(eff.defense, eff.crits) end,
	type = "magical",
	subtype = { sense=true },
	status = "beneficial",
	parameters = { range=10, actor=1, trap=1, defense=0, crits=0 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "detect_range", eff.range)
		self:effectTemporaryValue(eff, "detect_actor", eff.actor)
		self:effectTemporaryValue(eff, "detect_trap", eff.actor)
		self:effectTemporaryValue(eff, "ignore_direct_crits", eff.crits)
		self:effectTemporaryValue(eff, "combat_def", eff.defense)
		self.detect_function = eff.on_detect
		game.level.map.changed = true
	end,
	deactivate = function(self, eff)
		self.detect_function = nil
	end,
}

newEffect{
	name = "WEBS_OF_FATE", image = "talents/webs_of_fate.png",
	desc = "Webs of Fate",
	long_desc = function(self, eff) return ("将 %d%% 伤害转移至随机敌人。"):format(eff.power*100) end,
	type = "magical",
	subtype = { temporal=true },
	status = "beneficial",
	on_gain = function(self, err) return nil, "+Webs of Fate" end,
	on_lose = function(self, err) return nil, "-Webs of Fate" end,
	parameters = { power=0.1 },
	callbackOnTakeDamage = function(self, eff, src, x, y, type, dam, state)
		-- Displace Damage?
		local t = eff.talent
		if dam > 0 and src ~= self and not state.no_reflect then

			-- Spin Fate?
			if self.turn_procs and self:knowTalent(self.T_SPIN_FATE) and not self.turn_procs.spin_webs then
				self.turn_procs.spin_webs = true
				self:callTalent(self.T_SPIN_FATE, "doSpin")
			end

			-- find available targets
			local tgts = {}
			local grids = core.fov.circle_grids(self.x, self.y, 10, true)
			for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
				local a = game.level.map(x, y, Map.ACTOR)
				if a and self:reactionToward(a) < 0 then
					tgts[#tgts+1] = a
				end
			end end

			-- Displace the damage
			local a = rng.table(tgts)
			if a then
				local displace = dam * eff.power
				state.no_reflect = true
				DamageType.defaultProjector(self, a.x, a.y, type, displace, state)
				state.no_reflect = nil
				dam = dam - displace
				game:delayedLogDamage(src, self, 0, ("%s(%d webs of fate)#LAST#"):format(DamageType:get(type).text_color or "#aaaaaa#", displace), false)
			end
		end

		return {dam=dam}
	end,
	activate = function(self, eff)
		if core.shader.allow("adv") then
			eff.particle1, eff.particle2 = self:addParticles3D("volumetric", {kind="fast_sphere", shininess=40, density=40, radius=1.4, scrollingSpeed=0.001, growSpeed=0.004, img="squares_x3_01"})
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
	end,
}

newEffect{
	name = "SEAL_FATE", image = "talents/seal_fate.png",
	desc = "Seal Fate",
	long_desc = function(self, eff)
		local chance = eff.chance
		local spin = self:hasEffect(self.EFF_SPIN_FATE)
		if spin then
			chance = chance * (1 + spin.spin/3)
		end
		return ("有 %d%% 几率延长受到你的伤害的目标的负面状态持续时间 1 回合。"):format(chance) 
	end,
	type = "magical",
	subtype = { focus=true },
	status = "beneficial",
	parameters = { procs=1 },
	on_gain = function(self, err) return nil, "+Seal Fate" end,
	on_lose = function(self, err) return nil, "-Seal Fate" end,
	callbackOnDealDamage = function(self, eff, dam, target)
		if dam <=0 then return end

		-- Spin Fate?
		if self.turn_procs and self:knowTalent(self.T_SPIN_FATE) and not self.turn_procs.spin_seal then
			self.turn_procs.spin_seal = true
			self:callTalent(self.T_SPIN_FATE, "doSpin")
		end


		if self.turn_procs and target.tmp then
			if self.turn_procs.seal_fate and self.turn_procs.seal_fate >= eff.procs then return end
			local chance = eff.chance
			local spin = self:hasEffect(self.EFF_SPIN_FATE)
			if spin then
				chance = chance * (1 + spin.spin/3)
			end

			if rng.percent(chance) then
				-- Grab a random effect
				local eff_ids = target:effectsFilter({status="detrimental", ignore_crosstier=true}, 1)
				for _, eff_id in ipairs(eff_ids) do
					local eff = target:hasEffect(eff_id)
					eff.dur = eff.dur +1
				end

				self.turn_procs.seal_fate = (self.turn_procs.seal_fate or 0) + 1
			end

		end
	end,
	activate = function(self, eff)
		if core.shader.allow("adv") then
			eff.particle1, eff.particle2 = self:addParticles3D("volumetric", {kind="no_idea_but_looks_cool", shininess=60, density=40, scrollingSpeed=0.0002, radius=1.6, growSpeed=0.004, img="squares_x3_01"})
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
	end,
}


newEffect{
	name = "UNRAVEL", image = "talents/temporal_vigour.png",
	desc = "Unravel",
	long_desc = function(self, eff)
		return ("目标免疫伤害，但造成的伤害减少 %d%%。"):format(eff.power)
	end,
	on_gain = function(self, err) return "#Target# has started to unravel.", "+Unraveling" end,
	type = "magical",
	subtype = {time=true},
	status = "beneficial",
	parameters = {power=50, die_at=50},
	on_timeout = function(self, eff)
		if self.life > 0 then
			self:removeEffect(self.EFF_UNRAVEL)
		end
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "die_at", eff.die_at)
		self:effectTemporaryValue(eff, "generic_damage_penalty", eff.power)
		self:effectTemporaryValue(eff, "invulnerable", 1)
	end,
	deactivate = function(self, eff)
		-- check negative life first incase the creature has healing
		if self.life <= (self.die_at or 0) then
			local sx, sy = game.level.map:getTileToScreen(self.x, self.y, true)
			game.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, rng.float(-2.5, -1.5), "Unravels!", {255,0,255})
			game.logSeen(self, "%s has unraveled!", self.name:capitalize())
			self:die(self)
		end
	end,
}

newEffect{
	name = "ENTROPY", image = "talents/entropy.png",
	desc = "Entropy",
	long_desc = function(self, eff) return "每轮失去一项维持技能。" end,
	on_gain = function(self, err) return "#Target# is caught in an entropic field!", "+Entropy" end,
	on_lose = function(self, err) return "#Target# is free from the entropy.", "-Entropy" end,
	type = "magical",
	subtype = { temporal=true },
	status = "detrimental",
	parameters = {},
	on_timeout = function(self, eff)
		self:removeSustainsFilter(nil, 1)
	end,
	activate = function(self, eff)
		if core.shader.allow("adv") then
			eff.particle1, eff.particle2 = self:addParticles3D("volumetric", {kind="fast_sphere", twist=2, base_rotation=90, radius=1.4, density=40,  scrollingSpeed=-0.0002, growSpeed=0.004, img="miasma_01_01"})
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
	end,
}

newEffect{
	name = "REGRESSION", image = "talents/turn_back_the_clock.png",
	desc = "Regression",
	long_desc = function(self, eff)	return ("减少三项最高属性 %d 点。"):format(eff.power) end,
	on_gain = function(self, err) return "#Target# has regressed.", "+Regression" end,
	on_lose = function(self, err) return "#Target# has returned to its natural state.", "-Regression" end,
	type = "physical",
	subtype = { temporal=true },
	status = "detrimental",
	parameters = { power=1},
	activate = function(self, eff)
		local l = { {Stats.STAT_STR, self:getStat("str")}, {Stats.STAT_DEX, self:getStat("dex")}, {Stats.STAT_CON, self:getStat("con")}, {Stats.STAT_MAG, self:getStat("mag")}, {Stats.STAT_WIL, self:getStat("wil")}, {Stats.STAT_CUN, self:getStat("cun")}, }
		table.sort(l, function(a,b) return a[2] > b[2] end)
		local inc = {}
		for i = 1, 3 do inc[l[i][1]] = -eff.power end
		self:effectTemporaryValue(eff, "inc_stats", inc)
	end,
}

newEffect{
	name = "ATTENUATE_DET", image = "talents/attenuate.png",
	desc = "Attenuate",
	long_desc = function(self, eff) return ("目标被移出时间线，每轮受到 %0.2f 时空伤害。"):format(eff.power) end,
	type = "magical",
	subtype = { temporal=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is being being removed from the timeline!", "+Attenuate" end,
	on_lose = function(self, err) return "#Target# survived the attenuation.", "-Attenuate" end,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the flames!
		local olddam = old_eff.power * old_eff.dur
		local newdam = new_eff.power * new_eff.dur
		local dur = math.ceil((old_eff.dur + new_eff.dur) / 2)
		old_eff.dur = dur
		old_eff.power = (olddam + newdam) / dur
		return old_eff
	end,
	callbackOnHit = function(self, eff, cb, src)
		if cb.value <= 0 then return cb.value end

		-- Kill it!!
		if not self.dead and not self:isTalentActive(self.T_REALITY_SMEARING) and self:canBe("instakill") and self.life > 0 and self.life < self.max_life * 0.2 then
			game.logSeen(self, "%s has been removed from the timeline!", self.name:capitalize())
			self:die(src)
		end

		return cb.value
	end,
	on_timeout = function(self, eff)
		if self:isTalentActive(self.T_REALITY_SMEARING) then
			self:heal(eff.power * 0.4, eff)
		else
			DamageType:get(DamageType.TEMPORAL).projector(eff.src, self.x, self.y, DamageType.TEMPORAL, eff.power)
		end
	end,
}

newEffect{
	name = "ATTENUATE_BEN", image = "talents/attenuate.png",
	desc = "Attenuate",
	long_desc = function(self, eff) return ("目标被时间线包围，每轮受到 %0.2f 治疗。"):format(eff.power) end,
	type = "magical",
	subtype = { temporal=true },
	status = "beneficial",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is being being grounded in the timeline!", "+Attenuate" end,
	on_lose = function(self, err) return "#Target# is no longer being grounded.", "-Attenuate" end,
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
		self:heal(eff.power, eff)
	end,
}

newEffect{
	name = "OGRIC_WRATH", image = "talents/ogre_wrath.png",
	desc = "Ogric Wrath",
	long_desc = function(self, eff) return ("不要妄图抵抗！"):format() end,
	type = "magical",
	subtype = { runic=true },
	status = "beneficial",
	parameters = { power=1 },
	on_gain = function(self, err) return "#Target# enters an ogric frenzy.", "+Ogric Wrath" end,
	on_lose = function(self, err) return "#Target# calms down.", "-Ogric Wrath" end,
	callbackOnDealDamage = function(self, eff, val, target, dead, death_note)
		if not death_note or not death_note.initial_dam then return end
		if val >= death_note.initial_dam then return end
		if self:reactionToward(target) >= 0 then return end
		if self.turn_procs.ogric_wrath then return end

		self.turn_procs.ogric_wrath = true
		self:setEffect(self.EFF_OGRE_FURY, 7, {})
	end,
	callbackOnMeleeAttack = function(self, eff, target, hitted, crit, weapon, damtype, mult, dam)
		if hitted then return true end
		if self:reactionToward(target) >= 0 then return end
		if self.turn_procs.ogric_wrath then return end

		self.turn_procs.ogric_wrath = true
		self:setEffect(self.EFF_OGRE_FURY, 7, {})
	end,
	callbackOnTalentPost = function(self, eff, t)
		if not t.is_inscription then return end
		if self.turn_procs.ogric_wrath then return end

		self.turn_procs.ogric_wrath = true
		self:setEffect(self.EFF_OGRE_FURY, 7, {})
	end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "stun_immune", 0.2)
		self:effectTemporaryValue(eff, "pin_immune", 0.2)
		self:effectTemporaryValue(eff, "inc_damage", {all=10})

		self.moddable_tile_ornament, eff.old_mod = {female="runes_red_glow_01", male="runes_red_glow_01"}, self.moddable_tile_ornament
		self.moddable_tile_ornament_shader, eff.old_mod_shader = "runes_glow", self.moddable_tile_ornament_shader
		self:updateModdableTile()
	end,
	deactivate = function(self, eff)
		self.moddable_tile_ornament = eff.old_mod
		self.moddable_tile_ornament_shader = eff.old_mod_shader
		self:updateModdableTile()
	end,
}

newEffect{
	name = "OGRE_FURY", image = "effects/ogre_fury.png",
	desc = "Ogre Fury",
	long_desc = function(self, eff) return ("增加 %d%% 暴击率与 %d%% 暴击强度。叠加： %d ."):format(eff.stacks * 5, eff.stacks * 20, eff.stacks) end,
	type = "magical",
	subtype = { runic=true },
	status = "beneficial",
	parameters = { stacks=1, max_stacks=5 },
	charges = function(self, eff) return eff.stacks end,
	do_effect = function(self, eff, add)
		if eff.cdam then self:removeTemporaryValue("combat_critical_power", eff.cdam) eff.cdam = nil end
		if eff.crit then self:removeTemporaryValue("combat_generic_crit", eff.crit) eff.crit = nil end
		if add then
			eff.cdam = self:addTemporaryValue("combat_critical_power", eff.stacks * 20)
			eff.crit = self:addTemporaryValue("combat_generic_crit", eff.stacks * 5)
		end
	end,
	callbackOnCrit = function(self, eff)
		eff.stacks = eff.stacks - 1
		if eff.stacks == 0 then
			self:removeEffect(self.EFF_OGRE_FURY)
		else
			local e = self:getEffectFromId(self.EFF_OGRE_FURY)
			e.do_effect(self, eff, true)
		end
	end,
	on_merge = function(self, old_eff, new_eff, e)
		old_eff.dur = new_eff.dur
		old_eff.stacks = util.bound(old_eff.stacks + 1, 1, new_eff.max_stacks)
		e.do_effect(self, old_eff, true)
		return old_eff
	end,
	activate = function(self, eff, e)
		e.do_effect(self, eff, true)
	end,
	deactivate = function(self, eff, e)
		e.do_effect(self, eff, false)
	end,
	on_timeout = function(self, eff, e)
		if eff.stacks > 1 and eff.dur <= 1 then
			eff.stacks = eff.stacks - 1
			eff.dur = 7
			e.do_effect(self, eff, true)
		end
	end
}

newEffect{
	name = "WRIT_LARGE", image = "talents/writ_large.png",
	desc = "Writ Large",
	long_desc = function(self, eff) return ("纹身符文冷却速度加倍。"):format(eff.power) end,
	type = "magical",
	subtype = { runic=true },
	status = "beneficial",
	parameters = { power=1 },
	on_gain = function(self, err) return nil, "+Writ Large" end,
	on_lose = function(self, err) return nil, "-Writ Large" end,
	callbackOnActBase = function(self, eff)
		if not self:attr("no_talents_cooldown") then
			for tid, c in pairs(self.talents_cd) do
				local t = self:getTalentFromId(tid)
				if t and t.is_inscription then
					self.changed = true
					self.talents_cd[tid] = self.talents_cd[tid] - eff.power
					if self.talents_cd[tid] <= 0 then
						self.talents_cd[tid] = nil
						if self.onTalentCooledDown then self:onTalentCooledDown(tid) end
						if t.cooldownStop then t.cooldownStop(self, t) end
					end
				end
			end
		end
	end,
}

newEffect{
	name = "STATIC_HISTORY", image = "talents/static_history.png",
	desc = "Static History",
	long_desc = function(self, eff) return ("时空法术不会制造小异常。"):format() end,
	type = "magical",
	subtype = { time=true },
	status = "beneficial",
	parameters = { power=0.1 },
	on_gain = function(self, err) return "Spacetime has stabilized around #Target#.", "+Static History" end,
	on_lose = function(self, err) return "The fabric of spacetime around #Target# has returned to normal.", "-Static History" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "no_minor_anomalies", 1)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "ARROW_ECHOES", image = "talents/arrow_echoes.png",
	desc = "Arrow Echoes",
	long_desc = function(self, eff) return ("每轮都会有箭射向 %s。"):format(eff.target.name) end,
	type = "magical",
	subtype = { time=true },
	status = "beneficial",
	remove_on_clone = true,
	on_gain = function(self, err) return nil, "+Arrow Echoes" end,
	on_lose = function(self, err) return nil, "-Arrow Echoes" end,
	parameters = { shots = 1 },
	on_timeout = function(self, eff)
		if eff.shots <= 0 or eff.target.dead or not game.level:hasEntity(self) or not game.level:hasEntity(eff.target) or core.fov.distance(self.x, self.y, eff.target.x, eff.target.y) > 10 then
			self:removeEffect(self.EFF_ARROW_ECHOES)
		else
			self:callTalent(self.T_ARROW_ECHOES, "doEcho", eff)
		end
	end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "WARDEN_S_FOCUS", image = "talents/warden_s_focus.png",
	desc = "Warden's Focus",
	long_desc = function(self, eff)
		return ("集中于 %s, 对其增加 %d%% 暴击伤害与 %d%% 暴击率。"):format(eff.target.name, eff.power, eff.power)
	end,
	type = "magical",
	subtype = { tactic=true },
	status = "beneficial",
	on_gain = function(self, err) return nil, "+Warden's Focus" end,
	on_lose = function(self, err) return nil, "-Warden's Focus" end,
	parameters = { power=0},
	callbackOnTakeDamage = function(self, eff, src, x, y, type, dam, tmp)
		local eff = self:hasEffect(self.EFF_WARDEN_S_FOCUS)
		if eff and dam > 0 and eff.target ~= src and src ~= self and (src.rank and eff.target.rank and src.rank < eff.target.rank) then
			-- Reduce damage
			local reduction = dam * eff.power/100
			dam = dam -  reduction
			game:delayedLogDamage(src, self, 0, ("%s(%d focus)#LAST#"):format(DamageType:get(type).text_color or "#aaaaaa#", reduction), false)
		end
		return {dam=dam}
	end,
	on_timeout = function(self, eff)
		if eff.target.dead or not game.level:hasEntity(self) or not game.level:hasEntity(eff.target) or core.fov.distance(self.x, self.y, eff.target.x, eff.target.y) > 10 then
			self:removeEffect(self.EFF_WARDEN_S_FOCUS)
		end
	end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "FATEWEAVER", image = "talents/fateweaver.png",
	desc = "Fateweaver",
	long_desc = function(self, eff) return ("目标的命中和强度增加 %d。"):format(eff.power_bonus * eff.spin) end,
	display_desc = function(self, eff) return eff.spin.." Fateweaver" end,
	charges = function(self, eff) return eff.spin end,
	type = "magical",
	subtype = { temporal=true },
	status = "beneficial",
	parameters = { power_bonus=0, spin=0, max_spin=3},
	on_gain = function(self, err) return "#Target# weaves fate.", "+Fateweaver" end,
	on_lose = function(self, err) return "#Target# stops weaving fate.", "-Fateweaver" end,
	on_merge = function(self, old_eff, new_eff)
		-- remove the four old values
		self:removeTemporaryValue("combat_atk", old_eff.atkid)
		self:removeTemporaryValue("combat_dam", old_eff.physid)
		self:removeTemporaryValue("combat_spellpower", old_eff.spellid)
		self:removeTemporaryValue("combat_mindpower", old_eff.mentalid)

		-- add some spin
		old_eff.spin = math.min(old_eff.spin + 1, new_eff.max_spin)

		-- and apply the current values
		old_eff.atkid = self:addTemporaryValue("combat_atk", old_eff.power_bonus * old_eff.spin)
		old_eff.physid = self:addTemporaryValue("combat_dam", old_eff.power_bonus * old_eff.spin)
		old_eff.spellid = self:addTemporaryValue("combat_spellpower", old_eff.power_bonus * old_eff.spin)
		old_eff.mentalid = self:addTemporaryValue("combat_mindpower", old_eff.power_bonus * old_eff.spin)

		old_eff.dur = new_eff.dur

		return old_eff
	end,
	activate = function(self, eff)
		-- apply current values
		eff.atkid = self:addTemporaryValue("combat_atk", eff.power_bonus * eff.spin)
		eff.physid = self:addTemporaryValue("combat_dam", eff.power_bonus * eff.spin)
		eff.spellid = self:addTemporaryValue("combat_spellpower", eff.power_bonus * eff.spin)
		eff.mentalid = self:addTemporaryValue("combat_mindpower", eff.power_bonus * eff.spin)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("combat_atk", eff.atkid)
		self:removeTemporaryValue("combat_dam", eff.physid)
		self:removeTemporaryValue("combat_spellpower", eff.spellid)
		self:removeTemporaryValue("combat_mindpower", eff.mentalid)
	end,
}

newEffect{
	name = "FOLD_FATE", image = "talents/fold_fate.png",
	desc = "Fold Fate",
	long_desc = function(self, eff) return ("目标临近终结，物理和时空抗性下降 %d%%。"):format(eff.power) end,
	type = "magical",
	subtype = { temporal=true },
	status = "detrimental",
	parameters = { power = 1 },
	on_gain = function(self, err) return "#Target# is nearing the end.", "+Fold Fate" end,
	activate = function(self, eff)
		eff.phys = self:addTemporaryValue("resists", { [DamageType.PHYSICAL] = -eff.power})
		eff.temp = self:addTemporaryValue("resists", { [DamageType.TEMPORAL] = -eff.power})
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("resists", eff.phys)
		self:removeTemporaryValue("resists", eff.temp)
	end,
}

-- These are cosmetic so they can be cleared or clicked off
newEffect{
	name = "BEN_TETHER", image = "talents/spatial_tether.png",
	desc = "Spatial Tether",
	long_desc = function(self, eff)
		local chance = eff.chance * core.fov.distance(self.x, self.y, eff.x, eff.y)
		return ("目标被标记于某地，有 %d%% 几率被传送回去，并造成 %0.2f 物理和 %0.2f 时空翘曲爆炸伤害。"):format(chance, eff.dam/2, eff.dam/2)
	end,
	type = "magical",
	subtype = { teleport=true, temporal=true },
	status = "beneficial",
	parameters = { chance = 1 },
	on_gain = function(self, err) return "#Target# has been tethered!", "+Tether" end,
	on_lose = function(self, err) return "#Target# is no longer tethered.", "-Tether" end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "DET_TETHER", image = "talents/spatial_tether.png",
	desc = "Spatial Tether",
	long_desc = function(self, eff)
		local chance = eff.chance * core.fov.distance(self.x, self.y, eff.x, eff.y)
		return ("目标被标记于某地，有 %d%% 几率被传送回去，并造成 %0.2f 物理和 %0.2f时空翘曲爆炸伤害。"):format(chance, eff.dam/2, eff.dam/2)
	end,
	type = "magical",
	subtype = { teleport=true, temporal=true },
	status = "detrimental",
	parameters = { chance = 1 },
	on_gain = function(self, err) return "#Target# has been tethered!", "+Tether" end,
	on_lose = function(self, err) return "#Target# is no longer tethered.", "-Tether" end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "BLIGHT_POISON", image = "effects/poisoned.png",
	desc = "Blight Poison",
	long_desc = function(self, eff) return ("目标中毒，每回合受到 %0.2f 枯萎伤害。"):format(eff.power) end,
	type = "magical",
	subtype = { poison=true, blight=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is poisoned with blight!", "+Blight Poison" end,
	on_lose = function(self, err) return "#Target# is free from the blighted poison.", "-Blight Poison" end,
	on_merge = function(self, old_eff, new_eff)
		-- Merge the poison
		local olddam = old_eff.power * old_eff.dur
		local newdam = new_eff.power * new_eff.dur
		local dur = math.ceil((old_eff.dur + new_eff.dur) / 2)
		old_eff.dur = dur
		old_eff.power = (olddam + newdam) / dur
		if new_eff.max_power then old_eff.power = math.min(old_eff.power, new_eff.max_power) end
		return old_eff
	end,
	on_timeout = function(self, eff)
		if self:attr("purify_poison") then self:heal(eff.power, eff.src)
		else DamageType:get(DamageType.BLIGHT).projector(eff.src, self.x, self.y, DamageType.BLIGHT, eff.power)
		end
	end,
}

newEffect{
	name = "INSIDIOUS_BLIGHT", image = "effects/insidious_poison.png",
	desc = "Insidious Blight",
	long_desc = function(self, eff) return ("目标中毒，每回合受到 %0.2f 枯萎伤害并降低所有治疗效果 %d%%。"):format(eff.power, eff.heal_factor) end,
	type = "magical",
	subtype = { poison=true, blight=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10, heal_factor=30},
	on_gain = function(self, err) return "#Target# is poisoned with insidious blight!!", "+Insidious Blight" end,
	on_lose = function(self, err) return "#Target# is free from the insidious blight.", "-Insidious Blight" end,
	activate = function(self, eff)
		eff.healid = self:addTemporaryValue("healing_factor", -eff.heal_factor / 100)
	end,
	-- There are situations this matters, such as copyEffect
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = math.max(old_eff.dur, new_eff.dur)
		return old_eff
	end,
	on_timeout = function(self, eff)
		if self:attr("purify_poison") then self:heal(eff.power, eff.src)
		else DamageType:get(DamageType.BLIGHT).projector(eff.src, self.x, self.y, DamageType.BLIGHT, eff.power)
		end
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("healing_factor", eff.healid)
	end,
}

newEffect{
	name = "CRIPPLING_BLIGHT", image = "talents/crippling_poison.png",
	desc = "Crippling Blight",
	long_desc = function(self, eff) return ("目标中毒，每回合受到 %0.2f 枯萎伤害，每次使用技能时有 %d%% 概率失败。"):format(eff.power, eff.fail) end,
	type = "magical",
	subtype = { poison=true, blight=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10, fail=5},
	on_gain = function(self, err) return "#Target# is poisoned with crippling blight!", "+Crippling Blight" end,
	on_lose = function(self, err) return "#Target# is free from the crippling blight.", "-Crippling Blight" end,
	-- Damage each turn
	on_timeout = function(self, eff)
		if self:attr("purify_poison") then self:heal(eff.power, eff.src)
		else DamageType:get(DamageType.BLIGHT).projector(eff.src, self.x, self.y, DamageType.BLIGHT, eff.power)
		end
	end,
	-- There are situations this matters, such as copyEffect
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = math.max(old_eff.dur, new_eff.dur)
		return old_eff
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("talent_fail_chance", eff.fail)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("talent_fail_chance", eff.tmpid)
	end,
}

newEffect{
	name = "NUMBING_BLIGHT", image = "effects/numbing_poison.png",
	desc = "Numbing Blight",
	long_desc = function(self, eff) return ("目标中毒，每回合受到 %0.2f 枯萎伤害并减少其造成伤害 %d%%。"):format(eff.power, eff.reduce) end,
	type = "magical",
	subtype = { poison=true, blight=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = {power=10, reduce=5},
	on_gain = function(self, err) return "#Target# is poisoned numbing blight!", "+Numbing Blight" end,
	on_lose = function(self, err) return "#Target# is free from the numbing blight.", "-Numbing Blight" end,
	-- Damage each turn
	on_timeout = function(self, eff)
		if self:attr("purify_poison") then self:heal(eff.power, eff.src)
		else DamageType:get(DamageType.BLIGHT).projector(eff.src, self.x, self.y, DamageType.BLIGHT, eff.power)
		end
	end,
	-- There are situations this matters, such as copyEffect
	on_merge = function(self, old_eff, new_eff)
		old_eff.dur = math.max(old_eff.dur, new_eff.dur)
		return old_eff
	end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("numbed", eff.reduce)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("numbed", eff.tmpid)
	end,
}

newEffect{
	name = "ELDRITCH_STONE", image = "talents/eldritch_stone.png",
	desc = "Eldritch Stone Shield",
	long_desc = function(self, eff)
		return ("The target is surrounded by a stone shield absorbing %d/%d damage.  When the shield is removed, it will explode for up to %d (currently %d) Arcane damage in a radius %d."):
		format(eff.power, eff.max, eff.maxdam, math.min(eff.maxdam, self:getEquilibrium() - self:getMinEquilibrium()), eff.radius)
	end,
	type = "magical",
	subtype = { earth=true, shield=true },
	status = "beneficial",
	parameters = { power=100, radius=3 , maxdam=500},
	on_gain = function(self, err) return "#Target# is encased in a stone shield." end,
	on_lose = function(self, err)
		return ("The stone shield around #Target# %s"):format(self:getEquilibrium() - self:getMinEquilibrium() > 0 and "explodes!" or "crumbles.")
	end,
	on_aegis = function(self, eff, aegis)
		eff.power = eff.power + eff.max * aegis / 100
		if core.shader.active(4) then
			self:removeParticles(eff.particle)
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.3, img="runicshield_stonewarden"}, {type="runicshield", shieldIntensity=0.2, oscillationSpeed=4, ellipsoidalFactor=1.3, time_factor=5000, auraColor={0x61/255, 0xff/255, 0x6a/255, 1}}))
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
		eff.max = eff.power
		if core.shader.active(4) then
			eff.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.3, img="runicshield_stonewarden"}, {type="runicshield", shieldIntensity=0.2, oscillationSpeed=4, ellipsoidalFactor=1.3, time_factor=9000, auraColor={0x61/255, 0xff/255, 0x6a/255, 0}}))
		else
			eff.particle = self:addParticles(Particles.new("damage_shield", 1))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle)

		local equi = self:getEquilibrium() - self:getMinEquilibrium()
		if equi > 0 then
			self:incMana(equi)
			self:incEquilibrium(-equi)
			self:project({type="ball", radius=eff.radius, friendlyfire=false}, self.x, self.y, DamageType.ARCANE, math.min(equi, eff.maxdam))
			game.level.map:particleEmitter(self.x, self.y, eff.radius, "eldricth_stone_explo", {radius=eff.radius})
		end
	end,
}

newEffect{
	name = "DEEPROCK_FORM", image = "talents/deeprock_form.png",
	desc = "Deeprock Form",
	long_desc = function(self, eff)
		local xs = ""
		if eff.arcaneDam and eff.arcanePen then
			xs = xs..(", +%d%% 奥术伤害加成和+%d%% 奥术伤害抗性穿透 "):format(eff.arcaneDam, eff.arcanePen)
		end
		if eff.natureDam and eff.naturePen then
			xs = (", +%d%% 自然伤害加成和 +%d%% 自然抗性穿透 "):format(eff.natureDam, eff.naturePen)..xs
		end
		if eff.immune then
			xs = ("以及 %d%% 震慑、流血、毒素和疾病免疫 "):format(eff.immune*100)..xs
		end
		return ("目标化作巨大的深岩元素形态。体型 + 2 ，并获得 +%d%% 物理伤害加成和 +%d%% 物理伤害抗性穿透 %s"):format(xs, eff.dam, eff.pen, eff.useResist and "  In addition, it uses its physical resistance against all damage." or "")
	end,
	type = "magical",
	subtype = { earth=true, elemental=true },
	status = "beneficial",
	parameters = { dam = 10, pen = 5, armor = 5},
	on_gain = function(self, err) return "#Target# is imbued by the power of the Stone.", "+Deeprock Form" end,
	on_lose = function(self, err) return "#Target# is abandoned by the Stone's power.", "-Deeprock Form" end,
	activate = function(self, eff)
		if self:knowTalent(self.T_VOLCANIC_ROCK) then
			self:learnTalent(self.T_VOLCANO, true, self:getTalentLevelRaw(self.T_VOLCANIC_ROCK) * 2, {no_unlearn=true})
			self:effectTemporaryValue(eff, "talent_cd_reduction", {[self.T_VOLCANO] = 15})

			local t = self:getTalentFromId(self.T_VOLCANIC_ROCK)
			eff.arcaneDam, eff.arcanePen = t.getDam(self, t), t.getPen(self, t)
			self:effectTemporaryValue(eff, "inc_damage", {[DamageType.ARCANE] = eff.arcaneDam})
			self:effectTemporaryValue(eff, "resists_pen", {[DamageType.ARCANE] = eff.arcanePen})
		end

		if self:knowTalent(self.T_BOULDER_ROCK) then
			self:learnTalent(self.T_THROW_BOULDER, true, self:getTalentLevelRaw(self.T_BOULDER_ROCK) * 2, {no_unlearn=true})

			local t = self:getTalentFromId(self.T_BOULDER_ROCK)
			eff.natureDam, eff.naturePen = t.getDam(self, t), t.getPen(self, t)
			self:effectTemporaryValue(eff, "inc_damage", {[DamageType.NATURE] = eff.natureDam})
			self:effectTemporaryValue(eff, "resists_pen", {[DamageType.NATURE] = eff.naturePen})
		end

		if self:knowTalent(self.T_MOUNTAINHEWN) then
			local t = self:getTalentFromId(self.T_MOUNTAINHEWN)
			if self:getTalentLevel(self.T_MOUNTAINHEWN) >= 5 then
				eff.useResist = true
				self:effectTemporaryValue(eff, "force_use_resist", DamageType.PHYSICAL)
			end
			eff.immune = t.getImmune(self, t)
			self:effectTemporaryValue(eff, "cut_immune", eff.immune)
			self:effectTemporaryValue(eff, "poison_immune", eff.immune)
			self:effectTemporaryValue(eff, "disease_immune", eff.immune)
			self:effectTemporaryValue(eff, "stun_immune", eff.immune)
		end

		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.PHYSICAL] = eff.dam})
		self:effectTemporaryValue(eff, "resists_pen", {[DamageType.PHYSICAL] = eff.pen})
		self:effectTemporaryValue(eff, "combat_armor", eff.armor)
		self:effectTemporaryValue(eff, "size_category", 2)

		self.replace_display = mod.class.Actor.new{
			image = "invis.png",
			add_displays = {mod.class.Actor.new{
				image = "npc/elemental_xorn_harkor_zun.png", display_y=-1, display_h=2,
				shader = "shadow_simulacrum",
				shader_args = { color = {0.6, 0.5, 0.2}, base = 0.95, time_factor = 1500 },
			}},
		}
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)
	end,
	deactivate = function(self, eff)
		if self:knowTalent(self.T_VOLCANIC_ROCK) then self:unlearnTalent(self.T_VOLCANO, self:getTalentLevelRaw(self.T_VOLCANIC_ROCK) * 2) end
		if self:knowTalent(self.T_BOULDER_ROCK) then self:unlearnTalent(self.T_THROW_BOULDER, self:getTalentLevelRaw(self.T_BOULDER_ROCK) * 2) end

		self.replace_display = nil
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)
	end,
}

newEffect{
	name = "BATHE_IN_LIGHT", image = "talents/bathe_in_light.png",
	desc = "Bathe in Light",
	long_desc = function(self, eff) return ("火焰和光系伤害增加 %d%%."):format(eff.power)
	end,
	type = "magical",
	subtype = { celestial=true, light=true },
	status = "beneficial",
	parameters = { power = 10 },
	on_gain = function(self, err) return "#Target# glows intensely!", true end,
	on_lose = function(self, err) return "#Target# is no longer glowing .", true end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_damage", {[DamageType.FIRE]=eff.power, [DamageType.LIGHT]=eff.power})
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "OVERSEER_OF_NATIONS", image = "talents/overseer_of_nations.png",
	desc = "Overseer of Nations",
	long_desc = function(self, eff) return ("在15格范围内感知以下种族： %s/%s "):format(eff.type, eff.subtype) end,
	type = "magical",
	subtype = { higher=true },
	status = "beneficial",
	parameters = { type="humanoid", subtype="human" },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "esp", {[eff.type.."/"..eff.subtype]=1})
		self:effectTemporaryValue(eff, "esp_range", 5)
	end,
	deactivate = function(self, eff)
	end,
}


newEffect{
	name = "PACIFICATION_HEX", image = "talents/pacification_hex.png",
	desc = "Pacification Hex",
	long_desc = function(self, eff) return ("目标受邪术影响，每回合有 %d%% 概率眩晕 3 回合。"):format(eff.chance) end,
	type = "magical",
	subtype = { hex=true, dominate=true },
	status = "detrimental",
	parameters = {chance=10, power=10},
	on_gain = function(self, err) return "#Target# is hexed!", "+Pacification Hex" end,
	on_lose = function(self, err) return "#Target# is free from the hex.", "-Pacification Hex" end,
	-- Damage each turn
	on_timeout = function(self, eff)
		if not self:hasEffect(self.EFF_DAZED) and rng.percent(eff.chance) and self:canBe("stun") then
			self:setEffect(self.EFF_DAZED, 3, {})
			if not self:checkHit(eff.power, self:combatSpellResist(), 0, 95, 15) then eff.dur = 0 end
		end
	end,
	activate = function(self, eff)
		if self:canBe("stun") then
			self:setEffect(self.EFF_DAZED, 3, {})
		end
		if core.shader.active() then
			local h1x, h1y = self:attachementSpot("head", true) if h1x then eff.particle = self:addParticles(Particles.new("circle", 1, {shader=true, oversize=0.5, a=225, appear=8, speed=0, img="pacification_hex_debuff_aura", base_rot=0, radius=0, x=h1x, y=h1y})) end
		end
	end,
	deactivate = function(self, eff)
		if eff.particle then self:removeParticles(eff.particle) end
	end,
}

newEffect{
	name = "BURNING_HEX", image = "talents/burning_hex.png",
	desc = "Burning Hex",
	long_desc = function(self, eff) return ("目标受邪术影响，每次施放技能都会受到 %0.2f 火焰伤害, 技能冷却延长 %s 再延长 1 回合。"):
		format(eff.dam, eff.power and ("%d%%"):format((eff.power-1)*100) or "")
	end,
	charges = function(self, eff) return (tostring(math.floor((eff.power-1)*100)).."%") end,
	type = "magical",
	subtype = { hex=true, fire=true },
	status = "detrimental",
	-- _M:getTalentCooldown(t) in mod.class.Actor.lua references this table to compute cooldowns
	parameters = {dam=10, power = 1},
	on_gain = function(self, err) return "#Target# is hexed!", "+Burning Hex" end,
	on_lose = function(self, err) return "#Target# is free from the hex.", "-Burning Hex" end,
}

newEffect{
	name = "EMPATHIC_HEX", image = "talents/empathic_hex.png",
	desc = "Empathic Hex",
	long_desc = function(self, eff) return ("目标受邪术影响，使其造成的伤害发生偏转，所有其造成的伤害有 %d%% 会反弹给自己。"):format(eff.power) end,
	charges = function(self, eff) return (tostring(math.floor(eff.power)).."%") end,	
	type = "magical",
	subtype = { hex=true, dominate=true },
	status = "detrimental",
	parameters = { power=10 },
	on_gain = function(self, err) return "#Target# is hexed.", "+Empathic Hex" end,
	on_lose = function(self, err) return "#Target# is free from the hex.", "-Empathic hex" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("martyrdom", eff.power)
		if core.shader.active() then
			local h1x, h1y = self:attachementSpot("head", true) if h1x then eff.particle = self:addParticles(Particles.new("circle", 1, {toback=true, shader=true, oversize=0.5, a=225, appear=8, speed=0, img="empathic_hex_debuff_aura", base_rot=0, radius=0, x=h1x, y=h1y})) end
		end
	end,
	deactivate = function(self, eff)
		if eff.particle then self:removeParticles(eff.particle) end
		self:removeTemporaryValue("martyrdom", eff.tmpid)
	end,
}

newEffect{
	name = "DOMINATION_HEX", image = "talents/domination_hex.png",
	desc = "Domination Hex",
	long_desc = function(self, eff) return ("目标受邪术影响，暂时改变阵营至 %s 。"):format(engine.Faction.factions[eff.faction].name) end,
	type = "magical",
	subtype = { hex=true, dominate=true },
	status = "detrimental",
	parameters = {},
	on_gain = function(self, err) return "#Target# is hexed.", "+Domination Hex" end,
	on_lose = function(self, err) return "#Target# is free from the hex.", "-Domination hex" end,
	activate = function(self, eff)
		self:setTarget() -- clear ai target
		eff.olf_faction = self.faction
		self.faction = eff.src.faction
		if core.shader.active() then
			local h1x, h1y = self:attachementSpot("head", true) if h1x then eff.particle = self:addParticles(Particles.new("circle", 1, {shader=true, oversize=1, a=225, appear=8, speed=0, img="domination_hex_debuff_aura", base_rot=0, radius=0, x=h1x, y=h1y})) end
		end
	end,
	deactivate = function(self, eff)
		if eff.particle then self:removeParticles(eff.particle) end
		self.faction = eff.olf_faction
	end,
}

newEffect{
	name = "SHADOWGUARD_IMMUNITY", image = "talents/shadowguard.png",
	desc = "Shadowguard Immunity",
	long_desc = function(self, eff) return "目标对所有负面状态免疫。" end,
	type = "other",
	subtype = { shadow=true },
	status = "beneficial",
	on_gain = function(self, err) return "#Target#'s fades into the shadows.", "+Shadowguard" end,
	on_lose = function(self, err) return "#Target#'s can be afflicted again.", "-Shadowguard" end,
	parameters = { },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "negative_status_effect_immune", 1)
	end,
}

newEffect{
	name = "SHADOWGUARD_BUFF", image = "talents/shadowguard.png",
	desc = "Shadowguard",
	long_desc = function(self, eff) return ("目标进入自身的阴影，获得 %d 法术强度和闪避。"):format(eff.spellpower) end,
	type = "magical",
	subtype = { shadow=true },
	status = "beneficial",
	--on_gain = function(self, err) return "#Target#'s fades into the shadows.", "+Shadowguard" end,
	on_lose = function(self, err) return "#Target#'s fully exits the shadows.", "-Shadowguard" end,
	parameters = { spellpower=0},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_spellpower", eff.spellpower)
		self:effectTemporaryValue(eff, "combat_def", eff.spellpower)
	end,
}

newEffect{
	name = "RETCHED", image = "talents/retch.png",
	desc = "Retched",
	long_desc = function(self, eff) return (" 目标站在自己的亡灵唾液上，暂时取消了食尸鬼种族的速度惩罚。"):format() end,
	type = "magical",
	subtype = { undead=true, speed=true },
	status = "beneficial",
	on_gain = function(self, err) return "#Target# speeds up in the retch.", "+Retched" end,
	on_lose = function(self, err) return "#Target# speeds down outside of the retch.", "-Retched" end,
	parameters = { spellpower=0},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "global_speed_add", 0.2)
	end,
}

newEffect{
	name = "SHADOW_CUT", image = "",
	desc = "Shadow Cut",
	long_desc = function(self, eff) return ("正在流血的巨大的暗影伤口，每回合造成 %0.2f 暗影伤害。每次你击中目标将受到 %d 点治疗。"):format(eff.dam/5, eff.heal) end,
	type = "magical",
	subtype = { wound=true, cut=true, bleed=true, darkness=true },
	status = "detrimental",
	parameters = { dam=1, heal=1 },
	on_gain = function(self, err) return "#Target# starts to bleed darkness.", "+Shadow Cut" end,
	on_lose = function(self, err) return "#Target# stops bleeding darkness.", "-Shadow Cut" end,
	callbackOnMeleeHit = function(self, eff, src, dam)
		if not dam or dam <= 0 or src ~= eff.src then return end

		src:heal(eff.heal)
		if core.shader.active(4) then
			src:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healdark", life=25}, {type="healing", time_factor=6000, beamsCount=15, noup=2.0, beamColor1={0xcb/255, 0xcb/255, 0xcb/255, 1}, beamColor2={0x35/255, 0x35/255, 0x35/255, 1}}))
			src:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healdark", life=25}, {type="healing", time_factor=6000, beamsCount=15, noup=1.0, beamColor1={0xcb/255, 0xcb/255, 0xcb/255, 1}, beamColor2={0x35/255, 0x35/255, 0x35/255, 1}}))
		end
		game:playSoundNear(src, "talents/heal")
	end,
	activate = function(self, eff)
		if eff.src and eff.src:knowTalent(self.T_BLOODY_BUTCHER) then
			local t = eff.src:getTalentFromId(eff.src.T_BLOODY_BUTCHER)
			local resist = math.min(t.getResist(eff.src, t), math.max(0, self:combatGetResist(DamageType.PHYSICAL)))
			self:effectTemporaryValue(eff, "resists", {[DamageType.PHYSICAL] = -resist})
		end
	end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.DARKNESS).projector(eff.src or self, self.x, self.y, DamageType.DARKNESS, eff.dam)
	end,
}

newEffect{
	name = "GLYPH_OF_MOONLIGHT", image = "trap/trap_glyph_fatigue_01_64.png",
	desc = "Draining Moonlight",
	long_desc = function(self, eff) return ("目标被圣印汲取能量，造成的所有伤害降低 %d%%"):format(eff.reduce) end,
	type = "magical",
	subtype = { darkness=true,},
	status = "detrimental",
	parameters = {reduce=5},
	on_gain = function(self, err) return "#Target# is weakened by the glyph of moonlight!", "+Draining Moonlight" end,
	on_lose = function(self, err) return "#Target# looks shakes off the effect of the glyph of moonlight.", "-Draining Moonlight" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "numbed", eff.reduce)
	end,
	deactivate = function(self, eff)
	end,
}
