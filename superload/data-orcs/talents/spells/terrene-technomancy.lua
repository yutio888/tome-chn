local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MICRO_SPIDERBOT",
	name = "迷你蜘蛛机器人",
	info = function(self, t)
		local damage = t.getDamage(self, t) / 2
		local range = self:getTalentRange(t)
		return ([[你使用周围的土元素制造 %d 个迷你蜘蛛机器人。蜘蛛机器人是由和你的力量相连的奥术致冷单元驱动的。
		蜘蛛机器人每个回合会对它们的目标造成 %0.2f 寒岩（物理和寒冷）伤害。极寒的攻击有 25%% 的几率冻结目标的双脚，将他们定身 5 回合。
		如果目标被击杀了，蜘蛛机器人将会跳跃到你半径 %d 码范围内的另一个敌人身上。如果这个目标上有多个机器人，并且在范围内有足够多的可选目标，他们会尽可能分散地跳到每个敌人身上。
		如果一个目标的身上附身了多个蜘蛛机器人，他们会一起攻击，伤害会叠加（但收益递减），并且会一起试图冻结目标。
		你可以维持最多 %d 个蜘蛛机器人，他们最多存活 %d 回合。但是，只有在你视野范围内的蜘蛛机器人才会行动。
		这一技能的冷却时间受岩石身躯的影响。
		技能伤害受法术强度加成。

		你现在有 %d 个蜘蛛机器人。]]):format(t.getNbBots(self, t), damDesc(self, DamageType.PHYSICAL, damage) + damDesc(self, DamageType.COLD, damage), range, t.getMaxBots(self, t), t.getDur(self, t), self.micro_spiderbots_store and #self.micro_spiderbots_store.bots or 0)
	end,
}

registerTalentTranslation{
	id = "T_CRYOGENIC_DIGS",
	name = "低温掘进",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[每当一个蜘蛛机器人到持续时间时，它会钻入地下，在 1 码范围内产生寒霜冰雾 （ %0.2f 寒冷伤害，对潮湿目标造成 30%% 额外的伤害）或地震（ %0.2f 物理伤害，有 25%% 几率震慑目标 2 回合）， 持续 %d 回合。
		这种寒霜冰雾或地震不会影响技能施放者。
		伤害受法术强度提升。]]):format(damDesc(self, DamageType.COLD, damage), damDesc(self, DamageType.PHYSICAL, damage), t.getDur(self, t))
	end,
}

registerTalentTranslation{
	id = "T_RAMMING_BOT",
	name = "机器人冲撞",
	info = function(self, t)
		local damage = t.getDamage(self, t) / 2
		local radius = self:getTalentRadius(t)
		return ([[指挥一个随机的蜘蛛机器人，跳起高速撞向你的目标。这一撞击会立刻摧毁这个机器人。（可以触发低温掘进效果）
		这回造成一个半径 %d 码的爆炸，对所有生物造成 %0.2f 寒岩伤害，并冻结他们 %d 回合，使他们潮湿 %d 回合。
		这一技能的冷却时间受岩石身躯的影响。
		伤害受法术强度提升。]]):format(radius, damDesc(self, DamageType.PHYSICAL, damage) + damDesc(self, DamageType.COLD, damage), t.getDur(self, t) / 2, t.getDur(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SPIDERBOT_SHIELD",
	name = "机器人护盾",
	info = function(self, t)
		return ([[你召回最多 %d 个蜘蛛机器人，在你的身边形成一个保护屏障，持续 %d 回合。
		蜘蛛机器人有 %d 点生命值，会依次承受伤害。如果被摧毁，他们会完全承受摧毁他们的那一击伤害。
		如果你激活了低温掘进，被摧毁的机器人会跳向攻击你的敌人，然后在那里向下掘进。
		这一技能的冷却时间受岩石身躯的影响。]])
		:format(t.getNbBots(self, t), t.getDur(self, t), t.getLife(self, t))
	end,
}

return _M