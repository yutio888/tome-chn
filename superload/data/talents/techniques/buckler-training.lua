local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SKIRMISHER_BUCKLER_EXPERTISE",
	name = "盾牌训练",
	info = function(self, t)
		local block = t.chance(self, t)
		local armor = t.getHardiness(self, t)
		return ([[允许你装备盾牌，使用灵巧作为属性需求。
		当你受到近战攻击，你有 %d%% 的几率用盾牌使这次攻击偏斜，并完全躲避它。
		另外，若你没有装备重甲，你获得 %d 护甲值和 %d%% 护甲硬度。
		受到灵巧影响，偏斜几率有加成。]])
		:format(block, armour, hardiness)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_BASH_AND_SMASH",
	name = "击退射击",
	info = function(self, t)
		local shieldMult = t.getShieldMult(self, t) * 100
		local tiles = t.getDist(self, t)
		local slingMult = t.getSlingMult(self, t) * 100
		return ([[用盾牌重击近战范围内的一名敌人（当技能等级在 5 级或更高时重击 2 次），造成 %d%% 伤害并击退 %d 格。紧接着用投石索发动一次致命的攻击，造成 %d%% 伤害。 
		盾牌攻击使用敏捷取代力量来计算盾牌伤害加成。]])
		:format(shieldMult, tiles, slingMult)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_BUCKLER_MASTERY",
	name = "格挡大师",
	info = function(self, t)
		local chance = t.getChance(self, t)
		local range = t.getRange(self, t)
		return ([[当你被抛射物攻击时，不论是否为物理类型，你有 %d%% 的几率使其偏斜最多 %d 格。
		技能等级 5 时，你的击退射击必定暴击。]])
			:format(chance, range)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_COUNTER_SHOT",
	name = "以牙还牙",
	info = function(self, t)
		local mult = t.getMult(self, t) * 100
		local blocks = t.getBlocks(self, t)
		
		return ([[每当你的格挡专家或者格挡大师技能挡住攻击时，你立刻使用投石索发动一次伤害 %d%% 的反击。每回合最多只能发动 %d 次反击。
			]])
			:format(mult, blocks)
	end,
}


return _M
