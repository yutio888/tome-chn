local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_LUNAR_ORB",
	name = "Lunar Orb",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local restore = t.getNegative(self, t)
		return ([[Fires out a bolt of cosmic energy in the target direction. The projectile continues until it hits a wall or the edge of the map, dealing %0.2f dark damage to enemies hit and restoring %d negative energy. The negative energy gained is reduced by 25%% per enemy hit, restoring a maximum of %d. Enemies hit will become aware of you.]]):
		format(damDesc(self, DamageType.DARKNESS, damage), restore, restore * 4)
	end,}

registerTalentTranslation{
	id = "T_ASTRAL_PATH",
	name = "Astral Path",
	info = function(self, t)
		return ([[Fire an orb of negative energy towards a spot within range %d.
		When the orb reaches its destination, it will teleport you to its location.
		The speed of the projectile (%d%%) increases with your movement speed]]):format(t.range(self, t), t.proj_speed(self, t)*100)
	end,}

registerTalentTranslation{
	id = "T_GALACTIC_PULSE",
	name = "Galactic Pulse",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Sends out a slow-moving spiral of cosmic energy towards a target location within range 8.
		As the cosmic energy moves, it pulls in targets adjacent to it, dealing %0.2f darkness damage and granting you 1 negative energy per hit.]]):
		format(damDesc(self, DamageType.DARKNESS, damage))
	end,}

registerTalentTranslation{
	id = "T_SUPERNOVA",
	name = "Supernova",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local pin = t.getPinDuration(self, t)
		return ([[Expend all of your negative energy to create a massive burst of dark energy (radius %d) at a target location within range %d.
		This deals %0.2f darkness damage and pins targets hit for %d turns.
		The damage and pin chance increase with your spellpower, and the damage, radius and pin duration all increase with negative energy and talent level]]):
		format(radius, self:getTalentRange(t), damDesc(self, DamageType.DARKNESS, damage), pin)
	end,}
return _M