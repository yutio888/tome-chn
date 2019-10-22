local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RITCH_FLAMESPITTER_BOLT",
	name = "火焰喷射",
	message = "@Source@ 喷出火焰!",
	info = function(self, t)
		return ([[吐出一枚火球造成 %0.2f 火焰伤害。 
		受精神强度影响，伤害有额外加成。]]):format(damDesc(self, DamageType.FIRE, self:combatTalentMindDamage(t, 8, 120)))
	end,
}
registerTalentTranslation{
	id = "T_WILD_RITCH_FLAMESPITTER_BOLT",
	name = "火焰喷射",
	message = "@Source@ 喷出火焰!",
	info = function(self, t)
		return ([[吐出一枚火球造成 %0.2f 火焰伤害。 
		受精神强度影响，伤害有额外加成。]]):format(damDesc(self, DamageType.FIRE, self:combatTalentMindDamage(t, 8, 120)))
	end,
}
registerTalentTranslation{
	id = "T_FLAME_FURY",
	name = "火焰之怒",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[发射一道火焰波，范围 %d 码内的敌人被击退并引燃，造成 %0.2f 火焰伤害持续 3 回合。 
		受精神强度影响，伤害有额外加成。]]):format(radius, damDesc(self, DamageType.FIRE, damage))
	end,
}

registerTalentTranslation{
	id = "T_ACID_BREATH",
	name = "酸液吐息",
	message = "@Source@ 喷出酸液!",
	info = function(self, t)
		return ([[向单体目标喷射酸液造成 %0.2f 伤害。 
		受意志影响，伤害有额外加成。]]):format(damDesc(self, DamageType.ACID, self:combatTalentStatDamage(t, "wil", 30, 430)))
	end,
}

registerTalentTranslation{
	id = "T_ACID_SPIT_HYDRA",
	name = "酸液喷吐",
	message = "@Source@ 呼出酸液!",
	info = function(self, t)
		return ([[向敌人喷射酸液造成 %0.2f 伤害。 
		受意志影响，伤害有额外加成。]]):format(damDesc(self, DamageType.ACID, self:combatTalentStatDamage(t, "wil", 30, 430)))
	end,
}


registerTalentTranslation{
	id = "T_LIGHTNING_BREATH_HYDRA",
	name = "闪电吐息",
	message = "@Source@ 呼出闪电!",
	info = function(self, t)
		return ([[向敌人喷出闪电吐息造成 %d 到 %d 伤害。 
		受意志影响，伤害有额外加成。]]):
		format(
			damDesc(self, DamageType.LIGHTNING, (self:combatTalentStatDamage(t, "wil", 30, 500)) / 3),
			damDesc(self, DamageType.LIGHTNING, self:combatTalentStatDamage(t, "wil", 30, 500))
		)
	end,
}

registerTalentTranslation{
	id = "T_LIGHTNING_SPIT_HYDRA",
	name = "闪电喷吐",
	message = "@Source@ 喷出闪电!",
	info = function(self, t)
		return ([[向单体敌人喷吐闪电造成 %d 到 %d 伤害。 
		受意志影响，伤害有额外加成。]]):
		format(
			damDesc(self, DamageType.LIGHTNING, (self:combatTalentStatDamage(t, "wil", 30, 500)) / 3),
			damDesc(self, DamageType.LIGHTNING, self:combatTalentStatDamage(t, "wil", 30, 500))
		)
	end,
}


registerTalentTranslation{
	id = "T_POISON_BREATH",
	name = "毒性吐息",
	message = "@Source@ 呼出毒液!",
	info = function(self, t)
		return ([[向敌人施放剧毒吐息至你的目标造成 %d 伤害，持续数回合。 
		受意志影响，伤害有额外加成。]]):format(damDesc(self, DamageType.NATURE, self:combatTalentStatDamage(t, "wil", 30, 460)))
	end,
}

registerTalentTranslation{
	id = "T_POISON_SPIT_HYDRA",
	name = "毒性喷吐",
	message = "@Source@ 喷出毒液!",
	info = function(self, t)
		return ([[向单体敌人施放剧毒喷吐至你的目标造成 %d 伤害，持续数回合。 
		受意志影响，伤害有额外加成。]]):format(damDesc(self, DamageType.NATURE, self:combatTalentStatDamage(t, "wil", 30, 460)))
	end,
}


registerTalentTranslation{
	id = "T_WINTER_S_FURY",
	name = "严冬之怒",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[一阵激烈的冰风暴环绕施法者造成每回合 %0.2f 冰冷伤害，有效范围 3 码，持续 %d 回合。 
		有 25%% 几率使受伤害目标被冰冻。 
		受意志影响 , 伤害和持续时间有额外加成。]]):format(damDesc(self, DamageType.COLD, damage), duration)
	end,
}

registerTalentTranslation{
	id = "T_WINTER_S_GRASP",
	name = "严冬抓握",
	info = function(self, t)
		return ([[将目标抓取到自己的身边，用寒霜覆盖它，使其移动速度减少 50%% ，持续 %d 回合。
		寒冰还会对其造成 %0.2f 寒冷伤害。
		伤害和减速几率受精神强度加成。]]):
		format(t.getDuration(self, t), damDesc(self, DamageType.COLD, self:combatTalentMindDamage(t, 5, 140)))
	end,
}

registerTalentTranslation{
	id = "T_RITCH_FLAMESPITTER",
	name = "契约：火焰里奇",
	message = "@Source@ 召唤出火焰里奇!",
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召唤一只火焰里奇来燃烧敌人，持续 %d 回合。火焰里奇很脆弱，但是它们可以远远地燃烧敌人。 
		它拥有 %d 点意志， %d 点灵巧和 %d 点体质。 
		你的召唤物继承你部分属性：增加百分比伤害、抗性穿透、震慑 / 定身 / 混乱 / 致盲抵抗和护甲穿透。 
		受精神强度影响，火焰里奇的意志和灵巧有额外加成。]])
		:format(t.summonTime(self, t), incStats.wil, incStats.cun, incStats.con)
	end,
}

registerTalentTranslation{
	id = "T_HYDRA",
	name = "契约：三头蛇",
	message = "@Source@ 召唤出三头蛇!",
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召唤一只三头蛇来摧毁敌人，持续 %d 回合。 
		三头蛇可以喷出毒系、酸系、闪电吐息。 
		它拥有 %d 点意志， %d 点体质和 18 点力量。 
		你的召唤物继承你部分属性：增加百分比伤害、震慑 / 定身 / 混乱 / 致盲抵抗和护甲穿透。 
		受精神强度影响，三头蛇的意志有额外加成。]])
		:format(t.summonTime(self, t), incStats.wil, incStats.con, incStats.str)
	end,
}

registerTalentTranslation{
	id = "T_RIMEBARK",
	name = "契约：雾凇",
	message = "@Source@ 召唤出雾凇",
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召唤 1 棵雾凇来来骚扰敌人，持续 %d 回合。 
		雾凇不可移动，但是永远有寒冰风暴围绕着它们，伤害并冰冻 3 码半径范围内的任何人。 
		它拥有 %d 点意志， %d 点灵巧和 %d 点体质。 
		你的召唤物继承你部分属性：增加百分比伤害、震慑 / 定身 / 混乱 / 致盲抵抗和护甲穿透。 
		受精神强度影响，雾凇的意志和灵巧有额外加成。]])
		:format(t.summonTime(self, t), incStats.wil, incStats.cun, incStats.con)
	end,
}

registerTalentTranslation{
	id = "T_FIRE_DRAKE",
	name = "契约：火龙",
	message = "@Source@ 召唤出火龙",
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		return ([[召唤一只火龙来摧毁敌人，持续 %d 回合。 
		火龙是可以从很远的地方烧毁敌人的强大生物。 
		它拥有 %d 点力量， %d 点体质和 38 点意志。 
		你的召唤物继承你部分属性：增加百分比伤害、震慑 / 定身 / 混乱 / 致盲抵抗和护甲穿透。 
		受精神强度影响，火龙的力量和体质有额外加成。]])
		:format(t.summonTime(self, t), incStats.str, incStats.con)
	end,
}


return _M
