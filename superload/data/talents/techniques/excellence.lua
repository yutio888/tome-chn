local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHOOT_DOWN_OLD",
	name = "强制击落",
	info = function(self, t)
		return ([[ 你的反射神经像闪电一样快。当你瞄准抛射物（箭矢、弹药、法术等）时，你能马上击落它而不消耗时间。 
		你最多能击落 %d 个目标。]]):
		format(t.getNb(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BULL_SHOT_OLD",
	name = "冲锋射击",
	info = function(self, t)
		return ([[ 你冲向你的敌人，并准备好射击。如果你接触到敌人，你将射出你准备好的箭矢/ 弹药，给予其强劲的力量。射击造成 %d%% 伤害并击退对手 %d 码。]]):
		format(self:combatTalentWeaponDamage(t, 1.5, 2.8) * 100, t.getDist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_INTUITIVE_SHOTS_OLD",
	name = "直觉射击",
	info = function(self, t)
		return ([[ 激活该技能会大幅强化你的反射神经。每次你受到近战攻击，你有 %d%% 的几率进行一次防御性射击来中止对方这次攻击，并造成 %d%% 伤害，同时击退对方 %d 码。激活这项技能不会中断装填弹药。]])
		:format(t.getChance(self, t), self:combatTalentWeaponDamage(t, 0.4, 0.9) * 100, t.getDist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_STRANGLING_SHOT",
	name = "沉默射击",
	info = function(self, t)
		return ([[ 你瞄准目标的喉咙、嘴巴或相关部位，造成 %d%% 伤害，并沉默对方 %d 个回合。沉默几率随命中增长。]])
		:format(self:combatTalentWeaponDamage(t, 0.9, 1.7) * 100, t.getDur(self,t))
	end,
}


return _M
