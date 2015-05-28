local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_PSYCHOMETRY",
	name = "共鸣之心",
	info = function(self, t)
		local max = t.getPsychometryCap(self, t)
		return ([[与 你 装 备 着 的 超 能 力、 自 然 和 反 魔 超 能 力 值 所 制 造 的 物 品 产 生 共 鸣， 增 加 你 %0.2f 点 或 %d%% 物 品 材 质 等 级 数 值（ 取 较 小 值） 的 物 理 和 精 神 强 度。 
		 此 效 果 可 以 叠 加， 并 且 适 用 于 所 有 符 合 条 件 的 已 穿 戴 装 备。]]):format(max, 100*t.getMaterialMult(self,t))
	end,
}

registerTalentTranslation{
	id = "T_MENTAL_SHIELDING",
	name = "精神屏障",
	info = function(self, t)
		local count = t.getRemoveCount(self, t)
		return ([[净 化 你 当 前 所 有 的 精 神 状 态， 并 在 接 下 来 的 6 回 合 内 免 疫 新 增 的 精 神 状 态。 最 多 一 共（ 净 化 和 免 疫） 能 影 响 %d 种 精 神 状 态。 
		 此 技 能 使 用 时 不 消 耗 回 合。]]):format(count)
	end,
}

registerTalentTranslation{
	id = "T_PROJECTION",
	name = "灵魂出窍",
	info = function(self, t)
		local power = t.getPower(self, t)
		local duration = t.getDuration(self, t)
		return ([[激 活 此 技 能 可 以 使 你 的 灵 魂 出 窍， 持 续 %d 回 合。 在 此 效 果 下， 你 处 于 隐 形 状 态（ +%d 强 度）， 并 且 可 以 看 到 隐 形 和 潜 行 单 位（ +%d 侦 查 强 度）， 还 可 以 穿 过 墙 体， 并 且 无 需 呼 吸。 
		 你 受 到 的 所 有 伤 害 都 会 与 身 体 共 享， 当 你 处 于 此 形 态 下 你 只 能 对 “ 鬼 魂 ” 类 怪 物 造 成 伤 害， 或 者 通 过 激 活 一 种 精 神 通 道 来 造 成 伤 害。 
		 注： 后 一 种 情 况 下 只 能 造 成 精 神 伤 害。 
		 要 回 到 你 的 身 体 里， 只 需 释 放 灵 魂 体 的 控 制 即 可。]]):format(duration, power/2, power)
	end,
}

registerTalentTranslation{
	id = "T_MIND_LINK",
	name = "精神通道",
	info = function(self, t)
		local damage = t.getBonusDamage(self, t)
		local range = self:getTalentRange(t) * 2
		return ([[用 精 神 通 道 连 接 目 标。 当 精 神 通 道 连 接 时， 你 对 其 造 成 的 精 神 伤 害 增 加 %d%% ， 同 时 你 可 以 感 知 与 目 标 同 种 类 型 的 单 位。 
		 在 同 一 时 间 内 只 能 激 活 一 条 精 神 通 道， 当 目 标 死 亡 或 超 出 范 围（ %d 码） 时， 通 道 中 断。 
		 受 精 神 强 度 影 响， 精 神 伤 害 按 比 例 加 成。]]):format(damage, range)
	end,
}


return _M
