local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_UNNATURAL_BODY",
	name = "诅咒之体",
	info = function(self, t)
		local healPerKill = t.getHealPerKill(self, t)
		local maxUnnaturalBodyHeal = t.getMaxUnnaturalBodyHeal(self, t)
		local regenRate = t.getRegenRate(self, t)

		return ([[你的力量来源于心底的憎恨，这使得大部分治疗效果减至原来的 50%% （ 0 仇恨）～ 100%% （ 100+ 仇恨）。 
		 另外，每次击杀敌人你将存储生命能量来治疗自己，回复 %d 点生命（受敌人最大生命值限制，任何时候不能超过 %d 点）。这个方式带来的每回合回复量不能超过 %0.1f 点生命，也不受仇恨等级或治疗加成等因素影响。 
		 受意志影响，通过杀死敌人获得的治疗量有额外加成。]]):format(healPerKill, maxUnnaturalBodyHeal, regenRate)
	end,
}

registerTalentTranslation{
	id = "T_RELENTLESS",
	name = "鲜血渴望",
	info = function(self, t)
		return ([[对鲜血的渴望控制了你的行为。增加 +%d%% 混乱、恐惧、击退和震慑免疫。]]):format(t.getImmune(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_SEETHE",
	name = "狂热沸腾",
	info = function(self, t)
		local incDamageChangeMax = t.getIncDamageChange(self, t, 5)
		return ([[你学会控制憎恨，并用你的痛苦燃烧心底的愤怒。 
		 每当你受到伤害时，你的伤害会在 5 回合后增加至最大值 +%d%% 。 
		 每个你不承受伤害的回合会降低该增益效果。]]):format(incDamageChangeMax)
	end,
}

registerTalentTranslation{
	id = "T_GRIM_RESOLVE",
	name = "冷酷决心",
	info = function(self, t)
		local statChangeMax = t.getStatChange(self, t, 5)
		local neutralizeChance = t.getNeutralizeChance(self, t)
		return ([[你勇于面对其他人带给你的痛苦。每回合当你承受伤害时，你将会增加你的力量和意志，直至在 5 回合后增加至最大值 +%d 。 
		 每个你不承受伤害的回合会降低该增益效果。 
		 当此效果激活时，每回合你有 %d%% 的概率抵抗毒素和疾病效果。]]):format(statChangeMax, neutralizeChance)
	end,
}





return _M
