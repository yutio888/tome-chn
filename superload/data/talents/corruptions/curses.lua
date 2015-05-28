local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CURSE_OF_DEFENSELESSNESS",
	name = "衰竭诅咒",
	info = function(self, t)
		return ([[诅 咒 目 标， 减 少 它 %d 点 闪 避 和 所 有 豁 免， 持 续 10 回 合。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):format(self:combatTalentSpellDamage(t, 30, 60))
	end,
}

registerTalentTranslation{
	id = "T_CURSE_OF_IMPOTENCE",
	name = "虚弱诅咒",
	info = function(self, t)
		return ([[诅 咒 目 标， 减 少 它 %d%% 所 有 伤 害， 持 续 10 回 合。 
		 受 法 术 强 度 影 响， 伤 害 值 有 额 外 减 少。]]):format(t.imppower(self,t))
	end,
}

registerTalentTranslation{
	id = "T_CURSE_OF_DEATH",
	name = "死亡诅咒",
	info = function(self, t)
		return ([[诅 咒 目 标， 中 断 任 何 自 然 治 疗。 每 回 合 造 成 %0.2f 暗 影 伤 害， 持 续 10 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.DARKNESS, self:combatTalentSpellDamage(t, 10, 70)))
	end,
}

registerTalentTranslation{
	id = "T_CURSE_OF_VULNERABILITY",
	name = "弱点诅咒",
	info = function(self, t)
		return ([[诅 咒 目 标， 减 少 其 %d%% 所 有 抵 抗， 持 续 7 回 合。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):format(self:combatTalentSpellDamage(t, 10, 40))
	end,
}



return _M
