local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TELEKINETIC_GRASP",
	name = "念力之握",
	info = function(self, t)
		return ([[用精神超能力值灌注一件武器或宝石，使它能够承受你的精神力量。]])
	end,
}

registerTalentTranslation{
	id = "T_BEYOND_THE_FLESH",
	name = "超越肉体",
	info = function(self, t)
		local base = [[允许你用念力来装备一件武器，用你的意念来操纵它，使它能在每回合随机攻击一个近战范围的目标。
		 也可以装备灵晶或者宝石，并获得特殊效果。
		 宝石：每一级材质等级，使全部属性加 3 ，同时部分技能的攻击范围增加 1 。
		 灵晶：每一级材质等级，有 5% 几率将额外 1 半径内一个随机敌人抓取到身边。
		 开启后，使用 60% 意志和灵巧来分别代替力量和敏捷以决定武器的攻击。 ]]

		local o = self:getInven("PSIONIC_FOCUS") and self:getInven("PSIONIC_FOCUS")[1]
		if type(o) == "boolean" then o = nil end
		if not o then return base end

		local atk = 0
		local dam = 0
		local apr = 0
		local crit = 0
		local speed = 1
		local range = 0
		local ammo = self:getInven("QUIVER") and self:getInven("QUIVER")[1]
		if ammo and ammo.archery_ammo ~= o.archery then ammo = nil end
		if o.type == "gem" then
			local ml = o.material_level or 1
			base = base..([[念动宝石增加你 %d 属性。]]):format(ml * 4)
		elseif o.subtype == "mindstar" then
			local ml = o.material_level or 1			
			base = base..([[念动灵晶有 %d%% 几率抓取 %d 半径内的敌人。]]):format((ml + 1) * 5, ml + 2)
			elseif o.archery and ammo then
			self:attr("use_psi_combat", 1)
			range = math.max(math.min(o.combat.range or 6), self:attr("archery_range_override") or 1)
			atk = self:combatAttackRanged(o.combat, ammo.combat)
			dam = self:combatDamage(o.combat, nil, ammo.combat)
			apr = self:combatAPR(ammo.combat) + (o.combat and o.combat.apr or 0)
			crit = self:combatCrit(o.combat)
			speed = self:combatSpeed(o.combat)
			self:attr("use_psi_combat", -1)
			base = base..([[念动武器使用意志和灵巧来分别代替力量和敏捷以决定武器的攻击。 
			战斗属性： 
			范围： %d
			命中： %d
			伤害： %d
			护甲穿透： %d
			暴击率： %0.2f
			速度： %0.2f]]):
			format(range, atk, dam, apr, crit, speed*100)
		else
			self:attr("use_psi_combat", 1)
			atk = self:combatAttack(o.combat)
			dam = self:combatDamage(o.combat)
			apr = self:combatAPR(o.combat)
			crit = self:combatCrit(o.combat)
			speed = self:combatSpeed(o.combat)
			self:attr("use_psi_combat", -1)
			base = base..([[念动武器使用意志和灵巧来分别代替力量和敏捷以决定武器的攻击。 
			战斗属性： 
			命中： %d
			伤害： %d
			护甲穿透： %d
			暴击率： %0.2f
			速度： %0.2f]]):
			format(atk, dam, apr, crit, speed)
		end
		return base
	end,
}


return _M
