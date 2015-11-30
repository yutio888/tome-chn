local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_THREAD_WALK",
	name = "空间行走",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local defense = t.getDefense(self, t)
		local resist = t.getResist(self, t)
		return ([[使 用 弓 或 双 持 武 器 攻 击 ， 造 成 %d%% 武 器 伤 害。
		如 果 使 用 弓 箭 ， 则 你 被 传 送 到 目 标 附 近 。 否 则 传 送 到 和 目 标 距 离 等 于 弓 的 射 程 的 位 置。
		同 时 ， 你 获 得 传 送 后 加 成 ： 增 加 %d 闪 避 和 %d%% 全 体 抗 性。
		传 送 后 加 成 受 魔 法 加 成 。]])
		:format(damage, defense, resist)
	end,
}

registerTalentTranslation{
	id = "T_BLENDED_THREADS",
	name = "混合螺旋",
	info = function(self, t)
		local count = t.getCount(self, t)
		return ([[每 次 你 的 箭 命 中 时 ， 减 少 一 个 螺 旋 灵 刃 系 技 能 一 回 合 的 冷 却。
		每 次 你 的 近 战 武 器 命 中 时 ， 减 少 一 个 螺 旋 灵 弓 系 技 能 一 回 合 的 冷 却。
		这 个 效 果 一 回 合 最 多 触 发 %d 次。]])
		:format(count)
	end,
}

	
registerTalentTranslation{
	id = "T_THREAD_THE_NEEDLE",
	name = "针型聚焦",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[使 用 弓 箭 或 者 双 持 武 器 攻 击 造 成 %d%% 武 器 伤 害 。
		如 果 使 用 弓 箭 ， 你 的 箭 将 成 为 具 有 穿 透 性 的 射 线。
		如 果 使 用 双 持 武 器 ， 则 攻 击 你 周 围 半 径 1 的 所 有 目 标。]])
		:format(damage)
	end,
}

	
	
registerTalentTranslation{
	id = "T_WARDEN_S_CALL",
	name = "守卫呼唤",
	info = function(self, t)
		return ([[当 你 用 弓 箭 或 近 战 武 器 攻 击 时 ，有 %d%% 几 率 让 一 个 时 空 守 卫 从 另 一 个 时 空 线 穿 越 过 来 帮 助 你 ， 攻 击 或 者 射 击 目 标。
		守 卫 处 于 相 位 空 间 外 ， 伤 害 减 少 %d%% ， 守 卫 的 弓 箭 能 穿 过 友 方 生 物。
		这 个 效 果 每 回 合 只 能 触 发 一 次 ， 守 卫 在 攻 击 后 会 消 失 。]])
		:format(t.getChance(self, t), t.getDamagePenalty(self, t))
	end,

}

return _M
