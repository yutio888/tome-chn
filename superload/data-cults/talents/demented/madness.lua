local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_DARK_WHISPERS",
	name = "Dark Whispers",
	info = function(self, t)
		local dam = t.getDamage(self,t)
		local stat = t.getPowerLoss(self,t)
		local rad = self:getTalentRadius(t)
		return ([[Terrible visions and maddening voices fill the minds of enemies within a radius %d area, inflicting %0.2f darkness damage each turn for 5 turns. In addition, this distraction will reduce physical, spell and mindpower of those affected by %d.
The power loss caused by this spell can stack, to a maximum of %d powers.
		The effect will increase with your Spellpower.]]):
		format(rad, damDesc(self, DamageType.DARKNESS, dam), stat, stat*3)
	end,
}

registerTalentTranslation{
	id = "T_HIDEOUS_VISIONS",
	name = "Hideous Visions",
	info = function(self, t)
		local chance = t.getChance(self,t)
		local dur = t.getDuration(self,t)
		local damage = t.getDamageReduction(self,t)
		return ([[Each time an enemy takes damage from Dark Whispers, there is a %d%% chance for one of their visions to manifest in an adjacent tile for %d turns. This vision takes no actions but the victim will deal %d%% reduced damage to all other targets until the vision is slain.
		A target cannot have more than one hallucination at a time.]]):
		format(chance, dur, damage)
	end,
}

registerTalentTranslation{
	id = "T_SANITY_WARP",
	name = "Sanity Warp",
	info = function(self, t)
		local dam = t.getDamage(self,t)
		local radius = self:getTalentRadius(t)
		return ([[When a hallucination from Hideous Visions is slain, it unleashes a psychic shriek dealing %0.2f darkness damage to enemies in radius %d.]]):
		format(damDesc(self, DamageType.DARKNESS, dam), radius)
	end,
}

registerTalentTranslation{
	id = "T_CACOPHONY",
	name = "Cacophony",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local dur = t.getDuration(self,t)
		local dam = t.getDamage(self,t)*100
		return ([[Raise your Dark Whispers in radius %d to a deafening crescendo for %d turns, applying another stack and drowning out all thought. 
			Targets afflicted by Dark Whispers will have 20%% higher chance to spawn hallucinations, and each time they take damage from your Dark Whispers or Sanity Warp they will take an additional %d%% damage as temporal damage.
		The damage will improve with your Spellpower.]]):format(rad, dur, dam)
	end,
}

return _M
