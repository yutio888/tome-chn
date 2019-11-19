local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WILD_GROWTH",
	name = "野性生长",
	info = function(self, t)
		return ([[使你自身周围环绕无数微不可见、有治疗作用的孢子。
		你获得 %d 最大生命值， %d 生命回复。
		效果受意志值加成。]]):
		format(t.getLife(self, t), t.getRegen(self, t))
	end,
}

registerTalentTranslation{
	id = "T_FUNGAL_GROWTH",
	name = "真菌生长",
	info = function(self, t)
		return ([[你身上的孢子让回复效果更加持久。
		每当你获得一个回复类的增益效果，你会让它的持续时间增加 %d%% +1，向上取整。
		技能效果受意志值加成。]]):
		format(t.getDurationBonus(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_ANCESTRAL_LIFE",
	name = "原始生命",
	info = function(self, t)
		local eq = t.getEq(self, t)
		local turn = t.getTurn(self, t)
		return ([[你的孢子可以追溯到创世纪元，你可以传承来自远古的天赋。 
		每当你获得一个非回复的治疗效果，每治疗 100 点生命值，你获得 %d%% 个回合。
		这一效果最多获得 2 个回合。
		同时，每当你受到回复作用时，每回合你的失衡值将会减少 %0.1f 。 
		受精神强度影响，增益回合有额外加成。]]):
		format(turn * 100, eq)
	end,
}

registerTalentTranslation{
	id = "T_SUDDEN_GROWTH",
	name = "疯狂成长",
	info = function(self, t)
		local mult = t.getMult(self, t)
		return ([[一股强大的能量穿过你的孢子，使其立刻对你释放治愈性能量，治疗你 %d%% 当前生命回复值 (#GREEN#%d#LAST#)。]]):
		format(mult * 100, self.life_regen * mult)
	end,
}


return _M
