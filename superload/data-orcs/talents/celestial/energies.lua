local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CELESTIAL_ACCELERATION",
	name = "天体加速",
	info = function(self, t)
		local posFactor = t.getPosFactor(self, t)
		local negFactor = t.getNegFactor(self, t)
		local cap = t.getCap(self, t)
		return ([[每 1%% 的正能量增加 %0.2f%% 的移动速度, 每 1%% 的负能量增加 %0.2f%% 施法速度, 在 80%% 时达到最大值, 为 %0.2f%%. 持续能量仍然算向最大值.]]):
		format(posFactor * 100, negFactor * 100, cap * 100)
	end,}

registerTalentTranslation{
	id = "T_POLARIZATION",
	name = "偏振",
	info = function(self, t)
		local regeneration = t.getRegen(self, t)
		local positive_rest = (self:attr("positive_at_rest") or 0)/100*self:getMaxPositive()
		local negative_rest = (self:attr("negative_at_rest") or 0)/100*self:getMaxNegative()
		return ([[无论是你的正能量还是负能量都将用更高百分比的恢复替代正常的休息值 (%d 正能量, %d 负能量). 你的正能量和负能量恢复/ 消退速度增加至 %0.2f.]]):
		format(positive_rest, negative_rest, regeneration)
	end,}

registerTalentTranslation{
	id = "T_MAGNETIC_INVERSION",
	name = "磁反转",
	info = function(self, t)
		return ([[交换当前正和负能量水平, 这个法术是瞬发.]])
	end,}

registerTalentTranslation{
	id = "T_PLASMA_BOLT",
	name = "等离子球",
	info = function(self, t)
		local dam = t.getRawDam(self, t)
		local negpart = t.getNegPart(self, t)
		local radius = self:getTalentRadius(t)
		local slow = 100 * t.getSlow(self, t)
		return ([[发射一道纯粹的能量, 在 %d 范围内造成 %0.2f 的光伤害和 %0.2f 的暗影伤害 , 并减速. 他们的移动速度减少 %d%% 并减少 %d%% 的攻击力、法术和精神攻击. 此能量将协调你当前的正负能量数值.]]):
		format(damDesc(self, DamageType.LIGHT, dam * (1 - negpart)), damDesc(self, DamageType.DARKNESS, dam * negpart), radius, slow * negpart, slow * 0.6 * (1 - negpart))
	end,}
	
	return _M