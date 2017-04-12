local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_PSYCHIC_CRUSH",
	name = "精 神 粉 碎",
	info = function (self,t)
		return ([[用 双 手 武 器 攻 击 敌 人 造 成 %d%% 武 器 精 神 伤 害 。
		如 果 命 中 且 目 标 没 有 通 过 精 神 豁 免 有 %d%% 几 率 剥 夺 目 标 的 心 灵 印 记 。
		它 会 出 现 在 附 近 ，并 为 你 服 务 %d 回合 。
		如 果 你 没 有 装 备 双 手 武 器 ，但 是 在 副 手 栏 里 装 备 了 ，你 会 立 刻 自 动 切 换 。]]):
		format(t.getDam(self, t) * 100, t.getChance(self, t), t.getDuration(self,t))
	end,
}
registerTalentTranslation{
	id = "T_FORCE_SHIELD",
	name = "力 场 盾",
	info = function (self,t)
		return ([[你 通 过 你 的 武 器 创 造 力 场 盾 ，每 次 受 到 伤 害 时 ，伤 害 不 会 超 过 最 大 生 命 值 %d%% 并 有 %d%% 回 避 攻 击 。
		此 外 ，每 次 受 到 近 战 攻 击 时 ，攻 击 者 会 受 到 %d%% 武 器 精 神 伤 害 的 反 击 ，(每 回 合 一 次)
		如 果 你 没 有 装 备 双 手 武 器 ，但 是 在 副 手 栏 里 装 备 了 ，你 会 立 刻 自 动 切 换 。]]):
		format(t.getMaxDamage(self, t), t.getEvasion(self, t), t.getDam(self, t) * 100)
	end,
}
registerTalentTranslation{
	id = "T_UNLEASHED_MIND",
	name = "心 灵 释 放",
	info = function (self,t)
		return ([[你 将 强 大 的 灵 能 力 集 中 在 你 的 武 器 上 ，并 简 单 地 释 放 你 的 愤 怒 。	
		半 径 %d 内 的 敌 人 受 到 近 战 攻 击 造 成 %d%% 武 器 精 神 伤 害 。
		范 围 内 的 所 有 灵 能 克 隆 体 将 延 长 %d 回 合 。
		如 果 你 没 有 装 备 双 手 武 器 ，但 是 在 副 手 栏 里 装 备 了 ，你 会 立 刻 自 动 切 换 。]]):
		format(self:getTalentRadius(t), t.getDam(self, t) * 100, t.getDur(self, t))
	end,
}
registerTalentTranslation{
	id = "T_SEISMIC_MIND",
	name = "心 灵 地 震",
	info = function (self,t)
		return ([[你 在 地 面 上 打 碎 你 的 武 器 ，将 一 个 心 灵 的 冲 击 波 投 射 在 半 径 为 %d 的 圆 锥 上 。
		范 围 内 的 所 有 敌 人 受 到 %d%% 武 器 精 神 伤 害 。
		任 何 被 击 中 的 灵 能 克 隆 体 将 立 即 破  碎 ，在 半 径 1 的 范 围 内 爆 炸 造 成  %0.2f 物 理 伤 害 。
		如 果 你 没 有 装 备 双 手 武 器 ，但 是 在 副 手 栏 里 装 备 了 ，你 会 立 刻 自 动 切 换 。]]):
		format(self:getTalentRadius(t), t.getDam(self, t) * 100, t.getExplosionDam(self, t))
	end,
}
return _M