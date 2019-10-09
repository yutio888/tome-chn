local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_EMPTY_HAND",
	name = "空手道",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[当你徒手或仅装备手套和臂铠时提高 %d 物理强度。 
		受技能等级影响，效果有额外加成。 ]]):
		format(damage)
	end,
}

registerTalentTranslation{
	id = "T_UNARMED_MASTERY",
	name = "徒手大师",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[增加 %d%% 所有徒手伤害，提高 30 物理强度（包括抓取 / 徒手技）。 
		注意：徒手战斗时格斗家随等级每级增加 0.5 物理强度。（当前提高 %0.1f 物理强度）你的攻击速度提高 20%% 。]]):
		format(100*inc, self.level * 0.5)
	end,
}

registerTalentTranslation{
	id = "T_UNIFIED_BODY",
	name = "强化身躯",
	info = function(self, t)
		return ([[你对徒手格斗的掌握强化了你的身体，增加 %d 力量（基于灵巧）， %d 体质（基于敏捷）。]]):format(t.getStr(self, t), t.getCon(self, t))
	end,
}

registerTalentTranslation{
	id = "T_HEIGHTENED_REFLEXES",
	name = "高度反射",
	info = function(self, t)
		local power = t.getPower(self, t)
		return ([[当你被抛射物锁定时，增加你 %d%% 整体速度 1 回合。 
		除了移动外的任何动作均会打破此效果。]]):
		format(power * 100)
	end,
}

registerTalentTranslation{
	id = "T_REFLEX_DEFENSE",
	name = "闪避神经",
	info = function(self, t)
		return ([[你对生理的了解让你能在新的领域运用你的闪避神经。 
		 攻击姿态的减伤效果增强 %d%% ，对你的暴击伤害的暴击系数下降 %d%% 。]]):
		format(t.getFlatReduction(self,t), t.critResist(self,t) )
	end,
}


return _M
