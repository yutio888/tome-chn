local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FEARSCAPE_SHIFT",
	name = "炼狱之门",
	info = function(self, t)
	local damage = t.getDamage(self, t)
	return ([[开启通往恶魔空间的炼狱之门，踏入并传送到附近位置。 
	当你踏出炼狱之门时，炼狱之火随之喷发，造成 %0.2f 恶魔之火伤害，伤害 %d 码内所有生物。地上的余烬会造成持续 4 回合的额外 %0.2f 恶魔之火伤害。

	穿越空间增强了你的直觉，让你能够在 3 回合内觉察到 %d 码内的所有敌对生物。 
 
	伤害受法术强度加成，范围随技能等级增大。]]):
	format(damage, self:getTalentRadius(t),damage, t.getVision(self, t))
	end,
}


registerTalentTranslation{
	id = "T_CAUTERIZE_SPIRIT",
	name = "灵魂焚净",
	info = function(self, t)
	return ([[移除所有负面状态，但每移除一个状态，会在 7 回合内灼烧自身，受到合计 %d%% 最大生命值的伤害。
	伤害无视一切抗性、防御效果和伤害吸收。
	
此技能瞬发。]]):format(t.getBurnDamage(self, t)*100)
	end,
}


registerTalentTranslation{
	id = "T_INFERNAL_BREATH_DOOM",
	name = "地狱吐息",
	info = function(self, t)
	local radius = self:getTalentRadius(t)
	return ([[在 %d 码的锥形范围内，喷出持续 4 回合的暗黑火焰。
	范围内所有的非恶魔生物受到 %0.2f 火焰伤害，同时火焰会造成每回合 %0.2f 的灼烧伤害。
	恶魔受到等量的治疗。
 
	伤害受力量加成，该技能使用魔法暴击率。]]):
	format(radius, self:combatTalentStatDamage(t, "str", 30, 350), self:combatTalentStatDamage(t, "str", 30, 70))
	end,
}


registerTalentTranslation{
	id = "T_FEARSCAPE_AURA",
	name = "乌鲁克之胃",
	info = function(self, t)
	local damage = t.getDamage(self, t)
	local radius = self:getTalentRadius(t)
	return ([[你的身体成为恶魔空间与现实的纽带，将 %d 码的锥形范围内的敌人抓过来，同时每回合造成 %0.2f 点火焰伤害。
伤害受法术强度加成。]]):format(radius, damage)
	end,
}




return _M
