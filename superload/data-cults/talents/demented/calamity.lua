local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_JINXED_TOUCH",	
	name = "Jinxed Touch",
	info = function(self, t)
		local saves = t.getSaves(self,t)
		local crit = t.getCrit(self,t)
		return ([[Your touch carries an entropic curse, marking your victims for a terrible fate. Each time you deal damage to a target, they are Jinxed for 10 turns. This stacks up to 10 times, reducing saves and defense by %d and critical strike chance by %d%%.
			This can only be applied once per target per turn.
		Targets will begin losing 1 stack of Jinx each turn if they have not received damage from you in the last 2 turns.]]):
		format(saves, crit)
	end,
}
registerTalentTranslation{
	id = "T_PREORDAIN",	
	name = "Preordain",
	info = function(self, t)
		local chance = t.getChance(self,t)
		return ([[You subtly alter the course of events to cause your foes further misfortune. For each stack of Jinx beyond 6, enemies will also suffer %d%% chance to fail talent usage.]]):
		format(chance)
	end,
}
registerTalentTranslation{
	id = "T_LUCKDRINKER",	
	name = "Luckdrinker",
	info = function(self, t)
		local chance = t.getChance(self,t)
		local saves = t.getSaves(self,t)
		local crit = t.getCrit(self,t)
		local avoid = t.getAvoid(self,t)
		return ([[Each time you apply Jinx to an enemy, you have a %d%% chance to siphon some of their luck for yourself for 10 turns. This stacks up to 10 times, increasing saves and defense by %d and critical strike chance by %d%%.
		If you know Preordain, stacks beyond 6 also grant a %d%% chance for you to entirely avoid damage taken.]]):
		format(chance, saves, crit, avoid)
	end,
}
registerTalentTranslation{
	id = "T_FATEBREAKER",	
	name = "Fatebreaker",
	info = function(self, t)
		local dur = t.getDuration(self,t)
		local life = t.getLife(self,t)
		return ([[You form a link between yourself and the chosen target for %d turns, tying your fates together. If during this time you receive fatal damage, you reflexively warp reality, ending the effect and attempting to force them to die in your place. 
		This prevents all damage taken during that turn, redirecting it to your target as temporal and void damage.
		Any Fortune stacks you have and any Jinx stacks the enemy have will then be consumed to heal you for %d life per stack.]]):
		format(dur, life)
	end,
}
return _M
