local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_PHASE_DOOR",
	name = "次元之门",
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local range = t.getRange(self, t)
		return ([[在 %d 码范围内随机传送你自己。 
		在等级 4 时，你可以传送指定生物（怪物或被护送者）。 
		在等级 5 时，你可以选择传送位置（半径 %d ）。 
		如果目标位置不在你的视线里，则法术有可能失败，变为随机传送。 
		受法术强度影响，影响范围有额外加成。]]):format(range, radius)
	end,
}

registerTalentTranslation{
	id = "T_TELEPORT",
	name = "传送",
	info = function(self, t)
		local range = t.getRange(self, t)
		local radius = t.getRadius(self, t)
		return ([[在 %d 码范围内随机传送。 
		在等级 4 时，你可以传送指定生物（怪物或被护送者）。 
		在等级 5 时，你可以选择传送位置（半径 %d ）。 
		随机传送的最小半径为 %d 。
		受法术强度影响，影响范围有额外加成。]]):format(range, radius, t.minRange)
	end,
}

registerTalentTranslation{
	id = "T_DISPLACEMENT_SHIELD",
	name = "相位护盾",
	info = function(self, t)
		local chance = t.getTransferChange(self, t)
		local maxabsorb = t.getMaxAbsorb(self, t) * (100 + (self:attr("shield_factor") or 0)) / 100
		local duration = t.getDuration(self, t)
		return ([[这个复杂的法术可以扭曲施法者周围的空间，此空间可连接至范围内的另外 1 个目标。 
		任何时候，施法者所承受的伤害有 %d%% 的概率转移给指定连接的目标。 
		一旦吸收伤害达到上限（ %d ），持续时间到了（ %d 回合）或目标死亡，护盾会破碎掉。 
		受法术强度影响，护盾的伤害最大吸收值有额外加成。]]):
		format(chance, maxabsorb, duration)
	end,
}

registerTalentTranslation{
	id = "T_PROBABILITY_TRAVEL",
	name = "次元移动",
	info = function(self, t)
		local range = t.getRange(self, t)
		return ([[当你击中一个固体表面时，此法术会撕裂位面将你瞬间传送至另一面。 
		传送最大距离为 %d 码。 
		在一次成功的移动后，你将进入不稳定状态，在基于你传送码数的 %d%% 回合内，无法再次使用该技能。 
		受法术强度影响，传送距离有额外加成。]]):
		format(range, (2 + (5 - math.min(self:getTalentLevelRaw(t), 5)) / 2) * 100)
	end,
}


return _M
