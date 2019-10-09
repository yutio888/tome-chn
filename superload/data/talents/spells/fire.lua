local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FLAME",
	name = "火球术",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[制造一个火球，使目标进入灼烧状态并在 3 回合内造成 %0.2f 火焰伤害。 
		 在等级 5 时，火焰会有穿透效果。 
		 受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.FIRE, damage))
	end,
}

registerTalentTranslation{
	id = "T_FLAMESHOCK",
	name = "火焰冲击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local stunduration = t.getStunDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在你前方制造一片 %d 码半径锥形范围的火焰。 
		 任何在此范围的目标会被燃烧的火焰震慑，共受到 %0.2f 点火焰伤害，持续 %d 回合。
		 受法术强度影响，伤害有额外加成。]]):
		format(radius, damDesc(self, DamageType.FIRE, damage), stunduration)
	end,
}

registerTalentTranslation{
	id = "T_FIREFLASH",
	name = "爆裂火球",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[向你的目标发射一枚爆裂火球，造成 %0.2f 火焰伤害，有效范围 %d 码。 
		 受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.FIRE, damage), radius)
	end,
}

registerTalentTranslation{
	id = "T_INFERNO",
	name = "地狱火",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[向地上释放一片火焰，每回合可对敌我双方造成 %0.2f 火焰伤害，半径 %d 码，持续 %d 回合。 
		 受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.FIRE, damage), radius, duration)
	end,
}


return _M
