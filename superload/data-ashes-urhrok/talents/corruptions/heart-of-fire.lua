local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_BURNING_SACRIFICE",
	name = "燃烧献祭",
	info = function(self, t)
	local mult = t.getMult(self, t) * 100
	local dam = t.getDam(self, t) * 100
	return ([[每次你击杀一个燃烧的敌对生物时，会立刻对一个随机相邻敌对生物进行一次攻击，造成 %d%% 武器伤害。
	另外，焚尽强击必定被此效果触发（或者下一次攻击），对所有击中的敌对生物造成 %d%% 倍伤害。
	此效果每 5 回合才能触发一次。]]):format(dam, mult)
	end,
}


registerTalentTranslation{
	id = "T_DEVOURING_FLAMES",
	name = "火焰守护",
	info = function(self, t)
	return ([[吸取燃烧中的烈焰，将自己包裹其中。
	除去半径 5 内的敌方生物身上的燃烧效果，同时制造一层持续 %d 轮的 %d 强度的护盾，每吸收一层燃烧效果护盾强度增加 15%% 。
	当护盾效果结束时，将在半径 %d 范围内释放一次火焰爆炸，灼烧周围生物 3 回合，造成等于护盾初始值的伤害。]]):format(t.getDur(self, t), t.getBaseShield(self, t), t.getRange(self, t))
	end,
}


registerTalentTranslation{
	id = "T_INFERNO_NEXUS",
	name = "吞噬之焰",
	info = function(self, t)
	return ([[恶魔之炎抚育你成长。每次你近战攻击命中时，你对目标施加诅咒，只要其处于燃烧状态，你每回合获得 %0.2f 生命与 %0.2f 活力。 
	同时，在你周围 10 码范围内，所有被诅咒火焰燃烧的敌方生物会将诅咒传播至半径 1 内的燃烧生物上，并造成 %d 火焰伤害同时给予你等量治疗。]]):format(t.getHeal(self, t), t.getVim(self, t), t.getDam(self, t))
	end,
}

		

registerTalentTranslation{
	id = "T_BLAZING_REBIRTH",
	name = "烈焰重生",
	info = function(self, t)
	return ([[生命值恢复为满值，但治疗值转化为持续 %d 回合的伤害。 
	伤害会平均分配给你自己和 %d 码范围内的燃烧敌对生物。
	你受到的伤害无法减免，敌对生物受到火焰伤害。]]):format(t.getDur(self, t), t.getRange(self, t))
	end,
}


return _M
