local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DOMINATE",
	name = "压制",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local armorChange = t.getArmorChange(self, t)
		local defenseChange = t.getDefenseChange(self, t)
		local resistPenetration = t.getResistPenetration(self, t)
		return ([[将注意力转移到附近目标并用你强大的气场压制它。如果目标未能通过精神强度豁免鉴定，目标 %d 回合内将无法移动并受到更多伤害。目标降低 %d 点护甲值、 %d 点闪避，并且你对目标的攻击会增加 %d%% 抵抗穿透。如如果目标与你相邻 , 那么此技能会附加一次近战攻击。 
		受意志影响，效果有额外加成。]]):format(duration, -armorChange, -defenseChange, resistPenetration)
	end,
}

registerTalentTranslation{
	id = "T_PRETERNATURAL_SENSES",
	name = "第七感觉",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local sense = t.sensePower(self, t)
		return ([[你的第 7 感能让你能在狩猎中发现下个牺牲品。 
		你能感觉到 %0.1f 码半径范围内的敌人。 
		在 10 码半径范围内你总能看见被追踪的目标。
		同时增加你的侦测潜行等级 %d ，侦测隐形等级 %d 。
		受意志影响，侦测强度有额外加成。]]):
		format(range, sense, sense)
	end,
}

registerTalentTranslation{
	id = "T_BLINDSIDE",
	name = "闪电突袭",
	info = function(self, t)
		local multiplier = self:combatTalentWeaponDamage(t, 0.7, 1.9)
		local defenseChange = t.getDefenseChange(self, t)
		return ([[你闪电般的出现在 %d 码范围内的敌人身边，造成 %d%% （ 0 仇恨）～ %d%% （ 100+ 仇恨）的伤害。 
		你闪电般的突袭使敌人没有提防，增加 %d 点额外闪避，持续 1 回合。 
		受力量影响，闪避值有额外加成。
		如果你装备盾牌的话，这一技能也可以使用你的盾牌攻击。]]):format(self:getTalentRange(t), multiplier * 30, multiplier * 100, defenseChange)
	end,
}

registerTalentTranslation{
	id = "T_REPEL",
	name = "无所畏惧",
	info = function(self, t)
		local chance = t.getChance(self, t)
		return ([[在猛烈的攻击面前，你选择直面威胁而不是躲藏。 
		当技能激活时，你有 %d%% 概率抵挡一次近程攻击。不顾一切的防御会带给你厄运（ -3 幸运）。 
		分裂攻击，杀意涌动和无所畏惧不能同时开启，并且激活其中一个也会使另外两个进入冷却。 
		抵挡概率受力量加成。
		装备盾牌时，抵挡概率增加 20%% ]]):format(chance)
	end,
}



return _M
