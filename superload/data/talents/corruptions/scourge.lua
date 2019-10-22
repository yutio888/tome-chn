local _M = loadPrevious(...)

registerTalentTranslation{
    id = "T_REND",
    name = "撕裂",
	info = function(self, t)
		return ([[向目标挥舞两把武器，每次攻击造成 %d%% 伤害，每次攻击将会使目标身上持续时间最短的疾病效果的持续时间延长 %d 回合。]]):
		format(100 * t.getDamage(self, t), t.getIncrease(self, t))
	end,
}

registerTalentTranslation{
    id = "T_RUIN",
    name = "毁伤",
	info = function(self, t)
		local dam = damDesc(self, DamageType.BLIGHT, t.getDamage(self, t))
		return ([[专注于你带来的瘟疫，每次近战攻击会造成 %0.2f 枯萎伤害（同时每击恢复你 %0.2f 生命值）。 
		受法术强度影响，伤害有额外加成。]]):
		format(dam, dam * 0.4)
	end,
}

registerTalentTranslation{
    id = "T_ACID_STRIKE",
    name = "酸性打击",
	info = function(self, t)
		return ([[用每把武器打击目标，每次攻击造成 %d%% 酸性武器伤害。 
		如果有至少一次攻击命中目标，则会产生酸系溅射，对 %d 范围内的所有敌人造成 %0.2f 酸性伤害。 
		受法术强度影响，溅射伤害有额外加成。]]):
		format(100 * t.getDamage(self, t), self:getTalentRadius(t), damDesc(self, DamageType.ACID, t.getSplash(self, t)))
		end,
}

registerTalentTranslation{
    id = "T_DARK_SURPRISE",
    name = "黑暗连击",
	info = function(self, t)
		return ([[腐化目标， 2  回合内降低其  100%%  的疾病免疫，并去除其  2  个自然持续效果。然后用你的两把武器打击敌人，造成  %d%%  伤害。]]):
			format(100 * t.getDamage(self, t))
	end,
}


return _M
