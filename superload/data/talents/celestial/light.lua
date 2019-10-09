local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_HEALING_LIGHT",
	name = "治愈之光",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[一束充满活力的阳光照耀着你，治疗你 %d 点生命值。 
		 受法术强度影响，治疗量有额外加成。]]):
		format(heal)
	end,
}

registerTalentTranslation{
	id = "T_BATHE_IN_LIGHT",
	name = "光之洗礼",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local heal = t.getHeal(self, t)
		local heal_fact = heal/(heal+50)
		local duration = t.getDuration(self, t)
		return ([[圣光倾泻在你周围 %d 码范围内，每回合治疗所有单位 %0.2f 生命值, 给予其等量的护盾 , 并增加此范围内所有人 %d%% 治疗效果。此效果持续 %d 回合。 
		 如果已经存在护盾，则护盾将会增加等量数值，如果护盾持续时间不足 2 回合，会延长至 2 回合。
		 当同一个护盾被刷新 20 次后，将会因为不稳定而破碎。
		 它同时会照亮此区域。 
		 受魔法影响，治疗量有额外加成。]]):
		format(radius, heal, heal_fact*100, duration)
	end,
}

registerTalentTranslation{
	id = "T_BARRIER",
	name = "护盾术",
	info = function(self, t)
		local absorb = t.getAbsorb(self, t) * (100 + (self:attr("shield_factor") or 0)) / 100
		return ([[一个持续 10 回合的保护性圣盾围绕着你，可吸收 %d 点伤害。 
		 受法术强度影响，圣盾的最大吸收量有额外加成，该技能可以暴击。]]):
		format(absorb)
	end,
}

registerTalentTranslation{
	id = "T_PROVIDENCE",
	name = "光之守护",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[你位于圣光的保护下，每回合移除 1 种负面状态，持续 %d 回合。。]]):
		format( duration)
	end,
}

return _M
