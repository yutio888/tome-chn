local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DIFFRACTION_PULSE",
	name = "衍射脉冲",
	info = function(self, t)
		return ([[在目标所在地创造一个地块, 击退所有的飞行物如果可能的话还会改变他们的方向.]])
	end,}

registerTalentTranslation{
	id = "T_MIRROR_WALL",
	name = "反射镜墙",
	info = function(self, t)
		local halflength = t.getHalflength(self, t)
		local duration = t.getDuration(self, t)
		return([[创造一堵墙长 %d 持续 %d 回合, 反射所有击中此墙的飞行物并且阻挡视线.]]):
		format(halflength * 2 + 1, duration)
	end,}

registerTalentTranslation{
	id = "T_SPATIAL_PRISM",
	name = "空间棱镜",
	info = function(self, t)
		return([[选择一个飞行中抛射物复制并使它们分开. 你获得新的抛射物所有权.]])
	end,}

registerTalentTranslation{
	id = "T_MIRROR_SELF",
	name = "自我镜像",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDam(self, t)
		local health = t.getHealth(self, t)
		return([[召唤一个持续 %d 回合能施放你所有法术的镜像, 造成 %d%% 的伤害和拥有 %d%% 生命值. 此外, 镜像造成的所有光伤害转换为暗影伤害，所有暗影伤害转换为光伤害.]]):
		format(duration, damage * 100, health * 100)
	end,}
	
	return _M