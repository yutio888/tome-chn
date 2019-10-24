local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_DIGEST",
	name = "消化",
	info = function(self, t)
		return ([[ 造成 %d%% 近战武器伤害并尝试消化生命在 %d%% 以下的敌人。
		消化过程中你每回合获得 %d 疯狂值。
		精英消化时间为 5 0 回合，其他生物消化时间为2 5 回合。]]):
		format(100 * t.getDamage(self, t), t.getMax(self, t), t.getInsanity(self, t))
	end,
}

registerTalentTranslation{
	id = "T_PAINFUL_AGONY",
	name = "极度痛苦",
	info = function(self, t)
		return ([[ 正在被你消化的目标承受着极大的痛苦，让你能趁机侵入它的思维。
		你可以窃取并使用它的一个随机技能（技能等级 %d）。
		技能等级 5 时，你可以指定窃取的技能。
		你不能窃取你已知的技能。
		窃取的技能使用时不消耗资源。
		]]):format(t.getTalentLevel(self, t))
	end,
}

registerTalentTranslation{
	id = "T_INNER_TENTACLES",
	name = "内部触手",
	info = function(self, t)
		return ([[你的肚子内产生小型触手，对消化中的目标造成更多折磨。
		每次你暴击时，触手将进一步折磨目标，为你提供更多能量，持续 3 回合。
		该效果为你的攻击提供 20%% 几率吸血，将 %d%% 伤害转化为治疗。]]):
		format(t.getLeechValue(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CONSUME_WHOLE",
	name = "完整消化",
	info = function(self, t)
		return ([[立刻消化掉当前目标，获得 %d 生命和 %d 疯狂值。
		使用该技能会立刻重置消化技能的冷却。
		生命回复受法术强度加成。]]):
		format(t.getHeal(self, t), t.getInsanity(self, t))
	end,
}

return _M
