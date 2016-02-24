local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_VAPOROUS_STEP",
	name = "Vaporous Step",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[You concentrate your will to psychoport some of the steam of your generator to a remote location. Each turn steam accumulates there, up to %d charges.
		When you deactivate the effect you release the accumulated psionic and steam energies, instantly switching places with the target location and releasing the charges in a fiery explosion of hot wet steam in radius 4.
		The explosion will do %0.2f fire damage, multiplied by 33%% (diminutive) for each charge and apply the wet effect.
		The effect will fizzle is the charged grid is currently occupied by a creature or not in sight.
		The damage will increase with your Steampower.]]):
		format(t.getMaxCharge(self, t), damDesc(self, DamageType.FIRE, damage))
	end,}

registerTalentTranslation{
	id = "T_INHALE_VAPOURS",
	name = "Inhale Vapours",
	info = function(self, t)
		return ([[When you deactivate Vaporous Step, if the psychoport succeeds you inhale some of the vapours, regenerating %d steam and %d life.
		The effects will be multiplied by 33%% (diminutive) for each charge of Vaporous Step.
		The healing done will increase with your Mindpower.]]):
		format(t.getSteam(self, t), t.getHeal(self, t))
	end,}

registerTalentTranslation{
	id = "T_PSIONIC_FOG",
	name = "Psionic Fog",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[Using the steam of your generators you shape it into a psionic fog that lasts %d turns. Any foes caught inside will take %0.2f damage per turn and be seared, reducing their fire resistance by %d%% and and mind save by %d.
		The damage will increase with your Mindpower.]]):
		format(duration, damDesc(self, DamageType.MIND, damage), t.getSearing(self, t), t.getSearing(self, t))
	end,}

registerTalentTranslation{
	id = "T_UNCERTAINTY_PRINCIPLE",
	name = "Uncertainty Principle",
	info = function(self, t)
		return ([[While inside a psionic fog the quantum state of space is warped by your powerful tech-augmented psionic powers.
		When you would get hit you instead find yourself in an adjacent location.
		This effect has a cooldown.]]):
		format()
	end,}
