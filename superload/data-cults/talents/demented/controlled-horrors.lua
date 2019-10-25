local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DECAYED_DEVOURERS",
	name = "腐败吞噬者",
	info = function(self, t)
		return ([[你利用和恐魔的联系召唤三个持续 %d 轮的腐败吞噬者。
		腐败吞噬者不能移动，能攻击周围所有敌对生物。它们拥有浴血奋战、咬牙切齿和狂乱撕咬技能。
		它们的所有主属性将设为 %d (基于你的魔法属性 )，生命回复速度增加 %d ，所有技能等级设为 %d 。许多其他属性与技能等级相关。
		它们将继承你的伤害加成、伤害抗性穿透、暴击几率和暴击伤害系数。]]):
		format(t.getDur(self, t), t.getStats(self, t), t.getLifeRating(self, t), math.floor(self:getTalentLevel(t)))
	end,
}

registerTalentTranslation{
	id = "T_DECAYED_BLADE_HORROR",
	name = "腐败浮肿恐魔",
	info = function(self, t)
		return ([[你利用和恐魔的联系召唤一个持续 %d 回合的腐败浮肿恐魔。
		腐败的恐魔不能移动，能攻击范围内的所有敌对生物。它拥有精神干扰和精神光束技能。
		它们的所有主属性将设为 %d (基于你的魔法属性 )，生命回复速度增加 %d ，所有技能等级设为 %d 。许多其他属性与技能等级相关。
		它们将继承你的伤害加成、伤害抗性穿透、暴击几率和暴击伤害系数。、
		]]):
		format(t.getDur(self, t), t.getStats(self, t), t.getLifeRating(self, t), math.floor(self:getTalentLevel(t)))
	end,
}

-- Check for permanently changing target and possible general overpoweredness
registerTalentTranslation{
	id = "T_HORRIFIC_DISPLAY",
	name = "恐魔具现化",
	info = function(self, t)
		return ([[你强行让一个生物变化为恐魔。
		如果目标生物未能通过魔法豁免， %d 回合内它的相貌将转变为恐魔，令周围其他生物与之敌对。
		目标生物周围的敌人将重新考虑其攻击目标。
		该法术对恐魔无效。]])
		:format(t.getDur(self, t))
	end,
}

registerTalentTranslation{
	name = "阿玛克塞尔的呼唤", 
	id = "T_DEMENTED_CALL_AMAKTHEL",
	info = function(self, t)
		return ([[ 你将你的恐魔和已死之神阿玛克塞尔同化，增加恐魔 %d%% 伤害。
		技能等级 3 后，你的腐败吞噬者法术将额外召唤四名吞噬者在随机敌人周围，你的浮肿恐魔将学会极度痛苦。 
		技能等级 5 后，你的恐魔具现化的目标将获得“每回合将周围敌人朝你身边拉 1 格”的法术。
伤害加成随法术强度而增加。]]):
		format(t.getDam(self, t))
	end,
}
return _M
