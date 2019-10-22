local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CHANNEL_STAFF",
	name = "魔法箭",
	info = function(self, t)
		local damagemod = t.getDamageMod(self, t)
		return ([[引导冰冷的法力穿过你的法杖，发射出 1 道能造成 %d%% 法杖伤害的魔法箭。 
		这道魔法可以安全的穿过己方队友，只会对敌方目标造成伤害。 
		此攻击能 100%% 命中并无视目标护甲。
		法杖的伤害系数会增加 0.2 。]]):
		format(damagemod * 100)
	end,
}

registerTalentTranslation{
	id = "T_STAFF_MASTERY",
	name = "法杖掌握",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[使用法杖时，增加 %d%% 法杖伤害，同时增加 30 物理强度。]]):
		format(100 * inc)
	end,
}

registerTalentTranslation{
	id = "T_DEFENSIVE_POSTURE",
	name = "闪避姿态",
	info = function(self, t)
		local defense = t.getDefense(self, t)
		return ([[采取闪避姿态，增加你 %d 点闪避和护甲值。]]):
		format(defense)
	end,
}

registerTalentTranslation{
	id = "T_BLUNT_THRUST",
	name = "钝器挥击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local dazedur = t.getDazeDuration(self, t)
		return ([[挥动法杖对目标造成 %d%% 近程伤害并震慑目标 %d 回合。 
		受法术强度影响，震慑概率有额外加成。 
		在等级 5 时，此攻击必中。]]):
		format(100 * damage, dazedur)
	end,
}


return _M
