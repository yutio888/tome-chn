local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_VILE_POISONS",
	name = "涂毒",
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
		 每 次 你 击 中 目 标 时， 你 有 %d%% 概 率 使 目 标 随 机 感 染 已 使 用 的 2 种 毒 素 之 一。 
		 如 果 目 标 已 经 处 于 中 毒 状 态， 则 目 标 再 次 中 毒 的 概 率 降 低。]]):
		format(self:getTalentLevel(t) * 20, 20 + self:getTalentLevel(t) * 5)
	end,
}

registerTalentTranslation{
	id = "T_VENOMOUS_STRIKE",
	name = "毒素爆发",
	info = function(self, t)
		local dam0 = 100 * self:combatTalentWeaponDamage(t, 0.5, 0.9)
		local dam1 = 100 * self:combatTalentWeaponDamage(t, 0.5 + 0.6,   0.9 + 1)
		local dam2 = 100 * self:combatTalentWeaponDamage(t, 0.5 + 0.6*2, 0.9 + 1*2)
		local dam3 = 100 * self:combatTalentWeaponDamage(t, 0.5 + 0.6*3, 0.9 + 1*3)
		return ([[你 击 中 目 标 并 造 成 一 定 的 自 然 伤 害， 伤 害 值 取 决 于 目 标 身 上 的 中 毒 种 类。 
		- 0 毒 素： %d%%
		- 1 毒 素： %d%%
		- 2 毒 素： %d%%
		- 3 毒 素： %d%%
		如 果 你 装 备 有 弓 或 投 石 索， 你 会 射 击 目 标。 
		]]):
		format(dam0, dam1, dam2, dam3)
	end,
}

registerTalentTranslation{
	id = "T_EMPOWER_POISONS",
	name = "强化毒素",
	info = function(self, t)
		return ([[减 少 所 有 毒 药 50%% 的 持 续 时 间 但 增 加 它 们 %d%% 伤 害。 
		 受 灵 巧 影 响， 效 果 有 额 外 加 成。]]):
		format(100 + self:combatTalentStatDamage(t, "cun", 40, 250))
	end,
}

registerTalentTranslation{
	id = "T_TOXIC_DEATH",
	name = "致命毒素",
	info = function(self, t)
		return ([[当 你 杀 死 携 带 毒 素 的 生 物 时，有 %d%% 几 率 将 毒 素 传 播 至 %d 半 径 内 的 目 标 .]]):format(20 + self:getTalentLevelRaw(t) * 8, t.getRadius(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DEADLY_POISON",
	name = "致命毒剂",
	info = function(self, t)
		return ([[在 你 的 武 器 上 涂 上 致 命 毒 剂， 造 成 每 轮 %d 点 自 然 伤 害， 持 续 %d 轮。 
		 受 灵 巧 影 响， 伤 害 按 比 例 加 成。 
		 毒 素 效 果 可 叠 加。]]):
		format(damDesc(self, DamageType.NATURE, t.getDOT(self, t)), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_NUMBING_POISON",
	name = "麻木毒剂",
	info = function(self, t)
		return ([[在 你 的 武 器 上 涂 上 麻 木 毒 剂， 造 成 每 轮 %d 点 自 然 伤 害 持 续 %d 回 合。 
		 中 毒 目 标 造 成 的 伤 害 降 低 %d%% 。 
		 受 灵 巧 影 响， 效 果 按 比 例 加 成。]]):
		format(damDesc(self, DamageType.NATURE, t.getDOT(self, t)), t.getDuration(self, t), t.getEffect(self, t))
	end,
}

registerTalentTranslation{
	id = "T_INSIDIOUS_POISON",
	name = "阴险毒剂",
	info = function(self, t)
		return ([[在 你 的 武 器 上 涂 上 阴 险 毒 剂， 造 成 每 轮 %d 点 自 然 伤 害 持 续 %d 回 合。 
		 中 毒 目 标 受 到 的 治 疗 效 果 减 少 %d%% 。 
		 受 灵 巧 影 响， 效 果 按 比 例 加 成。]]):
		format(damDesc(self, DamageType.NATURE, t.getDOT(self, t)), t.getDuration(self, t), t.getEffect(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CRIPPLING_POISON",
	name = "致残毒剂",
	info = function(self, t)
		return ([[在 你 的 武 器 上 涂 上 致 残 毒 剂， 造 成 每 轮 %d 点 自 然 伤 害 持 续 %d 回 合。 
		 中 毒 目 标 每 次 使 用 技 能 都 有 %d%% 概 率 失 败 并 流 失 1 回 合 时 间。 
		 受 灵 巧 影 响， 伤 害 按 比 例 加 成。]]):
		format(damDesc(self, DamageType.NATURE, t.getDOT(self, t)), t.getDuration(self, t), t.getEffect(self, t))
	end,
}

registerTalentTranslation{
	id = "T_STONING_POISON",
	name = "石化毒剂",
	info = function(self, t)
		return ([[在 你 的 武 器 上 涂 上 石 化 毒 剂， 造 成 每 轮 %d 点 自 然 伤 害 持 续 %d 回 合。 
		 毒 素 效 果 结 束 后 目 标 将 被 石 化 %d 回 合。 
		 受 灵 巧 影 响， 伤 害 按 比 例 加 成。]]):
		format(damDesc(self, DamageType.NATURE, t.getDOT(self, t)), t.getDuration(self, t), t.getEffect(self, t))
	end,
}

registerTalentTranslation{
	id = "T_VULNERABILITY_POISON",
	name = "奥术毒剂",
	info = function(self, t)
		return ([[在 你 的 武 器 上 涂 上 奥 术 毒 剂， 造 成 每 轮 %d 点 奥 术 伤 害 持 续 %d 回 合。 
		 目 标 的 所 有 抵 抗 将 被 减 少 %d%% 。 
		 受 灵 巧 影 响， 伤 害 按 比 例 加 成。]]):
		format(damDesc(self, DamageType.NATURE, t.getDOT(self, t)), t.getDuration(self, t), t.getEffect(self, t))
	end,
}





return _M
