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
	name = "Dominate",
	type = {"cursed/strife", 1},
	require = cursed_str_req1,
	points = 5,
	random_ego = "attack",
	cooldown = function(self, t)
		return 8
	end,
	hate = 4,
	tactical = { ATTACK = 2 },
	requires_target = true,
	range = 2.5,
	getDuration = function(self, t)
		return math.min(6, math.floor(2 + self:getTalentLevel(t)))
	end,
	getArmorChange = function(self, t)
		return -self:combatTalentStatDamage(t, "wil", 4, 30)
	end,
	getDefenseChange = function(self, t)
		return -self:combatTalentStatDamage(t, "wil", 6, 45)
	end,
	getResistPenetration = function(self, t) return self:combatLimit(self:combatTalentStatDamage(t, "wil", 30, 80), 100, 0, 0, 55, 55) end, -- Limit < 100%
	action = function(self, t)
		local range = self:getTalentRange(t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > range then return nil end

		-- attempt domination
		local duration = t.getDuration(self, t)
		local armorChange = t.getArmorChange(self, t)
		local defenseChange = t.getDefenseChange(self, t)
		local resistPenetration = t.getResistPenetration(self, t)
		target:setEffect(target.EFF_DOMINATED, duration, {src = self, armorChange = armorChange, defenseChange = defenseChange, resistPenetration = resistPenetration, apply_power=self:combatMindpower() })

		-- attack if adjacent
		if core.fov.distance(self.x, self.y, x, y) <= 1 then
			self:attackTarget(target, nil, 1, true)
		end

		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local armorChange = t.getArmorChange(self, t)
		local defenseChange = t.getDefenseChange(self, t)
		local resistPenetration = t.getResistPenetration(self, t)
		return ([[将 注 意 力 转 移 到 附 近 目 标 并 用 你 强 大 的 气 场 压 制 它。 如 果 目 标 未 能 通 过 精 神 强 度 豁 免 鉴 定， 目 标 %d 回 合 内 将 无 法 移 动 并 受 到 更 多 伤 害。 目 标 降 低 %d 点 护 甲 值、 %d 点 闪 避， 并 且 你 对 目 标 的 攻 击 会 增 加 %d%% 抵 抗 穿 透。 如 如 果 目 标 与 你 相 邻 , 那 么 此 技 能 会 附 加 一 次 近 战 攻 击。 
		 受 意 志 影 响， 效 果 有 额 外 加 成。]]):format(duration, -armorChange, -defenseChange, resistPenetration)
	end,
}

newTalent{
	name = "Preternatural Senses",
	type = {"cursed/strife", 2},
	mode = "passive",
	require = cursed_str_req2,
	points = 5,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 2.5, 6.6)) end,
	-- _M:combatSeeStealth and _M:combatSeeInvisible functions updated in mod.class.interface.Combat.lua
	sensePower = function(self, t) return self:combatScale(self:getTalentLevel(t) * self:getWil(15, true), 5, 0, 80, 75) end,
	info = function(self, t)
		local range = self:getTalentRange(t)
		local sense = t.sensePower(self, t)
		return ([[你 的 第 7 感 能 让 你 能 在 狩 猎 中 发 现 下 个 牺 牲 品。 
		 你 能 感 觉 到 %0.1f 码 半 径 范 围 内 的 敌 人。 
		 在 10 码 半 径 范 围 内 你 总 能 看 见 被 追 踪 的 目 标。
		 同 时 增 加 你 的 侦 测 潜 行 等 级 %d， 侦 测 隐 形 等 级%d。
		 受 意 志 影 响， 侦 测 强 度 有 额 外 加 成。 ]]):
		format(range, sense, sense)
	end,
}

--newTalent{
--	name = "Suffering",
--	type = {"cursed/strife", 2},
--	require = cursed_str_req2,
--	points = 5,
--	cooldown = 30,
--	hate = 5,
--	tactical = { DEFEND = 3 },
--	getConversionDuration = function(self, t)
--		return 3
--	end,
--	getDuration = function(self, t)
--		return 10
--	end,
--	getConversionPercent = function(self, t)
--		return self:combatTalentStatDamage(t, "wil", 40, 80)
--	end,
--	getMaxConversion = function(self, t, hate)
--		return self:combatTalentStatDamage(t, "wil", 60, 400) * getHateMultiplier(self, 0.7, 1, false, hate)
--	end,
--	action = function(self, t)
--		local duration = t.getDuration(self, t)
--		local conversionDuration = t.getConversionDuration(self, t)
--		local conversionPercent = t.getConversionPercent(self, t)
--		local maxConversion = t.getMaxConversion(self, t)
--		self:setEffect(target.EFF_SUFFERING, duration, { conversionDuration = conversionDuration, conversionPercent = conversionPercent, maxConversion = maxConversion })
--
--		return true
--	end,
--	info = function(self, t)
--		local duration = t.getDuration(self, t)
--		local conversionDuration = t.getConversionDuration(self, t)
--		local conversionPercent = t.getConversionPercent(self, t)
--		local maxConversion = t.getMaxConversion(self, t)
--		return ([[Your suffering becomes theirs. %d%% of all damage (up to a maximum of %d per turn) that you inflict over %d turns feeds your own endurance allowing you to negate that much damage over % turns.]]):format(conversionPercent, maxConversion, conversionDuration, duration)
--	end,
--}

--newTalent{
--	name = "Bait",
--	type = {"cursed/strife", 2},
--	require = cursed_str_req2,
--	points = 5,
--	random_ego = "attack",
--	cooldown = 6,
--	hate = 4,
--	tactical = { ATTACK = 2 },
--	requires_target = true,
--	getDamagePercent = function(self, t)
--		return 100 - (40 / self:getTalentLevel(t))
--	end,
--	getDistance = function(self, t)
--		return math.max(1, math.floor(self:getTalentLevel(t)))
--	end,
--	action = function(self, t)
--		local tg = {type="hit", range=self:getTalentRange(t)}
--		local x, y, target = self:getTarget(tg)
--		if not x or not y or not target then return nil end
--		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
--
--		local damagePercent = t.getDamagePercent(self, t)
--		local distance = t.getDistance(self, t)
--
--		local hit = self:attackTarget(target, nil, damagePercent / 100, true)
--		self:knockback(target.x, target.y, distance)
--
--		return true
--	end,
--	info = function(self, t)
--		local damagePercent = t.getDamagePercent(self, t)
--		local distance = t.getDistance(self, t)
--		return ([[Swing your weapon for %d%% damage as you leap backwards %d spaces from your target.]]):format(damagePercent, distance)
--	end,
--}

--newTalent{
--	name = "Ruined Cut",
--	type = {"cursed/strife", 2},
--	require = cursed_wil_req2,
--	points = 5,
--	random_ego = "attack",
--	cooldown = 6,
--	hate = 4,
--	tactical = { ATTACK = 2 },
--	requires_target = true,
--	getDamagePercent = function(self, t)
--		return 100 - (40 / self:getTalentLevel(t))
--	end,
--	getPoisonDamage = function(self, t, hate)
--		return self:combatTalentStatDamage(t, "wil", 20, 300) * getHateMultiplier(self, 0.5, 1.0, false, hate)
--	end,
--	getHealFactor = function(self, t, hate)
--		return self:combatTalentStatDamage(t, "wil", 30, 70) * getHateMultiplier(self, 0.5, 1.0, false, hate)
--	end,
--	getDuration = function(self, t)
--		return math.max(3, math.floor(6.5 - self:getTalentLevel(t) * 0.5))
--	end,
--	action = function(self, t)
--		local tg = {type="hit", range=self:getTalentRange(t)}
--		local x, y, target = self:getTarget(tg)
--		if not x or not y or not target then return nil end
--		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
--
--		local damagePercent = t.getDamagePercent(self, t)
--		local poisonDamage = t.getPoisonDamage(self, t)
--		local healFactor = t.getHealFactor(self, t)
--		local duration = t.getDuration(self, t)
--
--		local hit = self:attackTarget(target, nil, damagePercent / 100, true)
--		if hit and target:canBe("poison") then
--			target:setEffect(target.EFF_INSIDIOUS_POISON, duration, {src=self, power=poisonDamage / duration, heal_factor=healFactor})
--		end
--
--		return true
--	end,
--	info = function(self, t)
--		local damagePercent = t.getDamagePercent(self, t)
--		local poisonDamageMin = t.getPoisonDamage(self, t, 0)
--		local poisonDamageMax = t.getPoisonDamage(self, t, 100)
--		local healFactorMin = t.getHealFactor(self, t, 0)
--		local healFactorMax = t.getHealFactor(self, t, 100)
--		local duration = t.getDuration(self, t)
--		return ([[Poison your foe with the essence of your curse inflicting %d%% damage and %d (at 0 Hate) to %d (at 100+ Hate) poison damage over %d turns. Healing is also reduced by %d%% (at 0 Hate) to %d%% (at 100+ Hate).
--		Poison damage increases with the Willpower stat. Hate-based effects will improve when wielding cursed weapons.]]):format(damagePercent, poisonDamageMin, poisonDamageMax, duration, healFactorMin, healFactorMax)
--	end,
--}

newTalent{
	name = "Blindside",
	type = {"cursed/strife", 3},
	require = cursed_str_req3,
	points = 5,
	random_ego = "attack",
	cooldown = function(self, t) return math.max(6, 13 - math.floor(self:getTalentLevel(t))) end,
	hate = 4,
	range = 6,
	tactical = { CLOSEIN = 2, ATTACK = { PHYSICAL = 0.5 } },
	requires_target = true,
	getDefenseChange = function(self, t)
		return self:combatTalentStatDamage(t, "str", 20, 50)
	end,
	action = function(self, t)
		local tg = {type="hit", pass_terrain = true, range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end

		local start = rng.range(0, 8)
		for i = start, start + 8 do
			local x = target.x + (i % 3) - 1
			local y = target.y + math.floor((i % 9) / 3) - 1
			if game.level.map:isBound(x, y)
					and self:canMove(x, y)
					and not game.level.map.attrs(x, y, "no_teleport") then
				self:move(x, y, true)
				game:playSoundNear(self, "talents/teleport")
				local multiplier = self:combatTalentWeaponDamage(t, 0.7, 1.9) * getHateMultiplier(self, 0.3, 1.0, false)
				self:attackTarget(target, nil, multiplier, true)

				local defenseChange = t.getDefenseChange(self, t)
				self:setEffect(target.EFF_BLINDSIDE_BONUS, 1, { defenseChange=defenseChange })

				return true
			end
		end

		return true
	end,
	info = function(self, t)
		local multiplier = self:combatTalentWeaponDamage(t, 0.7, 1.9)
		local defenseChange = t.getDefenseChange(self, t)
		return ([[你 闪 电 般 的 出 现 在 %d 码 范 围 内 的 敌 人 身 边， 造 成 %d%% （ 0 仇 恨） ～ %d%% （ 100+ 仇 恨） 的 伤 害。 
		 你 闪 电 般 的 突 袭 使 敌 人 没 有 提 防， 增 加 %d 点 额 外 闪 避， 持 续 1 回 合。 
		 受 力 量 影 响， 闪 避 值 有 额 外 加 成。]]):format(self:getTalentRange(t), multiplier * 30, multiplier * 100, defenseChange)
	end,
}

-- newTalent{
	-- name = "Assail",
	-- type = {"cursed/strife", 4},
	-- require = cursed_str_req4,
	-- points = 5,
	-- random_ego = "attack",
	-- cooldown = 20,
	-- hate = 15,
	-- tactical = { ATTACKAREA = 2 },
	-- requires_target = false,
	-- getDamagePercent = function(self, t)
		-- return 100 - (40 / self:getTalentLevel(t))
	-- end,
	-- getAttackCount = function(self, t)
		-- return 2 + math.floor(self:getTalentLevel(t) / 2)
	-- end,
	-- getConfuseDuration = function(self, t)
		-- return 2 + math.floor(self:getTalentLevel(t) / 1.5)
	-- end,
	-- getConfuseEfficiency = function(self, t)
		-- return 50 + self:getTalentLevelRaw(t) * 10
	-- end,
	-- action = function(self, t)
		-- local damagePercent = t.getDamagePercent(self, t)
		-- local attackCount = t.getAttackCount(self, t)
		-- local confuseDuration = t.getConfuseDuration(self, t)
		-- local confuseEfficiency = t.getConfuseEfficiency(self, t)

		-- local minDistance = 1
		-- local maxDistance = 4
		-- local startX, startY = self.x, self.y
		-- local positions = {}
		-- local targets = {}

		-- -- find all positions and targets in range
		-- for x = startX - maxDistance, startX + maxDistance do
			-- for y = startY - maxDistance, startY + maxDistance do
				-- if game.level.map:isBound(x, y)
						-- and core.fov.distance(startX, startY, x, y) <= maxDistance
						-- and core.fov.distance(startX, startY, x, y) >= minDistance
						-- and self:hasLOS(x, y) then
					-- if self:canMove(x, y) then positions[#positions + 1] = {x, y} end

					-- local target = game.level.map(x, y, Map.ACTOR)
					-- if target and target ~= self and self:reactionToward(target) < 0 then targets[#targets + 1] = target end
				-- end
			-- end
		-- end

		-- -- perform confusion
		-- for i = 1, #targets do
			-- self:project({type="hit",x=targets[i].x,y=targets[i].y}, targets[i].x, targets[i].y, DamageType.CONFUSION, { dur = confuseDuration, dam = confuseEfficiency })
		-- end

		-- -- perform attacks
		-- for i = 1, attackCount do
			-- if #targets == 0 then break end

			-- local target = rng.tableRemove(targets)
			-- local hit = self:attackTarget(target, nil, damagePercent / 100, true)
		-- end

		-- -- perform movements
		-- if #positions > 0 then
			-- for i = 1, 8 do
				-- local position = positions[rng.range(1, #positions)]
				-- if rng.chance(50) then
					-- game.level.map:particleEmitter(position[1], position[2], 1, "teleport_out")
				-- else
					-- game.level.map:particleEmitter(position[1], position[2], 1, "teleport_in")
				-- end
			-- end
		-- end

		-- game.level.map:particleEmitter(currentX, currentY, 1, "teleport_in")
		-- local position = positions[rng.range(1, #positions)]
		-- self:move(position[1], position[2], true)

		-- return true
	-- end,
	-- info = function(self, t)
		-- local damagePercent = t.getDamagePercent(self, t)
		-- local attackCount = t.getAttackCount(self, t)
		-- local confuseDuration = t.getConfuseDuration(self, t)
		-- local confuseEfficiency = t.getConfuseEfficiency(self, t)

		-- return ([[With unnatural speed you assail all foes in sight within a range of 4 with wild swings from your axe. You will attack up to %d different targets for %d%% damage. When the assualt finally ends all foes in range will be confused for %d turns and you will find yourself in a nearby location.]]):format(attackCount, damagePercent, confuseDuration)
	-- end,
-- }

newTalent{
	name = "Repel",
	type = {"cursed/strife", 4},
	mode = "sustained",
	require = cursed_str_req4,
	points = 5,
	cooldown = 10,
	no_energy = true,
	getChance = function(self, t)
		local chance = self:combatLimit(self:combatTalentStatDamage(t, "str", 12, 36), 50, 0, 0, 26.45, 26.45) -- Limit <50% (56% with shield)
		if self:hasShield() then
			chance = chance + 6
		end
		return chance
	end,
	preUseTalent = function(self, t)
		-- prevent AI's from activating more than 1 talent
		if self ~= game.player and (self:isTalentActive(self.T_CLEAVE) or self:isTalentActive(self.T_SURGE)) then return false end
		return true
	end,
	activate = function(self, t)
		-- deactivate other talents and place on cooldown
		if self:isTalentActive(self.T_CLEAVE) then
			self:useTalent(self.T_CLEAVE)
		elseif self:knowTalent(self.T_CLEAVE) then
			local tCleave = self:getTalentFromId(self.T_CLEAVE)
			self.talents_cd[self.T_CLEAVE] = tCleave.cooldown
		end

		if self:isTalentActive(self.T_SURGE) then
			self:useTalent(self.T_SURGE)
		elseif self:knowTalent(self.T_SURGE) then
			local tSurge = self:getTalentFromId(self.T_SURGE)
			self.talents_cd[self.T_SURGE] = tSurge.cooldown
		end

		return {
			luckId = self:addTemporaryValue("inc_stats", { [Stats.STAT_LCK] = -3 })
		}
	end,
	deactivate = function(self, t, p)
		if p.luckId then self:removeTemporaryValue("inc_stats", p.luckId) end

		return true
	end,
	isRepelled = function(self, t)
		local chance = t.getChance(self, t)
		return rng.percent(chance)
	end,
	info = function(self, t)
		local chance = t.getChance(self, t)
		return ([[在 猛 烈 的 攻 击 面 前， 你 选 择 直 面 威 胁 而 不 是 躲 藏。 
		 当 技 能 激 活 时， 你 有 %d%% 概 率 抵 挡 一 次 近 程 攻 击。 不 顾 一 切 的 防 御 会 带 给 你 厄 运（ -3 幸 运）。 
		 分 裂 攻 击， 杀 意 涌 动 和 无 所 畏 惧 不 能 同 时 开 启， 并 且 激 活 其 中 一 个 也 会 使 另 外 两 个 进 入 冷 却。 
		 受 力 量 和 是 否 装 备 盾 牌 影 响， 概 率 有 额 外 加 成。]]):format(chance)
	end,
}
