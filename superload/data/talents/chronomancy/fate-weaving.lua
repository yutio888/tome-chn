local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SPIN_FATE",
	name = "命运之丝",
	info = function(self, t)
		local save = t.getSaveBonus(self, t)
		return ([[每 当 你 要 受 到 其 他 人 造 成 的 伤 害 时 ， 你 编 织 一 层 命 运 之 丝，使 你 的 闪 避 和 豁 免 增 加 %d ，持 续 三 回 合。
		这 个 效 果 每 回 合 只 能 触 发 一 次 ， 丝 能 叠 加 三 层 ( 加 成 最 多 为 %d ).]]):
		format(save, save * 3)
	end,
}

registerTalentTranslation{
	id = "T_SEAL_FATE",
	name = "命运封印",
	info = function(self, t)
		local procs = t.getProcs(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		return ([[激 活 这 个 技 能 封 印 命 运 %d 回 合。
		在 这 个 技 能 激 活 期 间 ， 每 当 你 对 目 标 造 成 伤 害，你 获 得 一 层 命 运 之 丝 效 果，并 有 %d%% 几 率 延 长 目 标 的 一 个 负 面 效 果 一 回 合 。
		每 层 命 运 之 茧 将 使 负 面 状 态 延 长 的 概 率 增 加 33%%  ( 三 层 效 果 时 增 加 %d%% 。 )
		负 面 状 态 延 长 每 回 合 只 能 触 发  %d 次，该 效 果 获 得 的 命 运 之 丝 每 回 合 最 多 一 层。]]):format(duration, chance, chance * 2, procs)
	end,
}

registerTalentTranslation{
	id = "T_FATEWEAVER",
	name = "命运编织",
	info = function(self, t)
		local power = t.getPowerBonus(self, t)
		return ([[现 在 每 层 命 运 之 网 使 你 获 得 %d 命 中 ， 物 理 、法 术 和 精 神 强 度。]]):
		format(power)
	end,
}

registerTalentTranslation{
	id = "T_WEBS_OF_FATE",
	name = "命运之网",
	info = function(self, t)
		local power = t.getPower(self, t) * 100
		local duration = t.getDuration(self, t)
		return ([[接 下 来 的 %d 回 合 中 ， 你 将 受 到 的 %d%% 伤 害 转 移 给 随 机 的 敌 人。
		当 命 运 之 网 激 活 时 ， 你 每 回 合 可 以 额 外 获 得 一 层 命 运 之 丝，同 时 你 的 命 运 之 丝 上 限 翻 倍。]])
		:format(duration, power)
	end,
}


return _M
