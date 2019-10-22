local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ARCANE_EYE",
	name = "奥术之眼",
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local duration = t.getDuration(self, t)
		return ([[召唤 1 个奥术之眼放置于指定地点，持续 %d 回合。 
		此眼睛不会被其他生物看见或攻击，它提供魔法视觉，可看到它周围 %d 码范围的怪物。 
		它不需要灯光去提供能量，且它的视线无法穿墙。 
		召唤奥术之眼不消耗回合。 
		同时只能存在 1 个奥术之眼。 
		在等级 4 时，可以在怪物身上放置奥术之眼，持续时间直到技能结束或怪物死亡。 
		在等级 5 时，它可以在怪物身上放置一个魔法标记并无视隐形和潜行效果。]]):
		format(duration, radius)
	end,
}

registerTalentTranslation{
	id = "T_KEEN_SENSES",
	name = "敏锐直觉",
	info = function(self, t)
		local seeinvisible = t.getSeeInvisible(self, t)
		local seestealth = t.getSeeStealth(self, t)
		local criticalchance = t.getCriticalChance(self, t)
		return ([[你集中精神，通过直觉获取未来的信息。 
		增加侦测隐形等级 +%d
		增加侦测潜行等级 +%d
		增加法术暴击几率 +%d%%
		受法术强度影响，此效果有额外加成。]]):
		format(seeinvisible, seestealth, criticalchance)
	end,
}

registerTalentTranslation{
	id = "T_VISION",
	name = "探测",
	info = function(self, t)
		local radius = t.getRadius(self, t)
		return ([[通过意念探测周围地形，有效范围： %d  码。]]):
		format(radius)
	end,
}

registerTalentTranslation{
	id = "T_PREMONITION",
	name = "预感",
	info = function(self, t)
		local resist = t.getResist(self, t)
		return ([[你的眼前会闪烁未来的景象，让你能够预知对你的攻击。 
		如果攻击是元素类或魔法类的，那么你会创造一个临时性的护盾来减少 %d%% 所有此类攻击伤害，持续 5 回合。 
		此效果每隔 5 回合只能触发一次，且在承受伤害前被激活。 
		受法术强度影响，效果有额外加成。]]):format(resist)
	end,
}


return _M
