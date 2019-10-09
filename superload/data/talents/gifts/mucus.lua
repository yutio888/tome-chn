local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MUCUS",
	name = "粘液",
	info = function(self, t)
		local dur = t.getDur(self, t)
		local dam = t.getDamage(self, t)
		local equi = t.getEqui(self, t)
		return ([[你开始在你经过或站立的地方滴落粘液，持续 %d 回合。 
		 粘液每回合自动放置，持续 %d 回合。
		 在等级 4 时，粘液会扩展到 1 码半径范围。 
		 粘液会使所有经过的敌人中毒，每回合造成 %0.1f 自然伤害，持续 5 回合（可叠加）。 
		 站在自己的粘液上时，你每回合回复 %0.1f 失衡值。
		 每个经过粘液的友方单位，每回合将和你一起回复 1 点失衡值。  
		 受精神强度影响，伤害和失衡值回复有额外加成。 
		 在同样的位置站在更多的粘液上会强化粘液效果，增加 1 回合持续时间。]]):
		format(dur, dur, damDesc(self, DamageType.NATURE, dam), equi)
	end,
}

registerTalentTranslation{
	id = "T_ACID_SPLASH",
	name = "酸液飞溅",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[你召唤大自然的力量，将 %d 码半径范围内的地面转化为酸性淤泥区，对所有目标造成 %0.1f 酸性伤害并在区域内制造粘液。 
		 同时如果你有任何粘液软泥怪存在，则会向视线内的某个被淤泥击中的随机目标释放史莱姆喷吐（较低强度）。 
		 受精神强度影响，伤害有额外加成。]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.ACID, dam))
	end,
}

registerTalentTranslation{
	id = "T_MUCUS_OOZE_SPIT",
	name = "粘液喷吐",
	info = function(self, t)
		return ([[喷射一道射线造成 %0.2f 史莱姆伤害。 
		 受精神强度影响，伤害有额外加成。]]):format(damDesc(self, DamageType.SLIME, self:combatTalentMindDamage(t, 8, 80)))
	end,
}

registerTalentTranslation{
	id = "T_LIVING_MUCUS",
	name = "粘液伙伴",
	info = function(self, t)
		return ([[你的粘液有了自己的感知。每回合有 %d%% 几率，随机一个滴有你的粘液的码子会产生一只粘液软泥怪。 
		 粘液软泥怪会存在 %d 回合，会向任何附近的敌人释放史莱姆喷吐。 
		 同时场上可存在 %d 只粘液软泥怪。 ( 基于你的灵巧值 )
		 每当你造成一次精神暴击，你的所有粘液软泥怪的存在时间会延长 2 回合。 
		 受精神强度影响，效果有额外加成。]]):
		format(t.getChance(self, t), t.getSummonTime(self, t), t.getMax(self, t))
	end,
}

registerTalentTranslation{
	id = "T_OOZEWALK",
	name = "粘液探戈",
	info = function(self, t)
		local nb = t.getNb(self, t)
		local energy = t.getEnergy(self, t)
		return ([[你暂时性的和粘液融为一体，净化你身上 %d 物理或魔法负面效果。 
		 然后，你可以闪现到视野内任何有粘液覆盖的区域。
		 此技能使用速度很快，只消耗一般技能使用时间的 %d%% ，但只有当你站在粘液区时才能使用。]]):
		format(nb, (energy) * 100)
	end,
}


return _M
