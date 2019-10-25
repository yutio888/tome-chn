local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_ENTROPIC_GIFT",
	name = "熵能天赋",
	info = function(self, t)
		local power = t.getPower(self,t)
		return ([[你作为非自然的存在被现实抗拒。你受到的直接治疗的 25%% 将以熵能反冲的形式伤害自身，无视抗性和护盾，但不会致死。
		你可以主动开启该技能，将你身上的熵转移给附近的一名敌人，除去所有熵能反冲并对其造成持续 4 回合的黑暗和时空伤害，伤害值等于你自身熵能的 %d%% 。
		伤害受法术强度加成。]]):
		format(power)
	end,
}

registerTalentTranslation{
	id = "T_REVERSE_ENTROPY",
	name = "熵能逆转",
	info = function(self, t)

		return ([[你对熵的知识让你可以对抗物理定律，增强你对熵能的承受力。
		你从熵能反冲中受到的伤害减少 %d%% 。
		你可以主动开启该技能，瞬间减少当前的熵。]]):
		format(t.getReduction(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BLACK_HOLE",
	name = "黑洞",
	info = function(self, t)
		local rad = t.getMaxRadius(self,t)
		local dam = t.getDamage(self,t)/2
		local dur = t.getDuration(self,t)
		local bonus = t.getEntropyBonus(self,t)*100
		local entropy = 0
		if self:hasEffect(self.EFF_ENTROPIC_WASTING) then
			local eff = self:hasEffect(self.EFF_ENTROPIC_WASTING)
			local edam = 0
			if eff then edam = (eff.power * eff.dur) * t.getEntropyBonus(self,t) end
			entropy = edam
		end
		return ([[每次释放熵能天赋，会在目标处产生一个持续 %d 回合的一格小型黑洞，每回合半径增加 1 直到 %d 。 
		所有范围内的生物每回合将被拉向黑洞中心并受到 %0.2f 时空伤害以及你当前熵的 %d%% 的伤害。]]):
		format(dur, rad, damDesc(self, DamageType.DARKNESS, dam), damDesc(self, DamageType.TEMPORAL, dam), bonus, entropy)
	end,
}

registerTalentTranslation{
	id = "T_POWER_OVERWHELMING",
	name = "无敌能量",
	info = function(self, t)
		local power = t.getDamageIncrease(self,t)
		local pen = t.getResistPenalty(self,t)
		local dam = t.getDamage(self,t)
		return ([[ 你用危险的熵能大幅强化你的法术，增加 %d%% 黑暗和时空伤害与 %d%% 抗性穿透。
			作为代价，每个非瞬间法术会带来 %0.2f 熵能反冲。]]):
		format(power, pen, dam)
	end,
}

return _M
