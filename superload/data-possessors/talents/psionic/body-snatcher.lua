local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_BODIES_RESERVE",
	name = "躯体储备",
	info = function (self,t)
		return ([[你的头脑是如此强大，它可以扭曲现实，为你提供一个非自然的 #{italic}#仓库#{normal}# 让你储存抢夺过来的身体。
		仓库容量增加 %d 。]]):
		format(t.getMax(self, t))
	end,
}
registerTalentTranslation{
	id = "T_PSIONIC_MINION",
	name = "灵能奴役",
	info = function (self,t)
		return ([[你将自己的心灵的一部分融入一个身体，而不会实际上表现出来。
		身体会作为你的仆从工作 %d 回合。
		灵能仆从无法被任何方法治疗。
		当效果结束时，身体永久丢失。]]):
		format(t.getDur(self, t))
	end,
}
registerTalentTranslation{
	id = "T_PSIONIC_DUPLICATION",
	name = "灵能复制",
	info = function (self,t)
		return ([[当你获得一个身体时复制 %d 个克隆体.
		当你获得稀有/史诗/Boss 或者更高阶级的身体时，复制的数量除以 3 (至少一个).]]):
		format(t.getNb(self, t))
	end,
}
registerTalentTranslation{
	id = "T_CANNIBALIZE",
	name = "合并",
	info = function (self,t)
		return ([[合并一个身体，用来补充现在使用的身体。
		你只能合并同阶级或者更高阶级的身体且每次治疗效果降低 33%% 。
		生命值恢复被合并的身体的最大血量 %d%% 且你的灵能值恢复这个数值的 50%% 。
		该治疗不会被其他效果减低，合并是治疗身体的唯一方法。]]):
		format(t.getHeal(self, t))
	end,
}
return _M