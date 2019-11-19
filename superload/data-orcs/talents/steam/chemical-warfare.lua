local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MIASMA_ENGINE",
	name = "瘴气引擎",
	info = function(self, t)
		local rad = t.getMax(self, t)
		local chance = t.getChance(self,t)
		local heal = t.getHealing(self,t)
		local dam = t.getDamage(self,t)
		return ([[你使用你的蒸汽机，在你的周围产生一股有毒且有腐蚀性的化学物质形成的云雾。
		每当你使用一个非瞬发的蒸汽科技技能的时候，你会在周围产生半径为 3 码的瘴气，持续 5 回合。所有被包裹入瘴气的敌人治疗效果减少 %d%% ，且会有 %d%% 的几率使用技能失败。
		瘴气效果叠加的时候，这一技能使用失败的几率也会上升，最多叠加五次，达到 %d%% 。
		当被瘴气影响的目标每回合第一次被近战或远程攻击击中的时候，瘴气会渗入他们的伤害，造成 %0.2f 额外的酸性伤害。
		瘴气效果叠加的时候，持续时间不会叠加。
		当一个生物在瘴气效果中存活下来后，它会免疫瘴气效果 9 回合。]]):
		format(heal, chance / 5, chance, damDesc(self, DamageType.ACID, dam), rad)
	end,
}

registerTalentTranslation{
	id = "T_CAUSTIC_DISPERSAL",
	name = "腐蚀扩散",
	info = function(self, t)
		local dam = t.getDamage(self,t)*100
		local rad = self:getTalentRadius(t)
		local dur = t.getDuration(self,t)
		return ([[你发射一枚毒气弹，在半径 %d 码范围内爆炸，造成 %d%% 酸性武器伤害，并留下一团瘴气，持续 %d 回合。瘴气效果继承你瘴气引擎技能的一切效果。]]):
		format(rad, dam, dur)
	end,
}

registerTalentTranslation{
	id = "T_SMOGSCREEN",
	name = "蔽目毒云",
	info = function(self, t)
		local evade = t.getEvade(self,t)
		local evades = t.getEvadeStacks(self,t)
		return ([[在你的瘴气引擎造成的浓雾中，敌人更难击中你了。当你被瘴气包裹的时候，你有 %d%% 的几率完全闪避伤害。瘴气的半径每叠加一层，则效果增加 %d%% 。]]):
		format(evade, evades)
	end,
}

registerTalentTranslation{
	id = "T_FUMIGATE",
	name = "毒气熏杀",
	info = function(self, t)
		local dam = t.getDamage(self,t)*100
		local rad = self:getTalentRadius(t)
		local chance = t.getChance(self,t)
		return ([[你消耗所有瘴气引擎的叠加效果，并用你的蒸汽枪发射出毁灭性的腐蚀爆炸，在 %d 码范围的扇形区域内造成 %d%% 酸性武器伤害，并有 %d%% 的几率移除一个随机物理或精神效果。你瘴气引擎叠加的层数每超过一层，则增加 50%% 伤害，并有 %d%% 几率额外移除一个效果。
		你至少需要有一层瘴气引擎效果才能使用这个技能。]])
		:format(rad, dam, chance, chance)
	end,
}

return _M