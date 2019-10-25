local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_PROPHECY",
	name = "预言",
	info = function(self, t)
		local mcd = t.getMadnessCooldown(self,t)*100
		local rdam = t.getRuinDamage(self,t)
		local tchance = t.getTreasonChance(self,t)
		--local tdam = t.getTreasonDamage(self,t)
		return ([[对目标释放熵能力量，你预言了它无可避免的末日。随着技能等级提升，你能解锁更多预言。同一目标不能同时处于两种预言下。		
技能等级 1：毁灭预言。当生命值滑落至最大生命的 75%% ，50%% 或 25%% 下时，造成 %d 伤害。
技能等级 3：背叛预言。每回合有 %d%% 几率攻击友方单位或自身。
技能等级 5：疯狂预言。增加 %d%% 技能冷却时间。]]):
		format(mcd, rdam, tchance)
	end,
}

-- These may need to be implemented differently to avoid talent level scaling bugs
registerTalentTranslation{
	id = "T_PROPHECY_OF_MADNESS",
	name = "疯狂预言",
	info = function(self, t)
		local cd = t.getCooldown(self,t)*100
		return ([[对目标施加疯狂预言，增加 %d%% 技能冷却时间，持续 6 回合。]]):format(cd)
	end,
}

registerTalentTranslation{
	id = "T_PROPHECY_OF_RUIN",
	name = "毁灭预言",
	info = function(self, t)
		local dam = t.getDamage(self,t)
		return ([[对目标施加毁灭预言，  持续 6 回合。
		当生命值滑落至最大生命的 75%% ，50%% 或 25%% 下时，造成 %d 暗影伤害。
		伤害受法术强度加成。]]):format(dam)
	end,
}

registerTalentTranslation{
	id = "T_PROPHECY_OF_TREASON",
	name = "背叛预言",
	info = function(self, t)
		local chance = t.getChance(self,t)
		return ([[对目标施加背叛预言，  持续 6 回合。每回合有 %d%% 几率攻击友方单位或自身。]]):format(chance)
	end,
}

registerTalentTranslation{
	id = "T_GRAND_ORATION",
	name = "隆重演说",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local talent = self:isTalentActive(t.id) and self:getTalentFromId(self:isTalentActive(t.id).talent).name or "None"		
		return ([[你隆重地宣读某种预言，令其在周围 %d 格内传播。
		同一种预言只能以一种方式进行强化，隆重演说，双重诅咒或者天启。
		
		当前预言 : %s]]):
		format(rad, talent)
	end,
}

registerTalentTranslation{
	id = "T_TWOFOLD_CURSE",
	name = "双重诅咒",
	info = function(self, t)
		local talent = self:isTalentActive(t.id) and self:getTalentFromId(self:isTalentActive(t.id).talent).name or "None"		
		return ([[对你的听众施加双重诅咒。每当你施加其他预言时，你选择的预言将同时施加给主要目标 (技能等级 %d)。 
		同一种预言只能以一种方式进行强化，隆重演说，双重诅咒或者天启。
		当前预言 : %s]]):
		format(self:getTalentLevel(t), talent)
	end,
}

registerTalentTranslation{
	id = "T_REVELATION",
	name = "天启",
	info = function(self, t)
		local madness = t.getMadness(self,t)
		local ruin = t.getRuin(self,t)
		local treason = t.getTreason(self,t)
		local talent = self:isTalentActive(t.id) and self:getTalentFromId(self:isTalentActive(t.id).talent).name or "None"
		return ([[当你宣读预言时，来自虚空的回响将指引你带来敌人的末日。你选择的预言将提供 1 0 回合的加成。
		疯狂预言：每次目标使用技能时，你的一个技能的冷却时间将减少 %d 。
		毁灭预言：每次目标受到伤害时，你回复 %d%% 伤害值。
		背叛预言 :  你受到的 %d%% 伤害将转移至周围随机目标。
		
		同一种预言只能以一种方式进行强化，隆重演说，双重诅咒或者天启。
		当前预言 : %s]]):
		format(madness, ruin, treason, talent)
	end,
}

return _M
