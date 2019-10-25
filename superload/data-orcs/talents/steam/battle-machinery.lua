local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_EXPLOSIVE_STEAM_ENGINE",
	name = "引擎轰炸",
	info = function(self, t)
		return ([[在战场上投掷一枚两回合后爆炸的微型不稳定蒸汽引擎。
		爆炸后在 %d 码范围内产生灼热的蒸汽云雾，对范围内敌人造成 %0.2f 的火焰伤害。
		流血状态的敌人会受到 40%% 的额外火焰伤害。
		伤害随蒸汽强度增加。
		#{italic}#嘀嗒嘀嗒嘀嗒轰！！#{normal}#]])
		:format(self:getTalentRadius(t), damDesc(self, DamageType.FIRE, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_LINGERING_CLOUD",
	name = "厚重云雾",
	info = function(self, t)
		return ([[引擎轰炸产生的蒸汽云雾现在会持续 5 回合。
		每回合云雾范围内的流血敌人会受到 %0.2f 火焰伤害。
		任何使用蒸汽科技的生物在云雾中每回合额外回复 %d 蒸汽值。
		伤害随蒸汽强度增加。 
		#{italic}#尝尝最新科技带来的燃烧服务吧！#{normal}#]])
		:format(damDesc(self, DamageType.FIRE, t.getDamage(self, t)), t.getRegen(self, t))
	end,}

registerTalentTranslation{
	id = "T_TREMOR_ENGINE",
	name = "巨震引擎",
	info = function(self, t)
		return ([[在战场上投掷一枚两回合后触发的巨震引擎。
		触发后 5 回合内，他会持续的造成地面的小范围震动，震慑、定身或者缴械范围 %d 内任何生物 %d 回合。
		#{italic}#你脚下是纸, 不是大地。颤抖吧！#{normal}#]])
		:format(self:getTalentRadius(t), t.getDur(self, t))
	end,}


registerTalentTranslation{
	id = "T_SEISMIC_ACTIVITY",
	name = "地震爆发",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[巨震引擎的最后一次爆发输出撕裂地面，引出岩浆，形成一座火山，持续 %d 回合。
		每回合，火山会喷出熔岩球，造成 %0.2f 火焰伤害 %0.2f 物理伤害。
		伤害随蒸汽强度增加。
		#{italic}#品尝火焰之怒吧！#{normal}#]])
		:format(t.getDur(self, t), damDesc(self, DamageType.FIRE, dam/2), damDesc(self, DamageType.PHYSICAL, dam/2))
	end,}

return _M