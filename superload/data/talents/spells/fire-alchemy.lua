local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FIRE_INFUSION",
	name = "火焰充能",
	info = function(self, t)
		local daminc = t.getIncrease(self, t)
		return ([[给炼金炸弹附加火焰能量, 使敌人进入灼烧状态
		此外，你造成的所有火焰伤害增加 %d%% 。]]):
		format(daminc)
	end,
}

registerTalentTranslation{
	id = "T_SMOKE_BOMB",
	name = "烟雾弹",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[投掷一枚烟雾弹，遮住一条直线的视野。 %d 回合后烟雾会消失。 
		若烟雾中存在处于引燃状态的生物，则会将烟雾消耗一空并在所有目标身上附加引燃效果，持续时间增加 %d 回合。 
		受法术强度影响，持续时间有额外加成。]]):
		format(duration, math.ceil(duration / 3))
	end,
}

registerTalentTranslation{
	id = "T_FIRE_STORM",
	name = "火焰风暴",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[制造一片激烈的火焰风暴，每回合对施法者周围 3 码范围内的目标造成 %0.2f 火焰伤害，持续 %d 回合。 
		你精确的操控火焰风暴，阻止它伤害你的队友。 
		受法术强度影响，伤害和持续时间有额外加成。]]):
		format(damDesc(self, DamageType.FIRE, damage), duration)
	end,
}

registerTalentTranslation{
	id = "T_BODY_OF_FIRE",
	name = "火焰之躯",
	info = function(self, t)
		local onhitdam = t.getFireDamageOnHit(self, t)
		local insightdam = t.getFireDamageInSight(self, t)
		local res = t.getResistance(self, t)
		return ([[将你的身体转化为纯净的火焰，增加你 %d%% 火焰抵抗。对任何进展攻击你的怪物造成 %0.2f 火焰伤害并向附近目标每回合随机射出 %d 个缓慢移动的火焰球，每个火球造成 %0.2f 火焰伤害。 
		受法术强度影响，伤害和火焰抵抗有额外加成。]]):
		format(res,onhitdam, math.floor(self:getTalentLevel(t)), insightdam)
	end,
}


return _M
