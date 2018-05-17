local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_DISEASED_TONGUE",
	name = "Diseased Tongue",
	info = function(self, t)
		return ([[Your tongue turns into a diseased tentacle that you use to #{italic}#lick#{normal}# enemies in a cone.
		Licked creatures take %d%% tentacle damage that ignores armor and get sick, gaining a random disease for %d turns that deals %0.2f blight damage per turn and reduces strength, dexterity or constitution by %d.
		
		If at least one enemy is hit you gain %d insanity.
		
		Disease damage will increase with your Spellpower.]]):
		format(
			t.getDamageTentacle(self, t) * 100,
			t.getDuration(self, t), damDesc(self, DamageType.BLIGHT, t.getDamageDisease(self, t)), t.getDiseasePower(self, t),
			t.getInsanity(self, t)
		)
	end,
}

registerTalentTranslation{
	id = "T_DISSOLVED_FACE",
	name = "Dissolved Face",
	info = function(self, t)
		return ([[You approach your face to your target and let some of it melt in a gush of blood and gore, dealing %0.2f darkness damage (%0.2f total) in a cone over 5 turns.
		Each turn the target will be dealt an additional %0.2f blight damage per disease.
		Damage will increase with your Spellpower.]])
		:format(damDesc(self, DamageType.DARKNESS, t.getDamage(self, t) / 5), damDesc(self, DamageType.DARKNESS, t.getDamage(self, t)), damDesc(self, DamageType.BLIGHT, 0.7 * t.getDamage(self, t) / 5))
	end,
}

registerTalentTranslation{
	id = "T_WRITHING_HAIRS",
	name = "Writhing Hairs",
	info = function(self, t)
		return ([[For a brief moment horrific hairs grow on your head, each of them ending with a creepy eye.
		You use those eyes to gaze upon a target area, and creatures caught inside partially turn to stone, reducing their movement speed by %d%% and making them brittle for 7 turns.
		Brittle targets have a 35%% chance for any damage they take to be increased by %d%%.
		This cannot be saved against.
		]]):
		format(t.getSpeed(self, t) * 100, t.getBrittle(self, t))
	end,
}

registerTalentTranslation{
	id = "T_GLIMPSE_OF_TRUE_HORROR",
	name = "Glimpse of True Horror",
	info = function(self, t)
		return ([[Whenever you use a disfigured face power you show a glimpse of what True Horror is.
		If the affected targets fail a spell save they become frightened for 2 turns, giving them %d%% chances to fail using talents.
		When a target becomes afraid it bolsters you to see their anguish, increasing your darkness and blight damage penetration by %d%% for 2 turns.
		The values will increase with your Spellpower.]]):
		format(t.getFail(self, t), t.getPen(self, t))
	end,
}
return _M
