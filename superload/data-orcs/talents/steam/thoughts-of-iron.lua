local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MOLTEN_IRON_BLOOD",
	name = "Molten Iron Blood",
	info = function(self, t)
		return ([[Using psionic energies you temporarily alter your blood, turning it into molten iron.
		When affected by molten blood all creatures that hit you in melee take %0.2f fire damage, all your resistances are increased by %d%% and all new detrimental effects on you have their duration reduced by %d%%.
		Damage increases with your Steampower.
		]]):format(damDesc(self, DamageType.FIRE, t.getSplash(self, t)), t.getResists(self, t), t.getReduction(self, t))
	end,}

registerTalentTranslation{
	id = "T_MIND_DRONES",
	name = "Mind Drones",
	info = function(self, t)
		return ([[Melding psionics with steamtech you create 5 mind drones at your sides that fly towards your target.
		If they encounter a creature they will latch on it and bore into its skull for 6 turns, disrupting its thoughts.
		Disrupted creatures have %d%% chances to fail to use talents and suffer a -%d%% reduction to fear and sleep immunity.]]):
		format(t.getFail(self, t), t.getReduction(self, t))
	end,}

registerTalentTranslation{
	id = "T_PSIONIC_MIRROR",
	name = "Psionic Mirror",
	info = function(self, t)
		return ([[You cleanse your mind of %d mental debuffs.
		Cleansed effects will be randomly sent to closeby foes (range 5, subject to a mental save).]])
		:format(t.getNum(self, t))
	end,}

registerTalentTranslation{
	id = "T_MIND_INJECTION",
	name = "Mind Injection",
	info = function(self, t)
		local faked = false
		if not self.inscriptions_data.MIND_INJECTION then self.inscriptions_data.MIND_INJECTION = {power=t.getPower(self, t), cooldown_mod=t.getCooldownMod(self, t), cooldown=1} faked = true end
		local data = self:getInscriptionData(t.short_name)
		if faked then self.inscriptions_data.MIND_INJECTION = nil end
		return ([[By using a direct psionic link to your body you can use even more therapeutics. %d%% efficiency and %d%% cooldown mod.]])
		:format(data.power + data.inc_stat, data.cooldown_mod)
	end,}
