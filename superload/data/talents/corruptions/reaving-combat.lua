local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CORRUPTED_STRENGTH",
	name = "堕落力量",
	info = function(self, t)
		return ([[允许你双持单手武器并使副手武器伤害增加至 %d%% 。 
		同时每释放 1 个法术（消耗 1 回合）会给予近战范围内的 1 个随机目标一次附加攻击，造成 %d%% 枯萎伤害。]]):
		format(100*t.getoffmult(self,t), 100 * self:combatTalentWeaponDamage(t, 0.2, 0.7))
		end,
}

registerTalentTranslation{
	id = "T_BLOODLUST",
	name = "嗜血杀戮",
	info = function(self, t)
		local SPbonus = t.getSpellpower(self, t)
		return ([[每当你使用近战武器击中一个目标，你进入嗜血状态，增加你的法术强度  %0.1f  。
		这一效果最多叠加  10  层，共获得  %d  法术强度。
		嗜血状态持续  3  回合。]]):
		format(SPbonus, SPbonus*10)
	end,
}

registerTalentTranslation{
	id = "T_CARRIER",
	name = "携带者",
	info = function(self, t)
		return ([[你增加 %d%% 疾病抵抗并有 %d%% 概率在近战时散播你目标身上现有的疾病。]]):
		format(t.getDiseaseImmune(self, t)*100, t.getDiseaseSpread(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ACID_BLOOD",
	name = "酸性血液",
	info = function(self, t)
		return ([[你的血液变成酸性混合物。当你受伤害时，攻击者会受到酸性溅射。 
		每回合溅射会造成 %0.2f 酸性伤害，持续 5 回合。 
		同时减少攻击者 %d 点命中。 
		在等级 3 时，酸性溅射会减少目标 %d 点护甲持续 5 回合。 
		受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.ACID, self:combatTalentSpellDamage(t, 5, 30)), self:combatTalentSpellDamage(t, 15, 35), self:combatTalentSpellDamage(t, 15, 40))
	end,
}



return _M
