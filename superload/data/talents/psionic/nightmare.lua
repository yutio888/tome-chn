local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_NIGHTMARE",
	name = "梦靥",
	info = function(self, t)
		local radius = self:getTalentRange(t)
		local duration = t.getDuration(self, t)
		local power = t.getSleepPower(self, t)
		local damage = t.getDamage(self, t)
		local insomnia = t.getInsomniaPower(self, t)
		return([[使 %d 码 锥 形 范 围 内 的 目 标 进 入 持 续 %d 回 合 的 噩 梦， 令 其 无 法 行 动。 目 标 每 承 受 %d 点 伤 害 减 少 一 回 合 状 态 持 续 时 间。 
		 每 回 合 目 标 会 受 到 %0.2f 暗 影 伤 害。 此 伤 害 不 会 减 少 噩 梦 的 状 态 持 续 时 间。 
		 当 梦 靥 结 束 时， 目 标 会 饱 受 失 眠 的 痛 苦， 持 续 回 合 等 于 已 睡 眠 的 回 合 数（ 但 最 多 10 回 合）， 失 眠 状 态 的 每 一 个 剩 余 回 合 数 会 让 目 标 获 得 %d%% 睡 眠 免 疫。 
		 受 精 神 强 度 影 响， 伤 害 临 界 点 和 精 神 伤 害 有 额 外 加 成。]]):format(radius, duration, power, damDesc(self, DamageType.DARKNESS, (damage)), insomnia)
	end,
}

registerTalentTranslation{
	id = "T_INNER_DEMONS",
	name = "心魔",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		return ([[使 目 标 的 心 魔 具 象 化。 在 %d 回 合 内， 每 回 合 有 %d%% 的 几 率 会 召 唤 一 个 心 魔， 需 要 目 标 进 行 一 次 精 神 豁 免 鉴 定， 失 败 则 心 魔 具 象 化。 
		 如 果 目 标 处 于 睡 眠 状 态， 豁 免 概 率 减 半 ， 且 无 视 目 标 的 恐 惧 免 疫。 若 目 标 豁 免 鉴 定 成 功， 则 心 魔 的 效 果 提 前 结 束。 
		 受 精 神 强 度 影 响， 召 唤 几 率 按 比 例 加 成。 
		 受 目 标 品 级 影 响， 心 魔 的 生 命 值 有 额 外 加 成。]]):format(duration, chance)
	end,
}

registerTalentTranslation{
	id = "T_WAKING_NIGHTMARE",
	name = "梦靥复苏",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		return ([[每 回 合 造 成 %0.2f 暗 影 伤 害， 持 续 %d 回 合， 并 且 有 %d%% 几 率 随 机 造 成 致 盲、 震 慑 或 混 乱 效 果（ 持 续 3 回 合）。 
		 如 果 目 标 处 于 睡 眠 状 态， 则 其 不 受 负 面 状 态 的 几 率 减 半 。 
		 受 精 神 强 度 影 响， 伤 害 按 比 例 加 成。]]):
		format(damDesc(self, DamageType.DARKNESS, (damage)), duration, chance)
	end,
}

registerTalentTranslation{
	id = "T_NIGHT_TERROR",
	name = "梦靥降临",
	info = function(self, t)
		local damage = t.getDamageBonus(self, t)
		local summon = t.getSummonTime(self, t)
		return ([[增 加 %d%% 你 对 睡 眠 状 态 目 标 的 伤 害 和 抵 抗 穿 透 效 果。 另 外 每 当 你 杀 死 一 个 睡 眠 状 态 的 目 标， 你 可 以 召 唤 一 只 持 续 %d 回 合 的 暗 夜 恐 魔。 
		 受 精 神 强 度 影 响， 伤 害 和 暗 夜 恐 魔 的 属 性 按 比 例 加 成。]]):format(damage, summon)
	end,
}


return _M
