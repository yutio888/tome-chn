local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_MIND_STEAL",
	name = "精神窃取",
	info = function (self,t)
		return ([[链接目标，偷取目标一个技能。
		持续 %d 回合，你获得目标一个随机主动技能 (非被动，非持续) ，目标会失去该技能。
		你不会偷取一个已有的技能。
		偷取的技能不消耗任何能量。
		在等级 5 时，可选择偷取的技能。
		偷取的技能等级被限制成最高为 %d 级。]]):
		format(t.getDuration(self, t), t.getMaxTalentsLevel(self, t))
	end,
}
registerTalentTranslation{
	id = "T_SPECTRAL_DASH",
	name = "光谱冲锋",
	info = function (self,t)
		return ([[短暂的一瞬间，你的整个身体变得飘渺，你对附近一个生物进行一次直线冲锋 (范围 %d)。
		你再次出现在另一边，获得 %d 灵能值并对目标造成 %0.2f 精神伤害。
		]]):
		format(t.getRange(self,t), t.getPsi(self, t), damDesc(self, DamageType.MIND, t.getDam(self, t)))
	end,
}
registerTalentTranslation{
	id = "T_WRITHING_PSIONIC_MASS",
	name = "扭曲装甲",
	info = function (self,t)
		return ([[你的身体形态只不过是你心灵的延伸，你可以随意扭曲它 %d 回合。
		效果生效时，你全部抗性提升 %d%% 并有 %d%% 几率避免被暴击。
		激活时，你最多可以移除 %d 个物理或者精神效果。
		]]):
		format(t.getDur(self, t), t.getResist(self, t), t.getCrit(self, t), t.getNbEffects(self, t))
	end,
}
registerTalentTranslation{
	id = "T_OMINOUS_FORM",
	name = "不详躯体",
	info = function (self,t)
		return ([[你的灵能力量没有限制。你现在能够攻击一个目标，克隆它的身体，且不需要杀死它。
		身体只是暂时的，持续 %d 回合并受到你正常力量的限制。
		该身体的生命值与你目标的生命值绑定在一起。(你的血量百分比和目标的血量百分比相同)
		]]):
		format(t.getDur(self, t))
	end,
}
return _M