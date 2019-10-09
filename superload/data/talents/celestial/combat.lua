local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WEAPON_OF_LIGHT",
	name = "光明之刃",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local shieldflat = t.getShieldFlat(self, t)
		return ([[使你的武器充满太阳能量，每击造成 %0.2f 光系伤害。 
		 如果你同时打开了临时伤害护盾，每回合一次，你的近战攻击命中可以增加护盾 %d 强度。
		 受法术强度影响，伤害和护盾加成有额外加成。]]):
		format(damDesc(self, DamageType.LIGHT, damage), shieldflat)
	end,
}

registerTalentTranslation{
	id = "T_WAVE_OF_POWER",
	name = "光明冲击",
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[你用光明力量释放一次近程打击，造成 %d%% 武器伤害。 
		如果目标在近战范围以外，有一定几率进行二次打击，造成 %d%% 武器伤害。
		二次打击几率随距离增加，距离 2 时为 %0.1f%% ，距离最大（ %d ）时几率为 %0.1f%% 。
		受力量影响，攻击距离有额外加成。]]):
		format(t.getDamage(self, t)*100, t.getDamage(self, t, true)*100, t.SecondStrikeChance(self, t, 2), range,t.SecondStrikeChance(self, t, range))
	end,
}

registerTalentTranslation{
	id = "T_WEAPON_OF_WRATH",
	name = "愤怒之刃",
	info = function(self, t)
		local martyr = t.getMartyrDamage(self, t)
		local damagepct = t.getLifeDamage(self, t)
		local damage = t.getDamage(self, t)
		return ([[你使用武器攻击时，造成相当于 %d%% 你已损失的生命值的火焰伤害 , 至多 %d 点,当前 %d 点 
		然后令目标进入殉难状态，受到 %d%% 自己造成的伤害，持续 4 回合。
		每回合最多触发一次额外伤害。]]):
		format(damagepct*100, t.getMaxDamage(self, t, 10, 400), damage, martyr)
	end,
}

registerTalentTranslation{
	id = "T_SECOND_LIFE",
	name = "第二生命",
	info = function(self, t)
		return ([[任何使你生命值降到 1 点以下的攻击都会激活第二生命，自动中断此技能并将你的生命值恢复到 1 点,然后受到 %d 点治疗。]]):
		format(t.getLife(self, t))
	end,
}

return _M
