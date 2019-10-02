local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WILD_GROWTH",
	name = "野性生长",
	info = function(self, t)
		return ([[使 你 自 身 周 围 环 绕 无 数 微 不 可 见、 有 治 疗 作 用 的 孢 子。
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
		return ([[你 的 孢 子 可 以 追 溯 到 创 世 纪 元， 你 可 以 传 承 来 自 远 古 的 天 赋。  
		每 当 你 获 得 一 个 直 接 治 疗 效 果 ， 每 治 疗 100 点 生 命 值 ，你 获 得 %d%% 个 回 合。
		这 一 效 果 最 多 获 得 2 个 回 合。
		同 时， 每 当 你 受 到 回 复 作 用 时， 每 回 合 你 的 失 衡 值 将 会 减 少 %0.1f 。 
		受 精 神 强 度 影 响， 增 益 回 合 有 额 外 加 成。]]):
		format(turn * 100, eq)
	end,
}

registerTalentTranslation{
	id = "T_SUDDEN_GROWTH",
	name = "疯狂成长",
	info = function(self, t)
		local mult = t.getMult(self, t)
		return ([[一 股 强 大 的 能 量 穿 过 你 的 孢 子， 使 其 立 刻 对 你 释 放 治 愈 性 能 量， 治 疗 你 %d%% 当 前 生 命 回 复 值 (#GREEN#%d#LAST#)。]]):
		format(mult * 100,  self.life_regen * mult)
	end,
}


return _M
