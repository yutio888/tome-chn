local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_HASTE_OF_THE_DOOMED",
	name = "加速",
	info = function(self, t)
		local v = t.getPower(self, t)
		return ([[加速自身，以至于脱离空间，传送半径 %d 。
		你在同一回合内至多连用两次该技能，且第二次使用会消耗时间。
		之后，你停留在相位外 5 回合，闪避增加 %d , 全体抗性增加 %d%% 。
		效果受意志加成。]]):
		format(self:getTalentRange(t), v, v)
	end,
}

registerTalentTranslation{
	id = "T_RESILIENCE_OF_THE_DOOMED",
	name = "强韧",
	info = function(self, t)
		return ([[你在恶魔空间忍受的折磨让你更加强韧。
		所有负面状态持续时间减少 %d%% , 同时你能摆脱 %d%% 暴击伤害。]]):
		format(t.effectsReduce(self, t), t.critResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CORRUPTION_OF_THE_DOOMED",
	name = "腐化",
	info = function(self, t)
		return ([[你原本的隐身技能被腐化扭曲了。
		当你受到一次伤害超过 10%% 总生命值时，有 %d%% 几率转变成多瑟顿形态 5 回合。
		在多瑟顿形态下：
		-  你获得永久潜行 (强度 %d )
		-  你的暗影伤害增加 %d%%
		-  每当你造成超过 %d 点的非物理非精神伤害时，在半径 1 的范围内产生一次暗影爆炸，造成额外 50%% 伤害（每回合至多 1 次）。
		-  变形时重置种族技能“加速”与种族技能“无情”
		]]):
		format(t.getChance(self, t), t.getStealth(self, t), t.getDarkness(self, t), t.getThreshold(self, t))
	end,
}

registerTalentTranslation{
	id = "T_PITILESS",
	name = "无情",
	info = function(self, t)
		return ([[你对目标的精神进行冲击。
		他所有正在冷却中的技能冷却时间延长 %d 回合，所有负面魔法、物理、精神效果延长 %d 回合，所有正面魔法、物理、精神效果缩短 %d 回合。]]):
		format(t.getEffectGood(self, t), t.getEffectBad(self, t), t.getEffectGood(self, t))
	end,
}


return _M
