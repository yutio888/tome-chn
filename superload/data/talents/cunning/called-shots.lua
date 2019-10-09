local _M = loadPrevious(...)

-- calc_all is so the info can show all the effects.
local sniper_bonuses = function(self, calc_all)
	local bonuses = {}
	local t = self:getTalentFromId("T_SKIRMISHER_SLING_SNIPER")
	local level = self:getTalentLevel(t)

	if level > 0 or calc_all then
		bonuses.crit_chance = self:combatTalentScale(t, 3, 10)
		bonuses.crit_power = self:combatTalentScale(t, 0.1, 0.2, 0.75)
	end
	if level >= 5 or calc_all then
		bonuses.resists_pen = {[DamageType.PHYSICAL] = self:combatStatLimit("cun", 100, 15, 50)} -- Limit < 100%
	end
	return bonuses
end

registerTalentTranslation{
	id = "T_SKIRMISHER_KNEECAPPER",
	name = "膝盖杀手",
	info = function(self, t)
		return ([[射击敌人的膝盖（或者任何活动肢体上的重要部位），造成 %d%% 武器伤害，并将敌人击倒（定身 %d 回合）并在之后降低其移动速度 %d%% %d 回合。
		这个射击将会穿过你和目标间的其他敌人。
		受灵巧影响，减速效果有额外加成。]])
		:format(t.damage_multiplier(self, t) * 100,
				t.pin_duration(self, t),
				t.slow_power(self, t) * 100,
				t.slow_duration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_THROAT_SMASHER",
	name = "致命狙击",
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[对敌人进行一次特殊的射击。
		这个技能专注于精准的远程狙击，造成 %d%% 的基础远程伤害以及受距离加成的额外伤害。
		在零距离，伤害加成（惩罚）为 %d%% ，在最大射程（ %d 格），伤害加成为 %d%% 。
		这个射击将会穿过你和目标间的其他敌人。]])
		:format(t.damage_multiplier(self, t) * 100, t.getDistanceBonus(self, t, 1)*100, range, t.getDistanceBonus(self, t, range)*100)

	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_NOGGIN_KNOCKER",
	name = "爆头连射",
	info = function(self, t)
		return ([[对敌人的脆弱部位（通常是头部）迅速地连射三次。
		每次射击造成 %d%% 远程伤害并试图震慑目标或增加震慑的持续时间 1 回合。
		这些射击将会穿过你和目标间的其他敌人。
		受命中影响，晕眩几率增加。]])
		:format(t.damage_multiplier(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_SLING_SNIPER",
	name = "投石大师",
	info = function(self, t)
		local bonuses = sniper_bonuses(self, true)
		return ([[你对射击的掌握程度无与伦比。你的精准射击系技能获得 %d%% 额外暴击几率和 %d%% 额外暴击伤害。 
		在第 3 级时，所有精准射击系技能冷却时间降低两回合。
		在第 5 级时，你的精准射击技能获得 %d%% 物理抗性穿透]])
		:format(bonuses.crit_chance,
			bonuses.crit_power * 100,
			bonuses.resists_pen[DamageType.PHYSICAL])
	end,
}



return _M
