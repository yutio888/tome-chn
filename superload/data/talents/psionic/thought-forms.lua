local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TF_BOWMAN",
	name = "具象之弧：弓箭手",
	info = function(self, t)
		local stat = t.getStatBonus(self, t)
		return ([[你 从 脑 海 里 召 唤 出 一 位 身 穿 皮 甲 的 精 神 体 弓 箭 手。 当 精 神 体 弓 箭 手 到 达 对 应 等 级 时 可 习 得 弓 术 掌 握、 强 化 命 中、 稳 固 射 击、 致 残 射 击 和 急 速 射 击， 并 且 可 增 加 %d 点 力 量、 %d 点 敏 捷 和 %d 体 质。 
		 激 活 此 技 能 会 使 其 他 具 象 之 弧 系 技 能 进 入 冷 却。 
		 受 精 神 强 度 影 响， 属 性 增 益 有 额 外 加 成。]]):format(stat/2, stat, stat/2)
	end,
}

registerTalentTranslation{
	id = "T_TF_WARRIOR",
	name = "具象之弧：狂战士",
	info = function(self, t)
		local stat = t.getStatBonus(self, t)
		return ([[你 从 脑 海 里 召 唤 出 一 位 手 持 战 斧 的 精 神 体 狂 战 士。 当 精 神 体 狂 战 士 到 达 对 应 等 级 时 可 习 得 武 器 掌 握、 强 化 命 中、 嗜 血、 死 亡 之 舞 和 冲 锋， 并 且 可 增 加 %d 点 力 量、 %d 点 敏 捷 和 %d 体 质。 
		 激 活 此 技 能 会 使 其 他 具 象 之 弧 系 技 能 进 入 冷 却。 
		 受 精 神 强 度 影 响， 属 性 增 益 有 额 外 加 成。]]):format(stat, stat/2, stat/2)
	end,
}

registerTalentTranslation{
	id = "T_TF_DEFENDER",
	name = "具象之弧：盾战士",
	info = function(self, t)
		local stat = t.getStatBonus(self, t)
		return ([[你 从 脑 海 里 召 唤 出 一 位 手 持 剑 盾 的 精 神 体 盾 战 士。 当 精 神 体 盾 战 士 到 达 对 应 等 级 时 可 习 得 护 甲 掌 握、 武 器 掌 握、 强 化 命 中、 盾 牌 连 击 和 盾 墙， 并 且 可 增 加 %d 点 力 量、 %d 点 敏 捷 和 %d 体 质。 
		 激 活 此 技 能 会 使 其 他 具 象 之 弧 系 技 能 进 入 冷 却。 
		 受 精 神 强 度 影 响， 属 性 增 益 有 额 外 加 成。]]):format(stat/2, stat/2, stat)
	end,
}

registerTalentTranslation{
	id = "T_THOUGHT_FORMS",
	name = "具象之弧",
	info = function(self, t)
		local bonus = t.getStatBonus(self, t)
		local range = self:getTalentRange(t)
		return([[你 从 脑 海 里 召 唤 出 一 位 强 大 的 守 护 者。 
		 你 的 守 护 者 主 属 性 会 增 加 %d ， 他 的 两 项 副 属 性 会 增 加 %d ， 同 时 他 的 力 量、 灵 巧 和 意 志 属 性 等 同 于 你 的 属 性 值。 
		 在 等 级 1 时， 你 会 召 唤 出 身 着 皮 甲 的 弓 箭 手 大 师； 
		 在 等 级 3 时， 你 会 召 唤 出 手 持 双 手 武 器 的 精 英 狂 战 士； 
		 在 等 级 5 时， 你 会 召 唤 出 手 持 剑 盾 的 精 英 盾 战 士。 
		 精 神 体 只 能 存 在 于 %d 码 范 围 内， 若 超 出 此 范 围， 则 精 神 体 会 回 到 你 身 边。 
		 在 同 一 时 间 内 只 有 一 种 具 象 之 弧 可 以 激 活。 
		 受 精 神 强 度 影 响， 属 性 增 益 有 额 外 加 成。]]):format(bonus, bonus/2, range)
	end,
}

registerTalentTranslation{
	id = "T_TRANSCENDENT_THOUGHT_FORMS",
	name = "具象之弧：卓越",
	info = function(self, t)
		local level = math.floor(self:getTalentLevel(t))
		return([[你 的 精 神 体 习 得 技 能 等 级 为 %d 的 清 晰 梦 境、 生 物 反 馈 和 共 鸣 之 心。]]):format(level)
	end,
}

registerTalentTranslation{
	id = "T_OVER_MIND",
	name = "具象之弧：支配",
	info = function(self, t)
		local bonus = t.getControlBonus(self, t)

		return ([[直 接 控 制 当 前 的 精 神 体， 增 加 其 %d%% 伤 害、 攻 速 以 及 最 大 生 命 值， 但 是 此 时 你 的 身 体 会 处 于 比 较 脆 弱 的 状 态。 
		 在 等 级 1 时， 你 的 守 护 者 所 获 得 的 任 何 反 馈 值 也 会 传 递 给 你。 
		 在 等 级 3 时， 你 的 守 护 者 会 获 得 所 有 豁 免 的 增 益 效 果， 数 值 等 同 你 精 神 豁 免 的 大 小。 
		 在 等 级 5 时， 它 们 会 获 得 伤 害 增 益， 增 益 值 基 于 你 的 额 外 精 神 伤 害。 
		 等 级 3 的 增 益 为 被 动 效 果， 无 论 此 技 能 是 否 激 活 均 有 效。 
		 受 精 神 强 度 影 响， 增 益 效 果 有 额 外 加 成。]]):format(bonus)
	end,
}

registerTalentTranslation{
	id = "T_TF_UNITY",
	name = "具象之弧：共鸣",
	info = function(self, t)
		local offense = t.getOffensePower(self, t)
		local defense = t.getDefensePower(self, t)
		local speed = t.getSpeedPower(self, t)
		return([[现 在， 当 具 象 之 弧： 弓 箭 手 激 活 时， 你 提 升 %d%% 精 神 速 度； 
		 当 具 象 之 弧： 狂 战 士 激 活 时， 你 提 升 %d 精 神 强 度； 
		 当 具 象 之 弧： 盾 战 士 激 活 时， 你 提 升 %d%% 所 有 抵 抗。 
		 受 精 神 强 度 影 响， 增 益 效 果 按 比 例 加 成。]]):format(speed, offense, defense, speed)
	end,
}


return _M
