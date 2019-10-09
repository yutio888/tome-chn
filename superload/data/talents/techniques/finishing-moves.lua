local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_UPPERCUT",
	name = "上钩拳",
	message = "@Source@ 施展了终结的上勾拳。",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local stun = t.getDuration(self, t, 0)
		local stunmax = t.getDuration(self, t, 5)
		return ([[一次终结的上钩拳，对目标造成 %d%% 伤害并可能震慑目标 %d 到 %d 回合（由你的连击点数决定）。 
		受物理强度影响，震慑概率有额外加成。 
		使用此技能会消耗当前的所有连击点。]])
		:format(damage, stun, stunmax)
	end,
}

registerTalentTranslation{
	id = "T_CONCUSSIVE_PUNCH",
	name = "金刚碎",
	message = "@Source@ 施展了金刚碎。",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local area = t.getAreaDamage(self, t) * 0.25
		local areamax = t.getAreaDamage(self, t) * 1.25
		local radius = self:getTalentRadius(t)
		return ([[一次强力的冲击，对目标造成 %d%% 武器伤害。如果此次攻击命中，则会对 %d 码半径内所有目标造成 %0.2f ～ %0.2f 物理伤害（由你的连击点数决定）。 
		受力量影响，范围伤害按比例加成，每 1 点连击点范围上升 1 码。 
		使用此技能会消耗当前所有连击点。]])
		:format(damage, radius, damDesc(self, DamageType.PHYSICAL, area), damDesc(self, DamageType.PHYSICAL, areamax))
	end,
}

registerTalentTranslation{
	id = "T_BUTTERFLY_KICK",
	name = "蝴蝶踢",
	info = function(self, t)
		return ([[你旋转着飞踢过去，对半径 1 内的敌人造成 %d%% 武器伤害。
		 每一点连击点增加 1 点攻击范围和 10%% 伤害。
		 使用该技能需要至少一点连击点。]]):format(t.getDamage(self, t)*100)	
	end,
}

registerTalentTranslation{
	id = "T_HAYMAKER",
	name = "收割之刃",
	message = "@Source@ 开始了狂野的收割!",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local maxDamage = damage * 2
		local stamina = t.getStamina(self, t, 0)/self.max_stamina*100
		local staminamax = t.getStamina(self, t, 5)/self.max_stamina*100
		return ([[一次强烈的终结追击，对目标造成 %d%% 伤害，每 1 点连击点额外造成 20%% 的伤害，至多 %d%% 。 
		如果目标生命低于 20%% ，则会被立刻杀死。 
		用此技能杀死目标会立刻回复你 %d%% 到 %d%% 最大体力值（由你的连击点数决定）。 
		使用此技能会消耗当前所有连击点。]])
		:format(damage, maxDamage, stamina, staminamax)
	end,
}


return _M
