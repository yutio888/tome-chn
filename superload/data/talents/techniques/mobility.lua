local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DISENGAGE",
	name = "后跳",
	info = function (self,t)
		return ([[指定目标，向后跳跃 %d 格，可以跃过途中所有生物。
		你必须选择可见目标，必须以近乎直线的轨迹后跳。
		落地后，你获得 3 回合 %d%% 移动速度加成，采取除移动外的行动会提前终止。
		移动速度和跳跃距离会受疲劳值影响。]]):
		format(t.getDist(self, t), t.getSpeed(self,t), t.getNb(self,t))
	end,
}

registerTalentTranslation{
	id = "T_EVASION",
	name = "闪避",
	info = function (self,t)
		local chance, def = t.getChanceDef(self,t)
		return ([[你的战斗技巧和反射神经让你能迅速躲闪攻击，获得 %d%% 几率躲闪近战与远程攻击，闪避增加 %d ，持续 %d 回合。
		躲闪几率和闪避加成受敏捷加成。]]):
		format(chance, def,t.getDur(self,t))
	end,
}

registerTalentTranslation{
	id = "T_TUMBLE",
	name = "翻筋斗",
	info = function (self,t)
		return ([[你迅速地移动至范围内可见的位置，跃过路径上所有敌人。
		该技能在身着重甲时不能使用，使用后你会进入疲劳状态，增加移动系技能消耗 %d%% （可以叠加），%d 回合后解除。]]):format(t.getExhaustion(self,t),t.getDuration(self,t))
	end,
}

registerTalentTranslation{
	id = "T_TRAINED_REACTIONS",
	name = "特种训练",
	info = function (self,t)
		local stam = t.getStamina(self, t)
		local trigger = t.getLifeTrigger(self, t)
		local reduce = t.getReduction(self, t, true)*100
		return ([[经过训练后，你脚步轻快，神经敏锐。
		技能开启时，你会对任何将超过你 %d%% 最大生命值的伤害做出反应。
		消耗 %0.1f 体力，你将减少 %d%% 伤害。
		身着重甲时无法使用。
		伤害减免受闪避加成。]])
		:format(trigger, stam, reduce)
	end,
}


return _M
