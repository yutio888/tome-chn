local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DARK_RITUAL",
	name = "黑暗仪式",
	info = function(self, t)
		return ([[增加 %d%% 法术暴击倍率。 
		 受法术强度影响，倍率有额外加成。]]):
		format(self:combatTalentSpellDamage(t, 20, 50))
	end,
}

registerTalentTranslation{
	id = "T_CORRUPTED_NEGATION",
	name = "能量腐蚀",
	info = function(self, t)
		return ([[在 3 码球形范围内制造一个堕落能量球，造成 %0.2f 枯萎伤害并移除范围内任意怪物至多 %d 种魔法或物理效果或持续技能。 
		 每除去一个效果时，基于法术豁免，目标都有一定概率抵抗。 
		 受法术强度影响，伤害有额外加成。]]):format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 28, 120)), t.getRemoveCount(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CORROSIVE_WORM",
	name = "腐蚀蠕虫",
	info = function(self, t)
		return ([[用腐蚀蠕虫感染目标 6 回合，降低目标 %d%% 酸性枯萎抗性。
		效果结束或者目标死亡时会产生爆炸，在 4 码半径内造成 %d 酸性伤害。同时，感染期内目标受到的伤害将以 %d%% 比例增加至爆炸伤害  中。
		伤害受法术强度加成。]]):
		format(t.getResist(self,t), t.getDamage(self, t), t.getPercent(self, t))
	end,
}

registerTalentTranslation{
	id = "T_POISON_STORM",
	name = "剧毒风暴",
	info = function(self, t)
		local dam = damDesc(self, DamageType.BLIGHT, t.getDamage(self,t))
		local power, heal_factor, fail = t.getEffects(self, t)
		return ([[一股强烈的剧毒风暴围绕着施法者，半径 %d 持续 %d 回合。风暴内的生物将进入中毒状态，受到 %0.2f 枯萎伤害并中毒 4 回合受到额外 %0.2f 枯萎伤害。
		技能等级 2 时有几率触发阴险毒素效果，降低 %d%% 治疗系数。
		技能等级 4 时有几率触发麻痹毒素效果，降低 %d%% 伤害。
		技能等级 6 时有几率触发致残毒素效果， %d%% 几率使用技能失败。
		中毒几率在可能的毒素效果中平分。
		毒素伤害可以暴击。
		伤害受法术强度加成。]]):
		format(self:getTalentRadius(t), t.getDuration(self, t), dam/4, dam, heal_factor, power, fail)
	end,
}




return _M
