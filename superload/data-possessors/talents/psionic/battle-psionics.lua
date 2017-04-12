local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_PSIONIC_DISRUPTION",
	name = "灵 能 瓦 解",
	info = function (self,t)
		return ([[向 副 手 灵 晶 灌 注 狂 暴 的 灵 能 力 量 。
		生 效 时 ，灵 晶 的 精 神 强 度 和 精 神 暴 击 几 率 增 加 %d%% 。
		每 次 攻 击 ，都 会 给 目 标 附 加 1 层 灵 能 瓦 解 效 果 。
		每 层 效 果 持 续 %d 回 合 造 成 %0.2f 精神伤害 (最 多 %d 层).
		如 果 你 没 有 装 备 单 手 武 器 和 灵 晶 ，但 是 在 副 手 栏 里 装 备 了 ，你 会 立 刻 自 动 切 换 。 此 技 能 与 心 灵 利 刃 不 兼 容 。]]):
		format(t.getBuff(self, t), t.getDur(self, t), damDesc(self, DamageType.MIND, t.getDam(self, t)), t.getStacks(self, t))
	end,
}
registerTalentTranslation{
	id = "T_SHOCKSTAR",
	name = "震 撼 之 星",
	info = function (self,t)
		return ([[用 主 手 武 器 造 成 %d%% 武 器 伤 害 。
		如 果 命 中 目 标 立 刻 用 灵 晶 攻 击 目 标 造 成 %d%% 伤 害 。
		震 慑 目 标 %d 回 合 且 半 径 %d 范 围 内 的 生 物 眩 晕 同 样 的 回 合。
		灵 能 瓦 解 层 数 决 定 震 慑 和 眩 晕 的 持 续 时 间 ，已 给 出 的 数 据 是 灵 能 瓦 解 4 层 的 情 况 下 。
		如 果 你 没 有 装 备 单 手 武 器 和 灵 晶 ，但 是 在 副 手 栏 里 装 备 了 ，你 会 立 刻 自 动 切 换 。 此 技 能 与 心 灵 利 刃 不 兼 容 。]]):
		format(t.getMDam(self, t)*100, t.getODam(self, t)*100, t.getDur(self, t), t.getRadius(self, t))
	end,
}
registerTalentTranslation{
	id = "T_DAZZLING_LIGHTS",
	name = "炫 目 之 光",
	info = function (self,t)
		return ([[举 起 灵 晶 ，致 盲 半 径 %d 内 的 生 物 %d 回 合 。
		在 近 战 范 围 内 的 敌 人 被 此 效 果 致 盲 ，立 刻 用 主 手 武 器 造 成 %d%% 伤 害 。
		如 果 你 没 有 装 备 单 手 武 器 和 灵 晶 ，但 是 在 副 手 栏 里 装 备 了 ，你 会 立 刻 自 动 切 换 。 此 技 能 与 心 灵 利 刃 不 兼 容 。]]):
		format(self:getTalentRadius(t), t.getDur(self, t), t.getDam(self, t) * 100)
	end,
}
registerTalentTranslation{
	id = "T_PSIONIC_BLOCK",
	name = "灵 能 格 挡",
	info = function (self,t)
		return ([[创 造 一 个 持 续 5 回 合 的 灵 能 盾 牌 围 绕 你 。
		技 能 生 效 时 有 %d%% 几 率 会 无 视 伤 害 。
		如 果 伤 害 被 无 视 ，你 会 对 目 标 进 行 反 击 ，造 成 %0.2f 精 神 伤 害 。(每 回 合 最 多 2 次 )
		]]):
		format(t.getChance(self, t), damDesc(self, DamageType.MIND, t.getDam(self, t)))
	end,
}
return _M