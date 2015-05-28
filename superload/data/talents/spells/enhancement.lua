local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FIERY_HANDS",
	name = "燃烧之手",
	info = function(self, t)
		local firedamage = t.getFireDamage(self, t)
		local firedamageinc = t.getFireDamageIncrease(self, t)
		return ([[你 的 双 手 笼 罩 在 火 焰 中， 每 次 近 战 攻 击 会 造 成 %0.2f 火 焰 伤 害 并 提 高 所 有 火 焰 伤 害 %d%% 。 
		 每 次 攻 击 同 时 也 会 回 复 %0.2f 体 力 值。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, firedamage), firedamageinc, self:getTalentLevel(t) / 3)
	end,
}

registerTalentTranslation{
	id = "T_EARTHEN_BARRIER",
	name = "土质屏障",
	info = function(self, t)
		local reduction = t.getPhysicalReduction(self, t)
		return ([[运 用 土 壤 的 力 量 增 强 你 的 皮 肤， 减 少 %d%% 所 承 受 物 理 伤 害， 持 续 10 回 合。 
		 受 法 术 强 度 影 响， 伤 害 减 免 有 额 外 加 成。]]):
		format(reduction)
	end,
}

registerTalentTranslation{
	id = "T_SHOCK_HANDS",
	name = "闪电之触",
	info = function(self, t)
		local icedamage = t.getIceDamage(self, t)
		local icedamageinc = t.getIceDamageIncrease(self, t)
		return ([[你 的 双 手 笼 罩 在 雷 电 中， 每 次 近 战 攻 击 会 造 成 %d 闪 电 伤 害（ 25%% 几 率 眩 晕 敌 人）， 并 提 高 %d%% 所 有 闪 电 系 伤 害。 
		 每 次 攻 击 同 时 也 会 回 复 %0.2f 法 力 值。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.LIGHTNING, icedamage), icedamageinc, self:getTalentLevel(t) / 3)
	end,
}

registerTalentTranslation{
	id = "T_INNER_POWER",
	name = "心灵之力",
	info = function(self, t)
		local statinc = t.getStatIncrease(self, t)
		return ([[你 专 注 于 你 的 内 心， 增 加 你 %d 点 所 有 属 性。 
		 受 法 术 强 度 影 响， 属 性 有 额 外 加 成。]]):
		format(statinc)
	end,
}


return _M
