local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DISPERSE_MAGIC",
	name = "驱散",
	info = function(self, t)
		local count = t.getRemoveCount(self, t)
		return ([[驱散目标身上的 %d 种魔法效果（敌方单位的增益状态和友方单位的负面状态）。 
		 在等级 3 时可以选择目标。]]):
		format(count)
	end,
}

registerTalentTranslation{
	id = "T_SPELLCRAFT",
	name = "法术亲和",
	info = function(self, t)
		local chance = t.getChance(self, t)
		return ([[你学会精确调节你的攻击技能。 
		 你试图控制自己的攻击性魔法，尝试在攻击范围中留出空隙，避免伤及自身， %d%% 成功概率。 
		 如果你的法术强度等级超过目标法术豁免等级，你的攻击法术将会对目标产生法术冲击。此技能将赋予你提高 %d 法术强度的加成用于判定目标的法术豁免。被法术冲击目标暂时减少 20%% 伤害抵抗。]]):
		format(chance, self:combatTalentSpellDamage(t, 10, 320) / 4)
	end,
}

registerTalentTranslation{
	id = "T_QUICKEN_SPELLS",
	name = "快速施法",
	info = function(self, t)
		local cooldownred = t.getCooldownReduction(self, t)
		return ([[减少 %d%% 所有法术冷却时间。]]):
		format(cooldownred * 100)
	end,
}

registerTalentTranslation{
	id = "T_METAFLOW",
	name = "奥术流动",
	info = function(self, t)
		local talentcount = t.getTalentCount(self, t)
		local maxlevel = t.getMaxLevel(self, t)
		return ([[ 你对奥术的精通使你能重置法术的冷却时间。 
		 重置至多 %d 个法术的冷却，对技能层次 %d 或更低的技能有效。]]):
		format(talentcount, maxlevel)
	end,
}


return _M
