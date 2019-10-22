local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MASTER_SUMMONER",
	name = "召唤精通",
	info = function(self, t)
		local cooldownred = t.getCooldownReduction(self, t)
		return ([[降低所有召唤系技能 %d%% 冷却时间。]]):
		format(cooldownred * 100)
	end,
}

registerTalentTranslation{
	id = "T_GRAND_ARRIVAL",
	name = "野性降临",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[当召唤精通激活时，每个召唤兽出现在世界上时，它会触发 1 个野性效果： 
		- 火焰里奇：减少范围内所有敌人的火焰抵抗 %d%%
		- 三头蛇：生成一片持续的毒雾，范围内所有敌人每回合受到 %0.1f 自然伤害（可叠加）
		- 雾凇：减少范围内所有敌人的寒冷抵抗 %d%%
		- 火龙：出现 %d 只小火龙 
		- 战争猎犬：减少范围内所有敌人的物理抵抗 %d%%
		- 果冻怪：减少范围内所有敌人的自然抵抗 %d%%
		- 米诺陶：减少范围内所有敌人的移动速度 %0.1f%%
		- 岩石傀儡：眩晕范围内所有敌人 
		- 乌龟：治疗范围内所有友军单位 %d 生命值
		- 蜘蛛：定身范围内所有敌人。
		效果范围 %d ，每个持续效果维持 %d 回合。 
		受精神强度影响，效果有额外加成。]]):format(t.resReduction(self, t), t.poisonDamage(self,t) / 6, t.resReduction(self, t), t.nbEscorts(self, t), t.resReduction(self, t), t.resReduction(self, t), 100*t.slowStrength(self,t), t.amtHealing(self,t), radius, t.effectDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_NATURE_CYCLE",
	name = "自然之环",
	info = function(self, t)
		return ([[当召唤精通激活时，每出现新的召唤兽会减少信息素、引爆和野性召唤的冷却时间。 
		%d%% 概率减少它们 %d 回合冷却时间。]]):format(t.getChance(self, t), t.getReduction(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WILD_SUMMON",
	name = "野性召唤",
	info = function(self, t)
		return ([[你在 %d 回合内 100%% 召唤出一只野性模式的召唤兽。 
		此概率每回合递减。
		野性召唤兽增加 1 个新的天赋： 
		- 火焰里奇：可以在空中飞行，吐火不会被路径上的生物所阻挡。
		- 三头蛇：如果发现友军会被击中，则将吐息改为单体攻击。
		- 雾凇：可以抓取敌人，将它们拉进自己的冰风暴范围。
		- 火龙：可以用怒吼来沉默敌人 
		- 战争猎犬：可以狂暴，增加它的暴击率和护甲穿透值 
		- 果冻怪：可以在被攻击造成较大伤害的时候，分裂出一个果冻怪（分裂出的果冻怪不会占用你的召唤物上限）
		- 米诺陶：可以向目标冲锋 
		- 岩石傀儡：可以缴械敌人。
		- 乌龟：可以嘲讽范围内敌人进入近战状态 
		- 蜘蛛：可以向目标吐出剧毒，减少它们的治疗效果 
		此技能只有在召唤精通激活时才能使用。
		技能效果受召唤物技能等级加成。]]):format(t.duration(self,t))
	end,
}


return _M
