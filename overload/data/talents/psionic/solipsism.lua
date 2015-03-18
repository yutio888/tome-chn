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
	name = "Solipsism",
	type = {"psionic/solipsism", 1},
	points = 5, 
	require = psi_wil_req1,
	mode = "passive",
	no_unlearn_last = true,
	psi = 0 ,
	-- Speed effect calculations performed in _M:actBase function in mod\class\Actor.lua to handle suppressing the solipsim threshold
	-- Damage conversion handled in mod.class.Actor.lua _M:onTakeHit
	getConversionRatio = function(self, t) return self:combatTalentLimit(t, 1, 0.15, 0.5) end, -- Limit < 100% Keep some life dependency
	getPsiDamageResist = function(self, t)
		local lifemod = 1 + (1 + self.level)/2/40 -- Follows normal life progression with level see mod.class.Actor:getRankLifeAdjust (level_adjust = 1 + self.level / 40)
		-- Note: This effectively magifies healing effects
		local talentmod = self:combatTalentLimit(t, 50, 2.5, 10) -- Limit < 50%
		return 100 - (100 - talentmod)/lifemod, 1-1/lifemod, talentmod
	end,

	on_learn = function(self, t)
		if self:getTalentLevelRaw(t) == 1 then
			self.inc_resource_multi.psi = (self.inc_resource_multi.psi or 0) + 0.5
			self.inc_resource_multi.life = (self.inc_resource_multi.life or 0) - 0.25
			self.life_rating = math.ceil(self.life_rating/2)
			self.psi_rating =  self.psi_rating + 5
			self.solipsism_threshold = (self.solipsism_threshold or 0) + 0.2
			
			-- Adjust the values onTickEnd for NPCs to make sure these table values are resolved
			-- If we're not the player, we resetToFull to ensure correct values
			game:onTickEnd(function()
				self:incMaxPsi((self:getWil()-10) * 1)
				self.max_life = self.max_life - (self:getCon()-10) * 0.5
				if self ~= game.player then self:resetToFull() end
			end)
		end
	end,
	on_unlearn = function(self, t)
		if not self:knowTalent(t) then
			self:incMaxPsi(-(self:getWil()-10) * 0.5)
			self.max_life = self.max_life + (self:getCon()-10) * 0.25
			self.inc_resource_multi.psi = self.inc_resource_multi.psi - 0.5
			self.inc_resource_multi.life = self.inc_resource_multi.life + 0.25
			self.solipsism_threshold = self.solipsism_threshold - 0.2
		end
	end,
	info = function(self, t)
		local conversion_ratio = t.getConversionRatio(self, t)
		local psi_damage_resist, psi_damage_resist_base, psi_damage_resist_talent = t.getPsiDamageResist(self, t)
		local threshold = math.min((self.solipsism_threshold or 0),self:callTalent(self.T_CLARITY, "getClarityThreshold") or 1)
		return ([[你 相 信 你 的 心 灵 是 世 间 万 物 的 中 心。 
		 每 级 永 久 性 增 加 你 5 点 超 能 力 值， 并 减 少 你 50％ 的 生 命 成 长（ 影 响 升 级 时 的 生 命 增 益， 但 只 在 学 习 此 技 能 时 永 久 影 响 一 次）
		 同 时 你 学 会 用 心 灵 来 承 受 伤 害， 转 化 %d%% 生 命 削 减 为 超 能 力 值 削 减， 并 且 %d%% 的 治 疗 值 和 回 复 值 会 转 化 为 超 能 力 值 的 增 长。 
		 转 化 成 的 超 能 力 值 削 减 将 进 一 步 被 减 少 %0.1f%% （ %0.1f%% 来 自 于 人 物 等 级， %0.1f%% 来 自 于 技 能 等 级 。 ） 
		 学 习 此 技 能 时，（ 高 于 基 础 值 10 的） 每 点 意 志 会 额 外 增 加 0.5 点 超 能 力 值 上 限， 而（ 高 于 基 础 值 10 的） 每 点 体 质 会 减 少 0.25 点 生 命 上 限（ 若 低 于 基 础 值 10 则 增 加 生 命 上 限）。 
		 学 习 此 技 能 时， 你 的 唯 我 临 界 点 会 增 加 20％（ 当 前 %d%% ）， 你 的 超 能 力 值 每 低 于 这 个 临 界 点 1％， 你 的 所 有 速 度 减 少 1％。]]):format(conversion_ratio * 100, conversion_ratio * 100, psi_damage_resist, psi_damage_resist_base * 100, psi_damage_resist_talent, (self.solipsism_threshold or 0) * 100)
	end,
}

newTalent{
	name = "Balance",
	type = {"psionic/solipsism", 2},
	points = 5, 
	require = psi_wil_req2,
	mode = "passive",
	getBalanceRatio = function(self, t) return math.min(0.1 + self:getTalentLevel(t) * 0.1, 1) end,
	on_learn = function(self, t)
		if self:getTalentLevelRaw(t) == 1 then
			self.inc_resource_multi.psi = (self.inc_resource_multi.psi or 0) + 0.5
			self.inc_resource_multi.life = (self.inc_resource_multi.life or 0) - 0.25
			self.solipsism_threshold = (self.solipsism_threshold or 0) + 0.1
			-- Adjust the values onTickEnd for NPCs to make sure these table values are filled out
			-- If we're not the player, we resetToFull to ensure correct values
			game:onTickEnd(function()
				self:incMaxPsi((self:getWil()-10) * 0.5)
				self.max_life = self.max_life - (self:getCon()-10) * 0.25
				if self ~= game.player then self:resetToFull() end
			end)
		end
	end,
	on_unlearn = function(self, t)
		if not self:knowTalent(t) then
			self:incMaxPsi(-(self:getWil()-10) * 0.5)
			self.max_life = self.max_life + (self:getCon()-10) * 0.25
			self.inc_resource_multi.psi = self.inc_resource_multi.psi - 0.5
			self.inc_resource_multi.life = self.inc_resource_multi.life + 0.25
			self.solipsism_threshold = self.solipsism_threshold - 0.1
		end
	end,
	info = function(self, t)
		local ratio = t.getBalanceRatio(self, t) * 100
		return ([[你 现 在 使 用 %d%% 精 神 豁 免 值 来 替 代 %d%% 物 理 和 法 术 豁 免（ 即 100％ 时 精 神 豁 免 完 全 替 代 所 有 豁 免）。 
		 学 习 此 技 能 时，（ 高 于 基 础 值 10 的） 每 点 意 志 会 额 外 增 加 0.5 点 超 能 力 值 上 限， 而（ 高 于 基 础 值 10 的） 每 点 体 质 会 减 少 0.25 点 生 命 上 限（ 若 低 于 基 础 值 10 则 增 加 生 命 上 限）。 
		 学 习 此 技 能 也 会 增 加 你 10％ 唯 我 临 界 点（ 当 前 %d%%）。]]):format(ratio, ratio, math.min((self.solipsism_threshold or 0),self.clarity_threshold or 1) * 100)
	end,
}

newTalent{
	name = "Clarity",
	type = {"psionic/solipsism", 3},
	points = 5, 
	require = psi_wil_req3,
	mode = "passive",
	-- Speed effect calculations performed in _M:actBase function in mod\class\Actor.lua to handle suppressing the solipsim threshold
	getClarityThreshold = function(self, t) return self:combatTalentLimit(t, 0, 0.89, 0.65)	end, -- Limit > 0%
	on_learn = function(self, t)
		if self:getTalentLevelRaw(t) == 1 then
			self.inc_resource_multi.psi = (self.inc_resource_multi.psi or 0) + 0.5
			self.inc_resource_multi.life = (self.inc_resource_multi.life or 0) - 0.25
			self.solipsism_threshold = (self.solipsism_threshold or 0) + 0.1
			-- Adjust the values onTickEnd for NPCs to make sure these table values are resolved
			-- If we're not the player, we resetToFull to ensure correct values
			game:onTickEnd(function()
				self:incMaxPsi((self:getWil()-10) * 0.5)
				self.max_life = self.max_life - (self:getCon()-10) * 0.25
				if self ~= game.player then self:resetToFull() end
			end)
		end
	end,
	on_unlearn = function(self, t)
		if not self:knowTalent(t) then
			self:incMaxPsi(-(self:getWil()-10) * 0.5)
			self.max_life = self.max_life + (self:getCon()-10) * 0.25
			self.inc_resource_multi.psi = self.inc_resource_multi.psi - 0.5
			self.inc_resource_multi.life = self.inc_resource_multi.life + 0.25
			self.solipsism_threshold = self.solipsism_threshold - 0.1
		end
	end,
	info = function(self, t)
		local threshold = t.getClarityThreshold(self, t)
		local bonus = ""
		if not self.max_level or self.max_level > 50 then
			bonus = " Exceptional focus on this talent can suppress your solipsism threshold."
		end
		return ([[当 你 的 超 能 力 值 超 过 %d%% 时， 每 超 过 1％ 你 增 加 1％ 整 体 速 度（ 最 大 值 %+d%%）。 
		 学 习 此 技 能 时，（ 高 于 基 础 值 10 的） 每 点 意 志 会 额 外 增 加 0.5 点 超 能 力 值 上 限， 而（ 高 于 基 础 值 10 的） 每 点 体 质 会 减 少 0.25 点 生 命 上 限（ 若 低 于 基 础 值 10 则 增 加 生 命 上 限）， 增 加 你 10％ 唯 我 临 界 点（ 当 前 %d%%）。]]):
		format(threshold * 100, (1-threshold)*100, math.min(self.solipsism_threshold or 0,threshold) * 100)..bonus
	end,
}

newTalent{
	name = "Dismissal",
	type = {"psionic/solipsism", 4},
	points = 5, 
	require = psi_wil_req4,
	mode = "passive",
	getSavePercentage = function(self, t) return self:combatTalentScale(t, 0.25, 0.6) end,
	on_learn = function(self, t)
		if self:getTalentLevelRaw(t) == 1 then
			self.inc_resource_multi.psi = (self.inc_resource_multi.psi or 0) + 0.5
			self.inc_resource_multi.life = (self.inc_resource_multi.life or 0) - 0.25
			self.solipsism_threshold = (self.solipsism_threshold or 0) + 0.1
			-- Adjust the values onTickEnd for NPCs to make sure these table values are resolved
			-- If we're not the player, we resetToFull to ensure correct values
			game:onTickEnd(function()
				self:incMaxPsi((self:getWil()-10) * 0.5)
				self.max_life = self.max_life - (self:getCon()-10) * 0.25
				if self ~= game.player then self:resetToFull() end
			end)
		end
	end,
	on_unlearn = function(self, t)
		if not self:knowTalent(t) then
			self:incMaxPsi(-(self:getWil()-10) * 0.5)
			self.max_life = self.max_life + (self:getCon()-10) * 0.25
			self.inc_resource_multi.psi = self.inc_resource_multi.psi - 0.5
			self.inc_resource_multi.life = self.inc_resource_multi.life + 0.25
			self.solipsism_threshold = self.solipsism_threshold - 0.1
		end
	end,
	-- called by _M:onTakeHit in mod.class.Actor.lua
	doDismissalOnHit = function(self, value, src, t)
		local saving_throw = self:combatMentalResist() * t.getSavePercentage(self, t)
		print("[Dismissal] ", self.name:capitalize(), " attempting to ignore ", value, "damage from ", src.name:capitalize(), "using", saving_throw,  "mental save.")
		if self:checkHit(saving_throw, value) then
			local dismissed = value * (1 - (1 / self:mindCrit(2))) -- Diminishing returns on high crits
			game:delayedLogMessage(self, nil, "豁免", "#TAN##Source#精神上豁免了部分伤害!")
			game:delayedLogDamage(src, self, 0, ("#TAN#(%d 豁免)#LAST#"):format(dismissed))
			return value - dismissed
		else
			return value
		end
	end,
	info = function(self, t)
		local save_percentage = t.getSavePercentage(self, t)
		return ([[每 当 你 受 到 伤 害 时， 你 会 使 用 %d%% 精 神 豁 免 来 鉴 定。 鉴 定 时 精 神 豁 免 可 能 暴 击， 至 少 减 少 50%% 的 伤 害 。 
		 学 习 此 技 能 时，（ 高 于 基 础 值 10 的） 每 点 意 志 会 额 外 增 加 0.5 点 超 能 力 值 上 限， 而（ 高 于 基 础 值 10 的） 每 点 体 质 会 减 少 0.25 点 生 命 上 限（ 若 低 于 基 础 值 10 则 增 加 生 命 上 限）。 
		 学 习 此 技 能 也 会 增 加 你 10％ 唯 我 临 界 点（ 当 前 %d%%）。]]):format(save_percentage * 100, math.min(self.solipsism_threshold or 0,self.clarity_threshold or 1) * 100)		
	end,
}