local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TAUNT",
	name = "嘲讽",
	info = function(self, t)
		return ([[强制 %d 码范围内的所有敌对目标攻击你。]]):format(self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_SHELL_SHIELD",
	name = "甲壳护盾",
	info = function(self, t)
		return ([[隐藏在你的甲壳下，增加 %d%% 全体伤害抗性，持续 %d 回合。]]):format(t.resistPower(self, t), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SPIDER_WEB",
	name = "蜘蛛之网",
	info = function(self, t)
		return ([[朝你的目标投掷一个网，若目标被击中则被困在原地 %d 回合。]]):format(t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_TURTLE",
	name = "契约：乌龟",
	message = "@Source@ 召唤出乌龟",
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召唤一只乌龟来吸引敌人攻击，持续 %d 回合。 
		乌龟具有很强的生命力，并不能造成很多伤害。 
		然而，它们会周期性的嘲讽敌人并用龟壳保护自己。
		它拥有 %d 点体质， %d 点敏捷和 18 点意志。 
		你的召唤物继承你部分属性：增加百分比伤害、抗性穿透、震慑 / 定身 / 混乱 / 致盲抵抗和护甲穿透。 
		受精神强度影响，乌龟的体质有额外加成。]])
		:format(t.summonTime(self, t), incStats.con, incStats.dex)
	end,
}

registerTalentTranslation{
	id = "T_SPIDER",
	name = "契约：蜘蛛",
	message = "@Source@ 召唤出蜘蛛",
	info = function(self, t)
		local incStats = t.incStats(self, t,true)
		return ([[召唤一只蜘蛛来扰乱敌人，持续 %d 回合。 
		蜘蛛可以使敌人中毒并向目标撒网，将目标固定在地上。 
		它拥有 %d 点敏捷， %d 点力量， 18 点意志和 %d 点体质。 
		你的召唤物继承你部分属性：增加百分比伤害、抗性穿透、震慑 / 定身 / 混乱 / 致盲抵抗和护甲穿透。 
		受精神强度影响，蜘蛛的敏捷有额外加成。]])
		:format(t.summonTime(self, t), incStats.dex, incStats.str, incStats.con)
	end,
}

registerTalentTranslation{
	id = "T_FRANTIC_SUMMONING",
	name = "疯狂召唤",
	info = function(self, t)
		local reduc = t.getReduc(self, t)
		return ([[你专注于自然，使你的自然召唤速度提升（ %d%% 的正常召唤时间），并且即使在高自然失衡值下也不会失败，持续 %d 回合。 
		当此技能激活时，某个随机的召唤天赋会冷却。 
		每次你进行召唤，疯狂召唤的效果会减少 1 回合。]]):
		format(100 - reduc, t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SUMMON_CONTROL",
	name = "信息素",
	info = function(self, t)
		return ([[用信息素标记一个生物，向它周围 %d 码范围内的所有召唤兽发出信号，将攻击目标转移到被标记的生物身上，持续 %d 回合。]]):format(t.getRad(self,t), t.getDur(self,t))
		return ([[用信息素标记一个生物，向它周围 %d 码范围内的所有召唤兽发出信号，将攻击目标转移到被标记的生物身上，持续 %d 回合。被标记的目标从你的召唤物那里受到的伤害增加 %d%% ，你的召唤物也会集火它。
		你召唤物的伤害增加效果受精神强度加成。]]):format(t.getRad(self,t), t.getDur(self,t), t.getDamage(self,t))
	end,
}


return _M
