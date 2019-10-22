local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_UNDEAD_EXPLOSION",
	name = "亡灵爆炸",
	info = function(self, t)
		return ([[亡灵随从只是工具。你可以残忍地引爆它们。 
		使目标单位爆炸并造成枯萎伤害，伤害为它最大生命值的 %d%% ,半径为 %d 。 
		注意！别站在爆炸范围内！( 除非你学会了黑暗共享，这样你有 %d%% 几率无视伤害。)]]):
		format(t.getDamage(self, t),t.radius(self,t), self:getTalentLevelRaw(self.T_DARK_EMPATHY) * 20)
	end,
}

registerTalentTranslation{
	id = "T_ASSEMBLE",
	name = "亡灵组合",
	info = function(self, t)
		return ([[将 3 个单位组合成 1 个骨巨人。 
		在等级 1 时它可以制造 1 个骨巨人。 
		在等级 3 时它可以制造 1 个重型骨巨人。 
		在等级 5 时它可以制造 1 个不朽骨巨人。 
		在等级 6 时它可以有 20%% 几率制造 1 个符文骨巨人。 
		在同一时间只能激活 %s 。]]):
		format(necroEssenceDead(self, true) and "2 个骨巨人" or "1 个骨巨人")
	end,
}

registerTalentTranslation{
	id = "T_SACRIFICE",
	name = "献祭骨盾",
	info = function(self, t)
		return ([[牺牲 1 个骨巨人。使用它的骨头，你可以制造一个临时的骨盾，格挡超过你总生命值的 %d%% 的任何伤害。 
		此效果持续 %d 回合。]]):
		format(t.getPower(self, t), t.getTurns(self, t))
	end,
}

registerTalentTranslation{
	id = "T_MINION_MASTERY",
	name = "亡灵精通",
	info = function(self, t)
		return ([[你召唤的每个亡灵单位有概率进阶:%s]]):
		format(self:callTalent(self.T_CREATE_MINIONS,"MinionChancesDesc")
		:gsub("Degenerated skeleton warrior","堕落骷髅战士"):gsub("Skeleton warrior","骷髅战士"):gsub("Armoured skeleton warrior","装甲骷髅战士")
		:gsub("Skeleton archer","骷髅弓箭手"):gsub("Skeleton master archer","精英骷髅弓箭手"):gsub("Skeleton mage","骷髅法师")
		:gsub("Ghoul","食尸鬼"):gsub("Ghast","妖鬼"):gsub("king","王")
		:gsub("Vampire","吸血鬼"):gsub("Master vampire","精英吸血鬼"):gsub("Grave wight","坟墓尸妖")
		:gsub("Barrow wight","古墓尸妖"):gsub("Dread","梦靥"):gsub("Lich","巫妖")
		)
	end,
}


return _M
