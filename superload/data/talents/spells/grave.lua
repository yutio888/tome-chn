local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CHILL_OF_THE_TOMB",
	name = "极寒坟墓",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[召唤 1 个冰冷的球体射向目标并产生死亡的冰冷爆炸对目标造成 %0.2f 冰冷伤害，范围 %d 码。 
		 受法术强度影响，伤害有额外加成。
		 同时，当鬼火开启时，被这个法术杀死的单位将产生鬼火。]]):
		format(damDesc(self, DamageType.COLD, damage), radius)
	end,
}

registerTalentTranslation{
	id = "T_WILL_O__THE_WISP",
	name = "鬼火",
	info = function(self, t)
		local chance, dam = t.getParams(self, t)
		return ([[亡灵的能量缠绕着你，当你的随从之一在亡灵光环内被摧毁时，它有 %d%% 的概率变为 1 个鬼火。 
		 鬼火会随机选择并追踪目标。当它击中目标时，它会爆炸并造成 %0.2f 冰冷伤害。 
		 受法术强度影响，伤害有额外加成。]]):
		format(chance, damDesc(self, DamageType.COLD, dam))
	end,
}

registerTalentTranslation{
	id = "T_COLD_FLAMES",
	name = "骨灵冷火",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		local darkCount = t.getDarkCount(self, t)
		return ([[冰冷的火焰从目标点向 %d 个方向扩散，有效范围 %d 码半径。火焰会造成 %0.2f 冰冷伤害并有几率冰冻目标。 
		 受法术强度影响，伤害有额外加成。]]):format(darkCount, radius, damDesc(self, DamageType.COLD, damage))
	end,
}

registerTalentTranslation{
	id = "T_VAMPIRIC_GIFT",
	name = "血族礼物",
	info = function(self, t)
		local chance, val = t.getParams(self, t)
		return ([[血族的能量在你的身体里流动；每次你对目标造成伤害时有 %d%% 概率吸收目标血液，恢复 %d%% 伤害的生命值。 
		 受法术强度影响，吸收百分比有额外加成。]]):
		format(chance, val)
	end,
}


return _M
