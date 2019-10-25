local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SKIRMISHER_BREATHING_ROOM",
	name = "喘息间隙",
	info = function(self, t)
		local stamina = t.getRestoreRate(self, t)
		return ([[当没有敌人与你相邻的时候，你获得 %0.1f 体力回复。在第 3 级时，这个技能带给你等量的生命回复.]])
			:format(stamina)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_PACE_YOURSELF",
	name = "调整步伐",
	info = function(self, t)
		local slow = t.getSlow(self, t) * 100
		local reduction = t.getReduction(self, t)
		return ([[控制你的行动来节省体力。当这个技能激活时，你的全局速度降低 %0.1f%% ，你的疲劳值降低 %d%% （最多降至 0%% ）。]])
		:format(slow, reduction)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_DAUNTLESS_CHALLENGER",
	name = "不屈底力",
	info = function(self, t)
		local stamina = t.getStaminaRate(self, t)
		local health = t.getLifeRate(self, t)
		return ([[当战斗变得艰难时，你变得更加顽强。视野内每有一名敌人存在，你就获得 %0.1f 体力回复。从第三级起，每名敌人同时能增加 %0.1f 生命回复。加成上限为 4 名敌人。]])
			:format(stamina, health)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_THE_ETERNAL_WARRIOR",
	name = "不灭战士",
	info = function(self, t)
		local max = t.getMax(self, t)
		local duration = t.getDuration(self, t)
		local resist = t.getResist(self, t)
		local cap = t.getResistCap(self, t)
		local mult = (t.getMult(self, t, true) - 1) * 100
		return ([[每回合使用体力后，你获得 %0.1f%% 全抗性加成和 %0.1f%% 全抗性上限，持续 %d 回合。加成效果最多叠加 %d 次，每次叠加都会刷新效果持续时间。
		在第 5 级时，  喘息间隙和不屈底力效果提升 %d%%]])
			:format(resist, cap, duration, max, mult)
	end,
}


return _M
