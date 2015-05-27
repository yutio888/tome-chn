local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ARCANE_COMBAT",
	name = "奥术武器",
	info = function(self, t)
		return ([[允 许 你 使 用 近 战 武 器 附 魔 法 术。 在 你 每 次 的 近 战 攻 击 中 都 有 %d%% 概 率 附 加 一 次 火 球 术、 闪 电 术 或 岩 石 飞 弹 。 
		当 双 持 或 持 有 盾 牌 时， 此 效 果 对 每 一 个 武 器 均 可 触 发， 但 触 发 概 率 减 少。 
		通 过 这 种 方 式 触 发 的 法 术 不 会 造 成 对 应 技 能 进 入 CD 状 态， 但 是 只 有 在 对 应 技 能 未 冷 却 时 才 可 以 触 发。 
		受 灵 巧 影 响， 触 发 概 率 有 额 外 加 成。 ]]):
		format(t.getChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ARCANE_CUNNING",
	name = "奥术灵巧",
	info = function(self, t)
		return ([[你 额 外 增 加 相 当 于 你 %d%% 灵 巧 值 的 法 术 强 度。]]):
		format(t.getSpellpower(self,t))
	end,
}

registerTalentTranslation{
	id = "T_ARCANE_FEED",
	name = "奥术充能",
	info = function(self, t)
		return ([[当 技 能 激 活 时， 每 回 合 恢 复 %0.2f 法 力 值 并 提 高 %d%% 物 理 及 法 术 爆 击 几 率。]]):format(t.getManaRegen(self, t), t.getCritChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ARCANE_DESTRUCTION",
	name = "奥术毁灭",
	info = function(self, t)
		return ([[通 过 你 的 武 器 来 传 送 原 始 的 魔 法 伤 害。 增 加 %d 点 物 理 强 度。 
		每 当 你 近 战 攻 击 暴 击 时， 你 会 释 放 一 个 半 径 为 %d 码 的 火 属 性、 电 属 性 或 奥 术 属 性 的 魔 法 球， 造 成 %0.2f 的 伤 害。 
		受 法 术 强 度 影 响， 增 益 按 比 例 加 成。]]):
		format(self:combatSpellpower() * t.getSPMult(self, t), self:getTalentRadius(t), self:combatSpellpower() * 2)
	end,
}

