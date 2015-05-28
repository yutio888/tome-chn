local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ARROW_STITCHING",
	name = "重叠灵矢",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local penalty = t.getDamagePenalty(self, t)
		return ([[发 射 一 支 灵 矢 造 成  %d%%  武 器 伤 害 ，并 且 根 据 可 用 空 间 ，召 唤 最 多 两 个 守 卫 ，各 自 发 射 一 枚 灵 矢 然 后 回 到 他 们 自 己 的 时 间 线 中 。
		 守 卫 处 在 现 实 位 面 之 外 ，灵 矢 的 伤 害 减 少  %d%%  ，但 能 够 穿 过 友 好 目 标 。同 时 ，你 发 射 的 所 有 来 自 射 击 或 者 其 他 技 能 的 箭 矢 ，都 可 以 穿 透 友 军 并 且 不 会 造 成 伤 害 。
		 
		  激 活 螺 旋 灵 弓 技 能 可 以 自 由 切 换 到 你 的 弓 （必 须 装 备 在 副 武 器 栏 位 上 ）。此 外 ，当 你 使 用 远 程 攻 击 时 也 会 触 发 这 个 效 果 。]])
		:format(damage, penalty)
	end,
}

	
registerTalentTranslation{
	id = "T_SINGULARITY_ARROW",
	name = "奇点之矢",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local radius = self:getTalentRadius(t)
		local aoe = t.getDamageAoE(self, t)
		return ([[发 射 一 支 灵 矢 造 成  %d%%  武 器 伤 害 。当 灵 矢 到 达 目 标 地 点 或 者 击 中 目 标 后 ，会 牵 引 半 径  %d  并 造 成  %0.2f  物 理 伤 害 。
		 从 第 二 个 单 位 起 ，每 增 加 一 个 被 牵 引 的 单 位 ，会 使 伤 害 增 加  %0.2f (最 多 增 加  %0.2f  额 外 伤 害 ).
		 目 标 离 牵 引 中 心 的 距 离 越 远 受 到 的 伤 害 就 越 低  (每 格 减 少 20%% ).
		 受 法 术 强 度 影 响 ，额 外 伤 害 有 加 成 。]])
		:format(damage, radius, damDesc(self, DamageType.PHYSICAL, aoe), damDesc(self, DamageType.PHYSICAL, aoe/8), damDesc(self, DamageType.PHYSICAL, aoe/2))
	end,
}

registerTalentTranslation{
	id = "T_ARROW_ECHOES",
	name = "灵矢回声",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[在 下 面 的  %d  回 合 中 ，你 从 当 前 所 在 位 置 对 目 标 发 射 最 多  %d  支 灵 矢 ，每 支 对 目 标 造 成  %d%%  武 器 伤 害 。  
		 这 些 射 击 不 消 耗 弹 药 。]])
		:format(duration, duration, damage)
	end,
}

registerTalentTranslation{
	id = "T_ARROW_THREADING",
	name = "螺旋灵矢",
	info = function(self, t)
		local tune = t.getTuning(self, t)
		return ([[当 你 发 射 的 箭 矢 命 中 时 ，将 会 使 你 的 紊 乱 值 向 预 设 值 调 谐  %0.2f  点 。]])
		:format(tune)
	end,
}

return _M
