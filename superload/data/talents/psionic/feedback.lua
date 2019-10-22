local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_BIOFEEDBACK",
	name = "生物反馈",
	info = function(self, t)
		local heal = t.getHealRatio(self, t)
		local decaySpeed = t.getDecaySpeed(self, t)
		local newDecay = decaySpeed*0.1
		local netHeal = newDecay*heal
		return ([[ 你的反馈值衰减的 %0.1f%% 会治疗你，同时衰减速率下降 %d%% （每回合最多 %0.1f%% ）。总而言之，每回合你将受到治疗量等于你的反馈池 %0.2f%% 的治疗。 
		受精神强度影响，治疗效果按比例加成。]]):format(heal, decaySpeed*100, newDecay*100, netHeal*100)
	end,
}

registerTalentTranslation{
	id = "T_RESONANCE_FIELD",
	name = "共鸣领域",
	info = function(self, t)
		local shield_power = t.getShieldPower(self, t)
		return ([[激活此技能可产生一个吸收 50 ％伤害的共鸣领域（最大吸收值 %d ）。此领域不会干扰反馈值的增长。 
		受精神强度影响，最大吸收值有额外加成。 
		此技能最多维持 10 回合。]]):format(shield_power)
	end,
}

registerTalentTranslation{
	id = "T_AMPLIFICATION",
	name = "强化反馈",
	info = function(self, t)
		local max_feedback = t.getMaxFeedback(self, t)
		local gain = t.getFeedbackGain(self, t)
		local feedbackratio = self:callTalent(self.T_FEEDBACK_POOL, "getFeedbackRatio")
		return ([[增加 %d 最大反馈值，同时反馈值的基础获得比率增加 %0.1f%%( 相比于你受到伤害的 %0.1f%% ) 。 
		受精神强度影响，反馈值增加率按比例加成。]]):format(max_feedback, gain*100, feedbackratio*100)
	end,
}

registerTalentTranslation{
	id = "T_CONVERSION",
	name = "反馈充能",
	info = function(self, t)
		local data = t.getData(self, t)
		return ([[使用反馈值来补充自己。治疗 %d 生命值并回复 %d 点耐力， %d 点法力， %d 点失衡值， %d 点活力， %d 点正负超能力值， %d 点超能力值及 %d 点仇恨值。 
		受精神强度影响，增益效果有额外加成。]]):format(data.heal, data.stamina, data.mana, -data.equilibrium, data.vim, data.positive, data.psi, data.hate)
	end,
}


return _M
