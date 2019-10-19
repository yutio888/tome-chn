local _M = loadPrevious(...)

local function getDamageIncrease(self)
	local total = 0
		
	local t = self:getTalentFromId(self.T_CREEPING_DARKNESS)
	if t then total = total + self:getTalentLevelRaw(t) end
	t = self:getTalentFromId(self.T_DARK_VISION)
	if t then total = total + self:getTalentLevelRaw(t) end
	t = self:getTalentFromId(self.T_DARK_TORRENT)
	if t then total = total + self:getTalentLevelRaw(t) end
	t = self:getTalentFromId(self.T_DARK_TENDRILS)
	if t then total = total + self:getTalentLevelRaw(t) end
	
	return self:combatScale(total, 5, 1, 40, 20) --I5
--I5	return total * 2
end

registerTalentTranslation{
	id = "T_CREEPING_DARKNESS",
	name = "黑暗之雾",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		local darkCount = t.getDarkCount(self, t)
		local damageIncrease = getDamageIncrease(self)
		return ([[一股黑暗之雾蔓延在目标点和目标点附近 %d 码范围内最多 %d 格。黑暗之雾造成 %d 点伤害，阻挡未掌握黑暗视觉或其他魔法视觉能力目标的视线。 
		受精神强度影响，伤害有额外加成。你对任何进入黑暗之雾的人造成 +%d%% 点伤害。]]):format(radius, darkCount, damage, damageIncrease)
	end,
}

registerTalentTranslation{
	id = "T_DARK_VISION",
	name = "黑暗视觉",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local movementSpeedChange = t.getMovementSpeedChange(self, t)
		local damageIncrease = getDamageIncrease(self)
		return ([[你的眼睛穿过黑暗并发现隐藏在黑暗里的敌人。 
		 你的视线同样可以穿过黑暗之雾看到 %d 的半径范围。同时黑暗之雾极大的提高你的步伐。 
		（在黑暗之雾中增加你 +%d%% 移动速度） 
		 你对任何进入黑暗之雾的人造成 +%d%% 点伤害。]]):format(range, movementSpeedChange * 100, damageIncrease)
	end,
}

registerTalentTranslation{
	id = "T_DARK_TORRENT",
	name = "黑暗迸发",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local damageIncrease = getDamageIncrease(self)
		return ([[向敌人发射一股灼热的黑暗能量，造成 %d 点伤害。黑暗能量有 25%% 概率致盲目标 3 回合并使它们丢失当前目标。 
		 受精神强度影响，伤害有额外加成。 
		 你对任何进入黑暗之雾的人造成 +%d%% 点伤害。]]):format(damDesc(self, DamageType.DARKNESS, damage), damageIncrease)
	end,
}

registerTalentTranslation{
	id = "T_DARK_TENDRILS",
	name = "黑暗触手",
	info = function(self, t)
		local pinDuration = t.getPinDuration(self, t)
		local damage = t.getDamage(self, t)
		local damageIncrease = getDamageIncrease(self)
		return ([[伸出黑暗触手攻击你的敌人并使它们在黑暗里定身 %d 回合。当黑暗触手移动时，黑暗之雾会跟随蔓延。 
		 每回合黑暗会造成 %d 点伤害。 
		 受精神强度影响，伤害有额外加成。你对任何进入黑暗之雾的人造成 +%d%% 点伤害。]]):format(pinDuration, damage, damageIncrease)
	end,
}




return _M
