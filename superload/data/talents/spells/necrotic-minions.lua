local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_NECROTIC_AURA",
	name = "死灵光环",
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local decay = t.getDecay(self, t)
		return ([[产生一个死灵光环，维持你亡灵随从的生存， %d 码有效范围。在光环以外的随从每回合减少 %d%% 生命。 
		 所有在你光环中被杀死的敌人灵魂可以吸收以召唤随从。 
		 食尸鬼的呕吐同时也能治疗你，即使你不是不死族。]]):
		format(radius, decay)
	end,
}

registerTalentTranslation{
	id = "T_CREATE_MINIONS",
	name = "亡灵召唤",
	info = function(self, t)
		local nb = t.getMax(self, t)
		local lev = t.getLevel(self, t)
		local mm = self:knowTalent(self.T_MINION_MASTERY) and " (Minion Mastery effects included)" or ""
		return ([[通过你的亡灵光环释放强烈的不死能量。在你的光环里，每有 1 个刚死亡的目标，你召唤 1 个亡灵随从（最多 %d 个）。 
		 亡灵随从在光环边缘按照锥形分布。 
		 单位等级为你的等级 %+d.
		 每个单位有概率进阶为 %s:%s ]]):
		format(nb, lev, mm, t.MinionChancesDesc(self, t)
		:gsub("Degenerated skeleton warrior","堕落骷髅战士"):gsub("Skeleton warrior","骷髅战士"):gsub("Armoured skeleton warrior","装甲骷髅战士")
		:gsub("Skeleton archer","骷髅弓箭手"):gsub("Skeleton master archer","精英骷髅弓箭手"):gsub("Skeleton mage","骷髅法师")
		:gsub("Ghoul","食尸鬼"):gsub("Ghast","妖鬼"):gsub("king","王"))
	end,
}

registerTalentTranslation{
	id = "T_AURA_MASTERY",
	name = "光环掌握",
	info = function(self, t)
		return ([[随着你逐渐强大，黑暗能量的影响范围增加。 
		 增加亡灵光环 %d 码半径，并减少光环范围外亡灵随从每回合掉血量 %d%% 。
		 技能等级 3 后，光环内亡灵随从死亡时有 25%% 几率返还灵魂，若其转换为鬼火，则在鬼火爆炸时返还。.]]):
		format(math.floor(t.getbonusRadius(self, t)), math.min(7, self:getTalentLevelRaw(t)))
	end,
}

registerTalentTranslation{
	id = "T_SURGE_OF_UNDEATH",
	name = "不死狂潮",
	info = function(self, t)
		return ([[一股强大的能量灌输入你的所有亡灵随从。 
		 增加它们的物理强度、法术强度和命中 %d 点， %d 点护甲穿透， %d 暴击几率，持续 6 回合。 
		 受法术强度影响，此效果有额外加成。]]):
		format(t.getPower(self, t), t.getAPR(self, t), t.getCrit(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DARK_EMPATHY",
	name = "黑暗共享",
	info = function(self, t)
		return ([[你和你的亡灵随从分享你的能量，随从获得你的抵抗和豁免的 %d%% 。 
		 此外，所有随从对你和其他随从造成的伤害减少 %d%% 。 
		 受法术强度影响，此效果有额外加成。]]):
		format(t.getPerc(self, t), self:getTalentLevelRaw(t) * 20)
	end,
}


return _M
