local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_PSIBLADES",
	name = "心灵利刃",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[将你的精神能量灌入你所装备的灵晶中，使其生成心灵利刃。 
		灵晶所产生的心灵利刃会进行 %0.2f 伤害修正加成（从属性中获得的伤害值），增加 %0.2f 护甲穿透。
		心灵利刃将使灵晶附加的精神强度、意志和灵巧变为 %0.2f 倍。 
		同时，还会在使用灵晶时增加 %d%% 武器伤害与 30 点物理强度。]]):
		format(t.getStatmult(self, t), t.getAPRmult(self, t), t.getPowermult(self, t), 100 * inc) --I5
		end,
}

registerTalentTranslation{
	id = "T_THORN_GRAB",
	name = "荆棘之握",
	info = function(self, t)
		return ([[你通过心灵利刃接触你的目标，将自然的怒火带给你的敌人。 
		荆棘藤蔓会抓取目标，使其减速 %d%% ，并且每回合造成 %0.2f 自然伤害，持续 10 回合。 
		受精神强度和灵晶强度影响，伤害有额外加成（需要 2 只灵晶，加成比例 %0.2f ）。]]):
		format(100*t.speedPenalty(self,t), damDesc(self, DamageType.NATURE, self:combatTalentMindDamage(t, 15, 250) / 10 * get_mindstar_power_mult(self)), get_mindstar_power_mult(self))
	end,
}

registerTalentTranslation{
	id = "T_LEAVES_TIDE",
	name = "叶刃风暴",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local c = t.getChance(self, t)
		return ([[向四周粉碎利刃，在你周围的 3 码半径范围内形成一股叶刃风暴，持续 7 回合。 
		被叶刃击中的目标会开始流血，每回合受到 %0.2f 点伤害（可叠加）。 
		所有被叶刃覆盖的同伴，获得 %d%% 概率完全免疫任何伤害。 
		受精神强度和灵晶强度影响，伤害和免疫几率有额外加成（需要 2 只灵晶，加成比例 %2.f ）。]]):
		format(dam, c, get_mindstar_power_mult(self))
	end,
}

registerTalentTranslation{
	id = "T_NATURE_S_EQUILIBRIUM",
	name = "自然均衡",
	info = function(self, t)
		return ([[你用主手心灵利刃攻击敌人造成 %d%% 武器伤害，用副手心灵利刃传导敌人所受的伤害能量来治疗友方单位。 
		治疗最大值为 %d 。受到治疗效果的目标失衡值会降低治疗量的 10%% 。 
		受精神强度和灵晶强度影响，最大治疗值有额外加成（需要 2 只灵晶，加成比例 %2.f ）。]]):
		format(self:combatTalentWeaponDamage(t, 2.5, 4) * 100, t.getMaxDamage(self, t), get_mindstar_power_mult(self))
	end,
}


return _M
