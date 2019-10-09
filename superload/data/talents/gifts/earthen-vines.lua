local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STONE_VINES",
	name = "岩石藤蔓",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local turns, dam, arcanedam = t.getValues(self, t)
		local xs = arcanedam and (" 和 %0.1f 奥术伤害"):format(arcanedam) or ""
		return ([[你周围的地面开始生成岩石藤蔓。
		每回合藤蔓将试图抓住半径 %d 内的一个随机目标。
		受影响的目标将被定身，同时每回合受到 %0.1f 自然伤害 %s, 持续 %d 回合。
		被岩石藤蔓抓住的生物每回合有一定几率逃脱，如果距离你超过 %d 码则自动逃脱。 
		定身几率和伤害受法术强度与技能等级加成。]]):
		format(rad, damDesc(self, DamageType.NATURE, dam), xs, turns, rad+4)
	end,
}

registerTalentTranslation{
	id = "T_ELDRITCH_VINES",
	name = "奥术藤蔓",
	info = function(self, t)
		return ([[每次藤蔓造成伤害时，你回复 %0.1f 点失衡值与 %0.1f 点法力值。
		同时藤蔓会附加 %0.1f 奥术伤害。]])
		:format(t.getEquilibrium(self, t), t.getMana(self, t), t.getDamage(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ROCKWALK",
	name = "岩石漫步",
	info = function(self, t)
		return ([[吸收一条岩石藤蔓，并将自己拉到被困住的怪物附近（最大半径 %d ）。
		吸收岩石藤蔓会治疗你 %0.2f 点生命值。
		使用这个技能不会打破岩石身躯。]])
		:format(self:getTalentRange(t) ,100 + self:combatTalentStatDamage(t, "wil", 40, 630))
	end,
}

registerTalentTranslation{
	id = "T_ROCKSWALLOW",
	name = "岩石吞噬",
	info = function(self, t)
		return ([[将半径 %d 内的目标连同岩石藤蔓一起拉过来，造成 %0.1f 自然伤害。
		伤害受法术强度加成。]])
		:format(self:getTalentRange(t), 80 + self:combatTalentStatDamage(t, "wil", 40, 330))
	end,
}


return _M
