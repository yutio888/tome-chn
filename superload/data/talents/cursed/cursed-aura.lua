local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_DEFILING_TOUCH",
	name = "诅咒之触",
	info = function(self, t)
		return ([[
		你的诅咒之触弥漫于你附近的所有东西，给予找到的每个物品 1 个随机诅咒。当你穿戴 1 件诅咒装备时，你增加那种诅咒的效果。最初诅咒是有害的，但是当装备多件物品并且学到黑暗礼物时，诅咒会变的非常有益。 
		等级 1 ——诅咒武器
		等级 2 ——诅咒盔甲和斗篷
		等级 3 ——诅咒盾牌和头盔
		等级 4 ——诅咒手套、靴子和腰带
		等级 6 ——诅咒戒指
		等级 7 ——诅咒项链
		等级 8 ——诅咒灯具
		等级 9 ——诅咒工具 / 图腾 / 项圈 /魔棒
		等级 10 ——诅咒弹药
		在等级 5 时，你可以激活此技能形成 1 个光环，增加 2 级你选择的诅咒效果( 当前 %s)。 
		同时，技能等级在 5 以上时会减轻诅咒的负面效果（现在减少 %d%% ） ]]):
		format(t.getCursedAuraName(self, t), (1-t.cursePenalty(self, t))*100)
	end,
}

registerTalentTranslation{
	id = "T_DARK_GIFTS",
	name = "黑暗礼物",
	info = function(self, t)
		local level = math.min(4, self:getTalentLevelRaw(t))
		local xs = t.curseBonusLevel(self,t)
		return ([[你的诅咒带来黑暗的礼物。解锁所有诅咒第 %d 层效果，并允许你在诅咒达到该等级时获得此效果。 
		 在等级 5 时，因诅咒带来的幸运惩罚降到 1 。
		 等级 5 以上时增加诅咒效果（当前增加 %0.1f ）]]):
		format(level, xs)
	end,
}

registerTalentTranslation{
	id = "T_RUINED_EARTH",
	name = "毁灭大地",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local duration = t.getDuration(self, t)
		local incDamage = t.getIncDamage(self, t)

		return ([[诅咒你周围 %d 码半径范围的大地，持续 %d 回合。 
		 任何站在大地上的目标将会被虚弱，减少它们 %d%% 的伤害。]]):format(range, duration, incDamage)
	end,
}

registerTalentTranslation{
	id = "T_CHOOSE_CURSED_SENTRY",
	name = "选择诅咒守卫",
	info = function(self, t) 
        return [[选择你的诅咒护卫。]] 
    end,
}
registerTalentTranslation{
	id = "T_CURSED_SENTRY",
	name = "诅咒护卫",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local attackSpeed = t.getAttackSpeed(self, t)*100

		return ([[将部分活性诅咒能量灌输到你背包里的 1 把武器上，使其悬浮在空中。这个类似于诅咒护卫的武器会自动攻击附近的敌人，持续 %d 回合。 
		  攻击速度： %d%% 。
		  当你第一次选择武器后，只要武器仍旧在背包里，就会被记住。使用“选择诅咒护卫”技能来切换武器。
		  技能等级 3 时，你能将具有高级词缀的武器化为守卫。
		  技能等级 5 时，你能将神器化为守卫。
		  ]]):format(duration, attackSpeed)
	end,
}



return _M
