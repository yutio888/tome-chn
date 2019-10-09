local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SUN_BEAM",
	name = "阳光烈焰",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[ 召唤太阳之力，形成一道射线，造成 %0.1f 点光系伤害。
		等级 3 时射线变得如此强烈，半径 2 以内的敌人将被致盲 %d 回合。
		伤害受法强加成。]]):
		format(damDesc(self, DamageType.LIGHT, damage), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_PATH_OF_THE_SUN",
	name = "阳光大道",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		return ([[ 在你面前出现一条阳光大道，持续 5 回合。任何站在上面的敌人每回合受到 %0.2f 点光系伤害。
		 你站在上面行走不消耗时间, 也不会触发陷阱。
		 伤害受法强加成。]]):format(damDesc(self, DamageType.LIGHT, damage / 5), radius)
	end,
}

registerTalentTranslation{
	id = "T_SUN_VENGEANCE",
	name = "阳光之怒",
	info = function(self, t)
		local crit = t.getCrit(self, t)
		local chance = t.getProcChance(self, t)
		return ([[让阳光的怒火充满自身，增加 %d%% 物理和法术暴击率。
		 每次物理或法术暴击时，有 %d%% 几率获得阳光之怒效果，持续两回合。
		 当效果激活时，你的阳光烈焰变为瞬发，同时伤害增加 25%% 。 
		 如果阳光烈焰处于冷却中，则减少 1 回合冷却时间。 
		 该效果一回合至多触发一次。 ]]):
		format(crit, chance)
	end,
}

registerTalentTranslation{
	id = "T_SUNCLOAK",
	name = "阳光护体",
	info = function(self, t)
		return ([[ 你将自己包裹在阳光中，保护你 6 回合。
		 你的施法速度增加 %d%% ，法术冷却减少 %d%% ，同时一次攻击不能对你造成超过 %d%% 最大生命的伤害。
		 效果受法强加成。]]):
		format(t.getHaste(self, t)*100, t.getCD(self, t)*100, t.getCap(self, t))
   end,
}

return _M
