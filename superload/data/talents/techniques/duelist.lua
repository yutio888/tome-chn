local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_DUAL_WEAPON_MASTERY",
	name = "双持掌握",
	info = function (self,t)
		mult = t.getoffmult(self,t)*100
		block = t.getDamageChange(self, t, true)
		chance = t.getDeflectChance(self,t)
		return ([[你的副手武器惩罚减少至  %d%% .
		每回合最多 %0.1f 次，你有 %d%% 概率抵挡至多 %d 点伤害（基于副手伤害  ）。 
		抵挡的减伤类似护甲，且被抵挡的攻击不会暴击。很难抵挡未发现的敌人的攻击，且不能使用灵晶抵挡攻击。
		]]):
		format(100 - mult, t.getDeflects(self, t, true), chance, block)
	end,
}
registerTalentTranslation{
	id = "T_TEMPO",
	name = "节奏",
	info = function (self,t)
		local sta = t.getStamina(self,t)
		local speed = t.getSpeed(self,t)
		return ([[战斗鼓舞着你，让你在战斗中获得优势。
		每回合一次，若你双持武器，你将：
		反击 -- 如果你闪避或抵挡了近战或弓箭攻击，你立刻回复 %0.1f 体力并获得 %d%% 额外回合。
		回复 -- 副手武器暴击时回复 %0.1f 体力。]]):format(sta, speed, sta)
	end,
}
registerTalentTranslation{
	id = "T_FEINT",
	name = "佯攻",
	info = function (self,t)
		return ([[假装攻击敌人，欺骗敌人和你换位。在移动时趁机削弱敌人，使其定身并眩晕 2 回合。
		换位令你的敌人分心，使你的闪避得到强化： %d 回合内，双持掌握提供额外一次抵挡攻击机会，你错失抵挡机会的几率下降 %d%% 。
		定身与眩晕几率受命中加成。]]):
		format(t.getDuration(self, t), t.getParryEfficiency(self, t))
	end,
}
registerTalentTranslation{
	id = "T_LUNGE",
	name = "刺击",
	info = function (self,t)
		local dam = t.getDamage(self, t)
		local dur = t.getDuration(self,t)
		return ([[你攻其不备，用副手发起致命打击，造成 %d%% 伤害并使其武器脱落，缴械 %d 回合。
		节奏技能被触发时，该技能的冷却时间减少 1 回合。
		缴械几率受命中加成。]]):
		format(dam*100, dur)
	end,
}
return _M