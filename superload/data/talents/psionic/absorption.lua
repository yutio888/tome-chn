local _M = loadPrevious(...)

local function getShieldStrength(self, t)
	--return math.max(0, self:combatMindpower())
	return self:combatTalentMindDamage(t, 20, 100)
end

local function getEfficiency(self, t)
	return self:combatTalentLimit(t, 100, 20, 55)/100 -- Limit to <100%
end

local function maxPsiAbsorb(self, t) -- Max psi/turn to prevent runaway psi gains (solipsist randbosses)
	return 2 + self:combatTalentScale(t, 0.3, 1)
end

local function shieldMastery(self, t)
	return 100-self:combatTalentMindDamage(t, 40, 50)
end

registerTalentTranslation{
	id = "T_KINETIC_SHIELD",
	name = "动能护盾",
	info = function(self, t)
		local s_str = getShieldStrength(self, t)
		local absorb = 100*getEfficiency(self,t)
		return ([[用护盾环绕自己，吸收  %d%%  物理、酸性、自然、时空伤害，每次最多吸收 %d 伤害。
		每次你的护盾吸收伤害时，将部分伤害转化为能量，获得两点超能力值，每吸收 %0.1f 点伤害额外增加一点超能力值，每回合最多增加 %0.1f 点超能力值。
		等级 3 时，当你关掉护盾，前 3 回合内吸收的全部伤害值的两倍将被释放成为一个完整的超能力护盾（吸收完整伤害）
		护盾的吸收值和获得超能力值的效率随精神强度增强。]]):
		format(absorb, s_str, shieldMastery(self, t), maxPsiAbsorb(self,t))
	end,
}

registerTalentTranslation{
	id = "T_THERMAL_SHIELD",
	name = "热能护盾",
	info = function(self, t)
		local s_str = getShieldStrength(self, t)
		local absorb = 100*getEfficiency(self,t)
		return ([[用护盾环绕自己，吸收  %d%%  火焰、寒冷、光系、奥术伤害，每次最多吸收 %d 伤害。
		每次你的护盾吸收伤害时，将部分伤害转化为能量，获得两点超能力值，每吸收 %0.1f 点伤害额外增加一点超能力值，每回合最多增加 %0.1f 点超能力值。
		等级 3 时，当你关掉护盾，前 3 回合内吸收的全部伤害值的两倍将被释放成为一个完整的超能力护盾（吸收完整伤害）
		护盾的吸收值和获得超能力值的效率随精神强度增强。]]):
		format(absorb, s_str, shieldMastery(self, t), maxPsiAbsorb(self,t))
	end,
}

registerTalentTranslation{
	id = "T_CHARGED_SHIELD",
	name = "电能护盾",
	info = function(self, t)
		local s_str = getShieldStrength(self, t)
		local absorb = 100*getEfficiency(self,t)
		return ([[用护盾环绕自己，吸收  %d%%  闪电、枯萎、暗影、精神伤害  , 每次最多吸收 %d 伤害。
每次你的护盾吸收伤害，将其部分转化为能量，获得两点能量，每吸收 %0.1f 点伤害额外增加一点能量，每回合最多增加 %0.1f 点能量。
等级 3 时，当你关掉护盾，前 3 回合内吸收的全部伤害两倍将被释放成为一个完整的超能力护盾（吸收完整伤害）
护盾的吸收值和获得能量的效率随精神强度增强 .]]):
		format(absorb, s_str, shieldMastery(self, t), maxPsiAbsorb(self,t))
	end,
}

registerTalentTranslation{
	id = "T_FORCEFIELD",
	name = "超能力场",
	info = function(self, t)
		local drain = t.getDrain(self, t)
		return ([[用力场环绕自己，减少受到的所有伤害 %d%%
		维持这样的护盾代价非常昂贵，开启的第一回合会消耗你 5%%的超能力值，之后每维持一回合就会多消耗 5%%的超能力值。例如，第二回合会消耗 10%%的超能力值。
		目前的超能力值消耗：每回合 %0.1f 超能力值 ]]):
		format(t.getResist(self,t), drain)
	end,
}


return _M
