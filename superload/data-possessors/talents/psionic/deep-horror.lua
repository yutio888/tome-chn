local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_MIND_STEAL",
	name = "精 神 窃 取",
	info = function (self,t)
		return ([[链 接 目 标 ， 偷 取 目 标 一 个 技 能 。
		持 续 %d 回 合 ，你 获 得 目 标 一 个 随 机 主 动 技 能 (非 被 动 ，非 持 续) ，目 标 会 失 去 该 技 能 。
		你 不 会 偷 取 一 个 已 有 的 技 能 。
		偷 取 的 技 能 不 消 耗 任 何 能 量 。
		在 等 级 5 时 ，可 选 择 偷 取 的 技 能 。
		偷 取 的 技 能 等 级 被 限 制 成 最 高 为 %d 级 。]]):
		format(t.getDuration(self, t), t.getMaxTalentsLevel(self, t))
	end,
}
registerTalentTranslation{
	id = "T_SPECTRAL_DASH",
	name = "光 谱 冲 锋",
	info = function (self,t)
		return ([[短 暂 的 一 瞬 间 ，你 的 整 个 身 体 变 得 飘 渺 ，你 对 附 近 一 个 生 物 进 行 一 次 直 线 冲 锋 (范 围 %d)。
		你 再 次 出 现 在 另 一 边 ，获 得 %d 灵 能 值 并 对 目 标 造 成 %0.2f 精 神 伤 害 。
		]]):
		format(t.getRange(self,t), t.getPsi(self, t), damDesc(self, DamageType.MIND, t.getDam(self, t)))
	end,
}
registerTalentTranslation{
	id = "T_WRITHING_PSIONIC_MASS",
	name = "扭 曲 装 甲",
	info = function (self,t)
		return ([[你 的 身 体 形 态 只 不 过 是 你 心 灵 的 延 伸 ，你 可 以 随 意 扭 曲 它 %d 回 合 。
		效 果 生 效 时 ，你 全 部 抗 性 提 升 %d%% 并 有 %d%% 几 率 避 免 被 暴 击 。
		激 活 时 ，你 最 多 可 以 移 除 %d 个 物 理 或 者 精 神 效 果 。
		]]):
		format(t.getDur(self, t), t.getResist(self, t), t.getCrit(self, t), t.getNbEffects(self, t))
	end,
}
registerTalentTranslation{
	id = "T_OMINOUS_FORM",
	name = "不 详 躯 体",
	info = function (self,t)
		return ([[你 的 灵 能 力 量 没 有 限 制 。你 现 在 能 够 攻 击 一 个 目 标 ，克 隆 它 的 身 体 ，且 不 需 要 杀 死 它 。
		身 体 只 是 暂 时 的 ，持 续 %d 回 合 并 受 到 你 正 常 力 量 的 限 制 。
		该 身 体 的 生 命 值 与 你 目 标 的 生 命 值 绑 定 在 一 起 。(你 的 血 量 百 分 比 和 目 标 的 血 量 百 分 比 相 同)
		]]):
		format(t.getDur(self, t))
	end,
}
return _M