local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_CONCEALMENT",
	name = "隐匿",
	info = function (self,t)
		local avoid = t.getAvoidance(self,t)*3
		local range = t.getSight(self,t)
		local radius = t.getRadius(self,t)
		return ([[进 入 隐 匿 的 狙 击 状 态, 增 加 武 器 攻 击 范 围 和 视 野 %d 格, 所 有 攻 击 有 %d%% 几 率 无 法 命 中 你, 爆 头、齐 射 和 精 巧 射 击 视 为 目 标 已 被 标 记.
所 有 非 瞬 时 非 移 动 行 为 将 打 破 隐 匿 状 态, 攻 击 范 围 与 视 野 的 加 成 和 伤 害 回 避 效 果 将 额 外 持 续 3 回 合, 伤 害 回 避 效 果 每 回 合 减 少 33%%.
该 技 能 需 要 弓 来 使 用, 如 果 在 你 周 围 %d 格 内 有 敌 人, 则 不 能 使 用.]]):
		format(range, avoid, radius)
	end,
}
registerTalentTranslation{
	id = "T_SHADOW_SHOT",
	name = "暗影射击",
	info = function (self,t)
		local dam = t.getDamage(self,t)*100
		local radius = self:getTalentRadius(t)
		local sight = t.getSightLoss(self,t)
		local cooldown = t.getCooldownReduction(self,t)
		return ([[发 射 一 个 带 着 烟 雾 弹 的 箭 头 造 成 %d%% 伤 害 并 制 造 一 个 半 径 为 %d 的 烟 雾. 被 困 在 内 的 人 将 被 混 乱( 强 度 50%%) 并 减 少 视 野 %d 格 5 回 合.
此 效 果 将 减 少 你 隐 匿 技 能 %d 回 合 冷 却 时 间. 如 果 冷 却 时 间 减 到 0, 无 论 敌 人 是 否 太 近, 都 可 立 即 激 活 隐 匿.
烟 雾 弹 影 响 目 标 的 几 率 随 你 命 中 增 加.]]):
		format(dam, radius, sight, cooldown)
	end,
}
registerTalentTranslation{
	id = "T_AIM",
	name = "瞄准姿态",
	info = function (self,t)
		local power = t.getPower(self,t)
		local speed = t.getSpeed(self,t)
		local dam = t.getDamage(self,t)
		local mark = t.getMarkChance(self,t)
		return ([[进 入 一 个 平 静, 专 注 的 姿 态, 增 加 %d 物 理 强 度 和 命 中, 抛 射 物 速 度 增 加 %d%% 并 且 标 记 目 标 的 几 率 增 加 %d%%.
这 让 你 在 射 程 内 射 击 更 有 效：对 三 格 外 目 标 的 距 离 每 增 加 一 格 ，伤 害 增 加 %0.1f%% , 8 格 距 离 时 达 到 最 大值 （%0.1f%% ）。
物 理 强 度 和 命 中 随 敏 捷 增 加.]]):
		format(power, speed, mark, dam, dam*5)
	end,
}
registerTalentTranslation{
	id = "T_SNIPE",
	name = "狙击",
	info = function (self,t)
		local dam = t.getDamage(self,t)*100
		local reduction = t.getDamageReduction(self,t)
		return ([[瞄 准 1 回合, 准 备 射 出 一 发 致 命 的 子 弹. 下 回 合, 这 个 技 能 被 替 换 成 标 记 目 标 并 造 成 %d%% 伤 害 的 致 命 攻 击 .
若 你 处 于 瞄 准 姿 态，专 注 力 让 你 无 视 受 到 的 %d%% 伤 害 和 所 有 负 面 状 态。]]):
		format(dam, reduction)
	end,
}
registerTalentTranslation{
	id = "T_SNIPE_FIRE",
	name = "狙 击",
	info = function (self,t)
		return ([[射 出 一 发 致 命 射 击. 这 次 射 击 将 绕 过 你 和 你 的 目 标 之 间 的 其 他 敌 人, 并 提 高 100 命 中.]]):
		format(dam, reduction)
	end,
}

return _M