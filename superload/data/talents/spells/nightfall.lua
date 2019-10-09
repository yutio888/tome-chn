local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_INVOKE_DARKNESS",
	name = "黑夜降临",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[召唤出一片黑暗，对目标造成 %0.2f 暗影伤害。 
		 在等级 3 时，它会生成暗影射线。 
		 在等级 5 时，你的黑夜降临系法术不会再伤害亡灵随从。 
		 受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage))
	end,
}

registerTalentTranslation{
	id = "T_CIRCLE_OF_DEATH",
	name = "死亡之环",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[从地上召唤出持续 5 回合的黑暗之雾。 
		 受法术强度影响，伤害有额外加成。 
		 任何生物走进去都会吸入混乱毒素或致盲毒素。 
		 对 1 个生物每次只能产生 1 种毒素效果。 
		 毒素效果持续 %d 回合并造成 %0.2f 暗影伤害。 
		 受法术强度影响，伤害有额外加成。]]):
		format(t.getBaneDur(self,t), damDesc(self, DamageType.DARKNESS, damage))
	end,
}

registerTalentTranslation{
	id = "T_FEAR_THE_NIGHT",
	name = "暗夜恐惧",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在前方锥形范围内造成 %0.2f 暗影伤害（ %d 码半径范围）。 
		 任何受影响的怪物须进行一次精神豁免鉴定，否则会被击退 4 码以外。 
		 受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage), self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_RIGOR_MORTIS",
	name = "尸僵症",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local speed = t.getSpeed(self, t) * 100
		local dur = t.getDur(self, t)
		local minion = t.getMinion(self, t)
		return ([[发射 1 个黑暗之球在范围内造成 %0.2f 暗影系伤害（ %d 码半径）。 
		 被击中的目标将会感染尸僵症并减少整体速度： %d%% 。 
		 亡灵随从对这些目标额外造成伤害： %d%% 。 
		 此效果持续 %d 回合。 
		 受法术强度影响，你的伤害和亡灵随从的伤害有额外加成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage), self:getTalentRadius(t), speed, minion, dur)
	end,
}


return _M
