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

local Stats = require "engine.interface.ActorStats"

newTalent{
	name = "Slash",
	type = {"cursed/slaughter", 1},
	require = cursed_str_req1,
	points = 5,
	random_ego = "attack",
	cooldown = 8,
	hate = 2,
	tactical = { ATTACK = { PHYSICAL = 2 } },
	requires_target = true,
	-- note that EFF_CURSED_WOUND in mod.data.timed_effects.physical.lua has a cap of -75% healing per application
	getDamageMultiplier = function(self, t, hate)
		return 1 + self:combatTalentIntervalDamage(t, "str", 0.3, 1.5, 0.4) * getHateMultiplier(self, 0.3, 1, false, hate)
	end,
	getHealFactorChange = function(self, t)
		local level = math.max(3 * self:getTalentTypeMastery(t.type[1]), self:getTalentLevel(t))
		return -self:combatLimit(math.max(0,(level-2)^0.5), 1, 0, 0, 0.26, 1.73)  -- Limit < -100%
	end,
	getWoundDuration = function(self, t)
		return 15
	end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		local damageMultiplier = t.getDamageMultiplier(self, t)
		local hit = self:attackTarget(target, nil, damageMultiplier, true)

		if hit and not target.dead then
			local level = self:getTalentLevel(t)
			if target:canBe("poison") and level >= 3 then
				local healFactorChange = t.getHealFactorChange(self, t)
				local woundDuration = t.getWoundDuration(self, t)
				target:setEffect(target.EFF_CURSED_WOUND, woundDuration, { healFactorChange=healFactorChange, totalDuration=woundDuration })
			end
		end

		return true
	end,
	info = function(self, t)
		local healFactorChange = t.getHealFactorChange(self, t)
		local woundDuration = t.getWoundDuration(self, t)
		return ([[野 蛮 的 削 砍 你 的 目 标 造 成 %d%%（ 0 仇 恨） 至 %d%%（ 100+ 仇 恨） 伤 害。 
		 等 级 3 时 攻 击 附 带 诅 咒， 降 低 目 标 治 疗 效 果 %d%% 持 续 %d 回 合， 效 果 可 叠 加。 
		 受 力 量 影 响， 伤 害 按 比 例 加 成。]]):format(t.getDamageMultiplier(self, t, 0) * 100, t.getDamageMultiplier(self, t, 100) * 100, -healFactorChange * 100, woundDuration)
	end,
}

newTalent{
	name = "Frenzy",
	type = {"cursed/slaughter", 2},
	require = cursed_str_req2,
	points = 5,
	tactical = { ATTACKAREA = { PHYSICAL = 2 } },
	random_ego = "attack",
	cooldown = 12,
	hate = 2,
	getDamageMultiplier = function(self, t, hate)
		return self:combatTalentIntervalDamage(t, "str", 0.25, 0.8, 0.4) * getHateMultiplier(self, 0.5, 1, false, hate)
	end,
	getAttackChange = function(self, t)
		local level = math.max(3 * self:getTalentTypeMastery(t.type[1]) - 2, self:getTalentLevel(t) - 2)
		return -self:combatScale(math.max(0,level^0.5 - 0.5) * 15 * (100 + self:getStr()), 0, 0, 20.77, 3696, 0.67)
	end,
	range = 0,
	radius = 1,
        target = function(self, t)
                return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t)}
        end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)

		local targets = {}
		self:project(tg, self.x, self.y, function(px, py, tg, self)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and self:reactionToward(target) < 0 then
				targets[#targets+1] = target
			end
		end)

		if #targets <= 0 then return nil end

		local damageMultiplier = t.getDamageMultiplier(self, t)
		local attackChange = t.getAttackChange(self, t)

		local effStalker = self:hasEffect(self.EFF_STALKER)
		if effStalker and core.fov.distance(self.x, self.y, effStalker.target.x, effStalker.target.y) > 1 then effStalker = nil end
		for i = 1, 4 do
			local target
			if effStalker and not effStalker.target.dead then
				target = effStalker.target
			else
				target = rng.table(targets)
			end

			if self:attackTarget(target, nil, damageMultiplier, true) and self:getTalentLevel(t) >= 3 and not target:hasEffect(target.EFF_OVERWHELMED) then
				target:setEffect(target.EFF_OVERWHELMED, 3, {src=self, attackChange=attackChange})
			end
		end

		return true
	end,
	info = function(self, t)
		local attackChange = t.getAttackChange(self, t)
		return ([[对 附 近 目 标 进 行 4 次 攻 击 每 个 目 标 造 成 %d%% （ 0 仇 恨 值） 至 %d%% （ 100+ 仇 恨 值）。 附 近 被 追 踪 的 目 标 会 被 优 先 攻 击。 
		 等 级 3 时 你 的 猛 烈 攻 击 会 同 时 降 低 目 标 %d 的 命 中， 持 续 3 回 合。 
		 受 力 量 影 响， 伤 害 加 成 和 命 中 减 值 有 额 外 加 成。]]):format(t.getDamageMultiplier(self, t, 0) * 100, t.getDamageMultiplier(self, t, 100) * 100, -attackChange)
	end,
}

newTalent{
	name = "Reckless Charge",
	type = {"cursed/slaughter", 3},
	require = cursed_str_req3,
	points = 5,
	random_ego = "attack",
	cooldown = 15,
	hate = 5,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	tactical = { CLOSEIN = 2 },
	requires_target = true,
	getDamageMultiplier = function(self, t, hate)
		return 0.7 * getHateMultiplier(self, 0.5, 1, false, hate)
		--return self:combatTalentIntervalDamage(t, "str", 0.8, 1.7, 0.4) * getHateMultiplier(self, 0.5, 1, false, hate)
	end,
	getMaxAttackCount = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6, "log")) end,
	action = function(self, t)
		local targeting = {type="bolt", range=self:getTalentRange(t), nolock=true}
		local targetX, targetY, actualTarget = self:getTarget(targeting)
		if not targetX or not targetY then return nil end
		if core.fov.distance(self.x, self.y, targetX, targetY) > self:getTalentRange(t) then return nil end

		local block_actor = function(_, bx, by) return game.level.map:checkEntity(bx, by, Map.TERRAIN, "block_move", target) end
		local lineFunction = core.fov.line(self.x, self.y, targetX, targetY, block_actor)
		local nextX, nextY, is_corner_blocked = lineFunction:step()
		local currentX, currentY = self.x, self.y

		local attackCount = 0
		local maxAttackCount = t.getMaxAttackCount(self, t)

		while nextX and nextY and not is_corner_blocked do
			local blockingTarget = game.level.map(nextX, nextY, Map.ACTOR)
			if blockingTarget and self:reactionToward(blockingTarget) < 0 then
				-- attempt a knockback
				local level = self:getTalentLevelRaw(t)
				local maxSize = 2
				if level >= 5 then
					maxSize = 4
				elseif level >= 3 then
					maxSize = 3
				end

				local blocked = true
				if blockingTarget.size_category <= maxSize then
					if blockingTarget:checkHit(self:combatPhysicalpower(), blockingTarget:combatPhysicalResist(), 0, 95, 15) and blockingTarget:canBe("knockback") then
						blockingTarget:crossTierEffect(blockingTarget.EFF_OFFBALANCE, self:combatPhysicalpower())
						-- determine where to move the target (any adjacent square that isn't next to the attacker)
						local start = rng.range(0, 8)
						for i = start, start + 8 do
							local x = nextX + (i % 3) - 1
							local y = nextY + math.floor((i % 9) / 3) - 1
							if core.fov.distance(currentY, currentX, x, y) > 1
									and game.level.map:isBound(x, y)
									and not game.level.map:checkAllEntities(x, y, "block_move", self) then
								blockingTarget:move(x, y, true)
								self:logCombat(blockingTarget, "#Source# knocks back #Target#!")
								blocked = false
								break
							end
						end
					end
				end

				if blocked then
					self:logCombat(blockingTarget, "#Target# blocks #Source#!")
				end
			end

			-- check that we can move
			if not game.level.map:isBound(nextX, nextY) or game.level.map:checkAllEntities(nextX, nextY, "block_move", self) then break end

			-- allow the move
			currentX, currentY = nextX, nextY
			nextX, nextY, is_corner_blocked = lineFunction:step()

			-- attack adjacent targets
			for i = 0, 8 do
				local x = currentX + (i % 3) - 1
				local y = currentY + math.floor((i % 9) / 3) - 1
				local target = game.level.map(x, y, Map.ACTOR)
				if target and self:reactionToward(target) < 0 and attackCount < maxAttackCount then
					local damageMultiplier = t.getDamageMultiplier(self, t)
					self:attackTarget(target, nil, damageMultiplier, true)
					attackCount = attackCount + 1

					game.level.map:particleEmitter(x, y, 1, "blood", {})
					game:playSoundNear(self, "actions/melee")
				end
			end
		end

		self:move(currentX, currentY, true)

		return true
	end,
	info = function(self, t)
		local level = self:getTalentLevelRaw(t)
		local maxAttackCount = t.getMaxAttackCount(self, t)
		local size
		if level >= 5 then
			size = "Big"
		elseif level >= 3 then
			size = "Medium-sized"
		else
			size = "Small"
		end
		return ([[冲 过 你 的 目 标， 途 经 的 所 有 目 标 受 到 %d%% （ 0 仇 恨） 至 %d%% （ 100+ 仇 恨） 伤 害。 %s 体 型 的 目 标 会 被 你 弹 开。 你 最 多 可 以 攻 击 %d 次， 并 且 你 对 路 径 上 的 敌 人 可 造 成 不 止 1 次 攻 击。]]):format(t.getDamageMultiplier(self, t, 0) * 100, t.getDamageMultiplier(self, t, 100) * 100, size, maxAttackCount)
	end,
}

--newTalent{
--	name = "Cleave",
--	type = {"cursed/slaughter", 4},
--	mode = "passive",
--	require = cursed_str_req4,
--	points = 5,
--	on_attackTarget = function(self, t, target, multiplier)
--		if inCleave then return end
--		inCleave = true
--
--		local chance = 28 + self:getTalentLevel(t) * 7
--		if rng.percent(chance) then
--			local start = rng.range(0, 8)
--			for i = start, start + 8 do
--				local x = self.x + (i % 3) - 1
--				local y = self.y + math.floor((i % 9) / 3) - 1
--				local secondTarget = game.level.map(x, y, Map.ACTOR)
--				if secondTarget and secondTarget ~= target and self:reactionToward(secondTarget) < 0 then
--					local multiplier = multiplier or 1 * self:combatTalentWeaponDamage(t, 0.2, 0.7) * getHateMultiplier(self, 0.5, 1.0, false)
--					game.logSeen(self, "%s cleaves through another foe!", self.name:capitalize())
--					self:attackTarget(secondTarget, nil, multiplier, true)
--					inCleave = false
--					return
--				end
--			end
--		end
--		inCleave = false
--
--	end,
--	info = function(self, t)
--		local chance = 28 + self:getTalentLevel(t) * 7
--		local multiplier = self:combatTalentWeaponDamage(t, 0.2, 0.7)
--		return ([[Every swing of your weapon has a %d%% chance of striking a second target for %d%% (at 0 Hate) to %d%% (at 100+ Hate) damage.]]):format(chance, multiplier * 50, multiplier * 100)
--	end,
--}

newTalent{
	name = "Cleave",
	type = {"cursed/slaughter", 4},
	mode = "sustained",
	require = cursed_str_req4,
	points = 5,
	cooldown = 10,
	no_energy = true,
	getChance = function(self, t, has2h)
		local chance = self:combatTalentIntervalDamage(t, "str", 10, 38, 0.4)
		if (not has2h and self:hasTwoHandedWeapon()) or (has2h and has2h > 0) then chance = chance + 15 end
		chance = self:combatLimit(chance, 100, 0, 0, 25.18, 25.18) -- Limit < 100%
		return chance
	end,
	getDamageMultiplier = function(self, t, hate)
		local damageMultiplier = self:combatLimit(self:getTalentLevel(t) * self:getStr()*getHateMultiplier(self, 0.5, 1.0, false, hate), 1, 0, 0, 0.79, 500) -- Limit < 100%
		if self:hasTwoHandedWeapon() then
			damageMultiplier = damageMultiplier + 0.25
		end
		return damageMultiplier
	end,
	preUseTalent = function(self, t)
		-- prevent AI's from activating more than 1 talent
		if self ~= game.player and (self:isTalentActive(self.T_SURGE) or self:isTalentActive(self.T_REPEL)) then return false end
		return true
	end,
	activate = function(self, t)
		-- deactivate other talents and place on cooldown
		if self:isTalentActive(self.T_SURGE) then
			self:useTalent(self.T_SURGE)
		elseif self:knowTalent(self.T_SURGE) then
			local tSurge = self:getTalentFromId(self.T_SURGE)
			self.talents_cd[self.T_SURGE] = tSurge.cooldown
		end

		if self:isTalentActive(self.T_REPEL) then
			self:useTalent(self.T_REPEL)
		elseif self:knowTalent(self.T_REPEL) then
			local tRepel = self:getTalentFromId(self.T_REPEL)
			self.talents_cd[self.T_REPEL] = tRepel.cooldown
		end

		return {
			luckId = self:addTemporaryValue("inc_stats", { [Stats.STAT_LCK] = -3 })
		}
	end,
	deactivate = function(self, t, p)
		if p.luckId then self:removeTemporaryValue("inc_stats", p.luckId) end

		return true
	end,
	on_attackTarget = function(self, t, target)
		if self.inCleave then return end
		self.inCleave = true

		local chance = t.getChance(self, t)
		if rng.percent(chance) then
			local start = rng.range(0, 8)
			for i = start, start + 8 do
				local x = self.x + (i % 3) - 1
				local y = self.y + math.floor((i % 9) / 3) - 1
				local secondTarget = game.level.map(x, y, Map.ACTOR)
				if secondTarget and secondTarget ~= target and self:reactionToward(secondTarget) < 0 then
					local damageMultiplier = t.getDamageMultiplier(self, t)
					self:logCombat(secondTarget, "#Source# 劈开了 #Target#!")
					self:attackTarget(secondTarget, nil, damageMultiplier, true)
					self.inCleave = false
					return
				end
			end
		end
		self.inCleave = false
	end,
	info = function(self, t)
		local chance = t.getChance(self, t, 0)
		local chance2h = t.getChance(self, t, 1)
		return ([[ 激 活 时 ， 你 的 每 一 个 武 器 有 %d%% （ 双 持） 或 %d%% （ 单 持） 概 率 攻 击 第 二 个 目 标， 造 成 %d%%（ 0 仇 恨 值） 到 %d%% （ 100+ 仇 恨 值） 伤 害（ 双 手 武 器 伤 害 额 外 增 加 25%% ）。 
		 不 顾 一 切 的 杀 戮 会 带 给 你 厄 运 (-3 幸 运 )。 
		 分 裂 攻 击、 杀 意 涌 动 和 无 所 畏 惧 不 能 同 时 开 启， 并 且 激 活 其 中 一 个 也 会 使 另 外 两 个 进 入 冷 却。
		 受 力 量 影 响 ， 攻 击 概 率 和 伤 害 有 额 外 加 成 。]]):
		format(chance, chance2h, t.getDamageMultiplier(self, t, 0) * 100, t.getDamageMultiplier(self, t, 100) * 100)
	end,
}

