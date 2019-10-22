local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GOLEMANCY_LIFE_TAP",
	name = "生命分流",
	info = function(self, t)
		local power=t.getPower(self, t)
		return ([[你汲取傀儡的生命能量来恢复自己。恢复 %d 点生命。]]):
		format(power)
	end,
}

registerTalentTranslation{
	id = "T_GEM_GOLEM",
	name = "宝石傀儡",
	info = function(self, t)
		return ([[在傀儡身上镶嵌 2 颗宝石，它可以得到宝石加成并改变近战攻击类型。你可以移除并镶嵌不同种类的宝石，移除行为不会破坏宝石。 
		可用宝石等级： %d
		宝石会在傀儡的物品栏中改变成功。]]):format(self:getTalentLevelRaw(t))
	end,
}

registerTalentTranslation{
	id = "T_SUPERCHARGE_GOLEM",
	name = "超能傀儡",
	info = function(self, t)
		local regen, turns, life = t.getPower(self, t)
		return ([[你激活傀儡的特殊模式，提高它每回合 %0.2f 生命回复速度，持续 %d 回合。 
		如果你的傀儡死亡，它会立刻复活，复活时保留 %d%% 生命值。 
		此技能激活时你的傀儡处于激怒状态，可增加 25%% 伤害。]]):
		format(regen, turns, life)
	end,
}

registerTalentTranslation{
	id = "T_RUNIC_GOLEM",
	name = "符文傀儡",
	info = function(self, t)
		return ([[增加傀儡 %0.2f 生命、法力和耐力回复。 
		在等级 1 、 3 、 5 时，傀儡会增加 1 个新的符文孔。 
		即使没有此天赋，傀儡默认也有 3 个符文孔。]]):
		format(self:getTalentLevelRaw(t))
	end,
}


return _M
