local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_BONE_SPEAR",
	name = "白骨之矛",
		info = function(self, t)
		return ([[ 释 放 一 根 骨 矛， 对 一 条 线 上 的 目 标 造 成 %0.2f 物 理 伤 害。这些目标每具有一个魔法负面效果，就额外受到 %d%% 的伤害。
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), damDesc(self, DamageType.PHYSICAL, t.getBonus(self, t)*100))
	end,
}

registerTalentTranslation{
	id = "T_BONE_GRAB",
	name = "白骨之握",
	info = function(self, t)
		return ([[抓 住 目 标 将 其 传 送 到 你 的 身 边 ，或 将 身 边 的 目 标 丢 到 最 多 6 格 之 外 。从 地 上 冒 出 一 根 骨 刺 ，将 其 定 在 那 里 ，持 续  %d  回 合 。
		 骨 刺 同 时 也 会 造 成  %0.2f  物 理 伤 害 。
		 伤 害 受 法 术 强 度 加 成 。]]):
		format(t.getDuration(self, t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_BONE_SPIKE",
	name = "白骨尖刺",
	info = function(self, t)
		return ([[每 当 你 使 用 一 个 非 瞬 发 的 技 能 ，你 朝 周 围 所 有 具 有  3  个 或 以 上 魔 法 负 面 效 果 的 敌 人 射 出 骨 矛 ，对 一 条 直 线 上 的 敌 人 造 成  %d  伤 害 。
		 伤 害 受 法 术 强 度 加 成 。]]):format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)) )
	end,
}

registerTalentTranslation{
	id = "T_BONE_SHIELD",
	name = "白骨护盾",
	info = function(self, t)
		return ([[制 造 一 圈 白 骨 护 盾 围 绕 你 。每 个 护 盾 能 完 全 吸 收 一 次 攻 击 伤 害 。
		 启 动 时 制 造  %d  个 骨 盾 。
		 如 果 你 的 骨 盾 数 量 不 满 ，每  %d  个 回 合 将 会 自 动 补 充 一 层 骨 盾 。
		 这 一 技 能 只 会 在 攻 击 伤 害 超 过  %d  时 触 发 ，阈 值 受 法 术 强 度 加 成 。]]):
		format(t.getNb(self, t), t.getRegen(self, t), t.getThreshold(self, t))
	end,
}



return _M
