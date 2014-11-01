-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011, 2012, 2013 Nicolas Casalini
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

--I5 Assumed reference Actor for scaling: (level 50, wil = 100, Paradox mastery at level 5, 0% fatigue) at 25% failure chance = 1150 paradox

-- A simple scaling damage formula
-- damage proportional to paradox, returns 127, 367 damage at 400, 1150 paradox
getAnomalyDamage = function(self)
	return self:getParadox()*367/1150 -- linear formula with no cap
end

-- Another scaling formula, used in place of apply_power for timed effects
-- power proportional to paradox, returns 72, 207 at 400, 1150 paradox
getAnomalyPower = function(self)
	return self:getParadox()*207/1150 -- linear formula
end

-- simple radius formula used for AoEs and targeting, caps at 10 mostly to prevent overloading the particle threads with a giant AoE
getAnomalyRadius = function(self)
	local base_radius = math.ceil(self:getParadox()/100)
	local radius = math.min(base_radius, 10)
	return radius
end

newTalent{
	name = "Anomaly Teleport",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	range = 10,
	direct_hit = true,
	type_no_req = true,
	no_unlearn_last = true,
	getTargetCount = function(self, t) return math.ceil(self:combatScale(self:getParadox(), 0, 0, 1150/200, 1150)) end,
	getRange = function(self, t) return math.floor(self:combatScale(self:getParadox(), 0, 0, 1150/20, 1150)) end,
	message = "Reality has shifted.",
	action = function(self, t)
		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, 10, true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a and a:canBe("teleport") then
				tgts[#tgts+1] = a
			end
		end end

		-- Randomly take targets
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		for i = 1, t.getTargetCount(self, t) do
			if #tgts <= 0 then break end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)

			game.level.map:particleEmitter(a.x, a.y, 1, "teleport")
			a:teleportRandom(a.x, a.y, t.getRange(self, t), 15)
			game.level.map:particleEmitter(a.x, a.y, 1, "teleport")
		end
		return true
	end,
	info = function(self, t)
		local targets = t.getTargetCount(self, t)
		local range = t.getRange(self, t)
		return ([[随 机 传 送 施 法 者 范 围 内 %d 个 目 标 至 离 原 位 %d 码 外 的 位 置。]]):format(targets, range)
	end,
}

newTalent{
	name = "Anomaly Rearrange",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	range = 10,
	paradox = 0,
	direct_hit = true,
	type_no_req = true,
	cooldown = 1,
	no_unlearn_last = true,
	getTargetCount = function(self, t) return math.ceil(self:combatScale(self:getParadox(), 0, 0, 1150/50, 1150)) end,
	getRange = function(self, t) return math.floor(self:combatScale(self:getParadox(), 0, 0, 1150/100, 1150)) end,
	message = "@Source@ has caused a hiccup in the fabric of spacetime.",
	action = function(self, t)
		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, 10, true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a and a:canBe("teleport") then
				tgts[#tgts+1] = a
			end
		end end

		-- Randomly take targets
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		for i = 1, t.getTargetCount(self, t) do
			if #tgts <= 0 then break end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)

			game.level.map:particleEmitter(a.x, a.y, 1, "teleport")
			a:teleportRandom(a.x, a.y, t.getRange(self, t), 1)
			game.level.map:particleEmitter(a.x, a.y, 1, "teleport")
		end
		return true
	end,
	info = function(self, t)
		local targets = t.getTargetCount(self, t)
		local range = t.getRange(self, t)
		return ([[随 机 传 送 施 法 者 范 围 内 %d 个 目 标 至 离 原 位 %d 码 外 的 位 置。]]):format(targets, range)
	end,
}

newTalent{
	name = "Anomaly Stop",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	range = 10,
	direct_hit = true,
	type_no_req = true,
	no_unlearn_last = true,
	getTargetCount = function(self, t) return 1 end,
	getRadius = function(self, t) return getAnomalyRadius(self) end,
	getStop = function(self, t) return math.ceil(self:combatScale(self:getParadox(), 0, 0, 1150/100, 1150)) end,
	message = "@Source@ has created a bubble of nul time.",
	action = function(self, t)
		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, 10, true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a then
				tgts[#tgts+1] = a
			end
		end end

		-- Randomly take targets
		local tg = {type="ball", range=self:getTalentRange(t), radius=t.getRadius(self, t), selffire=self:spellFriendlyFire(), talent=t}
		for i = 1, t.getTargetCount(self, t) do
			if #tgts <= 0 then break end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)

			self:project(tg, a.x, a.y, DamageType.STOP, t.getStop(self, t))
			game.level.map:particleEmitter(a.x, a.y, tg.radius, "ball_temporal", {radius=t.getRadius(self, t), tx=a.x, ty=a.y})
			game:playSoundNear(self, "talents/spell_generic")
		end
		return true
	end,
	info = function(self, t)
		return ([[震 慑 半 径 %d  时 空 球 中 的 所 有 目 标 %d 回 合 。]]):format(t.getRadius(self, t), t.getStop(self, t))
	end,
}

newTalent{
	name = "Anomaly Slow",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	range = 6,
	direct_hit = true,
	type_no_req = true,
	no_unlearn_last = true,
	getTargetCount = function(self, t) return 1 end,
	getRadius = function(self, t) return getAnomalyRadius(self) end,
	getSlow = function(self, t) return 1 - 1 / (1 + (self:getParadox()/15) / 100) end,
	message = "@Source@ has created a bubble of slow time.",
	action = function(self, t)
		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, 10, true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a then
				tgts[#tgts+1] = a
			end
		end end

		-- Randomly take targets
		local tg = {type="ball", range=self:getTalentRange(t), radius=t.getRadius(self, t), selffire=self:spellFriendlyFire(), talent=t}
		for i = 1, t.getTargetCount(self, t) do
			if #tgts <= 0 then break end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)

			self:project(tg, a.x, a.y, DamageType.SLOW, t.getSlow(self, t))
			game.level.map:particleEmitter(a.x, a.y, tg.radius, "ball_temporal", {radius=t.getRadius(self, t), tx=a.x, ty=a.y})
			game:playSoundNear(self, "talents/spell_generic")
		end
		return true
	end,
	info = function(self, t)
		return ([[半 径 %d 时 空 球 中 的 所 有 目 标 减 速 %d%%。]]):
		format(t.getRadius(self, t), t.getSlow(self, t)*100)
	end,
}

newTalent{
	name = "Anomaly Haste",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	range = 6,
	direct_hit = true,
	type_no_req = true,
	no_unlearn_last = true,
	getTargetCount = function(self, t) return math.ceil(self:combatScale(self:getParadox(), 0, 0, 1150/300, 1150)) end,
	getPower = function(self, t) return self:combatScale(self:getParadox(), 0, 0, 1150/15/100, 1150) end,
	message = "@Source@ has sped up several threads of time.",
	action = function(self, t)
		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, 10, true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a then
				tgts[#tgts+1] = a
			end
		end end

		-- Randomly take targets
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		for i = 1, t.getTargetCount(self, t) do
			if #tgts <= 0 then break end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)

			a:setEffect(self.EFF_SPEED, 8, {power=t.getPower(self, t)})
			game.level.map:particleEmitter(a.x, a.y, 1, "teleport")
			game:playSoundNear(self, "talents/spell_generic")
		end
		return true
	end,
	info = function(self, t)
		return ([[Increases global speed of up to %d targets in a radius %d ball centered on target by %d%%.]]):
		format(t.getTargetCount(self, t), 10, t.getPower(self, t)*100)
	end,
}

newTalent{
	name = "Anomaly Temporal Storm",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	type_no_req = true,
	cooldown = 1,
	paradox = 0,
	no_unlearn_last = true,
	getDamage = function(self, t) return getAnomalyDamage(self)/4 end,
	getDuration = function(self, t) return math.ceil(self:combatScale(self:getParadox(), 0, 0, 1150/50, 1150)) end,
	message = "A temporal storm rages around @Source@.",
	action = function(self, t)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, t.getDuration(self, t),
			DamageType.TEMPORAL, t.getDamage(self, t),
			3,
			5, nil,
			engine.MapEffect.new{alpha=85, color_br=200, color_bg=200, color_bb=0, effect_shader="shader_images/paradox_effect.png"},
			nil, false
		)
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[制 造 一 个 持 续 %d 回 合 的 时 间 风 暴， 造 成 每 回 合 %d 时 空 伤 害。]])
		:format(duration, damDesc(self, DamageType.TEMPORAL, damage))
	end,
}

newTalent{
	name = "Anomaly Summon Time Elemental",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	range = 10,
	direct_hit = true,
	type_no_req = true,
	no_unlearn_last = true,
	getTargetCount = function(self, t) return math.ceil(self:combatScale(self:getParadox(), 0, 0, 1150/200, 1150)) end,
	getSummonTime = function(self, t) return math.ceil(self:combatScale(self:getParadox(), 0, 0, 1150/50, 1150)) end,
	message = "Some Time Elementals have been attracted by @Source@'s meddling.",
	action = function(self, t)
		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, 10, true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a then
				tgts[#tgts+1] = a
			end
		end end

		-- Randomly take targets
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		for i = 1, t.getTargetCount(self, t) do
			if #tgts <= 0 then break end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)
			-- Find space
			local x, y = util.findFreeGrid(a.x, a.y, 5, true, {[Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "Not enough space to summon!")
				return
			end

			local NPC = require "mod.class.NPC"
			local m = NPC.new{
				type = "elemental", subtype = "temporal",
				display = "E", color=colors.YELLOW,
				name = "telugoroth", faction = a.faction,
				desc = [[A temporal elemental, rarely encountered except by those who travel through time itself.  Its blurred form constantly shifts before your eyes.]],
				combat = { dam=resolvers.mbonus(40, 15), atk=15, apr=15, dammod={mag=0.8}, damtype=DamageType.TEMPORAL },
				body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1 },
				autolevel = "none",
				global_speed_base = 1.5,
				stats = { str=8, dex=12, mag=12, wil= 12, con=10 },
				ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=2, },
				level_range = {self.level, self.level},

				resists = { [DamageType.PHYSICAL] = 10, [DamageType.TEMPORAL] = 100, },

				no_breath = 1,
				poison_immune = 1,
				disease_immune = 1,

				max_life = resolvers.rngavg(70,80),
				life_rating = 8,
				infravision = 10,
				rank = 2,
				size_category = 3,

				autolevel = "dexmage",

				combat_armor = 0, combat_def = 20,

				on_melee_hit = { [DamageType.TEMPORAL] = resolvers.mbonus(20, 10), },

				resolvers.talents{
					[Talents.T_TURN_BACK_THE_CLOCK]=3,
				},

				summoner = self, summoner_gain_exp=false,
				summon_time = t.getSummonTime(self, t),
			--	ai_target = {actor=target}
			}

			m:resolve() m:resolve(nil, true)
			m:forceLevelup(self.level)
			game.zone:addEntity(game.level, m, "actor", x, y)
			game.level.map:particleEmitter(x, y, 1, "summon")

			game:playSoundNear(self, "talents/spell_generic")
		end
		return true
	end,
	info = function(self, t)
		return ([[召 唤 %d 个 时 空 元 素 for %d turns ， 不 过 召 唤 出 的 时 空 元 素 可 能 会 攻 击 施 法 者。]]):
		format(t.getTargetCount(self, t), t.getSummonTime(self, t))
	end,
}

newTalent{
	name = "Anomaly Temporal Bubble",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	range = 10,
	type_no_req = true,
	no_unlearn_last = true,
	getTargetCount = function(self, t) return math.ceil(self:combatScale(self:getParadox(), 0, 0, 1150/200, 1150)) end,
	getDuration = function(self, t) return math.floor(self:combatScale(self:getParadox(), 0, 0, 1150/100, 1150)) end,
	message = "@Source@ has paused a temporal thread.",
	action = function(self, t)
		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, 10, true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a then
				tgts[#tgts+1] = a
			end
		end end

		-- Randomly take targets
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		for i = 1, t.getTargetCount(self, t) do
			if #tgts <= 0 then break end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)

			self:project(tg, a.x, a.y, DamageType.TIME_PRISON, t.getDuration(self, t), {type="manathrust"})
		end
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local target = t.getTargetCount(self, t)
		return ([[使 %d 个 随 机 目 标 困 在 时 间 牢 笼 内 持 续 %d 回 合。]])
		:format(target, duration)
	end,
}

newTalent{
	name = "Anomaly Dig",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	type_no_req = true,
	no_unlearn_last = true,
	getRadius = function(self, t) return getAnomalyRadius(self) end,
	message = "Matter turns to dust around @Source@.",
	action = function(self, t)
		local tg = {type="ball", range=0, radius=t.getRadius(self,t), friendlyfire=false, talent=t}
		self:project(tg, self.x, self.y, DamageType.DIG, 1)
		game.level.map:particleEmitter(self.x, self.y, t.getRadius(self, t), "ball_earth", {radius=tg.radius})
		game:playSoundNear(self, "talents/breath")
		return true
	end,
	info = function(self, t)
		return ([[将 施 法 者 周 围 球 形 范 围 内 的 地 形 全 部 挖 开。]])
	end,
}

newTalent{
	name = "Anomaly Swap",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	direct_hit = true,
	type_no_req = true,
	no_unlearn_last = true,
	getRange = function(self, t) return math.ceil(self:combatScale(self:getParadox(), 0, 0, 1150/20, 1150)) end,
	getConfuseDuration = function(self, t) return math.floor(self:combatScale(self:getParadox(), 0, 0, 1150/200, 1150)) end,
	getConfuseEfficency = function(self, t) return self:combatLimit(self:getParadox(), 50, 0, 0, 35, 1150) end, -- Limit < 50%
	message = "Reality has shifted.",
	action = function(self, t)
		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, t.getRange(self, t))
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a and a:canBe("teleport") and a ~= self then
				tgts[#tgts+1] = a
			end
		end end

		if #tgts > 0 then
			-- Randomly take a target
			local tg = {type="hit", range=t.getRange(self,t), talent=t} -- bug fix
			local a, id = rng.table(tgts)
			local target = a
		
			if target:canBe("teleport") and self:canBe("teleport") then
				-- first remove the target so the destination tile is empty
				game.level.map:remove(target.x, target.y, Map.ACTOR)
				local px, py 
				px, py = self.x, self.y
				if self:teleportRandom(a.x, a.y, 0) then
					-- return the target at the casters old location
					game.level.map(px, py, Map.ACTOR, target)
					self.x, self.y, target.x, target.y = target.x, target.y, px, py
					game.level.map:particleEmitter(target.x, target.y, 1, "temporal_teleport")
					game.level.map:particleEmitter(self.x, self.y, 1, "temporal_teleport")
					-- confuse them both
					self:project(tg, target.x, target.y, DamageType.CONFUSION, { dur = t.getConfuseDuration(self, t), dam = t.getConfuseEfficency(self, t), })
					self:project(tg, self.x, self.y, DamageType.CONFUSION, { dur = t.getConfuseDuration(self, t), dam = t.getConfuseEfficency(self, t),	})
				else
					-- return the target without effect
					game.level.map(target.x, target.y, Map.ACTOR, target)
					game.logSeen(self, "The spell fizzles!")
				end
			else
				game.logSeen(target, "%s resists the swap!", target.name:capitalize())
			end
			game:playSoundNear(self, "talents/teleport")
		end

		return true
	end,
	info = function(self, t)
		return ([[施 法 者 与 一 个 随 机 目 标 的 位 置 进 行 交 换 within range %d, confusing (%d%% chance to act randomly) both of them for %d turns.]]):
		format(t.getRange(self, t), t.getConfuseEfficency(self, t), t.getConfuseDuration(self, t))
	end,
}

newTalent{
	name = "Anomaly Gravity Spike",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	range = 10,
	direct_hit = true,
	type_no_req = true,
	no_unlearn_last = true,
	getTargetCount = function(self, t) return 1 end,
	getRadius = function(self, t) return getAnomalyRadius(self) end,
	getDamage = function(self, t) return getAnomalyDamage(self) end,
	message = "@Source@ has caused a Gravity Spike.",
	action = function(self, t)
		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, 10, true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a then
				tgts[#tgts+1] = a
			end
		end end

		-- Randomly take targets
		local tg = {type="ball", range=self:getTalentRange(t), radius=t.getRadius(self, t), friendlyfire=self:spellFriendlyFire(), talent=t}
		for i = 1, t.getTargetCount(self, t) do
			if #tgts <= 0 then break end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)

			self:project(tg, a.x, a.y, function(px, py)
				local target = game.level.map(px, py, Map.ACTOR)
				if not target then return end
				local tx, ty = util.findFreeGrid(a.x, a.y, 5, true, {[Map.ACTOR]=true})
				if tx and ty and target:canBe("knockback") then
					target:move(tx, ty, true)
					game.logSeen(target, "%s is drawn in by the gravity spike!", target.name:capitalize())
				end
			end)

			self:project (tg, a.x, a.y, DamageType.PHYSICAL, t.getDamage(self, t))
			game.level.map:particleEmitter(a.x, a.y, tg.radius, "gravity_spike", {radius=t.getRadius(self, t), grids=grids, tx=a.x, ty=a.y, allow=core.shader.allow("distort")})
			game:playSoundNear(self, "talents/earth")

		end
		return true
	end,
	info = function(self, t)
		return ([[制 造 一 个 重 力 钉 刺。]])
	end,
}

newTalent{
	name = "Anomaly Entropy",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	range = 6,
	direct_hit = true,
	type_no_req = true,
	no_unlearn_last = true,
	getTargetCount = function(self, t) return math.ceil(self:combatScale(self:getParadox(), 0, 0, 1150/100, 1150)) end,
	getPower = function(self, t) return math.floor(self:combatScale(self:getParadox(), 0, 0, 1150/100, 1150)) end,
	getTalentCount = function(self, t) return math.floor(self:combatScale(self:getParadox(), 0, 0, 1150/200, 1150)) end,
	message = "@Source@ has increased local entropy.",
	action = function(self, t)
		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, 10, true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a then
				tgts[#tgts+1] = a
			end
		end end

		-- Randomly take targets
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		for i = 1, t.getTargetCount(self, t) do
			if #tgts <= 0 then break end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)

			self:project(tg, a.x, a.y, function(px, py)
				local target = game.level.map(px, py, engine.Map.ACTOR)
				if not target then return end

				local tids = {}
				for tid, lev in pairs(target.talents) do
					local t = target:getTalentFromId(tid)
					if not target.talents_cd[tid] and t.mode == "activated" and not t.innate then tids[#tids+1] = t end
				end
				for i = 1, t.getTalentCount(self, t) do
					local power = t.getPower(self, t)
					local t = rng.tableRemove(tids)
					if not t then break end
					target.talents_cd[t.id] = rng.range(2, power)
					game.logSeen(target, "%s's %s is disrupted!", target.name:capitalize(), t.name)
				end
				target.changed = true
			end, nil)
		end
		return true
	end,
	info = function(self, t)
		return ([[使 up to %d 目 标 的 %d 技 能 in a radius 10 ball 进 入 冷 却 for up to %d turns.]]):
		format(t.getTalentCount(self, t), t.getTargetCount(self, t), t.getPower(self, t))
	end,
}

newTalent{
	name = "Anomaly Summon Townsfolk",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	range = 10,
	direct_hit = true,
	type_no_req = true,
	no_unlearn_last = true,
	getTargetCount = function(self, t) return math.ceil(self:combatScale(self:getParadox(), 0, 0, 1150/200, 1150)) end,
	getSummonTime = function(self, t) return math.ceil(self:combatScale(self:getParadox(), 0, 0, 1150/20, 1150)) end,
	message = "Some innocent bystanders have been pulled out of their timeline.",
	action = function(self, t)
		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, 10, true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a then
				tgts[#tgts+1] = a
			end
		end end

		-- Randomly take targets
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		for i = 1, t.getTargetCount(self, t) do
			if #tgts <= 0 then break end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)
			-- Randomly pick a race
			local race = rng.range(1, 4)

			-- Find space
			for i = 1, 4 do
				local x, y = util.findFreeGrid(a.x, a.y, 5, true, {[Map.ACTOR]=true})
				if not x then
					game.logPlayer(self, "Not enough space to summon!")
					return
				end

				local NPC = require "mod.class.NPC"
				local m = NPC.new{
					type = "humanoid", display = "p",
					color=colors.WHITE,

					combat = { dam=resolvers.rngavg(1,2), atk=2, apr=0, dammod={str=0.4} },

					body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
					lite = 3,

					life_rating = 10,
					rank = 2,
					size_category = 3,

					open_door = true,

					autolevel = "warrior",
					stats = { str=12, dex=8, mag=6, con=10 },
					ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=2, },
					level_range = {1, 3},

					max_life = resolvers.rngavg(30,40),
					combat_armor = 2, combat_def = 0,

				--	summoner = self,
					summoner_gain_exp=false,
					summon_time = t.getSummonTime(self, t),
				}

				m.level = 1

				if race == 1 then
					m.name = "human farmer"
					m.subtype = "human"
					m.image = "npc/humanoid_human_human_farmer.png"
					m.desc = [[A weather-worn human farmer, looking at a loss as to what's going on.]]
					m.faction = "allied-kingdoms"
					m.resolvers.inscriptions(1, "infusion")
				elseif race == 2 then
					m.name = "halfling gardener"
					m.subtype = "halfling"
					m.desc = [[A rugged halfling gardener, looking quite confused as to what he's doing here.]]
					m.faction = "allied-kingdoms"
					m.image = "npc/humanoid_halfling_halfling_gardener.png"
					m.resolvers.inscriptions(1, "infusion")
				elseif race == 3 then
					m.name = "shalore scribe"
					m.subtype = "shalore"
					m.desc = [[A scrawny elven scribe, looking bewildered at his surroundings.]]
					m.faction = "shalore"
					m.image = "npc/humanoid_shalore_shalore_rune_master.png"
					m.resolvers.inscriptions(1, "rune")
				elseif race == 4 then
					m.name = "dwarven lumberjack"
					m.subtype = "dwarf"
					m.desc = [[A brawny dwarven lumberjack, looking a bit upset at his current situation.]]
					m.faction = "iron-throne"
					m.image = "npc/humanoid_dwarf_lumberjack.png"
					m.resolvers.inscriptions(1, "rune")
				end

				m:resolve() m:resolve(nil, true)
				m:forceLevelup(self.level)
				game.zone:addEntity(game.level, m, "actor", x, y)
				game.level.map:particleEmitter(x, y, 1, "summon")
			end

			game:playSoundNear(self, "talents/spell_generic")
		end
		return true
	end,
	info = function(self, t)
		return ([[召 唤 无 辜 的 村 民 进 入 战 斗。]])
	end,
}

newTalent{
	name = "Anomaly Call",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	direct_hit = true,
	type_no_req = true,
	no_unlearn_last = true,
	getRange = function(self, t) return math.ceil(self:combatScale(self:getParadox(), 0, 0, 1150/30, 1150)) end,
	getTargetCount = function(self, t) return math.ceil(self:combatScale(self:getParadox(), 0, 0, 1150/200, 1150)) end,
	message = "Poof!!",
	action = function(self, t)
		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, t.getRange(self, t))
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a and a:canBe("teleport") and a ~= self then
				tgts[#tgts+1] = a
			end
		end end

		-- Randomly take targets
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		for i = 1, t.getTargetCount(self, t) do
			if #tgts <= 0 then break end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)

			local x, y = util.findFreeGrid(self.x, self.y, 5, true, {[Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "Not enough space to summon!")
				return
			end

			a:move(x, y, true)
			game.level.map:particleEmitter(x, y, 1, "teleport")

		end
		return true
	end,
	info = function(self, t)
		return ([[Pulls up to %d enemies within range %d to the caster's location.]]):
		format(t.getTargetCount(self, t), t.getRange(self, t))
	end,
}

newTalent{
	name = "Anomaly Flawed Design",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	range = 6,
	direct_hit = true,
	type_no_req = true,
	no_unlearn_last = true,
	getTargetCount = function(self, t) return math.ceil(self:combatScale(self:getParadox(), 0, 0, 1150/150, 1150)) end,
	getPower = function(self, t) return self:combatScale(self:getParadox(), 0, 0, 1150/30, 1150) end,
	message = "@Source@ has inadvertently weakened several creatures.",
	action = function(self, t)
		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, 10, true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a then
				tgts[#tgts+1] = a
			end
		end end

		-- Randomly take targets
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		for i = 1, t.getTargetCount(self, t) do
			if #tgts <= 0 then break end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)

			a:setEffect(self.EFF_FLAWED_DESIGN, 10, {power=t.getPower(self, t)})
			a:setEffect(self.EFF_TURN_BACK_THE_CLOCK, 10, {power=t.getPower(self, t)/2})
			game.level.map:particleEmitter(a.x, a.y, 1, "temporal_teleport")
			game:playSoundNear(self, "talents/spell_generic")
		end
		return true
	end,
	info = function(self, t)
		return ([[弱 化 半 径 10 范 围 内 一 部 分 怪 物 ]])
	end,
}

newTalent{
	name = "Anomaly Dues Ex",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	range = 6,
	direct_hit = true,
	type_no_req = true,
	no_unlearn_last = true,
	getTargetCount = function(self, t) return 1 end,
	getHastePower = function(self, t) return self:combatScale(self:getParadox(), 0, 0, 1150/15/100, 1150) end,
	getRegenPower = function(self, t) return self:combatScale(self:getParadox(), 0, 0, 1150/15, 1150) end,
	message = "The odds have tilted.",
	action = function(self, t)
		local tgts = {}
		local grids = core.fov.circle_grids(self.x, self.y, 10, true)
		for x, yy in pairs(grids) do for y, _ in pairs(grids[x]) do
			local a = game.level.map(x, y, Map.ACTOR)
			if a then
				tgts[#tgts+1] = a
			end
		end end

		-- Randomly take targets
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		for i = 1, t.getTargetCount(self, t) do
			if #tgts <= 0 then break end
			local a, id = rng.table(tgts)
			table.remove(tgts, id)

			a:setEffect(self.EFF_SPEED, 8, {power=t.getHastePower(self, t)})
			a:setEffect(self.EFF_REGENERATION, 8, {power=t.getRegenPower(self, t)})
			a:setEffect(self.EFF_PAIN_SUPPRESSION, 8, {power=t.getRegenPower(self, t)})
			game.level.map:particleEmitter(a.x, a.y, 1, "temporal_teleport")
			game:playSoundNear(self, "talents/spell_generic")
		end
		return true
	end,
	info = function(self, t)
		return ([[Substantially toughens and hastes one target for 8 turns.]])
	end,
}

--[[newTalent{
	name = "Anomaly Terrain Change",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	type_no_req = true,
	no_unlearn_last = true,
	action = function(self, t)
		return true
	end,
	info = function(self, t)
		return (Random Terrain in a ball.)
	end,
}

newTalent{
	name = "Anomaly Stat Reorder",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	type_no_req = true,
	no_unlearn_last = true,
	action = function(self, t)
		return true
	end,
	info = function(self, t)
		return (Target loses stats.)
	end,
}

newTalent{
	name = "Anomaly Heal",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	type_no_req = true,
	no_unlearn_last = true,
	action = function(self, t)
		return true
	end,
	info = function(self, t)
		return (Target is healed to full life.)
	end,
}

newTalent{
	name = "Anomaly Double",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	type_no_req = true,
	no_unlearn_last = true,
	action = function(self, t)
		return true
	end,
	info = function(self, t)
		return (Clones a random non-elite creature.  Clone may or may not be hostile to the caster.)
	end,
}

newTalent{
	name = "Anomaly Sex Change",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	type_no_req = true,
	no_npc_use = true,
	no_unlearn_last = true,
	action = function(self, t)
		return true
	end,
	info = function(self, t)
		return ()
	end,
}

newTalent{
	name = "Anomaly Money Changer",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	type_no_req = true,
	no_npc_use = true,
	no_unlearn_last = true,
	action = function(self, t)
		return true
	end,
	info = function(self, t)
		return ()
	end,
}

newTalent{
	name = "Anomaly Spacetime Folding",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	type_no_req = true,
	no_unlearn_last = true,
	action = function(self, t)
		return true
	end,
	info = function(self, t)
		return ()
	end,
}

newTalent{
	name = "Anomaly Charge/Drain",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	type_no_req = true,
	no_npc_use = true,
	no_unlearn_last = true,
	action = function(self, t)
		return true
	end,
	info = function(self, t)
		return ()
	end,
}

newTalent{
	name = "Anomaly Vertigo",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	type_no_req = true,
	no_npc_use = true,
	no_unlearn_last = true,
	action = function(self, t)
		return true
	end,
	info = function(self, t)
		return ()
	end,
}

newTalent{
	name = "Anomaly Evil Twin",
	type = {"chronomancy/anomalies", 1},
	points = 1,
	type_no_req = true,
	requires_target = true,
	no_unlearn_last = true,
	getSummonTime = function(self, t) return math.floor(self:getParadox()/50) end,
	action = function(self, t)
		return true
	end,
	info = function(self, t)
		return (Clones the caster)
	end,
}]]

