local _M = loadPrevious(...)


registerTalentTranslation{
	id = "T_GLYPH_OF_EXPLOSION",
	name = "爆炸圣印",
	info = function(self, t)
		return ([[测试圣印]]):
		format()
	end,
}


registerTalentTranslation{
	id = "T_GLYPH_OF_PARALYSIS",
	name = "麻痹圣印",
	info = function(self, t)
		local dazeduration = t.getDazeDuration(self, t)
		local duration = t.getDuration(self, t)
		return ([[你用光能在地上刻画圣印。所有经过的目标会被眩晕 %d 回合。 
		 圣印视为隐藏陷阱（ %d 侦查强度 , %d 点解除强度 , 基于魔法）持续 %d 回合。]]):format(dazeduration, t.trapPower(self,t)*0.8, t.trapPower(self,t), duration)
	end,
}

registerTalentTranslation{
	id = "T_GLYPH_OF_REPULSION",
	name = "冲击圣印",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[你用光能在地上刻画圣印。所有经过的目标会受到 %0.2f 伤害并被击退。 
		 圣印视为隐藏陷阱（ %d 侦查强度 , %d 点解除强度 , 基于魔法）持续 %d 回合。 
		 受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.PHYSICAL, damage), t.trapPower(self, t)*0.8, t.trapPower(self, t), duration)
	end,
}


registerTalentTranslation{
	id = "T_GLYPH_OF_FATIGUE",
	name = "疲劳圣印",
	info = function(self, t)
		local slow = t.getSlow(self, t)
		local duration = t.getDuration(self, t)
		return ([[你用光能在地上刻画圣印。所有经过的目标会减速 %d%% ，持续 5 回合。 
		 圣印视为隐藏陷阱（ %d 侦查强度 , %d 点解除强度 , 基于魔法）持续 %d 回合。]]):
		format(100 * slow, t.trapPower(self, t), t.trapPower(self, t), duration)
	end,
}

return _M
