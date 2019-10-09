local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DRAINING_ASSAULT",
	name = "汲魂痛击",
	info = function(self, t)
	return ([[对目标攻击两次，每次造成 %d%% 武器伤害 , 吸取 %d%% 的伤害回复生命，同时每次击中均回复 %d 活力。]]):format(100 * t.getHit(self, t), t.lifeSteal(self, t), t.vimSteal(self, t))
	end,
}


registerTalentTranslation{
	id = "T_FIERY_GRASP",
	name = "炙炎之牢",
	info = function(self, t)
	local damage = t.getDamage(self, t)
	return ([[对目标伸出一只火炎之爪，对直线上的生物造成 %0.2f 点火焰伤害。目标被火炎之爪抓住后，受到 %d%% 火焰武器伤害，并在 %d 回合不能移动，同时每回合受到 %0.2f 点火焰伤害。
	技能等级 4 级以后，目标同时会被沉默。
	射线伤害和持续伤害受法术强度加成。]]):
	format(damage, 100 * t.getHit(self, t),t.getDur(self,t), damage)
	end,
}


registerTalentTranslation{
	id = "T_RECKLESS_STRIKE",
	name = "舍身一击",
	info = function(self, t)
	return ([[攻击目标，造成 %d%% 武器伤害。本次攻击必中，且无视目标护甲和抗性。
	但是，你自己会受到输出伤害的 %d%% 或者当前生命值 30%% 的伤害，取数值较低者。]]):format(100 * t.getMainhit(self, t), t.getBacklash(self,t))
	end,
}


registerTalentTranslation{
	id = "T_SHARE_THE_PAIN",
	name = "以眼还眼",
	info = function(self, t)
	return ([[你沉迷于战争的狂热。当一个近身的敌对生物伤害你时，有 %d%% 几率自动反击，造成 %d%% 武器伤害。
	此效果每回合对同一目标触发一次。]]):format(math.min(100, t.getChance(self,t)), t.getHit(self,t)*100)
	end,
}



return _M
