local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SOLIPSISM",
	name = "唯我论",
	info = function(self, t)
		local conversion_ratio = t.getConversionRatio(self, t)
		local psi_damage_resist, psi_damage_resist_base, psi_damage_resist_talent = t.getPsiDamageResist(self, t)
		local threshold = math.min((self.solipsism_threshold or 0),self:callTalent(self.T_CLARITY, "getClarityThreshold") or 1)
		return ([[你相信你的心灵是世间万物的中心。 
		每级永久性增加你 5 点超能力值，并减少你 50 ％的生命成长（影响升级时的生命增益，但只在学习此技能时永久影响一次）
		同时你学会用心灵来承受伤害，转化 %d%% 生命削减为超能力值削减，并且 %d%% 的治疗值和回复值会转化为超能力值的增长。 
		转化成的超能力值削减将进一步被减少 %0.1f%% （ %0.1f%% 来自于人物等级， %0.1f%% 来自于技能等级。） 
		学习此技能时，（高于基础值 10 的）每点意志会额外增加 0.5 点超能力值上限，而（高于基础值 10 的）每点体质会减少 0.25 点生命上限（若低于基础值 10 则增加生命上限）。 
		学习此技能时，你的唯我临界点会增加 20 ％（当前 %d%% ），你的超能力值每低于这个临界点 1 ％，你的所有速度减少 1 ％。]]):format(conversion_ratio * 100, conversion_ratio * 100, psi_damage_resist, psi_damage_resist_base * 100, psi_damage_resist_talent, (self.solipsism_threshold or 0) * 100)
	end,
}

registerTalentTranslation{
	id = "T_BALANCE",
	name = "唯我论：均衡",
	info = function(self, t)
		local ratio = t.getBalanceRatio(self, t) * 100
		return ([[你现在使用 %d%% 精神豁免值来替代 %d%% 物理和法术豁免（即 100 ％时精神豁免完全替代所有豁免）。 
		学习此技能时，（高于基础值 10 的）每点意志会额外增加 0.5 点超能力值上限，而（高于基础值 10 的）每点体质会减少 0.25 点生命上限（若低于基础值 10 则增加生命上限）。 
		学习此技能也会增加你 10 ％唯我临界点（当前 %d%% ）。]]):format(ratio, ratio, math.min((self.solipsism_threshold or 0),self.clarity_threshold or 1) * 100)
	end,
}

registerTalentTranslation{
	id = "T_CLARITY",
	name = "唯我论：明晰",
	info = function(self, t)
		local threshold = t.getClarityThreshold(self, t)
		local bonus = ""
		if not self.max_level or self.max_level > 50 then
			bonus = " 进一步提升这一技能可以降低你的唯我论阈值。"
		end
		return ([[当你的超能力值超过 %d%% 时，每超过 1 ％你增加 1 ％整体速度（最大值 %+d%% ）。 
		学习此技能时，（高于基础值 10 的）每点意志会额外增加 0.5 点超能力值上限，而（高于基础值 10 的）每点体质会减少 0.25 点生命上限（若低于基础值 10 则增加生命上限），增加你 10 ％唯我临界点（当前 %d%% ）。]]):
		format(threshold * 100, (1-threshold)*100, math.min(self.solipsism_threshold or 0,threshold) * 100)..bonus
	end,
}

registerTalentTranslation{
	id = "T_DISMISSAL",
	name = "唯我论：豁免",
	info = function(self, t)
		local save_percentage = t.getSavePercentage(self, t)
		return ([[每当你受到伤害时，你会使用 %d%% 精神豁免来鉴定。鉴定时精神豁免可能暴击，至少减少 50%% 的伤害。 
		学习此技能时，（高于基础值 10 的）每点意志会额外增加 0.5 点超能力值上限，而（高于基础值 10 的）每点体质会减少 0.25 点生命上限（若低于基础值 10 则增加生命上限）。 
		学习此技能也会增加你 10 ％唯我临界点（当前 %d%% ）。]]):format(save_percentage * 100, math.min(self.solipsism_threshold or 0,self.clarity_threshold or 1) * 100)		
	end,
}


return _M
