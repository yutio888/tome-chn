local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WARSHOUT_BERSERKER",
	name = "战争怒吼",
	message = "@Source@ 使出战争怒吼",
	info = function(self, t)
		return ([[在你的正前方大吼形成 %d 码半径的扇形战争怒吼。任何在其中的目标会被混乱 %d 回合。]]):
		format(self:getTalentRadius(t), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BERSERKER_RAGE",
	name = "狂战之怒",
	info = function(self, t)
		return ([[进入狂暴的战斗状态，增加 %d 点命中和 %d 点物理强度，增加 %d%% 震慑和定身抵抗。
		同时狂暴的力量会支配你的身体，每回合损失 2%% 生命。同时，你每失去 1%% 生命，增加 0.5%% 暴击率。
		该技能只在视野内有敌人时生效。
		受敏捷影响，命中有额外加成； 
		受力量影响，物理强度有额外加成。]]):
		format( t.getAtk(self, t), t.getDam(self, t), t.getImmune(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_SHATTERING_BLOW",
	name = "破碎震击",
	info = function(self, t)
		return ([[用你的武器攻击目标并造成 %d%% 伤害。如果此次攻击命中，则目标护甲和豁免会减少 %d 持续 %d 回合。 
		同时，如果目标被临时伤害护盾保护，有 %d%% 几率使之破碎。
		受物理强度影响，护甲减值有额外增加。]])
		:format(100 * self:combatTalentWeaponDamage(t, 0.8, 1.5), t.getArmorReduc(self, t), t.getDuration(self, t), t.getShatter(self, t))
	end,
}

registerTalentTranslation{
	id = "T_RELENTLESS_FURY",
	name = "无尽愤怒",
	info = function(self, t)
		return ([[激发你内在的力量，持续 %d 回合。
		每回合恢复 %d 体力，同时增加 %d%% 移动速度和攻击速度。
		只能在体力少于 30%% 时使用。
		体力回复受体质加成。]]):
		format(t.getDur(self, t), t.getStamina(self, t), t.getSpeed(self, t))
	end,
}


return _M
