local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ICE_CLAW",
	name = "冰爪",
	info = function(self, t)
		return ([[你召唤强大的冰龙之爪，在半径 %d 范围内造成 %d%% 寒冰武器伤害，有一定几率冻结目标。
		同时，该技能每等级增加物理豁免 2 点。 
		每一点冰龙系技能同时也能增加你的寒冷抵抗 1%% 。
		如果你装备了盾牌，这一技能也会用你的盾牌攻击。]]):format(self:getTalentRadius(t),100 * t.damagemult(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ICY_SKIN",
	name = "冰肤术",
	info = function(self, t)
		local life = t.getLifePct(self, t)
		return ([[你的皮肤上覆盖了寒冰，血肉更加坚硬。增加 %d%% 最大生命与 %d 护甲值。
		同时，你对近战命中你的目标造成 %0.2f 寒冷伤害。
		每一点冰龙系技能同时也能增加你的寒冷抵抗 1%% 。
		生命加成受技能等级影响，护甲和伤害受精神强度加成。]]):format(life * 100, t.getArmor(self, t), damDesc(self, DamageType.COLD, t.getDamageOnMeleeHit(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_ICE_WALL",
	name = "冰墙术",
	info = function(self, t)
		local icerad = t.getIceRadius(self, t)
		local icedam = t.getIceDamage(self, t)
		return ([[召唤一条长度 %d 的冰墙，持续 %d 回合。冰墙是透明的，但能阻挡抛射物和敌人。
		冰墙会释放极度寒气，每格墙壁对半径 %d 内的敌人造成 %0.2f 伤害，并有 25%% 几率冻结。寒气不会伤害释放者及其召唤物。
		每一点冰龙系技能同时也能增加你的寒冷抵抗 1%% 。]]):format(3 + math.floor(self:getTalentLevel(t) / 2) * 2, t.getDuration(self, t), damDesc(self, DamageType.COLD, icedam), icerad)
	end,
}

registerTalentTranslation{
	id = "T_ICE_BREATH",
	name = "冰息术",
	message = "@Source@ 呼出冰块!",
	info = function(self, t)
		return ([[向前方 %d 码范围施放一个锥形冰冻吐息，范围内所有目标受到 %0.2f 寒冷伤害，并被冻结3回合。
		受力量影响，伤害有额外加成。技能暴击率基于精神暴击值计算，冻结几率受精神强度影响。 
		每一点冰龙系技能同时也能增加你的寒冷抵抗 1%% 。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.COLD, t.getDamage(self, t)))
	end,
}


return _M
