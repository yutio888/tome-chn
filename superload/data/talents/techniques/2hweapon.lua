local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DEATH_DANCE",
	name = "死亡之舞",
	info = function(self, t)
		return ([[原地旋转，伸展你的武器，伤害你周围所有的目标，造成 %d%% 武器伤害。]]):format(100 * self:combatTalentWeaponDamage(t, 1.4, 2.1))
	end,
}

registerTalentTranslation{
	id = "T_BERSERKER",
	name = "狂暴",
	info = function(self, t)
		return ([[进入狂暴的战斗状态，以减少 10 点闪避和 10 点护甲的代价增加 %d 点命中和 %d 点物理强度。 
		开启狂暴时你无人能挡，增加 %d%% 震慑和定身抵抗。 
		受敏捷影响，命中有额外加成； 
		受力量影响，物理强度有额外加成。]]):
		format( t.getAtk(self, t), t.getDam(self, t), t.getImmune(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_WARSHOUT",
	name = "战争怒吼",
	message = "@Source@使用了战争怒吼",
	info = function(self, t)
		return ([[在你的正前方大吼形成 %d 码半径的扇形战争怒吼。任何在其中的目标会被混乱（强度 %d) %d 回合。]]):
		format(self:getTalentRadius(t),t.getConfusion(self, t), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DEATH_BLOW",
	name = "致命打击",
	info = function(self, t)
		return ([[试图施展一次致命打击，造成 %d%% 武器伤害，本次攻击自动变成暴击。 
		如果打击后目标生命值低于 20%% 则有可能直接杀死。 
		在等级 4 时会消耗剩余的耐力值的一半并增加 100%% 所消耗耐力值的伤害。 
		受物理强度影响，目标即死的概率有额外加成。]]):format(100 * self:combatTalentWeaponDamage(t, 0.8, 1.3))
	end,
}

registerTalentTranslation{
	id = "T_STUNNING_BLOW",
	name = "震慑打击",
	info = function(self, t)
		return ([[用你的武器攻击目标并造成 %d%% 伤害。如果此次攻击命中，则目标会震慑 %d 回合。 
		受物理强度影响，震慑概率有额外加成。]])
		:format(100 * self:combatTalentWeaponDamage(t, 1, 1.5), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SUNDER_ARMOUR",
	name = "破甲",
	info = function(self, t)
		return ([[用你的武器攻击目标并造成 %d%% 伤害。如果此次攻击命中，则目标护甲和豁免会减少 %d 持续 %d 回合。 
		同时，如果目标被临时伤害护盾保护，有 %d%% 几率使之破碎。
		受物理强度影响，护甲减值有额外增加。]])
		:format(100 * self:combatTalentWeaponDamage(t, 1, 1.5),t.getArmorReduc(self, t), t.getDuration(self, t), t.getShatter(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SUNDER_ARMS",
	name = "破刃",
	info = function(self, t)
		return ([[用你的武器攻击目标并造成 %d%% 伤害。如果此次攻击命中，则目标命中会减少 %d 持续 %d 回合。 
		受物理强度影响，命中减值有额外加成。]])
		:format(
			100 * self:combatTalentWeaponDamage(t, 1, 1.5), 3 * self:getTalentLevel(t), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BLOOD_FRENZY",
	name = "血之狂暴",
	info = function(self, t)
		return ([[进入血之狂暴状态，快速消耗体力（ -4 体力 / 回合）。每次你在血之狂暴状态下杀死一个敌人，你可以获得 %d 物理强度增益。 
		每回合增益减 2 。]]):
		format(t.bonuspower(self,t))
	end,
}


return _M
