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

local Object = require "mod.class.Object"

function DistortionCount(self)
	local distortion_count = 0
	
	for tid, lev in pairs(self.talents) do
		local t = game.player:getTalentFromId(tid)
		if t.type[1]:find("^psionic/") and t.type[1]:find("^psionic/distortion") then
			distortion_count = distortion_count + lev
		end
	end
	distortion_count = mod.class.interface.Combat:combatScale(distortion_count, 0, 0, 20, 20, 0.75)
	print("Distortion Count", distortion_count)
	return distortion_count
end

newTalent{
	name = "Distortion Bolt",
	type = {"psionic/distortion", 1},
	points = 5, 
	require = psi_wil_req1,
	cooldown = 3,
	psi = 5,
	tactical = { ATTACKAREA = { PHYSICAL = 2} },
	range = 10,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1.3, 2.7)) end,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 10, 150) end,
	target = function(self, t)
		local friendlyfire = true
		if self:getTalentLevel(self.T_DISTORTION_BOLT) >= 5 then
			friendlyfire = false
		end
		return {type="ball", radius=self:getTalentRadius(t), friendlyfire=friendlyfire, range=self:getTalentRange(t), talent=t, display={trail="distortion_trail"}}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local damage = self:mindCrit(t.getDamage(self, t))
		tg.type = "bolt" -- switch our targeting to a bolt for the initial projectile
		self:projectile(tg, x, y, DamageType.DISTORTION, {dam=damage,  penetrate=true, explosion=damage*1.5, friendlyfire=tg.friendlyfire, distort=DistortionCount(self), radius=self:getTalentRadius(t)})
		game:playSoundNear(self, "talents/distortion")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local distort = DistortionCount(self)
		return ([[射 出 一 枚 无 视 抵 抗 的 扭 曲 之 球 并 造 成 %0.2f 物 理 伤 害。 此 技 能 会 扭 曲 目 标，减 少 对 方 物 理 抗 性 %d%% ，并 使 其 在 2 回 合 内 受 到 扭 曲 效 果 时 会 产 生 额 外 的 负 面 影 响。
		 如 果 目 标 身 上 已 存 在 扭 曲 效 果， 则 会 在 %d 码 范 围 内 产 生 150％ 基 础 伤 害 的 爆 炸。 
		 在 该 技 能 投 入 点 数 会 增 加 你 所 有 扭 曲 效 果 的 降 抗 效 果。
		 在 等 级 5 时， 你 学 会 控 制 你 的 扭 曲 效 果， 防 止 扭 曲 效 果 攻 击 到 你 或 友 军。 
		 受 精 神 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(damDesc(self, DamageType.PHYSICAL, damage), distort, radius)
	end,
}

newTalent{
	name = "Distortion Wave",
	type = {"psionic/distortion", 2},
	points = 5, 
	require = psi_wil_req2,
	cooldown = 6,
	psi = 10,
	tactical = { ATTACKAREA = { PHYSICAL = 2}, ESCAPE = 2,
		DISABLE = function(self, t, target) if target and target:hasEffect(target.EFF_DISTORTION) then return 2 else return 0 end end,
	},
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	requires_target = true,
	direct_hit = true,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 10, 150) end,
	getPower = function(self, t) return math.floor(self:combatTalentScale(t, 2, 4)) end, -- stun duration
	target = function(self, t)
		local friendlyfire = true
		if self:getTalentLevel(self.T_DISTORTION_BOLT) >=5 then
			friendlyfire = false
		end
		return { type="cone", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=friendlyfire, talent=t }
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.DISTORTION, {dam=self:mindCrit(t.getDamage(self, t)), knockback=t.getPower(self, t), stun=t.getPower(self, t), distort=DistortionCount(self)})
		game:playSoundNear(self, "talents/warp")
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "gravity_breath", {radius=tg.radius, tx=x-self.x, ty=y-self.y, allow=core.shader.allow("distort")})
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local power = t.getPower(self, t)
		local distort = DistortionCount(self)
		return ([[在 %d 码 锥 形 半 径 范 围 内 创 建 一 股 扭 曲 之 涛， 造 成 %0.2f 物 理 伤 害， 并 击 退 扭 曲 之 涛 中 的 目 标。 
		 此 技 能 会 扭 曲 目 标，减 少 对 方 物 理 抗 性 %d%% ，并 使 其 在 2 回 合 内 受 到 扭 曲 效 果 时 会 产 生 额 外 的 负 面 影 响。
		 在 该 技 能 投 入 点 数 会 增 加 你 所 有 扭 曲 效 果 的 降 抗 效 果。
		 如 果 目 标 身 上 已 存 在 扭 曲 效 果， 则 会 被 震 慑 %d 回 合。 
		 受 精 神 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(radius, damDesc(self, DamageType.PHYSICAL, damage), distort, power)
	end,
}

newTalent{
	name = "Ravage",
	type = {"psionic/distortion", 3},
	points = 5, 
	require = psi_wil_req3,
	cooldown = 12,
	psi = 20,
	tactical = { ATTACK = { PHYSICAL = 2},
		DISABLE = function(self, t, target) if target and target:hasEffect(target.EFF_DISTORTION) then return 4 else return 0 end end,
	},
	range = 10,
	requires_target = true,
	direct_hit = true,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 10, 50) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	target = function(self, t)
		return {type="hit", range=self:getTalentRange(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		local target = game.level.map(x, y, Map.ACTOR)
		if not target then return end
		
		local ravage = false
		if target:hasEffect(target.EFF_DISTORTION) then
			ravage = true
		end
		target:setEffect(target.EFF_RAVAGE, t.getDuration(self, t), {src=self, dam=self:mindCrit(t.getDamage(self, t)), ravage=ravage, distort=DistortionCount(self), apply_power=self:combatMindpower()})
		game:playSoundNear(self, "talents/echo")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local distort = DistortionCount(self)
		return ([[疯 狂 扭 曲 目 标， 造 成 每 轮 %0.2f 物 理 伤 害， 持 续 %d 回 合。 
		 此 技 能 会 扭 曲 目 标，减 少 对 方 物 理 抗 性 %d%% ，并 使 其 在 2 回 合 内 受 到 扭 曲 效 果 时 会 产 生 额 外 的 负 面 影 响。
		 如 果 目 标 身 上 已 存 在 扭 曲 效 果， 则 伤 害 提 升 50％， 并 且 目 标 每 回 合 会 丢 失 一 种 物 理 增 益 效 果 或 持 续 技 能 效 果。 
		 在 该 技 能 投 入 点 数 会 增 加 你 所 有 扭 曲 效 果 的 降 抗 效 果。
		 受 精 神 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(damDesc(self, DamageType.PHYSICAL, damage), duration, distort)
	end,
}

newTalent{
	name = "Maelstrom",
	type = {"psionic/distortion", 4},
	points = 5, 
	require = psi_wil_req4,
	cooldown = 24,
	psi = 30,
	tactical = { ATTACK = { PHYSICAL = 2}, DISABLE = 2, ESCAPE=2 },
	range = 10,
	radius = function(self, t) return math.min(4, 1 + math.ceil(self:getTalentLevel(t)/3)) end,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 10, 50) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	target = function(self, t)
		return {type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t), nolock=true, talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		local oe = game.level.map(x, y, Map.TERRAIN)
		if not oe or oe:attr("temporary") or oe.is_maelstrom or game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move") then return nil end
		
		local e = Object.new{
			old_feat = oe,
			type = oe.type, subtype = oe.subtype,
			name = self.name:capitalize().. "'s maelstrom", image = oe.image,
			display = oe.display, color=oe.color, back_color=oe.back_color,
			tooltip = mod.class.Grid.tooltip,
			always_remember = true,
			temporary = t.getDuration(self, t),
			is_maelstrom = true,
			x = x, y = y,
			canAct = false,
			dam = self:mindCrit(t.getDamage(self, t)),
			radius = self:getTalentRadius(t),
			distortionPower = DistortionCount(self),
			act = function(self)
				local tgts = {}
				local Map = require "engine.Map"
				local DamageType = require "engine.DamageType"
				local grids = core.fov.circle_grids(self.x, self.y, self.radius, true)
				for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
					local Map = require "engine.Map"
					local target = game.level.map(x, y, Map.ACTOR)
					local friendlyfire = true
					if self.summoner:getTalentLevel(self.summoner.T_DISTORTION_BOLT) >= 5 then
						friendlyfire = false
					end
					if target and not (friendlyfire == false and self.summoner:reactionToward(target) >= 0) then 
						tgts[#tgts+1] = {actor=target, sqdist=core.fov.distance(self.x, self.y, x, y)}
					end
				end end
				table.sort(tgts, "sqdist")
				for i, target in ipairs(tgts) do
					self.summoner.__project_source = self
					if target.actor:canBe("knockback") then
						target.actor:pull(self.x, self.y, 1)
						target.actor.logCombat(self, target.actor, "#Source# pulls #Target# in!")
					end
					DamageType:get(DamageType.PHYSICAL).projector(self.summoner, target.actor.x, target.actor.y, DamageType.PHYSICAL, self.dam)
					self.summoner.__project_source = nil
					target.actor:setEffect(target.actor.EFF_DISTORTION, 2, {power=self.distortionPower})
				end

				self:useEnergy()
				self.temporary = self.temporary - 1
				if self.temporary <= 0 then
					game.level.map:removeParticleEmitter(self.particles)	
					game.level.map(self.x, self.y, engine.Map.TERRAIN, self.old_feat)
					game.level:removeEntity(self)
					game.level.map:updateMap(self.x, self.y)
					game.nicer_tiles:updateAround(game.level, self.x, self.y)
				end
			end,
			summoner_gain_exp = true,
			summoner = self,
		}

		local particle = engine.Particles.new("generic_vortex", e.radius, {radius=e.radius, rm=255, rM=255, gm=180, gM=255, bm=180, bM=255, am=35, aM=90})
		if core.shader.allow("distort") then particle:setSub("vortex_distort", e.radius, {radius=e.radius}) end
		e.particles = game.level.map:addParticleEmitter(particle, x, y)
		game.level:addEntity(e)
		game.level.map(x, y, Map.TERRAIN, e)
		--game.nicer_tiles:updateAround(game.level, x, y)
		game.level.map:updateMap(x, y)
		game:playSoundNear(self, "talents/lightning_loud")
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local distort = DistortionCount(self)
		return ([[创 造 一 个 强 大 的 灵 能 漩 涡， 持 续 %d 回 合。 每 回 合 漩 涡 会 将 半 径 %d 码 内 的 目 标 吸 向 中 心 并 造 成 %0.2f 物 理 伤 害。 
		 此 技 能 会 扭 曲 目 标，减 少 对 方 物 理 抗 性 %d%% ，并 使 其 在 2 回 合 内 受 到 扭 曲 效 果 时 会 产 生 额 外 的 负 面 影 响。
		 在 该 技 能 投 入 点 数 会 增 加 你 所 有 扭 曲 效 果 的 降 抗 效 果。
		 受 精 神 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(duration, radius, damDesc(self, DamageType.PHYSICAL, damage), distort)
	end,
}

