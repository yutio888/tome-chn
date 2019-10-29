local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STATIC_SHOCK",
	name = "静电震击", 
	info = function(self, t)
		local resist = t.getResists(self,t)
		local damage = t.getDamage(self, t)
		return ([[当你使用格挡技能的时候，你会在身边产生一个静电屏障，增加所有抗性 %d%% ，持续 4 回合。如果有敌人此时攻击你，屏障会电击它们，造成 %d%% 盾牌伤害。
		这一效果每回合最多只能对一个目标伤害一次，并且不会消耗反击效果。
你装备盾牌和计算盾牌攻击伤害的时候，用灵巧代替力量要求。]]):format(resist, damage*100)
	end,
}

registerTalentTranslation{
	id = "T_MAGNETIC_FIELD",
	name = "磁性力场",
	info = function(self, t)
		local slow = t.getSlow(self,t)
		local crit = t.getCrit(self,t)
		local damage = t.getDamage(self,t)*100
		local radius = self:getTalentRadius(t)
		return ([[你从盾牌中发射出强大的磁性能量冲击波，半径为 %d 码范围。所有被击中的敌人会被击退 %d 码，并受到 %d%% 闪电盾牌伤害。所有的抛射物也会被摧毁。
		当这一技能不处于冷却时间的时候，你会从盾牌中发射出一个磁性力场，降低所有瞄准你的抛射物速度 %d%% ，并且你被暴击的几率降低 %d%% 。]])
		:format(radius, radius, damage, slow, crit)
	end,
}

registerTalentTranslation{
	id = "T_CAPACITOR_DISCHARGE",
	name = "电力放出",
	info = function(self, t)
	local block = t.getBlock(self,t)
	local dam = t.getDamage(self,t)
	local shielddam = t.getShieldDamage(self,t)*100
	local nb = t.getTargetCount(self,t)
		return ([[将电容器放置在你的盾牌上，它们可以减弱攻击的影响。增加 %d%% 的格挡值，并将 100%% 格挡的伤害转化为电力充能（最多充能 %d 点）。
启动这一技能将会放出格挡的伤害，并发射出一道闪电冲击，对第一个目标造成 %d%% 闪电盾牌伤害，并产生一股电弧，对最多 %d 个其他目标产生相当于你存储的伤害量的伤害。
如果你的伤害充能满了，被击中的目标还会被眩晕 2 回合，且盾牌攻击必定暴击。
你能够吸收的最大伤害量受蒸汽强度加成。]]):
		format(block, dam, shielddam, nb)
	end,
}

registerTalentTranslation{
	id = "T_LIGHTNING_WEB",
	name = "闪电之网",
	info = function(self, t)
		local damage = t.getDamage(self, t)*100
		local duration = t.getDuration(self, t)
		local block = t.getBlock(self,t)
		return ([[从你的盾牌中发射出一个半径为 3 的电网，持续 %d 回合。所有被电网覆盖的敌人将会每回合受到一次自动的盾牌攻击，造成 %d 闪电伤害。而被覆盖的队友会获得相当于 %d%% 格挡值的直接伤害减免。
		所有被这一效果减免的伤害会被计入电力放出技能所存储的伤害。]]):
		format(duration, damage, block)
	end,
}

return _M