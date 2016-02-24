local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_PSYSHOT",
	name = "Psyshot",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[Increases Physical Power by %d and increases weapon damage by %d%% when using steamguns.
		When your bullets hit a target your instinctively reach out to the impact and use the kinetic force to project a mindstar attack doing %d%% damage (guaranteed hit), if you wield one in the offhand.

		Also activable for a shoot that deals %d%% weapon damage as mind damage.]]):format(damage, inc * 100, t.mindstarMult(self, t) * 100, t.getShootDamage(self, t) * 100)
	end,}

registerTalentTranslation{
	id = "T_BOILING_SHOT",
	name = "Boiling Shot",
	info = function(self, t)
		return ([[Using psionic energies you overheat your shot, making it deal %d%% damage.
		If the shot hits a wet foe it will vaporize, removing the wet effect and dealing %0.2f fire damage in a radius 4.]]):format(100 * t.getDam(self, t), damDesc(self, DamageType.FIRE, t.getSplash(self, t)))
	end,}

registerTalentTranslation{
	id = "T_BLUNT_SHOT",
	name = "Blunt Shot",
	info = function(self, t)
		return ([[Fire a relatively low-powered shot at a foe doing %d%% weapon damage, if it hits a cone-shaped shockwave of radius 4 emanates from the impact, stunning it and all creatures caught inside for %d turns.]])
		:format(100 * t.getDam(self, t), t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_VACUUM_SHOT",
	name = "Vacuum Shot",
	info = function(self, t)
		return ([[Attach a psionic steam device to a shot doing %d%% weapon damage.
		When it hits a foe the device activates, violently sucking all the air nearby, pulling in all creatures in radius %d.]])
		:format(100 * t.getDam(self, t), self:getTalentRadius(t))
	end,}
