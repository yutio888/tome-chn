local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_WTW_DESTRUCT",
	name = "自爆",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		return ([[自爆成一团血肉，对周围 %d 码半径内所有敌人造成 %0.2f 枯萎伤害。这个技能只有主人死亡时能够使用。]])
			:format(rad, damDesc(self, DamageType.BLIGHT, 50 + 10 * self.level))
	end,
}
registerTalentTranslation{
	id = "T_TELEPORT_KROSHKKUR",
	name = "传送: 克诺什库尔",
	info = function(self, t) return ([[允许传送至克诺什库尔。
	你学习了那里的禁忌秘密，因此获得了传送至克诺什库尔的法术。
	该法术必须保持机密；它在有其他人在场时不能使用。
	该法术需要 40 回合生效，在此期间你需要处于任何生物视线外。]]) end,
}

registerTalentTranslation{
	id = "T_DREM_CALL_OF_AMAKTHEL",
	name = "阿玛克塞尔的呼唤",
	info = function(self, t)
		return ([[将 10 格内的敌人朝你拉近 2 格。]])
	end,
}


registerTalentTranslation{
	id = "T_BLIGHTLASH",
	name = "枯萎鞭挞",
	info = function(self, t)
		return ([[用触手打击 10 码范围内的一个敌人，造成 %d%% 枯萎伤害。]]):
		format(t.getDamageTentacle(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_CRUMBLE",
	name = "瓦解",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[发射黑暗能量，对目标造成 %0.2f 伤害并破坏 3 格范围内的墙壁。伤害受法术强度加成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage))
	end,
}

registerTalentTranslation{
	id = "T_TWISTED_EVOLUTION",
	name = "扭曲进化",
	info = function(self, t)
		return ([[进化 10 格范围内至多 %d 名友方单位 5 回合。
		#ORCHID#速度:#LAST# 增加 %d%% 整体速度。
		#ORCHID#形态:#LAST# 增加 %d 全属性。
		#ORCHID#力量:#LAST# 增加 %d%% 伤害。]]):format(t.getAmount(self, t), t.getEvolveSpeed(self, t) * 100, t.getEvolveStat(self, t), t.getEvolveDamage(self, t))
	end,
}

registerTalentTranslation{
	id = "T_GLASS_SPLINTERS",
	name = "玻璃碎片",
	info = function(self, t)
		return ([[ 使用玻璃碎片攻击敌人，造成 %d%% 奥术武器伤害。
		如果攻击命中，目标将被玻璃碎片扎 6 回合。
		每回合目标将受到 8%% 攻击伤害的流血伤害。
		同时每当目标移动时，受到 %d%% 攻击伤害。 
		技能等级 5 后，目标有 15%% 几率使用技能失败。]])
		:format(t.getDam(self, t) * 100, t.getMovePenalty(self, t))
	end,
}

registerTalentTranslation{
	id = "T_THROW_PEEBLE",
	name = "投掷鹅卵石",
	info = function(self, t)
		return ([[朝目标扔石头，造成 %0.2f 物理伤害。
		伤害受力量加成。]]):format(damDesc(self, DamageType.PHYSICAL, t.getDam(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_NETHERFORCE",
	name = "虚空之力",
	info = function(self, t)
		local dam = t.getDamage(self,t)/2
		local backlash = t.getBacklash(self,t)
		return ([[用虚空之力攻击目标，造成 %0.2f 暗影 %0.2f 时空伤害并击退 8 格。 
		该法术会产生熵能反冲，让你在 8 回合内受  到 %d 伤害。
		伤害受法术强度加成。]]):
		format(damDesc(self, DamageType.DARKNESS, dam), damDesc(self, DamageType.TEMPORAL, dam), backlash)
	end,
}
return _M
