local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHADOW_SENSES",
	name = "阴影感知",
	info = function(self, t)
		return ([[ 你的意识延伸到阴影上。
		你能清晰的感知到阴影的位置，同时还能感知到阴影视野 %d 码范围内的敌人。]])
		:format(self:getTalentRange(t))
	end,
}

registerTalentTranslation{
	id = "T_SHADOWS_EMPATHY",
	name = "阴影链接",
	info = function(self, t)
		return ([[你与你的阴影链接，你和你的阴影之间的界限渐渐模糊。
		你失去 %d%% 光系伤害抗性，获得 %d%% 暗影伤害抗性和伤害吸收。你的队伍里每有一个阴影，就获得 %0.2f%% 所有伤害抗性。]]):
		format(t.getLightResist(self, t), t.getDarkResist(self, t), t.getAllResScale(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_TRANSPOSITION",
	name = "阴影换位",
	info = function(self, t)
		return ([[ 现在，其他人很难分清你和阴影。 
 	 	 你能选择半径 %d 范围内的一个阴影并和它交换位置。
		同时至多 %d 个随机负面物理或魔法效果会被转移至选择的阴影身上。]])
		:format(self:getTalentRadius(t), t.getNb(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_DECOY",
	name = "阴影诱饵",
	info = function(self, t)
		return ([[ 你的阴影用生命来守护你。
		当你受到致命攻击时，你将立刻和随机一个阴影换位，让它代替承受攻击，并将此技能打入冷却。
		在接下来的 4 个回合，除非你的生命降至 - %d 下，否则你不会死去。
		受精神强度影响，效果有额外加成。]]):
		format(t.getPower(self, t))
	end,
}



return _M
