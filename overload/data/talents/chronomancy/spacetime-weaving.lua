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

newTalent{
	name = "Dimensional Step",
	type = {"chronomancy/spacetime-weaving", 1},
	require = temporal_req1,
	points = 5,
	paradox = 5,
	cooldown = 10,
	tactical = { CLOSEIN = 2, ESCAPE = 2 },
	range = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	requires_target = true,
	target = function(self, t)
		return {type="hit", range=self:getTalentRange(t), nolock=true, nowarning=true}
	end,
	direct_hit = true,
	no_energy = true,
	is_teleport = true,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		if not self:hasLOS(x, y) or game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move") then
			game.logSeen(self, "You do not have line of sight.")
			return nil
		end
		x, y = checkBackfire(self, x, y)
		local __, x, y = self:canProject(tg, x, y)

		game.level.map:particleEmitter(self.x, self.y, 1, "temporal_teleport")

		-- since we're using a precise teleport we'll look for a free grid first
		local tx, ty = util.findFreeGrid(x, y, 5, true, {[Map.ACTOR]=true})
		if tx and ty then
			if not self:teleportRandom(tx, ty, 0) then
				game.logSeen(self, "The spell fizzles!")
			end
		end

		game.level.map:particleEmitter(self.x, self.y, 1, "temporal_teleport")
		game:playSoundNear(self, "talents/teleport")

		return true
	end,
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[将 你 传 送 到 %d 码 视 野 范 围 内 的 指 定 地 点。 提 升 等 级 将 增 加 传 送 范 围。 
		 该 法 术 不 消 耗 施 法 时 间。]]):format(range)
	end,
}

newTalent{
	name = "Banish",
	type = {"chronomancy/spacetime-weaving", 2},
	require = temporal_req2,
	points = 5,
	paradox = 10,
	cooldown = 10,
	tactical = { ESCAPE = 2 },
	range = 0,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 4.5)) end,
	getTeleport = function(self, t) return math.floor(self:combatTalentScale(self:getTalentLevel(t) * getParadoxModifier(self, pm), 8, 16)) end,
	target = function(self, t)
		return {type="ball", range=0, radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	requires_target = true,
	direct_hit = true,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local actors = {}

		--checks for spacetime mastery hit bonus
		local power = self:combatSpellpower()
		if self:knowTalent(self.T_SPACETIME_MASTERY) then
			power = self:combatSpellpower() * (1 + self:callTalent(self.T_SPACETIME_MASTERY, "getPower"))
		end

		self:project(tg, self.x, self.y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target or target == self then return end
			if self:checkHit(power, target:combatSpellResist() + (target:attr("continuum_destabilization") or 0)) and target:canBe("teleport") then
				actors[#actors+1] = target
			else
				game.logSeen(target, "%s resists the banishment!", target.name:capitalize())
			end
		end)

		local do_fizzle = false
		for i, a in ipairs(actors) do
			game.level.map:particleEmitter(a.x, a.y, 1, "teleport")
			if not a:teleportRandom(a.x, a.y, self:getTalentRadius(t) * 4, self:getTalentRadius(t) * 2) then
				do_fizzle = true
			end
			a:setEffect(a.EFF_CONTINUUM_DESTABILIZATION, 100, {power=self:combatSpellpower(0.3)})
			game.level.map:particleEmitter(a.x, a.y, 1, "teleport")
		end

		if do_fizzle == true then
			game.logSeen(self, "The spell fizzles!")
		end

		game.level.map:particleEmitter(self.x, self.y, tg.radius, "ball_teleport", {radius=tg.radius})
		game:playSoundNear(self, "talents/teleport")

		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local range = t.getTeleport(self, t)
		return ([[随 机 传 送 你 周 围 %d 码 范 围 内 的 目 标。 
		 目 标 会 被 随 机 传 送 到 离 各 自 当 前 位 置 %d 码 到 %d 码 的 地 点。
		 受 紊 乱 值 影 响， 传 送 范 围 按 比 例 加 成。]]):format(radius, range / 2, range)
	end,
}

newTalent{
	name = "Wormhole",
	type = {"chronomancy/spacetime-weaving", 3},
	require = temporal_req3,
	points = 5,
	paradox = 20,
	cooldown = 20,
	tactical = { ESCAPE = 2 },
	range = function (self, t) return math.floor(self:combatTalentScale(t, 10.5, 12.5)) end,
	radius = function(self, t) return math.floor(self:combatTalentLimit(t, 0, 7, 3)) end, -- Limit to radius 0
	requires_target = true,
	getDuration = function (self, t) return math.floor(self:combatTalentScale(self:getTalentLevel(t)*getParadoxModifier(self, pm), 6, 10)) end,
	no_npc_use = true,
	action = function(self, t)
		local tg = {type="bolt", nowarning=true, range=1, nolock=true, simple_dir_request=true, talent=t}
		local entrance_x, entrance_y = self:getTarget(tg)
		if not entrance_x or not entrance_y then return nil end
		local _ _, entrance_x, entrance_y = self:canProject(tg, entrance_x, entrance_y)
		local trap = game.level.map(entrance_x, entrance_y, engine.Map.TRAP)
		if trap or game.level.map:checkEntity(entrance_x, entrance_y, Map.TERRAIN, "block_move") then game.logPlayer(self, "You can't place a wormhole entrance here.") return end

		-- Finding the exit location
		-- First, find the center possible exit locations
		local x, y, radius, minimum_distance
		if self:getTalentLevel(t) >= 4 then
			radius = self:getTalentRadius(t)
			minimum_distance = 0
			local tg = {type="ball", nolock=true, pass_terrain=true, nowarning=true, range=self:getTalentRange(t), radius=radius}
			x, y = self:getTarget(tg)
			print("[Target]", x, y)
			if not x then return nil end
			-- Make sure the target is within range
			if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then
				game.logPlayer(self, "Pick a valid location.")
				return false
			end
		else
			x, y = self.x, self.y
			radius = self:getTalentRange(t)
			minimum_distance = 10
		end
		-- Second, select one of the possible exit locations
		local poss = {}
		for i = x - radius, x + radius do
			for j = y - radius, y + radius do
				if game.level.map:isBound(i, j) and
					core.fov.distance(x, y, i, j) <= radius and
					core.fov.distance(x, y, i, j) >= minimum_distance and
					self:canMove(i, j) and not game.level.map(i, j, engine.Map.TRAP) then
					poss[#poss+1] = {i,j}
				end
			end
		end
		if #poss == 0 then game.logPlayer(self, "No exit location could be found.")	return false end
		local pos = poss[rng.range(1, #poss)]
		local exit_x, exit_y = pos[1], pos[2]
		print("[[wormhole]] entrance ", entrance_x, " :: ", entrance_y)
		print("[[wormhole]] exit ", exit_x, " :: ", exit_y)

		--checks for spacetime mastery hit bonus
		local power = self:combatSpellpower()
		if self:knowTalent(self.T_SPACETIME_MASTERY) then
			power = self:combatSpellpower() * (1 + self:callTalent(self.T_SPACETIME_MASTERY, "getPower"))
		end

		-- Adding the entrance wormhole
		local entrance = mod.class.Trap.new{
			name = "wormhole",
			type = "annoy", subtype="teleport", id_by_type=true, unided_name = "trap",
			image = "terrain/wormhole.png",
			display = '&', color_r=255, color_g=255, color_b=255, back_color=colors.STEEL_BLUE,
			message = "@Target@ moves onto the wormhole.",
			temporary = t.getDuration(self, t),
			x = entrance_x, y = entrance_y,
			canAct = false,
			energy = {value=0},
			disarm = function(self, x, y, who) return false end,
			check_hit = power,
			destabilization_power = self:combatSpellpower(0.3),
			summoned_by = self, -- "summoner" is immune to it's own traps
			triggered = function(self, x, y, who)
				if who == self.summoned_by or who:checkHit(self.check_hit, who:combatSpellResist()+(who:attr("continuum_destabilization") or 0), 0, 95) and who:canBe("teleport") then -- Bug fix, Deprecrated checkhit call
					-- since we're using a precise teleport we'll look for a free grid first
					local tx, ty = util.findFreeGrid(self.dest.x, self.dest.y, 5, true, {[engine.Map.ACTOR]=true})
					if tx and ty then
						if not who:teleportRandom(tx, ty, 0) then
							game.logSeen(who, "%s tries to enter the wormhole but a violent force pushes it back.", who.name:capitalize())
						elseif who ~= self.summoned_by then
							who:setEffect(who.EFF_CONTINUUM_DESTABILIZATION, 100, {power=self.destabilization_power})
						end
					end
				else
					game.logSeen(who, "%s ignores the wormhole.", who.name:capitalize())
				end
				return true
			end,
			act = function(self)
				self:useEnergy()
				self.temporary = self.temporary - 1
				if self.temporary <= 0 then
					game.logSeen(self, "Reality asserts itself and forces the wormhole shut.")
					if game.level.map(self.x, self.y, engine.Map.TRAP) == self then game.level.map:remove(self.x, self.y, engine.Map.TRAP) end
					game.level:removeEntity(self)
				end
			end,
		}
		entrance.faction = nil
		game.level:addEntity(entrance)
		entrance:identify(true)
		entrance:setKnown(self, true)
		game.zone:addEntity(game.level, entrance, "trap", entrance_x, entrance_y)
		game.level.map:particleEmitter(entrance_x, entrance_y, 1, "teleport")
		game:playSoundNear(self, "talents/heal")

		-- Adding the exit wormhole
		local exit = entrance:clone()
		exit.x = exit_x
		exit.y = exit_y
		game.level:addEntity(exit)
		exit:identify(true)
		exit:setKnown(self, true)
		game.zone:addEntity(game.level, exit, "trap", exit_x, exit_y)
		game.level.map:particleEmitter(exit_x, exit_y, 1, "teleport")

		-- Linking the wormholes
		entrance.dest = exit
		exit.dest = entrance

		game.logSeen(self, "%s folds the space between two points.", self.name)
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[你 打 开 范 围 内 随 机 点 和 你 之 间 的 通 道， 制 造 2 个 虫 洞。 任 何 站 在 虫 洞 一 边 的 人 会 被 传 送 至 另 一 边。 
		 虫 洞 持 续 %d 回 合。 
		 在 等 级 4 时， 你 可 以 选 择 出 口 地 点（ %d 码 半 径 范 围）。 
		 受 紊 乱 值 影 响， 持 续 时 间 按 比 例 加 成。]])
		:format(duration, radius)
	end,
}

newTalent{
	name = "Spacetime Mastery",
	type = {"chronomancy/spacetime-weaving", 4},
	mode = "passive",
	require = temporal_req4,
	points = 5,
	getPower = function(self, t) return math.max(0, self:combatTalentLimit(t, 1, 0.15, 0.5)) end, -- Limit < 100%
	cdred = function(self, t, scale) return math.floor(scale*self:combatTalentLimit(t, 0.8, 0.1, 0.5)) end, -- Limit < 80% of cooldown
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "talent_cd_reduction", {[self.T_BANISH] = t.cdred(self, t, 10)})
		self:talentTemporaryValue(p, "talent_cd_reduction", {[self.T_DIMENSIONAL_STEP] = t.cdred(self, t, 10)})
		self:talentTemporaryValue(p, "talent_cd_reduction", {[self.T_SWAP] = t.cdred(self, t, 10)})
		self:talentTemporaryValue(p, "talent_cd_reduction", {[self.T_TEMPORAL_WAKE] = t.cdred(self, t, 10)})
		self:talentTemporaryValue(p, "talent_cd_reduction", {[self.T_WORMHOLE] = t.cdred(self, t, 20)})
	end,
	info = function(self, t)
		local cooldown = t.cdred(self, t, 10)
		local wormhole = t.cdred(self, t, 20)
		return ([[你 对 时 空 的 掌 握 让 你 减 少 空 间 跳 跃 、 时 空 放 逐 、 时 空 交 换 、 时 空 觉 醒 的 冷 却 时 间 %d 个 回 合 ， 减 少 虫 洞 跃 迁 的 冷 却 时 间 %d 个  回 合 。 同 时 当 你 对 目 标 使 用 可 能 造 成 连 续 紊 乱 的 技 能 时 ， 有 %d%% 的 概 率 你 不 会 造 成 连 续 紊 乱 。]]):
		format(cooldown, wormhole, t.getPower(self, t)*100)
		
	end,
}
