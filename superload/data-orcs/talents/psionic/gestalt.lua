local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GESTALT",
	name = "Gestalt",
	info = function(self, t)
		return ([[You let your mind tap into your steam generators for energy, increasing your Mindpower in proportion to your steam level: %d when at full steam and 0 when at 0 steam.
		Using a psionic talent will feedback into your generators, increasing your Steam power by %d for your next steamtech talent.
		Using a steamtech talent will feedback into psionic focus, increasing your psi level by %d.
		The effects increase with your Willpower.]]):
		format(t.getMind(self, t), t.getSteam(self, t), t.getPsi(self, t))
	end,}

registerTalentTranslation{
	id = "T_IMPROVED_GESTALT",
	name = "Improved Gestalt",
	info = function(self, t)
		local shield_power = t.getShieldPower(self, t)
		return ([[When you use a steamtech talent while Gestalt is active you drain some residual power to form a psionic shield.
		The shield forms for 3 turns and absorbs %d damage.
		The effects increase with your Mindpower.]]):format(shield_power)
	end,}

registerTalentTranslation{
	id = "T_INSTANT_CHANNELING",
	name = "Instant Channeling",
	info = function(self, t)
		return ([[Instantly channel all of your remaining steam to replenish your psi energies and either enhance your active psionic damage shield or trigger a new one.
		The (new or existing) shield duration is increased by 3 turns and its power is boosted by %d%% of the steam used.
		You restore psi equal to %d%% of the steam used.
		This talent requires Gestalt to be active and either an active psionic damage shield or Improved Gestalt off cooldown.]]):format(t.getPower(self, t), t.getPsi(self, t))
	end,}

registerTalentTranslation{
	id = "T_FORCED_GESTALT",
	name = "Forced Gestalt",
	info = function(self, t)
		return ([[Temporarily expand your mind to force your Gestalt upon your foes in a radius of 5. Up to %d foe(s) will be affected.
		The Gestalt will drain each affected foe's powers (physical power, mind power, spell power and steam power) by %d for 5 turns.
		Your own powers will be increased in return by the drained amount (reduced for each additional foe).
		In addition for 5 turns you can sense creatures beyond your sight, even through walls in radius %d.
		The effects improve with your Mindpower.]]):format(t.getNb(self, t), t.getPower(self, t), t.getSenseRadius(self, t))
	end,}
