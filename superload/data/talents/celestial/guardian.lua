local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHIELD_OF_LIGHT",
	name = "圣光沁盾",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[使你的盾牌充满光系能量，每次受到攻击会消耗 2 点正能量并恢复 %0.2f 生命值。 
		 如果你没有足够的正能量，此效果无法触发。 
		 同时，每回合一次，近战攻击命中时会附加一次盾击，造成 %d%% 光系伤害。
		 受法术强度影响，恢复量有额外加成。]]):
		format(heal, t.getShieldDamage(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_BRANDISH",
	name = "剑盾之怒",
	info = function(self, t)
		local weapondamage = t.getWeaponDamage(self, t)
		local shielddamage = t.getShieldDamage(self, t)
		local lightdamage = t.getLightDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[用你的武器对目标造成 %d%% 伤害，同时盾击目标造成 %d%% 伤害。如果盾牌击中目标，则会产生光系爆炸，对范围内除你以外的所有目标造成 %0.2f 光系范围伤害（半径 %d 码）并照亮受影响区域。 
		 受法术强度影响，光系伤害有额外加成。]]):
		format(100 * weapondamage, 100 * shielddamage, damDesc(self, DamageType.LIGHT, lightdamage), radius)
	end,
}

registerTalentTranslation{
	id = "T_RETRIBUTION",
	name = "惩戒之盾",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local absorb_string = ""
		if self.retribution_absorb and self.retribution_strike then
			absorb_string = ([[#RED#Absorb Remaining: %d]]):format(self.retribution_absorb)
		end
		return ([[吸收你收到的一半伤害。一旦惩戒之盾吸收 %0.2f 伤害值，它会产生光系爆炸，在 %d 码半径范围内造成等同吸收值的伤害并中断技能效果。 
		 受法术强度影响，伤害吸收值有额外加成。
		%s]]):
		format(damage, self:getTalentRange(t), absorb_string)
	end,
}
registerTalentTranslation{
	id = "T_CRUSADE",
	name = "十字军打击",
	info = function(self, t)
		local weapon = t.getWeaponDamage(self, t)*100
		local shield = t.getShieldDamage(self, t)*100
		local cooldown = t.getCooldownReduction(self, t)
		local cleanse = t.getDebuff(self, t)
		return ([[你用武器攻击造成 %d%% 光系伤害，再用盾牌攻击造成 %d%% 光系伤害。
			如果第一次攻击命中，随机 %d 个技能 cd 时间减 1 。
			如果第二次攻击命中，除去你身上至多 %d 个 debuff。]]):
		format(weapon, shield, cooldown, cleanse)
	end,
}

return _M
