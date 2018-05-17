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
registerTalentTranslation{
	id = "T_ANARCHIC_WALK",	
	name = "Anarchic Walk",
	info = function(self, t)
		return ([[You consume the chaotic forces of 2 chaos orbs, randomly teleporting you in a general direction up to %d tiles away.
		You will always travel at least %d tiles away if possible.]]):format(t.getMax(self, t), self:getTalentRange(t))
	end,
}
registerTalentTranslation{
	id = "T_DISJOINTED_MIND",	
	name = "Disjointed Mind",
	info = function(self, t)
		return ([[You trigger an explosion of your chaos orbs on a target.
		The orbs do no damage but confuse it for %d turns with a confusion power of 10%% per orb.
		Your effective spellpower used to overcome the target's mental save is also increased by 10%% per orb.
		All your orbs are always spent.]]):
		format(t.getDur(self, t))
	end,
}
registerTalentTranslation{
	id = "T_CONTROLLED_CHAOS",	
	name = "Controlled Chaos",
	info = function(self, t)
		return ([[You lean to alter chaotic forces to your advantage.
		Your maximum negative insanity effect is reduced from 50%% to %d%%.
		You may activate this talent to consume any Chaos Orbs you have gaining %d insanity per orb.]]):
		format(t.getReduced(self, t), t.getInsanity(self, t))
	end,
}
return _M
