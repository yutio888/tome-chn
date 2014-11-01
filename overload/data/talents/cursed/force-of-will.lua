-- ToME - Tales of Middle-Earth
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


-- damage: initial physical damage and used for fractional knockback damage
-- knockback: distance to knockback
-- knockbackDamage: when knockback strikes something, both parties take damage - percent of damage * remaining knockback
-- power: used to determine the initial radius of particles
local function forceHit(self, t, target, sourceX, sourceY, damage, knockback, knockbackDamage, power, max)
	-- apply initial damage
	if damage > 0 then
		damage = self:mindCrit(damage)
		self:project({type="hit", range=10, talent=t}, target.x, target.y, DamageType.PHYSICAL, damage)
		game.level.map:particleEmitter(target.x, target.y, 1, "force_hit", {power=power, dx=target.x - sourceX, dy=target.y - sourceY})
	end

	-- knockback?
	if not target.dead and knockback and knockback > 0 and target:canBe("knockback") and (target.never_move or 0) < 1 then
		-- give direct hit a direction?
		if sourceX == target.x and sourceY == target.y then
			local newDirection = rng.table(util.adjacentDirs())
			local dx, dy = util.dirToCoord(newDirection, sourceX, sourceY)
			sourceX = sourceX + dx
			sourceY = sourceY + dy
		end

		local block_actor = function(_, bx, by) return game.level.map:checkEntity(bx, by, Map.TERRAIN, "block_move", target) end
		local lineFunction = core.fov.line(sourceX, sourceY, target.x, target.y, block_actor, true)
		local finalX, finalY = target.x, target.y
		local knockbackCount = 0
		local blocked = false
		while knockback > 0 do
			local x, y, is_corner_blocked = lineFunction:step(true)

			if not game.level.map:isBound(x, y) or is_corner_blocked or game.level.map:checkAllEntities(x, y, "block_move", target) then
				-- blocked
				local nextTarget = game.level.map(x, y, Map.ACTOR)
				if nextTarget then
					if knockbackCount > 0 then
						target:logCombat(nextTarget, "#Source# 被拉向#Target# %d码!", knockbackCount)
					else
						target:logCombat(nextTarget, "#Source# 被拉向#Target#!")
					end
				elseif knockbackCount > 0 then
					game.logSeen(target, "%s 被击退 %d 码!", target.name:capitalize(), knockbackCount)
				else
					game.logSeen(target, "%s 被击退!", target.name:capitalize())
				end

				-- take partial damage
				local blockDamage = damage * util.bound(knockback * (knockbackDamage / 100), 0, 1.5)
				self:project({type="hit", range=10, talent=t}, target.x, target.y, DamageType.PHYSICAL, blockDamage)

				if nextTarget then
					-- start a new force hit with the knockback damage and current knockback
					if max > 0 then
						forceHit(self, t, nextTarget, sourceX, sourceY, blockDamage, knockback, knockbackDamage, power / 2, max - 1)
					end
				end

				knockback = 0
				blocked = true
			else
				-- allow move
				finalX, finalY = x, y
				knockback = knockback - 1
				knockbackCount = knockbackCount + 1
			end
		end

		if not blocked and knockbackCount > 0 then
			game.logSeen(target, "%s 被击退%d 码!", target.name:capitalize(), knockbackCount)
		end

		if not target.dead and (finalX ~= target.x or finalY ~= target.y) then
			local ox, oy = target.x, target.y
			target:move(finalX, finalY, true)
			if config.settings.tome.smooth_move > 0 then
				target:resetMoveAnim()
				target:setMoveAnim(ox, oy, 9, 5)
			end
		end
	end
end

newTalent{
	name = "Willful Strike",
	type = {"cursed/force-of-will", 1},
	require = cursed_wil_req1,
	points = 5,
	random_ego = "attack",
	cooldown = 5,
	hate = 5,
	tactical = { ATTACK = { PHYSICAL = 2 } },
	direct_hit = true,
	requires_target = true,
	range = 3,
	getDamage = function(self, t)
		return self:combatTalentMindDamage(t, 0, 280)
	end,
	getKnockback = function(self, t)
		return 2
	end,
	critpower = function(self, t) return self:combatTalentScale(t, 4, 15) end,
	action = function(self, t)
		local range = self:getTalentRange(t)

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target or core.fov.distance(self.x, self.y, x, y) > range then return nil end

		--local distance = math.max(1, core.fov.distance(self.x, self.y, x, y))
		local power = 1 --(1 - ((distance - 1) / range))
		local damage = t.getDamage(self, t) * power
		local knockback = t.getKnockback(self, t)
		forceHit(self, t, target, self.x, self.y, damage, knockback, 7, power, 10)
		return true
	end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_critical_power", t.critpower(self, t))
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local knockback = t.getKnockback(self, t)
		return ([[专 注 你 的 仇 恨， 你 用 无 形 的 力 量 打 击 敌 人 造 成 %d 点 伤 害 和 %d 码 击 退 效 果。 
		 此 外， 你 灌 注 力 量 的 能 力 使 你 增 加 %d%% 所 有 暴 击 伤 害。（ 当 前： %d%% ） 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.PHYSICAL, damage), knockback, t.critpower(self, t), self.combat_critical_power or 0)
	end,
}

newTalent{
	name = "Deflection",
	type = {"cursed/force-of-will", 2},
	mode = "sustained",
	no_energy = true,
	require = cursed_wil_req2,
	points = 5,
	random_ego = "attack",
	cooldown = 12,
	tactical = { DEFEND = 2 },
	no_sustain_autoreset = true,
	getMaxDamage = function(self, t)
		return self:combatTalentMindDamage(t, 0, 240)
	end,
	getDisplayName = function(self, t, p)
		return ("Deflection (%d)"):format(p.value)
	end,
	critpower = function(self, t) return self:combatTalentScale(t, 4, 15) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic2")
		return {
			value = 0,
			__update_display = true,
		}
	end,
	deactivate = function(self, t, p)
		if p.particles then self:removeParticles(p.particles) end
		p.particles = nil
		return true
	end,
	do_act = function(self, t, p)
		local maxDamage = t.getMaxDamage(self, t)
		if p.value < maxDamage and self.hate >= 0.2 then
			self:incHate(-0.2)

			p.value = math.min(p.value + maxDamage / 35, maxDamage)
			p.__update_display = true

			t.updateParticles(self, t, p)
		end
	end,
	do_onTakeHit = function(self, t, p, damage)
		if p.value > 0 then
			-- absorb 50% damage
			local deflectDamage = math.floor(math.min(damage * 0.5, p.value))
			if deflectDamage > 0 then
				damage = damage - deflectDamage
				p.value = math.max(0, p.value - deflectDamage)
				p.__update_display = true
				t.updateParticles(self, t, p)

				game.logPlayer(self, "You have deflected %d incoming damage!", deflectDamage)
			end
		end
		return damage
	end,
	updateParticles = function(self, t, p)
		local power = 1 + math.floor(p.value / t.getMaxDamage(self, t) * 9)
		if not p.particles or p.power ~= power then
			if p.particles then self:removeParticles(p.particles) end
			p.particles = self:addParticles(Particles.new("force_deflection", 1, { power = power }))
			p.power = power
		end
	end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_critical_power", t.critpower(self, t))
	end,
	info = function(self, t)
		local maxDamage = t.getMaxDamage(self, t)
		return ([[用 你 的 意 志 力 折 射 50%% 的 伤 害。 你 可 以 折 射 最 多 %d 点 伤 害， 护 盾 值 每 回 合 回 复 最 大 值 的 1/35 。（ 技 能 激 活 时 -0.2 仇 恨 值 回 复）。 
		 你 灌 注 力 量 的 能 力 使 你 增 加 %d%% 所 有 暴 击 伤 害。（ 当 前： %d%% ） 
		 受 精 神 强 度 影 响， 最 大 伤 害 折 射 值 有 额 外 加 成。]]):format(maxDamage, t.critpower(self, t),self.combat_critical_power or 0)
	end,
}

newTalent{ 
	name = "Blast",
	type = {"cursed/force-of-will", 3},
	require = cursed_wil_req3,
	points = 5,
	random_ego = "attack",
	cooldown = 14,
	tactical = { ATTACKAREA = { PHYSICAL = 2 }, DISABLE = { stun = 1 } },
	requires_target = true,
	hate = 12,
	range = 4,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.3, 3.7)) end,
	getDamage = function(self, t)
		return self:combatTalentMindDamage(t, 0, 300)
	end,
	getKnockback = function(self, t)
		return 2
	end,
	target = function(self, t)
		return {type="ball", nolock=true, pass_terrain=false, friendly_fire=false, nowarning=true, range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
	end,
	getDazeDuration = function(self, t)
		return 3
	end,
	critpower = function(self, t) return self:combatTalentScale(t, 4, 15) end,
	action = function(self, t) --NOTE TO DG, SINCE I CAN'T UNDERSTAND A WORD OF BENLI'S CODE: EDIT SO THAT KNOCKBACK OCCURS AFTER DAMAGE, AND SEPARATELY, TO PREVENT ENEMIES BEING SHOVED INTO A NEW SPACE AND HIT AGAIN.
		local range = self:getTalentRange(t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		local knockback = t.getKnockback(self, t)

		local tg = self:getTalentTarget(t)
		local blastX, blastY = self:getTarget(tg)
		if not blastX or not blastY or core.fov.distance(self.x, self.y, blastX, blastY) > range then return nil end

		local grids = self:project(tg, blastX, blastY,
			function(x, y, target, self)
				-- your will ignores friendly targets (except for knockback hits)
				local target = game.level.map(x, y, Map.ACTOR)
				if target and self:reactionToward(target) < 0 then
					local distance = core.fov.distance(blastX, blastY, x, y)
					local power = (1 - (distance / radius))
					local localDamage = damage * power
					local dazeDuration = t.getDazeDuration(self, t)

					forceHit(self, t, target, blastX, blastY, damage, math.max(0, knockback - distance), 7, power, 10)
					if target:canBe("stun") then
						target:setEffect(target.EFF_DAZED, dazeDuration, {src=self})
					end
				end
			end,
			nil, nil)

		local _ _, _, _, x, y = self:canProject(tg, blastX, blastY)
		game.level.map:particleEmitter(x, y, tg.radius, "force_blast", {radius=tg.radius})
		game:playSoundNear(self, "talents/fireflash")

		return true
	end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_critical_power", t.critpower(self, t))
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		local knockback = t.getKnockback(self, t)
		local dazeDuration = t.getDazeDuration(self, t)
		return ([[你 将 愤 怒 聚 集 在 一 点， 然 后 向 %d 码 范 围 内 所 有 方 向 炸 开。 爆 炸 造 成 %d 点 伤 害， 在 中 心 点 处 造 成 %d 码 击 退 效 果， 距 离 越 远 效 果 越 弱。 
		 在 爆 炸 范 围 内 的 任 何 目 标 将 会 被 眩 晕 3 回 合。 
		 你 灌 注 力 量 的 能 力 使 你 每 点 增 加 %d%% 所 有 暴 击 伤 害。（ 当 前： %d%% ） 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(radius, damDesc(self, DamageType.PHYSICAL, damage), knockback, t.critpower(self, t), self.combat_critical_power or 0)
	end,
}

newTalent{
	name = "Unseen Force",
	type = {"cursed/force-of-will", 4},
	require = cursed_wil_req4,
	points = 5,
	hate = 18,
	cooldown = 30,
	tactical = { ATTACKAREA = { PHYSICAL = 2 } },
	range = 4,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10))	end,
	getDamage = function(self, t)
		return self:combatTalentMindDamage(t, 0, 140)
	end,
	getKnockback = function(self, t)
		return 2
	end,
	-- Minimum effects until tLvl > 4
	getAdjustedTalentLevel = function(self, t)
		local tLevel = self:getTalentLevel(self, t) - 4
		-- Do not feed a negative talent level to the scaling functions
		if tLevel < 0 then
			tLevel = 0
		end
		return tLevel
	end,
	getSecondHitChance = function(self, t)
		return self:combatTalentScale(t.getAdjustedTalentLevel(self, t), 15, 35)
	end,
	action = function(self, t)
		game.logSeen(self, "An unseen force begins to swirl around %s!", self.name)
		local duration = t.getDuration(self, t)
		local particles = self:addParticles(Particles.new("force_area", 1, { radius = self:getTalentRange(t) }))

		self.unseenForce = { duration = duration, particles = particles }
		return true
	end,
	do_unseenForce = function(self, t)
		local targets = {}
		local grids = core.fov.circle_grids(self.x, self.y, 5, true)
		for x, yy in pairs(grids) do
			for y, _ in pairs(grids[x]) do
				local a = game.level.map(x, y, Map.ACTOR)
				if a and self:reactionToward(a) < 0 and self:hasLOS(a.x, a.y) then
					targets[#targets+1] = a
				end
			end
		end

		if #targets > 0 then
			local damage = t.getDamage(self, t)
			local knockback = t.getKnockback(self, t)

			local xtrahits = t.getSecondHitChance(self,t)/100
			local hitCount = 1 + math.floor(xtrahits)
			if rng.percent(xtrahits - math.floor(xtrahits)*100) then hitCount = hitCount + 1 end

			-- Randomly take targets
			for i = 1, hitCount do
				local target, index = rng.table(targets)
				forceHit(self, t, target, target.x, target.y, damage, knockback, 7, 0.6, 10)
			end
		end

		self.unseenForce.duration = self.unseenForce.duration - 1
		if self.unseenForce.duration <= 0 then
			self:removeParticles(self.unseenForce.particles)
			self.unseenForce = nil
			game.logSeen(self, "The unseen force around %s subsides.", self.name)
		end
	end,
	critpower = function(self, t) return self:combatTalentScale(t, 4, 15) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_critical_power", t.critpower(self, t))
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		local knockback = t.getKnockback(self, t)
		local secondHitChance = t.getSecondHitChance(self, t)
		local hits = 1 + math.floor(secondHitChance/100)
		local chance = secondHitChance - math.floor(secondHitChance/100)*100
		return ([[你 的 愤 怒 变 成 一 股 无 形 之 力， 猛 烈 鞭 笞 你 附 近 的 随 机 敌 人。在 %d 回 合 内， 你 将 攻 击 %d（ %d%% 概 率 攻 击%d） 个 半 径 5  以 内 的 敌 人， 造 成 %d 点 伤 害 并 击 退 %d 码。 额 外 攻 击 的 数 目 随 技 能 等 级 增 长。 
		 你 灌 注 力 量 的 能 力 使 你 增 加 %d%% 所 有 暴 击 伤 害。（ 当 前： %d%% ） 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(duration, hits, chance, hits+1, damDesc(self, DamageType.PHYSICAL, damage), knockback, t.critpower(self, t), self.combat_critical_power or 0)
	end,
}

