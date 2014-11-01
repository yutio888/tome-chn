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

local function combatTalentDamage(self, t, min, max)
	return self:combatTalentSpellDamage(t, min, max, self.level + self:getWil())
end

local function getWillFailureEffectiveness(self, minChance, maxChance, attackStrength)
	return attackStrength * self:getWil() * 0.05 * (minChance + (maxChance - minChance) / 2)
end

-- mindpower bonus for gloom talents
local function gloomTalentsMindpower(self)
	return self:combatScale(self:getTalentLevel(self.T_GLOOM) + self:getTalentLevel(self.T_WEAKNESS) + self:getTalentLevel(self.T_DISMAY) + self:getTalentLevel(self.T_SANCTUARY), 1, 1, 20, 20, 0.75)
end

newTalent{
	name = "Gloom",
	type = {"cursed/gloom", 1},
	mode = "sustained",
	require = cursed_wil_req1,
	points = 5,
	cooldown = 0,
	range = 3,
	no_energy = true,
	tactical = { BUFF = 5 },
	getChance = function(self, t) return self:combatLimit(self:getTalentLevel(t)^.5, 100, 7, 1, 15.65, 2.23) end, -- Limit < 100%
	getDuration = function(self, t)
		return 3
	end,
	activate = function(self, t)
		self.torment_turns = nil -- restart torment
		game:playSoundNear(self, "talents/arcane")
		return {
			particle = self:addParticles(Particles.new("gloom", 1)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeParticles(p.particle)
		return true
	end,
	do_gloom = function(self, tGloom)
		if game.zone.wilderness then return end

		-- all gloom effects are handled here
		local tWeakness = self:getTalentFromId(self.T_WEAKNESS)
		local tDismay = self:getTalentFromId(self.T_DISMAY)
		--local tSanctuary = self:getTalentFromId(self.T_SANCTUARY)
		--local tLifeLeech = self:getTalentFromId(self.T_LIFE_LEECH)
		--local lifeLeeched = 0
		
		local mindpower = self:combatMindpower(1, gloomTalentsMindpower(self))
		
		local grids = core.fov.circle_grids(self.x, self.y, self:getTalentRange(tGloom), true)
		for x, yy in pairs(grids) do
			for y, _ in pairs(grids[x]) do
				local target = game.level.map(x, y, Map.ACTOR)
				if target and self:reactionToward(target) < 0 then
					-- check for hate bonus against tough foes
					if target.rank >= 3.5 and not target.gloom_hate_bonus then
						local hateGain = target.rank >= 4 and 20 or 10
						self:incHate(hateGain)
						game.logPlayer(self, "#F53CBE#Your heart hardens as a powerful foe enters your gloom! (+%d hate)", hateGain)
						target.gloom_hate_bonus = true
					end
				
					-- Gloom
					if self:getTalentLevel(tGloom) > 0 and rng.percent(tGloom.getChance(self, tGloom)) and target:checkHit(mindpower, target:combatMentalResist(), 5, 95, 15) then
						local effect = rng.range(1, 3)
						if effect == 1 then
							-- confusion
							if target:canBe("confusion") and not target:hasEffect(target.EFF_GLOOM_CONFUSED) then
								target:setEffect(target.EFF_GLOOM_CONFUSED, 2, {power=70})
							end
						elseif effect == 2 then
							-- stun
							if target:canBe("stun") and not target:hasEffect(target.EFF_GLOOM_STUNNED) then
								target:setEffect(target.EFF_GLOOM_STUNNED, 2, {})
							end
						elseif effect == 3 then
							-- slow
							if target:canBe("slow") and not target:hasEffect(target.EFF_GLOOM_SLOW) then
								target:setEffect(target.EFF_GLOOM_SLOW, 2, {power=0.3})
							end
						end
					end

					-- Weakness
					if self:getTalentLevel(tWeakness) > 0 and rng.percent(tWeakness.getChance(self, tWeakness)) and target:checkHit(mindpower, target:combatMentalResist(), 5, 95, 15) then
						if not target:hasEffect(target.EFF_GLOOM_WEAKNESS) then
							local duration = tWeakness.getDuration(self, tWeakness)
							local incDamageChange = tWeakness.getIncDamageChange(self, tWeakness)
							local hateBonus = tWeakness.getHateBonus(self, tWeakness)
							target:setEffect(target.EFF_GLOOM_WEAKNESS, duration, {incDamageChange=incDamageChange,hateBonus=hateBonus})
						end
					end

					-- Dismay
					if self:getTalentLevel(tDismay) > 0 and rng.percent(tDismay.getChance(self, tDismay)) and target:checkHit(mindpower, target:combatMentalResist(), 5, 95, 15) then
						target:setEffect(target.EFF_DISMAYED, tDismay.getDuration(self, tDismay), {})
					end

					-- Life Leech
					--if tLifeLeech and self:getTalentLevel(tLifeLeech) > 0 and target:checkHit(mindpower, target:combatMentalResist(), 5, 95, 15) then
					--	local damage = tLifeLeech.getDamage(self, tLifeLeech)
					--	local actualDamage = DamageType:get(DamageType.LIFE_LEECH).projector(self, target.x, target.y, DamageType.LIFE_LEECH, damage)
					--	lifeLeeched = lifeLeeched + actualDamage
					--end
				end
			end
		end

		-- life leech
		--if lifeLeeched > 0 then
		--	lifeLeeched = math.min(lifeLeeched, tLifeLeech.getMaxHeal(self, tLifeLeech))
		--	local temp = self.healing_factor
		--	self.healing_factor = 1
		--	self:heal(lifeLeeched)
		--	self.healing_factor = temp
		--	game.logPlayer(self, "#F53CBE#You leech %0.1f life from your foes.", lifeLeeched)
		--end
	end,
	info = function(self, t)
		local chance = t.getChance(self, t)
		local duration = t.getDuration(self, t)
		local mindpowerChange = gloomTalentsMindpower(self)
		return ([[1 个 3 码 半 径 范 围 的 可 怕 黑 暗 光 环 围 绕 你 , 影 响 附 近 的 敌 人。 
		 光 环 内 的 每 一 个 目 标 每 回 合 必 须 与 你 的 精 神 强 度 进 行 豁 免 鉴 定， 未 通 过 鉴 定 则 有 %d%% 概 率 被 减 速、 震 慑、 混 乱， 持 续 %d 回 合。 
		 这 个 能 力 是 与 生 俱 来 的， 激 活 或 停 止 不 消 耗 任 何 能 量， 每 增 加 一 点 技 能 点 可 增 加 黑 暗 光 环 系 精 神 强 度（ 当 前： %+d ）。]]):format(chance, duration, mindpowerChange)
	end,
}

newTalent{
	name = "Weakness",
	type = {"cursed/gloom", 2},
	mode = "passive",
	require = cursed_wil_req2,
	points = 5,
	getChance = function(self, t) return self:combatLimit(self:getTalentLevel(t)^.5, 100, 7, 1, 15.65, 2.23) end, -- Limit < 100%
	getDuration = function(self, t)
		return 3
	end,
	getIncDamageChange = function(self, t) return self:combatLimit(self:getTalentLevel(t)^.5, 65, 12, 1, 26.8, 2.23) end, -- Limit to <65%
	getHateBonus = function(self, t)
		return 2
	end,
	info = function(self, t)
		local chance = t.getChance(self, t)
		local duration = t.getDuration(self, t)
		local incDamageChange = t.getIncDamageChange(self, t)
		local hateBonus = t.getHateBonus(self, t)
		local mindpowerChange = gloomTalentsMindpower(self)
		return ([[在 黑 暗 光 环 里 的 每 一 个 目 标 每 回 合 必 须 与 你 的 精 神 强 度 进 行 豁 免 鉴 定， 未 通 过 鉴 定 则 有 %d%% 概 率 被 恐 惧 而 虚 弱 持 续 %d 回 合， 降 低 %d%% 伤 害， 你 对 被 削 弱 目 标 的 首 次 近 战 攻 击 能 获 得 %d 点 仇 恨 值。 
		 每 增 加 一 点 技 能 点 可 增 加 黑 暗 光 环 系 精 神 强 度（ 当 前： %+d ）。]]):format(chance, duration, -incDamageChange, hateBonus, mindpowerChange)
	end,
}

newTalent{
	name = "Dismay",
	type = {"cursed/gloom", 3},
	mode = "passive",
	require = cursed_wil_req3,
	points = 5,
	getChance = function(self, t) return self:combatLimit(self:getTalentLevel(t)^.5, 100, 3.5, 1, 7.83, 2.23) end, -- Limit < 100%
	getDuration = function(self, t)
		return 3
	end,
	info = function(self, t)
		local chance = t.getChance(self, t)
		local duration = t.getDuration(self, t)
		local mindpowerChange = gloomTalentsMindpower(self)
		return ([[在 黑 暗 光 环 里 的 每 一 个 目 标 每 回 合 必 须 与 你 的 精 神 强 度 进 行 豁 免 鉴 定， 未 通 过 鉴 定 则 有 %0.1f%% 概 率 受 到 黑 暗 痛 苦 持 续 %d 回 合， 你 对 受 黑 暗 痛 苦 折 磨 的 目 标 进 行 的 首 次 近 战 攻 击 必 定 暴 击。 
		 每 增 加 一 点 技 能 点 可 增 加 黑 暗 光 环 系 精 神 强 度（ 当 前： %+d ）。]]):format(chance, duration, mindpowerChange)
	end,
}

--newTalent{
--	name = "Life Leech",
--	type = {"cursed/gloom", 4},
--	mode = "passive",
--	require = cursed_wil_req4,
--	points = 5,
--	getDamage = function(self, t)
--		return combatTalentDamage(self, t, 2, 10)
--	end,
--	getMaxHeal = function(self, t)
--		return combatTalentDamage(self, t, 4, 25)
--	end,
--	info = function(self, t)
--		local damage = t.getDamage(self, t)
--		local maxHeal = t.getMaxHeal(self, t)
--		local mindpowerChange = self:getTalentLevelRaw(self.T_GLOOM) + self:getTalentLevelRaw(self.T_WEAKNESS) + self:getTalentLevelRaw(self.T_DISMAY) + self:getTalentLevelRaw(self.T_LIFE_LEECH)
--		return ([[Each turn, those caught in your gloom must save against your mindpower or have %0.1f life leeched from them. Life leeched in this way will restore up to a total of %0.1f of your own life per turn. This form of healing is unaffected by healing modifiers.
--		Each point in Life Leech increases the mindpower of all gloom effects (current: %+d).]]):format(damage, maxHeal, mindpowerChange)
--	end,
--}

newTalent{
	name = "Sanctuary",
	type = {"cursed/gloom", 4},
	mode = "passive",
	require = cursed_wil_req4,
	points = 5,
	getDamageChange = function(self, t)
		return math.max(-35, -math.sqrt(self:getTalentLevel(t)) * 11)
	end,
	info = function(self, t)
		local damageChange = t.getDamageChange(self, t)
		local mindpowerChange = gloomTalentsMindpower(self)
		return ([[你 的 黑 暗 光 环 成 为 独 立 于 外 界 的 避 难 所， 任 何 光 环 外 的 目 标 对 你 的 伤 害 降 低 %d%% 。 
		 每 增 加 一 点 技 能 点 可 增 加 黑 暗 光 环 系 精 神 强 度（ 当 前： %+d ）。]]):format(-damageChange, mindpowerChange)
	end,
}
