local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHOOT",
	name = "射击",
	info = function(self, t)
		return ([[使用弓箭、投石索或者其他什么东西发射！]])
	end,
}

registerTalentTranslation{
	id = "T_STEADY_SHOT",
	name = "稳固射击",
	info = function (self,t)
		local dam = t.getDamage(self,t)*100
		local chance = t.getChance(self,t)
		return ([[稳固地射击，造成 %d%% 伤害，同时有 %d%% 几率标记目标。
如果稳固射击没有进入冷却状态，将自动代替普通攻击，并进入冷却。]]):
		format(dam, chance)
	end,
}
registerTalentTranslation{
	id = "T_PIN_DOWN",
	name = "强力定身",
	info = function (self,t)
		local dam = t.getDamage(self,t)*100
		local dur = t.getDuration(self,t)
		local mark = t.getMarkChance(self,t)
		local chance = t.getChance(self,t)
		return ([[你朝目标发射定身攻击，造成 %d%% 伤害，并尝试将目标定身 %d 回合。
		你对目标的下一发射击或者稳固射击将增加 100%% 暴击率与标记几率。
		此次攻击有 20%% 几率标记目标。
		定身几率受命中加成。]]):
		format(dam, dur, mark, chance)
	end,
}
registerTalentTranslation{
	id = "T_FRAGMENTATION_SHOT",
	name = "爆裂射击",
	info = function (self,t)
		local rad = self:getTalentRadius(t)
		local dam = t.getDamage(self,t)*100
		local dur = t.getDuration(self,t)
		local speed = t.getSpeedPenalty(self,t)*100
		local chance = t.getChance(self,t)
		return ([[发射命中后爆裂成 %d 格半径球型范围碎片的弹药, 造成 %d%% 武器伤害并致残目标 %d 回合，降低  %d%% 攻击、施法和精神速度。
		每个被击中的目标有 %d%% 几率被标记。
		致残几率受命中加成。]])
		:format(rad, dam, dur, speed, chance)
	end,
}
registerTalentTranslation{
	id = "T_SCATTER_SHOT",
	name = "分散射击",
	info = function (self,t)
		local rad = self:getTalentRadius(t)
		local dam = t.getDamage(self,t)*100
		local dur = t.getDuration(self,t)
		local chance = t.getChance(self,t)
		return ([[射出弹药化为 %d 格锥形冲击波，造成 %d%% 伤害，被击中的单位将被击退至范围外，并被震慑 %d 回合。
		每个被击中的目标有 %d%% 几率被标记。
		击退与震慑几率受命中加成。]])
		:format(rad, dam, dur, chance)
	end,
}
registerTalentTranslation{
	id = "T_HEADSHOT",
	name = "爆头",
	info = function (self,t)
		local dam = t.getDamage(self,t)*100
		return ([[瞄准目标头部发射穿透性弹药，造成 %d%% 武器伤害。
此次攻击额外获得 100 命中，且能穿透目标以外单位。
只能对被标记的单位使用，使用将消耗掉标记。 ]]):
		format(dam)
	end,
}
registerTalentTranslation{
	id = "T_VOLLEY",
	name = "齐射",
	info = function (self,t)
		local rad = self:getTalentRadius(t)
		local dam = t.getDamage(self,t)*100
		return ([[你向天空发射无数弹药，如箭雨般落向目标，造成 %d%% 伤害，杀伤  半径 %d 格。
如果中心目标被标记，你将消耗其标记，不消耗弹药发射额外齐射一轮，造成 %d%% 伤害。]])
		:format(dam, rad, dam*0.75)
	end,
}
registerTalentTranslation{
	id = "T_CALLED_SHOTS",
	name = "精巧射击",
	info = function (self,t)
		local dam = t.getDamage(self,t)*100
		local dur = t.getDuration(self,t)
		return ([[你朝目标的喉咙（或者类似部位）射击，造成 %d%% 武器伤害并沉默 %d 回合。
如果目标被标记，则消耗标记并额外向目标的手臂与大腿（或者类似部位）射击两次，造成 %d%% 伤害 , 降低其 50 %% 移动速度，同时使其不能使用武器。
状态效果几率受命中加成。]]):
		format(dam, dur, dam*0.25)
	end,
}
registerTalentTranslation{
	id = "T_BULLSEYE",
	name = "靶心",
	info = function (self,t)
		local speed = t.getSpeed(self,t)*100
		local nb = t.getTalentCount(self,t)
		local cd = t.getCooldown(self,t)
		return ([[每次消耗标记时，获得 %d%% 攻击速度 2 回合，并减少 %d 个战斗技巧系技能冷却时间 %d 回合。]]):
		format(speed, nb, cd)
	end,
}
registerTalentTranslation{
	id = "T_RELAXED_SHOT",
	name = "宁神射击",
	info = function (self,t)
		return ([[你射出放松的一箭, 造成 %d%% 伤害，同时回复 %d 体力。
		]]):format(self:combatTalentWeaponDamage(t, 0.5, 1.1) * 100, 12 + self:getTalentLevel(t) * 8)
	end,
}
registerTalentTranslation{
	id = "T_CRIPPLING_SHOT",
	name = "致残射击",
	info = function (self,t)
		return ([[你射出致残一箭 ,造成 %d%% 伤害，并降低目标 %d%% 速度 7 回合。
		状态效果受命中加成。]]):format(self:combatTalentWeaponDamage(t, 1, 1.5) * 100, util.bound((self:combatAttack() * 0.15 * self:getTalentLevel(t)) / 100, 0.1, 0.4) * 100)
	end,
}
registerTalentTranslation{
	id = "T_PINNING_SHOT",
	name = "定身射击",
	info = function (self,t)
		return ([[你射出定身一箭 , 造成 %d%% 伤害，并定身目标 %d 回合。
		定身几率受敏捷加成。]])
		:format(self:combatTalentWeaponDamage(t, 1, 1.4) * 100,
		t.getDur(self, t))
	end,
}