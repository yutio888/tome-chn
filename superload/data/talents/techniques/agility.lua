local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_AGILE_DEFENSE",
	name = "敏捷防御",
	info = function (self,t)
		local chance = t.getChance(self, t)
		return ([[你 学 会 了 在 战 斗 中 灵 敏 使 用 投 石 索 和 盾 牌 的 技 巧 。 允 许 你 装 备 盾 牌 ， 用  敏 捷 代 替 力 量 需 求 。
当 你 装 备 盾 牌 ， 且 格 挡 技 能 未 进 入 冷 却 时，有 %d%% 几 率 抵 挡 攻 击 ， 减 免 50%% 格 挡 值 的 伤 害 。]])
			:format(chance)
	end,
}
registerTalentTranslation{
	id = "T_VAULT",
	name = "跳跃",
	info = function (self,t)
		local dam = t.getDamage(self, t) * 100
		local range = t.getDist(self, t)
		return ([[用盾 牌 踩 在 临 近 目 标 上 ， 造 成 %d%% 伤 害 并 眩 晕 2 回 合 ，  之 后 将 其 做 为 跳 板 跃 向 %d 格 内 的 空 地 。
盾 袭 将 使 用 敏 捷 代 替 力 量 决 定 盾 牌 伤 害 。
技 能 等 级 5 时， 你 将 在 落 地 后 立 刻 进 入 格 挡 状 态。]])
		:format(dam, range)
	end,
}
registerTalentTranslation{
	id = "T_BULL_SHOT",
	name = "冲锋射击",
	info = function (self,t)
		return ([[你 冲 向 敌 人 ， 同 时 准 备 射 击 。当 你 接 近 敌 人 时 ， 立 刻 射 击 ， 释 放 强 大 的 威 力。
		射 击 造 成 %d%% 武 器 伤 害 并 击 退 目 标 %d 格.
		每 次 你 移 动 时 ， 该 技 能 的 冷 却 时 间 减 少 1 回 合 。
		该 技 能 需 要 投 石 索。]]):
		format(t.getDamage(self,t)*100, t.getDist(self, t))
	end,
}
registerTalentTranslation{
	id = "T_RAPID_SHOT",
	name = "速射姿态",
	info = function (self,t)
		local atk = t.getAttackSpeed(self,t)*100
		local move = t.getMovementSpeed(self,t)*100
		local turn = t.getTurn(self,t)
		return ([[进 入 流 畅 而 灵 活 的 射 击 姿 势 ， 更 适 用 于 近 战 。 你 的 远 程 攻 击 速 度 增 加 %d%% ， 每 次 射 击 令 你 在 两 回 合 内 移 动 速 度 增 加 %d%%  。
命 中 敌 人 的 远 程 攻 击 将 给 你 带 来 %d%% 额 外 回 合，该 效 果 对 三 格 以 内 的 目 标 有 100%% 效 果 ， 每 增 加 1 格 距 离 ， 效 果 降 低 20%% ( 8 格 降 为 0 %% )。该 效 果 每 回 合 只 能 生 效 一 次 。
该 技 能 需 要 投 石 索。]]):
		format(atk, move, turn)
	end,
}

return _M