-- Skirmisher, a class for Tales of Maj'Eyal 1.1.5
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



newTalent {
	short_name = "SKIRMISHER_BREATHING_ROOM",
	name = "Breathing Room",
	type = {"technique/tireless-combatant", 1},
	require = techs_wil_req1,
	mode = "passive",
	points = 5,
	getRestoreRate = function(self, t)
		return t.applyMult(self, t, self:combatTalentScale(t, 1.5, 6, 0.75))
	end,
	applyMult = function(self, t, gain)
		if self:knowTalent(self.T_SKIRMISHER_THE_ETERNAL_WARRIOR) then
			local t2 = self:getTalentFromId(self.T_SKIRMISHER_THE_ETERNAL_WARRIOR)
			return gain * t2.getMult(self, t2)
		else
			return gain
		end
	end,
	callbackOnAct = function(self, t)

		-- Remove the existing regen rate
		if self.temp_skirmisherBreathingStamina then
			self:removeTemporaryValue("stamina_regen", self.temp_skirmisherBreathingStamina)
		end
		if self.temp_skirmisherBreathingLife then
			self:removeTemporaryValue("life_regen", self.temp_skirmisherBreathingLife)
		end
		self.temp_skirmisherBreathingStamina = nil
		self.temp_skirmisherBreathingLife = nil

		-- Calculate surrounding enemies
		local nb_foes = 0
		local add_if_visible_enemy = function(x, y)
			local target = game.level.map(x, y, game.level.map.ACTOR)
			if target and self:reactionToward(target) < 0 and self:canSee(target) then
				nb_foes = nb_foes + 1
			end
		end
		local adjacent_tg = {type = "ball", range = 0, radius = 1, selffire = false}
		self:project(adjacent_tg, self.x, self.y, add_if_visible_enemy)

		-- Add new regens if needed
		if nb_foes == 0 then
			self.temp_skirmisherBreathingStamina = self:addTemporaryValue("stamina_regen", t.getRestoreRate(self, t))
			if self:getTalentLevelRaw(t) >= 3 then
				self.temp_skirmisherBreathingLife = self:addTemporaryValue("life_regen", t.getRestoreRate(self, t))
			end
		end

	end,
	info = function(self, t)
		local stamina = t.getRestoreRate(self, t)
		return ([[当 没 有 敌 人 与 你 相 邻 的 时 候， 你 获 得 %0.1f 体 力 回 复。 在 第 3 级 时， 这 个 技 能 带 给 你 等 量 的 生 命 回 复.]])
			:format(stamina)
	end,
}

newTalent {
	short_name = "SKIRMISHER_PACE_YOURSELF",
	name = "Pace Yourself",
	type = {"technique/tireless-combatant", 2},
	mode = "sustained",
	points = 5,
	cooldown = 10,
	sustain_stamina = 0,
	no_energy = true,
	require = techs_wil_req2,
	tactical = { STAMINA = 2 },
	random_ego = "utility",
	activate = function(self, t)
		-- Superloads Combat:combatFatigue.
		local eff = {}
		self:talentTemporaryValue(eff, "global_speed_add", -t.getSlow(self, t))
		self:talentTemporaryValue(eff, "fatigue", -t.getReduction(self, t))
		return eff
	end,
	deactivate = function(self, t, p) return true end,
	getSlow = function(self, t)
		return  self:combatTalentLimit(t, 0, 0.15, .05)
	end,
	getReduction = function(self, t)
		return self:combatTalentScale(t, 10, 30)
	end,
	info = function(self, t)
		local slow = t.getSlow(self, t) * 100
		local reduction = t.getReduction(self, t)
		return ([[控 制 你 的 行 动 来 节 省 体 力。 当 这 个 技 能 激 活 时， 你 的 全 局 速 度 降 低 %0.1f%%， 你 的 疲 劳 值 降 低 %d%% （ 最 多 降 至 0%%）。]])
		:format(slow, reduction)
	end,
}

newTalent {
	short_name = "SKIRMISHER_DAUNTLESS_CHALLENGER",
	name = "Dauntless Challenger",
	type = {"technique/tireless-combatant", 3},
	require = techs_wil_req3,
	mode = "passive",
	points = 5,
	getStaminaRate = function(self, t)
		return t.applyMult(self, t, self:combatTalentScale(t, 0.3, 1.5, 0.75))
	end,
	getLifeRate = function(self, t)
		return t.applyMult(self, t, self:combatTalentScale(t, 1, 5, 0.75))
	end,
	applyMult = function(self, t, gain)
		if self:knowTalent(self.T_SKIRMISHER_THE_ETERNAL_WARRIOR) then
			local t2 = self:getTalentFromId(self.T_SKIRMISHER_THE_ETERNAL_WARRIOR)
			return gain * t2.getMult(self, t2)
		else
			return gain
		end
	end,
	callbackOnAct = function(self, t)
		-- Remove the existing regen rate
		if self.temp_skirmisherDauntlessStamina then
			self:removeTemporaryValue("stamina_regen", self.temp_skirmisherDauntlessStamina)
		end
		if self.temp_skirmisherDauntlessLife then
			self:removeTemporaryValue("life_regen", self.temp_skirmisherDauntlessLife)
		end
		self.temp_skirmisherDauntlessStamina = nil
		self.temp_skirmisherDauntlessLife = nil

		-- Calculate visible enemies
		local nb_foes = 0
		local act
		for i = 1, #self.fov.actors_dist do
			act = self.fov.actors_dist[i]
			if act and self:reactionToward(act) < 0 and self:canSee(act) then nb_foes = nb_foes + 1 end
		end

		-- Add new regens if needed
		if nb_foes >= 1 then
			if nb_foes > 4 then nb_foes = 4 end
			self.temp_skirmisherDauntlessStamina = self:addTemporaryValue("stamina_regen", t.getStaminaRate(self, t) * nb_foes)
			if self:getTalentLevelRaw(t) >= 3 then
				self.temp_skirmisherDauntlessLife = self:addTemporaryValue("life_regen", t.getLifeRate(self, t) * nb_foes)
			end
		end

	end,
	info = function(self, t)
		local stamina = t.getStaminaRate(self, t)
		local health = t.getLifeRate(self, t)
		return ([[当 战 斗 变 得 艰 难 时， 你 变 得 更 加 顽 强。 视 野 内 每 有 一 名 敌 人 存 在， 你 就 获 得 %0.1f 体 力 回 复。 从 第 三 级 起， 每 名 敌 人 同 时 能 增 加 %0.1f 生 命 回 复。 加 成 上 限 为 4 名 敌 人。]])
			:format(stamina, health)
	end,
}

newTalent {
	short_name = "SKIRMISHER_THE_ETERNAL_WARRIOR",
	name = "The Eternal Warrior",
	type = {"technique/tireless-combatant", 4},
	require = techs_wil_req4,
	mode = "passive",
	points = 5,
	getResist = function(self, t)
		return self:combatTalentScale(t, 0.7, 2.5)
	end,
	getResistCap = function(self, t)
		return self:combatTalentLimit(t, 30, 0.7, 2.5)/t.getMax(self, t) -- Limit < 30%
	end,
	getDuration = function(self, t)
		return 3
	end,
	getMax = function(self, t)
		return 5
	end,
	getMult = function(self, t, fake)
		if self:getTalentLevelRaw(t) >= 5 or fake then
			return 1.2
		else
			return 1
		end
	end,
	-- call from incStamina whenever stamina is incremented or decremented
	onIncStamina = function(self, t, delta)
		if delta < 0 and not self.temp_skirmisherSpentThisTurn then
			self:setEffect(self.EFF_SKIRMISHER_ETERNAL_WARRIOR, t.getDuration(self, t), {
				res = t.getResist(self, t),
				cap = t.getResistCap(self, t),
				max = t.getMax(self, t),
			})
			self.temp_skirmisherSpentThisTurn = true
		end
	end,
	callbackOnAct = function(self, t)
		self.temp_skirmisherSpentThisTurn = false
	end,
	info = function(self, t)
		local max = t.getMax(self, t)
		local duration = t.getDuration(self, t)
		local resist = t.getResist(self, t)
		local cap = t.getResistCap(self, t)
		local mult = (t.getMult(self, t, true) - 1) * 100
		return ([[每 回 合 使 用 体 力 后， 你 获 得 %0.1f%% 全 抗 性 加 成 和 %0.1f%% 全 抗 性 上 限， 持 续 %d 回 合。 加 成 效 果 最 多 叠 加 %d 次， 每 次 叠 加 都 会 刷 新 效 果 持 续 时 间。
		在 第 5 级 时 ，   喘 息 间 隙 和 不 屈 底 力 效 果 提 升 %d%%]])
			:format(resist, cap, duration, max, mult)
	end,
}
