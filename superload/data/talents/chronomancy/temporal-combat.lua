local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FOLD_FATE",
	name = "命运折叠",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local resists = t.getResists(self, t)
		local duration = t.getDuration(self, t)
		return ([[当你用武器折叠命中时，有 %d%% 几率在半径 %d 内造成额外 %0.2f 时空伤害。
		受影响的生物可能减少 %d%% 物理和时空抗性 %d 回合。
		这个效果有冷却时间。当处于冷却状态被触发时，会减少重力折叠和扭曲折叠 1 回合冷却时间。]])
		:format(chance, radius, damDesc(self, DamageType.TEMPORAL, damage), resists, duration)
	end,
}

registerTalentTranslation{
	id = "T_FOLD_WARP",
	name = "扭曲折叠",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		return ([[当你用武器折叠命中时，有 %d%% 几率在半径 %d 内造成额外 %0.2f 物理和 %0.2f 时空伤害。
		受影响的生物可能被震慑、致盲、定身或混乱 %d 回合。
		这个效果有冷却时间。当处于冷却状态被触发时，会减少重力折叠和命运折叠 1 回合冷却时间。]])
		:format(chance, radius, damDesc(self, DamageType.TEMPORAL, damage/2), damDesc(self, DamageType.PHYSICAL, damage/2), duration)
	end,
}

registerTalentTranslation{
	id = "T_FOLD_GRAVITY",
	name = "重力折叠",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local slow = t.getSlow(self, t)
		local duration = t.getDuration(self, t)
		return ([[当你用武器折叠命中时，有 %d%% 几率在半径 %d 内造成额外 %0.2f 物理( 重力) 伤害。
		受影响的生物可能被减速 %d%% ，持续 %d 回合。
		这个效果有冷却时间。当处于冷却状态被触发时，会减少扭曲折叠和命运折叠 1 回合冷却时间。]])
		:format(chance, radius, damDesc(self, DamageType.PHYSICAL, damage), slow, duration)
	end,
}

registerTalentTranslation{
	id = "T_WEAPON_FOLDING",
	name = "武器折叠",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local chance = t.getChance(self, t)
		return ([[将时空折叠在武器 \ 弹药上，造成额外 %0.2f 时空伤害。
		同时武器命中时你有 %d%% 几率获得 10%% 回合的时间。
		伤害受法术强度加成。]]):format(damDesc(self, DamageType.TEMPORAL, damage), chance)
	end,
}

registerTalentTranslation{
	id = "T_INVIGORATE",
	name = "鼓舞",
	info = function(self, t)
		local power = t.getPower(self, t)
		local duration = t.getDuration(self, t)
		return ([[接下来的 %d 回合里，你回复 %0.1f 生命，同时不具有固定冷却时间的技能会加倍冷却速度。
		生命回复受法术强度加成。]]):format(duration, power)
	end,
}

registerTalentTranslation{
	id = "T_WEAPON_MANIFOLD",
	name = "多态武器",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local slow = t.getSlow(self, t)
		local duration = t.getDuration(self, t)
		local resists = t.getResists(self, t)
		return ([[你现在有 %d%% 几率将命运、重力或扭曲之力折叠进你的武器。
		命运：半径 %d 内造成 %0.2f 时空伤害，并降低 %d%% 物理和时空抗性。
		扭曲：半径 %d 内造成 %0.2f 物理 %0.2f 时空伤害，并可能震慑、致盲、混乱或者定身 %d 回合。
		重力：半径 %d 内造成 %0.2f 物理伤害，并减速（ %d%% ） %d 回合。
		每项效果有 8 回合冷却时间。
		当处于冷却中的效果被触发时，将减少另外两个效果的冷却 1 回合。]])
			:format(chance, radius, damDesc(self, DamageType.TEMPORAL, damage), resists, radius, damDesc(self, DamageType.PHYSICAL, damage/2), damDesc(self, DamageType.TEMPORAL, damage/2), duration, radius,
		damDesc(self, DamageType.PHYSICAL, damage), slow, duration)
	end,
}

registerTalentTranslation{
	id = "T_BREACH",
	name = "破灭",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[ 使用远程或近战武器攻击目标，造成 %d%% 武器伤害。
		如果攻击命中，你将摧毁目标的防御，减半护甲硬度，震慑定身致盲混乱免疫。]])
		:format(damage, duration)
	end,
}

return _M
