local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WILLFUL_TORMENTER",
	name = "施虐之心",
	info = function(self, t)
		return ([[你将精神集中于一个目标：摧毁所有敌人。 
		增加你 %d 点活力上限。]]):
		format(t.VimBonus(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BLOOD_LOCK",
	name = "鲜血禁锢",
	info = function(self, t)
		return ([[掌控敌人的血液和肉体。在 2 码范围内，任何被鲜血禁锢攻击到的敌人的治疗或回复将不能超过当前生命值，持续 %d 回合。]]):
		format(t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_OVERKILL",
	name = "赶尽杀绝",
	info = function(self, t)
		return ([[当你杀死一个敌人后，多余的伤害不会消失。 
		反之 %d%% 的伤害会溅落在 2 码范围内，造成枯萎伤害。 
		受法术强度影响，伤害有额外加成。]]):format(t.getOversplash(self,t))
	end,
}

registerTalentTranslation{
	id = "T_BLOOD_VENGEANCE",
	name = "血之复仇",
	info = function(self, t)
		local l, c = t.getPower(self, t)
		return ([[当你遭受到超过至少 %d%% 总生命值的伤害时，你有 %d%% 概率降低所有技能 1 回合冷却时间。 
		鲜血灌注带来的额外生命值，不会影响该技能的伤害阈值。
		受法术强度影响，概率有额外加成。]]):
		format(l, c)
	end,
}



return _M
