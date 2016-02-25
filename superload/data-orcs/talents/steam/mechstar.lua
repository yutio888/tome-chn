local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_METALSTAR",
	name = "Metalstar",
	info = function(self, t)
		return ([[Quickly aggregate particles of metal around your mindstar and focus psionic energies into it.
		The metal explodes like shrapnel, knocking back (%d away) and dazing (%d duration) all foes in radius %d.]])
		:format(t.getKnockback(self, t), t.getDur(self, t), self:getTalentRadius(t))
	end,}

registerTalentTranslation{
	id = "T_BLOODSTAR",
	name = "Bloodstar",
	info = function(self, t)
		local mt = self:getTalentFromId(self.T_METALSTAR)
		return ([[When you fire your metalstar, your also establish a psionic bloodlink with the shrapnel still inside for %d turns.
		Each turn the victims are drained for %0.2f physical damage, half of which heals you (each additional victim healing is reduced by half).
		If the victim move more than twice away from the radius of Metalstar (currently %d) the effect stops.
		This damage does not break daze and increases with your Steampower.]])
		:format(t.getDur(self, t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), self:getTalentRadius(mt) * 2)
	end,}

registerTalentTranslation{
	id = "T_STEAMSTAR",
	name = "Steamstar",
	info = function(self, t)
		local mt = self:getTalentFromId(self.T_METALSTAR)
		return ([[Your bloodstar effect also burns part of your victim's flesh, dealing %0.2f fire damage.
		The intensity of the fire generates steam which you psionically absorb through gestalt, providing %d steam each turn (each additional victim steam generation is reduced by 66%%).
		This damage does not break daze and increases with your Steampower.]])
		:format(damDesc(self, DamageType.FIRE, t.getDamage(self, t)), t.getSteam(self, t))
	end,}

registerTalentTranslation{
	id = "T_DEATHSTAR",
	name = "Deathstar",
	info = function(self, t)
		return ([[When you use a shoot class talent to hit a creature affected by bloodstar an other shoot talent will have its current cooldown reduced by %d turns.]])
		:format(t.getReduct(self, t))
	end,}
return _M