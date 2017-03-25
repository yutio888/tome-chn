local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SLIME_SPIT",
	name = "史莱姆喷射",
	info = function(self, t)
		return ([[向 你 的 目 标 喷 吐 酸 液 造 成 %0.1f 自 然 伤 害 并 减 速 目 标 30%%  3 回 合。 
		 酸 液 球 可 弹 射 到 附 近 的 某 个 敌 方 单 位 %d 次。 
		 弹 射 距 离 最 多 为 6 码 ， 同 时 每 弹 一 次 会 减 少 %0.1f%% 伤 害 。
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.NATURE, self:combatTalentMindDamage(t, 30, 250)), t.getTargetCount(self, t), 100-t.bouncePercent(self, t))
	end,
}

registerTalentTranslation{
	id = "T_POISONOUS_SPORES",
	name = "毒性孢子",
	info = function(self, t)
		return ([[向 %d 码 半 径 范 围 释 放 毒 性 孢 子， 使 范 围 内 的 敌 方 单 位 感 染 随 机 类 型 的 毒 素， 造 成 %0.1f 自 然 伤 害， 持 续 10 回 合。
		这 个 攻 击 能 够 暴 击 ， 造 成 额 外 %d%% 暴 击 伤 害。
		受 精 神 强 度 影 响 ， 伤 害 和 暴 击 加 成 有 额 外 加 成。 ]]):format(self:getTalentRadius(t), damDesc(self, DamageType.NATURE, t.getDamage(self, t)), t.critPower(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ACIDIC_SKIN",
	name = "酸性皮肤",
	info = function(self, t)
		return ([[你 的 皮 肤 浸 泡 着 酸 液， 对 所 有 攻 击 你 的 目 标 造 成 %0.1f 酸 性 缴 械 伤 害。
		 受 精 神 强 度 影 响 ， 伤 害 有 额 外 加 成 。 ]]):format(damDesc(self, DamageType.ACID, t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_SLIME_ROOTS",
	name = "史莱姆触手",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local radius = self:getTalentRadius(t)
		local talents = t.getNbTalents(self, t)
		return ([[你 延 伸 史 莱 姆 触 手 进 入 地 下 ， 然 后 在 %d 码 范 围 内 的 指 定 位 置 出 现（ %d 码 误 差）。
		 释 放 此 技 能 会 导 致 你 的 身 体 结 构 发 生 轻 微 的 改 变， 使 %d 个 技 能 冷 却 完 毕。]]):format(range, radius, talents)
	end,
}


return _M
