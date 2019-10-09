local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_KINETIC_LEECH",
	name = "动能吸取",
	info = function(self, t)
		local range = self:getTalentRadius(t)
		return ([[你从周围吸取动能，来增加自己的超能力值。
		减少 %d 码半径范围内的敌人 %d%% (最多 %d%% ) 速度，同时每个目标吸取 %0.1f ( 最多 %0.1f ) 点体力。 
		从第一个目标处你获得 %d ( 最多 %d ) 超能力值，之后每个目标减少 20%%.
		当超能力值减少时，技能效果会加强。]])
		:format(range, t.getSlow(self, t)*100, t.getSlow(self, t, 0)*100, t.getDam(self, t), t.getDam(self, t, 0), t.getLeech(self, t), t.getLeech(self, t, 0))
	end,
}

registerTalentTranslation{
	id = "T_THERMAL_LEECH",
	name = "热能吸取",
	info = function(self, t)
		local range = self:getTalentRadius(t)
		return ([[你从周围吸取热能，来增加自己的超能力值。
		冻结 %d 码半径范围内的敌人 %d （最多 %d ）回合，同时对每个目标造成 %0.1f （最   多 %0.1f ）点寒冷伤害。 
		从第一个目标处你获得 %d （最多 %d ）超能力值，之后每个目标减少 20%%.
		当超能力值减少时，技能效果会加强。]])
		:format(range, t.getDur(self, t), t.getDur(self, t, 0), damDesc(self, DamageType.COLD, t.getDam(self, t)), damDesc(self, DamageType.COLD, t.getDam(self, t, 0)), t.getLeech(self, t), t.getLeech(self, t, 0))
	end,
}

registerTalentTranslation{
	id = "T_CHARGE_LEECH",
	name = "电能吸取",
	info = function(self, t) 
		local range = self:getTalentRadius(t)
		return ([[你从周围吸取电能，来增加自己的超能力值。
		对 %d 码半径范围内的敌人造成 %0.1f ( 最多 %0.1f ）点闪电伤害，同时有 %d%% （   最多 %d%% ）几率使之眩晕 3 回合。 
		从第一个目标处你获得 %d ( 最多 %d ) 超能力值，之后每个目标减少 20%%.
		当超能力值减少时，技能效果会加强。]])
		:format(range,t.getDam(self, t), t.getDam(self, t, 0),  t.getDaze(self, t), t.getDaze(self, t, 0), t.getLeech(self, t), t.getLeech(self, t, 0))
	end,
}

registerTalentTranslation{
	id = "T_INSATIABLE",
	name = "贪得无厌",
	info = function(self, t)
		local recover = t.getPsiRecover(self, t)
		return ([[增加超能力值上限 %d. 每次杀死敌人获得 %0.1f 超能力值，每次精神暴击获得 %0.1f 超能力值。]]):format(5 * recover, recover, 0.5*recover)
	end,
}


return _M
