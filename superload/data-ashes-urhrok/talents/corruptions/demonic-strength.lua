local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DISMEMBER",
	name = "肢解",
	info = function(self, t)
	return ([[当近战攻击暴击时，致残你的目标，降低 %d%% 移动速度和 %d 命中，持续 %d 回合。
	同时，增加 %d%% 近战暴击率。]]):format(t.getSlow(self, t), t.getAcc(self, t), t.getDuration(self, t), t.statBonus(self, t))
	end,
}


registerTalentTranslation{
	id = "T_SURGE_OF_POWER",
	name = "力量之潮",
	info = function(self, t)
	return ([[你使用体内蕴藏的活力强化自己的身体，恢复 %d 点体力值和 %d%% 点生命值。
	同时让你在 -%d 生命时才会死亡，此效果持续 8 回合。
	恢复值受法术强度加成。
	法术暴击也会增加这一技能恢复的体力值。]]):
	format( t.stamValue(self, t), t.getHeal(self, t), t.getPower(self, t))
	end,
}


registerTalentTranslation{
	id = "T_DEMONIC_BLOOD",
	name = "恶魔之血",
	info = function(self, t)
	return ([[你体内涌动着恶魔之血，增加 %d 点法术强度和 %d 点活力上限。
	同时获得相当于当前活力 %d%% 的全伤害加成（当前 %d%% ）。]]):
	format(t.statBonus(self, t),t.vimBonus(self, t),(t.atkBonus(self, t)),(t.atkBonus(self, t)/100)*self:getVim())
	end,
}


registerTalentTranslation{
	id = "T_ABYSSAL_SHIELD",
	name = "深渊护盾",
	info = function(self, t)
	return ([[深渊气息围绕着你，增加 %d 点护甲，增加 %0.2f 点火焰、 %0.2f 点枯萎近战反击伤害。
	同时你的活力会增强你的防御，减少相当于当前活力 %d%% 的伤害（目前为 %d 点），但不会减少超过原伤害的一半。此效果会消耗等同于 5%% 减少伤害值的活力。
	伤害值受法术强度加成。]]):
		format(	t.statBonus(self, t),t.getDamage(self,t),t.getDamage(self,t),t.defBonus(self, t),(t.defBonus(self, t)/100)*self:getVim())
	end,
}


return _M
