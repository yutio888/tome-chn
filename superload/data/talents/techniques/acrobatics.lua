local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SKIRMISHER_VAULT",
	name = "撑杆跳",
	info = function(self, t)
		return ([[利用相邻的友军或敌人作为跳板，从他们头上跳入技能范围内的另外一格中。
		这个伎俩使你借助弹跳的力量提高你的速度，让你在跳跃的方向上的移动速度增加 %d%% 三回合。
		如果你改变方向或者停止移动，速度加成将会消失。
		]]):format(t.speed_bonus(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_CUNNING_ROLL",
	name = "翻滚",
	message = function(self, t) return "@Source@ 滚向更有利的位置!" end,
	info = function(self, t)
		return ([[从敌人的侧面、上空或者胯下移动到技能范围内的指定位置。
		这个伎俩可以惊吓你的敌人让你获得更有利的战术位置，增加你的暴击几率 %d%% 1 回合。]]):format(t.combat_physcrit(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_TRAINED_REACTIONS",
	name = "求生本能",
	info = function(self, t)
		local trigger = t.getLifeTrigger(self, t)
		local reduce = t.getReduction(self, t)
		local cost = t.stamina_per_use(self, t) * (1 + self:combatFatigue() * 0.01)
		return ([[当这个技能被激活的时候，你能够预见到致命的伤害。
		每当你遭受一次大于 %d%% 生命值的攻击时，你闪身躲避这个攻击并摆出防御姿势。
		这个技能降低本次伤害和接下来本回合的所有伤害 %d%% 。
		你需要 %0.1f 体力和相邻的无人空地来触发技能效果（尽管你不会因为躲避而移动）。]])
		:format(trigger, reduce, cost)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_SUPERB_AGILITY",
	name = "身轻如燕",
	info = function(self, t)
		return ([[你使用杂耍系技能更加得心应手，降低撑杆跳、翻滚和求生本能的冷却时间 %d 回合，降低技能的体力消耗 %0.1f 。
		在等级 3 时，每当求生本能触发，你获得 10%% 的全局速度 1 回合。
		在等级 5 时，速度加成变为 20%% ，持续 2 回合。]])
		:format(t.cooldown_bonus(self, t), t.stamina_bonus(self, t))
	end,
}


return _M
