local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_INSTILL_FEAR",
	name = "恐惧灌输",
	info = function(self, t)
		local damInstil = t.getDamage(self, t) / 2
		local damTerri = t.getTerrifiedDamage(self, t) / 2
		local damHaunt = t.getHauntedDamage(self, t) / 2
		return ([[将恐惧注入目标范围内 %d 半径内的敌人中，造成 %0.2f 精神和 %0.2f 暗影伤害，并随机造成4种可能的恐惧效果之一，持续 %d 回合。
		目标可以与你的精神强度对抗，以抵抗恐惧效果。
		恐惧效果受精神强度加成。
		
		可能的恐惧效果如下所示：
		#ORANGE#妄想症:#LAST# 目标有 %d%% 几率物理攻击附近的生物，不管它是敌对还是友方生物。如果击中了目标，目标也会感染妄想症。
		#ORANGE#绝望:#LAST# 精神伤害抵抗，精神豁免，护甲值和闪避各降低 %d 。
		#ORANGE#惊惧:#LAST# 每回合受到 %0.2f 精神和 %0.2f 暗影伤害，技能冷却时间增加 %d%% 。
		#ORANGE#恶灵缠身:#LAST# 目标每有一个负面精神效果，则每回合受到 %0.2f 精神和 %0.2f 暗影伤害。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.MIND, damInstil), damDesc(self, DamageType.DARKNESS, damInstil), t.getDuration(self, t),
		t.getParanoidAttackChance(self, t),
		-t.getDespairStatChange(self, t),
		damDesc(self, DamageType.MIND, damTerri), damDesc(self, DamageType.DARKNESS, damTerri), t.getTerrifiedPower(self, t),
		damDesc(self, DamageType.MIND, damHaunt), damDesc(self, DamageType.DARKNESS, damHaunt)
	)
	end,
}

registerTalentTranslation{
	id = "T_HEIGHTEN_FEAR",
	name = "恐惧深化",
	info = function(self, t)
		local tInstillFear = self:getTalentFromId(self.T_INSTILL_FEAR)
		local range = self:getTalentRange(t)
		local turnsUntilTrigger = t.getTurnsUntilTrigger(self, t)
		local duration = tInstillFear.getDuration(self, tInstillFear)
		local damage = t.getDamage(self, t)
		return ([[加深你周围敌人的恐惧。所有被你灌注恐惧的目标若待在你视野内%d的范围内%d个不连续的回合，则会受到 %0.2f 精神和 %0.2f 暗影伤害，并获得一个新的恐惧效果，持续%d回合。
		这一效果无视恐惧免疫，但可以被豁免。]]):
			format(range, turnsUntilTrigger, damDesc(self, DamageType.MIND, t.getDamage(self, t) / 2), damDesc(self, DamageType.DARKNESS, t.getDamage(self, t) / 2 ), duration)
	end,
}

registerTalentTranslation{
	id = "T_TYRANT",
	name = "精神专制",
	info = function(self, t)
		return ([[提高对被你恐惧的目标的精神专制。当一个敌人获得了一个新的恐惧效果，你有 %d%% 的几率增加这一效果和另一个随机的已有恐惧效果的持续时间 %d 回合，最多8回合。
		此外，每当你恐惧一个目标，你获得 %d 精神强度和物理强度，持续5回合，最多叠加 %d 层]]):format(t. getExtendChance(self, t), t.getExtendFear(self, t), t.getTyrantPower(self, t), t.getMaxStacks(self, t))
	end,
}

registerTalentTranslation{
	id = "T_PANIC",
	name = "惊慌失措",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		return ([[使 %d 范 围 内 的 敌 人 惊 慌 失 措， 持 续 %d 回 合， 任 何 未 通 过 精 神 豁 免 的 敌 人 每 回 合 将 有 %d%% 概 率 从 你 身 边 吓 走。]]):format(range, duration, chance)
	end,
}



return _M
