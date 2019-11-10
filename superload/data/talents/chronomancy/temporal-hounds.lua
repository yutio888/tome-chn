local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TEMPORAL_HOUNDS",
	name = "时空猎犬",
	info = function(self, t)
		local incStats = t.incStats(self, t, true)
		local cooldown = self:getTalentCooldown(t)
		local resists = t.getResists(self, t)
		return ([[召唤一条时空猎犬。
		每隔 %d 回合召唤另一条时空猎犬，直至最多 3 条。
		当一条猎犬死去时，你将在 %d 回合内召唤一条新的猎犬。
		你猎犬继承你的伤害加成，有 %d%% 物理和 %d%% 时空抗性，对传送效果免疫。
		猎犬将拥有 %d 力量， %d 敏捷， %d 体质， %d 魔法和 %d 灵巧，基于你的魔法。]])
		:format(cooldown, cooldown, resists/2, math.min(100, resists*2), incStats.str + 1, incStats.dex + 1, incStats.con + 1, incStats.mag + 1, incStats.wil +1, incStats.cun + 1)
	end,
}

registerTalentTranslation{
	id = "T_COMMAND_BLINK",
	name = "闪烁命令",
	info = function(self, t)
		local defense = t.getDefense(self, t)
		return ([[命令你的时空猎犬传送至指定位置。
		如果你指定敌人为目标，猎犬们将视其为目标攻击。
		当你学会该技能后，你的猎犬在传送后获得 %d 闪避和 %d 全抗。
		技能等级 5 时，若猎犬数小于最大召唤数目，使用该技能时将召唤一条新猎犬。
		传送加成受法术强度加成。]]):format(defense, defense, defense/2, defense/2)
	end,
}

registerTalentTranslation{
	id = "T_TEMPORAL_VIGOUR",
	name = "时空活力",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local regen = t.getRegen(self, t)
		local haste = t.getHaste(self, t) * 100
		local immunities = t.getImmunities(self, t) * 100
		return ([[你的猎犬现在在生命值降至 1 以下后还能生存至多 %d 回合，免疫所有伤害但造成的伤害减少 50%% 。
		闪烁命令将能让猎犬每回合回复 %d 生命并增加 %d%% 整体速度，持续 5 回合。生命 1 以下的猎犬将加倍该效果。
		当你学会该技能后，你的猎犬获得 %d%% 震慑致盲混乱定身免疫。
		生命回复受法术强度加成。]]):format(duration, regen, haste, immunities)
	end,
}

registerTalentTranslation{
	id = "T_COMMAND_BREATHE",
	name = "吐息命令",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local stat_damage = t.getDamageStat(self, t)
		local duration =t.getDuration(self, t)
		local affinity = t.getResists(self, t)
		return ([[命令猎犬们使用时光吐息，锥形范围半径 %d 范围内造成 %0.2f 时空伤害并减少目标三项最高属性值 %d 点 %d 回合。
		你免疫自己猎犬的吐息。自己的猎犬免疫其他猎犬的属性降低效果。
		当你学会该技能后，猎犬们获得 %d%% 时空伤害吸收。]]):format(radius, damDesc(self, DamageType.TEMPORAL, damage),  stat_damage, duration, affinity)
	end,
}

return _M
