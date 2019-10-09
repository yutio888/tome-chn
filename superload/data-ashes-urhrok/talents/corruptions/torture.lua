local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_INCINERATING_BLOWS",
	name = "焚尽强击",
	info = function(self, t)
	return ([[恶魔空间的力量注入你的武器：你的近战攻击在 3 回合内造成 %0.2f 点火焰伤害。
	另外，每次攻击时有 %d%% 几率在 %d 码范围释放强烈的火焰爆发，造成持续 %d 回合的 %0.2f 点火焰伤害。
	若该技能冷却完毕，则火焰爆发将聚集在 %d 码范围内，并产生火焰震慑效果。
	进行震慑判定时，额外增加 %d 点法术强度。
	伤害受法术强度加成。]]):
	format(t.damBonus(self, t),t.getChance(self, t),self:getTalentRadius(t),t.getDur(self, t),t.bigBonus(self, t),t.getStunRad(self,t),t.getPowerbonus(self, t))
	end,
}


registerTalentTranslation{
	id = "T_ABDUCTION",
	name = "锁魂之链",
	info = function(self, t)
	return ([[对目标攻击，造成 %d%% 武器伤害。
	如果命中，将目标抓到身边并再次攻击，造成 %d%% 武器伤害。]]):format(100 * t.getSmallhit(self, t), 100 * t.getBighit(self, t))
	end,
}

	
registerTalentTranslation{
	id = "T_FIERY_TORMENT",
	name = "灼魂之罚",
	info = function(self, t)
	return ([[用武器攻击敌人，造成 %d%% 武器伤害。如果命中，目标受到灼魂之罚的影响，持续 %d 回合 , 火焰抗性降低 %d%% 。
	当灼魂之罚结束，敌人会受到 %d 点火焰伤害。 
	在灼魂之罚持续时间内目标受到的所有伤害，有 %d%% 会加成到火焰伤害中。
	被灼魂之罚影响的恶魔会被恶魔空间中的火焰焚烧。]])
	:format(100 * t.getMainhit(self,t),t.getDur(self,t),t.getResist(self,t),t.getDamage(self, t),t.getPercent(self, t))
	end,
}

	
registerTalentTranslation{
	id = "T_ETERNAL_SUFFERING",
	name = "无尽苦痛",
	info = function(self, t)
	return ([[你的攻击充溢着恶毒的力量，能够延长敌人的苦痛。当近战命中时，有 %d%% 几率延长对方所有的负面状态持续时间并降低所有正面状态的持续时间，增减幅度为 %d 回合。
	该效果对同一目标每 6 回合才能生效一次。]]):format(math.min(100, t.getChance(self,t)), t.getExtend(self,t))
	end,
}


return _M
