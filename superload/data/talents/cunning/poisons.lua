local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_APPLY_POISON",
	name = "涂毒",
	info = function (self,t)
		return ([[学 会 如 何 在 近 战 武 器 、飞 刀 、弹 药 上 涂 毒 ，命 中 后 有  %d%%  几 率 使 目 标 中 毒 ，每 回 合 受 到 %d  自 然 伤 害 ，持 续 %d  回 合 。毒 素 效 果 可 以 叠 加 至 %d  伤 害 每 回 合 。
		 伤 害 受 灵 巧 加 成 。]]):
		format(t.getChance(self,t), damDesc(self, DamageType.NATURE, t.getDamage(self, t)), t.getDuration(self, t), damDesc(self, DamageType.NATURE, t.getDamage(self, t)*4))
	end,
}
registerTalentTranslation{
	id = "T_TOXIC_DEATH",
	name = "致命毒素",
	info = function(self, t)
		return ([[当 你 杀 死 携 带 毒 素 的 生 物 时，将 毒 素 传 播 至 %d 半 径 内 的 敌 人 .]]):format(t.getRadius(self, t))
	end,
}

registerTalentTranslation{
	id = "T_VILE_POISONS",
	name = "邪恶毒素",
	info = function(self, t)
		return ([[你 学 会 如 何 在 近 战 武 器, 长 弓 和 投 石 索 的 弹 药 上 涂 毒。 每 等 级 你 将 会 学 到 新 的 毒 剂。 
		 等 级 1 ： 致 命 毒 剂 
		 等 级 2 ： 麻 木 毒 剂 
		 等 级 3 ： 阴 险 毒 剂 
		 等 级 4 ： 致 残 毒 剂 
		 等 级 5 ： 石 化 毒 剂 
		 同 时 你 还 可 以 向 世 界 上 特 定 的 人 学 习 新 毒 剂。 
		 同 时 提 高 你 %d%% 的 毒 素 效 果。（ 此 效 果 对 每 个 毒 剂 都 有 改 变） 
		 在 你 的 武 器 上 涂 毒 不 会 打 破 潜 行 状 态。 
		 每 次 只 能 同 时 使 用 2 种 毒 剂。 
		 如 果 目 标 已 经 处 于 中 毒 状 态， 则 目 标 再 次 中 毒 的 概 率 降 低。]]):
		format(self:getTalentLevel(t) * 20)
	end,
}

registerTalentTranslation{
	id = "T_VENOMOUS_STRIKE",
	name = "毒素爆发",
	effectsDescription = function(self, t)
		local power = t.getPower(self,t)
		local idam = t.getSecondaryDamage(self,t)
		local nb = t.getNb(self,t)
		local heal = t.getSecondaryDamage(self,t)
		local vdam = t.getSecondaryDamage(self,t)*0.6
		return ([[麻木毒素 - 整体速度减少 %d%% ，持续5回合。
		阴险毒素 - 在 5 回合内 造成 %0.2f 自然伤害。
		致残毒素 - 令 %d 个 技能 进入 %d 回合 冷却。
		水蛭毒素 - 自己获得 %d 治疗。
		传染毒素 - 额外 %0.2f 自然伤害，伤害半径 %d 。
		]]):
		format(power*100, damDesc(self, DamageType.NATURE, idam), nb, math.floor(nb*1.5), heal, damDesc(self, DamageType.NATURE, vdam), nb)
	end,
	info = function(self, t)
		local dam = 100 * t.getDamage(self,t)
		local desc = t.effectsDescription(self, t)
		return ([[你 攻 击 目 标 ，造 成  %d%%  自 然 武 器 伤 害 ，并 基 于 目 标 当 前 毒 素 触 发 额 外 效 果 :
		 
		%s 
		 学 习 该 技 能 后 ，你 能 学 习 剧 毒 飞 刀 ，但 使 用 该 技 能 会 使 其 进 入 冷 却 。
		]]):
		format(dam, desc)
	end,
}
registerTalentTranslation{
	id = "T_NUMBING_POISON",
	name = "麻木毒剂",
	info = function(self, t)
		return ([[在 你 的 武 器 上 涂 上 麻 木 毒 剂，  中 毒 目 标 造 成 的 伤 害 降 低 %d%% 。 ]]):
	format(t.getEffect(self, t))
	end,
}
registerTalentTranslation{
	id = "T_INSIDIOUS_POISON",
	name = "阴险毒剂",
	info = function(self, t)
		return ([[在 你 的 武 器 上 涂 上 阴 险 毒 剂，  中 毒 目 标 受 到 的 治 疗 效 果 减 少 %d%% 。 ]]):
	format(t.getEffect(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CRIPPLING_POISON",
	name = "致残毒剂",
	info = function(self, t)
		return ([[在 你 的 武 器 上 涂 上 致 残 毒 剂, 中 毒 目 标 每 次 使 用 技 能 都 有 %d%% 概 率 失 败 并 流 失 1 回 合 时 间。 ]]):
	format(t.getEffect(self, t))
	end,
}
registerTalentTranslation{
	id = "T_LEECHING_POISON",
	name = "水蛭毒素",
	info = function (self,t)
	return ([[在 你 的 武 器 上 涂 上 水 蛭 毒 剂, 你 受 到 中 毒 伤 害 %d%% 的 治 疗。]]):
	format(t.getEffect(self, t))
	end,
}
registerTalentTranslation{
	id = "T_VOLATILE_POISON",
	name = "传染毒素",
	info = function (self,t)
	return ([[在 你 的 武 器 上 涂 上 传 染 毒 剂, 毒 素 造 成 额 外 %d%% 伤害，且 会 对 周 围 敌 人 造 成 伤 害 。]]):
	format(t.getEffect(self, t))
	end,
}

registerTalentTranslation{
	id = "T_VULNERABILITY_POISON",
	name = "奥术毒剂",
	info = function(self, t)
		return ([[在 你 的 武 器 上 涂 上 奥 术 毒 剂， 每 回 合 造 成 每 轮 %0.2f 点 奥 术 伤 害 且 所 有 伤 害 抗 性 将 被 减 少 10%% ，毒 素 免 疫 减 少 50%% 。 ]]):
	format(damDesc(self, DamageType.ARCANE, t.getDamage(self,t)))
	end,
}

registerTalentTranslation{
	id = "T_STONING_POISON",
	name = "石化毒剂",
	info = function(self, t)
		local dam = damDesc(self, DamageType.NATURE, t.getDOT(self, t))
		return ([[在 你 的 武 器 上 涂 上 石 化 毒 剂，额 外 造 成 每 轮 %d 点 自 然 伤 害（可 叠 加 至 %d），持 续 %d 回 合。 。 
		 %d 回 合 后 或 者 毒 素 效 果 结 束 后 目 标 将 被 石 化 %d 回 合。 
		 受 灵 巧 影 响， 伤 害 按 比 例 加 成。]]):
		format(dam, dam*4, t.getDuration(self, t), t.stoneTime(self, t), t.getEffect(self, t))
	end,
}



return _M
