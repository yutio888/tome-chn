local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_REALITY_FRACTURE",
	name = "Reality Fracture",
	info = function(self, t)
		local dur = t.getDuration(self,t)
		local damage = t.getDamage(self,t)/2
		local nb = t.getNb(self,t)
		return ([[The sheer power of your entropy tears holes through spacetime, opening this world to the void.
On casting a Demented spell you have a 30%% chance of creating a void rift lasting %d turns in a nearby tile, which will launch void blasts each turn at a random enemy in range 7, dealing %0.2f darkness and %0.2f temporal damage.

You may activate this talent to forcibly destabilize spacetime, spawning %d void rifts around you.]]):
		format(dur, damDesc(self, DamageType.DARKNESS, damage), damDesc(self, DamageType.TEMPORAL, damage), nb)
	end,
}

registerTalentTranslation{
	id = "T_QUANTUM_TUNNELLING",
	name = "Quantum Tunnelling",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local power = t.getPower(self,t)
		return ([[You briefly open a tunnel through spacetime, teleporting to a void rift in range %d. This destroys the rift, granting you a shield for 4 turns absorbing %d damage.
		The damage absorbed will scale with your Spellpower]]):
		format(range, power)
	end
}

registerTalentTranslation{
	id = "T_PIERCE_THE_VEIL",
	name = "Pierce the Veil",
	info = function(self, t)
		local chance = t.getChance(self,t)
		local ndam = t.getNetherDamage(self,t)
		local tdam = t.getTemporalDamage(self,t)
		local dur = t.getDimensionalDuration(self,t)
		return ([[Pouring more energy into your rifts, you have a %d%% chance for each one to instead appear as a more powerful type.
#PURPLE#Nether Breach:#LAST# Fires a beam dealing %0.2f darkness damage at a random target in radius 10.
#PURPLE#Temporal Vortex:#LAST# Inflicts %0.2f temporal damage each turn to enemies in radius 4 and reduces their global speed by 30%%.
#PURPLE#Dimensional Gate:#LAST# Each turn has a 50%% chance to summon a voidling lasting %d turns, a fast melee attacker that can teleport.
The stats of your Void Skitterers will scale with your Magic stat and level.]])
		:format(chance, damDesc(self, DamageType.DARKNESS, ndam), damDesc(self, DamageType.TEMPORAL, tdam), dur)
	end
}

registerTalentTranslation{
	id = "T_DIMENSIONAL_SKITTER",
	name = "Dimensional Skitter",
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[Teleport to a target within range 10 and strike them with your fangs dealing %d%% weapon damage.]]):format(t.getDamage(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_ZERO_POINT_ENERGY",
	name = "Zero Point Energy",	
	info = function(self, t)
		local power = t.getPower(self,t)
		return ([[You draw power from the depths of the void causing your Reality Fracture to enhance any existing rifts.
#GREY#Void Rift:#LAST# Deals %d%% increased damage and projectiles explode in radius 1.
#PURPLE#Nether Breach:#LAST# Deals %d%% increased damage and chains to 3 targets.
#PURPLE#Temporal Vortex:#LAST# Deals %d%% increased damage, radius increased by 1, and slow increased to 50%%.
#PURPLE#Dimensional Gate:#LAST# Voidling Skitterers will be frenzied, increasing their global speed by %d%%.]])
		:format(power, power, power, power)
	end,
}
return _M

