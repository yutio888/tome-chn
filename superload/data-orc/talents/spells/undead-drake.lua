local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RAZE",
	name = "Raze",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[You revel in death, devouring the souls of your victims. Whenever you inflict damage to a target, you deal an additional %0.2f darkness damage.
		Additionally, you gain %d souls whenever you score a kill.
		The damage will scale with the highest of your spell or mind power.]]):
		format(damDesc(self, DamageType.DARKNESS, damage), t.soulBonus(self,t))
	end,}

registerTalentTranslation{
	id = "T_INFECTIOUS_MIASMA",
	name = "Infectious Miasma",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Release a cloud of deadly miasma over a targeted area, dealing %0.2f darkness damage to all units inside it with a 20%% chance of inflicting a disease that will do blight damage and weaken either Constitution, Strength or Dexterity for %d turns.
		The damage will scale with the highest of your spell or mind power.]]):
		format(damDesc(self, DamageType.DARKNESS, damage), t.getBaneDur(self,t))
	end,}

registerTalentTranslation{
	id = "T_VAMPIRIC_SURGE",
	name = "Vampiric Surge",
	info = function(self, t)
		local power = t.getPower(self, t)
		local dur = t.getDuration(self, t)
		return ([[You surge with a life draining energy for %d turns.
		While the effect lasts, you heal yourself for %d%% of all damage you deal.]]):
		format(dur, power)
	end,}


registerTalentTranslation{
	id = "T_NECROTIC_BREATH",
	name = "Necrotic Breath",
	info = function(self, t)
		return ([[You breathe a wave of deathly miasma in a cone of radius %d. Any target caught in the area will take %0.2f darkness damage over 4 turns and receive either a bane of confusion or a bane of blindness for 4 turns.
		The damage will increase with your Magic, and the critical chance is based on your Spell crit rate.]]):format(self:getTalentRadius(t), damDesc(self, DamageType.DARKNESS, self:combatTalentStatDamage(t, "mag", 30, 550)))
	end,}
