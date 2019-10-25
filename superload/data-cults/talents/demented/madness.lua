local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_DARK_WHISPERS",
	name = "黑暗低语",
	info = function(self, t)
		local dam = t.getDamage(self,t)
		local stat = t.getPowerLoss(self,t)
		local rad = self:getTalentRadius(t)
		return ([[令半径 %d 格内的敌人的心灵里充满可怕的幻觉和疯狂的低语， 5 回合内每回合受到 %0.2f 暗影伤害。同时，该效果将降低其物理、法术和精神强度 %d 点，该效果可叠加至最多 %d 点。
		技能效果受法术强度加成。]]):
		format(rad, damDesc(self, DamageType.DARKNESS, dam), stat, stat*3)
	end,
}

registerTalentTranslation{
	id = "T_HIDEOUS_VISIONS",
	name = "惊骇幻象",
	info = function(self, t)
		local chance = t.getChance(self,t)
		local dur = t.getDuration(self,t)
		local damage = t.getDamageReduction(self,t)
		return ([[每次敌人受到黑暗低语的伤害时，有 %d%% 几率在视野内产生持续 %d 回合的幻象。幻象不能行动，但被影响的敌人在幻象结束前造成的伤害降低 %d%% 。
		同一敌人同时只能产生一个幻象。]]):
		format(chance, dur, damage)
	end,
}

registerTalentTranslation{
	id = "T_SANITY_WARP",
	name = "失智冲击",
	info = function(self, t)
		local dam = t.getDamage(self,t)
		local radius = self:getTalentRadius(t)
		return ([[每当幻象被消灭时，它将释放心灵冲击，对 %d 格内的敌人造成 %0.2f 暗影伤害。]]):
		format(radius,damDesc(self, DamageType.DARKNESS, dam))
	end,
}

registerTalentTranslation{
	id = "T_CACOPHONY",
	name = "心灵尖啸",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local dur = t.getDuration(self,t)
		local dam = t.getDamage(self,t)*100
		return ([[ 使 %d 格内的黑暗低语音量提升 %d 回合，达到震耳欲聋的地步，额外施加一层低语效果，同时干扰一切思考能力。
		被黑暗低语影响的目标产生幻象的几率增加 20%% ，每次受到黑暗低语或失智冲击的伤害时，会受到额外 %d%% 时空伤害。
		伤害受法术强度加成。]]):format(rad, dur, dam)
	end,
}

return _M
