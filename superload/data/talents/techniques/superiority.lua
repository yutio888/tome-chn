local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_JUGGERNAUT",
	name = "战场主宰",
	info = function(self, t)
		return ([[专 注 于 战 斗 并 忽 略 你 所 承 受 的 攻 击。 
		增 加 物 理 伤 害 减 免 %d%% 同 时 有 %d%% 几 率 摆 脱 暴 击 伤 害 ， 持 续 20 回 合。]]):
		format(t.getResist(self,t), t.critResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ONSLAUGHT",
	name = "猛攻",
	info = function(self, t)
		return ([[采 取 一 个 猛 攻 姿 态， 当 你 经 过 你 的 敌 人 时， 你 会 将 前 方 弧 形 范 围 内 的 敌 人 全 部 击 退。（ 上 限 %d 码）。 
		这 个 姿 态 会 快 速 减 少 体 力 值（ -1 体 力 / 回 合）。]]):
		format(t.range(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BATTLE_CALL",
	name = "挑衅",
	info = function(self, t)
		return ([[挑 衅 你 周 围 %d 码 半 径 范 围 内 的 敌 人 进 入 战 斗， 使 它 们 立 刻 进 入 近 战 状 态。]]):format(t.radius(self,t))
	end,
}

registerTalentTranslation{
	id = "T_SHATTERING_IMPACT",
	name = "震荡攻击",
	info = function(self, t)
		return ([[用 尽 全 身 的 力 量 挥 舞 武 器， 造 成 震 荡 波 冲 击 你 周 围 的 所 有 敌 人， 对 每 个 敌 人 造 成 %d%% 基 础 武 器 伤 害。
		一 回 合 至 多 产 生 一 次 冲 击 波 ， 第 一 个 目 标 不 会 受 到 额 外 伤 害。
		每 次 震 荡 攻 击 消 耗 8 点 体 力。]]):
		format(100*t.weaponDam(self, t))
	end,
}


return _M
