local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ACCELERATE",
	name = "窃速神偷",
	info = function(self, t)
		local dur = t.getDuration(self, t)
		local speed = t.getSpeed(self, t)
		return ([[扭曲周围时空，周围 7 码内敌人移动速度降低 50%% ，持续 %d 回合。
		你使用偷取的速度强化自身，使自己获得一回合神速状态，移动速度提高 %d%%，每减速一个敌人，额外提高 %d%%，最大个数 4 个。
		移动外的任何行动将终止加速效果。]]):
		format(dur, speed, speed/8)
	end,
}

registerTalentTranslation{
	id = "T_SWITCH",
	name = "偷天换日",
	info = function(self, t)
		local nb = t.getNb(self,t)
		local dur = t.getDuration(self,t)
		return ([[释放熵浪潮，清除自己的灾祸，同时吸取他人的能量。 10 码内所有敌人的 %d 项有益效果持续时间缩短 %d 回合。自身同等数量的有害效果持续时间缩短同等回合。]]):
		format(nb, dur)
	end,
}

registerTalentTranslation{
	id = "T_SUSPEND",
	name = "窃命凝固",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local dur = t.getDuration(self,t)
		return ([[你和 %d 码内所有敌人在时间中凝固 %d 回合，无法行动但也无法被伤害。
		自身的有害效果持续时间和技能 CD 会正常扣减，有益效果持续时间不变。
		敌人的有害效果持续时间和技能 CD 不会扣减，有益效果持续时间正常扣减。]]):format(rad, dur)
	end,
}

registerTalentTranslation{
	id = "T_SPLIT",
	name = "命运裂解",
	info = function(self, t)
		local dur = t.getDuration(self, t)
		local power = t.getPower(self,t)
		local res = 80 - power
		local dam = 40 + power
		local life = 20 + power
		return ([[将目标敌人从正常时间流部分移除，持续 %d 回合，隔绝他们与现实世界交互的能力。移除期间敌人受到的伤害降低 %d%% ，造成的伤害也降低 %d%% 。
		技能启动时，你从受损的时间线中召唤敌人的时空克隆体协助你战斗，持续时间与敌人移除时间相同，克隆体生命值降低 %d%% ，造成伤害降低 %d%% ，其他能力与本体相同。]]):
		format(dur, res, dam, life, dam)
	end,
}
return _M
