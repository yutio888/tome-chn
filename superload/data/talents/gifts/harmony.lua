local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WATERS_OF_LIFE",
	name = "生命之水",
	info = function(self, t)
		return ([[生命之水流过你的身体，净化你身上的毒素或疾病效果。 
		 在 %d 回合内所有的毒素或疾病效果都无法伤害却能治疗你。 
		 当此技能激活时，你身上每有 1 种毒素或疾病效果，恢复 %d 点生命。 
		 受意志影响，治疗量有额外加成。]]):
		format(t.getdur(self,t), self:combatTalentStatDamage(t, "wil", 20, 60))
	end,
}

registerTalentTranslation{
	id = "T_ELEMENTAL_HARMONY",
	name = "元素和谐",
	info = function(self, t)
		local power = self:getTalentLevel(t)
		local turns = t.duration(self, t)
		local fire = 100 * t.fireSpeed(self, t)
		local cold = 3 + power * 2
		local lightning = math.floor(power)
		local acid = 5 + power * 2
		local nature = 5 + power * 1.4
		return ([[通过自然协调与元素们成为朋友。每当你被某种元素攻击时，你可以获得对应效果，持续 %d 回合。每 %d 回合只能触发一次。 
		 火焰： +%d%% 全部速度 
		 寒冷： +%d 护甲值 
		 闪电： +%d 所有属性 
		 酸液： +%0.2f 生命回复 
		 自然： +%d%% 所有抵抗]]):
		format(turns, turns, fire, cold, lightning, acid, nature)
	end,
}

registerTalentTranslation{
	id = "T_ONE_WITH_NATURE",
	name = "自然之友",
	info = function(self, t)
		local turns = t.getCooldown(self, t)
		local nb = t.getNb(self, t)
		return ([[与自然交流，移除纹身类技能饱和效果并减少 %d 种纹身 %d 回合冷却时间。]]):
		format(nb, turns)
	end,
}

registerTalentTranslation{
	id = "T_HEALING_NEXUS",
	name = "治疗转移",
	info = function (self,t)
		local pct = t.getPct(self, t)*100
		return ([[在你的身旁 %d 码半径范围内流动着一波自然能量，所有被击中的敌人都会受到治疗转移的效果，持续 %d 回合。 
		 每次你被治疗，会回复 %d 点自然失衡值，治疗效率 %d%% 。
		 当此技能激活时，所有对敌人的治疗都会转移到你身上，继承 %d%% 治疗价值。（敌人不受到治疗） 
		 。]]):
		format(self:getTalentRadius(t), t.getDur(self, t), t.getEquilibrium(self, t), 100 + pct, pct)
	end,
}


return _M
