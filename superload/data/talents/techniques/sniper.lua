local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_CONCEALMENT",
	name = "隐匿",
	info = function (self,t)
		local avoid = t.getAvoidance(self,t)*3
		local range = t.getSight(self,t)
		local radius = t.getRadius(self,t)
		return ([[进入隐匿的狙击状态, 增加武器攻击范围和视野 %d 格, 所有攻击有 %d%% 几率无法命中你, 爆头、齐射和精巧射击视为目标已被标记.
所有非瞬时非移动行为将打破隐匿状态, 攻击范围与视野的加成和伤害回避效果将额外持续 3 回合, 伤害回避效果每回合减少 33%%.
该技能需要弓来使用, 如果在你周围 %d 格内有敌人, 则不能使用.]]):
		format(range, avoid, radius)
	end,
}
registerTalentTranslation{
	id = "T_SHADOW_SHOT",
	name = "暗影射击",
	info = function (self,t)
		local dam = t.getDamage(self,t)*100
		local radius = self:getTalentRadius(t)
		local sight = t.getSightLoss(self,t)
		local cooldown = t.getCooldownReduction(self,t)
		return ([[发射一个带着烟雾弹的箭头造成 %d%% 伤害并制造一个半径为 %d 的烟雾. 被困在内的人将减少视野 %d 格 5 回合.
此效果将减少你隐匿技能 %d 回合冷却时间. 如果冷却时间减到 0, 无论敌人是否太近, 都可立即激活隐匿.
烟雾弹影响目标的几率随你命中增加.]]):
		format(dam, radius, sight, cooldown)
	end,
}
registerTalentTranslation{
	id = "T_AIM",
	name = "瞄准姿态",
	info = function (self,t)
		local power = t.getPower(self,t)
		local speed = t.getSpeed(self,t)
		local dam = t.getDamage(self,t)
		local mark = t.getMarkChance(self,t)
		return ([[进入一个平静, 专注的姿态, 增加 %d 物理强度和命中, 抛射物速度增加 %d%% 并且标记目标的几率增加 %d%%.
这让你在射程内射击更有效：对三格外目标的距离每增加一格，伤害增加 %0.1f%% , 8 格距离时达到最大值（ %0.1f%% ）。
物理强度和命中随敏捷增加.]]):
		format(power, speed, mark, dam, dam*5)
	end,
}
registerTalentTranslation{
	id = "T_SNIPE",
	name = "狙击",
	info = function (self,t)
		local dam = t.getDamage(self,t)*100
		local reduction = t.getDamageReduction(self,t)
		return ([[瞄准 1 回合, 准备射出一发致命的子弹. 下回合, 这个技能被替换成标记目标并造成 %d%% 伤害的致命攻击 .
若你处于瞄准姿态，专注力让你无视受到的 %d%% 伤害和所有负面状态。]]):
		format(dam, reduction)
	end,
}
registerTalentTranslation{
	id = "T_SNIPE_FIRE",
	name = "狙击",
	info = function (self,t)
		return ([[射出一发致命射击. 这次射击将绕过你和你的目标之间的其他敌人, 并提高 100 命中.]]):
		format(dam, reduction)
	end,
}

return _M
