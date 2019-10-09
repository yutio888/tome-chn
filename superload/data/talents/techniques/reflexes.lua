
local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_SHOOT_DOWN",
	name = "击落",
	info = function (self,t)
		return ([[你的反射像闪电一样快, 如果你发现一个抛射物 (箭矢, 弹丸, 法术, ...) 你可以不消耗时间立刻射击之。
		最多可同时击落 %d 个抛射物。
		此外, 射向你的抛射物飞行速度下降 %d%% ，你的抛射物不再击中你自己。]]):
		format(t.getNb(self, t), t.getSlow(self,t))
	end,
}
registerTalentTranslation{
	id = "T_INTUITIVE_SHOTS",
	name = "直觉射击",
	info = function (self,t)
		local chance = t.getChance(self,t)
		local dam = t.getDamage(self,t)*100
		return ([[激活这个技能将你的反应提升到令人难以置信的水平. 每当你被近身攻击, 你有 %d%% 几率射出一箭拦截攻击, 躲闪攻击并造成 %d%% 伤害.
		该技能每回合触发最多一次.]])
		:format(chance, dam)
	end,
}
registerTalentTranslation{
	id = "T_SENTINEL",
	name = "哨兵",
	info = function (self,t)
		local nb = t.getTalentCount(self,t)
		local cd = t.getCooldown(self,t)
		return ([[你在接下来的 5 回合内密切关注目标. 当其使用非瞬发技能时, 你立刻做出反应, 射出一箭造成 25%% 伤害打断技能并使其进入冷却.
该攻击为瞬间击中, 必中, 并使其它 %d 个技能进入冷却 %d 回合.]]):
		format(nb, cd)
	end,
}
registerTalentTranslation{
	id = "T_ESCAPE",
	name = "逃脱",
	info = function (self,t)
		local power = t.getDamageReduction(self,t)
		local sta = t.getStamina(self,t)
		local speed = t.getSpeed(self,t)
		return ([[你专注逃跑 4 回合. 处于此状态时增加 %d%% 所有伤害抗性, %0.1f 体力恢复, 免疫震慑, 定身, 眩晕和减速效果并增加 %d%% 移动速度. 
除移动外的任何行动将终止该效果。]]):
		format(power, sta, speed)
	end,
}

return _M