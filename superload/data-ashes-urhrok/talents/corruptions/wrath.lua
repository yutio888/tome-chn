local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_OBLITERATING_SMASH",
	name = "歼灭挥斩",
	info = function(self, t)
	return ([[用无与伦比的力量挥动武器，打击正面半圆 %d 码范围内所有敌对生物，对所有目标造成 %d%% 武器伤害。
	技能 5 级时，被击中敌对生物的护甲和豁免会降低 %d 点。
	此攻击必中。]]):
	format(self:getTalentRange(t), 100 * t.getDamage(self, t), t.getSunder(self, t))
	end,
}

	
registerTalentTranslation{
	id = "T_DETONATING_CHARGE",
	name = "爆裂冲锋",
	info = function(self, t)
	return ([[向目标冲锋，如果到达目标位置，则攻击目标造成 %d%% 武器伤害。
	若攻击命中，将释放强烈的火焰冲击，击退 %d 码之内目标之外的所有敌对生物。
	至少要从 2 码外开始冲锋。]]):format(t.getMainHit(self,t) * 100, t.fireRadius(self,t), t.getDamage(self, t))
	end,
}

	
registerTalentTranslation{
	id = "T_VORACIOUS_BLADE",
	name = "饕餮之刃",
	info = function(self, t)
	return ([[你的利刃充满着对杀戮的渴望。
	在技能冷却完毕后，当杀死敌人时，接下来 6 回合内的 %d 次近战攻击必定暴击，在持续时间内，暴击系数增加 %d%% 。
	另外，每次击杀时额外获得 %d 点活力。]]):format(t.getHits(self, t), t.getMult(self, t), t.vimBonus(self, t))
	end,
}

	
registerTalentTranslation{
	id = "T_DESTROYER",
	name = "毁灭者",
	info = function(self, t)
		local dest = t.getDestroy(self, t)
		return ([[恶魔空间的力量充溢了你的身体，将你转换成一个强大的恶魔，持续 %d 回合。 
	变身期间，体力恢复和物理强度增加 %d ，缴械和震慑抗性增加 %d%% 。
	物理强度，体力恢复，状态抗性加值受法力强度加成。
	变身期间，其他技能也受到强化：
	汲魂痛击：冷却时间减少 %d 。
	舍身一击：增加 %d%% 全体抗性穿透，持续 %d 回合。
	歼灭挥斩：增加半径 %d 。
	锁魂之链：如果命中，额外附加 %d 次 35%% 武器伤害的攻击。
	焚尽强击：增加额外伤害几率至 %d%% 。
	恐惧盛宴：每汲取一层叠加的恐惧，获得 %0.1f 点活力。
	乌鲁克之胃：角度增加 %d 。]]):
	format(t.getDuration(self, t),
		t.getPower(self, t),
		math.min(math.ceil(t.getPower(self, t)/40 *100),100),
		math.ceil(dest/3),
		10 * dest, 3 + math.ceil(dest/2),
		math.ceil(dest/4),
		math.ceil(dest/2),
		25 + 10 * dest,
		dest * 0.4,
		dest * 10)
	end,
}


return _M
