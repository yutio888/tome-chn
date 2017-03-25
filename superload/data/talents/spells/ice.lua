local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ICE_SHARDS",
	name = "寒冰箭",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[向 指 定 地 点 的 目 标 射 出 寒 冰 箭。 每 根 寒 冰 箭 %s 并 造 成 %0.2f 冰 系 伤 害， 对 目 标 附 近 单 位 同 样 造 成 伤 害。 
		 此 法 术 不 会 伤 害 施 法 者。 
		 如 果 目 标 处 于 湿 润 状 态 ， 伤 害 增 加 30%% ， 同 时 冰 冻 率 上 升 至 50%% 。
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(necroEssenceDead(self, true) and " 影 响 路 径 上 所 有 敌 人 " or "缓 慢 移 动", damDesc(self, DamageType.COLD, damage))
	end,
}

registerTalentTranslation{
	id = "T_FROZEN_GROUND",
	name = "冻结大地",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[制 造 一 股 冷 空 气 围 绕 着 你， 在 %d 码 半 径 范 围 内 对 目 标 造 成 %0.2f 冰 冷 伤 害 并 冻 结 它 们 的 双 脚 4 回 合。 
		 被 冻 结 双 脚 的 单 位 可 以 动 作 但 无 法 移 动。 
		 该 技 能 每 击 中 一 个 处 于 湿 润 状 态 的 目 标 ， 将 会 减 少 寒 冰 破 碎 的 技 能 冷 却 时 间 2 回 合 。
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(radius, damDesc(self, DamageType.COLD, damage))
	end,
}

registerTalentTranslation{
	id = "T_SHATTER",
	name = "寒冰破碎",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local targetcount = t.getTargetCount(self, t)
		return ([[打 破 视 线 范 围 内 所 有 已 冻 结 目 标， 造 成 %0.2f 冰 冷 伤 害。 
		 基 于 目 标 品 级， 有 额 外 效 果： 
		* 动 物 类 会 被 立 刻 杀 死 
		* 对 普 通 单 位 增 加 50%% 暴 击 率 
		* 对 精 英 单 位 增 加 25%% 暴 击 率 
		 所 有 受 影 响 单 位 将 进 入 湿 润 状 态。
		 它 最 多 可 影 响 %d 个 敌 方 单 位。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.COLD, damage), targetcount)
	end,
}

registerTalentTranslation{
	id = "T_UTTERCOLD",
	name = "绝对零度",
	info = function(self, t)
		local damageinc = t.getColdDamageIncrease(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		local pierce = t.getPierce(self, t)
		return ([[使 你 周 围 的 温 度 骤 降， 增 加 你 %0.1f%% 冰 系 伤 害 并 无 视 目 标 %d%% 冰 冷 抵 抗。 
		 同 时， 你 的 破 冰 动 作 变 的 更 加 容 易， 减 少 %d%% 冰 层 对 你 的 攻 击 伤 害 格 挡 值。]])
		:format(damageinc, ressistpen, pierce)
	end,
}


return _M
