local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STONESHIELD",
	name = "岩石坚盾",
	info = function(self, t)
		local m, mm, e, em = t.getValues(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[每回合第一次承受伤害时，你将 %d%% 的伤害转化为法力 ( 至多 %0.2f 点 ) ， %d%% 的伤害转化为失衡值 ( 至多回复 %0.2f )。
		增加物理强度 %d , 增加盾牌伤害 %d%% , 并让你能够双持盾牌。
		同时，你的近战攻击附带一次盾牌攻击。]]):format(100 * m, mm, 100 * e, em, damage, inc*100)
	end,
}

registerTalentTranslation{
	id = "T_STONE_FORTRESS",
	name = "岩石壁垒",
	info = function(self, t)
		return ([[当你使用钢筋铁骨时，你的皮肤会变得非常坚硬，甚至能吸收非物理攻击。
		所有非物理伤害减免 %d%% 护甲值（无视护甲硬度）。]]):
		format(t.getPercent(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHARDS",
	name = "岩石碎片",
	info = function(self, t)
		return ([[尖锐的岩石碎片从盾牌生长出来。
		每次你承受近战攻击时，你能利用这些碎片反击攻击者，造成 %d%% 自然伤害。
		每回合只能反击一次。]]):
		format(self:combatTalentWeaponDamage(t, 0.4, 1) * 100)
	end,
}

registerTalentTranslation{
	id = "T_ELDRITCH_STONE",
	name = "岩石护盾",
	info = function(self, t)
		local power = t.getPower(self, t)
		local radius = self:getTalentRadius(t)
		return ([[制造一层持续 7 回合的岩石护盾，吸收至多 %d 点伤害。
		你的失衡值将会上升两倍伤害吸收量。 
		护盾破碎时，所有超过最小值的失衡值将被转化为法力，同时释放奥术能量风暴 , 造成等同于转化失衡值的奥术伤害（至多 %d 点），伤害半径 %d 。
		你的格挡技能的冷却时间也会被重置。
		同时，你休息时获得每回合 %0.2f 回魔速度。
		护盾值受法术强度加成。]]):format(power, t.maxDamage(self, t), radius, t.manaRegen(self, t))
	end,
}


return _M
