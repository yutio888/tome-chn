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
	name = "Spacetime Tuning",
	type = {"chronomancy/other", 1},
	points = 1,
	tactical = { PARADOX = 2 },
	no_npc_use = true,
	no_unlearn_last = true,
	on_learn = function(self, t)
		if not self.preferred_paradox then self.preferred_paradox = 0 end
	end,
	on_unlearn = function(self, t)
		if self.preferred_paradox then self.preferred_paradox = nil end
	end,
	getDuration = function(self, t) 
		local power = math.floor(self:combatSpellpower()/10)
		return math.max(20 - power, 10)
	end,
	action = function(self, t)
		function getQuantity(title, prompt, default, min, max)
			local result
			local co = coroutine.running()

			local dialog = engine.dialogs.GetQuantity.new(
				title,
				prompt,
				default,
				max,
				function(qty)
					result = qty
					coroutine.resume(co)
				end,
				min)
			dialog.unload = function(dialog)
				if not dialog.qty then coroutine.resume(co) end
			end

			game:registerDialog(dialog)
			coroutine.yield()
			return result
		end

		local paradox = getQuantity(
			"Spacetime Tuning",
			"What's your preferred paradox level?",
			math.floor(self.paradox))
		if not paradox then return end
		if paradox > 1000 then paradox = 1000 end
		self.preferred_paradox = paradox
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local preference = self.preferred_paradox
		local multiplier = getParadoxModifier(self, pm)*100
		local _, will_modifier = self:getModifiedParadox()
		local after_will = self:getModifiedParadox()
		local _, failure = self:paradoxFailChance()
		local _, anomaly = self:paradoxAnomalyChance()
		local _, backfire = self:paradoxBackfireChance()
		return ([[设 置 一 个 紊 乱 值 ， 休 息 时 会 自 动 在 %d 回 合 内 （ 最 低 10 回 合 ） 调 整 至 该 值 ， 不 能 超 过 1000。
		受 法 术 强 度 影 响 ， 时 间 会 缩 短 。

		设 定 紊 乱 值: %d
		紊 乱 值 加 成: %d%%
		意 志 修 正 值: %d
		修 正 紊 乱 值: %d
		当 前 失 败 率: %d%%
		当 前 变 异 率: %d%%
		当 前 走 火 率: %d%%]]):format(duration, preference, multiplier, will_modifier, after_will, failure, anomaly, backfire)
	end,
}


newTalent{
	name = "Precognition",
	type = {"chronomancy/chronomancy",1},
	require = temporal_req1,
	points = 5,
	paradox = 5,
	cooldown = 10,
	no_npc_use = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 14)) end,
	action = function(self, t)
		if checkTimeline(self) == true then
			return
		end
		game:playSoundNear(self, "talents/spell_generic")
		self:setEffect(self.EFF_PRECOGNITION, t.getDuration(self, t), {})
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 预 知 未 来， 允 许 你 探 索 周 围 的 事 物， 持 续 %d 回 合。 当 此 技 能 结 束 时， 你 会 回 到 原 来 释 放 该 法 术 的 时 间 点。 在 此 技 能 持 续 过 程 中 死 亡 会 提 前 中 断 技 能。 
		 这 个 法 术 会 使 时 间 线 分 裂， 所 以 其 他 同 样 能 使 时 间 线 分 裂 的 技 能 在 此 期 间 不 能 成 功 释 放。
		 分 裂 时 间 线 非 常 困 难 ， 在 使 用 这 个 技 能 的 回 合 你 不 会 受 到 保 护 。 
		 ]]):format(duration)
	end,
}

newTalent{
	name = "Foresight",
	type = {"chronomancy/chronomancy",2},
	mode = "passive",
	require = temporal_req2,
	points = 5,
	getRadius = function(self, t) return math.floor(self:combatTalentScale(t, 5, 13)) end,
	do_precog_foresight = function(self, t)
		self:magicMap(t.getRadius(self, t))
		self:setEffect(self.EFF_SENSE, 1, {
			range = t.getRadius(self, t),
			actor = 1,
			object = 1,
			trap = 1,
		})
	end,
	info = function(self, t)
		local radius = t.getRadius(self, t)
		return ([[在 预 知 未 来 技 能 结 束 后， 你 可 以 得 到 %d 码 半 径 范 围 的 视 野， 显 示 周 围 的 地 形、 敌 人、 物 品 和 陷 阱。]]):
		format(radius)
	end,
}

newTalent{
	name = "Moment of Prescience",
	type = {"chronomancy/chronomancy", 3},
	require = temporal_req3,
	points = 5,
	paradox = 10,
	cooldown = 18,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 18, 3, 10.5)) end, -- Limit < 18
	getPower = function(self, t) return self:combatTalentScale(t, 4, 15) end, -- Might need a buff
	tactical = { BUFF = 4 },
	no_energy = true,
	no_npc_use = true,
	action = function(self, t)
		local power = t.getPower(self, t)
		-- check for Spin Fate
		local eff = self:hasEffect(self.EFF_SPIN_FATE)
		if eff then
			local bonus = math.max(0, (eff.cur_save_bonus or eff.save_bonus) / 2)
			power = power + bonus
		end

		self:setEffect(self.EFF_PRESCIENCE, t.getDuration(self, t), {power=power})
		return true
	end,
	info = function(self, t)
		local power = t.getPower(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 集 中 意 识 提 升 你 的 潜 行 侦 测、 隐 形 侦 测、 闪 避 和 命 中 几 率 %d 持 续 %d 回 合。 
		 如 果 你 已 经 激 活 了 命 运 之 网 技 能， 你 将 得 到 一 个 基 于 50%% 命 运 之 网 获 得 提 升 点 数 的 增 益。 
		 此 技 能 不 需 要 施 法 时 间。]]):
		format(power, duration)
	end,
}

newTalent{
	name = "Spin Fate",
	type = {"chronomancy/chronomancy", 4},
	require = temporal_req4,
	mode = "passive",
	points = 5,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6, "log")) end,
	getSaveBonus = function(self, t) return self:combatTalentScale(t, 1, 5, 0.75) end,
	do_spin_fate = function(self, t, type)
		local save_bonus = t.getSaveBonus(self, t)
	
		if type ~= "defense" then
			if not self:hasEffect(self.EFF_SPIN_FATE) then
				game:playSoundNear(self, "talents/spell_generic")
			end
			self:setEffect(self.EFF_SPIN_FATE, t.getDuration(self, t), {max_bonus = t.getSaveBonus(self, t) * 5, save_bonus = t.getSaveBonus(self, t)})
		end
		
		return true
	end,
	info = function(self, t)
		local save = t.getSaveBonus(self, t)
		local duration = t.getDuration(self, t)
		return ([[当 未 来 逐 渐 呈 现 在 你 面 前 时， 你 学 会 如 何 对 未 来 事 件 进 行 少 量 的 修 正。 每 当 攻 击 者 对 你 的 闪 避 或 豁 免 进 行 判 定 时， 你 的 数 值 会 额 外 增 加 %d 点 强 度（ 每 个 属 性 最 大 累 积 增 加 %d ）。 
		 此 效 果 持 续 %d 回 合， 并 且 每 当 此 效 果 激 活 时 会 刷 新 持 续 时 间。]]):
		format(save, save * 5, duration)
	end,
}

