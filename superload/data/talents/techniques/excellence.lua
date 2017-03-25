local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHOOT_DOWN_OLD",
	name = "强制击落",
	info = function(self, t)
		return ([[ 你 的 反 射 神 经 像 闪 电 一 样 快。 当 你 瞄 准 抛 射 物 （ 箭 矢、 弹 药、 法 术 等 ） 时， 你 能 马 上 击 落 它 而 不 消 耗 时 间。 
		 你 最 多 能 击 落 %d 个 目 标。 ]]):
		format(t.getNb(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BULL_SHOT_OLD",
	name = "冲锋射击",
	info = function(self, t)
		return ([[ 你 冲 向 你 的 敌 人， 并 准 备 好 射 击。 如 果 你 接 触 到 敌 人， 你 将 射 出 你 准 备 好 的 箭 矢/ 弹 药， 给 予 其 强 劲 的 力 量。 射 击 造 成 %d%% 伤 害 并 击 退 对 手 %d 码。 ]]):
		format(self:combatTalentWeaponDamage(t, 1.5, 2.8) * 100, t.getDist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_INTUITIVE_SHOTS_OLD",
	name = "直觉射击",
	info = function(self, t)
		return ([[ 激 活 该 技 能 会 大 幅 强 化 你 的 反 射 神 经。 每 次 你 受 到 近 战 攻 击， 你 有 %d%% 的 几 率 进 行 一 次 防 御 性 射 击 来 中 止 对 方 这 次 攻 击， 并 造 成 %d%% 伤 害， 同 时 击 退 对 方 %d 码。 激 活 这 项 技 能 不 会 中 断 装 填 弹 药。]])
		:format(t.getChance(self, t), self:combatTalentWeaponDamage(t, 0.4, 0.9) * 100, t.getDist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_STRANGLING_SHOT",
	name = "沉默射击",
	info = function(self, t)
		return ([[ 你 瞄 准 目 标 的 喉 咙、 嘴 巴 或 相 关 部 位， 造 成 %d%% 伤 害， 并 沉 默 对 方 %d 个 回 合。 沉 默 几 率 随 命 中 增 长。 ]])
		:format(self:combatTalentWeaponDamage(t, 0.9, 1.7) * 100, t.getDur(self,t))
	end,
}


return _M
