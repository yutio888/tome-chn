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

-- Compute the total detection ability of enemies to see through stealth
-- Each foe loses 10% detection power per tile beyond range 1
-- returns detect, closest = total detection power, distance to closest enemy
local function stealthDetection(self, radius)
	if not self.x then return nil end
	local dist = 0
	local closest, detect = math.huge, 0
	for i, act in ipairs(self.fov.actors_dist) do
		dist = core.fov.distance(self.x, self.y, act.x, act.y)
		if dist > radius then break end
		if act ~= self and act:reactionToward(self) < 0 and not act:attr("blind") and (not act.fov or not act.fov.actors or act.fov.actors[self]) then
			detect = detect + act:combatSeeStealth() * (1.1 - dist/10) -- detection strength reduced 10% per tile
			if dist < closest then closest = dist end
		end
	end
	return detect, closest
end

newTalent{
	name = "Stealth",
	type = {"cunning/stealth", 1},
	require = cuns_req1,
	mode = "sustained", no_sustain_autoreset = true,
	points = 5,
	cooldown = 10,
	allow_autocast = true,
	no_energy = true,
	tactical = { BUFF = 3 },
	getStealthPower = function(self, t) return 10 + self:combatScale(math.max(1,self:getCun(10, true) * self:getTalentLevel(t)), 5, 1, 54, 50) end, --TL 5, cun 100 = 54
	getRadius = function(self, t) return math.ceil(self:combatTalentLimit(t, 0, 8.9, 4.6)) end, -- Limit to range >= 1
	on_pre_use = function(self, t, silent)
		if self:isTalentActive(t.id) then return true end
		local armor = self:getInven("BODY") and self:getInven("BODY")[1]
		if armor and (armor.subtype == "heavy" or armor.subtype == "massive") then
			if not silent then game.logPlayer(self, "You cannot Stealth with such heavy armour on!") end
			return nil
		end

		-- Check nearby actors detection ability
		if not self.x or not self.y or not game.level then return end
		if not rng.percent(self.hide_chance or 0) then
			if stealthDetection(self, t.getRadius(self, t)) > 0 then 
				if not silent then game.logPlayer(self, "You are being observed too closely to enter Stealth!") end
				return nil
			end
		end
		return true
	end,
	activate = function(self, t)
		local res = {
			stealth = self:addTemporaryValue("stealth", t.getStealthPower(self, t)),
			lite = self:addTemporaryValue("lite", -1000),
			infra = self:addTemporaryValue("infravision", 1),
		}
		self:resetCanSeeCacheOf()
		if self.updateMainShader then self:updateMainShader() end
		return res
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("stealth", p.stealth)
		self:removeTemporaryValue("infravision", p.infra)
		self:removeTemporaryValue("lite", p.lite)
		self:resetCanSeeCacheOf()
		if self.updateMainShader then self:updateMainShader() end
		return true
	end,
	info = function(self, t)
		local stealthpower = t.getStealthPower(self, t) + (self:attr("inc_stealth") or 0)
		local radius = t.getRadius(self, t)
		return ([[进 入 潜 行 模 式（ %d 点 潜 行 等 级， 基 于 灵 巧）， 使 你 更 难 被 察 觉。 如 果 潜 行 成 功 ( 每 回 合 都 会 进 行 鉴 定 )， 则 敌 人 无 法 看 到 你 也 不 会 注 意 到 你 的 行 动。 
		 当 你 在 潜 行 状 态 时， 光 照 范 围 减 少 至 0。 并 且， 当 你 穿 重 甲 或 板 甲 时 将 无 法 潜 行。 
		 当 周 围 %d 码 范 围 内 有 可 见 敌 人 时， 你 将 无 法 潜 行。]]):
		format(stealthpower, radius)
	end,
}

newTalent{
	name = "Shadowstrike",
	type = {"cunning/stealth", 2},
	require = cuns_req2,
	mode = "passive",
	points = 5,
	getMultiplier = function(self, t) return self:combatTalentScale(t, 1/7, 5/7) end,
	info = function(self, t)
		local multiplier = t.getMultiplier(self, t)
		return ([[当 你 在 隐 身 状 态 下 发 动 攻 击 时， 如 果 在 你 攻 击 前 目 标 没 发 现 你， 你 的 攻 击 会 自 动 变 成 暴 击。 
		 影 袭 的 暴 击 伤 害 比 普 通 暴 击 伤 害 多 +%.02f%% 。]]):
		format(multiplier * 100)
	end,
}

newTalent{
	name = "Hide in Plain Sight",
	type = {"cunning/stealth",3},
	require = cuns_req3,
	no_energy = true,
	points = 5,
	stamina = 20,
	cooldown = 40,
	tactical = { DEFEND = 2 },
	-- Assume level 50 w/100 cun --> stealth = 54, detection = 50
	-- 90% (~= 47% chance against 1 opponent (range 1) at talent level 1, 270% (~= 75% chance against 1 opponent (range 1) and 3 opponents (range 6) at talent level 5
	-- vs flat 47% at 1, 75% @ 5 previous
	stealthMult = function(self, t) return self:combatTalentScale(t, 0.9, 2.7) end,
	getChance = function(self, t, fake)
		local netstealth = t.stealthMult(self, t) * (self:callTalent(self.T_STEALTH, "getStealthPower") + (self:attr("inc_stealth") or 0))
		if fake then return netstealth end
		local detection = stealthDetection(self, 10) -- Default radius 10
		if detection <= 0 then return 100 end
		local _, chance = self:checkHit(netstealth, detection)
		print("Hide in Plain Sight: "..netstealth.." stealth vs "..detection.." detection -->chance "..chance)
		return chance
	end,
	action = function(self, t)
		if self:isTalentActive(self.T_STEALTH) then return end

		self.talents_cd[self.T_STEALTH] = nil
		self.changed = true
		self.hide_chance = t.getChance(self, t)
		self:useTalent(self.T_STEALTH)
		self.hide_chance = nil

		for uid, e in pairs(game.level.entities) do
			if e.ai_target and e.ai_target.actor == self then e:setTarget(nil) end
		end

		return true
	end,
	-- Note it would be easy to include the %chance of success from the player's current location here
	info = function(self, t)
		return ([[你 学 会 如 何 在 敌 人 的 视 线 内 进 入 潜 行 状 态。
		 成 功 率 取 决 于 %0.2f 倍 潜 行 强 度（ 现 有 %d 点 ）、 所 有 敌 人 的 侦 测 潜 行 强 度、敌 人 数 目 以 及 敌 人 和 你 的 距 离（ 每 有 1 码 距 离 ， 对 方 侦 测 潜 行 强 度 减 少 10％ ） ， 同 时 此 技 能 会 刷 新 潜 行 的 冷 却 时 间。 
		 所 有 正 在 追 赶 你 的 生 物 都 会 丢 失 你 的 踪 迹。
		 当 你 不 在 敌 人 的 视 野 内 时， 成 功 率 为 100％。]]):
		format(t.stealthMult(self, t), t.getChance(self, t, true))
	end,
}

newTalent{
	name = "Unseen Actions",
	type = {"cunning/stealth", 4},
	require = cuns_req4,
	mode = "passive",
	points = 5,
	-- Assume level 50 w/100 cun --> stealth = 54, detection = 50
	-- 40% (~= 20% chance against 1 opponent (range 1) at talent level 1, 189% (~= 55% chance against 1 opponent (range 1) and 2 opponents (range 6) at talent level 5
	-- vs flat 19% at 1, 55% @ 5 previous
	stealthMult = function(self, t) return self:combatTalentScale(t, 0.4, 1.89) end,
	getChance = function(self, t, fake)
		local netstealth = t.stealthMult(self, t) * (self:callTalent(self.T_STEALTH, "getStealthPower") + (self:attr("inc_stealth") or 0))
		if fake then return netstealth end
		local detection = stealthDetection(self, 10)
		if detection <= 0 then return 100 end
		local _, chance = self:checkHit(netstealth, detection)
		print("Unseen Actions: "..netstealth.." stealth vs "..detection.." detection -->chance "..chance)
		return chance
	end,
	-- Note it would be easy to include the %chance of success from the player's current location here
	info = function(self, t)
		return ([[当 你 在 隐 身 状 态 下 行 动 时（ 如 攻 击， 使 用 物 品 … …），你 有 一 定 概 率 不 会 打 破 潜 行 状 态 。
		成 功 率 取 决 于 %0.2f 倍 潜 行 强 度（ 现 有  %d 点 ）、 所 有 敌 人 的 侦 测 潜 行 强 度、敌 人 数 目 以 及 敌 人 和 你 的 距 离（ 每 有 1 码 距 离 ， 对 方 侦 测 潜 行 强 度 减 少 10%% ）。
		当 你 不 在 敌 人 的 视 野 内 时， 基 础 成 功 率 为 100%%。
		受 幸 运 值， 成 功 率 有 额 外 加 成 。]]):
		format(t.stealthMult(self, t), t.getChance(self, t, true))
	end,
}

