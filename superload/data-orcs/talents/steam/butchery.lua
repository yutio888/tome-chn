local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STEAMSAW_MASTERY",
	name = "链锯掌握",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[使用链锯时，提高武器伤害 %d%% 。]])
		:format(inc * 100)
	end,}

registerTalentTranslation{
	id = "T_OVERHEAT_SAWS",
	name = "过热链锯",
	info = function(self, t)
		return ([[用蒸汽包裹链锯，对近战攻击命中的目标在 3 回合内造成 %0.2f 点火焰伤害（可以叠加）。
		#{italic}#滚烫的蒸汽，死吧！#{normal}#]])
		:format(damDesc(self, DamageType.FIRE, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TEMPEST_OF_METAL",
	name = "金属狂怒",
	info = function(self, t)
		return ([[持续挥舞你的链锯，每次你攻击时对周围敌人造成 %d%% 武器伤害。
		你狂乱的动作使你很难被命中， %d%% 几率无视伤害。
		伤害无效概率随蒸汽强度提高。
		#{italic}#感受金属之怒吧！！#{normal}#]])
		:format(30, t.getEvasion(self, t))
	end,}

registerTalentTranslation{
	id = "T_OVERCHARGE_SAWS",
	name = "链锯过载",
	info = function(self, t)
		return ([[链锯引擎临时进入过载模式，增加 %d%% 的链锯相关技能有效等级 , 持续 %d 回合。
		#{italic}#无尽地痛苦#{normal}#]])
		:format(t.getPower(self, t), t.getDur(self, t))
	end,}
return _M