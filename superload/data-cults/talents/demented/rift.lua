local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_REALITY_FRACTURE",
	name = "实境撕裂",
	info = function(self, t)
		local dur = t.getDuration(self,t)
		local damage = t.getDamage(self,t)/2
		local nb = t.getNb(self,t)
		return ([[你强大的熵之力撕裂了时空，将这个世界与虚空相连。
当施放疯狂系法术时，你有 30%% 几率在相邻的空地里打开一个虚空裂口，持续 %d 回合。它每回合将会对范围 7 内的一个随机敌人释放虚空轰击，造成 %0.2f 点暗影伤害和 %0.2f 点时空伤害。

你可以主动激活这个天赋来强制使得时空不稳定，在你周围创造 %d 个虚空裂口。]]):
		format(dur, damDesc(self, DamageType.DARKNESS, damage), damDesc(self, DamageType.TEMPORAL, damage), nb)
	end,
}

registerTalentTranslation{
	id = "T_QUANTUM_TUNNELLING",
	name = "量子隧道",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local power = t.getPower(self,t)
		return ([[你短暂地在时空中打开一个通道 , 传送到范围 %d 内的一个虚空裂口。这将摧毁那个虚空裂口，使你获得一个护盾，吸收 %d 点伤害，持续 4 回合。
		护盾吸收的伤害随法术强度提高而提高。]]):
		format(range, power)
	end
}

registerTalentTranslation{
	id = "T_PIERCE_THE_VEIL",
	name = "刺破境界线",
	info = function(self, t)
		local chance = t.getChance(self,t)
		local ndam = t.getNetherDamage(self,t)
		local tdam = t.getTemporalDamage(self,t)
		local dur = t.getDimensionalDuration(self,t)
		return ([[向你的裂口注入能量，你将有 %d%% 概率让每一个裂口进化成为更强大的形态。
#PURPLE#深渊裂隙 :#LAST# 向半径 10 内随机敌人发射光束，造成 %0.2f 点暗影伤害。
#PURPLE#时空漩涡 :#LAST# 每回合对半径 4 内的敌人造成 %0.2f 点时空伤害，并且减少他们 30%% 的全局速度 .
#PURPLE#维度之门 :#LAST# 每回合有 50%% 概率召唤一个虚空造物，持续 %d 回合 , 是一个能传送的高速物理输出 
你的虚空造物属性随你的等级和魔法属性提高而提高。]])
		:format(chance, damDesc(self, DamageType.DARKNESS, ndam), damDesc(self, DamageType.TEMPORAL, tdam), dur)
	end
}

registerTalentTranslation{
	id = "T_DIMENSIONAL_SKITTER",
	name = "维度迅击",
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[传送到范围 10 内的一个敌人处，并用你的尖牙攻击它，造成 %d%% 武器伤害。]]):format(t.getDamage(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_ZERO_POINT_ENERGY",
	name = "零点能量",	
	info = function(self, t)
		local power = t.getPower(self,t)
		return ([[你从虚空深处汲取能量，每当你激活实境撕裂时，你可以强化任何已存在的裂口。
#GREY#虚空裂口 :#LAST# 造成 %d%% 点额外伤害，并且投射物在半径 1 范围内爆炸。
#PURPLE#深渊裂隙 :#LAST# 造成 %d%% 点额外伤害，并且连锁至 3 个额外目标。
#PURPLE#时空漩涡 :#LAST# 造成 %d%% 点额外伤害，增加 1 效果半径 , 并且减速效果提高至 50%%.
#PURPLE#维度之门 :#LAST# 虚空造物将会变得狂暴 , 增加他们 %d%% 的全局速度。]])
		:format(power, power, power, power)
	end,
}
return _M

