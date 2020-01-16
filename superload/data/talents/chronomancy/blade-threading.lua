local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WARP_BLADE",
	name = "扭曲灵刃",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local duration = t.getDuration(self, t)
		return ([[使用你的近战武器攻击敌人，造成 %d%% 物理、时空武器伤害。如果任意一次攻击命中，你可以震慑、致盲、定身或者混乱目标 %d 回合。
		
		激活螺旋灵刃技能可以自由切换到你的双持武器（必须装备在副武器栏位上）。此外，当你使用近战攻击时也会触发这个效果 ]])
		:format(damage, duration)
	end,
}

registerTalentTranslation{
	id = "T_BLINK_BLADE",
	name = "闪烁灵刃",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		return ([[传送到目标面前，并使用你的近战武器攻击目标，造成 %d%% 武器伤害。然后随机传送到第二个目标面前，攻击并造成 %d%% 武器伤害。
		闪烁灵刃可以命中同一个目标多次。]])
		:format(damage, damage)
	end,
}

registerTalentTranslation{
	id = "T_BLADE_SHEAR",
	name = "灵刃切变",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local shear = t.getShear(self, t)
		local radius = self:getTalentRadius(t)
		return ([[攻击至多三个相邻目标，造成 %d%% 武器伤害。任何一次攻击命中将会制造一次时空切变，造成 %0.2f 时空伤害。 切变具有 %d 格锥形范围。
		该攻击命中每个目标时都将增加 25%% 切变伤害。
		被切变将血量减少到最大值 20%% 以下的目标将会立刻死亡。
		受法术强度影响，切变的伤害有额外加成。]])
		:format(damage, damDesc(self, DamageType.TEMPORAL, shear), radius)
	end,
}

registerTalentTranslation{
	id = "T_BLADE_WARD",
	name = "灵刃守卫",
	info = function(self, t)
		local chance = t.getChance(self, t)
		return ([[双持时你有 %d%% 几率格挡近战攻击。]])
		:format(chance)
	end,
}


return _M
