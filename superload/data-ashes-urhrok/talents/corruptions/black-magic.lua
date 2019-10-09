local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_BLEAK_OUTCOME",
	name = "悲惨结局",
	info = function(self, t)
		return ([[你的一举一动都是敌人悲惨结局的预兆。
		每次你造成暗影、火焰、枯萎或酸性伤害时，你诅咒你的目标，最多叠加至 %d 次（每回合只能诅咒一个目标）。
		每有一层诅咒，你杀死被诅咒目标时获得的活力值增加 100%% 。
		获得活力值基础值取决于意志。]]):
		format(t.getStack(self, t))
	end,
}

	
registerTalentTranslation{
	id = "T_STRIPPED_LIFE",
	name = "生命剥夺",
	info = function(self, t)
		return ([[当至少承受了你 5 层悲惨结局诅咒的生物死亡时，你尽情享受它的活力，在 6 回合内增加法术强度 %d 点。]])
		:format(t.getSpellpowerIncrease(self, t))
	end,
}


registerTalentTranslation{
	id = "T_GRIM_FUTURE",
	name = "无情未来",
	info = function(self, t)
		return ([[对你的敌人来说，未来非常无情。
		每次你杀死被你的悲惨结局诅咒的生物时，该生物半径 %d 范围内的生物将被眩晕 2 回合。
		这个效果每 %d 回合只能触发一次( 只计算眩晕成功的回合 )。]]):
		format(self:getTalentRadius(t), t.cooldown(self, t))
	end,
}


registerTalentTranslation{
	id = "T_OMINOUS_SHADOW",
	name = "不祥黑影",
	info = function(self, t)
		return ([[当被悲惨结局诅咒的生物死亡时，你获得一个不祥黑影（至多 %d 个），保存 12 回合。
		每个不祥黑影能让你隐身 2 回合，隐形强度 %d 。]]):
		format(t.getStack(self, t), t.getInvisibilityPower(self, t))
	end,
}


return _M
