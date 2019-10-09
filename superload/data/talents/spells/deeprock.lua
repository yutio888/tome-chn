local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DEEPROCK_FORM",
	name = "深岩形态",
	info = function(self, t)
		local xs = ""
		local xsi = ""
		if self:knowTalent(self.T_VOLCANIC_ROCK) then
			xs = xs..(", 增加 %0.1f%% 奥术伤害和 %0.1f%% 奥术抗性穿透"):
			format(self:callTalent(self.T_VOLCANIC_ROCK, "getDam"), self:callTalent(self.T_VOLCANIC_ROCK, "getPen"))
		end
		if self:knowTalent(self.T_BOULDER_ROCK) then
			xs = (", 增加 %0.1f%% 自然伤害和 %0.1f%% 自然抗性穿透"):
			format(self:callTalent(self.T_BOULDER_ROCK, "getDam"), self:callTalent(self.T_BOULDER_ROCK, "getPen"))..xs
		end
		if self:knowTalent(self.T_MOUNTAINHEWN) then
			xsi = (" 和 %d%% 流血、毒素、疾病和震慑免疫"):
			format(self:callTalent(self.T_MOUNTAINHEWN, "getImmune")*100)
		end
		return ([[你呼唤世界深层的核心之力，用来改造自己的身体。
		%d 回合内，你将变成深岩元素形态，增加 2 点体型 %s 。
		同时，你将增加 %0.1f%% 物理伤害和 %0.1f%% 物理抗性穿透 %s ，并获得 %d 点护甲。 %s
		效果受法术强度加成。]])
		:format(t.getTime(self, t), xsi, t.getDam(self, t),t.getPen(self, t), xs, t.getArmor(self, t), self:getTalentLevel(self.T_MOUNTAINHEWN) >=5 and "\n另外，你将用物理抗性取代其他伤害抗性。" or "")
	end,
}

registerTalentTranslation{
	id = "T_VOLCANIC_ROCK",
	name = "火山熔岩",
	info = function(self, t)
		local tv = self:getTalentFromId(self.T_VOLCANO)
		return ([[当你进入深岩元素形态时，增加 %0.1f%% 奥术伤害和 %0.1f%% 奥术抗性穿透，同时获得激发火山的能力:
		%s]]):
		format(t.getDam(self, t),t.getPen(self, t), self:getTalentFullDescription(tv, self:getTalentLevelRaw(t) * 2):toString())
	end,
}

registerTalentTranslation{
	id = "T_BOULDER_ROCK",
	name = "岩石投掷",
	info = function(self, t)
		local tv = self:getTalentFromId(self.T_THROW_BOULDER)
		return ([[当你进入深岩元素形态时，增加 %0.1f%% 自然伤害和 %0.1f%% 自然抗性穿透，同时获得投掷巨石的能力:
		%s]]):
		format(t.getDam(self, t),t.getPen(self, t), self:getTalentFullDescription(tv, self:getTalentLevelRaw(t) * 2):toString())
	end,
}

registerTalentTranslation{
	id = "T_MOUNTAINHEWN",
	name = "山崩地裂",
	info = function(self, t)
		return ([[当你进入深岩元素形态时，你获得 %d%% 流血、毒素、疾病和震慑免疫。
		技能等级 5 或以上时，在深岩元素形态下，你将用物理抗性取代其他伤害抗性。]]):
		format(t.getImmune(self, t)*100)
	end,
}


return _M
