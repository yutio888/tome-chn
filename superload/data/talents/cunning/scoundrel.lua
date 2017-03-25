local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_LACERATING_STRIKES",
	name = "撕裂挥击",
	info = function(self, t)
		local chance = t.getChance(self,t)
		return ([[所 有 的 攻 击 现 在 都 有 %d%% 的 概 率 撕 裂 目 标， 使 目 标 进 入 持 续 10 回 合 的 流 血 状 态， 总 计 造 成 75%% 你 的 攻 击 伤 害 值，并 使 目标 失 去 %d%% 回 合（ 每 回 合 一 次）。]]):
		format(chance, t.turnLoss(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_SCOUNDREL",
	name = "街霸战术",
	info = function(self, t)
		local chance = t.getChance(self,t)
		local crit = t.getCritPenalty(self, t)
		local dur = t.getDuration(self,t)
		return ([[你 的 攻 击 在 制 造 伤 口 的 同 时 会 减 少 目 标 %d%% 暴 击 率 ， 持 续 10 回 合。
此 外 ， 攻 击 流 血 目 标 时 你 有 %d%%几 率 制 造 痛 苦 的 伤 口 。令 其 遗 忘 一 个 技 能 %d 回 合 ，这 项 效 果 对 每 个 目 标 每 回 合 只 能 触 发 一 次 。
		]]):format(crit, chance, dur)
	end,
}



registerTalentTranslation{
	id = "T_MISDIRECTION",
	name = "误导",
	info = function(self, t)
		return ([[你 制 造 混 乱 的 技 巧 已 趋 于 巅 峰。 现 在， 即 便 是 你 最 简 单 的 动 作 也 会 迷 惑 敌 人， 使 他 们 看 不 透 你 的 行 踪。 
		 敌 人 试 图 对 你 施 加 物 理 负 面 状 态 时，有 %d%% 几 率 会 被 误 导 至 自 身 ， 持 续 时 间 变 为 %d%%。 
		 施 加 负 面 状 态 几 率 受 命 中 影 响。]]):
		format(t.getChance(self,t),t.getDuration(self,t))
	end,
}
registerTalentTranslation{
	id = "T_FUMBLE",
	name = "笨拙",
	info = function (self,t)
		local stacks = t.getStacks(self, t)
		local dam = t.getDamage(self, t)
		return ([[你 的 街 霸 战 术 效 果 让 你 的 敌 人 难 以 集 中 精 神 ，使 用 技 能 有 3%%几 率 失 败 ，可 叠 加 至  %d%%。
		 如 果 技 能 使 用 失 败 ，对 方 将 弄 伤 自 己 ，造 成 %0.2f 物 理 伤 害 并 移 除 笨 拙 效 果 。
		 伤 害 受 灵 巧 加 成 。
		]]):format(stacks*3, damDesc(self, DamageType.PHYSICAL, dam))
	end,
}


return _M
