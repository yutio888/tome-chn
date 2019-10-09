local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_PSIONIC_DISRUPTION",
	name = "灵能瓦解",
	info = function (self,t)
		return ([[向副手灵晶灌注狂暴的灵能力量。
		生效时，灵晶的精神强度和精神暴击几率增加 %d%% 。
		每次攻击，都会给目标附加 1 层灵能瓦解效果。
		每层效果持续 %d 回合造成 %0.2f 精神伤害 (最多 %d 层).
		如果你没有装备单手武器和灵晶，但是在副手栏里装备了，你会立刻自动切换。此技能与心灵利刃不兼容。]]):
		format(t.getBuff(self, t), t.getDur(self, t), damDesc(self, DamageType.MIND, t.getDam(self, t)), t.getStacks(self, t))
	end,
}
registerTalentTranslation{
	id = "T_SHOCKSTAR",
	name = "震撼之星",
	info = function (self,t)
		return ([[用主手武器造成 %d%% 武器伤害。
		如果命中目标立刻用灵晶攻击目标造成 %d%% 伤害。
		震慑目标 %d 回合且半径 %d 范围内的生物眩晕同样的回合。
		灵能瓦解层数决定震慑和眩晕的持续时间，已给出的数据是灵能瓦解 4 层的情况下。
		如果你没有装备单手武器和灵晶，但是在副手栏里装备了，你会立刻自动切换。此技能与心灵利刃不兼容。]]):
		format(t.getMDam(self, t)*100, t.getODam(self, t)*100, t.getDur(self, t), t.getRadius(self, t))
	end,
}
registerTalentTranslation{
	id = "T_DAZZLING_LIGHTS",
	name = "炫目之光",
	info = function (self,t)
		return ([[举起灵晶，致盲半径 %d 内的生物 %d 回合。
		在近战范围内的敌人被此效果致盲，立刻用主手武器造成 %d%% 伤害。
		如果你没有装备单手武器和灵晶，但是在副手栏里装备了，你会立刻自动切换。此技能与心灵利刃不兼容。]]):
		format(self:getTalentRadius(t), t.getDur(self, t), t.getDam(self, t) * 100)
	end,
}
registerTalentTranslation{
	id = "T_PSIONIC_BLOCK",
	name = "灵能格挡",
	info = function (self,t)
		return ([[创造一个持续 5 回合的灵能盾牌围绕你。
		技能生效时有 %d%% 几率会无视伤害。
		如果伤害被无视，你会对目标进行反击，造成 %0.2f 精神伤害。(每回合最多 2 次 )
		]]):
		format(t.getChance(self, t), damDesc(self, DamageType.MIND, t.getDam(self, t)))
	end,
}
return _M