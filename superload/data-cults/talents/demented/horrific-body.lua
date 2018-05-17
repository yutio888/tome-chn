local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_SHED_SKIN",
	name = "Shed Skin",
	info = function(self, t)
		return ([[You shed the outer layer of your mutated skin and empower it to act as a damage shield for 7 turns.
		The shield can absorb up to %d damage before it crumbles.
		]]):format(t.getAbsorb(self, t))
	end,
}

registerTalentTranslation{
	id = "T_PUSTULENT_GROWTH",
	name = "Pustulent Growth",
	info = function(self, t)
		return ([[Each time your shed skin looses %d%% of its max power or you take damage over 15%% of your maximum life a black putrescent pustule grows on your body for 5 turns.
		Each pustule increases all your resistances by %d%%. You can have up to %d pustules at once.
		Resistance scales with your Spellpower.]]):
		format(t.getCutoff(self, t), t.getResist(self, t), t.getMax(self, t))
	end,
}

registerTalentTranslation{
	id = "T_PUSTULENT_FULMINATION",
	name = "Pustulent Fulmination",
	info = function(self, t)
		return ([[You make all your putrescent pustules explode at once, splashing all creatures in radius %d with black fluids that deal %0.2f darkness damage per pustule and healing you for %0.1f per pustule.]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.DARKNESS, t.getDam(self, t)), t.getHeal(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DEFILED_BLOOD",
	name = "Defiled Blood",
	info = function(self, t)
		return ([[When you make your pustules explode you leave a pool of defiled blood on the ground for 5 turns.
		Foes caught inside get assaulted by black tentacles every turn, dealing %d%% darkness tentacle damage and covering them in your black blood for 2 turns.
		Creatures that hit you while covered in your blood heal you for %d%% of the damage done.
		The healing received increases with your Spellpower.]]):
		format(t.getDam(self, t) * 100, t.getHeal(self, t))
	end,
}

return _M
