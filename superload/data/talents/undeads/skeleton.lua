local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SKELETON",
	name = "骷髅体质",
	info = function(self, t)
		return ([[调整你的骷髅体质，增加 %d 点力量和敏捷。]]):
		format(t.statBonus(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BONE_ARMOUR",
	name = "骨质盔甲",
	info = function(self, t)
		return ([[在你的周围制造一个能吸收 %d 点伤害的骨盾。持续 10 回合。 
		受敏捷影响，护盾的最大吸收值有额外加成。]]):
		format(t.getShield(self, t) * (100 + (self:attr("shield_factor") or 0)) / 100)
	end,
}

registerTalentTranslation{
	id = "T_RESILIENT_BONES",
	name = "弹力骨骼",
	info = function(self, t)
		return ([[你的骨头充满弹性，至多减少 %d%% 所有负面状态持续的时间。]]):
		format(100 * t.durresist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SKELETON_REASSEMBLE",
	name = "重组",
	info = function(self, t)
		return ([[重新组合你的骨头，治疗你 %d 点生命值。 
		在等级 5 时你将会得到重塑自我的能力，被摧毁后可以原地满血复活。（仅限 1 次）]]):
		format(t.getHeal(self, t))
	end,
}


return _M
