local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MERGE",
	name = "融合",
	info = function(self, t)
		return ([[指 定 附 近 的 一 个 阴 影，命 令 它 和 附 近 的 一 个 敌 人 融 合，降 低 其 伤 害 %d%% ， 持 续 5 回 合。
杀 死 阴 影 释 放 了 你 的 憎 恨 ，回 复 8 点 仇 恨 值 。]]):
		format(t.getReduction(self, t))
	end,
}

registerTalentTranslation{
	id = "T_STONE",
	name = "石化",
	info = function(self, t)
		return ([[指 定 附 近 的 一 个 阴 影 ，令 其 攻 击 附 近 的 一 个 敌 人 ， 造 成 %0.1f 物 理 伤 害 。
你 的 阴 影 将 把 那 个 敌 人 设 为 目 标 ，而 敌 人 也 会 攻 击 那 个 阴 影。
伤 害 受 精 神 强 度 加 成。]]):
		format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id	= "T_SHADOW_S_PATH",
	name = "阴影之路",
	info = function(self, t)
		return ([[命 令 所 有 视 野 内 阴 影 传 送 至 目 标 处，对 所 有 经 过 的 敌 人 造 成 %0.1f 物 理 伤 害。
阴 影 能 穿 过 墙 壁 来 到 达 目 的 地。
伤 害 受 精 神 强 度 加 成。]]):
		format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_CURSED_BOLT",
	name = "诅咒之球",
	info = function(self, t)
		return ([[和 视 野 内 的 阴 影 共 享 仇 恨 ， 获 得 临 时 控 制。
每 个 阴 影 将 发 射 纯 粹 的 仇 恨 之 球 ， 对 附 近 的 一 个 敌 人 造 成 %0.1f 精 神 伤 害 。
一 旦 发 射 了 一 个 仇 恨 之 球 ， 该 技 能 不 能 取 消。
伤 害 受 精 神 强 度 加 成。]]):
		format(damDesc(self, DamageType.MIND, t.getDamage(self, t)))
	end,
}

return _M