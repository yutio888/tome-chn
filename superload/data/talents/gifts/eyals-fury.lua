local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RECLAIM",
	name = "沙化",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[ 你将自然无情的力量集中于某个目标上，腐蚀他并让他重归生命轮回。
		造成 %0.1f 点自然伤害， %0.1f 点酸性伤害，对不死族和构装生物有 %d%% 伤害加成。
		受精神强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.NATURE, dam/2), damDesc(self, DamageType.ACID, dam/2), t.undeadBonus)
	end,
}

registerTalentTranslation{
	id = "T_NATURE_S_DEFIANCE",
	name = "自然的反抗",
	info = function(self, t)
		local p = t.getPower(self, t)
		return ([[ 你对自然的贡献让你的身体更亲近自然世界，对非自然力量也更具抵抗力。
		你获得 %d 点法术豁免， %0.1f%% 奥术抗性，同时将受到的 %0.1f%% 的自然伤害转化为治疗。
		由于你和奥术力量对抗，每次你受到法术伤害时，你回复 %0.1f 点失衡值，持续 %d 回合。
		受精神强度影响，效果有额外加成。]]):
		format(t.getSave(self, t), t.getResist(self, t), t.getAffinity(self, t), t.getPower(self, t), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ACIDFIRE",
	name = "酸火",
	info = function(self, t)
		return ([[ 你召唤酸云覆盖半径 %d 的地面，持续 %d 回合。酸云具有腐蚀性，能致盲敌人。
		每回合，酸云对每个敌人造成 %0.1f 点酸性伤害，25%% 几率致盲，同时有 %d%% 几率除去一个有益的魔法效果或魔法持续技能。
		受精神强度影响，伤害有额外加成。]]):
		format(self:getTalentRadius(t), t.getDuration(self, t), damDesc(self, DamageType.ACID, t.getDamage(self, t)), t.getChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_EYAL_S_WRATH",
	name = "埃亚尔之怒",
	info = function(self, t)
		local drain = t.getDrain(self, t)
		return ([[ 你在自己周围半径 %d 的范围内制造自然力量风暴，持续 %d 回合。
		风暴会跟随你移动，每回合对每个敌人造成 %0.1f 点自然伤害，并抽取 %d 点法力， %d 点活力， %d 点正负能量。
		同时你的失衡值会回复你抽取能量的 10%% 。
		受精神强度影响，伤害和吸取量有额外加成。]]):
		format(self:getTalentRadius(t), t.getDuration(self, t), damDesc(self, DamageType.NATURE, t.getDamage(self, t)), drain, drain/2, drain/4, drain/4)
	end,
}


return _M
