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
	name = "Lightning Speed",
	type = {"wild-gift/storm-drake", 1},
	require = gifts_req1,
	points = 5,
	equilibrium = 10,
	cooldown = 26,
	range = 10,
	tactical = { CLOSEIN = 2, ESCAPE = 2 },
	requires_target = true,
	no_energy = true,
	getSpeed = function(self, t) return self:combatTalentScale(t, 470, 750, 0.75) end,
	getDuration = function(self, t) return math.ceil(self:combatTalentScale(t, 1.1, 2.6)) end,
	on_learn = function(self, t) self.resists[DamageType.LIGHTNING] = (self.resists[DamageType.LIGHTNING] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.LIGHTNING] = (self.resists[DamageType.LIGHTNING] or 0) - 1 end,
	on_pre_use = function(self, t) return not self:attr("never_move") end,
	action = function(self, t)
		self:setEffect(self.EFF_LIGHTNING_SPEED, self:mindCrit(t.getDuration(self, t)), {power=t.getSpeed(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[你 转 化 为 闪 电， 增 加 %d%% 移 动 速 度， 持 续 %d 回 合。 
		 同 时 提 供 30%% 物 理 伤 害 抵 抗 和 100%% 闪 电 抵 抗。 
		 除 了 移 动 外， 任 何 动 作 都 会 打 断 此 效 果。 
		 注 意： 由 于 你 的 移 动 速 度 非 常 快， 游 戏 回 合 时 间 会 显 得 非 常 慢。 
		 每 点 雷 龙 系 的 天 赋 可 以 使 你 增 加 闪 电 抵 抗 1%%。]]):format(t.getSpeed(self, t), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Static Field",
	type = {"wild-gift/storm-drake", 2},
	require = gifts_req2,
	points = 5,
	equilibrium = 20,
	cooldown = 20,
	range = 0,
	radius = 1,
	tactical = { ATTACKAREA = { instakill = 5 } },
	requires_target = true,
	on_learn = function(self, t) self.resists[DamageType.LIGHTNING] = (self.resists[DamageType.LIGHTNING] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.LIGHTNING] = (self.resists[DamageType.LIGHTNING] or 0) - 1 end,
	target = function(self, t)
		return {type="ball", radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	getPercent = function(self, t)
		return self:combatLimit(self:combatTalentMindDamage(t, 10, 45), 90, 0, 0, 31, 31) -- Limit to <90%
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			if not target:checkHit(self:combatMindpower(), target:combatPhysicalResist(), 10) then
				game.logSeen(target, "%s resists the static field!", target.name:capitalize())
				return
			end
			target:crossTierEffect(target.EFF_OFFBALANCE, self:combatMindpower())
			game.logSeen(target, "%s is caught in the static field!", target.name:capitalize())

			local perc = t.getPercent(self, t)
			if target.rank >= 5 then perc = perc / 3
			elseif target.rank >= 3.5 then perc = perc / 2
			elseif target.rank >= 3 then perc = perc / 1.5
			end

			local dam = target.life * perc / 100
			if target.life - dam < 0 then dam = target.life end
			target:takeHit(dam, self)

			game:delayedLogDamage(self, target, dam, ("#PURPLE#%d STATIC#LAST#"):format(math.ceil(dam)))
		end, nil, {type="lightning_explosion"})
		game:playSoundNear(self, "talents/lightning")
		return true
	end,
	info = function(self, t)
		local percent = t.getPercent(self, t)
		return ([[制 造 一 个 1 码 范 围 的 静 电 力 场。 任 何 范 围 内 的 目 标 至 多 会 丢 失 %0.1f%% 当 前 生 命 值（ 高 阶 敌 人 受 较 少 影 响）。 
		 此 技 能 无 法 杀 死 敌 人。 受 精 神 强 度 影 响， 生 命 丢 失 量 有 额 外 加 成。 
		 每 点 雷 龙 系 的 天 赋 可 以 使 你 增 加 闪 电 抵 抗 1%%。]]):format(percent)
	end,
}

newTalent{
	name = "Tornado",
	type = {"wild-gift/storm-drake", 3},
	require = gifts_req3,
	points = 5,
	equilibrium = 14,
	cooldown = 15,
	proj_speed = 2, -- This is purely indicative
	tactical = { ATTACK = { LIGHTNING = 2 }, DISABLE = { stun = 2 } },
	range = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	requires_target = true,
	on_learn = function(self, t) self.resists[DamageType.LIGHTNING] = (self.resists[DamageType.LIGHTNING] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.LIGHTNING] = (self.resists[DamageType.LIGHTNING] or 0) - 1 end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		local target = game.level.map(x, y, Map.ACTOR)
		if not target then return nil end

		local movedam = self:mindCrit(self:combatTalentMindDamage(t, 10, 110))
		local dam = self:mindCrit(self:combatTalentMindDamage(t, 15, 190))

		local proj = require("mod.class.Projectile"):makeHoming(
			self,
			{particle="bolt_lightning", trail="lightningtrail"},
			{speed=2, name="Tornado", dam=dam, movedam=movedam},
			target,
			self:getTalentRange(t),
			function(self, src)
				local DT = require("engine.DamageType")
				DT:get(DT.LIGHTNING).projector(src, self.x, self.y, DT.LIGHTNING, self.def.movedam)
			end,
			function(self, src, target)
				local DT = require("engine.DamageType")
				src:project({type="ball", radius=1, x=self.x, y=self.y}, self.x, self.y, DT.LIGHTNING, self.def.dam)
				src:project({type="ball", radius=1, x=self.x, y=self.y}, self.x, self.y, DT.MINDKNOCKBACK, self.def.dam)
				if target:canBe("stun") then
					target:setEffect(target.EFF_STUNNED, 4, {apply_power=src:combatMindpower()})
				else
					game.logSeen(target, "%s resists the tornado!", target.name:capitalize())
				end

				-- Lightning ball gets a special treatment to make it look neat
				local sradius = (1 + 0.5) * (engine.Map.tile_w + engine.Map.tile_h) / 2
				local nb_forks = 16
				local angle_diff = 360 / nb_forks
				for i = 0, nb_forks - 1 do
					local a = math.rad(rng.range(0+i*angle_diff,angle_diff+i*angle_diff))
					local tx = self.x + math.floor(math.cos(a) * 1)
					local ty = self.y + math.floor(math.sin(a) * 1)
					game.level.map:particleEmitter(self.x, self.y, 1, "lightning", {radius=1, tx=tx-self.x, ty=ty-self.y, nb_particles=25, life=8})
				end
				game:playSoundNear(self, "talents/lightning")
			end
		)
		game.zone:addEntity(game.level, proj, "projectile", self.x, self.y)
		game:playSoundNear(self, "talents/lightning")
		return true
	end,
	info = function(self, t)
		return ([[召 唤 1 个 龙 卷 风， 缓 慢 跟 随 目 标。 
		 任 何 在 龙 卷 风 移 动 路 径 上 的 敌 人 会 受 到 %0.2f 闪 电 伤 害。 
		 当 它 到 达 目 标 时， 它 会 在 1 码 半 径 范 围 内 爆 炸 并 造 成 %0.2f 闪 电 伤 害， %0.2f 物 理 伤 害。 所 有 受 到 影 响 的 生 物 都 会 被 击 退 并 且 目 标 会 被 震 慑 4 回 合。 
		 龙 卷 风 持 续 %d 回 合 或 直 到 它 到 达 目 标 为 止。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。 
		 每 点 雷 龙 系 的 天 赋 可 以 使 你 增 加 闪 电 抵 抗 1%%。]]):format(
			damDesc(self, DamageType.LIGHTNING, self:combatTalentMindDamage(t, 10, 110)),
			damDesc(self, DamageType.LIGHTNING, self:combatTalentMindDamage(t, 15, 190)),
			damDesc(self, DamageType.PHYSICAL, self:combatTalentMindDamage(t, 15, 190)),
			self:getTalentRange(t)
		)
	end,
}

newTalent{
	name = "Lightning Breath",
	type = {"wild-gift/storm-drake", 4},
	require = gifts_req4,
	points = 5,
	random_ego = "attack",
	equilibrium = 12,
	cooldown = 12,
	message = "@Source@ breathes lightning!",
	tactical = { ATTACKAREA = {LIGHTNING = 2}, DISABLE = { stun = 1 } },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	direct_hit = true,
	requires_target = true,
	on_learn = function(self, t) self.resists[DamageType.LIGHTNING] = (self.resists[DamageType.LIGHTNING] or 0) + 1 end,
	on_unlearn = function(self, t) self.resists[DamageType.LIGHTNING] = (self.resists[DamageType.LIGHTNING] or 0) - 1 end,
	target = function(self, t)
		return {type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	getDamage = function(self, t)
		return self:combatTalentStatDamage(t, "str", 30, 500)
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = self:mindCrit(t.getDamage(self, t))
		self:project(tg, x, y, DamageType.LIGHTNING_DAZE, {power_check=self:combatMindpower(), dam=rng.avg(dam / 3, dam, 3)})

		if core.shader.active() then game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_lightning", {radius=tg.radius, tx=x-self.x, ty=y-self.y}, {type="lightning"})
		else game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_lightning", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		end

		
		if core.shader.active(4) then
			local bx, by = self:attachementSpot("back", true)
			self:addParticles(Particles.new("shader_wings", 1, {img="lightningwings", x=bx, y=by, life=18, fade=-0.006, deploy_speed=14}))
		end
		game:playSoundNear(self, "talents/breath")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你 在 前 方 %d 码 锥 形 范 围 内 喷 出 闪 电。 
		 此 范 围 内 的 目 标 会 受 到 %0.2f ～ %0.2f 闪 电 伤 害 并 被 眩 晕 3 回 合。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成。 技 能 暴 击 率 基 于 精 神 暴 击 值 计 算。
		 每 点 雷 龙 系 的 天 赋 可 以 使 你 增 加 闪 电 抵 抗 1%%。]]):format(
			self:getTalentRadius(t),
			damDesc(self, DamageType.LIGHTNING, damage / 3),
			damDesc(self, DamageType.LIGHTNING, damage)
		)
	end,
}
