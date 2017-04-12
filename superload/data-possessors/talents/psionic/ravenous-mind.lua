local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_SADIST",
	name = "虐 待 狂",
	info = function (self,t)
		return ([[你 从 视 野 内 所 有 敌 人 的 痛 苦 中 得 到 养 分 。每 一 个 生 命 值 低 于 80%% 的 敌 人 将 让 你 获 得 一 层 虐 待 狂 效 果 ，每 层 增 加 你 的 原 始 精 神 强 度 %d.
		]]):
		format(t.getPower(self, t))
	end,
}
registerTalentTranslation{
	id = "T_CHANNEL_PAIN",
	name = "痛 苦 连 接",
	info = function (self,t)
		return ([[当 你 至 少 有 一 层 虐 待 狂 效 果 时 ，每 当 你 受 到 伤 害 你 使 用 虐 待 狂 效 果 减 免 伤 害 ，最 终 受 到 的 伤 害 为 受 到 伤 害 除 以 虐 待 狂 效 果 层 数。
		计 算 时 层 数 + 1 ，每 层 效 果 消 耗 %d 灵 能 值 。
		每 次 生 效 时 ，视 野 内 随 机 一 个 生 命 值 低 于 80%% 的 敌 人 ，会 受 到 伤 害 反 弹 ，伤 害 为 所 吸 收 伤 害 的 %d%% 的 精 神 伤 害。
		该 效 果 每 回 合 一 次 ，且 只 会 在 伤 害 超 过 你 10%% 最 大 生 命 值 时 才 触 发 。]]):
		format(t.getPsi(self, t), t.getBacklash(self, t))
	end,
}
registerTalentTranslation{
	id = "T_RADIATE_AGONY",
	name = "痛 苦 辐 射",
	info = function (self,t)
		return ([[当 你 至 少 有 一 层 虐 待 狂 效 果 时 ，你 可 以 分 享 你 的 痛 苦 给 半 径 %d 所 有 可 见 的 生 命 值 少 于 80%% 的 敌 人 。
		持 续 5 回 合 ，他 们 的 头 脑 将 如 此 专 注 于 自 己 的 痛 苦 ，对 你 的 伤 害 减 少 %d%%]]):
		format(self:getTalentRadius(t), t.getProtection(self, t))
	end,
}
registerTalentTranslation{
	id = "T_TORTURE_MIND",
	name = "精 神 拷 打",
	info = function (self,t)
		return ([[当 你 至 少 有 一 层 虐 待 狂 效 果 时 ，你 可 以 精 神 鞭 打 一 个 目 标 ，发 送 恐 怖 的 图 像 到 目 标 的 脑 海 中 。
		目 标 因 效 果 趔 趄 %d 回 合 ， 随 机 %d 个 技 能 在 持 续 时 间 内 无 法 使 用 。]]):
		format(t.getDur(self, t), t.getNb(self, t))
	end,
}
return _M