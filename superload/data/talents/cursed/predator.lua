local _M = loadPrevious(...)


registerTalentTranslation{
	id = "T_PREDATOR",
	name = "猎杀者",
	info = function(self, t)
		return ([[你从过去的杀戮中汲取知识，强化你猎杀的能力。你过去每杀死过该类型的一个生物，就获得 %0.2f 命中和 %0.2f 护甲穿透，最多 %d 层 （ %d 命中， %d 护甲穿透）。
		另外，当你攻击杀死同类数量少于 %d 的生物时，你每次攻击获得 1 点仇恨值。]]):format(t.getATK(self, t), t.getAPR(self, t), t.getTypeKillMax(self, t), t.getATK(self, t) * t.getTypeKillMax(self, t), t.getAPR(self, t) * t.getTypeKillMax(self, t), t.getTypeKillMax(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SAVAGE_HUNTER",
	name = "凶残猎手",
	info = function(self, t)
		return ([[每当你造成一次近战暴击，你凶残的捕猎欲望在你的狩猎场中产生一股诅咒瘴气。
		瘴气会试图扩散到半径 %d 码内的 %d 格内，包括你自己所在的位置，对敌人交替造成 %0.2f 暗影或精神伤害，并阻挡视线。
		迷失在你瘴气中的猎物有 %d%% 的几率失去你的位置，并有可能攻击自己的盟友。
		凶残猎手触发时会消耗15点仇恨值，不会当你位于诅咒瘴气中时触发。]]):format(t.getMiasmaCount(self, t), self:getTalentRadius(t), self:damDesc(DamageType.DARKNESS, t.getDamage(self, t)/2) + self:damDesc(DamageType.MIND, t.getDamage(self, t)/2), t.getChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHROUDED_HUNTER",
	name = "障壁猎手",
	info = function(self, t)
		return ([[当你被包裹在诅咒瘴气中时，你获得潜行 (%d 强度) ，并有 %d%% 几率避免暴击伤害。
		潜行强度受精神强度加成。]]):format(t.getStealthPower(self, t), t.getCritResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_MARK_PREY",
	name = "猎杀标记",
	info = function(self, t)
		return([[将你的猎杀欲望集中在最重要的猎物身上。当你第一次走入某张地图，你会将最多 %d 个敌人标记成你的猎物。无论它们在哪里，你可以获得它们的视野。此外，对于所有它们所属的子分类的敌人，你从它们那里收到的伤害降低 %d%% 。]]):format(t.getCount(self, t), t.getPower(self, t))
	end,
}

return _M
