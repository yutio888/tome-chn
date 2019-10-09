local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_JELLY_PBAOE",
	name = "果冻散布",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[在 1 码范围内的地板上散布腐蚀性的粘液，持续 %d 回合，对上面所有的敌对生物造成 %d 自然伤害。]]):format(duration, damDesc(self, DamageType.NATURE, damage))
	end,
}
registerTalentTranslation{
	id = "T_JELLY_MITOTIC_SPLIT",
	name = "有丝分裂",
	info = function(self, t)
		return ([[当受到最大生命值 %d%% 的攻击的时候，有 %d%% 的几率分裂。]]):format(t.getDamage(self, t), t.getChance(self, t))
	end,
}
registerTalentTranslation{
	id = "T_WAR_HOUND",
	name = "契约：战争猎犬",
	message = "@Source@ 召唤出战争猎犬",
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召唤一只战争猎犬来攻击敌人，持续 %d 回合。 
		 战争猎犬是非常好的基础近战单位。 
		 它拥有 %d 点力量， %d 点敏捷和 %d 点体质。 
		 你的召唤物继承你部分属性：增加百分比伤害、震慑 / 定身 / 混乱 / 致盲抵抗和护甲穿透。 
		 受精神强度影响，猎犬的力量和敏捷有额外加成。]])
		:format(t.summonTime(self, t), incStats.str, incStats.dex, incStats.con)
	end,
}

registerTalentTranslation{
	id = "T_JELLY",
	name = "契约：果冻怪",
	message = "@Source@ 召唤出果冻怪",
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召唤一只果冻怪来攻击敌人，持续 %d 回合。 
		 果冻怪不会移动。 
		 它拥有 %d 点体质和 %d 点力量。 
		 每当果冻怪受到伤害时，你降低等同于它受到伤害值的 10 ％失衡值。 
		 你的召唤物继承你部分属性：增加百分比伤害、震慑 / 定身 / 混乱 / 致盲抵抗和护甲穿透。 
		 受精神强度影响，果冻怪的体质有额外加成。]])
		:format(t.summonTime(self, t), incStats.con, incStats.str)
	end,
}

registerTalentTranslation{
	id = "T_MINOTAUR",
	name = "契约：米诺陶",
	message = "@Source@ 召唤出米诺陶",
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召唤一只米诺陶来攻击敌人，持续 %d 回合。米诺陶不会呆很长时间，但是它们会造成极大伤害。 
		 它拥有 %d 点力量， %d 点体质和 %d 点敏捷。 
		 你的召唤物继承你部分属性：增加百分比伤害、震慑 / 定身 / 混乱 / 致盲抵抗和护甲穿透。 
		 受精神强度影响，米诺陶的力量和敏捷有额外加成。]])
		:format(t.summonTime(self,t), incStats.str, incStats.con, incStats.dex)
	end,
}

registerTalentTranslation{
	id = "T_STONE_GOLEM",
	name = "契约：岩石傀儡",
	message = "@Source@ 召唤出岩石傀儡",
	info = function(self, t)
		local incStats = t.incStats(self, t,true)
		return ([[召唤一只岩石傀儡来攻击敌人，持续 %d 回合。岩石傀儡是可怕的敌人并且不可阻挡。 
		 它有 %d 点力量， %d 点体质和 %d 点敏捷。 
		 你的召唤物继承你部分属性：增加百分比伤害、震慑 / 定身 / 混乱 / 致盲抵抗和护甲穿透。 
		 受精神强度影响，傀儡的力量和敏捷有额外加成。]])
		:format(t.summonTime(self, t), incStats.str, incStats.con, incStats.dex)
	end,
}


return _M
