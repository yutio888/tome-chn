local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TENTACLED_WINGS",
	name = "Tentacled Wings",
	info = function(self, t)
		return ([[You project tentacles in a cone of radius %d in front of you.
		Any foes caught inside is grappled by the tentacles and suffers %d%% weapon damage as blight, if the attack hits the creature is also pulled towards you.]]):
		format(self:getTalentRange(t), damDesc(self, DamageType.BLIGHT, t.getDamage(self, t) * 100))
	end,
}

registerTalentTranslation{
	id = "T_DECAYING_GROUNDS",
	name = "Decaying Grounds",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[You blight a zone as a decaying ground for %d turns. All creatures inside take %0.2f blight damage per turn and have all their cooldowns increased by %d%% for 3 turns.
		The damage will scale with the highest of your spell or mind power.]]):
		format(t.getDuration(self, t), damDesc(self, DamageType.DARKNESS, damage), t.getPower(self,t))
	end,
}

registerTalentTranslation{
	id = "T_AUGMENT_DESPAIR",
	name = "Augment Despair",
	info = function(self, t)
		return ([[You target a single creature with all your hatred and insanity, augmenting its despair, increasing the duration of detrimental effects by %d turns and dealing %0.2f blight damage per detrimental effect (each effect deals 75%% of the previous one).
		The damage will scale with the highest of your spell or mind power.]]):
		format(t.getDuration(self, t), damDesc(self, DamageType.BLIGHT, t.getDamage(self, t)))
	end,
}


registerTalentTranslation{
	id = "T_MAGGOT_BREATH",
	name = "Maggot Breath",
	info = function(self, t)
		return ([[You breathe a wave of dead maggots in a cone of radius %d. Any target caught in the area will take %0.2f blight damage and be infected with a crippling disease for 10 turns.
		Crippling disease slows creatures by %d%% and deals %0.2f blight damage per turn.
		The damage will increase with your Magic, and the critical chance is based on your Spell crit rate.]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.BLIGHT, t.getDamage(self, t)), t.getSlow(self, t) * 100, damDesc(self, DamageType.BLIGHT, t.getDiseaseDamage(self, t)))
	end,
}

return _M
