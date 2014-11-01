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
	name = "Biofeedback",
	type = {"psionic/feedback", 1},
	points = 5, 
	require = psi_wil_req1,
	mode = "passive",
	-- called by _M:actBase in mod.class.Actor.lua
	getHealRatio = function(self, t) return self:combatScale(self:getWil()*self:getTalentLevel(t), 0, 0, 2.5, 500, 0.75) end, -- Follows buff to quick recovery, scales faster than getDecaySpeed to improve healing
	-- called by _M:getFeedbackDecay in mod.class.Actor.lua
	getDecaySpeed = function(self, t) return math.min(1, self:combatTalentLimit(t, 0.1, 0.9, 0.5)) end, -- Limit >10%
	info = function(self, t)
		local heal = t.getHealRatio(self, t)
		local decaySpeed = t.getDecaySpeed(self, t)
		local newDecay = decaySpeed*0.1
		local netHeal = newDecay*heal
		return ([[ 你 的 反 馈 值 衰 减 的 %0.1f%% 会 治 疗 你 ， 同 时 衰 减 速 率 下 降 %d%%（ 每 回 合 最 多 %0.1f%% ） 。 总 而 言 之， 每 回 合 你 将 受 到  治 疗 量 等 于 你 的 反 馈 池 %0.2f%% 的 治 疗。 
		受 精 神 强 度 影 响， 治 疗 效 果 按 比 例 加 成。]]):format(heal, decaySpeed*100, newDecay*100, netHeal*100)
	end,
}

newTalent{
	name = "Resonance Field",
	type = {"psionic/feedback", 2},
	points = 5,
	feedback = 25,
	require = psi_wil_req2,
	cooldown = 15,
	tactical = { DEFEND = 2},
	no_break_channel = true,
	getShieldPower = function(self, t) return self:combatTalentMindDamage(t, 30, 470) end,
	action = function(self, t)
		self:setEffect(self.EFF_RESONANCE_FIELD, 10, {power = self:mindCrit(t.getShieldPower(self, t))})
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		local shield_power = t.getShieldPower(self, t)
		return ([[激 活 此 技 能 可 产 生 一 个 吸 收 50％ 伤 害 的 共 鸣 领 域（ 最 大 吸 收 值 %d ）。 此 领 域 不 会 干 扰 反 馈 值 的 增 长。 
		 受 精 神 强 度 影 响， 最 大 吸 收 值 有 额 外 加 成。 
		 此 技 能 最 多 维 持 10 回 合。]]):format(shield_power)
	end,
}

newTalent{
	name = "Amplification",
	type = {"psionic/feedback", 3},
	points = 5,
	require = psi_wil_req3,
	mode = "passive",
	-- 	called by _M:onTakeHit in mod.class.Actor.lua
	getFeedbackGain = function(self, t)
		if self:getTalentLevel(t) <= 0 then return 0 end
		return self:combatTalentScale(t, 0.15, 0.5, 0.75)
	end,
	getMaxFeedback = function(self, t) return self:getTalentLevelRaw(t) * 10 end,
	on_learn = function(self, t)
		self:incMaxFeedback(10)
	end,
	on_unlearn = function(self, t)
		self:incMaxFeedback(-10)
	end,
	info = function(self, t)
		local max_feedback = t.getMaxFeedback(self, t)
		local gain = t.getFeedbackGain(self, t)
		local feedbackratio = self:callTalent(self.T_FEEDBACK_POOL, "getFeedbackRatio")
		return ([[增 加 %d 最 大 反 馈 值， 同 时 反 馈 值 的 基 础 获 得 比 率 增 加 %0.1f%%( 相 比 于 你 受 到 伤 害 的 %0.1f%% ) 。 
		 受 精 神 强 度 影 响， 反 馈 值 增 加 率 按 比 例 加 成。]]):format(max_feedback, gain*100, feedbackratio*100)
	end,
}

newTalent{
	name = "Conversion",
	type = {"psionic/feedback", 4},
	points = 5,
	feedback = 25,
	require = psi_wil_req4,
	cooldown = 24,
	no_break_channel = true,
	is_heal = true,
	tactical = { MANA = 2, VIM = 2, EQUILIBRIUM = 2, STAMINA = 2, POSITIVE = 2, NEGATIVE = 2, PSI = 2, HATE = 2 },
	getConversion = function(self, t) return self:combatTalentMindDamage(t, 10, 50) end,
	getData = function(self, t)
		local base = t.getConversion(self, t)
		return {
			heal = base * 10,
			stamina = base,
			mana = base * 1.8,
			equilibrium = -base * 1.5,
			vim = base,
			positive = base / 2,
			negative = base / 2,
			psi = base * 0.7,
			hate = base / 4,
		}
	end,
	action = function(self, t)
		local data = t.getData(self, t)
		for name, v in pairs(data) do
			local inc = "inc"..name:capitalize()
			if name == "heal" then
				self:attr("allow_on_heal", 1)
				self:heal(self:mindCrit(v), t)
				self:attr("allow_on_heal", -1)
			elseif
				self[inc] then self[inc](self, v) 
			end
		end
		game.level.map:particleEmitter(self.x, self.y, 1, "generic_charge", {rm=255, rM=255, gm=180, gM=255, bm=0, bM=0, am=35, aM=90})
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local data = t.getData(self, t)
		return ([[使 用 反 馈 值 来 补 充 自 己。 治 疗 %d 生 命 值 并 回 复 %d 点 耐 力， %d 点 法 力， %d 点 失 衡 值， %d 点 活 力， %d 点 正 负 超 能 力 值， %d 点 超 能 力 值 及 %d 点 仇 恨 值。 
		 受 精 神 强 度 影 响， 增 益 效 果 有 额 外 加 成。]]):format(data.heal, data.stamina, data.mana, -data.equilibrium, data.vim, data.positive, data.psi, data.hate)
	end,
}

