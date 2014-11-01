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
local Object = require "engine.Object"

newTalent{
	name = "Frost Infusion",
	type = {"spell/frost-alchemy", 1},
	mode = "sustained",
	require = spells_req1,
	sustain_mana = 30,
	points = 5,
	cooldown = 30,
	tactical = { BUFF = 2 },
	getIncrease = function(self, t) return self:combatTalentScale(t, 0.05, 0.25) * 100 end,
	activate = function(self, t)
		cancelAlchemyInfusions(self)
		game:playSoundNear(self, "talents/arcane")
		local ret = {}
		self:talentTemporaryValue(ret, "inc_damage", {[DamageType.COLD] = t.getIncrease(self, t)})
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local daminc = t.getIncrease(self, t)
		return ([[将 寒 冰 能 量 填 充 至 炼 金 炸 弹 ， 能 冰 冻 敌 人 。
		 你 造 成 的 寒 冰 伤 害 增 加 %d%% 。]]):
		format(daminc)
	end,
}

newTalent{
	name = "Ice Armour",
	type = {"spell/frost-alchemy", 2},
	require = spells_req2,
	mode = "passive",
	points = 5,
	getDuration = function(self, t) return math.floor(self:combatScale(self:combatSpellpower(0.03) * self:getTalentLevel(t), 2, 0, 10, 8)) end,
	getArmor = function(self, t) return self:combatTalentSpellDamage(t, 10, 25) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 5, 70) end,
	applyEffect = function(self, t, golem)
		local duration = t.getDuration(self, t)
		local dam = t.getDamage(self, t)
		local armor = t.getArmor(self, t)
		golem:setEffect(golem.EFF_ICE_ARMOUR, duration, {armor=armor, dam=dam})
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local dam = self.alchemy_golem and self.alchemy_golem:damDesc(engine.DamageType.COLD, t.getDamage(self, t)) or 0
		local armor = t.getArmor(self, t)
		return ([[当 你 的 寒 冰 充 能 激 活 时 ， 若 你 的 炸 弹 击 中 了 你 的 傀 儡 ， 冰 霜 会 覆 盖 傀 儡 %d 回 合 。
		 冰 霜 会 增 加 傀 儡 %d 点 护 甲 ， 同 时 受 到 近 战 攻 击 时 ， 会 反 击 攻 击 方 %0.1f 点 寒 冷 伤 害 ， 同 时 傀 儡 造 成 的 一 半 伤 害 转 化 为 寒 冰 伤 害 。
		 受 法 术 强 度 、 技 能 等 级 和 傀 儡 伤 害 影 响 ， 效 果 有 额 外 加 成 。]]):
		format(duration, armor, dam)
	end,
}

newTalent{
	name = "Flash Freeze",
	type = {"spell/frost-alchemy",3},
	require = spells_req3,
	points = 5,
	mana = 30,
	cooldown = 20,
	requires_target = true,
	tactical = { DISABLE = { stun = 1 }, ATTACKAREA = { COLD = 2 } },
	no_energy = true,
	range = 0,
	getDuration = function(self, t) return math.floor(self:combatScale(self:combatSpellpower(0.03) * self:getTalentLevel(t), 2, 0, 10, 8)) end,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 250) end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false, talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local grids = self:project(tg, self.x, self.y, DamageType.COLDNEVERMOVE, {dur=t.getDuration(self, t), dam=t.getDamage(self, t)})
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "ball_ice", {radius=tg.radius})
		game:playSoundNear(self, "talents/ice")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[ 在 半 径 %d 的 范 围 内 激 发 寒 冰 能 量 ， 造 成 %0.1f 点 寒 冷 伤 害 ， 同 时 将 周 围 的 生 物 冻 结 在 地 面 上 %d 个 回 合。 
		 受 影 响 的 生 物 能 够 行 动 ， 但 不 能 移 动。
		 受 法 术 强 度 影 响 ， 持 续 时 间 有 额 外 加 成 。]]):format(radius, damDesc(self, DamageType.COLD, t.getDamage(self, t)), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Ice Core", short_name = "BODY_OF_ICE",
	type = {"spell/frost-alchemy",4},
	require = spells_req4,
	mode = "sustained",
	cooldown = 40,
	sustain_mana = 100,
	points = 5,
	range = 6,
	tactical = { BUFF=1 },
	critResist = function(self, t) return self:combatTalentScale(t, 10, 50) end,
	getResistance = function(self, t) return self:combatTalentSpellDamage(t, 5, 45) end,
	getAffinity = function(self, t) return self:combatTalentLimit(t, 50, 5, 20) end, -- Limit <50%
	activate = function(self, t)
		game:playSoundNear(self, "talents/ice")
		local ret = {}
		self:addShaderAura("body_of_ice", "crystalineaura", {}, "particles_images/spikes.png")
		ret.particle = self:addParticles(Particles.new("snowfall", 1))
		self:talentTemporaryValue(ret, "resists", {[DamageType.PHYSICAL] = t.getResistance(self, t) * 0.6})
		self:talentTemporaryValue(ret, "damage_affinity", {[DamageType.COLD] = t.getAffinity(self, t)})
		self:talentTemporaryValue(ret, "ignore_direct_crits", t.critResist(self, t))
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		self:removeShaderAura("body_of_ice")
		return true
	end,
	info = function(self, t)
		local resist = t.getResistance(self, t)
		local crit = t.critResist(self, t)
		return ([[ 将 你 的 身 体 转 化 为 纯 净 的 寒 冰 体  ， 你 受 到 的 寒 冰 伤 害 的 %d%% 会 治 疗 你 ， 同 时 你  的 物 理 抗 性 增 加 %d%%。
		对 你 的 直 接 暴 击 会 减 少 %d%% 暴 击 系 数 ， 但 不 会 少 于 普 通 伤 害 。 
 		受 法 术 强 度 影 响 ， 效 果 有 额 外 加 成 。]]):
		format(t.getAffinity(self, t), resist, resist * 0.6, crit)
	end,
}


