local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_EARTHEN_MISSILES",
	name = "岩石飞弹",
	info = function(self, t)
		local count = 2
		if self:getTalentLevel(t) >= 5 then
			count = count + 1
		end
		local damage = t.getDamage(self, t)
		return ([[释放出 %d 个岩石飞弹射向任意射程内的目标。每个飞弹造成 %0.2f 物理伤害和每回合 %0.2f 流血伤害，持续 5 回合。 
		 在等级 5 时，你可以额外释放一个飞弹。 
		 受法术强度影响，伤害有额外加成。]]):format(count,damDesc(self, DamageType.PHYSICAL, damage/2), damDesc(self, DamageType.PHYSICAL, damage/12))
	end,
}

registerTalentTranslation{
	id = "T_BODY_OF_STONE",
	name = "岩石身躯",
	info = function(self, t)
		local fireres = t.getFireRes(self, t)
		local lightningres = t.getLightningRes(self, t)
		local acidres = t.getAcidRes(self, t)
		local cooldownred = t.getCooldownReduction(self, t)
		local stunres = t.getStunRes(self, t)
		return ([[你将自己扎根于土壤并使你的肉体融入石头。 
		 当此技能被激活时你不能移动并且任何移动会打断此技能效果。 
		 当此技能激活时，受你的石化形态和土壤相关影响，会产生以下效果： 
		* 减少岩石飞弹、粉碎钻击、地震和山崩地裂冷却时间回合数： %d%%
		* 获得 %d%% 火焰抵抗， %d%% 闪电抵抗， %d%% 酸性抵抗和 %d%% 震慑抵抗。 
		 受法术强度影响，抵抗按比例加成。]])
		:format(cooldownred, fireres, lightningres, acidres, stunres*100)
	end,
}

registerTalentTranslation{
	id = "T_EARTHQUAKE",
	name = "地震",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		return ([[引起一波强烈的地震，每回合造成 %0.2f 物理伤害（ %d 码半径范围），持续 %d 回合。有概率震慑此技能所影响到的怪物。 
		 受法术强度影响，伤害有额外加成。]]):
		format(damDesc(self, DamageType.PHYSICAL, damage), radius, duration)
	end,
}

registerTalentTranslation{
	id = "T_CRYSTALLINE_FOCUS",
	name = "水晶力场",
	info = function(self, t)
		local damageinc = t.getPhysicalDamageIncrease(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		local saves = t.getSaves(self, t)
		return ([[你专注于维持水晶力场，增加你 %0.1f%% 所有物理伤害并忽略目标 %d%% 的物理伤害抵抗。 
		 同时增加你 %d 点物理和魔法豁免。]])
		:format(damageinc, ressistpen, saves)
	end,
}


return _M
