local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CELESTIAL_ACCELERATION",
	name = "天体加速",
	info = function(self, t)
		local posFactor = t.getPosFactor(self, t)
		local negFactor = t.getNegFactor(self, t)
		local cap = t.getCap(self, t)
		return ([[每 1%% 的 正 能 量 增 加 %0.2f%% 的 移 动 速 度, 每 1%% 的 负 能 量 增 加 %0.2f%% 施 法 速 度, 在 80%% 时 达 到 最 大 值, 为  %0.2f%%. 持 续 能 量 仍 然 算 向 最 大 值.]]):
		format(posFactor * 100, negFactor * 100, cap * 100)
	end,}

registerTalentTranslation{
	id = "T_POLARIZATION",
	name = "偏振",
	info = function(self, t)
		local regeneration = t.getRegen(self, t)
		local positive_rest = (self:attr("positive_at_rest") or 0)/100*self:getMaxPositive()
		local negative_rest = (self:attr("negative_at_rest") or 0)/100*self:getMaxNegative()
		return ([[无 论 是 你 的 正 能 量 还 是 负 能 量 都 将 用 更 高 百 分 比 的 恢 复 替 代 正 常 的 休 息 值 (%d 正 能 量, %d 负 能 量). 你 的 正 能 量 和 负 能 量 恢 复/ 消 退 速 度 增 加 至 %0.2f.]]):
		format(positive_rest, negative_rest, regeneration)
	end,}

registerTalentTranslation{
	id = "T_MAGNETIC_INVERSION",
	name = "磁反转",
	info = function(self, t)
		return ([[交 换 当 前 正 和 负 能 量 水 平, 这 个 法 术 是 瞬 发.]])
	end,}

registerTalentTranslation{
	id = "T_PLASMA_BOLT",
	name = "等离子球",
	info = function(self, t)
		local dam = t.getRawDam(self, t)
		local negpart = t.getNegPart(self, t)
		local radius = self:getTalentRadius(t)
		local slow = 100 * t.getSlow(self, t)
		return ([[发 射 一 道 纯 粹 的 能 量, 在 %d 范 围 内 造 成  %0.2f 的 光 伤 害 和 %0.2f 的 暗 影 伤 害 , 并 减 速. 他 们 的 移 动 速 度 减 少 %d%% 并 减 少 %d%% 的 攻 击 力、 法 术 和 精 神 攻 击. 此 能 量 将 协 调 你 当 前 的 正 负 能 量 数 值.]]):
		format(damDesc(self, DamageType.LIGHT, dam * (1 - negpart)), damDesc(self, DamageType.DARKNESS, dam * negpart), radius, slow * negpart, slow * 0.6 * (1 - negpart))
	end,}
	
	return _M