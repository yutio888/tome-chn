local _M = loadPrevious(...)
local Object = require "mod.class.Object"

registerTalentTranslation{
	id = "T_MUTATED_HAND",
	name = "异变之手",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		local allow_tcombat = t.canTentacleCombat(self, t)
		local tcombat = {combat=t.getTentacleCombat(self, t, true)}
		local tcombatdesc = getObjectDescCHN(Object:descCombat(self, tcombat, {}, "combat"))
		return ([[你的左手异变成为大量的恶心触手。
		副手空闲时，当使用普通攻击，触手会自动攻击目标以及目标同侧的其他单位。
		物理强度提高 %d ，触手伤害提高 %d 。
		每次触手攻击时，获得 %d 疯狂值。
		附近有 #{italic}# 普通人 #{normal}# 时会自动生成微弱的心灵护盾  ，避免被他们发现你的恐魔形态。
		你的触手当前属性为 %s :
		%s]]):
		format(damage, 100*inc, t.getInsanityBonus(self, t), allow_tcombat and "" or ", #CRIMSON# 由于副手非空闲当前无法使用。d#WHITE#", tostring(tcombatdesc))
	end,
}

registerTalentTranslation{
	id = "T_LASH_OUT",
	name = "旋风鞭挞",
	info = function(self, t)
		return ([[飞速旋转，伸展武器对周围单位造成 %d%% 武器伤害，并且伸展触手对 3 码内单位造成 %d%% 触手伤害。
		如果武器击中敌人，你获得 %d 疯狂值。
		如果触手击中敌人，你获得 %d 疯狂值。
		#YELLOW_GREEN# 当触手处于缠绕状态 : #WHITE# 你的触手攻击以被缠绕目标为中心展开，攻击范围只有 1 码，但是会使被击中单位眩晕 5 回合。]]):
		format(100 * t.getDamage(self, t), 100 * t.getDamageTentacle(self, t), t.getMHInsanity(self, t), t.getTentacleInsanity(self, t))
	end,
}

registerTalentTranslation{
	id = "T_TENDRILS_ERUPTION",
	name = "触手地狱",
	info = function(self, t)
		return ([[你的触手钻入地下，分布到 %d 码范围的目标区域。
		该区域喷发出大量黑色触手，对区域内所有敌人造成 %d%% 触手伤害。
		被触手击中的生物需要进行法术检定，检定失败将被麻痹，5 回合内伤害降低 %d%% 。
		如果有敌人被触手击中，你获得 %d 疯狂值。
		#YELLOW_GREEN# 当触手处于缠绕状态 : #WHITE# 触手对缠绕对象连续突击，造成 %d%% 触手伤害。如果你与被缠绕对象相邻，则进行一次额外的主手打击。技能 C D 缩短为 1 0 回合。]]):
		format(self:getTalentRadius(t), t.getDamageTentacle(self, t) * 100, t.getNumb(self, t), t.getInsanity(self, t), t.getDamageTentacle(self, t) * 1.5 * 100)
	end,
}

registerTalentTranslation{
	name = "触手缠绕", 
	id = "T_TENTACLE_CONSTRICT",
	info = function(self, t)
		return ([[伸展触手缠绕一个远处的目标，并向你拖拽。
		目标被触手缠绕后，可以尝试向远处移动，但是每回合会被拖回一码。
		当缠绕了敌人，普通攻击不会额外附加触手攻击，但每回合对缠绕敌人造成 %d%% 触手伤害。
		敌人可以抵抗触手拖拽，但是缠绕状态会持续生效。
		其他触手技能在缠绕状态下会发生变化，具体请查看相应技能描述。]]):
		format(t.getDamageTentacle(self, t) * 100)
	end,
}

return _M
