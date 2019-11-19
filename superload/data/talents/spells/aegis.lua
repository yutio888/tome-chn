local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_HEAL",
	name = "奥术重组",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[使你的身体充满奥术能量，将其重组为原始状态，治疗 %d 点生命值。 
		受法术强度影响，治疗量有额外加成。]]):
		format(heal)
	end,
}

registerTalentTranslation{
	id = "T_SHIELDING",
	name = "强化护盾",
	info = function(self, t)
		local shield = t.getShield(self, t)
		local dur = t.getDur(self, t)
		return ([[使你的周身围绕着强烈的奥术能量。 
		你的每个伤害护盾、时间护盾、转移护盾、干扰护盾的强度上升 %d%% 。 
		在等级 5 时，它会增加 1 回合所有护盾的持续时间。 
		受法术强度影响，护盾强度有额外加成。]]):
		format(shield, dur)
	end,
}

registerTalentTranslation{
	id = "T_ARCANE_SHIELD",
	name = "奥术护盾",
	info = function(self, t)
		local shield = t.getShield(self, t)
		return ([[使你的周身围绕着保护性的奥术能量。 
		每当你获得一个直接治疗时（非持续恢复效果）你会自动获得一个护盾，护盾强度为治疗量的 %d%% ，持续 3 回合。 
		如果新护盾的量和持续时间比当前护盾大或相等，将会取代之。
		受法术强度影响，护盾强度有额外加成。]]):
		format(shield)
	end,
}

registerTalentTranslation{
	id = "T_AEGIS",
	name = "守护印记",
	info = function(self, t)
		local shield = t.getShield(self, t)
		return ([[释放奥术能量充满当前保护你的魔法护盾，进一步强化它。
		它会影响最多 %d 种护盾效果。 
		伤害护盾，时间护盾，转移护盾：提高 %d%% 最大伤害吸收值。 
		干扰护盾：将储存的能量转化为护盾值（比例为2:1）。剩余能量将以%0.2f的比例转化为法力值。
		受法术强度影响，充能强度有额外加成。]]):
		format(t.getNumEffects(self, t), shield, t.getDisruption(self, t), 100 / t.getDisruption(self, t))
	end,
}


return _M
