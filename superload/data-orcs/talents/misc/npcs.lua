local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_PETRIFYING_GAZE",
	name = "Petrifying Gaze",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[Gaze at your foes and turn them to stone for %d turns.
		Stoned creatures are unable to act or regen life, and are very brittle.
		If a stoned creature is hit by an attack that deals more than 30%% of its life, it will shatter and be destroyed.
		Stoned creatures are highly resistant to fire and lightning, and somewhat resistant to physical attacks.
		This spell may fail against creatures resistant to being stunned, that are specifically immune to stoning, or certain bosses.]]):
		format(duration)
	end,}

registerTalentTranslation{
	id = "T_GNASHING_MAW",
	name = "Gnashing Maw",
	info = function(self, t)
		return ([[Hits the target with your weapon, doing %d%% damage. If the attack hits, the target's Accuracy is reduced by %d for %d turns.
		Accuracy reduction chance increases with your Physical Power.]])
		:format(
			100 * self:combatTalentWeaponDamage(t, 1, 1.5), 3 * self:getTalentLevel(t), t.getDuration(self, t))
	end,}

local sandtrap = nil
registerTalentTranslation{
	id = "T_SANDRUSH",
	name = "Sandrush",
	info = function(self, t)
		return ([[Dive into the sand and rush towards your target at up to range %d, gaining a free attack if you reach it.
		At the exit point, up to 9 sand pits will appear that last for %d turns (based on your Strength).
		You must rush from at least 2 tiles away.]]):format(t.range(self, t), t.duration(self, t))
	end,}

registerTalentTranslation{
	id = "T_RITCH_LARVA_INFECT",
	name = "Ritch Larva Infect",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local nb = t.getNb(self, t)
		local Pdam, Fdam = self:damDesc(DamageType.PHYSICAL, dam/2), self:damDesc(DamageType.FIRE, dam/2)
		return ([[Sting the target with your ovipositor, injecting %d larvae into it to finish their hatching process.
		Over a 5 turn gestation period, the larvae will feed on the victim internally, dealing %0.2f to %0.2f physical damage each turn (increasing as they grow).
		After the gestation period is complete, each larva will rip itself free of its host, dealing %0.2f physical and %0.2f fire damage.
		]]):format(nb, nb*Pdam*2*.05, nb*Pdam*2*.25, Pdam, Fdam)
	end,}

registerTalentTranslation{
	id  = "T_AMAKTHEL_SLUMBER",
	name = "Slumbering...",
	info = function(self, t)
		return ([[The Dead God slumbers. For now.]])
	end,}

registerTalentTranslation{
	id = "T_AMAKTHEL_TENTACLE_SPAWN",
	name = "Tentacle Spawn", 
	info = function(self, t)
		return ([[The Dead God wishes to tickle you...]])
	end,}

registerTalentTranslation{
	id = "T_CURSE_OF_AMAKTHEL",
	name = "Curse of Amakthel",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[Create a circle of cursed ground (radius %d) for %d turns. Any foes inside will be cursed, all new negative effects on them will have their duration doubled.
		]]):
		format(radius, duration)
	end,}

registerTalentTranslation{
	id = "T_TEMPORAL_RIPPLES",
	name = "Temporal Ripples",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[Creates a circle of radius %d of altered time for %d turns. Any damage your foes take while standing in it will heal the attacker for 200%% of the damage dealt.
		]]):
		format(radius, duration)
	end,}

registerTalentTranslation{
	id = "T_SAW_STORM",
	name = "Saw Storm",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[Summon a storm of swirling sawblades to slice your foes, inflicting %d physical damage and bleeding to anyone who approaches for %d turns.
		The damage and duration will increase with your Mindpower.]]):format(damDesc(self, DamageType.PHYSICAL, damage), duration)
	end,}

registerTalentTranslation{
	id = "T_RAZOR_SAW",
	name = "Razor Saw",
	info = function(self, t)
		return ([[Launches a sawblade with intense power doing %0.2f physical damage to all targets in line.
		The damage will increase with Mindpower]]):format(damDesc(self, DamageType.PHYSICAL, self:combatTalentMindDamage(t, 60, 300)))
	end,}

registerTalentTranslation{
	id = "T_ROCKET_DASH",
	name = "Rocket Dash",
	info = function(self, t)
		return ([[Dash forward using rockets.
		If the spot is reached and occupied, you will perform a free melee attack against the target there.
		This attack does 130% weapon damage.
		You must dash from at least 2 tiles away.]])
	end,}

-- Solely used to track the achievement
registerTalentTranslation{
	id = "T_ACHIEVEMENT_MIND_CONTROLLED_YETI",
	name = "Mind Controlled Yeti",
	info = function(self, t)
		return "Yeti SMASH!"
	end,}


return _M