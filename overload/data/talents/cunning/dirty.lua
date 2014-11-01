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

local Map = require "engine.Map"

newTalent{
	name = "Dirty Fighting",
	type = {"cunning/dirty", 1},
	points = 5,
	random_ego = "attack",
	cooldown = 12,
	stamina = 10,
	tactical = { DISABLE = {stun = 2}, ATTACK = {weapon = 0.5} },
	require = cuns_req1,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.2, 0.7) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local hitted = self:attackTarget(target, nil, t.getDamage(self, t), true)

		if hitted then
			if target:canBe("stun") then
				target:setEffect(target.EFF_STUNNED, t.getDuration(self, t), {apply_power=self:combatAttack()})
			end
			if not target:hasEffect(target.EFF_STUNNED) then
				self:logCombat(target, "#Target# resists the stun and #Source# quickly regains its footing!")
				self.energy.value = self.energy.value + game.energy_to_act * self:combatSpeed()
			end
		end

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 对 目 标 造 成 %d%% 伤 害， 试 图 震 慑 他。 如 果 你 的 攻 击 命 中 目 标， 则 会 使 目 标 震 慑 %d 回 合。 
		 受 你 的 命 中 影 响， 震 慑 概 率 有 额 外 加 成。 
		 如 果 你 震 慑 目 标 失 败 ( 或 者 对 震 慑 免 疫 )， 你 会 快 速 恢 复， 此 技 能 的 使 用 不 会 消 耗 回 合。]]):
		format(100 * damage, duration)
	end,
}

newTalent{
	name = "Backstab",
	type = {"cunning/dirty", 2},
	mode = "passive",
	points = 5,
	require = cuns_req2,
	-- called by _M:physicalCrit in mod.class.interface.Combat.la
	getCriticalChance = function(self, t) return self:combatTalentScale(t, 15, 50, 0.75) end,
	-- called by _M:attackTargetWith in mod.class.interface.Combat.lua
	getStunChance = function(self, t) return self:combatTalentLimit(t, 100, 3, 15) end, -- Limit < 100%
	info = function(self, t)
		return ([[在 攻 击 震 慑 目 标 时， 你 有 很 大 的 优 势， 你 的 所 有 攻 击 会 提 高 %d%% 暴 击 率。 同 时， 你 的 近 战 攻 击 有 %d%% 几 率 震 慑 目 标 3 回 合。]]):
		format(t.getCriticalChance(self, t), t.getStunChance(self, t))
	end,
}
newTalent{
	name = "Switch Place",
	type = {"cunning/dirty", 3},
	points = 5,
	random_ego = "defensive",
	cooldown = 10,
	stamina = 15,
	require = cuns_req3,
	requires_target = true,
	tactical = { DISABLE = 2 },
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	on_pre_use = function(self, t)
		if self:attr("never_move") then return false end
		return true
	end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local tx, ty, sx, sy = target.x, target.y, self.x, self.y
		local hitted = self:attackTarget(target, nil, 0, true)

		if hitted and not self.dead and tx == target.x and ty == target.y then
			if not self:canMove(tx,ty,true) or not target:canMove(sx,sy,true) then
				self:logCombat(target, "Terrain prevents #Source# from switching places with #Target#.")
				return true
			end						
			self:setEffect(self.EFF_EVASION, t.getDuration(self, t), {chance=50})
			-- Displace
			if not target.dead then
				self.x = nil self.y = nil
				self:move(tx, ty, true)
				target.x = nil target.y = nil
				target:move(sx, sy, true)
			end
		end

		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[通 过 一 系 列 的 战 术 和 策 略， 你 和 你 的 目 标 交 换 了 位 置。 
		 移 形 换 位 会 混 乱 你 的 目 标， 允 许 你 进 入 50%% 闪 避 状 态 %d 回 合。 
		 移 形 换 位 的 同 时， 你 的 武 器 会 连 接 你 的 目 标， 不 造 成 伤 害 但 会 触 发 武 器 特 效。]]):
		format(duration)
	end,
}

newTalent{
	name = "Cripple",
	type = {"cunning/dirty", 4},
	points = 5,
	random_ego = "attack",
	cooldown = 25,
	stamina = 20,
	require = cuns_req4,
	requires_target = true,
	tactical = { DISABLE = 2, ATTACK = {weapon = 2} },
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1, 1.9) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	getSpeedPenalty = function(self, t) return self:combatLimit(self:combatTalentStatDamage(t, "cun", 5, 50), 100, 20, 0, 55.7, 35.7) end, -- Limit < 100%
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local hitted = self:attackTarget(target, nil, t.getDamage(self, t), true)

		if hitted then
			local speed = t.getSpeedPenalty(self, t) / 100
			target:setEffect(target.EFF_CRIPPLE, t.getDuration(self, t), {speed=speed, apply_power=self:combatAttack()})
		end

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local speedpen = t.getSpeedPenalty(self, t)
		return ([[你 对 目 标 造 成 %d%% 的 伤 害。 
		 如 果 你 的 攻 击 命 中， 目 标 会 被 致 残 %d 回 合， 减 少 目 标 %d%% 近 战、 施 法 和 精 神 速 度。 
		 受 命 中 影 响， 技 能 命 中 率 有 额 外 加 成。 
		 受 灵 巧 影 响， 技 能 效 果 有 额 外 加 成。]]):
		format(100 * damage, duration, speedpen)
	end,
}

