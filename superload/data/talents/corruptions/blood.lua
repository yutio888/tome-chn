local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_BLOOD_SPRAY",
	name = "鲜血喷射",
	info = function(self, t)
		return ([[你从自身射出堕落之血，对前方 %d 码半径锥形范围敌人造成 %0.2f 枯萎伤害。 
		每个受影响的单位有 %d%% 概率感染 1 种随机疾病，受到 %0.2f 枯萎伤害，并且随机弱化目标体质、力量和敏捷中的一项属性，持续 6 回合。 
		受法术强度影响，伤害有额外加成。]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 10, 190)), t.getChance(self, t), damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 10, 220)))
	end,
}

registerTalentTranslation{
	id = "T_BLOOD_GRASP",
	name = "鲜血支配",
	info = function(self, t)
		return ([[释放一个堕落血球，造成 %0.2f 枯萎伤害并恢复你 20%% 伤害值的生命。 
		造成的伤害的 50%% 会增加你的最大生命值，持续 7 回合。（这一效果发生在治疗之前）
		受法术强度影响，伤害有额外加成。]]):format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 10, 290)))
	end,
}

registerTalentTranslation{
	id = "T_BLOOD_BOIL",
	name = "鲜血沸腾",
	info = function(self, t)
		return ([[使你周围半径  %d  内生物的不纯净的血液沸腾。
		被疾病、毒素或伤口影响的敌人将会随机移除一个上述效果，受到  %0.2f  枯萎伤害，使你恢复  %d  生命值，并被减速  %d%%  5  回合。
		伤害受你的法术强度影响。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.BLIGHT, t.getDamage(self, t)), t.getHeal(self, t), t.getSlow(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BLOOD_FURY",
	name = "鲜血狂怒",
	info = function(self, t)
		return ([[专注于你带来的腐蚀，提高你 %d%% 法术暴击率。 
		每当你的法术打出暴击时，你进入嗜血状态 5 回合，增加你 %d%% 枯萎和酸性伤害。 
		受法术强度影响，暴击率和伤害有额外加成。]]):
		format(self:combatTalentSpellDamage(t, 10, 14), self:combatTalentSpellDamage(t, 10, 30))
	end,
}



return _M
