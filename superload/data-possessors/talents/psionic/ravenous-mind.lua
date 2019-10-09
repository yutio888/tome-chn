local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_SADIST",
	name = "虐待狂",
	info = function (self,t)
		return ([[你从视野内所有敌人的痛苦中得到养分。每一个生命值低于 80%% 的敌人将让你获得一层虐待狂效果，每层增加你的原始精神强度 %d.
		]]):
		format(t.getPower(self, t))
	end,
}
registerTalentTranslation{
	id = "T_CHANNEL_PAIN",
	name = "痛苦连接",
	info = function (self,t)
		return ([[当你至少有一层虐待狂效果时，每当你受到伤害你使用虐待狂效果减免伤害，最终受到的伤害为受到伤害除以虐待狂效果层数。
		计算时层数 + 1 ，每层效果消耗 %d 灵能值。
		每次生效时，视野内随机一个生命值低于 80%% 的敌人，会受到伤害反弹，伤害为所吸收伤害的 %d%% 的精神伤害。
		该效果每回合一次，且只会在伤害超过你 10%% 最大生命值时才触发。]]):
		format(t.getPsi(self, t), t.getBacklash(self, t))
	end,
}
registerTalentTranslation{
	id = "T_RADIATE_AGONY",
	name = "痛苦辐射",
	info = function (self,t)
		return ([[当你至少有一层虐待狂效果时，你可以分享你的痛苦给半径 %d 所有可见的生命值少于 80%% 的敌人。
		持续 5 回合，他们的头脑将如此专注于自己的痛苦，对你的伤害减少 %d%%]]):
		format(self:getTalentRadius(t), t.getProtection(self, t))
	end,
}
registerTalentTranslation{
	id = "T_TORTURE_MIND",
	name = "精神拷打",
	info = function (self,t)
		return ([[当你至少有一层虐待狂效果时，你可以精神鞭打一个目标，发送恐怖的图像到目标的脑海中。
		在 %d 回合内，目标随机 %d 个技能将无法使用。]]):
		format(t.getDur(self, t), t.getNb(self, t))
	end,
}
return _M