local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CREATE_ALCHEMIST_GEMS",
	name = "制造炼金宝石",
	info = function(self, t)
		return ([[从自然宝石中制造 40 ～ 80 个炼金宝石。 
		 许多法术需要使用炼金宝石。 
		 每种宝石拥有不同的特效。]]):format()
	end,
}

registerTalentTranslation{
	id = "T_EXTRACT_GEMS",
	name = "宝石提炼",
	info = function(self, t)
		local material = ""
		if self:getTalentLevelRaw(t) >=1 then material=material.."	-铁\n" end
		if self:getTalentLevelRaw(t) >=2 then material=material.."	-钢\n" end
		if self:getTalentLevelRaw(t) >=3 then material=material.."	-矮人钢\n" end
		if self:getTalentLevelRaw(t) >=4 then material=material.."	-蓝锆石\n" end
		if self:getTalentLevelRaw(t) >=5 then material=material.."	-沃瑞钽" end
		return ([[从金属武器和护甲中提取宝石。在此技能下你可以从以下材料中提取： 
		%s]]):format(material)
	end,
}

registerTalentTranslation{
	id = "T_IMBUE_ITEM",
	name = "装备附魔",
	info = function(self, t)
		return ([[在 %s 上附魔宝石（最大材质等级 %d ），使其获得额外增益。
		 你只能给每个装备附魔 1 次，并且此效果是永久的。]]):format(self:knowTalent(self.T_CRAFTY_HANDS) and "胸甲、腰带或头盔" or "胸甲", self:getTalentLevelRaw(t))
	end,
}

registerTalentTranslation{
	id = "T_GEM_PORTAL",
	name = "宝石传送",
	info = function(self, t)
		local range = t.getRange(self, t)
		return ([[使用 5 块宝石的粉末标记一块不可通过区域，你可以立即越过障碍物并出现在另一端。 
		 有效范围 %d 码。]]):
		format(range)
	end,
}

registerTalentTranslation{
	id = "T_STONE_TOUCH",
	name = "石化之触",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[触摸敌人使其进入石化状态，持续 %d 回合。 
		 石化状态的怪物不能动作或回复生命，且非常脆弱。 
		 如果对石化状态的怪物进行的单次打击，造成超过其 30%% 生命值的伤害，它会碎裂并死亡。 
		 石化状态的怪物对火焰和闪电有很高的抵抗，并且对物理攻击也会增加一些抵抗。 
		 等级 3 时触摸会成为一束光束。 
		 此技能可能对震慑免疫的怪物无效，尤其是石系怪物或某些特定 BOSS。]]):
		format(duration)
	end,
}


return _M
