local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SKIRMISHER_VAULT",
	name = "撑杆跳",
	info = function(self, t)
		return ([[利 用 相 邻 的 友 军 或 敌 人 作 为 跳 板， 从 他 们 头 上 跳 入 技 能 范 围 内 的 另 外 一 格 中。
		这 个 伎 俩 使 你 借 助 弹 跳 的 力 量 提 高 你 的 速 度， 让 你 在 跳 跃 的 方 向 上 的 移 动 速 度 增 加 %d%% 三 回 合。
		如 果 你 改 变 方 向 或 者 停 止 移 动， 速 度 加 成 将 会 消 失。
		]]):format(t.speed_bonus(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_CUNNING_ROLL",
	name = "翻滚",
	info = function(self, t)
		return ([[从 敌 人 的 侧 面、上 空 或 者 胯 下 移 动 到 技 能 范 围 内 的 指 定 位 置。
		这 个 伎 俩 可 以 惊 吓 你 的 敌 人 让 你 获 得 更 有 利 的 战 术 位 置， 增 加 你 的 暴 击 几 率 %d%% 1 回 合。]]):format(t.combat_physcrit(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_TRAINED_REACTIONS",
	name = "求生本能",
	info = function(self, t)
		local trigger = t.getLifeTrigger(self, t)
		local reduce = t.getReduction(self, t)
		local cost = t.stamina_per_use(self, t) * (1 + self:combatFatigue() * 0.01)
		return ([[当 这 个 技 能 被 激 活 的 时 候， 你 能 够 预 见 到 致 命 的 伤 害。
		每 当 你 遭 受 一 次 大 于 %d%% 生 命 值 的 攻 击 时， 你 闪 身 躲 避 这 个 攻 击 并 摆 出 防 御 姿 势。
		这 个 技 能 降 低 本 次 伤 害 和 接 下 来 本 回 合 的 所 有 伤 害 %d%% 。
		你 需 要 %0.1f 体 力 和 相 邻 的 无 人 空 地 来 触 发 技 能 效 果 （ 尽 管 你 不 会 因 为 躲 避 而 移 动） 。]])
		:format(trigger, reduce, cost)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_SUPERB_AGILITY",
	name = "身轻如燕",
	info = function(self, t)
		return ([[你 使 用 杂 耍 系 技 能 更 加 得 心 应 手， 降 低 撑 杆 跳、 翻 滚 和 求 生 本 能 的 冷 却 时 间 %d 回 合， 降 低 技 能 的 体 力 消 耗 %0.1f 。
		在 等 级 3 时， 每 当 求 生 本 能 触 发， 你 获 得 10%%  的 全 局 速 度 1 回 合。
		在 等 级 5 时， 速 度 加 成 变 为 20%% ， 持 续 2 回 合。]])
		:format(t.cooldown_bonus(self, t), t.stamina_bonus(self, t))
	end,
}


return _M
