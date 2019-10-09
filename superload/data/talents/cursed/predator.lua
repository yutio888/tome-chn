local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MARK_PREY",
	name = "猎杀标记",
	info = function(self, t)
		local maxKillExperience = t.getMaxKillExperience(self, t)
		local subtypeDamageChange = t.getSubtypeDamageChange(self, t)
		local typeDamageChange = t.getTypeDamageChange(self, t)
		local hateDesc = ""
		if self:knowTalent(self.T_HATE_POOL) then
			local hateBonus = t.getHateBonus(self, t)
			hateDesc = ("无论当前仇恨回复值为多少，每击杀一个被标记的亚类生物给予你额外的 +%d 仇恨值回复。"):format(hateBonus)
		end
		return ([[标记某个敌人作为你的捕猎目标，使攻击该类及该亚类的生物时获得额外加成，加成量受你杀死该标记类生物获得的经验值加成（ +0.25 主类， +1 亚类），当你增加 %0.1f 经验值时，获得 100%% 效果加成。攻击标记目标类生物将造成 +%d%% 伤害，攻击标记目标亚类生物将造成 +%d%% 伤害。 
		 每增加一个技能点减少达到 100%% 效果加成的经验需求。 
		%s]]):format(maxKillExperience, typeDamageChange * 100, subtypeDamageChange * 100, hateDesc)
	end,
}

registerTalentTranslation{
	id = "T_ANATOMY",
	name = "解剖学",
	info = function(self, t)
		local subtypeAttackChange = t.getSubtypeAttackChange(self, t)
		local typeAttackChange = t.getTypeAttackChange(self, t)
		local subtypeStunChance = t.getSubtypeStunChance(self, t)
		return ([[你对捕猎目标的了解使你的攻击提高额外精度，对标记类目标获得 +%d 命中，对标记亚类目标获得 +%d 命中。 
		 每次近战攻击对标记亚类生物有 %0.1f%% 概率震慑目标 3 回合。 
		 每增加一个技能点减少达到 100%% 效果加成的经验需求。]]):format(typeAttackChange, subtypeAttackChange, subtypeStunChance)
	end,
}

registerTalentTranslation{
	id = "T_OUTMANEUVER",
	name = "运筹帷幄",
	info = function(self, t)
		local subtypeChance = t.getSubtypeChance(self, t)
		local typeChance = t.getTypeChance(self, t)
		local physicalResistChange = t.getPhysicalResistChange(self, t)
		local statReduction = t.getStatReduction(self, t)
		local duration = t.getDuration(self, t)
		return ([[你的每次近战攻击有一定概率触发运筹帷幄，降低目标的物理抵抗 %d%% 同时降低他们最高的三项属性 %d ，对标记类生物有 %0.1f%% 概率触发，对标记亚类生物有 %0.1f%% 概率触发，持续 %d 回合，该效果可叠加。 
		 每增加一个技能点减少达到 100%% 效果加成的经验需求。]]):format(-physicalResistChange, statReduction, typeChance, subtypeChance, duration)
	end,
}

registerTalentTranslation{
	id = "T_MIMIC",
	name = "无相转生",
	info = function(self, t)
		local maxIncrease = t.getMaxIncrease(self, t)
		return ([[你学习汲取目标的力量，杀死该亚类生物可以提升你的属性值以接近该生物的能力（最多 %d 总属性点数，由你的当前效能决定），效果持续时间并不确定，且只有最近杀死的敌人获得的效果有效。 
		 每增加一个技能点减少达到 100%% 效果加成的经验需求。]]):format(maxIncrease)
	end,
}



return _M
