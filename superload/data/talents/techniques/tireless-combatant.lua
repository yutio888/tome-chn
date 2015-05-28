local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SKIRMISHER_BREATHING_ROOM",
	name = "喘息间隙",
	info = function(self, t)
		local stamina = t.getRestoreRate(self, t)
		return ([[当 没 有 敌 人 与 你 相 邻 的 时 候， 你 获 得 %0.1f 体 力 回 复。 在 第 3 级 时， 这 个 技 能 带 给 你 等 量 的 生 命 回 复.]])
			:format(stamina)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_PACE_YOURSELF",
	name = "调整步伐",
	info = function(self, t)
		local slow = t.getSlow(self, t) * 100
		local reduction = t.getReduction(self, t)
		return ([[控 制 你 的 行 动 来 节 省 体 力。 当 这 个 技 能 激 活 时， 你 的 全 局 速 度 降 低 %0.1f%% ， 你 的 疲 劳 值 降 低 %d%% （ 最 多 降 至 0%% ）。]])
		:format(slow, reduction)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_DAUNTLESS_CHALLENGER",
	name = "不屈底力",
	info = function(self, t)
		local stamina = t.getStaminaRate(self, t)
		local health = t.getLifeRate(self, t)
		return ([[当 战 斗 变 得 艰 难 时， 你 变 得 更 加 顽 强。 视 野 内 每 有 一 名 敌 人 存 在， 你 就 获 得 %0.1f 体 力 回 复。 从 第 三 级 起， 每 名 敌 人 同 时 能 增 加 %0.1f 生 命 回 复。 加 成 上 限 为 4 名 敌 人。]])
			:format(stamina, health)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_THE_ETERNAL_WARRIOR",
	name = "不灭战士",
	info = function(self, t)
		local max = t.getMax(self, t)
		local duration = t.getDuration(self, t)
		local resist = t.getResist(self, t)
		local cap = t.getResistCap(self, t)
		local mult = (t.getMult(self, t, true) - 1) * 100
		return ([[每 回 合 使 用 体 力 后， 你 获 得 %0.1f%% 全 抗 性 加 成 和 %0.1f%% 全 抗 性 上 限， 持 续 %d 回 合。 加 成 效 果 最 多 叠 加 %d 次， 每 次 叠 加 都 会 刷 新 效 果 持 续 时 间。
		在 第 5 级 时 ，   喘 息 间 隙 和 不 屈 底 力 效 果 提 升 %d%%]])
			:format(resist, cap, duration, max, mult)
	end,
}


return _M
