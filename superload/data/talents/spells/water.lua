local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ICE_SHARDS",
	name = "寒冰箭",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[朝指定地点所有目标射出寒冰箭。每根寒冰箭 %s 并造成 %0.2f 冰系伤害，有25%%几率使其冻结，未冻结时将使其湿润。
		此法术不会伤害施法者。 
		如果目标处于湿润状态，伤害增加 30%% ，同时冰冻率上升至 50%% 。
		受法术强度影响，伤害有额外加成。]]):
		format(necroEssenceDead(self, true) and " 影响路径上所有敌人 " or "缓慢移动", damDesc(self, DamageType.COLD, damage))
	end,
}

registerTalentTranslation{
	id = "T_GLACIAL_VAPOUR",
	name = "寒霜冰雾",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[在 3 码半径范围内升起一片寒冷的冰雾，每回合造成 %0.2f 冰冷伤害，持续 %d 回合。 
		处于湿润状态的生物承受额外 30%% 伤害，并有 15%% 几率被冻结。
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.COLD, damage), duration)
	end,
}

registerTalentTranslation{
	id = "T_TIDAL_WAVE",
	name = "潮汐",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[以施法者为中心，在 1 码半径范围内生成一股巨浪，每回合增加 1 码半径范围，最大 %d 码。 
		对目标造成 %0.2f 冰冷伤害和 %0.2f 物理伤害，同时击退目标，持续 %d 回合。 
		所有受影响的生物进入湿润状态，震慑抗性减半。
		受法术强度影响，伤害和持续时间有额外加成。]]):
		format(radius, damDesc(self, DamageType.COLD, damage/2), damDesc(self, DamageType.PHYSICAL, damage/2), duration)
	end,
}

registerTalentTranslation{
	id = "T_SHIVGOROTH_FORM",
	name = "寒冰之体",
	info = function(self, t)
		local power = t.getPower(self, t)
		local dur = t.getDuration(self, t)
		
		local t_is = self:getTalentFromId(self.T_ICE_STORM)
		local icestorm = self:getTalentFullDescription(t_is, self:getTalentLevelRaw(t))
		return ([[你吸收周围的寒冰围绕你，将自己转变为纯粹的冰元素——西弗格罗斯，持续 %d 回合。 
		转化成元素后，你不需要呼吸并获得等级 %d 的冰雪风暴，获得 %d%% 震慑和流血抵抗， %d%% 寒冷伤害抗性。所有寒冷伤害可对你产生治疗，治疗量基于伤害值的 %d%% 。 
		受法术强度影响，效果有额外加成。
		#AQUAMARINE#冰雪风暴:#LAST#
		%s]]):
		format(dur, self:getTalentLevelRaw(t), power * 100, power * 100 / 2, 50 + power * 100, tostring(icestorm or ""))
	end,
}

registerTalentTranslation{
	id = "T_ICE_STORM",
	name = "冰雪风暴",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[召唤一股激烈的暴风雪围绕着施法者，在 3 码范围内每回合对目标造成 %0.2f 冰冷伤害，持续 %d 回合。 
		它有 25%% 概率冰冻受影响目标。 
		如果目标处于湿润状态，伤害增加 30%% ，同时冻结率上升至 50%% 。
		受法术强度影响，伤害和持续时间有额外加成。]]):format(damDesc(self, DamageType.COLD, damage), duration)
	end,
}


return _M
