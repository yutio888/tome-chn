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

newTalent{
	name = "Feed",
	type = {"cursed/dark-sustenance", 1},
	require = cursed_wil_req1,
	points = 5,
	random_ego = "attack",
	cooldown = 6,
	range = 7,
	hate = 0,
	tactical = { BUFF = 2, DEFEND = 1 },
	requires_target = true,
	direct_hit = true,
	getHateGain = function(self, t)
		return math.sqrt(self:getTalentLevel(t)) * 2 + self:combatMindpower() * 0.02
	end,
	action = function(self, t)
		local range = self:getTalentRange(t)
		local tg = {type="hit", range=range}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target or core.fov.distance(self.x, self.y, x, y) > range then return nil end
		if target == self then return nil end -- avoid targeting while frozen

		if self:reactionToward(target) >= 0 or target.summoner == self then
			game.logPlayer(self, "You can only gain sustenance from your foes!");
			return nil
		end

		-- remove old effect
		if self:hasEffect(self.EFF_FEED) then
			self:removeEffect(self.EFF_FEED)
		end

		local hateGain = t.getHateGain(self, t)
		local constitutionGain = 0
		local lifeRegenGain = 0
		local damageGain = 0
		local resistGain = 0

		--local tFeedHealth = self:getTalentFromId(self.T_FEED_HEALTH)
		--if tFeedHealth and self:getTalentLevelRaw(tFeedHealth) > 0 then
		--	constitutionGain = tFeedHealth.getConstitutionGain(self, tFeedHealth, target)
		--	lifeRegenGain = tFeedHealth.getLifeRegenGain(self, tFeedHealth)
		--end

		local tFeedPower = self:getTalentFromId(self.T_FEED_POWER)
		if tFeedPower and self:getTalentLevelRaw(tFeedPower) > 0 then
			damageGain = tFeedPower.getDamageGain(self, tFeedPower, target)
		end

		local tFeedStrengths = self:getTalentFromId(self.T_FEED_STRENGTHS)
		if tFeedStrengths and self:getTalentLevelRaw(tFeedStrengths) > 0 then
			resistGain = tFeedStrengths.getResistGain(self, tFeedStrengths, target)
		end

		self:setEffect(self.EFF_FEED, 40, { target=target, range=range, hateGain=hateGain, constitutionGain=constitutionGain, lifeRegenGain=lifeRegenGain, damageGain=damageGain, resistGain=resistGain })

		return true
	end,
	info = function(self, t)
		local hateGain = t.getHateGain(self, t)
		return ([[吸 食 敌 人 的 精 华。 只 要 目 标 停 留 在 视 野 里， 你 每 回 合 会 从 其 身 上 吸 取 %0.1f 仇 恨 值。 
		 受 精 神 强 度 影 响， 怒 气 吸 取 量 有 额 外 加 成。]]):format(hateGain)
	end,
}

newTalent{
	name = "Devour Life",
	type = {"cursed/dark-sustenance", 2},
	require = cursed_wil_req2,
	points = 5,
	random_ego = "attack",
	cooldown = 6,
	range = 7,
	tactical = { BUFF = 2, DEFEND = 1 },
	direct_hit = true,
	requires_target = true,
	getLifeSteal = function(self, t, target)
		return self:combatTalentMindDamage(t, 0, 140)
	end,
	action = function(self, t)
		local effect = self:hasEffect(self.EFF_FEED)
		if not effect then
			if self:getTalentLevel(t) >= 5 then
				local tFeed = self:getTalentFromId(self.T_FEED)
				if not tFeed.action(self, tFeed) then return nil end
				effect = self:hasEffect(self.EFF_FEED)
			else
				game.logPlayer(self, "You must begin feeding before you can Devour Life.");
				return nil
			end
		end
		if not effect then return nil end
		local target = effect.target

		if target and not target.dead then
			local lifeSteal = t.getLifeSteal(self, t)
			self:project({type="hit", talent=t, x=target.x,y=target.y}, target.x, target.y, DamageType.DEVOUR_LIFE, { dam=lifeSteal })

			game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(target.x-self.x), math.abs(target.y-self.y)), "dark_torrent", {tx=target.x-self.x, ty=target.y-self.y})
			--local dx, dy = target.x - self.x, target.y - self.y
			--game.level.map:particleEmitter(self.x, self.y,math.max(math.abs(dx), math.abs(dy)), "feed_hate", { tx=dx, ty=dy })
			game:playSoundNear(self, "talents/fire")

			return true
		end

		return nil
	end,
	info = function(self, t)
		local lifeSteal = t.getLifeSteal(self, t)
		return ([[吸 取 饲 主 的 生 命。 你 会 从 饲 主 身 上 吸 收 %d 点 生 命 值。 这 个 回 复 效 果 无 法 被 减 少。 
		 在 等 级 5 时， 使 用 吞 噬 生 命 的 同 时 开 启 吸 食 精 华。 
		 受 精 神 强 度 影 响， 效 果 有 额 外 加 成。]]):format(lifeSteal)
	end,
}

--[[
newTalent{
	name = "Feed Health",
	type = {"cursed/dark-sustenance", 2},
	mode = "passive",
	require = cursed_wil_req2,
	points = 5,
	getConstitutionGain = function(self, t, target)
		local gain = math.floor((6 + self:getWil(6)) * math.sqrt(self:getTalentLevel(t)) * 0.392)
		if target then
			-- return capped gain
			return math.min(gain, math.floor(target:getCon() * 0.75))
		else
			-- return max gain
			return gain
		end
	end,
	getLifeRegenGain = function(self, t, target)
		return self.max_life * (math.sqrt(self:getTalentLevel(t)) * 0.012 + self:getWil(0.01))
	end,
	info = function(self, t)
		local constitutionGain = t.getConstitutionGain(self, t)
		local lifeRegenGain = t.getLifeRegenGain(self, t)
		return ([Enhances your feeding by transferring %d constitution and %0.1f life per turn from a targeted foe to you.
		Improves with the Willpower stat.]):format(constitutionGain, lifeRegenGain)
	end,
}
]]
newTalent{
	name = "Feed Power",
	type = {"cursed/dark-sustenance", 3},
	mode = "passive",
	require = cursed_wil_req3,
	points = 5,
	getDamageGain = function(self, t)
		return self:combatLimit(self:getTalentLevel(t)^0.5 * 5 + self:combatMindpower() * 0.05, 100, 0, 0, 14, 14) -- Limit < 100%
	end,
	info = function(self, t)
		local damageGain = t.getDamageGain(self, t)
		return ([[提 高 你 的 吸 收 能 力， 降 低 目 标 %d%% 伤 害 并 增 加 你 自 己 同 样 数 值 的 伤 害。 
		 受 精 神 强 度 影 响， 效 果 有 额 外 加 成。]]):format(damageGain)
	end,
}

newTalent{
	name = "Feed Strengths",
	type = {"cursed/dark-sustenance", 4},
	mode = "passive",
	require = cursed_wil_req4,
	points = 5,
	getResistGain = function(self, t)
		return self:combatLimit(self:getTalentLevel(t)^0.5 * 14 + self:combatMindpower() * 0.15, 100, 0, 0, 40, 40) -- Limit < 100%
	end,
	info = function(self, t)
		local resistGain = t.getResistGain(self, t)
		return ([[提 高 你 的 吸 收 能 力， 降 低 目 标 %d%% 负 面 状 态 抵 抗 并 增 加 你 同 样 数 值 的 状 态 抵 抗。 
		 对 “ 所 有 ” 抵 抗 无 效。 
		 受 精 神 强 度 影 响， 效 果 有 额 外 加 成。]]):format(resistGain)
	end,
}
