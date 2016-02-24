local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_SOLAR_ORB",
	name = "Solar Orb",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local cooldownred = t.getCooldownReduction(self, t)
		return ([[Fire out an orb of light that deals %0.2f light damage and then returns, dealing the same amount of damage again and reducing the cooldown by half (%d) when it reaches you. The damage will increase with your spellpower. The ball will travel at most %d distance to return to you.]]):
		format(damDesc(self, DamageType.LIGHT, damage), cooldownred, self:getTalentRange(t) * 4)
	end,}

registerTalentTranslation{
	id = "T_SOLAR_WIND",
	name = "Solar Wind",
	info = function(self, t)
		local speed = t.getSpeed(self, t)
		local slow = t.getSlowFromSpeed(speed)
		return ([[While sustained, this ability speeds up outgoing projectiles by %d%% while slowing incoming projectiles by %d%%. The increase and decrease improve with your spellpower]]):
		format(speed, slow)
	end,}

registerTalentTranslation{
	id = "T_LUCENT_WRATH",
	name = "Lucent Wrath",
	info = function(self, t)
		local delay = t.getDelay(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		return ([[After %d turns, the target area in (radius %d) is blasted with a beam of light, dealing %0.2f damage and lighting the area]]):
		format(delay, radius, damDesc(self, DamageType.LIGHT, damage))
		
	end,}

registerTalentTranslation{
	id = "T_LIGHTSPEED",
	name = "Lightspeed",
	info = function(self, t)
		local turn = t.getTurn(self, t)
		return ([[Instantly gain %d%% percent of a turn.]]):
		format(turn * 100)
	end,}


