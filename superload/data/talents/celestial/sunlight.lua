local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SEARING_LIGHT",
	name = "灼热之矛",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你祈祷太阳之力形成一束灼热的长矛，对目标造成 %d 点伤害，并在地上半径为 1 的范围内留下灼热光斑，每回合对其中的敌人造成 %d 光系伤害，持续 4 回合。 
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.LIGHT, damage), damDesc(self, DamageType.LIGHT, damage/2))
	end,
}

registerTalentTranslation{
	id = "T_SUN_FLARE",
	name = "日珥闪耀",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local res = t.getRes(self, t)
		local resdur = t.getResDuration(self, t)
		return ([[祈祷太阳之力，在 %d 码半径范围内致盲目标，持续 %d 回合并照亮你的周围区域。
		范围内的敌人将会受到 %0.2f 光系伤害。
		等级 3 时，你将获得 %d%% 光系、暗影和火焰伤害抗性，  持续 %d 回合。
		受法术强度影响，伤害和抗性有额外加成。]]):
		format(radius, duration, damDesc(self, DamageType.LIGHT, damage), res, resdur )

   end,
}

registerTalentTranslation{
	id = "T_FIREBEAM",
	name = "阳炎喷射",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[汲取太阳之力向目标射出一束太阳真火，射向最远的敌人，对这条直线上的所有敌人造成 %0.2f 火焰伤害。 
		这一技能将会每隔一个回合自动额外触发一次，共额外触发 2 次。
		 受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.FIRE, damage))
	end,
}

registerTalentTranslation{
	id = "T_SUNBURST",
	name = "日炎爆发",
	info = function(self, t)
		return ([[对半径 %d 范围内最多 %d 个敌人射出一团太阳光线，对所有击中的目标造成 %d 伤害，并使你的光系伤害加成增加相当于你暗影伤害加成 %d%% 的值，持续 %d 回合。]]):format( self:getTalentRadius(t), t.getTargetCount(self, t), damDesc(self, DamageType.LIGHT, t.getDamage(self, t)), t.getPower(self, t)*100, t.getDuration(self, t))
	end,
}

return _M
