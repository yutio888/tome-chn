local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ATROPHY",
	name = "Atrophy",
	info = function(self, t)
		return ([[You are surrounded by a vortex of entropic energy that feeds on the timeline of others. Each time you cast a spell random targets in radius 10 begin rapidly aging and decaying, reducing all stats by %d for 8 turns, stacking up to %d times.
			Up to %d stacks total will be applied to enemies each cast with a max of 2 stacks on the same target.]]):
		format(t.getStat(self, t), t.getMaxStacks(self, t), t.getStacks(self, t))
	end
}

registerTalentTranslation{
	id = "T_SEVERED_THREADS",
	name = "Severed Threads",
	info = function(self, t)
		local life = t.getLife(self,t)*100
		local dur = t.getDuration(self,t)
		local power = t.getPower(self,t)
		return ([[On applying atrophy to a target below %d%% of their maximum life you will sever their lifeline, slaying them instantly. You will then feast on the remnants of their timeline for %d turns, increasing your life regeneration by %0.1f and causing talents without fixed cooldowns to refresh twice as fast.
		You cannot receive the invigoration from this talent more than once every 15 turns.]])
		:format(life, dur, power)
	end
}

registerTalentTranslation{
	id = "T_TEMPORAL_FEAST",
	name = "Temporal Feast",
	info = function(self, t)
		local speed = t.getSpeed(self,t)*100
		local slow = t.getSlow(self,t)*100
		return ([[You drink deeper from the timeline of others.  Each time you apply atrophy you gain %0.1f%% cast speed per atrophy stack on the target and cause them to lose %d%% of a turn.
			The highest entropy stack found will be used for the cast speed calculation.]])
		:format(speed, slow)
	end
}

registerTalentTranslation{
	id = "T_TERMINUS",
	name = "Terminus",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local rad = self:getTalentRadius(t)
		local turn = t.getTurn(self,t)/10
		return ([[Shatter the spacetime continuum around yourself, inflicting %0.2f temporal damage to all targets within radius %d. Any atrophy stacks will be consumed to steal time from your victims, inflicting an additional %0.2f temporal damage and granting you %d%% of a turn per stack (but no more than 3 turns).
		The damage will scale with your Spellpower.]]):format(damDesc(self, DamageType.TEMPORAL, damage), rad, damDesc(self, DamageType.TEMPORAL, damage/6), turn)
	end
}

return _M
