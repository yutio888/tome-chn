local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_ENTROPIC_GIFT",
	name = "熵能天赋",
	info = function(self, t)
		local power = t.getPower(self,t)
		return ([[你 作 为 非 自 然 的 存 在 被 现 实 抗 拒 。 你 受 到 的 直 接 治 疗 的 25%% 将 以 熵 能 反 冲 的 形 式 伤 害 自 身 ， 无 视 抗 性 和 护 盾 ， 但 不 会 致 死。
		你 可 以 主 动 开 启 该 技 能 ，将 你 身 上 的 熵 转 移 给 附 近 的 一 名 敌 人， 除 去 所 有 熵 能 反 冲 并 对 其 造 成 持 续 4 回 合 的 黑 暗 和 时 空 伤 害， 伤 害 值 等 于 你 自 身 熵 能 的 %d%%。
		伤 害 受 法 术 强 度 加 成 。]]):
		format(power)
	end,
}

registerTalentTranslation{
	id = "T_REVERSE_ENTROPY",
	name = "熵能逆转",
	info = function(self, t)

		return ([[你 对 熵 的 知 识 让 你 可 以 对 抗 物 理 定 律， 增 强 你 对 熵 能 的 承 受 力 。
		你 从 熵 能 反 冲 中 受 到 的 伤 害 减 少 %d%%。
		你 可 以 主 动 开 启 该 技 能 ， 瞬 间 减 少 当 前 的 熵 。]]):
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
		return ([[每 次 释 放 熵 能 天 赋 ， 会 在 目 标 处 产 生 一 个 持 续 %d 回 合 的 一 格 小 型 黑 洞， 每 回 合 半 径 增 加 1 直 到 %d 。 
		所 有 范 围 内 的 生 物 每 回 合 将 被 拉 向 黑 洞 中 心 并 受 到 %0.2f 时 空 伤 害 以 及 你 当 前 熵 的 %d%% 的 伤 害。]]):
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
		return ([[ 你 用 危 险 的 熵 能 大 幅 强 化 你 的 法 术 ，增 加 %d%% 黑 暗 和 时 空 伤 害 与 %d%% 抗 性 穿 透。
			作 为 代 价， 每 个 非 瞬 间 法 术 会 带 来 %0.2f 熵 能 反 冲 。]]):
		format(power, pen, dam)
	end,
}

return _M
