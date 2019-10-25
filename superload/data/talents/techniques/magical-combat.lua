local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ARCANE_COMBAT",
	name = "奥术武器",
	info = function(self, t)
		local talent_list = ""
		local build_string = {}
		for _, talent in pairs(self.talents_def) do
			if talent.allow_for_arcane_combat and talent.name then
				if #build_string > 0 then build_string[#build_string+1] = ", " end
				build_string[#build_string+1] = talent.name
			end
		end
		if #build_string > 0 then talent_list = table.concat(build_string) end
		
		local talent_selected = ""
		if self:isTalentActive(t.id) then
			local talent = self:getTalentFromId(self:isTalentActive(t.id).talent)
			if talent and talent.name then
				talent_selected = [[
				
				当前选择法术: ]] .. talent.name
			else
				talent_selected = [[
				
				当前选择法术: 随机]]
			end
		end
		return ([[允许你使用近战武器附魔法术。在你每次的近战攻击中都有 %d%% 概率附加一次火球术、闪电术或岩石飞弹。 
		你可以选择触发某一种法术，或者选择随机触发任意一种法术。
		当双持或持有盾牌时，  每把武器触发概率减半。
		通过这种方式触发的法术不会造成对应技能进入 CD 状态。
		受灵巧影响，触发概率有额外加成。
		允许法术： %s %s]]):
		format(t.getChance(self, t), talent_list, talent_selected)
	end,
}


registerTalentTranslation{
	id = "T_ARCANE_CUNNING",
	name = "奥术灵巧",
	info = function(self, t)
		local spellpower = t.getSpellpower(self, t)
		local bonus = self:getCun()*spellpower/100
		return ([[增加相当于你 %d%% 灵巧的法术强度。目前的法术强度加成： %d]]):
		format(spellpower, bonus)
	end,
}

registerTalentTranslation{
	id = "T_ARCANE_FEED",
	name = "奥术充能",
	info = function(self, t)
		return ([[当技能激活时，每回合恢复 %0.2f 法力值并提高 %d%% 物理及法术爆击几率。]]):format(t.getManaRegen(self, t), t.getCritChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ARCANE_DESTRUCTION",
	name = "奥术毁灭",
	info = function(self, t)
		return ([[通过你的武器来传送原始的魔法伤害。增加相当于你 %d%% 魔法属性值的物理强度（当前值： %d ）。
		每当你近战攻击暴击时，你会释放一个半径为 %d 码的奥术属性的魔法球，造成 %0.2f 的伤害。 
		受法术强度影响，增益按比例加成。
		当双持或持有盾牌时，只有50%% 的几率触发。
		技能等级 5 时，魔法球的半径变成 2。]]):
		format(t.getSPMult(self, t)*100, self:getMag() * t.getSPMult(self, t), self:getTalentRadius(t), damDesc(self, DamageType.ARCANE, t.getDamage(self, t)) )
	end,
}


return _M
