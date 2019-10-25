local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_PRECOGNITION",
	name = "预知未来",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local duration = t.getDuration(self, t)
		return ([[你预知未来，感知半径 %d 以内的生物和陷阱，持续 %d 回合。
		如果你学会了深谋远虑，那么在你激活这个技能的时候，你可以获得额外的闪避和暴击减免（数值等于深谋远虑的奖励）。]]):format(range, duration)
	end,
}

registerTalentTranslation{
	id = "T_FORESIGHT",
	name = "深谋远虑",
	info = function(self, t)
		local defense = t.getDefense(self, t)
		local crits = t.getCritDefense(self, t)
		return ([[获得 %d 闪避  和 %d%% 暴击减免。
		如果你激活了预知未来或者命运歧路，那么这些技能也会拥有同样的加成，使你获得额外的闪避和暴击减免。		
		受魔法影响，增益效果有额外加成。]]):
		format(defense, crits)
	end,
}

registerTalentTranslation{
	id = "T_CONTINGENCY",
	name = "意外术",
	info = function(self, t)
		local trigger = t.getTrigger(self, t) * 100
		local cooldown = self:getTalentCooldown(t)
		local talent = self:isTalentActive(t.id) and self:getTalentFromId(self:isTalentActive(t.id).talent).name or "None"
		return ([[选择一个只会影响你并且不需要选中目标的非固定 CD 主动法术。当你受到伤害并使生命值降低到 %d%% 以下时，自动释放这个技能。
		即使选择的技能处于冷却状态也可以释放  ，并且不消耗回合或资源，技能等级为该技能和指定技能当中较低的一方。		这个效果每 %d 回合只能触发一次，并且在伤害结算之后生效。

		当前选择技能： %s ]]):
		format(trigger, cooldown, talent)
	end,
}

registerTalentTranslation{
	id = "T_SEE_THE_THREADS",
	name = "命运螺旋",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[你窥视三种可能的未来，允许你分别进行探索 %d 回合。当效果结束，你选择三者之一成为你的现在。
		如果你学会了深谋远虑，当你使用命运螺旋时，将获得额外的闪避和暴击减免（数值等于深谋远虑的奖励）。
		这个法术会使时间线分裂。当此技能激活的时候，使用其他分裂时间线的技能将会失败。
		如果你在任何一条时间线上死亡，你将使时间线回到你使用技能的地方，并且技能效果结束。
		这个技能每个楼层只能使用一次。]])
		:format(duration)
	end,
}

return _M
