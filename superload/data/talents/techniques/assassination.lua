
local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_COUP_DE_GRACE",
	name = "致命一击！",
	info = function (self,t)
		dam = t.getDamage(self,t)*100
		perc = t.getPercent(self,t)*100
		return ([[尝试终结一名受伤的敌人，用双持武器攻击对方，造成 %d%% 武器伤害，如果对方的生命值在30%%以下，伤害还会增加50%%。 20%% 生命以下的目标将用物理豁免对抗你的命中，若未通过则会被立刻秒杀。
		如果该技能杀死敌人，且你学会了潜行技能，你将进入潜行状态。]]):
		format(dam, perc)
	end,
}
registerTalentTranslation{
	id = "T_TERRORIZE",
	name = "致命恐惧",
	info = function (self,t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self,t)
		return ([[每次你脱离潜行状态，你戏剧般的显形令周围的敌人闻风丧胆。 
		%d 范围内看到你脱离潜行状态的敌人将陷入恐惧，随机触发震慑、减速(40%%)、或者混乱 (50%%) 状态，持续 %d 回合。
		恐惧几率受命中加成。]])
		:format(radius, duration)
	end,
}
registerTalentTranslation{
	id = "T_GARROTE",
	name = "绞刑",
	info = function (self,t)
		local damage = t.getDamage(self, t)*100
		local dur = t.getDuration(self,t)
		local sdur = math.ceil(t.getDuration(self,t)/2)
		return ([[每次在潜行状态下发起进攻时，你尝试绞杀目标。目标将被勒住 %d 回合，沉默 %d 回合。被勒住的目标不能移动，每回合受到一次 %d%% 伤害的徒手攻击。  
		勒住的几率受命中加成，你必须待在目标身边以保持该状态。
		该技能有冷却时间。]])
		:format(dur, sdur, damage)
	end,
}
registerTalentTranslation{
	id = "T_MARKED_FOR_DEATH",
	name = "死亡标记",
	info = function (self,t)
		power = t.getPower(self,t)
		perc = t.getPercent(self,t)
		dam = t.getDamage(self,t)
		return ([[你为目标打上死亡标记，持续 4 回合 , 使其受到的伤害增加 %d%% 。该效果结束时，额外造成  %0.2f 追加等于标记期间受到的伤害的 %d%% 的物理伤害。
		目标在标记期间死亡时，该技能立刻冷却完成，同时返还消耗。
		使用该技能不消耗潜行。
		伤害受敏捷加成。]]):
		format(power, damDesc(self, DamageType.PHYSICAL, dam), perc)
	end,
}
return _M