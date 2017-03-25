local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_PRECOGNITION",
	name = "预知未来",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local duration = t.getDuration(self, t)
		return ([[你 预 知 未 来 ，感 知 半 径  %d  以 内 的 生 物 和 陷 阱 ，持 续  %d  回 合 。
		 如 果 你 学 会 了 深 谋 远 虑 ，那 么 在 你 激 活 这 个 技 能 的 时 候 ，你 可 以 获 得 额 外 的 闪 避 和 暴 击 减 免 （数 值 等 于 深 谋 远 虑 的 奖 励 ）。]]):format(range, duration)
	end,
}

registerTalentTranslation{
	id = "T_FORESIGHT",
	name = "深谋远虑",
	info = function(self, t)
		local defense = t.getDefense(self, t)
		local crits = t.getCritDefense(self, t)
		return ([[获 得  %d  闪 避   和  %d%%  暴 击 减 免 。
		 如 果 你 激 活 了 预 知 未 来 或 者 命 运 歧 路 ，那 么 这 些 技 能 也 会 拥 有 同 样 的 加 成 ，使 你 获 得 额 外 的 闪 避 和 暴 击 减 免 。		 
		 受 魔 法 影 响 ，增 益 效 果 有 额 外 加 成 。]]):
		format(defense, crits)
	end,
}

registerTalentTranslation{
	id = "T_CONTINGENCY",
	name = "意外术",
	info = function(self, t)
		local trigger = t.getTrigger(self, t) * 100
		local cooldown = self:getTalentCooldown(t)
		local talent = self:isTalentActive(t.id) and self:getTalentFromId(self:isTalentActive(t.id).talent).name or "None"
		return ([[选 择 一 个 只 会 影 响 你 并 且 不 需 要 选 中 目 标 的 非 固 定 CD 主 动 法 术 。当 你 受 到 伤 害 并 使 生 命 值 降 低 到  %d%%  以 下 时 ，自 动 释 放 这 个 技 能 。
		 即 使 选 择 的 技 能 处 于 冷 却 状 态 也 可 以 释 放   ，并 且 不 消 耗 回 合 或 资 源 ，技 能 等 级 为 该 技 能 和 指 定 技 能 当 中 较 低 的 一 方 。		 这 个 效 果 每  %d  回 合 只 能 触 发 一 次 ，并 且 在 伤 害 结 算 之 后 生 效 。

		 当 前 选 择 技 能 ： %s ]]):
		format(trigger, cooldown, talent)
	end,
}

registerTalentTranslation{
	id = "T_SEE_THE_THREADS",
	name = "命运螺旋",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 窥 视 三 种 可 能 的 未 来 ，允 许 你 分 别 进 行 探 索  %d  回 合 。当 效 果 结 束 ，你 选 择 三 者 之 一 成 为 你 的 现 在 。
		 如 果 你 学 会 了 深 谋 远 虑 ，当 你 使 用 命 运 螺 旋 时 ，将 获 得 额 外 的 闪 避 和 暴 击 减 免 （数 值 等 于 深 谋 远 虑 的 奖 励 ）。
		 这 个 法 术 会 使 时 间 线 分 裂 。当 此 技 能 激 活 的 时 候 ，使 用 其 他 分 裂 时 间 线 的 技 能 将 会 失 败 。
		 如 果 你 在 任 何 一 条 时 间 线 上 死 亡 ，你 将 使 时 间 线 回 到 你 使 用 技 能 的 地 方 ，并 且 技 能 效 果 结 束 。
		 这 个 技 能 每 个 楼 层 只 能 使 用 一 次 。]])
		:format(duration)
	end,
}

return _M
