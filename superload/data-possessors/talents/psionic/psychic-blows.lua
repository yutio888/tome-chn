local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_PSYCHIC_CRUSH",
	name = "精神粉碎",
	info = function (self,t)
		return ([[用双手武器攻击敌人造成 %d%% 武器精神伤害。
		如果命中且目标没有通过精神豁免有 %d%% 几率剥夺目标的心灵印记。
		它会出现在附近，并为你服务 %d 回合。
		如果你没有装备双手武器，但是在副手栏里装备了，你会立刻自动切换。]]):
		format(t.getDam(self, t) * 100, t.getChance(self, t), t.getDuration(self,t))
	end,
}
registerTalentTranslation{
	id = "T_FORCE_SHIELD",
	name = "力场盾",
	info = function (self,t)
		return ([[你通过你的武器创造力场盾，每次受到伤害时，伤害不会超过最大生命值 %d%% 并有 %d%% 回避攻击。
		此外，每次受到近战攻击时，攻击者会受到 %d%% 武器精神伤害的反击，(每回合一次)
		如果你没有装备双手武器，但是在副手栏里装备了，你会立刻自动切换。]]):
		format(t.getMaxDamage(self, t), t.getEvasion(self, t), t.getDam(self, t) * 100)
	end,
}
registerTalentTranslation{
	id = "T_UNLEASHED_MIND",
	name = "心灵释放",
	info = function (self,t)
		return ([[你将强大的灵能力集中在你的武器上，并简单地释放你的愤怒。	
		半径 %d 内的敌人受到近战攻击造成 %d%% 武器精神伤害。
		范围内的所有灵能克隆体将延长 %d 回合。
		如果你没有装备双手武器，但是在副手栏里装备了，你会立刻自动切换。]]):
		format(self:getTalentRadius(t), t.getDam(self, t) * 100, t.getDur(self, t))
	end,
}
registerTalentTranslation{
	id = "T_SEISMIC_MIND",
	name = "心灵地震",
	info = function (self,t)
		return ([[你在地面上打碎你的武器，将一个心灵的冲击波投射在半径为 %d 的圆锥上。
		范围内的所有敌人受到 %d%% 武器精神伤害。
		任何被击中的灵能克隆体将立即破碎，在半径 1 的范围内爆炸造成 %0.2f 物理伤害。
		如果你没有装备双手武器，但是在副手栏里装备了，你会立刻自动切换。]]):
		format(self:getTalentRadius(t), t.getDam(self, t) * 100, t.getExplosionDam(self, t))
	end,
}
return _M