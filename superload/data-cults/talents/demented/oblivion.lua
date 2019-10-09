local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_NIHIL",
	name = "虚无",
	info = function(self, t)
		local targetcount = t.getTargetCount(self, t)
		local power = t.getPower(self, t)*100
		return ([[将你身体上的熵能向周围辐射。每当你受到熵能反冲时，在你 1 0  码距离内随机的 %d 个可见敌人都  将被熵能侵蚀 4 回合。
		增加 ( 减少 ) 它们受到的新的负面 ( 正面 ) 效果 %d%% 的持续时间。]]):
		format(targetcount, power)
	end,
}

registerTalentTranslation{
	id = "T_UNRAVEL_EXISTENCE",
	name = "拆解",
	info = function(self, t)
		local dur = t.getDuration(self,t)
		return ([[虚无能解构目标的存在并通过熵能将其摧毁。
		在熵能侵蚀效果结束之前，如果目标身上同时存在 6 个效果，将召唤出持续 %d 回合的湮灭使者。
		湮灭使者的全部属性点提升你魔法属性的相同数值。其他属性根据本身等级提升。
		湮灭使者会继承你的伤害加成、伤害穿透、暴击几率和暴击倍率加成。]]):
		format(dur)
	end,
}

registerTalentTranslation{
	id = "T_ERASE",
	name = "抹除",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local power = t.getNumb(self, t)
		return ([[受到你虚无之力影响的生物逐渐被从现实中被抹除，造成的伤害降低 %d%% ，同时每具有一个负面魔法效果，每回合受到 %0.2f 时空伤害。 
		伤害受到法术强度加成。]])
		:format(power, damDesc(self, DamageType.TEMPORAL, dam))
	end
}


registerTalentTranslation{
	id = "T_ALL_IS_DUST",
	name = "尽归尘土",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[在目标区域召唤出范围 4 码、持续 %d 回合的湮灭风暴，使受到影响的物质化为虚无，每回合造成 %0.2f 暗影 %0.2f 时空伤害。
		范围内的墙壁和部分其他地形将被粉粹。
		每次受到风暴伤害时，敌  人身上不足 3 回合的负面魔法效果都将重置为 3 回合。风暴范围内敌人的投射物都将被扯碎。
		伤害受到法术强度加成。]]):format(duration, damDesc(self, DamageType.DARKNESS, damage), damDesc(self, DamageType.TEMPORAL, damage))
	end,
}

registerTalentTranslation{
	id = "T_VOID_CRASH",
	name = "虚空破碎",
	info = function(self, t)
		return ([[用武器撞击地面 ,   产生 2 码的虚空爆炸，造成 %d%% 虚空武器伤害（暗影时空各 50%%）。]]):
		format(t.getDamage(self, t) * 100)
	end,
}

return _M
