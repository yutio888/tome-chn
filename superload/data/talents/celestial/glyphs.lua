local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GLYPHS",
	name = "圣印",
	info = function(self, t)
		local dam = t.getGlyphDam(self, t)
		local heal = t.getSunlightHeal(self, t)
		local numb = t.getMoonlightNumb(self, t)
		local numbDur = t.getMoonlightNumbDur(self, t)
		local dist = t.getTwilightKnockback(self, t)
		return ([[当你法术暴击时，你消耗5点正能量和负能量，在范围%d内的随机目标周围1半径的区域内放置随机圣印。
		圣印持续%d回合，当敌人踩上时，会对其产生特殊效果。
		圣印只会在周围没有圣印的敌人周围产生，并且会尽可能在你的周围产生。
		这一效果最多每%d游戏回合触发一次。
		圣印效果随法术强度提升。
		
		可用的圣印如下所示：
		阳光圣印——将阳光注入圣印。当其触发时，将会释放出明亮的光辉，造成%0.2f光系伤害，并恢复你%d生命值。
		月光圣印——将月光注入圣印。当其触发时，将会释放出让人疲劳的黑暗，造成%0.2f暗影伤害，并使目标所造成的伤害减少%d%%，持续%d回合。
		暮光圣印——将暮光注入圣印。当其出发时，将会释放出一团暮光，造成%0.2f光系和%0.2f暗影伤害，并将目标击退%d格。
		]]):format(self:getTalentRange(t), t.getDuration(self, t), t.getGlyphCD(self, t), 
			damDesc(self, DamageType.LIGHT, dam), heal,
			damDesc(self, DamageType.DARKNESS, dam), numb, numbDur,
			damDesc(self, DamageType.LIGHT, dam/2), damDesc(self, DamageType.DARKNESS, dam/2), dist)
	end,
}
registerTalentTranslation{
	id = "T_GLYPHS_OF_FURY",
	name = "愤怒圣印",
	info = function(self, t)
		local dam = t.getTriggerDam(self, t)
		return ([[你的圣印注入了星空之怒。它们的持续时间将会延长 %d 个回合，并在触发时造成伤害。
		阳光圣印：造成%0.2f光系伤害。
		月光圣印：造成%0.2f暗影伤害。
		暮光圣印：造成%0.2f光系和%0.2f暗影伤害。]]):format(t.getPersistentDuration(self, t), damDesc(self, DamageType.LIGHT, dam), damDesc(self, DamageType.DARKNESS, dam), damDesc(self, DamageType.LIGHT, dam/2), damDesc(self, DamageType.DARKNESS, dam/2))
	end,
}
registerTalentTranslation{
	id = "T_DIVINE_GLYPHS",
	name = "神圣之印",
	info = function(self, t)
		return ([[当你的圣印触发时，你将会获得一层星空能量的潮涌，增加你的暗影、光系抵抗和伤害吸收各%5%%，持续%d回合，最多叠加%d次。该效果每回合最多触发3次。]]):format(t.getTurns(self, t), t.getMaxStacks(self, t))
	end,
}
registerTalentTranslation{
	id = "T_TWILIGHT_GLYPH",
	name = "圣印之暮",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[将暮光能量注入圣印，使其消失并立刻造成%d光系或%d暗影伤害。
		你可以连续使用%d次该技能而不会使技能进入冷却，但每次使用都会增加其冷却时间2回合。当触发次数满，或你在1回合内没有使用这个技能，这个技能将会立刻进入冷却。]]):format(damDesc(self, DamageType.LIGHT, dam), damDesc(self, DamageType.DARKNESS, dam), t.getConsecutiveTurns(self, t))
	end,
}
return _M
