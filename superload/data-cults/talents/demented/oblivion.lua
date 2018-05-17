local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_NIHIL",
	name = "Nihil",
	info = function(self, t)
		local targetcount = t.getTargetCount(self, t)
		local power = t.getPower(self, t)*100
		return ([[Your entropy bleeds into the world around you. On having entropic backlash applied or increased to you, %d random enemies you can see within radius 10 will be shrouded in entropic forces for 4 turns. This increases the duration of new negative effects and reduces the duration of new beneficial effects applied to the target by %d%%.]]):
		format(targetcount, power)
	end,
}

registerTalentTranslation{
	id = "T_UNRAVEL_EXISTENCE",
	name = "Unravel Existence",
	info = function(self, t)
		local dur = t.getDuration(self,t)
		return ([[Your Nihil unravels the existence of the target, tearing them apart with entropy.
		If 6 effects are applied before Nihil expires a Herald of Oblivion will be summoned to assist you for %d turns.
		The Herald will have a bonus to all attributes equal to your Magic.  Many other stats will scale with level.
		Your increased damage, damage penetration, critical strike chance, and critical strike multiplier stats will all be inherited.]]):
		format(dur)
	end,
}

registerTalentTranslation{
	id = "T_ERASE",
	name = "Erase",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local power = t.getNumb(self, t)
		return ([[Those affected by your Nihil find themselves increasingly removed from reality, reducing all damage they deal by %d%% and taking %0.2f temporal damage each turn for each negative magical effect they have. 
		The damage will scale with your Spellpower.]])
		:format(power, damDesc(self, DamageType.TEMPORAL, dam))
	end
}


registerTalentTranslation{
	id = "T_ALL_IS_DUST",
	name = "All is Dust",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[Summon a radius 4 storm of all-consuming oblivion at the targeted location for %d turns, reducing those within to nothing. Targets within will take %0.2f darkness damage and %0.2f temporal damage each turn.  Walls and other terrain within the storm will be disintegrated.
		Each time the storm deals damage enemies will have any detrimental magical effect with less than 3 duration set to 3 duration, and all enemy projectiles will be destroyed.
		The damage will scale with your Spellpower.]]):format(duration, damDesc(self, DamageType.DARKNESS, damage), damDesc(self, DamageType.TEMPORAL, damage))
	end,
}

registerTalentTranslation{
	id = "T_VOID_CRASH",
	name = "Void Crash",
	info = function(self, t)
		return ([[Slam your weapons into the ground, creating a radius 2 explosion of void energy dealing %d%% damage split between darkness and temporal.]]):
		format(t.getDamage(self, t) * 100)
	end,
}

return _M
