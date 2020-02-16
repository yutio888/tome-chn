local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DIMENSIONAL_STEP",
	name = "空间跳跃",
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[将你传送到 %d 码视野范围内的指定地点。
		在等级 5 时，你可以与指定的目标交换位置。]]):format(range)
	end,
}

registerTalentTranslation{
	id = "T_DIMENSIONAL_SHIFT",
	name = "时空流转",
	info = function(self, t)
		local reduction = t.getReduction(self, t)
		return ([[每当你进行传送，你的 1 个负面效果的持续时间被减少 %d 回合。]]):
		format(reduction)
	end,
}

registerTalentTranslation{
	id = "T_WORMHOLE",
	name = "虫洞穿梭",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		local range = self:getTalentRange(t)
		return ([[你创造一对虫洞，使你所在之处和 %d 码范围内一点的空间重叠。  任何踏入虫洞的生物会被传送至另一个虫洞附近 (精度半径 %d )。  
		虫洞持续 %d 回合并且至少相距两码。
		受法术强度影响，传送敌人的几率按比例加成。]])
		:format(range, radius, duration)
	end,
}

registerTalentTranslation{
	id = "T_PHASE_PULSE",
	name = "相位脉冲",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		return ([[每当你进行传送，你发射一道脉冲将起点和终点半径 %d 码内的敌人击出位面。 
		你每传送一码，被击中的目标将有 %d%% 的几率被震慑、致盲、混乱或者束缚 %d 回合。]]):
		format(radius, chance, duration)
	end,
}

return _M
