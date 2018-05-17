local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_DIGEST",
	name = "Digest",
	info = function(self, t)
		return ([[Make a melee attack dealing %d%% weapon damage and attempt to snatch a foe that has %d%% life or less left and swallow it whole.
		While you digest it you gain %d insanity per turn and you will only die at -%0.1f life.
		The digestion lasts for 50 turns for an elite and 25 turns for others.]]):
		format(100 * t.getDamage(self, t), t.getMax(self, t), t.getInsanity(self, t), t.getLife(self, t))
	end,
}

registerTalentTranslation{
	id = "T_PAINFUL_AGONY",
	name = "Painful Agony",
	info = function(self, t)
		return ([[The pain you inflict to the victim you are digesting is so intense something breaks inside it, giving you a way into its mind.
		When you digest you can steal a random talent from your victim and can use it for yourself at talent level %d.
		At talent level 5 you can choose which talent to use.
		You may not steal a talent which you already know.
		The stolen talent will not use any resources to activate.
		]]):format(self:getTalentLevelRaw(t))
	end,
}

registerTalentTranslation{
	id = "T_INNER_TENTACLES",
	name = "Inner Tentacles",
	info = function(self, t)
		return ([[Your stomatch grows small tentacles inside which probe and torment your digested victim even more.
		Whenever you deal a critical strike the tentacles probe harder, feeding your more energy from the pain of your victim making you able to feed on the pain your cause to others for 3 turns.
		This effect gives you 20%% chances to leech of your attacks, healing you for %d%% of the damage done.]]):
		format(t.getLeechValue(self, t))
	end,
}

registerTalentTranslation{
	id = "T_CONSUME_WHOLE",
	name = "Consume Whole",
	info = function(self, t)
		return ([[Instantly consume what remains of your victim, healing yourself for %d life and generating %d insanity.
		The life healed will increase with your Spellpower.]]):
		format(t.getHeal(self, t), t.getInsanity(self, t))
	end,
}

return _M
