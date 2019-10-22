local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RAIN_OF_FIRE",
	name = "陨星火雨",
	info = function(self, t)
		return ([[你释放魔法大爆炸的力量，持续消耗活力。
		当技能开启时，每回合将召唤 2 个陨石坠落在你身边，在半径 2 的范围内造成 %0.2f 物理与 %0.2f 火焰伤害。
		这项法术在休息或跑步时自动关闭。
		效果受法术强度加成。]])
		:format(t.getDam(self, t), t.getDam(self, t))
	end,
}


registerTalentTranslation{
	id = "T_ONLY_ASHES_LEFT",
	name = "唯余灰烬",
	info = function(self, t)
		return ([[通过引发魔法大爆炸最黑暗的时候的场景，你加速了敌人的死亡。
		每次你对半径 %d 内的生物造成伤害后，如果它生命值低于 33%% ，将会承受魔法大爆炸的力量。
		受影响的敌人每回合将受到 %0.2f 暗影伤害，直到死亡或者离开范围。
		伤害受法术强度加成。]]):
		format(self:getTalentRadius(t), t.getDam(self, t), self:getTalentRadius(t))
	end,
}


registerTalentTranslation{
	id = "T_SHATTERED_MIND",
	name = "精神破碎",
	info = function(self, t)
		return ([[当你格挡攻击时，你能将魔法大爆炸的力量传导至攻击者的精神中，持续 5 回合。
		受影响的生物每次使用技能时有 %d%% 几率失败，同时全体豁免下降 %d 点。]]):
		format(t.getFail(self, t), t.getSaves(self, t))
	end,
}


registerTalentTranslation{
	id = "T_TALE_OF_DESTRUCTION",
	name = "毁灭传说",
	info = function(self, t)
		return ([[你赞颂恶魔家乡 Mal'Rok 的毁灭。
		每次你杀死生物时，你将释放魔法波动，在半径 %d 范围内的生物将承受 %d 回合的混乱或目盲毒素。
		中毒的生物每回合将受到 %0.2f 暗影伤害。
		伤害受法术强度加成。]]):
		format(self:getTalentRadius(t), t.getDur(self, t), t.getDamage(self, t))
	end,
}


return _M
