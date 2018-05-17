local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_ENTROPIC_GIFT",
	name = "Entropic Gift",
	info = function(self, t)
		local power = t.getPower(self,t)
		return ([[Your unnatural existence causes the fabric of reality to reject your presence. 25%% of all direct healing received damages you in the form of entropic backlash over 8 turns, which is irresistible and bypasses all shields, but cannot kill you.

You may activate this talent to channel your entropy onto a nearby enemy, removing all entropic backlash to inflict darkness and temporal damage equal to %d%% of your entropy over 4 turns.

The damage dealt when applying this to an enemy will increase with your Spellpower.]]):
		format(power)
	end,
}

registerTalentTranslation{
	id = "T_REVERSE_ENTROPY",
	name = "Reverse Entropy",
	info = function(self, t)

		return ([[Your knowledge of entropy allows you to defy the laws of physics, allowing you to better endure your entropic energies.
			You take %d%% less damage from your entropic backlash.
		You may activate this talent to instantly remove your current Entropy.]]):
		format(t.getReduction(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BLACK_HOLE",
	name = "Black Hole",
	info = function(self, t)
		local rad = t.getMaxRadius(self,t)
		local dam = t.getDamage(self,t)/2
		local dur = t.getDuration(self,t)
		local bonus = t.getEntropyBonus(self,t)*100
		local entropy = 0
		if self:hasEffect(self.EFF_ENTROPIC_WASTING) then
			local eff = self:hasEffect(self.EFF_ENTROPIC_WASTING)
			local edam = 0
			if eff then edam = (eff.power * eff.dur) * t.getEntropyBonus(self,t) end
			entropy = edam
		end
		return ([[On casting Entropic Gift, a radius 1 rift in spacetime will be opened underneath the target for %d turns, increasing in radius by 1 each turn to a maximum of %d.
		All caught within the rift are pulled towards the center and take %0.2f darkness and %0.2f temporal damage, plus %d%% of your total entropy each turn (currently %d).]]):
		format(dur, rad, damDesc(self, DamageType.DARKNESS, dam), damDesc(self, DamageType.TEMPORAL, dam), bonus, entropy)
	end,
}

registerTalentTranslation{
	id = "T_POWER_OVERWHELMING",
	name = "Power Overwhelming",
	info = function(self, t)
		local power = t.getDamageIncrease(self,t)
		local pen = t.getResistPenalty(self,t)
		local dam = t.getDamage(self,t)
		return ([[You empower your spells with dangerous levels of entropic energy, increasing your darkness and temporal damage by %d%% and resistance penetration by %d%%, at the cost of suffering %0.2f entropic backlash for each non-instant spell.]]):
		format(power, pen, dam)
	end,
}

return _M
