local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_DIGEST",
	name = "消化",
	info = function(self, t)
		return ([[ 造 成 %d%% 近 战 武 器 伤 害 并 尝 试 消 化 生 命 在 %d%% 以 下 的 敌 人。
		消 化 过 程 中 你 每 回 合 获 得 %d 疯 狂 值， 同 时 获 得 -%0.1f 生 命 底 线。
		精 英 消 化 时 间 为 5 0 回 合 ， 其 他 生 物 消 化 时 间 为2 5 回 合 。]]):
		format(100 * t.getDamage(self, t), t.getMax(self, t), t.getInsanity(self, t), t.getLife(self, t))
	end,
}

registerTalentTranslation{
	id = "T_PAINFUL_AGONY",
	name = "极度痛苦",
	info = function(self, t)
		return ([[ 正 在 被 你 消 化 的 目 标 承 受 着 极 大 的 痛 苦， 让 你 能 趁 机 侵 入 它 的 思 维。
		你 可 以 窃 取 并 使 用 它 的 一 个 随 机 技 能 （技 能 等 级 %d）。
		技 能 等 级 5 时， 你 可 以 指 定 窃 取 的 技 能。
		你 不 能 窃 取 你 已 知 的 技 能。
		窃 取 的 技 能 使 用 时 不 消 耗 资 源。
		]]):format(self:getTalentLevelRaw(t))
	end,
}

registerTalentTranslation{
	id = "T_INNER_TENTACLES",
	name = "内在触手",
	info = function(self, t)
		return ([[你 的 肚 子 内 产 生 小 型 触 手， 对 消 化 中 的 目 标 造 成 更 多 折 磨。
		每 次 你 暴 击 时， 触 手 将 进 一 步 折 磨 目 标， 为 你 提 供 更 多 能 量， 持 续 3 回 合。
		该 效 果 为 你 的 攻 击 提 供 20%% 几 率 吸 血， 将 %d%% 伤 害 转 化 为 治 疗。 ]]):
		format(t.getLeechValue(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CONSUME_WHOLE",
	name = "完整消化",
	info = function(self, t)
		return ([[立 刻 消 化 掉 当 前 目 标 ， 获 得 %d 生 命 和 %d 疯 狂 值。 生 命 回 复 受 法 术 强 度 加 成。]]):
		format(t.getHeal(self, t), t.getInsanity(self, t))
	end,
}

return _M
