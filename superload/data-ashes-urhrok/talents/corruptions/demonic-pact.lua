local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DEMON_SEED",
	name = "恶魔之种",
	info = function(self, t)
		local shield, weapon = t.getDam(self, t)
		return ([[对目标造成 %d%% 枯萎武器伤害。如果攻击命中，你将用盾牌攻击目标，造成 %d%% 盾牌伤害并眩晕 %d 回合。
		如果武器命中并且没有杀死目标，一个恶魔之种将试图进入目标的体内。
		种子需要足够强大的宿主来成长。存活几率：
			普通生物 		5%%
			精英生物 		20%%
			稀有与史诗生物 	50%%	
			Boss 			100%%
		种子只能寄生在有经验的生物里，不能寄生在召唤物中。
		当宿主死亡时，种子将吸收宿主的活力，成长为一个特定的恶魔种子，能用于召唤恶魔。
		如果已有更高级的恶魔种子，你将不能制造同类型的低级恶魔种子。
		高技能等级将带来更强大的种子。]])
		:format(weapon * 100, shield * 100, t.getDazeDuration(self, t))
	end,
}


registerTalentTranslation{
	id = "T_BIND_DEMON",
	name = "恶魔结合",
	info = function(self, t)
		return ([[你能通过恶魔种子来临时召唤恶魔 %d 回合。
		召唤出来的恶魔能回复生命，并且保持上一次召唤结束时的生命值。
		如果恶魔死亡，将不能再使用同一个种子进行召唤。

		随着你对恶魔力量的了解更加深入，你能将更多的种子与你的装备结合。
		技能等级 2 时你能将种子与第一个戒指结合。
		技能等级 3 时你能将种子与盾牌结合。
		技能等级 4 时你能将种子与第二个戒指结合。
		技能等级 5 时你能将种子与护甲结合。
		]]):
		format(t.getDur(self, t))
	end,
}


registerTalentTranslation{
	id = "T_TWISTED_PORTAL",
	name = "扭曲传送",
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local range = t.getRange(self, t)
		return ([[传送自己 %d 码，误差 %d 。
		在离开的位置，你将随机召唤一个恶魔，持续 %d 回合。
		如果目标地点不在视线内，有一定几率失败。
		该技能需要至少一个未召唤的存活的恶魔种子。
		传送半径受法术强度加成。]]):format(range, radius, t.getDur(self, t))
	end,
}


registerTalentTranslation{
	id = "T_SUFFUSE_LIFE",
	name = "生命能量",
	info = function(self, t)
		local healpct, rezchance, leech = t.getVals(self, t)
		return ([[你吸取敌方生物的生命来治疗恶魔种子和你。
		每次你杀死生物时，一个随机的生命不足 100%% 的恶魔种子将受到 %d%% 生命值的治疗。
		如果该生物是精英或者更高级别，你有 %d%% 几率复活一个死亡的恶魔种子。
		技能等级 4 时，你开始学会治疗自身，每次造成伤害时回复自身 %d%% 伤害值的生命。]]):
		format(healpct, rezchance, leech)
	end,
}


return _M
