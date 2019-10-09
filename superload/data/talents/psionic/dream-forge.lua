local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FORGE_SHIELD",
	name = "熔炉屏障",
	info = function(self, t)
		local power = t.getPower(self, t)
		local dur = t.getDuration(self, t)
		return ([[当你将要承受一次超过 15 ％最大生命值的攻击时，你会锻造一个熔炉屏障来保护自己，减少 %0.2f 点所有该类型攻击伤害于下 %d 回合。 
		 熔炉屏障能够同时格挡多种类型的伤害，但是每一种已拥有的格挡类型会使伤害临界点上升 15 ％。
		 如果你完全格挡了某一攻击者的伤害，则此攻击者受到持续 1 回合的反击 DEBUFF（ 200 ％普通近身或远程伤害）。 
		 在等级 5 时，格挡效果将持续 2 回合。 
		 受精神强度影响，格挡值按比例加成。]]):format(power, dur)
	end,
}

registerTalentTranslation{
	id = "T_FORGE_BELLOWS",
	name = "熔炉风箱",
	info = function(self, t)
		local blast_damage = t.getBlastDamage(self, t)/2
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		local forge_damage = t.getForgeDamage(self, t)/2
		return ([[将梦之熔炉的风箱打开，朝向你的四周，对锥形范围内敌人造成 %0.2f 精神伤害， %0.2f 燃烧伤害并造成击退效果。锥型范围的半径为 %d 码。
		 空旷的地面有 50 ％几率转化为持续 %d 回合的熔炉外壁。熔炉外壁阻挡移动，并对周围敌人造成 %0.2f 的精神伤害和 %0.2f 的火焰伤害。 
		 受精神强度影响，伤害和击退几率按比例加成。]]):
		format(damDesc(self, DamageType.MIND, blast_damage), damDesc(self, DamageType.FIRE, blast_damage), radius, duration, damDesc(self, DamageType.MIND, forge_damage), damDesc(self, DamageType.FIRE, forge_damage))
	end,
}

registerTalentTranslation{
	id = "T_FORGE_ARMOR",
	name = "熔炉护甲",
	info = function(self, t)
		local armor = t.getArmor(self, t)
		local defense = t.getDefense(self, t)
		local psi = t.getPsiRegen(self, t)
		return([[你的熔炉屏障技能现在可以增加你 %d 点护甲， %d 点闪避，并且当你被近战或远程攻击击中时给予你 %0.2f 超能力值。 
		 受精神强度影响，增益按比例加成。]]):format(armor, defense, psi)
	end,
}

registerTalentTranslation{
	id = "T_DREAMFORGE",
	name = "梦之熔炉",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)/2
		local power = t.getPower(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		local fail = t.getFailChance(self,t)
		return ([[你将脑海里锻造的冲击波向四周释放。 
		 每回合当你保持静止，你将会锤击梦之熔炉，对周围敌人造成精神和燃烧伤害。 
		 此效果将递增 5 个回合，直至 %d 码最大范围， %0.2f 最大精神伤害和 %0.2f 最大燃烧伤害。 
		 此刻，你将会打破那些听到熔炉声的敌人梦境，减少它们 %d 精神豁免，并且由于敲击熔炉的 
		 巨大回声，它们将获得一个 %d%% 的法术失败率，持续 %d 回合。 
		 梦境破碎有 %d%% 几率对你的敌人产生锁脑效果。 
		 受精神强度影响，伤害和梦境打破效果按比例加成。]]):
		format(radius, damDesc(self, DamageType.MIND, damage), damDesc(self, DamageType.FIRE, damage), power, fail, duration, chance)
	end,
}


return _M
