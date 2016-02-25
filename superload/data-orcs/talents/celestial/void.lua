local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_NEBULA_SPEAR",
	name = "Nebula Spear",
	info = function(self, t)
		local damage = damDesc(self, DamageType.DARKNESS, t.getDamage(self, t))
		local radius = self:getTalentRadius(t)
		return ([[Fire out a spear of cosmic energies. If it hits an enemy it deals %0.2f damage, otherwise it explodes in a thin cone of radius %d at the end of its range, blocked by enemies, which deals %.02f to %0.2f damage depending on how much the enemies block.]]):
		format(damage * 2.5, radius, damage, damage * 2.5)
	end,}

registerTalentTranslation{
	id = "T_CRESCENT_WAVE",
	name = "Crescent Wave",
	info = function(self, t)
		return ([[Fires out a projectile in a clockwise arc. If it hits an enemy it deals %0.2f damage and roots them for one turn. If another projectile damages them within %d turns, they take half that damage and are rooted again.]])
	end,}

registerTalentTranslation{
	id = "T_TWILIT_ECHOES",
	name = "Twilit Echoes",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local echo_dur = t.getEchoDur(self, t)
		local slow_per = t.getSlowPer(self, t)
		local slow_max = t.getSlowMax(self, t)
		local echo_factor = t.getDarkEcho(self, t)
		return ([[The target feels the echoes of all your light and dark damage for %d turns. 

Light damage slows the target by %0.2f%% per point of damage dealt for %d turns, up to a maximum of %d%% at %d damage.
Dark damage creates an effect at the tile for %d turns which deals %d%% of the damage dealt each turn. It will be refreshed as long as the target continues taking damage from it or another source while Twilit Echoes is active, dealing its remaining damage over the new duration as well as the new damage.]])
		:format(duration, slow_per * 100, echo_dur, slow_max * 100, slow_max/slow_per, echo_dur, 100 * echo_factor)
	end,}

registerTalentTranslation{
	id = "T_STARSCAPE",
	name = "Starscape",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		
		return ([[Summons the starscape in the surrounding area in a radius of %d. For %d turns, this area exists outside normal time, and in zero gravity. In addition to the effects of zero gravity, Movement of projectiles and other creatures is three times as slow. Spells and attacks cannot escape the radius until the effect ends.]]):
		format(radius, duration)
	end,}
	
	return _M