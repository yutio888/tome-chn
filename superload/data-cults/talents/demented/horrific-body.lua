local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_SHED_SKIN",
	name = "蜕皮",
	info = function(self, t)
		return ([[你蜕去表层变异皮肤，同时增加它的强度，令其在 7 回合内吸收 %d 伤害。]]):format(t.getAbsorb(self, t) * (100 + (self:attr("shield_factor") or 0)) / 100)
	end,
}

registerTalentTranslation{
	id = "T_PUSTULENT_GROWTH",
	name = "脓包生长",
	info = function(self, t)
		return ([[每次你的蜕皮护盾损失 %d%% 护盾量或者你受到超过 15%% 最大生命值的伤害时，一个黑色的腐败脓包将在你身上生长 5 回合。
		每个脓包增加你 %d%% 全体伤害抗性。
		你最多能同时拥有 %d 个脓包。
		抗性受法术强度加成。]]):
		format(t.getCutoff(self, t), t.getResist(self, t), t.getMax(self, t))
	end,
}

registerTalentTranslation{
	id = "T_PUSTULENT_FULMINATION",
	name = "脓包爆裂",
	info = function(self, t)
		return ([[你引爆身上所有脓包，产生黑色液体溅射到半径 %d 格内所有生物上，每个脓包造成 %0.2f 暗影伤害并治疗你 %0.1f 生命。]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.DARKNESS, t.getDam(self, t)), t.getHeal(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DEFILED_BLOOD",
	name = "污血",
	info = function(self, t)
		return ([[每次脓包爆裂时，你会在地上留下一滩持续 5 回合的污血。
		范围内的敌人每回合将被污血中产生的触手纠缠，受到 %d%% 暗影触手伤害并被污血覆盖 2 回合。
		被污血覆盖的敌人击中你时，你受到 %d%% 相应伤害的治疗。
		治疗系数受法术强度影响。]]):
		format(t.getDam(self, t) * 100, t.getHeal(self, t))
	end,
}

return _M
