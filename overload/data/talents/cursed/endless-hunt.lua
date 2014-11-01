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
	name = "Stalk",
	type = {"cursed/endless-hunt", 1},
	mode = "sustained",
	require = cursed_wil_req1,
	points = 5,
	cooldown = 0,
	no_energy = true,
	tactical = { BUFF = 5 },
	activate = function(self, t)
		return {
			hit = false, -- was any target hit this turn
			hit_target = nil, -- which single target was hit this turn
			hit_turns = 0, -- how many turns has the target been hit
		}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	getDuration = function(self, t)
		return 40
	end,
	getHitHateChange = function(self, t, bonus)
		bonus = math.min(bonus, 3)
		return 0.5 * bonus
	end,
	getAttackChange = function(self, t, bonus)
		return math.floor(self:combatTalentStatDamage(t, "wil", 10, 30) * math.sqrt(bonus))
	end,
	getStalkedDamageMultiplier = function(self, t, bonus)
		return 1 + self:combatTalentIntervalDamage(t, "str", 0.1, 0.35, 0.4) * bonus / 3
	end,
	doStalk = function(self, t, target)
		if self:hasEffect(self.EFF_STALKER) or target:hasEffect(self.EFF_STALKED) then
			-- doesn't support multiple stalkers, stalkees
			game.logPlayer(self, "#F53CBE#You are having trouble focusing on your prey!")
			return false
		end

		local duration = t.getDuration(self, t)
		self:setEffect(self.EFF_STALKER, duration, { target=target, bonus = 1 })
		target:setEffect(self.EFF_STALKED, duration, {src=self })

		game.level.map:particleEmitter(target.x, target.y, 1, "stalked_start")

		return true
	end,
	on_targetDied = function(self, t, target)
		self:removeEffect(self.EFF_STALKER)
		target:removeEffect(self.EFF_STALKED)

		-- prevent stalk targeting this turn
		local stalk = self:isTalentActive(self.T_STALK)
		if stalk then
			stalk.hit = false
			stalk.hit_target = nil
			stalk.hit_turns = 0
		end
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[当 你 连 续 两 回 合 持 续 近 战 攻 击 同 一 个 目 标 时， 你 将 憎 恨 目 标 并 追 踪 目 标， 效 果 持 续 %d 回 合 或 直 到 目 标 死 亡。 
		 你 每 回 合 攻 击 追 踪 目 标 都 将 获 得 可 叠 加 增 益 效 果， 该 效 果 在 你 不 攻 击 会 减 少 1 重 效 果。 
		1 重 增 益 : +%d 命 中， +%d%% 近 战 伤 害， 当 目 标 被 击 中 时， 每 回 合 增 加 +%0.2f 仇 恨 值。 
		2 重 增 益 : +%d 命 中， +%d%% 近 战 伤 害， 当 目 标 被 击 中 时， 每 回 合 增 加 +%0.2f 仇 恨 值。 
		3 重 增 益 : +%d 命 中， +%d%% 近 战 伤 害， 当 目 标 被 击 中 时， 每 回 合 增 加 +%0.2f 仇 恨 值。 
		 受 意 志 影 响， 命 中 有 额 外 加 成。 
		 受 力 量 影 响， 近 战 伤 害 有 额 外 加 成。]]):format(duration,
		t.getAttackChange(self, t, 1), t.getStalkedDamageMultiplier(self, t, 1) * 100 - 100, t.getHitHateChange(self, t, 1),
		t.getAttackChange(self, t, 2), t.getStalkedDamageMultiplier(self, t, 2) * 100 - 100, t.getHitHateChange(self, t, 2),
		t.getAttackChange(self, t, 3), t.getStalkedDamageMultiplier(self, t, 3) * 100 - 100, t.getHitHateChange(self, t, 3))
	end,
}

newTalent{
	name = "Beckon",
	type = {"cursed/endless-hunt", 2},
	require = cursed_wil_req2,
	points = 5,
	cooldown = 10,
	hate = 2,
	tactical = { DISABLE = 2 },
	range = 10,
	getDuration = function(self, t)
		return math.min(20, math.floor(5 + self:getTalentLevel(t) * 2))
	end,
	getChance = function(self, t)
		return math.min(75, math.floor(25 + (math.sqrt(self:getTalentLevel(t)) - 1) * 20))
	end,
	getSpellpowerChange = function(self, t)
		return -self:combatTalentStatDamage(t, "wil", 8, 33)
	end,
	getMindpowerChange = function(self, t)
		return -self:combatTalentStatDamage(t, "wil", 8, 33)
	end,
	action = function(self, t)
		local range = self:getTalentRange(t)

		local tg = {type="hit", pass_terrain=true, range=range}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > range then return nil end

		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		local spellpowerChange = t.getSpellpowerChange(self, t)
		local mindpowerChange = t.getMindpowerChange(self, t)
		target:setEffect(target.EFF_BECKONED, duration, {src=self, range=range, chance=chance, spellpowerChange=spellpowerChange, mindpowerChange=mindpowerChange })

		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		local spellpowerChange = t.getSpellpowerChange(self, t)
		local mindpowerChange = t.getMindpowerChange(self, t)
		return ([[捕 猎 者 和 猎 物 之 间 的 联 系 能 让 你 给 予 目 标 思 想 暗 示 , 引 诱 他 们 更 靠 近 你。 
		 在 %d 回 合 内， 目 标 会 试 图 接 近 你， 甚 至 推 开 路 径 上 的 其 他 单 位。 
		 每 回 合 有 %d%% 的 几 率， 它 们 会 取 消 原 有 动 作 并 直 接 向 你 走 去。 
		 目 标 受 到 致 命 攻 击 时 可 能 会 打 断 该 效 果， 此 效 果 会 减 少 目 标 注 意 力， 在 它 们 到 达 你 所 在 位 置 之 前， 降 低 其 %d 点 法 术 强 度 和 精 神 强 度。 
		 受 意 志 影 响， 法 术 强 度 和 精 神 强 度 的 降 低 效 果 有 额 外 加 成。]]):format(duration, chance, -spellpowerChange)
	end,
}

newTalent{
	name = "Harass Prey",
	type = {"cursed/endless-hunt", 3},
	require = cursed_wil_req3,
	points = 5,
	random_ego = "attack",
	cooldown = 6,
	hate = 5,
	tactical = { ATTACK = { PHYSICAL = 3 } },
	getCooldownDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3.75, 6.75, "log", 0, 1)) end,
	getDamageMultiplier = function(self, t, hate)
		return getHateMultiplier(self, 0.35, 0.67, false, hate)
	end,
	getTargetDamageChange = function(self, t)
		return -self:combatLimit(self:combatTalentStatDamage(t, "wil", 0.7, 0.9), 1, 0, 0, 0.75, 0.87)*100 -- Limit < 100%
	end,
	getDuration = function(self, t)
		return 2
	end,
	on_pre_use = function(self, t)
		local eff = self:hasEffect(self.EFF_STALKER)
		return eff and not eff.target.dead and core.fov.distance(self.x, self.y, eff.target.x, eff.target.y) <= 1
	end,
	action = function(self, t)
		local damageMultipler = t.getDamageMultiplier(self, t)
		local cooldownDuration = t.getCooldownDuration(self, t)
		local targetDamageChange = t.getTargetDamageChange(self, t)
		local duration = t.getDuration(self, t)
		local effStalker = self:hasEffect(self.EFF_STALKER)
		local target = effStalker.target
		if not target or target.dead then return nil end

		target:setEffect(target.EFF_HARASSED, duration, {src=self, damageChange=targetDamageChange })

		for i = 1, 2 do
			if not target.dead and self:attackTarget(target, nil, damageMultipler, true) then
				-- remove effects
				local tids = {}
				for tid, lev in pairs(target.talents) do
					local t = target:getTalentFromId(tid)
					if not target.talents_cd[tid] and t.mode == "activated" and not t.innate then tids[#tids+1] = t end
				end

				local t = rng.tableRemove(tids)
				if t then
					target.talents_cd[t.id] = rng.range(3, 5)
					game.logSeen(target, "#F53CBE#%s's %s is disrupted!", target.name:capitalize(), t.name)
				end
			end
		end

		return true
	end,
	info = function(self, t)
		local damageMultipler = t.getDamageMultiplier(self, t)
		local cooldownDuration = t.getCooldownDuration(self, t)
		local targetDamageChange = t.getTargetDamageChange(self, t)
		local duration = t.getDuration(self, t)
		return ([[用 两 次 快 速 的 攻 击 折 磨 你 追 踪 的 目 标 , 每 次 攻 击 造 成 %d%% （ 0 仇 恨） ～ %d%% （ 100+ 仇 恨） 的 伤 害。 并 且 每 次 攻 击 都 将 中 断 目 标 某 项 技 能 或 符 文， 持 续 %d 回 合。 目 标 会 因 为 你 的 攻 击 而 气 馁， 它 的 伤 害 降 低 %d%% ， 持 续 %d 回 合。 
		 受 意 志 影 响， 伤 害 降 低 有 额 外 加 成。]]):format(t.getDamageMultiplier(self, t, 0) * 100, t.getDamageMultiplier(self, t, 100) * 100, cooldownDuration, -targetDamageChange, duration)
	end,
}

newTalent{
	name = "Surge",
	type = {"cursed/endless-hunt", 4},
	mode = "sustained",
	require = cursed_wil_req4,
	points = 5,
	cooldown = 10,
	no_energy = true,
	getMovementSpeedChange = function(self, t)
		return self:combatTalentStatDamage(t, "wil", 0.1, 1.1)
	end,
	getDefenseChange = function(self, t, hasDualweapon)
		if hasDualweapon or self:hasDualWeapon() then return self:combatTalentStatDamage(t, "wil", 4, 40) end
		return 0
	end,
	preUseTalent = function(self, t)
		-- prevent AI's from activating more than 1 talent
		if self ~= game.player and (self:isTalentActive(self.T_CLEAVE) or self:isTalentActive(self.T_REPEL)) then return false end
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

		if self:isTalentActive(self.T_REPEL) then
			self:useTalent(self.T_REPEL)
		elseif self:knowTalent(self.T_REPEL) then
			local tRepel = self:getTalentFromId(self.T_REPEL)
			self.talents_cd[self.T_REPEL] = tRepel.cooldown
		end

		local movementSpeedChange = t.getMovementSpeedChange(self, t)
		return {
			moveId = self:addTemporaryValue("movement_speed", movementSpeedChange),
			luckId = self:addTemporaryValue("inc_stats", { [Stats.STAT_LCK] = -3 })
		}
	end,
	deactivate = function(self, t, p)
		if p.moveId then self:removeTemporaryValue("movement_speed", p.moveId) end
		if p.luckId then self:removeTemporaryValue("inc_stats", p.luckId) end

		return true
	end,
	info = function(self, t)
		local movementSpeedChange = t.getMovementSpeedChange(self, t)
		local defenseChange = t.getDefenseChange(self, t, true)
		return ([[让 杀 意 激 发 你 敏 捷 的 身 手 , 提 高 你 %d%% 移 动 速 度。 不 顾 一 切 的 移 动 会 带 给 你 厄 运 (-3 幸 运 )。 
		 分 裂 攻 击、 杀 意 涌 动 和 无 所 畏 惧 不 能 同 时 开 启， 并 且 激 活 其 中 一 个 也 会 使 另 外 两 个 进 入 冷 却。 
		 你 的 移 动 速 度 与 双 武 器 提 供 的 完 美 平 衡， 使 你 在 双 持 的 同 时 闪 避 增 加 %d 点。 
		 受 意 志 影 响， 移 动 速 度 和 双 持 时 的 闪 避 增 益 有 额 外 加 成。]]):format(movementSpeedChange * 100, defenseChange)
	end,
}
