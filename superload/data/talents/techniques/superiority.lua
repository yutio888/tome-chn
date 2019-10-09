local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_JUGGERNAUT",
	name = "战场主宰",
	info = function(self, t)
		return ([[专注于战斗并忽略你所承受的攻击。 
		增加物理伤害减免 %d%% 同时有 %d%% 几率摆脱暴击伤害，持续 20 回合。]]):
		format(t.getResist(self,t), t.critResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ONSLAUGHT",
	name = "猛攻",
	info = function(self, t)
		return ([[采取一个猛攻姿态，当你攻击你的敌人时，你会把目标和目标周围的敌人全部击退。（上限 %d 码）。 
		这个姿态会快速减少体力值（ -1 体力 / 回合）。]]):
		format(t.range(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BATTLE_CALL",
	name = "挑衅",
	info = function(self, t)
		return ([[挑衅你周围 %d 码半径范围内的敌人进入战斗，使它们立刻进入近战状态。]]):format(t.radius(self,t))
	end,
}

registerTalentTranslation{
	id = "T_SHATTERING_IMPACT",
	name = "震荡攻击",
	info = function(self, t)
		return ([[用尽全身的力量挥舞武器，造成震荡波冲击你周围的所有敌人，对每个敌人造成 %d%% 基础武器伤害。
		一回合至多产生一次冲击波，第一个目标不会受到额外伤害。
		每次震荡攻击消耗 8 点体力。]]):
		format(100*t.weaponDam(self, t))
	end,
}


return _M
