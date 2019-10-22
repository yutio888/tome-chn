local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WING_BUFFET",
	name = "龙翼飓风",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你召唤一阵强风，击退半径 %d 码内的敌人至多 3 格，并造成 %d%% 武器伤害。
		同时，每个技能等级增加你的物理强度和命中 2 点。
		每点火龙系的技能可以使你增加火焰抵抗 1%% 。
		如果你装备了盾牌，这一技能也会用你的盾牌攻击。]]):format(self:getTalentRadius(t),damage*100)
	end,
}

registerTalentTranslation{
	id = "T_BELLOWING_ROAR",
	name = "怒意咆哮",
	message = "@Source@ 开始咆哮!",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local power = 20 + 6 * self:getTalentLevel(t)
		return ([[你发出一声咆哮使 %d 码半径范围内的敌人陷入彻底的混乱（强度 %d%%），持续 3 回合。 
		如此强烈的咆哮使你的敌人受到 %0.2f 物理伤害。 
		受力量影响，伤害有额外加成。 
		每点火龙系的技能可以使你增加火焰抵抗 1%% 。]]):format(radius, power, self:combatTalentStatDamage(t, "str", 30, 380))
	end,
}

registerTalentTranslation{
	id = "T_DEVOURING_FLAME",
	name = "火焰吞噬",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		return ([[你喷出一片火焰，范围内的目标每回合会受到 %0.2f 火焰伤害（影响半径 %d ），持续 %d 回合。 
		火焰会无视使用者，并吸收 10%% 伤害治疗自身。
		伤害受精神强度加成。技能可暴击。 
		每点火龙系的技能可以使你增加火焰抵抗 1%% 。]]):format(damDesc(self, DamageType.FIRE, dam), radius, duration)
	end,
}

registerTalentTranslation{
	id = "T_FIRE_BREATH",
	name = "火焰吐息",
	message = "@Source@ 呼出火焰!",
	info = function(self, t)
		return ([[你在前方 %d 码锥形范围内喷出火焰。此范围内的目标会在 3 回合内受到 %0.2f 火焰伤害。
		受力量影响，伤害有额外加成，暴击几率基于你的精神暴击率。 
		每点火龙系的技能可以使你增加火焰抵抗 1%% 。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.FIRE, t.getDamage(self, t)))
	end,
}


return _M
