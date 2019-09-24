local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ARCANE_STRIKE",
	name = "奥术打击",
	info = function(self, t)
		return ([[使用你的主手武器打击两次目标，造成%d%% 奥术伤害。
		如果任何一击命中目标，你获得 %d 法力值。
		法力值恢复受法术强度加成。]]):
		format(t.getDamage(self, t)*100, t.getMana(self, t))
	end,
}

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
		local absorb = t.getShield(self, t) * (100 + (self:attr("shield_factor") or 0)) / 100
		return ([[你 专 注 于 你 的 内 心， 增 加 你 %d 点力量，敏捷，魔法和灵巧。
		在你受到伤害前，你会产生一个吸收%d伤害的护盾，该效果最多每%d回合触发一次。
		属性值增长和护盾强度受法术强度加成。]]):
		format(statinc, absorb, self:getTalentCooldown(t) )
	end,
}


return _M
