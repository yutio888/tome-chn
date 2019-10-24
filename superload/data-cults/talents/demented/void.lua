local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_VOID_STARS",
	name = "虚无之星",
	info = function(self, t)
		local power = t.getReduction(self,t)*100
		local regen = t.getRegen(self,t)
		return ([[形成围绕你旋转, 为你抵御伤害的虚无之星。
		每当受到超过 10%% 最大生命的伤害时，消耗一颗虚无之星，使受到的伤害减少 %d%% ，自己受到等同于减免伤害 40%% 的熵能反冲。
		虚无之星每经过 %d 回合自动恢复一颗。
		此技能只有装备轻甲时生效。]]):
		format(power, regen)
	end,
}

registerTalentTranslation{
	id = "T_NULLMAIL",
	name = "虚空护甲",
	info = function(self, t)
		local armor = t.getArmor(self, t)
		local power = t.getAbsorb(self, t)
		return ([[用无数微小的虚无之星强化护甲，护甲值提高 %d .
		每次虚无之星完全消耗后，生成一个持续 4 回合吸收 %d 伤害的护盾。在虚无之星完全恢复前无法再次生成护盾。]]):
		format(armor, power)
	end,
}

registerTalentTranslation{
	id = "T_BLACK_MONOLITH",
	name = "黑色巨石",
	info = function(self, t)
		return ([[消耗一枚虚无之星，在目标位置召唤持续 %d 回合的虚无巨石。巨石非常坚固，无法移动，每半回合对 2 码范围内敌人施加眩晕 ( 基于本体法术强度 ).
			基于你的魔法属性，巨石获得 %d 生命回复和 %d%% 全抗。]]):
		format(t.getDur(self, t), self:getTalentRadius(t), t.getLifeRating(self, t), t.getResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ESSENCE_REAVE",
	name = "精华收割",
	info = function(self, t)
		local damage = t.getDamage(self, t)/2
		local nb = t.getNb(self,t)
		return ([[撕开目标的核心部位，汲取生命转化为虚无之星。目标受到 %0.2f 黑暗和 %0.2f 时空伤害，你获得 %d 虚空之星。
		伤害随法术强度升高。]]):
		format(damDesc(self, DamageType.DARKNESS, (damage)), damDesc(self, DamageType.TEMPORAL, (damage)), nb)
	end,
}
return _M
