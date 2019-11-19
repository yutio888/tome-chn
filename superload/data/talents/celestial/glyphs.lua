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
		return ([[每当你的法术暴击时，你消耗 5 点正能量和负能量，在范围 %d 内的随机目标周围 1 码半径的区域内放置随机圣印。
		圣印持续 %d 回合，当敌人踩上时，会对其产生特殊效果。
		圣印只会在周围没有圣印的敌人周围产生，并且会尽可能在你的周围产生。
		每 %d 游戏回合最多触发一次该效果。
		圣印效果受法术强度加成。
		
		有以下几种可用的圣印：
		#ffd700#日光圣印#LAST#——将阳光注入圣印。当其触发时，将会释放出明亮耀眼的光芒，造成 %0.2f 光系伤害，并恢复你 %d 生命值。
		#7f7f7f#月光圣印#LAST#——将月光注入圣印。当其触发时，将会释放出疲惫困倦的黑暗，造成 %0.2f 暗影伤害，并使目标所造成的伤害减少 %d%% ，持续 %d 回合。
		#9D9DC9#暮光圣印#LAST#——将暮光注入圣印。当其触发时，将会释放出突然爆炸的暮光，造成 %0.2f 光系和 %0.2f 暗影伤害，并将目标击退 %d 格。
		]]):format(self:getTalentRange(t), t.getDuration(self, t), t.getGlyphCD(self, t), 
			damDesc(self, DamageType.LIGHT, dam), heal,
			damDesc(self, DamageType.DARKNESS, dam), numb, numbDur,
			damDesc(self, DamageType.LIGHT, dam/2), damDesc(self, DamageType.DARKNESS, dam/2), dist)
	end,
}
registerTalentTranslation{
	id = "T_GLYPHS_OF_FURY",
	name = "愤怒之印",
	info = function(self, t)
		local dam = t.getTriggerDam(self, t)
		return ([[你的圣印被注入了来自天空的怒火。
		它们的持续时间延长 %d 回合，并在触发时造成额外伤害。
		日光圣印：造成 %0.2f 光系伤害。
		月光圣印：造成 %0.2f 暗影伤害。
		暮光圣印：造成 %0.2f 光系和 %0.2f 暗影伤害。]]):format(t.getPersistentDuration(self, t), damDesc(self, DamageType.LIGHT, dam), damDesc(self, DamageType.DARKNESS, dam), damDesc(self, DamageType.LIGHT, dam/2), damDesc(self, DamageType.DARKNESS, dam/2))
	end,
}
registerTalentTranslation{
	id = "T_DIVINE_GLYPHS",
	name = "充能之印",
	info = function(self, t)
		return ([[当你的圣印触发时，天空能量的涌动让你获得暗影、光系抗性和伤害吸收各 5%% ，持续 %d 回合，最多叠加 %d 次。该效果每回合最多触发 3 次。]]):format(t.getTurns(self, t), t.getMaxStacks(self, t))
	end,
}
registerTalentTranslation{
	id = "T_TWILIGHT_GLYPH",
	name = "激发圣印",
		info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[激发所有圣印，10格内所有上方站着敌人的圣印将被触发。
		技能等级2时，该效果触发的圣印将在地面遗留能量，在%d回合内持续造成伤害。
		#ffd700#日光圣印#LAST#:  %0.2f 光系伤害。
		#7f7f7f#月光圣印#LAST#:  %0.2f 暗影伤害。
		#9D9DC9#暮光圣印#LAST#:  %0.2f 光系和 %0.2f 暗影伤害。]]):format(t.getDuration(self, t), damDesc(self, DamageType.LIGHT, dam), damDesc(self, DamageType.DARKNESS, dam), damDesc(self, DamageType.LIGHT, dam/2), damDesc(self, DamageType.DARKNESS, dam/2))
	end,
}
return _M
