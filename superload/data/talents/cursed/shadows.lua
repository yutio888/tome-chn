local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHADOW_FADE",
	name = "隐形",
	info = function(self, t)
		return ([[你从视线中消失并无敌，直到下一回合开始。]])
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_PHASE_DOOR",
	name = "相位之门",
	info = function(self, t)
		return ([[小范围内将你传送一段距离。]])
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_BLINDSIDE",
	name = "灵异打击",
	info = function(self, t)
		local multiplier = self:combatTalentWeaponDamage(t, 0.9, 1.9)
		return ([[你以难以置信的速度闪现至附近 %d 码的一个目标身边并造成 %d%% 伤害。]]):format(self:getTalentRange(t), multiplier * 100)
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_LIGHTNING",
	name = "暗影闪电",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[用闪电打击目标造成 %0.2f 到 %0.2f 伤害 (平均 %0.2f 伤害)。
		 受魔法影响，伤害有额外加成。]]):
		 format(damDesc(self, DamageType.LIGHTNING, damage / 3),
		 damDesc(self, DamageType.LIGHTNING, damage),
		 damDesc(self, DamageType.LIGHTNING, (damage + damage / 3) / 2))
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_FLAMES",
	name = "暗影之火",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[用火焰灼烧你的目标造成 %0.2f 伤害。 
		 受魔法影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.FIREBURN, damage))
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_REFORM",
	name = "重组",
	info = function(self, t)
		local chance = t.getChance(self, t)
		return ([[当阴影受到伤害或被杀死，有 %d%% 几率重组并免受伤害。]]):format(chance)
	end,
}

registerTalentTranslation{
	id = "T_CALL_SHADOWS",
	name = "召唤阴影",
	info = function(self, t)
		local maxShadows = t.getMaxShadows(self, t)
		local level = t.getLevel(self, t)
		local healLevel = t.getHealLevel(self, t)
		local blindsideLevel = t.getBlindsideLevel(self, t)
		local avoid_master_damage = t.getAvoidMasterDamage(self, t)
		return ([[当此技能激活时，你可以召唤 %d 个等级 %d 的阴影帮助你战斗。每个阴影需消耗 6 点仇恨值召唤。 
		 阴影是脆弱的战士，它们能够：使用奥术重组治疗自己（等级 %d ），使用灵异打击突袭目标（等级 %d ），使用相位之门进行传送。
		 阴影无视 %d%% 主人造成的伤害。]]):format(maxShadows, level, healLevel, blindsideLevel, avoid_master_damage)
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_WARRIORS",
	name = "阴影战士",
	info = function(self, t)
		local combatAtk = t.getCombatAtk(self, t)
		local incDamage = t.getIncDamage(self, t)
		local dominateChance = t.getDominateChance(self, t)
		local dominateLevel = t.getDominateLevel(self, t)
		local fadeCooldown = math.max(3, 8 - self:getTalentLevelRaw(t))
		return ([[将仇恨注入你的阴影，强化他们的攻击。他们获得 %d%% 额外命中和 %d%% 额外伤害加成。 
		 他们疯狂的攻击可以令他们控制对手，提高控制目标的所有伤害 4 回合（等级 %d ， %d%% 几率 1 码范围）。 
		 它们同时拥有消隐的能力，免疫所有伤害直到下一回合开始（ %d 回合冷却时间）。]]):format(combatAtk, incDamage, dominateLevel, dominateChance, fadeCooldown)
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_MAGES",
	name = "阴影法师",
	info = function(self, t)
		local closeAttackSpellChance = t.getCloseAttackSpellChance(self, t)
		local farAttackSpellChance = t.getFarAttackSpellChance(self, t)
		local spellpowerChange = t.getSpellpowerChange(self, t)
		local lightningLevel = t.getLightningLevel(self, t)
		local flamesLevel = t.getFlamesLevel(self, t)
		return ([[灌输魔力给你的阴影使它们学会可怕的法术。你的阴影获得 %d 点法术强度加成。 
		 你的阴影可以用闪电术攻击附近的目标（等级 %d ， %d%% 几率 1 码范围）。 
		 等级 3 时你的阴影可以远距离使用火焰术灼烧你的敌人（等级 %d ， %d%% 几率 2 到 6 码范围）。 
		 等级 5 时你的阴影在被击倒时有一定几率重组并重新加入战斗（ 50%% 几率）。]]):format(spellpowerChange, lightningLevel, closeAttackSpellChance, flamesLevel, farAttackSpellChance)
	end,
}

registerTalentTranslation{
	id = "T_FOCUS_SHADOWS",
	name = "聚集阴影",
	info = function(self, t)
		local defenseDuration = t.getDefenseDuration(self, t)
		local blindsideChance = t.getBlindsideChance(self, t)
		return ([[将你的阴影聚集至单一目标。如果目标为友善则保护目标 %d 回合。如目标为敌对则有 %d%% 几率使用灵异打击攻击目标。 
		 如果你的阴影数目少于最大值，将在聚集前召唤出来。
		 该技能不消耗任何能量。]]):format(defenseDuration, blindsideChance)
	end,
}




return _M
