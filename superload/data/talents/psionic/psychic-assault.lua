local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MIND_SEAR",
	name = "心灵光束",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[向 前 方 发 出 一 道 心 灵 光 束， 摧 毁 范 围 内 所 有 目 标 的 神 经 系 统， 造 成 %0.2f 精 神 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.MIND, damage))
	end,
}

registerTalentTranslation{
	id = "T_PSYCHIC_LOBOTOMY",
	name = "精神切断",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local cunning_damage = t.getPower(self, t)/2
		local power = t.getConfuse(self, t)
		local duration = t.getDuration(self, t)
		return ([[造 成 %0.2f 精 神 伤 害， 并 摧 毁 目 标 的 高 级 精 神 系 统， 降 低 %d 灵 巧 并 混 乱 目 标（ %d%% 强 度）， 持 续 %d 回 合。 
		 受 精 神 强 度 影 响， 伤 害、 灵 巧 降 幅 和 混 乱 强 度 按 比 例 加 成。]]):
		format(damDesc(self, DamageType.MIND, (damage)), cunning_damage, power, duration)
	end,
}

registerTalentTranslation{
	id = "T_SYNAPTIC_STATIC",
	name = "心灵爆破",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在 %d 码 半 径 范 围 内 释 放 一 波 心 灵 爆 震， 造 成 %0.2f 精 神 伤 害。 此 技 能 可 以 对 目 标 附 加 锁 脑 效 果。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(radius, damDesc(self, DamageType.MIND, damage))
	end,
}

registerTalentTranslation{
	id = "T_SUNDER_MIND",
	name = "碾碎心灵",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local power = t.getDamage(self, t) / 10
		return ([[摧 毁 目 标 的 思 维， 造 成 %0.2f 精 神 伤 害 并 且 减 少 %d 目 标 的 精 神 豁 免， 持 续 4 回 合。 
		 此 技 能 必 中 且 精 神 豁 免 削 减 效 果 可 叠 加。 
		 若 目 标 处 于 锁 脑 状 态， 则 会 产 生 双 倍 的 伤 害 和 豁 免 削 减。 
		 受 精 神 强 度 影 响， 伤 害 和 豁 免 削 减 按 比 例 加 成。]]):
		format(damDesc(self, DamageType.MIND, (damage)), power)
	end,
}


return _M
