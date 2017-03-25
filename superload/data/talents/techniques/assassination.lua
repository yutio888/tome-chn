
local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_COUP_DE_GRACE",
	name = "致命一击！",
	info = function (self,t)
		dam = t.getDamage(self,t)*100
		perc = t.getPercent(self,t)*100
		return ([[尝 试 终 结 一 名 受 伤 的 敌 人， 用 双 持 武 器 攻 击 对 方 ， 造 成 %d%% 武 器 伤 害 ，每 次 攻 击 额 外 造 成 等 价 于 %d%% 已 损 失 生 命 值 的 物 理 伤 害  (被 怪 物 阶 级 减 免 至:  1/1 ( 生物 ) 到  1/5 ( 精 英 boss )). 20%% 生 命 以 下 的 目 标 将 直 接 被 斩 杀 。
		如 果 该 技 能 杀 死 敌 人 ， 且 你 学 会 了 潜 行 技 能 ， 你 将 进 入 潜 行 状 态 。]]):
		format(dam, perc)
	end,
}
registerTalentTranslation{
	id = "T_TERRORIZE",
	name = "致命恐惧",
	info = function (self,t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self,t)
		return ([[每 次 你 脱 离 潜 行 状 态 ，你 戏 剧 般 的 显 形 令 周 围 的 敌 人 闻 风 丧 胆。 
		%d 范 围 内 看 到 你 脱 离 潜 行 状 态 的 敌 人 将 陷 入 恐 惧 ，随 机 触 发 震 慑 、 减 速(40%%)、 或 者 混 乱 (50%%) 状 态， 持 续 %d 回 合 。
		恐 惧 几 率 受 命 中 加 成 。]])
		:format(radius, duration)
	end,
}
registerTalentTranslation{
	id = "T_GARROTE",
	name = "绞刑",
	info = function (self,t)
		local damage = t.getDamage(self, t)*100
		local dur = t.getDuration(self,t)
		local sdur = math.ceil(t.getDuration(self,t)/2)
		return ([[每 次 在 潜 行 状 态 下 发 起 进 攻 时 ，你 尝 试 绞 杀 目 标。目 标 将 被 勒 住 %d 回 合， 沉 默 %d 回 合。 被 勒 住 的 目 标 不 能 移 动， 每 回 合 受 到 一 次 %d%% 伤 害 的 徒 手 攻 击 。  
		勒 住 的 几 率 受 命 中 加 成 ，你 必 须 待 在 目 标 身 边 以 保 持 该 状 态 。
		该 技 能 有 冷 却 时 间。]])
		:format(dur, sdur, damage)
	end,
}
registerTalentTranslation{
	id = "T_MARKED_FOR_DEATH",
	name = "死亡标记",
	info = function (self,t)
		power = t.getPower(self,t)
		perc = t.getPercent(self,t)
		dam = t.getDamage(self,t)
		return ([[你 为 目 标 打 上 死 亡 标 记，持 续 4 回 合 , 使 其 受 到 的 伤 害 增 加 %d%% 。该 效 果 结 束 时，额 外 造 成  %0.2f 追 加 等 于 标 记 期 间 受 到 的 伤 害 的 %d%% 的 物 理 伤 害。
		目 标 在 标 记 期 间 死 亡 时 ， 该 技 能 立 刻 冷 却 完 成 ， 同 时 返 还 消 耗 。
		使 用 该 技 能 不 消 耗 潜 行 。
		伤 害 受 敏 捷 加 成。]]):
		format(power, damDesc(self, DamageType.PHYSICAL, dam), perc)
	end,
}
return _M