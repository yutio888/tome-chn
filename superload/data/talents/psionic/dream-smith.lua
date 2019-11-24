local _M = loadPrevious(...)
local Object = require "mod.class.Object"

registerTalentTranslation{
	id = "T_DREAM_HAMMER",
	name = "梦之巨锤",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local weapon_stats = Object:descCombat(self, {combat=useDreamHammer(self)}, {}, "combat")
		return ([[在梦境熔炉中将武器锻造成一柄巨锤砸向附近某个目标，造成 %d%% 武器伤害。如果攻击命中，它会使梦境锻造系的某个随机技能冷却完毕。 
		在等级 5 时，此技能会使 2 个随机技能冷却完毕。 
		受精神强度影响，武器的基础攻击力、命中、护甲穿透和暴击率按比例加成。 

		当前梦之巨锤属性：
		%s]]):format(damage * 100, tostring(weapon_stats))
	end,
}

registerTalentTranslation{
	id = "T_HAMMER_TOSS",
	name = "回旋投掷",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local attack_bonus = t.getAttack(self, t)
		return ([[将你的梦之巨锤扔向远处，对沿途所有敌方单位造成 %d%% 武器伤害。在到达目标点后，梦之巨锤会自动返回，再次对沿途目标造成伤害。 
		学习此技能会增加梦之巨锤 %d 点命中。]]):format(damage * 100, attack_bonus)
	end,
}

registerTalentTranslation{
	id = "T_DREAM_CRUSHER",
	name = "雷霆一击",
	info = function(self, t)
		local damage = t.getWeaponDamage(self, t)
		local power = t.getDamage(self, t)
		local percent = t.getPercentInc(self, t)
		local stun = t.getStun(self, t)		
		return ([[用你的梦之巨锤碾碎敌人，造成 %d%% 武器伤害。如果攻击命中，则目标会被震慑 %d 回合。 
		受精神强度影响，震慑几率有额外加成。 
		学习此技能会增加 %d 点你使用梦之巨锤时的物理强度，同时使梦之巨锤造成的所有伤害提升 %d%% 。]]):format(damage * 100, stun, power, percent * 100)
	end,
}

registerTalentTranslation{
	id = "T_FORGE_ECHOES",
	name = "回音击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local project = t.getProject(self, t) /2
		return ([[用梦之巨锤对近身目标挥出强力的一击，造成 %d%% 武器伤害。如果攻击命中，挥击所产生的回音会伤害 %d 码范围内的所有目标。 
		学习此技能会使你的梦之巨锤附加 %0.2f 精神伤害和 %0.2f 燃烧伤害。 
		受精神强度影响，梦之巨锤附加的精神伤害和燃烧伤害按比例加成。]]):format(damage * 100, radius, damDesc(self, DamageType.MIND, project), damDesc(self, DamageType.FIRE, project))
	end,
}


return _M
