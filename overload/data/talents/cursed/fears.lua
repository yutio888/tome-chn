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
	name = "Instill Fear",
	type = {"cursed/fears", 1},
	require = cursed_wil_req1,
	points = 5,
	random_ego = "attack",
	cooldown = 6,
	hate = 8,
	range = 8,
	radius = function(self, t) return 2 end,
	tactical = { DISABLE = 2 },
	getDuration = function(self, t)
		return 8
	end,
	getParanoidAttackChance = function(self, t)
		return math.min(60, self:combatTalentMindDamage(t, 30, 50))
	end,
	getDespairResistAllChange = function(self, t)
		return -self:combatTalentMindDamage(t, 15, 40)
	end,
	hasEffect = function(self, t, target)
		if not target then return false end
		if target:hasEffect(target.EFF_PARANOID) then return true end
		if target:hasEffect(target.EFF_DISPAIR) then return true end
		if target:hasEffect(target.EFF_TERRIFIED) then return true end
		if target:hasEffect(target.EFF_DISTRESSED) then return true end
		if target:hasEffect(target.EFF_HAUNTED) then return true end
		if target:hasEffect(target.EFF_TORMENTED) then return true end
		return false
	end,
	applyEffect = function(self, t, target)
		if not target:canBe("fear") then
			game.logSeen(target, "#F53CBE#%s ignores the fear!", target.name:capitalize())
			return true
		end
		
		local tHeightenFear = nil
		if self:knowTalent(self.T_HEIGHTEN_FEAR) then tHeightenFear = self:getTalentFromId(self.T_HEIGHTEN_FEAR) end
		local tTyrant = nil
		if self:knowTalent(self.T_TYRANT) then tTyrant = self:getTalentFromId(self.T_TYRANT) end
		local mindpowerChange = tTyrant and tTyrant.getMindpowerChange(self, tTyrant) or 0
		
		local mindpower = self:combatMindpower(1, mindpowerChange)
		if not target:checkHit(mindpower, target:combatMentalResist()) then
			game.logSeen(target, "%s resists the fear!", target.name:capitalize())
			return nil
		end
		
		local effects = {}
		if not target:hasEffect(target.EFF_PARANOID) then table.insert(effects, target.EFF_PARANOID) end
		if not target:hasEffect(target.EFF_DISPAIR) then table.insert(effects, target.EFF_DISPAIR) end
		if tHeightenFear and not target:hasEffect(target.EFF_TERRIFIED) then table.insert(effects, target.EFF_TERRIFIED) end
		if tHeightenFear and not target:hasEffect(target.EFF_DISTRESSED) then table.insert(effects, target.EFF_DISTRESSED) end
		if tTyrant and not target:hasEffect(target.EFF_HAUNTED) then table.insert(effects, target.EFF_HAUNTED) end
		if tTyrant and not target:hasEffect(target.EFF_TORMENTED) then table.insert(effects, target.EFF_TORMENTED) end
		
		if #effects == 0 then return nil end
		local effectId = rng.table(effects)
		
		local duration = t.getDuration(self, t)
		local eff = {src=self, duration=duration }
		if effectId == target.EFF_PARANOID then
			eff.attackChance = t.getParanoidAttackChance(self, t)
			eff.mindpower = mindpower
		elseif effectId == target.EFF_DISPAIR then
			eff.resistAllChange = t.getDespairResistAllChange(self, t)
		elseif effectId == target.EFF_TERRIFIED then
			eff.actionFailureChance = tHeightenFear.getTerrifiedActionFailureChance(self, tHeightenFear)
		elseif effectId == target.EFF_DISTRESSED then
			eff.saveChange = tHeightenFear.getDistressedSaveChange(self, tHeightenFear)
		elseif effectId == target.EFF_HAUNTED then
			eff.damage = tTyrant.getHauntedDamage(self, tTyrant)
		elseif effectId == target.EFF_TORMENTED then
			eff.count = tTyrant.getTormentedCount(self, tTyrant)
			eff.damage = tTyrant.getTormentedDamage(self, tTyrant)
			eff.counts = {}
			for i = 1, duration do
				eff.counts[i] = math.floor(eff.count / duration) + ((eff.count % duration >= i) and 1 or 0)
			end
		else
			print("* fears: failed to get effect", effectId)
		end
		
		target:setEffect(effectId, duration, eff)
		
		-- heightened fear
		if tHeightenFear and not target:hasEffect(target.EFF_HEIGHTEN_FEAR) then
			local turnsUntilTrigger = tHeightenFear.getTurnsUntilTrigger(self, tHeightenFear)
			target:setEffect(target.EFF_HEIGHTEN_FEAR, 1, {src=self, range=self:getTalentRange(tHeightenFear), turns=turnsUntilTrigger, turns_left=turnsUntilTrigger })
		end
		
		return effectId
	end,
	endEffect = function(self, t)
		local tHeightenFear = nil
		if self:knowTalent(self.T_HEIGHTEN_FEAR) then tHeightenFear = self:getTalentFromId(self.T_HEIGHTEN_FEAR) end
		if tHeightenFear then
			if not t.hasEffect(self, t) then
				-- no more fears
				self:removeEffect(self.EFF_HEIGHTEN_FEAR)
			end
		end
	end,
	requires_target = true,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target or core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then return nil end
		
		self:project(
			tg, x, y,
			function(px, py)
				local actor = game.level.map(px, py, engine.Map.ACTOR)
				if actor and self:reactionToward(actor) < 0 and actor ~= self then
					if actor == target or rng.percent(25) then
						local tInstillFear = self:getTalentFromId(self.T_INSTILL_FEAR)
						tInstillFear.applyEffect(self, tInstillFear, actor)
					end
				end
			end,
			nil, nil)

		return true
	end,
	info = function(self, t)
		return ([[将 恐 惧 注 入 你 的 目 标， 在 %d 回 合 内 触 发 一 种 恐 惧 效 果。 同 时 有 25%% 概 率 将 恐 惧 注 入 %d 码 范 围 内 的 所 有 敌 人。 
		 目 标 将 与 你 的 精 神 强 度 进 行 豁 免 鉴 定， 并 且 可 以 被 多 种 恐 惧 效 果 影 响。 
		 你 习 得 2 种 新 的 恐 惧 效 果： 妄 想 症 使 目 标 有 %d%% 概 率 以 物 理 攻 击 附 近 一 个 友 善 或 非 友 善 目 标， 被 击 中 者 也 会 被 传 染 妄 想 症。 绝 望 效 果 使 目 标 对 所 有 伤 害 抵 抗 减 少 %d%% 。 
		 受 精 神 强 度 影 响， 恐 惧 效 果 有 额 外 加 成。]]):format(t.getDuration(self, t), self:getTalentRadius(t),
		t.getParanoidAttackChance(self, t),
		-t.getDespairResistAllChange(self, t))
	end,
}

newTalent{
	name = "Heighten Fear",
	type = {"cursed/fears", 2},
	require = cursed_wil_req2,
	mode = "passive",
	points = 5,
	range = function(self, t)
		return math.sqrt(self:getTalentLevel(t)) * 3
	end,
	getTurnsUntilTrigger = function(self, t)
		return 5
	end,
	getTerrifiedActionFailureChance = function(self, t)
		return math.min(50, self:combatTalentMindDamage(t, 20, 45))
	end,
	getDistressedSaveChange = function(self, t)
		return -self:combatTalentMindDamage(t, 15, 30)
	end,
	tactical = { DISABLE = 2 },
	info = function(self, t)
		local tInstillFear = self:getTalentFromId(self.T_INSTILL_FEAR)
		local range = self:getTalentRange(t)
		local turnsUntilTrigger = t.getTurnsUntilTrigger(self, t)
		local duration = tInstillFear.getDuration(self, tInstillFear)
		return ([[ 加 深 你 周 围 所 有 人 的 恐 惧 。 被 你 的 恐 惧 效 果 影 响 的 敌 人、 和 你 距 离 不 超 过 %d 且 在 你 视 野 内 不 少 于 %d 回 合 的 敌 人 ， 将 会 得 到 一 种 新 的 恐 惧 效 果 ， 持 续 %d 回 合。 目 标 的 精 神 豁 免 抵 抗 你 的 精 神 强 度 后 可 能 会 抵 抗 该 效 果， 且 每 个 已 有 的 恐 惧 效 果 会 减 少 10%% 新 的 恐 惧 效 果 产 生 概 率。
		 你 习 得 2 种 新 的 恐 惧 效 果： 惊 恐 效 果 使 其 技 能 或 攻 击 失 败 %d%% 。 痛 苦 效 果 使 其 所 有 豁 免 值 降 低 %d 。 
		 受 精 神 强 度 影 响， 恐 惧 效 果 有 额 外 加 成。]]):format(range, turnsUntilTrigger, duration,
		t.getTerrifiedActionFailureChance(self, t),
		-t.getDistressedSaveChange(self, t))
	end,
}

newTalent{
	name = "Tyrant",
	type = {"cursed/fears", 3},
	mode = "passive",
	require = cursed_wil_req3,
	points = 5,
	on_learn = function(self, t)
	end,
	on_unlearn = function(self, t)
	end,
	getMindpowerChange = function(self, t)
		return math.floor(math.sqrt(self:getTalentLevel(t)) * 7)
	end,
	getHauntedDamage = function(self, t)
		return self:combatTalentMindDamage(t, 40, 60)
	end,
	getTormentedCount = function(self, t)
		return 4 + math.min(5, math.floor(math.pow(self:getTalentLevelRaw(t), 0.7)))
	end,
	getTormentedDamage = function(self, t)
		return self:combatTalentMindDamage(t, 40, 60)
	end,
	info = function(self, t)
		return ([[提 高 对 恐 惧 的 目 标 的 精 神 专 制， 对 那 些 试 图 摆 脱 你 恐 惧 效 果 的 目 标 你 的 精 神 强 度 增 加 %d ， 你 习 得 2 种 新 的 恐 惧 效 果： 纠 缠 效 果 使 得 每 一 种 恐 惧 效 果 产 生 %d 精 神 伤 害， 痛 苦 折 磨 效 果 产 生 %d 个 幻 觉 攻 击 目 标， 产 生 %d 精 神 伤 害 直 至 幻 觉 消 失。 
		 受 精 神 强 度 影 响， 恐 惧 效 果 有 额 外 加 成。]]):format(t.getMindpowerChange(self, t),
		t.getHauntedDamage(self, t),
		t.getTormentedCount(self, t), t.getTormentedDamage(self, t))
	end,
}

newTalent{
	name = "Panic",
	type = {"cursed/fears", 4},
	require = cursed_wil_req4,
	points = 5,
	random_ego = "attack",
	cooldown = 20,
	hate =  1,
	range = 4,
	tactical = { DISABLE = 4 },
	getDuration = function(self, t)
		return 3 + math.floor(math.pow(self:getTalentLevel(t), 0.5) * 2.2)
	end,
	getChance = function(self, t)
		return math.min(60, math.floor(30 + (math.sqrt(self:getTalentLevel(t)) - 1) * 22))
	end,
	action = function(self, t)
		local range = self:getTalentRange(t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		self:project(
			{type="ball", radius=range}, self.x, self.y,
			function(px, py)
				local actor = game.level.map(px, py, engine.Map.ACTOR)
				if actor and self:reactionToward(actor) < 0 and actor ~= self then
					if not actor:canBe("fear") then
						game.logSeen(actor, "#F53CBE#%s ignores the panic!", actor.name:capitalize())
					elseif actor:checkHit(self:combatMindpower(), actor:combatMentalResist(), 0, 95) then
						actor:setEffect(actor.EFF_PANICKED, duration, {src=self,range=10,chance=chance})
					else
						game.logSeen(actor, "#F53CBE#%s resists the panic!", actor.name:capitalize())
					end
				end
			end,
			nil, nil)
		return true
	end,
	info = function(self, t)
		local range = self:getTalentRange(t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		return ([[使 %d 范 围 内 的 敌 人 惊 慌 失 措， 持 续 %d 回 合， 任 何 未 通 过 精 神 豁 免 的 敌 人 每 回 合 将 有 %d%% 概 率 从 你 身 边 吓 走。]]):format(range, duration, chance)
	end,
}
