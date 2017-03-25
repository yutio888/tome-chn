local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_AETHER_BEAM",
	name = "以太螺旋",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[你 凝 聚 以 太 能 量， 释 放 出 一 个 以 太 螺 旋， 对 周 围 目 标 造 成 %0.2f 奥 术 伤 害 并 且 有 25 ％ 几 率 沉 默 目 标。 
		 以 太 螺 旋 每 回 合 也 会 对 中 心 点 造 成 10 ％ 的 伤 害（ 但 是 不 会 沉 默 目 标）。 
		 螺 旋 会 以 难 以 置 信 的 速 度 旋 转。（ 1600 ％ 基 础 速 度） 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.ARCANE, dam))
	end,
}

registerTalentTranslation{
	id = "T_AETHER_BREACH",
	name = "以太裂隙",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[撕 裂 位 面， 暂 时 产 生 通 往 以 太 空 间 的 裂 隙， 在 目 标 区 域 造 成 %d 个 随 机 魔 法 爆 炸。 
		 每 个 爆 炸 在 2 码 范 围 内 造 成 %0.2f 奥 术 伤 害， 并 且 每 回 合 只 能 触 发 一 次 爆 炸。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(t.getNb(self, t), damDesc(self, DamageType.ARCANE, damage))
	end,
}

registerTalentTranslation{
	id = "T_AETHER_AVATAR",
	name = "以太之体",
	info = function(self, t)
		return ([[你 的 身 体 与 以 太 能 量 相 融， 持 续 %d 回 合。 
		 当 此 技 能 激 活 时， 你 只 能 使 用 奥 术 系 或 以 太 系 技 能， 同 时， 2 系 技 能 的 冷 却 时 间 减 为 三 分 之 一 ， 你 的 奥 术 伤 害 增 加 25 ％， 并 且 你 可 以 随 时 开 启 干 扰 护 盾， 你 的 法 力 最 大 值 增 加 33 ％。]]):
		format(t.getNb(self, t))
	end,
}

registerTalentTranslation{
	id = "T_PURE_AETHER",
	name = "以太掌握",
	info = function(self, t)
		local damageinc = t.getDamageIncrease(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		return ([[纯 净 的 以 太 能 量 环 绕 着 你， 增 加 %0.1f%% 奥 术 伤 害 并 且 无 视 目 标 %d%% 奥 术 抵 抗。 
		 在 等 级 5 时， 允 许 你 在 以 太 之 体 的 形 态 下 使 用 防 护 系 技 能。]])
		:format(damageinc, ressistpen)
	end,
}


return _M
