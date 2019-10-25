local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_INDUCE_ANOMALY",
	name = "引导异常",
	info = function(self, t)
		local reduction = t.getReduction(self, t)
		return ([[引发一次异常，减少你的紊乱值 %d 。这个技能不会引发重大异常。
		引导异常不会被扭曲命运延后，也不会触发被延后的异变。 
		然而，当学会扭曲命运后，你可以选中引导异变作为目标。
		受法术强度影响，紊乱值减少效果有额外加成。]]):format(reduction)
	end,
}

registerTalentTranslation{
	id = "T_REALITY_SMEARING",
	name = "弥散现实",
	info = function(self, t)
		local ratio = t.getPercent(self, t)
		local duration = t.getDuration(self, t)
		return ([[当激活这个技能时，你受到伤害的 30%% 被转化为 %0.2f 的紊乱值。
		这些紊乱伤害会被分散到三个回合中。]]):
		format(ratio, duration)
	end,
}

registerTalentTranslation{
	id = "T_ATTENUATE",
	name = "湮灭洪流",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[对范围内所有单位造成 %0.2f 时空伤害，这些伤害会被分散到 %d 回合中。技能半径为 %d 格。
		带有弥散现实效果的单位不会受到伤害，并在四回合中回复 %d 生命值。
		如果目标的生命值被减低到 20%% 以下，湮灭洪流将会立刻杀死目标。
		受到法术强度影响，伤害有额外加成。]]):format(damage, duration, radius, damage *0.4)
	end,
}

registerTalentTranslation{
	id = "T_TWIST_FATE",
	name = "扭曲命运",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local talent
		local t_name = "None"
		local t_info = ""
		local eff = self:hasEffect(self.EFF_TWIST_FATE)
		if eff then
			talent = self:getTalentFromId(eff.talent)
			t_name = talent.name
			t_info = talent.info(self, talent)
		end
		return ([[当扭曲命运没有进入冷却时，微小异变将会被延后 %d 回合，允许你正常地使用法术。  你可以使用扭曲命运技能来选择指定的区域来触发被延后的异变。		如果在第一个异变被延后的回合中引发了第二个异变，那么第一个异变将会立刻触发，并且打断你当前的回合或行动。
		当触发被延后的异变时，可以立即减少紊乱值。
				
		当前异变： %s 
		
		%s ]]):
		format(duration, t_name, t_info)
	end,
}

return _M
