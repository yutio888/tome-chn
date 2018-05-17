local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CHAOS_ORBS",	
	name = "混沌之球",
	info = function(self, t)
		return ([[You harness the chaos created by high insanity.
		Each time you trigger an insanity chaotic effect with a power higher than %d or lower than -%d you gain a chaos orb for 10 turns (This effect can only happen once per turn).
		Each orb increases your damage by 3%% and can stack up to %d.]]):
		format(t.getTrigger(self, t), t.getTrigger(self, t), t.getMax(self, t))
	end,
}

return _M