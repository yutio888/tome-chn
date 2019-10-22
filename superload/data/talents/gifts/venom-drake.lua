local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ACIDIC_SPRAY",
	name = "酸雾喷射",
	message = "@Source@ 喷出酸液！",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[向你的敌人喷出一团酸雾。 
		目标会受到 %0.2f 点基于精神强度的酸性伤害。 
		受到攻击的敌人有 25 ％几率被缴械 3 回合，因为酸雾将他们的武器给腐蚀了。 
		在等级 5 时，这团酸雾可以穿透一条线上的敌人。 
		每点技能等级增加精神强度 4 点。
		每一点毒龙系技能同时也能增加你的酸性抵抗 1%% 。]]):format(damDesc(self, DamageType.ACID, damage))
	end,
}

registerTalentTranslation{
	id = "T_CORROSIVE_MIST",
	name = "腐蚀酸雾",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local cordur = t.getCorrodeDur(self, t)
		local atk = t.getAtk(self, t)
		local radius = self:getTalentRadius(t)
		return ([[吐出一股浓厚的酸雾，每回合造成 %0.2f 酸性伤害，范围为 %d 码半径，持续 %d 回合。 
		在这团酸雾里的敌人会被腐蚀，持续 %d 回合，降低他们 %d 点命中、护甲和闪避。 
		受精神强度影响，伤害和持续时间有额外加成；受技能等级影响，范围有额外加成。 
		每一点毒龙系技能同时也能增加你的酸性抵抗 1%% 。]]):format(damDesc(self, DamageType.ACID, damage), radius, duration, cordur, atk)
	end,
}

registerTalentTranslation{
	id = "T_DISSOLVE",
	name = "腐蚀连击",
	info = function(self, t)
		return ([[你对敌人挥出暴风般的酸性攻击。你对敌人造成四次酸性伤害。每击造成 %d%% 点伤害。 
		每拥有 2 个天赋等级，你的其中一次攻击就会成附带致盲的酸性攻击，若击中则有 25%% 几率致盲目标。
		每一点毒龙系技能同时也能增加你的酸性抵抗 1%% 。
		如果你装备了盾牌，这一技能也会用你的盾牌攻击。]]):format(100 * self:combatTalentWeaponDamage(t, 0.1, 0.6))
	end,
}

registerTalentTranslation{
	id = "T_CORROSIVE_BREATH",
	name = "腐蚀吐息",
	message = "@Source@ 呼出酸液！",
	info = function(self, t)
		return ([[向前方 %d 码范围施放一个锥形酸雾吐息，范围内所有目标受到 %0.2f 酸性伤害。
		敌人还会被缴械 3 回合。 
		受力量影响，伤害有额外加成。技能暴击率基于精神暴击值计算。缴械强度基于你的精神强度。
		每一点毒龙系技能同时也能增加你的酸性抵抗 1%% 。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.ACID, t.getDamage(self, t)))
	end,
}


return _M
