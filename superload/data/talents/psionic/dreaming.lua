local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SLEEP",
	name = "入梦",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		local power = t.getSleepPower(self, t)
		local insomnia = t.getInsomniaPower(self, t)
		return([[使 %d 码 半 径 范 围 内 的 目 标 陷 入 %d 回 合 的 睡 眠 状 态 中， 使 它 们 无 法 行 动。 它 们 每 承 受 %d 点 伤 害， 睡 眠 的 持 续 时 间 减 少 一 回 合。 
		 当 睡 眠 结 束 时， 目 标 会 饱 受 失 眠 的 痛 苦， 持 续 回 合 等 于 已 睡 眠 的 回 合 数（ 但 最 多 10 回 合）， 失 眠 状 态 的 每 一 个 剩 余 回 合 数 会 让 目 标 获 得 %d%% 睡 眠 免 疫。 
		 在 等 级 5 时， 睡 眠 会 具 有 传 染 性， 每 回 合 有 25 ％ 几 率 传 播 向 附 近 的 目 标。 
		 受 精 神 强 度 影 响， 伤 害 临 界 点 按 比 例 加 成。]]):format(radius, duration, power, insomnia)
	end,
}

registerTalentTranslation{
	id = "T_LUCID_DREAMER",
	name = "清晰梦境",
	info = function(self, t)
		local power = t.getPower(self, t)
		return ([[你 进 入 清 晰 梦 境。 在 此 状 态 下， 你 虽 然 处 于 睡 眠 状 态 但 仍 可 以 行 动， 并 且 对 失 眠 免 疫， 对 失 眠 状 态 下 的 目 标 附 加 %d%% 伤 害， 同 时， 你 的 物 理、 法 术 和 精 神 豁 免 增 加 %d 点。 
		 注 意 在 睡 眠 状 态 下 会 使 你 降 低 对 特 定 负 面 状 态 的 抵 抗（ 例 如 心 魔， 暗 夜 恐 惧 和 梦 靥 行 者）。 
		 受 精 神 强 度 影 响， 豁 免 增 益 效 果 按 比 例 加 成。]]):format(power, power)
	end,
}

registerTalentTranslation{
	id = "T_DREAM_WALK",
	name = "梦境穿梭",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[你 穿 越 梦 境， 出 现 在 某 个 目 标 地 点 附 近 （ %d 码 传 送 误 差）。
		 如 果 目 标 为 处 于 睡 眠 状 态 的 生 物， 你 将 会 出 现 在 离 目 标 最 近 的 地 方。]]):format(radius)
	end,
}

registerTalentTranslation{
	id = "T_DREAM_PRISON",
	name = "梦境牢笼",
	info = function(self, t)
		local drain = t.getDrain(self, t)
		return ([[将 范 围 内 所 有 睡 眠 状 态 的 目 标 囚 禁 在 梦 境 牢 笼 里， 有 效 地 延 长 他 们 的 睡 眠 效 果， 这 个 强 大 的 技 能 每 回 合 会 持 续 消 耗 %d 点 超 能 力 值， 并 且 运 用 了 灵 能 通 道， 所 以 当 你 移 动 时 会 中 断 此 技 能。 
		 注 意： 每 回 合 可 产 生 的 睡 眠 附 加 状 态， 如 梦 靥 的 伤 害 和 入 梦 的 传 染 效 果， 将 在 此 效 果 持 续 过 程 中 失 效。]]):format(drain)
	end,
}


return _M
