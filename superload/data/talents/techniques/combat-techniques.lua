local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RUSH",
	name = "冲锋",
	info = function(self, t)
		return ([[快速冲向敌人，并造成 120% 基础武器伤害。 
		如果此次攻击命中，那么目标会被眩晕 3 回合。 
		你必须从至少 2 码以外开始冲锋。]])
	end,
}

registerTalentTranslation{
	id = "T_PRECISE_STRIKES",
	name = "精准打击",
	info = function(self, t)
		return ([[你集中精神攻击，减少你 %d%% 攻击速度并增加你 %d 点命中和 %d%% 暴击率。 
		受敏捷影响，此效果有额外加成。]]):
		format(10, t.getAtk(self, t), t.getCrit(self, t))
	end,
}

registerTalentTranslation{
	id = "T_PERFECT_STRIKE",
	name = "完美打击",
	info = function(self, t)
		return ([[你已经学会专注你的攻击来命中目标，增加 %d 命中并使你在攻击你看不见的目标时不再受到额外惩罚，持续 %d 回合。]]):format(t.getAtk(self, t), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BLINDING_SPEED",
	name = "急速",
	info = function(self, t)
		return ([[通过严格的训练你已经学会在短时间内爆发你的速度，提高你 %d%% 速度 5 回合。]]):format(100*t.getSpeed(self, t))
	end,
}

registerTalentTranslation{
	id = "T_QUICK_RECOVERY",
	name = "快速恢复",
	info = function(self, t)
		return ([[你专注于战斗，使得你可以更快的回复体力（ +%0.1f 体力 / 回合）。]]):format(t.getStamRecover(self, t))
	end,
}

registerTalentTranslation{
	id = "T_FAST_METABOLISM",
	name = "快速代谢",
	info = function(self, t)
		return ([[你专注于战斗，使你可以更快的回复生命值（ +%0.1f 生命值 / 回合）。]]):format(t.getRegen(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SPELL_SHIELD",
	name = "法术抵抗",
	info = function(self, t)
		return ([[严格的训练使得你对某些法术效果具有更高的抗性（ +%d 法术豁免）。]]):format(self:getTalentLevel(t) * 9)
	end,
}

registerTalentTranslation{
	id = "T_UNENDING_FRENZY",
	name = "无尽怒火",
	info = function(self, t)
		return ([[你陶醉在敌人的死亡中，每杀死一个敌人回复 %d 体力值。]]):format(t.getStamRecover(self, t))
	end,
}


return _M
