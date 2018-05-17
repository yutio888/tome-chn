local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_TELEPORT_KROSHKKUR",
	name = "Teleport: Kroshkkur",
	info = [[Allows to teleport to Kroshkkur.
	You have studied the forbidden secrets there and have been granted a special portal spell to teleport back.
	This spell must be kept secret; it should never be used within view of uninitiated witnesses.
	The spell takes time (40 turns) to activate, and you must be out of sight of any other creature when you cast it and when the teleportation takes effect.]]
}

registerTalentTranslation{
	id = "T_DREM_CALL_OF_AMAKTHEL",
	name = "Call of Amakthel",
	info = function(self, t)
		return ([[Pull all foes within radius 10 3 grid towards you and forces them to target you.]])
	end,
}

registerTalentTranslation{
	id = "T_CRUMBLE",
	name = "Crumble",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Fire a blast of darkness at an enemy dealing %0.2f damage and destroying any walls in radius 3 around them.
		The damage will increase with your Spellpower.]]):
		format(damDesc(self, DamageType.DARKNESS, damage))
	end,
}

registerTalentTranslation{
	id = "T_TWISTED_EVOLUTION",
	name = "Twisted Evolution",
	info = function(self, t)
		return ([[Evolve %d allies within radius 10 in random ways for 5 turns.
		#ORCHID#Speed:#LAST# Increases global speed by %d%%.
		#ORCHID#Form:#LAST# Increases all stats by %d.
		#ORCHID#Power:#LAST# Increases all damage by %d%%.]]):format(t.getAmount(self, t), t.getEvolveSpeed(self, t) * 100, t.getEvolveStat(self, t), t.getEvolveDamage(self, t))
	end,
}

registerTalentTranslation{
	id = "T_GLASS_SPLINTERS",
	name = "Glass Splinters",
	info = function(self, t)
		return ([[Smash your target with a splintering glass attack doing %d%% arcane weapon damage.
		If this attack hits the target will have glass splinters for 6 turns.
		Each turn the target will bleed for 8%% of the attack damage. The splinters are very painful and if the target moves it will instantly take %d%% of the attack damage.
		At level 5 the target suffers so much it has 15%% chances to fail using talents.]])
		:format(t.getDam(self, t) * 100, t.getMovePenalty(self, t))
	end,
}

registerTalentTranslation{
	id = "T_THROW_PEEBLE",
	name = "Throw Pebble",
	info = function(self, t)
		return ([[Throw a pebble at your target, dealing %0.2f physical damage.
		The damage will increase with your Strength.]]):format(damDesc(self, DamageType.PHYSICAL, t.getDam(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_NETHERFORCE",
	name = "Netherforce",
	info = function(self, t)
		local dam = t.getDamage(self,t)/2
		local backlash = t.getBacklash(self,t)
		return ([[Smash the target with the force of the void dealing %0.2f darkness and %0.2f temporal damage to the target and knocking them back 8 spaces.
		The power of this spell inflicts entropic backlash on you, causing you to take %d damage over 8 turns. This damage counts as entropy for the purpose of Entropic Gift.
		The damage will increase with your Spellpower.]]):
		format(damDesc(self, DamageType.DARKNESS, dam), damDesc(self, DamageType.TEMPORAL, dam), backlash)
	end,
}
return _M
