local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_HORRIFYING_BLOWS",
	name = "恐惧打击",
	info = function(self, t)
	return ([[你 的 攻 击 能 够 惊 吓 目 标 ， 降 低 目 标 %d%% 的 伤 害 。 
	此 效 果 可 以 叠 加 %d 次 ， 每 次 攻 击 会 刷 新 持 续 时 间 。 但 是 当 目 标 与 你 距 离 超 过 %d 码 ， 恐 惧 效 果 会 迅 速 消 退。
	技 能 3 级 时 ， 每 次 叠 加 会 同 时 减 少 目 标 %0.2f%% 的 速 度。
	技 能 5 级 时 ， 可 以 影 响 到 %d 码 内 的 所 有 敌 对 生 物。
	此 技 能 无 视 豁 免 和 免 疫 。]])
	:format(t.getDamageReduction(self,t),t.getMaxStacks(self,t),t.getLeashRange(self, t),t.getSlowPower(self,t)*100,self:getTalentRadius(t))
	end,
}


registerTalentTranslation{
	id = "T_MASS_HYSTERIA",
	name = "恐惧之潮",
	info = function(self, t)
	return ([[增 强 目 标 的 恐 惧 ， 目 标 身 上 每 有 一 次 恐 惧 叠 加 ，效 果 增 强 %d%% ， 持 续 时 间 增 大 到 %d 回 合 。 增 强 后 的 恐 惧 效 果 影 响 %d 码 内 所 有 敌 对 生 物。]]):format(t.getPowerBonus(self, t), t.getDurationBonus(self, t), self:getTalentRadius(t))
	end,
}


registerTalentTranslation{
	id = "T_FEARFEAST",
	name = "恐惧盛宴",
	info = function(self, t)
	return ([[汲 取 %d 码 内 敌 对 生 物 身 上 的 恐 惧 ， 每 汲 取 一 层 恐 惧 ， 恢 复 %d 生 命 并 获 得 %0.1f%% 额 外 回 合。
	至 多 能 获 得 %0.1f 个 额 外 回 合。]])
	:format(self:getTalentRadius(t), t.getHeal(self, t), t.getEnergyDrain(self, t)*0.1, t.getEnergyCap(self, t) / 1000)
	end,
}

	
registerTalentTranslation{
	id = "T_HOPE_WANES",
	name = "绝望碾压",
	info = function(self, t)
	return ([[击 溃 已 叠 加 至 少 %d 层 恐 惧 目 标 的 精 神 ，清 除 所 有 恐 惧 效 果 ， 使 目 标 %d 回 合 无 法 行 动 。
	此 技 能 无 视 豁 免 和 免 疫。]]):format(t.getStackReq(self, t), t.getDuration(self, t))
	end,
}


return _M
