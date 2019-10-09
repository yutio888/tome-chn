local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_AGILE_DEFENSE",
	name = "敏捷防御",
	info = function (self,t)
		local chance = t.getChance(self, t)
		return ([[你学会了在战斗中灵敏使用投石索和盾牌的技巧。允许你装备盾牌，用  敏捷代替力量需求。
当你装备盾牌，且格挡技能未进入冷却时，有 %d%% 几率抵挡攻击，减免 50%% 格挡值的伤害。]])
			:format(chance)
	end,
}
registerTalentTranslation{
	id = "T_VAULT",
	name = "跳跃",
	info = function (self,t)
		local dam = t.getDamage(self, t) * 100
		local range = t.getDist(self, t)
		return ([[用盾牌踩在临近目标上，造成 %d%% 伤害并眩晕 2 回合，  之后将其做为跳板跃向 %d 格内的空地。
盾袭将使用敏捷代替力量决定盾牌伤害。
技能等级 5 时，你将在落地后立刻进入格挡状态。]])
		:format(dam, range)
	end,
}
registerTalentTranslation{
	id = "T_BULL_SHOT",
	name = "冲锋射击",
	info = function (self,t)
		return ([[你冲向敌人，同时准备射击。当你接近敌人时，立刻射击，释放强大的威力。
		射击造成 %d%% 武器伤害并击退目标 %d 格.
		每次你移动时，该技能的冷却时间减少 1 回合。
		该技能需要投石索。]]):
		format(t.getDamage(self,t)*100, t.getDist(self, t))
	end,
}
registerTalentTranslation{
	id = "T_RAPID_SHOT",
	name = "速射姿态",
	info = function (self,t)
		local atk = t.getAttackSpeed(self,t)*100
		local move = t.getMovementSpeed(self,t)*100
		local turn = t.getTurn(self,t)
		return ([[进入流畅而灵活的射击姿势，更适用于近战。你的远程攻击速度增加 %d%% ，每次射击令你在两回合内移动速度增加 %d%%  。
命中敌人的远程攻击将给你带来 %d%% 额外回合，该效果对三格以内的目标有 100%% 效果，每增加 1 格距离，效果降低 20%% ( 8 格降为 0 %% )。该效果每回合只能生效一次。
该技能需要投石索。]]):
		format(atk, move, turn)
	end,
}

return _M