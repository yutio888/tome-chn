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
	name = "Swallow",
	type = {"wild-gift/sand-drake", 1},
	require = gifts_req1,
	points = 5,
	equilibrium = 4,
	cooldown = 10,
	range = 1,
	no_message = true,
	tactical = { ATTACK = { NATURE = 0.5 }, EQUILIBRIUM = 0.5},
	requires_target = true,
	no_npc_use = true,
	maxSwallow = function(self, t, target) return -- Limit < 50%
		self:combatLimit(self:getTalentLevel(t)*(self.size_category or 3)/(target.size_category or 3), 50, 13, 1, 25, 5)
	end,
	on_learn = function(self, t) self.resists[DamageType.PHYSICAL] = (self.resists[DamageType.PHYSICAL] or 0) + 0.5 end,
	on_unlearn = function(self, t) self.resists[DamageType.PHYSICAL] = (self.resists[DamageType.PHYSICAL] or 0) - 0.5 end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		self:logCombat(target, "#Source# 试图吞噬 #Target#!")
		local hit = self:attackTarget(target, DamageType.NATURE, self:combatTalentWeaponDamage(t, 1, 1.5), true)
		if not hit then return true end

		if (target.life * 100 / target.max_life > t.maxSwallow(self, t, target)) and not target.dead then
			return true
		end

		if (target:checkHit(self:combatPhysicalpower(), target:combatPhysicalResist(), 0, 95, 15) or target.dead) and (target:canBe("instakill") or target.life * 100 / target.max_life <= 5) then
			if not target.dead then target:die(self) end
			world:gainAchievement("EAT_BOSSES", self, target)
			self:incEquilibrium(-target.level - 5)
			self:attr("allow_on_heal", 1)
			self:heal(target.level * 2 + 5, target)
			if core.shader.active(4) then
				self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true ,size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0}))
				self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false,size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0}))
			end
			self:attr("allow_on_heal", -1)
		else
			game.logSeen(target, "%s resists!", target.name:capitalize())
		end
		return true
	end,
	info = function(self, t)
		return ([[对 目 标 造 成 %d%% 自 然 武 器 伤 害。 
		 如 果 此 攻 击 将 目 标 生 命 值 降 低 到 %d%% 以 下 或 杀 死 它 时 你 可 以 吞 噬 它 并 杀 死 它， 依 目 标 等 级 恢 复 你 的 生 命 和 自 然 失 衡 值。 
		 吞 噬 几 率 取 决 于 技 能 等 级 和 对 方 体 型 大 小。 
		 每 点 土 龙 系 的 天 赋 可 以 使 你 增 加 物 理 抵 抗 0.5%%。]]):
		format(100 * self:combatTalentWeaponDamage(t, 1, 1.5), t.maxSwallow(self, t, self))
	end,
}

newTalent{
	name = "Quake",
	type = {"wild-gift/sand-drake", 2},
	require = gifts_req2,
	points = 5,
	random_ego = "attack",
	message = "@Source@ shakes the ground!",
	equilibrium = 4,
	cooldown = 30,
	tactical = { ATTACKAREA = { PHYSICAL = 2 }, DISABLE = { knockback = 2 } },
	range = 10,
	on_learn = function(self, t) self.resists[DamageType.PHYSICAL] = (self.resists[DamageType.PHYSICAL] or 0) + 0.5 end,
	on_unlearn = function(self, t) self.resists[DamageType.PHYSICAL] = (self.resists[DamageType.PHYSICAL] or 0) - 0.5 end,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4.5)) end,
	no_npc_use = true,
	getDamage = function(self, t)
		return self:combatDamage() * 0.8
	end,
	action = function(self, t)
		local tg = {type="ball", range=0, selffire=false, radius=self:getTalentRadius(t), talent=t, no_restrict=true}
		self:project(tg, self.x, self.y, DamageType.PHYSKNOCKBACK, {dam=self:mindCrit(t.getDamage(self, t)), dist=4})
		self:doQuake(tg, self.x, self.y)
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local dam = t.getDamage(self, t)
		return ([[你 猛 踩 大 地， 在 %d 码 范 围 内 造 成 地 震。 
		 在 地 震 范 围 内 的 怪 物 会 受 到 %d 点 伤 害 并 被 击 退 4 码。 
		 在 地 震 范 围 内 的 地 形 也 会 受 到 影 响。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成。 
		 每 点 土 龙 系 的 天 赋 可 以 使 你 增 加 物 理 抵 抗 0.5%% 。]]):format(radius, dam)
	end,
}

newTalent{
	name = "Burrow",
	type = {"wild-gift/sand-drake", 3},
	require = gifts_req3,
	points = 5,
	equilibrium = 50,
	cooldown = 30,
	range = 10,
	tactical = { CLOSEIN = 0.5, ESCAPE = 0.5 },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 8, 20, 0.5, 0, 2)) end,
	on_learn = function(self, t) self.resists[DamageType.PHYSICAL] = (self.resists[DamageType.PHYSICAL] or 0) + 0.5 end,
	on_unlearn = function(self, t) self.resists[DamageType.PHYSICAL] = (self.resists[DamageType.PHYSICAL] or 0) - 0.5 end,
	action = function(self, t)
		self:setEffect(self.EFF_BURROW, t.getDuration(self, t), {})
		return true
	end,
	info = function(self, t)
		return ([[允 许 你 钻 进 墙 里， 持 续 %d 回 合。 
		 每 点 土 龙 系 的 天 赋 可 以 使 你 增 加 物 理 抵 抗 0.5%% 。]]):format(t.getDuration(self, t))
	end,
}

newTalent{
	name = "Sand Breath",
	type = {"wild-gift/sand-drake", 4},
	require = gifts_req4,
	points = 5,
	random_ego = "attack",
	equilibrium = 12,
	cooldown = 12,
	message = "@Source@ breathes sand!",
	tactical = { ATTACKAREA = {PHYSICAL = 2}, DISABLE = { blind = 2 } },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	direct_hit = true,
	requires_target = true,
	on_learn = function(self, t) self.resists[DamageType.PHYSICAL] = (self.resists[DamageType.PHYSICAL] or 0) + 0.5 end,
	on_unlearn = function(self, t) self.resists[DamageType.PHYSICAL] = (self.resists[DamageType.PHYSICAL] or 0) - 0.5 end,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	getDamage = function(self, t)
		return self:combatTalentStatDamage(t, "str", 30, 400)
	end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.SAND, {dur=t.getDuration(self, t), dam=self:mindCrit(t.getDamage(self, t))})
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_earth", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/breath")
		
		if core.shader.active(4) then
			local bx, by = self:attachementSpot("back", true)
			self:addParticles(Particles.new("shader_wings", 1, {img="sandwings", x=bx, y=by, life=18, fade=-0.006, deploy_speed=14}))
		end
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 在 前 方 %d 码 锥 形 范 围 内 喷 出 流 沙。 此 范 围 内 的 目 标 会 受 到 %0.2f 物 理 伤 害 并 被 致 盲 %d 回 合。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成。 技 能 暴 击 率 基 于 精 神 暴 击 值 计 算。
		 每 点 土 龙 系 的 天 赋 可 以 使 你 增 加 物 理 抵 抗 0.5%% 。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.PHYSICAL, damage), duration)
	end,
}


