local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SLASH",
	name = "削砍",
	info = function(self, t)
		local healFactorChange = t.getHealFactorChange(self, t)
		local woundDuration = t.getWoundDuration(self, t)
		return ([[野蛮的削砍你的目标造成 %d%% （ 0 仇恨）至 %d%% （ 100+ 仇恨）伤害。 
		等级 3 时攻击附带诅咒，降低目标治疗效果 %d%% 持续 %d 回合，效果可叠加。 
		伤害比例受力量值加成。
		如果你装备了盾牌，这一技能也会用你的盾牌攻击。]]):format(t.getDamageMultiplier(self, t, 0) * 100, t.getDamageMultiplier(self, t, 100) * 100, -healFactorChange * 100, woundDuration)
	end,
}

registerTalentTranslation{
	id = "T_FRENZY",
	name = "狂乱之袭",
	info = function(self, t)
		local defenseChange = t.getDefenseChange(self, t)
		return ([[对附近目标进行 4 次攻击每个目标造成 %d%% （ 0 仇恨值）至 %d%% （ 100+ 仇恨值）。附近被追踪的目标会被优先攻击。 
		等级 3 时你的猛烈攻击会同时降低目标 %d 的闪避，持续 4 回合。 
		伤害加成和闪避减值受力量值加成。
		如果你装备了盾牌，这一技能也会用你的盾牌攻击。]]):format(t.getDamageMultiplier(self, t, 0) * 100, t.getDamageMultiplier(self, t, 100) * 100, -defenseChange)
	end,
}

registerTalentTranslation{
	id = "T_RECKLESS_CHARGE",
	name = "鲁莽冲撞",
	info = function(self, t)
		local level = self:getTalentLevelRaw(t)
		local maxAttackCount = t.getMaxAttackCount(self, t)
		local size
		if level >= 5 then
			size = "大型"
		elseif level >= 3 then
			size = "中型"
		else
			size = "小型"
		end
		return ([[冲过你的目标，途经的所有目标受到 %d%% （ 0 仇恨）至 %d%% （ 100+ 仇恨）伤害。 %s 体型的目标会被你弹开。你最多可以攻击 %d 次，并且你对路径上的敌人可造成不止 1 次攻击。]]):format(t.getDamageMultiplier(self, t, 0) * 100, t.getDamageMultiplier(self, t, 100) * 100, size, maxAttackCount)
	end,
}

registerTalentTranslation{
	id = "T_CLEAVE",
	name = "分裂攻击",
	info = function(self, t)
		return ([[当激活时，你的每一次武器攻击都会攻击一个临近的目标，造成 %d%% （0 仇恨值）到 %d%% （100 仇恨值）的物理伤害。不顾一切的杀戮会带给你厄运（-3 幸运）。
		分裂攻击、杀意涌动和无所畏惧不能同时开启，并且激活一个也会使另外两个进入冷却。
		当使用双手武器时，分裂攻击会造成 25%% 的额外伤害。
		分裂攻击伤害受力量值加成。]]):
		format( t.getDamageMultiplier(self, t, 0) * 100, t.getDamageMultiplier(self, t, 100) * 100)
	end,
}




return _M
