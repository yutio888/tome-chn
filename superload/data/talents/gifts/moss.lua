local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GRASPING_MOSS",
	name = "减速苔藓",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local slow = t.getSlow(self, t)
		local pin = t.getPin(self, t)
		local radius = self:getTalentRadius(t)
		return ([[在你的脚下，半径 %d 的范围内生长出苔藓。 
		 每回合苔藓对半径内的敌人会造成 %0.2f 点自然伤害。 
		 这种苔藓又厚又滑，所有经过的敌人的移动速度会被降低 %d%% ，并有 %d%% 概率被定身 4 回合。 
		 苔藓持续 %d 个回合。 
		 苔藓系技能无需使用时间，但会让同系其他技能进入 3 回合的冷却。 
		 受精神强度影响，伤害有额外加成。 ]]):
		format(radius, damDesc(self, DamageType.NATURE, damage), slow, pin, duration)
	end,
}

registerTalentTranslation{
	id = "T_NOURISHING_MOSS",
	name = "生命苔藓",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local heal = t.getHeal(self, t)
		local radius = self:getTalentRadius(t)
		return ([[ 在你的脚下，半径 %d 的范围内生长出苔藓。 
		 每回合苔藓对半径内的敌人会造成 %0.2f 点自然伤害。 
		 这种苔藓具有吸血功能，会治疗使用者，数值等于造成伤害的 %d%% 。 
		 苔藓持续 %d 个回合。 
		 苔藓系技能无需使用时间，但会让同系其他技能进入 3 回合的冷却。 
		 受精神强度影响，伤害有额外加成。 ]]):
		format(radius, damDesc(self, DamageType.NATURE, damage), heal, duration)
	end,
}

registerTalentTranslation{
	id = "T_SLIPPERY_MOSS",
	name = "光滑苔藓",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local fail = t.getFail(self, t)
		local radius = self:getTalentRadius(t)
		return ([[ 在你的脚下，半径 %d 的范围内生长出苔藓。 
		 每回合苔藓对半径内的敌人会造成 %0.2f 点自然伤害。 
		 这种苔藓十分光滑，会使所有受影响的敌人有 %d%% 概率不能做出复杂行动。
		 苔藓持续 %d 个回合。 
		 苔藓系技能无需使用时间，但会让同系其他技能进入 3 回合的冷却。 
		 受精神强度影响，伤害有额外加成。 ]]):
		format(radius, damDesc(self, DamageType.NATURE, damage), fail, duration)
	end,
}

registerTalentTranslation{
	id = "T_HALLUCINOGENIC_MOSS",
	name = "迷幻苔藓",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local chance = t.getChance(self, t)
		local power = t.getPower(self, t)
		local radius = self:getTalentRadius(t)
		return ([[ 在你的脚下，半径 %d 的范围内生长出苔藓。 
		 每回合苔藓对半径内的敌人会造成 %0.2f 点自然伤害。 
		 这种苔藓上沾满了奇怪的液体，有 %d%% 概率让对方混乱（ %d%% 强度） 2 个回合。  
		 苔藓持续 %d 个回合。 
		 苔藓系技能无需使用时间，但会让同系其他技能进入 3 回合的冷却。 
		 受精神强度影响，伤害有额外加成。 ]]):
		format(radius, damDesc(self, DamageType.NATURE, damage), chance, power, duration)
	end,
}


return _M
