local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_MIND_WHIP",
	name = "心 灵 鞭 打",
	info = function (self,t)
		return ([[对 一 个 生 物 释 放 你 的 灵 能 怒 气 造 成 %0.2f 精 神 伤 害 。
		鞭 子 可 同 时 对 目 标 身 边 的 一 个 敌 人 造 成 伤 害 。
		如 果 你 没 有 双 持 灵 晶 ，但 是 在 副 手 栏 里 装 备 了 ，你 会 立 刻 自 动 切 换 。此 技 能 与 心 灵 利 刃 不 兼 容 。]]):
		format(damDesc(self, DamageType.MIND, t.getDam(self, t)))
	end,
}
registerTalentTranslation{
	id = "T_PSYCHIC_WIPE",
	name = "精 神 鞭 打",
	info = function (self,t)
		return ([[你 在 目 标 脑 中 投 射 空 灵 的 手 指 。
		持 续 %d 回 合 总 共 造 成 %0.2f 精 神 伤 害 并 减 少  %d 精 神 豁 免 。
		这 个 强 大 的 效 果 尝 试 使 用 130%% 你 的 精 神 强 度 去 对 抗 目 标 的 精 神 豁 免 。
		如 果 你 没 有 双 持 灵 晶 ，但 是 在 副 手 栏 里 装 备 了 ，你 会 立 刻 自 动 切 换 。此 技 能 与 心 灵 利 刃 不 兼 容 。]]):
		format(t.getDur(self,t), damDesc(self, DamageType.MIND, t.getDam(self, t)), t.getReduct(self, t))
	end,
}
registerTalentTranslation{
	id = "T_GHASTLY_WAIL",
	name = "恐 怖 嚎 叫",
	info = function (self,t)
		return ([[释 放 你 的 心 灵 力 量 ，把 你 身 边 半 径 %d 内 的 敌 人 击 退 3 格 。
		没 有 通 过 精 神 豁 免 的 生 物 会 眩 晕 %d 回 合 并 受 到 %0.2f 精 神 伤 害 。
		如 果 你 没 有 双 持 灵 晶 ，但 是 在 副 手 栏 里 装 备 了 ，你 会 立 刻 自 动 切 换 。此 技 能 与 心 灵 利 刃 不 兼 容 。]]):
		format(self:getTalentRadius(t), t.getDur(self, t), t.getDam(self, t))
	end,
}
registerTalentTranslation{
	id = "T_FINGER_OF_DEATH",
	name = "死 亡 一 指",
	info = function (self,t)
		return ([[用 手 指 对 受 到 恐 怖 嚎 叫 效 果 影 响 的 敌 人 射 出 一 道 冲 击 波 。
		对 目 标 已 造 成 %d%% 已 损 失 生 命 值 的 精 神 伤 害 。
		对 boss 或 者 更 高 阶 级 的 目 标 伤 害 最 高 为 %d.
		如 果 目 标 从 死 亡 ，并 且 是 你 经 可 以 占 有 类 型 ，则 直 接 吸 收 到 你 的 身 体 储 备 中 。
		如 果 你 没 有 双 持 灵 晶 ，但 是 在 副 手 栏 里 装 备 了 ，你 会 立 刻 自 动 切 换 。此 技 能 与 心 灵 利 刃 不 兼 容 。]]):
		format(t.getDam(self, t), t.getBossMax(self, t))
	end,
}
return _M