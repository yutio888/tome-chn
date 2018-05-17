local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DECAYED_DEVOURERS",
	name = "Decayed Devourers",
	info = function(self, t)
		return ([[You use your bond with horrors to summon three decaying devourers for %d turns.
The decaying horrors cannot move and will attack all hostile creatures around them. They possess the talents Bloodbath, Gnashing Teeth and Frenzied Bite.
All its primary stats will be set to %d (based on your Magic stat), life rating increased by %d, and all talent levels set to %d.  Many other stats will scale with level.
Your increased damage, damage penetration, critical strike chance, and critical strike multiplier stats will all be inherited.]]):
		format(t.getDur(self, t), t.getStats(self, t), t.getLifeRating(self, t), math.floor(self:getTalentLevel(t)))
	end,
}

registerTalentTranslation{
	id = "T_DECAYED_BLADE_HORROR",
	name = "Decayed Bloated Horror",
	info = function(self, t)
		return ([[You use your bond with horrors to summon a decaying bloated horror for %d turns.
The decaying horror cannot move and will attack all hostile creatures in range of it. It possesses the talents Mind Disruption and Mind Sear.
All its primary stats will be set to %d (based on your Magic stat), life rating increased by %d, and all talent levels set to %d.  Many other stats will scale with level.
Your increased damage, damage penetration, critical strike chance, and critical strike multiplier stats will all be inherited.
		]]):
		format(t.getDur(self, t), t.getStats(self, t), t.getLifeRating(self, t), math.floor(self:getTalentLevel(t)))
	end,
}

-- Check for permanently changing target and possible general overpoweredness
registerTalentTranslation{
	id = "T_HORRIFIC_DISPLAY",
	name = "Horrific Display",
	info = function(self, t)
		return ([[You forcefully try to turn a creature into an horror.
If the target fails a magical save against your Spellpower, its appearance turns into that of an horror for %d turns, making all other creatures hostile to it.
Enemies near the target will have their target cleared on application.
This spell does not work on horrors.]])
		:format(t.getDur(self, t))
	end,
}

registerTalentTranslation{
	name = "Call of Amakthel", 
	id = "T_DEMENTED_CALL_AMAKTHEL",
	info = function(self, t)
		return ([[You attune your horrors to the dead god Amakthel, increasing your summoned horrors damage by %d%%.
At talent level 3, your Decaying Devourers spell will summon 4 additional Devourers adjacent to random enemies nearby and your Bloated Horror will learn the Agony talent.
At talent level 5, victims of your Horrific Display spell will pull enemies in radius 10 1 space towards them each turn.
The damage increase is based on your Spellpower.]]):
		format(t.getDam(self, t))
	end,
}
return _M
