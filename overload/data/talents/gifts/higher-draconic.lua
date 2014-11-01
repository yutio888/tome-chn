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

newTalent{
	name = "Prismatic Slash",
	type = {"wild-gift/higher-draconic", 1},
	require = gifts_req_high1,
	points = 5,
	random_ego = "attack",
	equilibrium = 20,
	cooldown = 16,
	range = 1,
	tactical = { ATTACK = { PHYSICAL = 1, COLD = 1, FIRE = 1, LIGHTNING = 1, ACID = 1 } },
	requires_target = true,
	getWeaponDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.2, 2.0) end,
	getBurstDamage = function(self, t) return self:combatTalentMindDamage(t, 20, 230) end,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1.5, 3.5)) end,
	on_learn = function(self, t) 
		self.combat_physresist = self.combat_physresist + 1
		self.combat_spellresist = self.combat_spellresist + 1
		self.combat_mentalresist = self.combat_mentalresist + 1
	end,
	on_unlearn = function(self, t) 
		self.combat_physresist = self.combat_physresist - 1
		self.combat_spellresist = self.combat_spellresist - 1
		self.combat_mentalresist = self.combat_mentalresist - 1
	end,
	action = function(self, t)

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		local elem = rng.table{"phys", "cold", "fire", "lightning", "acid",}

			if elem == "phys" then
				self:attackTarget(target, DamageType.PHYSICAL, t.getWeaponDamage(self, t), true)
				local tg = {type="ball", range=1, selffire=false, radius=self:getTalentRadius(t), talent=t}
				local grids = self:project(tg, x, y, DamageType.SAND, {dur=3, dam=self:mindCrit(t.getBurstDamage(self, t))})
				game.level.map:particleEmitter(x, y, tg.radius, "ball_matter", {radius=tg.radius, grids=grids, tx=x, ty=y, max_alpha=80})
				game:playSoundNear(self, "talents/flame")
			elseif elem == "cold" then
				self:attackTarget(target, DamageType.ICE, t.getWeaponDamage(self, t), true)
				local tg = {type="ball", range=1, selffire=false, radius=self:getTalentRadius(t), talent=t}
				local grids = self:project(tg, x, y, DamageType.ICE, self:mindCrit(t.getBurstDamage(self, t)))
				game.level.map:particleEmitter(x, y, tg.radius, "ball_ice", {radius=tg.radius, grids=grids, tx=x, ty=y, max_alpha=80})
				game:playSoundNear(self, "talents/flame")
			elseif elem == "fire" then
				self:attackTarget(target, DamageType.FIREBURN, t.getWeaponDamage(self, t), true)
				local tg = {type="ball", range=1, selffire=false, radius=self:getTalentRadius(t), talent=t}
				local grids = self:project(tg, x, y, DamageType.FIREBURN, self:mindCrit(t.getBurstDamage(self, t)))
				game.level.map:particleEmitter(x, y, tg.radius, "ball_fire", {radius=tg.radius, grids=grids, tx=x, ty=y, max_alpha=80})
				game:playSoundNear(self, "talents/flame")
			elseif elem == "lightning" then
				self:attackTarget(target, DamageType.LIGHTNING_DAZE, t.getWeaponDamage(self, t), true)
				local tg = {type="ball", range=1, selffire=false, radius=self:getTalentRadius(t), talent=t}
				local grids = self:project(tg, x, y, DamageType.LIGHTNING_DAZE, self:mindCrit(t.getBurstDamage(self, t)))
				game.level.map:particleEmitter(x, y, tg.radius, "ball_lightning", {radius=tg.radius, grids=grids, tx=x, ty=y, max_alpha=80})
				game:playSoundNear(self, "talents/flame")
			elseif elem == "acid" then
				self:attackTarget(target, DamageType.ACID_DISARM, t.getWeaponDamage(self, t), true)
				local tg = {type="ball", range=1, selffire=false, radius=self:getTalentRadius(t), talent=t}
				local grids = self:project(tg, x, y, DamageType.ACID_DISARM, self:mindCrit(t.getBurstDamage(self, t)))
				game.level.map:particleEmitter(x, y, tg.radius, "ball_acid", {radius=tg.radius, grids=grids, tx=x, ty=y, max_alpha=80})
				game:playSoundNear(self, "talents/flame")
			end
		return true
	end,
	info = function(self, t)
		local burstdamage = t.getBurstDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[向 你 的 敌 人 释 放 原 始 的 混 乱 元 素 攻 击。 
		 你 有 几 率 使 用 致 盲 之 沙、 缴 械 酸 雾、 冰 结 之 息、 震 慑 闪 电 或 燃 烧 之 焰 攻 击 敌 人， 造 成 %d%% 点 对 应 伤 害 类 型 的 武 器 伤 害。 
		 此 外， 无 论 你 的 元 素 攻 击 是 否 命 中 敌 人 你 都 会 对 %d 码 半 径 范 围 内 的 敌 人 造 成 %0.2f 伤 害。 
		 每 提 升 1 级 五 灵 挥 击 会 增 加 你 的 物 理、 法 术 和 精 神 豁 免 1 点。]]):format(100 * self:combatTalentWeaponDamage(t, 1.2, 2.0), radius, burstdamage)
	end,
}

newTalent{
	name = "Venomous Breath",
	type = {"wild-gift/higher-draconic", 2},
	require = gifts_req_high2,
	points = 5,
	random_ego = "attack",
	equilibrium = 12,
	cooldown = 12,
	message = "@Source@ breathes venom!",
	tactical = { ATTACKAREA = { poison = 2 } },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	direct_hit = true,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentStatDamage(t, "str", 60, 650) end,
	getEffect = function(self, t) return self:combatTalentLimit(t, 100, 18, 50) end, -- Limit < 100%
	on_learn = function(self, t) self.resists[DamageType.NATURE] = (self.resists[DamageType.NATURE] or 0) + 2 end,
	on_unlearn = function(self, t) self.resists[DamageType.NATURE] = (self.resists[DamageType.NATURE] or 0) - 2 end,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.INSIDIOUS_POISON, {dam=self:mindCrit(t.getDamage(self,t)), dur=6, heal_factor=t.getEffect(self,t)})
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_slime", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/breath")
		
		if core.shader.active(4) then
			local bx, by = self:attachementSpot("back", true)
			self:addParticles(Particles.new("shader_wings", 1, {img="poisonwings", x=bx, y=by, life=18, fade=-0.006, deploy_speed=14}))
		end
		return true
	end,
	info = function(self, t)
		local effect = t.getEffect(self, t)
		return ([[你 向 %d 码 锥 形 半 径 范 围 的 敌 人 释 放 剧 毒 吐 息。 在 攻 击 范 围 内 的 敌 人， 每 回 合 会 受 到 %0.2f 自 然 伤 害， 持 续 6 回 合。 
		 剧 毒 同 时 降 低 受 影 响 目 标 %d%% 生 命 回 复。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成； 技 能 暴 击 率 基 于 精 神 暴 击 值 计 算。 
		 每 提 升 1 级 剧 毒 吐 息 同 样 增 加 你 2％ 自 然 抵 抗。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.NATURE, t.getDamage(self,t)/6), effect)
	end,
}

newTalent{
	name = "Wyrmic Guile",
	type = {"wild-gift/higher-draconic", 3},
	require = gifts_req_high3,
	points = 5,
	mode = "passive",
	resistKnockback = function(self, t) return self:combatTalentLimit(t, 1, .17, .5) end, -- Limit < 100%
	resistBlindStun = function(self, t) return self:combatTalentLimit(t, 1, .07, .25) end, -- Limit < 100%
	on_learn = function(self, t)
		self.inc_stats[self.STAT_CUN] = self.inc_stats[self.STAT_CUN] + 2
	end,
	on_unlearn = function(self, t)
		self.inc_stats[self.STAT_CUN] = self.inc_stats[self.STAT_CUN] - 2
	end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "knockback_immune", t.resistKnockback(self, t))
		self:talentTemporaryValue(p, "stun_immune", t.resistBlindStun(self, t))
		self:talentTemporaryValue(p, "blind_immune", t.resistBlindStun(self, t))
	end,
	info = function(self, t)
		return ([[你 继 承 了 龙 族 的 狡 诈。 
		 你 的 灵 巧 增 加 %d 点。 
		 你 获 得 %d%% 击 退 抵 抗 和 %d%% 致 盲、 震 慑 抵 抗。]]):format(2*self:getTalentLevelRaw(t), 100*t.resistKnockback(self, t), 100*t.resistBlindStun(self, t))
	end,
}

newTalent{
	name = "Chromatic Fury",
	type = {"wild-gift/higher-draconic", 4},
	require = gifts_req_high4,
	points = 5,
	mode = "passive",
	resistPen = function(tl)
		if tl <=0 then return 0 end
		return math.floor(mod.class.interface.Combat.combatTalentLimit({}, tl, 100, 4, 20))
	end, -- Limit < 100%
	on_learn = function(self, t)
		self.resists[DamageType.PHYSICAL] = (self.resists[DamageType.PHYSICAL] or 0) + 0.5
		self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) + 0.5
		self.resists[DamageType.FIRE] = (self.resists[DamageType.FIRE] or 0) + 0.5
		self.resists[DamageType.LIGHTNING] = (self.resists[DamageType.LIGHTNING] or 0) + 0.5
		self.resists[DamageType.ACID] = (self.resists[DamageType.ACID] or 0) + 0.5

		local rpchange = t.resistPen(self:getTalentLevelRaw(t)) - t.resistPen(self:getTalentLevelRaw(t)-1)
		self.resists_pen[DamageType.PHYSICAL] = (self.resists_pen[DamageType.PHYSICAL] or 0) + rpchange 
		self.resists_pen[DamageType.COLD] = (self.resists_pen[DamageType.COLD] or 0) + rpchange 
		self.resists_pen[DamageType.FIRE] = (self.resists_pen[DamageType.FIRE] or 0) + rpchange
		self.resists_pen[DamageType.LIGHTNING] = (self.resists_pen[DamageType.LIGHTNING] or 0) + rpchange
		self.resists_pen[DamageType.ACID] = (self.resists_pen[DamageType.ACID] or 0) + rpchange 

		self.inc_damage[DamageType.PHYSICAL] = (self.inc_damage[DamageType.PHYSICAL] or 0) + 2
		self.inc_damage[DamageType.COLD] = (self.inc_damage[DamageType.COLD] or 0) + 2
		self.inc_damage[DamageType.FIRE] = (self.inc_damage[DamageType.FIRE] or 0) + 2
		self.inc_damage[DamageType.LIGHTNING] = (self.inc_damage[DamageType.LIGHTNING] or 0) + 2
		self.inc_damage[DamageType.ACID] = (self.inc_damage[DamageType.ACID] or 0) + 2
	end,
	on_unlearn = function(self, t)
		self.resists[DamageType.PHYSICAL] = (self.resists[DamageType.PHYSICAL] or 0) - 0.5
		self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) - 0.5
		self.resists[DamageType.FIRE] = (self.resists[DamageType.FIRE] or 0) - 0.5
		self.resists[DamageType.LIGHTNING] = (self.resists[DamageType.LIGHTNING] or 0) - 0.5
		self.resists[DamageType.ACID] = (self.resists[DamageType.ACID] or 0) - 0.5

		local rpchange = t.resistPen(self:getTalentLevelRaw(t)) - t.resistPen(self:getTalentLevelRaw(t)+1)
		self.resists_pen[DamageType.PHYSICAL] = (self.resists_pen[DamageType.PHYSICAL] or 0) + rpchange
		self.resists_pen[DamageType.COLD] = (self.resists_pen[DamageType.COLD] or 0) + rpchange
		self.resists_pen[DamageType.FIRE] = (self.resists_pen[DamageType.FIRE] or 0) + rpchange
		self.resists_pen[DamageType.LIGHTNING] = (self.resists_pen[DamageType.LIGHTNING] or 0) + rpchange
		self.resists_pen[DamageType.ACID] = (self.resists_pen[DamageType.ACID] or 0) + rpchange

		self.inc_damage[DamageType.PHYSICAL] = (self.inc_damage[DamageType.PHYSICAL] or 0) - 2
		self.inc_damage[DamageType.COLD] = (self.inc_damage[DamageType.COLD] or 0) - 2
		self.inc_damage[DamageType.FIRE] = (self.inc_damage[DamageType.FIRE] or 0) - 2
		self.inc_damage[DamageType.LIGHTNING] = (self.inc_damage[DamageType.LIGHTNING] or 0) - 2
		self.inc_damage[DamageType.ACID] = (self.inc_damage[DamageType.ACID] or 0) - 2
	end,
	info = function(self, t)
		return ([[你 获 得 了 七 彩 巨 龙 的 传 承， 并 且 你 对 元 素 的 掌 控 达 到 了 新 的 高 峰。 
		 增 加 %d%% 物 理、 火 焰、 寒 冷、 闪 电 和 酸 性 伤 害 , 同 时 增 加 %d%% 对 应 的 抵 抗 穿 透。 
		 每 提 升 1 级 天 龙 之 怒 也 会 增 加 0.5％ 物 理、 火 焰、 寒 冷、 闪 电 和 酸 性 抵 抗。]])
		:format(2*self:getTalentLevelRaw(t), t.resistPen(self:getTalentLevelRaw(t)))
	end,
}
