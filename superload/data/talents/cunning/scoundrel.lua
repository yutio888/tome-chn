local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_LACERATING_STRIKES",
	name = "撕裂挥击",
	info = function(self, t)
		local chance = t.getChance(self,t)
		return ([[你 的 近 战 和 远 程 攻 击 有 %d%%的 几 率 撕 裂 敌 人 ，使 其 在 4 回 合 内 受 到 100%%的 额 外 流 血 伤 害 。]]):
		format(chance)
	end,
}

registerTalentTranslation{
	id = "T_SCOUNDREL",
	name = "街霸战术",
	info = function(self, t)
		local chance = t.getChance(self,t)
		local crit = t.getCritPenalty(self, t)
		local dur = t.getDuration(self,t)
		return ([[你 的 近 战 和 远 程 攻 击 制 造 的 伤 口 会 使 敌 人 分 心 ，使 目 标 的 暴 击 系 数 减 少 %d%%，持 续 5 回 合 。
		 此 外 ，你 的 攻 击 还 有 %d%%的 几 率 造 成 痛 苦 的 创 伤 ，使 敌 人 随 机 遗 忘 一 项 技 能 ，持 续 %d 回 合 。这 一 效 果 每 回 合 最 多 只 能 触 发 一 次 。]]):format(crit, chance, dur)
	end,
}



registerTalentTranslation{
	id = "T_MISDIRECTION",
	name = "误导",
	info = function(self, t)
		return ([[你 制 造 混 乱 的 技 巧 已 趋 于 巅 峰。 现 在， 即 便 是 你 最 简 单 的 动 作 也 会 迷 惑 敌 人， 使 他 们 看 不 透 你 的 行 踪。 
		 敌 人 试 图 对 你 施 加 物 理 负 面 状 态 时，有 %d%% 几 率 失 败。 此 外 ， 如 果 你 周 围 有 敌 人 ， 这 一 效 果 将 会 被 转 移 到 这 个 敌 人 身 上 ， 持 续 时 间 变 为 %d%%。 
		 你 获 得 %d 闪 避。
		 施 加 负 面 状 态 几 率 受 命 中 影 响。
		 闪 避 加 成 受 灵 巧 影 响]]):
		 format(t.getChance(self,t),t.getDuration(self,t), t.getDefense(self, t))
		end,
}
registerTalentTranslation{
	id = "T_FUMBLE",
	name = "笨拙",
	info = function (self,t)
		local stacks = t.getStacks(self, t)
		local dam = t.getDamage(self, t)
		return ([[你 的 近 程 和 远 程 攻 击 会 让 敌 人 难 以 集 中 精 力 于 复 杂 的 行 动 ，在 下 一 次 使 用 技 能 时 有 3%%的 几 率 失 败 ，这 一 效 果 可 以 叠 加 ，最 多 叠 加 至 %d%%。
		 如   果 因 任 何 原 因 ，敌 人 技  能  使 用 失 败 ，对 方 将 弄 伤 自 己 ，造 成 %0.2f 物 理 伤 害 。
		 如 果 敌 人 是 因 笨 拙 效 果 而 技 能 使 用 失 败 ，将 会 移 除 笨 拙 效 果 。
		伤 害 受 灵 巧 加 成 。
	   ]]):format(stacks*3, damDesc(self, DamageType.PHYSICAL, dam))
	end,
}


return _M
