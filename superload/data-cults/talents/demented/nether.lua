local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_NETHERBLAST",
	name = "Netherblast",
	info = function(self, t)
		local dam = t.getDamage(self,t)/2
		local backlash = t.getBacklash(self,t)
		return ([[Fire a burst of unstable void energy, dealing %0.2f darkness and %0.2f temporal damage to the target. The power of this spell inflicts entropic backlash on you, causing you to take %d damage over 8 turns. This damage counts as entropy for the purpose of Entropic Gift.
		The damage will increase with your Spellpower.]]):
		format(damDesc(self, DamageType.DARKNESS, dam), damDesc(self, DamageType.TEMPORAL, dam), backlash)
	end,
}

registerTalentTranslation{
	id = "T_RIFT_CUTTER",
	name = "Rift Cutter",
	info = function(self, t)
		return ([[Fire a beam of energy that rakes across the ground, dealing %0.2f darkness damage to enemies within and leaving behind an unstable rift. After 3 turns the rift detonates, dealing %0.2f temporal damage to adjacent enemies.
		Targets cannot be struck by more than a single rift explosion at once.
		The power of this spell inflicts entropic backlash on you, causing you to take %d damage over 8 turns. This damage counts as entropy for the purpose of Entropic Gift.
		The damage will increase with your Spellpower.]]):
		format(damDesc(self, DamageType.DARKNESS, t.getDamage(self,t)), damDesc(self, DamageType.TEMPORAL, t.getDamage(self,t)), t.getBacklash(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SPATIAL_DISTORTION",
	name = "Spatial Distortion",
	info = function(self, t)
		local dam = t.getDamage(self,t)/2
		local backlash = t.getBacklash(self,t)
		local dur = t.getDuration(self,t)
		local rad = self:getTalentRadius(t)
		return ([[Briefly open a radius %d rift in spacetime that teleports those within to the targeted location. Enemies will take %0.2f darkness and %0.2f temporal damage.
		The power of this spell inflicts entropic backlash on you, causing you to take %d damage over 8 turns. This damage counts as entropy for the purpose of Entropic Gift.
		The damage will improve with your Spellpower.]]):format(rad, damDesc(self, DamageType.DARKNESS, dam), damDesc(self, DamageType.TEMPORAL, dam), backlash)
	end,
}

registerTalentTranslation{
	id = "T_HALO_OF_RUIN",
	name = "Halo of Ruin",
	info = function(self, t)
		return ([[Each time you cast a non-instant Demented spell, a nether spark begins orbiting around you for 10 turns, to a maximum of 5. Each spark increases your critical strike chance by %d%%, and on reaching 5 stars your next Nether spell will consume all sparks to empower itself:
#PURPLE#Netherblast:#LAST# Becomes a deadly lance of void energy, piercing through enemies and dealing an additional %d%% damage over 5 turns.
#PURPLE#Rift Cutter:#LAST# Those in the rift will be pinned for %d turns, take %0.2f temporal damage each turn, and the rift explosion has %d increased radius.
#PURPLE#Spatial Distortion:#LAST# An Entropic Maw will be summoned at the rift's exit for %d turns, pulling in and taunting nearby targets with it's tendrils.
The damage will increase with your Spellpower.  Entropic Maw stats will increase with level and your Magic stat.]]):
		format(t.getCrit(self,t), t.getSpikeDamage(self,t)*100, t.getPin(self, t), damDesc(self, DamageType.TEMPORAL, t.getRiftDamage(self,t)), t.getRiftRadius(self,t), t.getSpatialDuration(self,t))
	end,
}

registerTalentTranslation{
	id = "T_GRASPING_TENDRILS",
	name = "Grasping Tendrils",
	info = function(self, t)
		return ([[Grab a target and drag it to your side, dealing %d%% weapon damage and taunting it.]]):
		format(t.getDamage(self,t)*100)
	end,
}
return _M
