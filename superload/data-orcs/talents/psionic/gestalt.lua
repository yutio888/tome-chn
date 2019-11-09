local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GESTALT",
	name = "格式塔",
	info = function(self, t)
		return ([[你让你的心灵从你的蒸汽发动机中汲取能量，按照你蒸汽的比例增加你的精神强度：满蒸汽时 %d 点， 0 蒸汽时 0 点。
		使用精神技能会反馈你的发动机，为你的下一个蒸汽技能增加 %d 点蒸汽强度。
		使用蒸汽技能会反馈你的精神，增加你的 %d 点你的超能力。
		效果会随着你的精神强度增加。]]):
		format(t.getMind(self, t), t.getSteam(self, t), t.getPsi(self, t))
	end,}

registerTalentTranslation{
	id = "T_IMPROVED_GESTALT",
	name = "强化格式塔",
	info = function(self, t)
		local shield_power = t.getShieldPower(self, t)
		return ([[每当你在格式塔激活状态中使用蒸汽技能时，你会吸取一些残留的力量来形成一个精神护盾。
		这个护盾持续 3 回合，并能吸收 %d 伤害。
		效果会随着你的精神强度增加。]]):format(shield_power)
	end,}

registerTalentTranslation{
	id = "T_INSTANT_CHANNELING",
	name = "瞬间引导",
	info = function(self, t)
		return ([[瞬间引导你剩余的所有蒸汽来补充你的超能力并充能或制造一个新的精神护盾。
		护盾的持续时间会增加 3 回合，并能多吸收 %d%% 消耗的蒸汽数额的伤害。
		你回复等同于 %d%% 所消耗的蒸汽数额的超能力。
		此技能需要格式塔在激活状态且有一个精神护盾或者强化格式塔不在冷却中。]]):format(t.getPower(self, t), t.getPsi(self, t))
	end,}

registerTalentTranslation{
	id = "T_FORCED_GESTALT",
	name = "强力格式塔",
	info = function(self, t)
		return ([[暂时延伸你的心灵以使你的格式塔笼罩你周围半径 5 码内的敌人，最多可影响 %d 个敌人。
		格式塔会吸收每个被影响敌人的力量（物理强度，精神强度，法术强度，蒸汽强度） %d 点，持续 5 回合。
		你自身的力量会增加所吸取的数额（每多吸收一个额外的敌人，效果都会衰减）。
		除此之外，在 5 回合内你可以超脱视线的感知半径 %d 码内的生物。
		效果会随着你的精神强度增加。]]):format(t.getNb(self, t), t.getPower(self, t), t.getSenseRadius(self, t))
	end,}
return _M