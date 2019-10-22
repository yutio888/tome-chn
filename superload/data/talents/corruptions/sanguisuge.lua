local _M = loadPrevious(...)

registerTalentTranslation{
    id = "T_DRAIN",
    name = "枯萎吸收",
	info = function(self, t)
		return ([[射出 1 枚枯萎之球，对目标造成 %0.2f 枯萎伤害。同时补充 20%% 伤害值作为活力。 
		活力回复量受目标分级影响（高级怪提供更多活力）。 
		受法术强度影响，效果有额外加成。]]):
		format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 25, 200)))
	end,
}

registerTalentTranslation{
    id = "T_BLOODCASTING",
    name = "血祭施法",
	info = function(self, t)
		return ([[使用生命值取代活力值释放技能时，生命值消耗减少到  %d%% 。]]):
		format(t.getLifeCost(self,t))
	end,
}

registerTalentTranslation{
    id = "T_ABSORB_LIFE",
    name = "生命吞噬",
	info = function(self, t)
		return ([[当你杀死敌人时，你会吸收目标生命。 
		当此技能激活时，每回合会消耗 0.5 点活力；当你杀死一个非不死族单位时，会获得 %0.1f 点活力（此外自然增长受意志影响）。]]):
		format(t.VimOnDeath(self, t))
	end,
}

registerTalentTranslation{
    id = "T_LIFE_TAP",
    name = "生命源泉",
	info = function(self, t)
		return ([[从你对敌人的痛苦中汲取力量。
		在 2 回合内，你的所有伤害获得  %d%%  的吸血。
		吸血比例受法术强度加成。]]):
		format(t.getMult(self,t))
	end,
}

return _M
