local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SAWWHEELS",
	name = "Saw Wheels",
	info = function(self, t)
		return ([[Firmly plant your steamsaws in the ground, using them to propel yourself very quickly (+%d%% movement speed).
		Any foes on either side of your movement get wrecked by the saws, damaging them for %d%% weapon damage and knocking them 3 tiles away from you.
		Attacking or using any talent will break this effect.
		#{italic}#The wheels of death! Amazing!#{normal}#]]):
		format(t.getSpeed(self, t), self:combatTalentWeaponDamage(t, 0.3, 0.9) * 100)
	end,}

registerTalentTranslation{
	id = "T_GRINDING_SHIELD",
	name = "Grinding Shield",
	info = function(self, t)
		local ev, spread = t.getEvasion(self, t)
		local flat = t.getFlatMax(self, t)
		return ([[Spin your saws wildly around you to create a wall of steamy sawteeth.
		All melee damage against you is reduced by %d%%, you have %d%% chance to evade projectiles and you can never take a blow that deals more than %d%% of your max life.
		#{italic}#Split their bones on the saws of death!#{normal}#]])
		:format(ev, ev, flat)
	end,}

-- Core highest damage potential strike
registerTalentTranslation{
	id = "T_PUNISHMENT",
	name = "Punishment",
	info = function(self, t)
		return ([[Slam your saws into your target, dealing 100%% weapon damage + %d%% per physical, magical, or mental effect on them (up to 7 effects).
			Sustains are not effects.
		#{italic}#The Metal Punisher!#{normal}#]]):
		format(t.getBonus(self, t))
	end,}

-- Needs new bonus for Saw Wheels
registerTalentTranslation{
	id = "T_BATTLEFIELD_VETERAN",
	name = "Battlefield Veteran",
	info = function(self, t)
		return ([[You have lived through many battles, and your experience makes you a gritty veteran.
		Saw Wheels steam drain is reduced by %d.
		Grinding Shield lets you live below your normal limits, up to -%d life.
		Punishment has a %d%% chance to have its cooldown reduced by 1 for each effect.
		#{italic}#Domination for all!#{normal}#]]):
		format(math.floor(self:getTalentLevel(t)), t.getLife(self, t), t.getChance(self, t))
	end,}
