local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TELEKINETIC_SMASH",
	name = "灵能冲击",
	info = function(self, t)
		return ([[凝集你的意念，用主手武器和念动武器狂莽地砸击你的目标，造成 %d%% 武器伤害。
		 如果你的主手武器命中，将震慑目标 %d 回合。
		 此次攻击根据意志和灵巧来判定伤害和命中，取代力量和敏捷。
		 此次攻击中任何激活光环的伤害附加将会沿用到武器上。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.9, 1.5), t.duration(self,t))
	end,
}

registerTalentTranslation{
	id = "T_AUGMENTATION",
	name = "心灵强化",
	info = function(self, t)
		local inc = t.getMult(self, t)
		local str_power = inc*self:getWil()
		local dex_power = inc*self:getCun()
		return ([[当开启时，你为了你的血肉之躯精准地灌布精神之力。分别增加意志和灵巧的 %d%% 至力量和敏捷。
		力量增加 %d 点
		敏捷增加 %d 点]]):
		format(inc*100, str_power, dex_power)
	end,
}

registerTalentTranslation{
	id = "T_WARDING_WEAPON",
	name = "武器格挡",
	info = function(self, t)
		return ([[用意念进行防御。
		 下一个回合，你的念动武器会完全格挡对你的第一次近战攻击，并反击攻击者造成 %d%% 武器伤害。
		 技能等级 3 时你还能缴械攻击者 3 回合。
		 技能等级 5 时每回合你有 %d%% 几率被动格挡一次近战攻击，并消耗 1 5 点超能力值。几率受灵巧加成。 
		 这个技能需要一把主手武器和一把念动武器。]]):
		format(100 * t.getWeaponDamage(self, t), t.getChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_IMPALE",
	name = "灵能突刺",
	info = function(self, t)
		return ([[将你的意志灌入你的念动武器，使它猛力推进并刺穿你的目标并恶毒的绞开它的身体。
		 这次攻击将造成 %d%% 武器伤害，并使目标流血 4 回合，累计造成 %0.1f 物理伤害。
		 在 3 级时，武器将势不可挡地突进，有 %d%% 几率击碎目标身上一个临时性的伤害护盾（如果存在）。
		 判定此次攻击的伤害和命中时，意志和灵巧讲替代力量和敏捷。
		 流血伤害随精神强度增加。]]):
		format(100 * t.getWeaponDamage(self, t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self,t)), t.getShatter(self, t))
	end,
}


return _M
