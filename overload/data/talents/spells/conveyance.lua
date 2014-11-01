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
	name = "Phase Door",
	type = {"spell/conveyance",1},
	require = spells_req1,
	points = 5,
	random_ego = "utility",
	mana = function(self, t) return game.zone and game.zone.force_controlled_teleport and 1 or 10 end,
	cooldown = function(self, t) return game.zone and game.zone.force_controlled_teleport and 3 or 8 end,
	tactical = { ESCAPE = 2 },
	requires_target = function(self, t) return self:getTalentLevel(t) >= 4 end,
	getRange = function(self, t) return self:combatLimit(self:combatTalentSpellDamage(t, 10, 15), 40, 4, 0, 13.4, 9.4) end, -- Limit to range 40
	getRadius = function(self, t) return math.floor(self:combatTalentLimit(t, 0, 6, 2)) end, -- Limit to radius 0	
	is_teleport = true,
	action = function(self, t)
		local target = self
		if self:getTalentLevel(t) >= 4 then
			game.logPlayer(self, "Selects a target to teleport...")
			local tg = {default_target=self, type="hit", nowarning=true, range=10, first_target="friend"}
			local tx, ty = self:getTarget(tg)
			if tx then
				local _ _, tx, ty = self:canProject(tg, tx, ty)
				if tx then
					target = game.level.map(tx, ty, Map.ACTOR) or self
				end
			end
		end
		if target ~= self and target:canBe("teleport") then
			local hit = self:checkHit(self:combatSpellpower(), target:combatSpellResist() + (target:attr("continuum_destabilization") or 0))
			if not hit then
				game.logSeen(target, "The spell fizzles!")
				return true
			end
		end

		-- Annoy them!
		if target ~= self and target:reactionToward(self) < 0 then target:setTarget(self) end

		local x, y = self.x, self.y
		local rad = t.getRange(self, t)
		local radius = t.getRadius(self, t)
		if self:getTalentLevel(t) >= 5 or game.zone.force_controlled_teleport then
			game.logPlayer(self, "Selects a teleport location...")
			local tg = {type="ball", nolock=true, pass_terrain=true, nowarning=true, range=rad, radius=radius, requires_knowledge=false}
			x, y = self:getTarget(tg)
			if not x then return nil end
			-- Target code does not restrict the target coordinates to the range, it lets the project function do it
			-- but we cant ...
			local _ _, x, y = self:canProject(tg, x, y)
			rad = radius

			-- Check LOS
			if not self:hasLOS(x, y) and rng.percent(35 + (game.level.map.attrs(self.x, self.y, "control_teleport_fizzle") or 0)) then
				game.logPlayer(self, "The targetted phase door fizzles and works randomly!")
				x, y = self.x, self.y
				rad = t.getRange(self, t)
			end
		end

		game.level.map:particleEmitter(target.x, target.y, 1, "teleport")
		target:teleportRandom(x, y, rad)
		game.level.map:particleEmitter(target.x, target.y, 1, "teleport")

		if target ~= self then
			target:setEffect(target.EFF_CONTINUUM_DESTABILIZATION, 100, {power=self:combatSpellpower(0.3)})
		end

		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local range = t.getRange(self, t)
		return ([[在 %d 码 范 围 内 随 机 传 送 你 自 己。 
		 在 等 级 4 时， 你 可 以 传 送 指 定 生 物（ 怪 物 或 被 护 送 者）。 
		 在 等 级 5 时， 你 可 以 选 择 传 送 位 置（ 半 径 %d ）。 
		 如 果 目 标 位 置 不 在 你 的 视 线 里， 则 法 术 有 可 能 失 败。 
		 受 法 术 强 度 影 响， 影 响 范 围 有 额 外 加 成。]]):format(range, radius)
	end,
}

newTalent{
	name = "Teleport",
	type = {"spell/conveyance",2},
	require = spells_req2,
	points = 5,
	random_ego = "utility",
	mana = 20,
	cooldown = 30,
	tactical = { ESCAPE = 3 },
	requires_target = function(self, t) return self:getTalentLevel(t) >= 4 end,
	getRange = function(self, t) return 100 + self:combatSpellpower(1) end,
	getRadius = function(self, t) return math.ceil(self:combatTalentLimit(t, 0, 19, 15)) end, -- Limit > 0
	is_teleport = true,
	action = function(self, t)
		local target = self

		if self:getTalentLevel(t) >= 4 then
			game.logPlayer(self, "Selects a target to teleport...")
			local tg = {default_target=self, type="hit", nowarning=true, range=10, first_target="friend"}
			local tx, ty = self:getTarget(tg)
			if tx then
				local _ _, tx, ty = self:canProject(tg, tx, ty)
				if tx then
					target = game.level.map(tx, ty, Map.ACTOR) or self
				end
			end
		end

		if target ~= self and target:canBe("teleport") then
			local hit = self:checkHit(self:combatSpellpower(), target:combatSpellResist() + (target:attr("continuum_destabilization") or 0))
			if not hit then
				game.logSeen(target, "The spell fizzles!")
				return true
			end
		end

		-- Annoy them!
		if target ~= self and target:reactionToward(self) < 0 then target:setTarget(self) end

		local x, y = self.x, self.y
		local newpos
		if self:getTalentLevel(t) >= 5 then
			game.logPlayer(self, "Selects a teleport location...")
			local tg = {type="ball", nolock=true, pass_terrain=true, nowarning=true, range=t.getRange(self, t), radius=t.getRadius(self, t), requires_knowledge=false}
			x, y = self:getTarget(tg)
			if not x then return nil end
			-- Target code does not restrict the target coordinates to the range, it lets the project function do it
			-- but we cant ...
			local _ _, x, y = self:canProject(tg, x, y)
			game.level.map:particleEmitter(target.x, target.y, 1, "teleport")
			newpos = target:teleportRandom(x, y, t.getRadius(self, t))
			game.level.map:particleEmitter(target.x, target.y, 1, "teleport")
		else
			game.level.map:particleEmitter(target.x, target.y, 1, "teleport")
			newpos = target:teleportRandom(x, y, t.getRange(self, t), 15)
			game.level.map:particleEmitter(target.x, target.y, 1, "teleport")
		end

		if target ~= self then
			target:setEffect(target.EFF_CONTINUUM_DESTABILIZATION, 100, {power=self:combatSpellpower(0.3)})
		end

		if not newpos then
			game.logSeen(game.player,"The spell fails: no suitable places to teleport to.")
		end
		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		local range = t.getRange(self, t)
		local radius = t.getRadius(self, t)
		return ([[在 %d 码 范 围 内 随 机 传 送， 最 小 距 离 15。 
		 在 等 级 4 时， 你 可 以 传 送 指 定 生 物（ 怪 物 或 被 护 送 者）。 
		 在 等 级 5 时， 你 可 以 选 择 传 送 位 置（ 半 径 %d ）。 
		 受 法 术 强 度 影 响， 影 响 范 围 有 额 外 加 成。]]):format(range, radius)
	end,
}

newTalent{
	name = "Displacement Shield",
	type = {"spell/conveyance", 3},
	require = spells_req3,
	points = 5,
	mana = 40,
	cooldown = 35,
	tactical = { DEFEND = 2 },
	range = 8,
	requires_target = true,
	getTransferChange = function(self, t) return 40 + self:getTalentLevel(t) * 5 end,
	getMaxAbsorb = function(self, t) return 50 + self:combatTalentSpellDamage(t, 20, 400) end,
	getDuration = function(self, t) return util.bound(10 + math.floor(self:getTalentLevel(t) * 3), 10, 25) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty or not target then return nil end
		local _ _, tx, ty = self:canProject(tg, tx, ty)
		target = game.level.map(tx, ty, Map.ACTOR)
		if target == self then target = nil end
		if not target then return end

		self:setEffect(self.EFF_DISPLACEMENT_SHIELD, t.getDuration(self, t), {power=t.getMaxAbsorb(self, t), target=target, chance=t.getTransferChange(self, t)})
		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		local chance = t.getTransferChange(self, t)
		local maxabsorb = t.getMaxAbsorb(self, t)
		local duration = t.getDuration(self, t)
		return ([[这 个 复 杂 的 法 术 可 以 扭 曲 施 法 者 周 围 的 空 间， 此 空 间 可 连 接 至 范 围 内 的 另 外 1 个 目 标。 
		 任 何 时 候， 施 法 者 所 承 受 的 伤 害 有 %d%% 的 概 率 转 移 给 指 定 连 接 的 目 标。 
		 一 旦 吸 收 伤 害 达 到 上 限（ %d ）， 持 续 时 间 到 了（ %d 回 合） 或 目 标 死 亡， 护 盾 会 破 碎 掉。 
		 受 法 术 强 度 影 响， 护 盾 的 伤 害 最 大 吸 收 值 有 额 外 加 成。]]):
		format(chance, maxabsorb, duration)
	end,
}

newTalent{
	name = "Probability Travel",
	type = {"spell/conveyance",4},
	mode = "sustained",
	require = spells_req4,
	points = 5,
	cooldown = 40,
	sustain_mana = 200,
	tactical = { ESCAPE = 1, CLOSEIN = 1 },
	getRange = function(self, t) return math.floor(self:combatScale(self:combatSpellpower(0.06) * self:getTalentLevel(t), 4, 0, 20, 16)) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/teleport")
		return {
			prob_travel = self:addTemporaryValue("prob_travel", t.getRange(self, t)),
			prob_travel_penalty = self:addTemporaryValue("prob_travel_penalty", 2 + (5 - math.min(self:getTalentLevelRaw(t), 5)) / 2),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("prob_travel", p.prob_travel)
		self:removeTemporaryValue("prob_travel_penalty", p.prob_travel_penalty)
		return true
	end,
	info = function(self, t)
		local range = t.getRange(self, t)
		return ([[当 你 击 中 一 个 固 体 表 面 时， 此 法 术 会 撕 裂 位 面 将 你 瞬 间 传 送 至 另 一 面。 
		 传 送 最 大 距 离 为 %d 码。 
		 在 一 次 成 功 的 移 动 后， 你 将 进 入 不 稳 定 状 态， 在 基 于 你 传 送 码 数 的 %d%% 回 合 内， 无 法 再 次 使 用 该 技 能。 
		 受 法 术 强 度 影 响， 传 送 距 离 有 额 外 加 成。]]):
		format(range, (2 + (5 - math.min(self:getTalentLevelRaw(t), 5)) / 2) * 100)
	end,
}
