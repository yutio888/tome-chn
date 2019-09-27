local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DRACONIC_WILL",
	name = "龙族意志",
	["require.special.desc"] = "熟悉龙之世界",
	info = function(self, t)
		return ([[你 的 身 体 如 巨 龙 般 强 韧， 可 以 轻 易 抵 抗 负 面 效 果。 
		在 5 回 合 内 对 负 面 效 果 免 疫。]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_METEORIC_CRASH",
	name = "落星",
	["require.special.desc"] = "曾亲眼目睹过陨石坠落",
	info = function(self, t)
		local dam = t.getDamage(self, t)/2
		return ([[在 施 展 伤 害 类 魔 法 或 精 神 攻 击 时， 你 会 释 放 意 念， 召 唤 一 颗 陨 石 砸 向 附 近 敌 人。 
		陨石在2码半径内造成%0.2f 火焰和%0.2f 物理伤害，震慑敌人3回合。
		周围3码半径内将会被冲击转换成岩浆，每回合造成%0.2f 火焰伤害，持续8回合。这会改变地形。
		你和你的盟友不会受到陨石的伤害。

		另外，你的火焰伤害加成和穿透将被设置成你最高的伤害加成和穿透，这对你造成的所有火焰伤害都有效。
		受 精 神 强 度 或 法 术 强 度 影 响， 伤 害 按 比 例 加 成。  ]])
		:format(damDesc(self, DamageType.FIRE, dam), damDesc(self, DamageType.PHYSICAL, dam), damDesc(self, DamageType.FIRE, t.getLava(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_GARKUL_S_REVENGE",
	name = "加库尔的复仇",
	["require.special.desc"] = "装备加库尔的两件宝物并且了解加库尔的一生",
	info = function(self, t)
		return ([[加 库 尔 之 魂 与 你 同 在， 你 现 在 能 对 建 筑 类 造 成 1000％ 额 外 伤 害， 对 人 形 生 物 和 巨 人 造 成 20％ 额 外 伤 害。  ]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_HIDDEN_RESOURCES",
	name = "潜能爆发",
	["require.special.desc"] = "曾 获 得 千 钧 一 发 成 就（ 在 低 于 1HP 情 况 下 杀 死 1 个 敌 人）",
	info = function(self, t)
		return ([[在 严 峻 的 形 势 面 前， 你 集 中 意 念 进 入 心 如 止 水 的 状 态。 
		在 5 回 合 内， 所 有 技 能 不 消 耗 任 何 能 量。  ]])
		:format()
	end,
}


registerTalentTranslation{
	id = "T_LUCKY_DAY",
	name = "幸运日",
	["require.special.desc"] = "拥有大运气。（至少有+5luck属性）",
	info = function(self, t)
		return ([[每 天 都 是 幸 运 日。 幸 运 永 久 +40，有 10%% 几 率 闪 避 所 有 攻 击。  ]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_UNBREAKABLE_WILL",
	name = "坚定意志",
	info = function(self, t)
		return ([[你 的 意 志 如 此 坚 定， 可 以 忽 视 对 你 造 成 的 精 神 效 果。 
	 	这一技能最多每5回合触发一次。]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_SPELL_FEEDBACK",
	name = "法术反馈",
	["require.special.desc"] = "习得反魔技能",
	info = function(self, t)
		return ([[你 的 意 志 是 对 抗 邪 恶 魔 法 师 的 盾 牌。 
		每 当 你 受 到 魔 法 伤 害， 你 会 惩 罚 施 法 者， 使 其 受 到 %0.2f 的 精 神 伤 害。 
		同 时， 它 们 在 对 你 使 用 的 技 能 进 入 冷 却 的 回 合 中， 会 受 到 35％ 法 术 失 败 率 惩 罚。
		注 意 ： 该 技 能 有 冷 却 时 间。 ]])
		:format(damDesc(self, DamageType.MIND, 20 + self:getWil() * 2))
	end,
}

registerTalentTranslation{
	id = "T_MENTAL_TYRANNY",
	name = "灵魂之怒",
	["require.special.desc"] = "曾造成50000点精神伤害",
	info = function(self, t)
		return ([[用 钢 铁 般 的 意 志 驱 使 整 个 身 体。 
		当 此 技 能 激 活 时， 你 33%% 的 伤 害 会 转 化 为 精 神 伤 害。 
		此 外， 你 获 得 30％ 精 神 抵 抗 穿 透 并 增 加 10％ 精 神 伤 害。 ]]):
		format()
	end,
}

return _M
