
local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_SHOOT_DOWN",
	name = "击落",
	info = function (self,t)
		return ([[你 的 反 射 像 闪 电 一 样 快, 如 果 你 发 现 一 个 抛 射 物 (箭 矢, 弹 丸, 法 术, ...) 你 可 以 不消 耗 时 间 立 刻 射 击 之 。
		最 多 可 同 时 击 落 %d 个 抛 射 物。
		此 外, 射 向 你 的 抛 射 物 飞 行 速 度 下 降 %d%% ，你 的 抛 射 物 不 再 击 中 你 自 己。]]):
		format(t.getNb(self, t), t.getSlow(self,t))
	end,
}
registerTalentTranslation{
	id = "T_INTUITIVE_SHOTS",
	name = "直觉射击",
	info = function (self,t)
		local chance = t.getChance(self,t)
		local dam = t.getDamage(self,t)*100
		return ([[激 活 这 个 技 能 将 你 的 反 应 提 升 到 令 人 难 以 置 信 的 水 平. 每 当 你 被 近 身 攻 击, 你 有 %d%% 几 率 射 出 一 箭 拦 截 攻 击, 躲 闪 攻 击 并 造 成 %d%% 伤 害.
		该技 能 每 回 合 触 发 最 多 一 次.]])
		:format(chance, dam)
	end,
}
registerTalentTranslation{
	id = "T_SENTINEL",
	name = "哨兵",
	info = function (self,t)
		local nb = t.getTalentCount(self,t)
		local cd = t.getCooldown(self,t)
		return ([[你 在 接 下 来 的 5 回 合 内 密 切 关 注 目 标. 当 其 使 用 非 瞬 发 技 能 时, 你 立 刻 做 出 反 应, 射 出 一 箭 造 成 25%% 伤 害 打 断 技 能 并 使 其 进 入 冷 却.
该 攻 击 为 瞬 间 击 中, 必 中, 并 使 其 它 %d 个 技 能 进 入 冷 却 %d 回 合.]]):
		format(nb, cd)
	end,
}
registerTalentTranslation{
	id = "T_ESCAPE",
	name = "逃脱",
	info = function (self,t)
		local power = t.getDamageReduction(self,t)
		local sta = t.getStamina(self,t)
		local speed = t.getSpeed(self,t)
		return ([[你 专 注 逃 跑 4 回 合. 处 于 此 状 态 时 增 加 %d%% 所 有 伤 害 抗 性, %0.1f 体 力 恢 复, 免 疫 震 慑, 定 身, 眩 晕 和 减 速 效 果 并 增 加 %d%% 移 动 速 度. 
除 移 动 外 的 任 何 行 动 将 终 止 该 效 果。]]):
		format(power, sta, speed)
	end,
}

return _M