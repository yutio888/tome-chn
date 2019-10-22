local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHATTERING_SHOUT",
	name = "狮子吼",
	info = function(self, t)
		return ([[一次强有力的怒吼，在你前方锥形区域内造成 %0.2f 物理伤害（有效半径 %d 码）。
		等级 5 时，怒吼变得如此强烈，范围内的抛射物会被击落。
		受力量影响，伤害有额外加成。]])
		:format(damDesc(self, DamageType.PHYSICAL, t.getdamage(self,t)), t.radius(self,t))
	end,
}

registerTalentTranslation{
	id = "T_SECOND_WIND",
	name = "宁神之风",
	info = function(self, t)
		return ([[做一次深呼吸并恢复 %d 体力值。该效果受意志和力量加成。]]):
		format(t.getStamina(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BATTLE_SHOUT",
	name = "战斗鼓舞",
	info = function(self, t)
		return ([[当你鼓舞后，提高你 %0.1f%% 生命值和体力值上限持续 %d 回合。
		效果结束时，增加的生命和体力会消失。]]):
		format(t.getPower(self, t), t.getdur(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BATTLE_CRY",
	name = "战斗怒喝",
	info = function(self, t)
		return ([[你的怒喝会减少 %d 码半径范围内敌人的意志，减少它们 %d 闪避，持续 7 回合。 
		同时，所有的闪避加成会被取消。
		受物理强度影响，命中率有额外加成。]]):
		format(self:getTalentRadius(t), 7 * self:getTalentLevel(t))
	end,
}


return _M
