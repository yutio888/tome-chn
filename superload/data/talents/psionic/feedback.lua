local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_BIOFEEDBACK",
	name = "生物反馈",
	info = function(self, t)
		local heal = t.getHealRatio(self, t)
		local decaySpeed = t.getDecaySpeed(self, t)
		local newDecay = decaySpeed*0.1
		local netHeal = newDecay*heal
		return ([[ 你 的 反 馈 值 衰 减 的 %0.1f%% 会 治 疗 你 ， 同 时 衰 减 速 率 下 降 %d%% （ 每 回 合 最 多 %0.1f%% ） 。 总 而 言 之， 每 回 合 你 将 受 到 治 疗 量 等 于 你 的 反 馈 池 %0.2f%% 的 治 疗。 
		受 精 神 强 度 影 响， 治 疗 效 果 按 比 例 加 成。]]):format(heal, decaySpeed*100, newDecay*100, netHeal*100)
	end,
}

registerTalentTranslation{
	id = "T_RESONANCE_FIELD",
	name = "共鸣领域",
	info = function(self, t)
		local shield_power = t.getShieldPower(self, t)
		return ([[激 活 此 技 能 可 产 生 一 个 吸 收 50 ％ 伤 害 的 共 鸣 领 域（ 最 大 吸 收 值 %d ）。 此 领 域 不 会 干 扰 反 馈 值 的 增 长。 
		 受 精 神 强 度 影 响， 最 大 吸 收 值 有 额 外 加 成。 
		 此 技 能 最 多 维 持 10 回 合。]]):format(shield_power)
	end,
}

registerTalentTranslation{
	id = "T_AMPLIFICATION",
	name = "强化反馈",
	info = function(self, t)
		local max_feedback = t.getMaxFeedback(self, t)
		local gain = t.getFeedbackGain(self, t)
		local feedbackratio = self:callTalent(self.T_FEEDBACK_POOL, "getFeedbackRatio")
		return ([[增 加 %d 最 大 反 馈 值， 同 时 反 馈 值 的 基 础 获 得 比 率 增 加 %0.1f%%( 相 比 于 你 受 到 伤 害 的 %0.1f%% ) 。 
		 受 精 神 强 度 影 响， 反 馈 值 增 加 率 按 比 例 加 成。]]):format(max_feedback, gain*100, feedbackratio*100)
	end,
}

registerTalentTranslation{
	id = "T_CONVERSION",
	name = "反馈充能",
	info = function(self, t)
		local data = t.getData(self, t)
		return ([[使 用 反 馈 值 来 补 充 自 己。 治 疗 %d 生 命 值 并 回 复 %d 点 耐 力， %d 点 法 力， %d 点 失 衡 值， %d 点 活 力， %d 点 正 负 超 能 力 值， %d 点 超 能 力 值 及 %d 点 仇 恨 值。 
		 受 精 神 强 度 影 响， 增 益 效 果 有 额 外 加 成。]]):format(data.heal, data.stamina, data.mana, -data.equilibrium, data.vim, data.positive, data.psi, data.hate)
	end,
}


return _M
