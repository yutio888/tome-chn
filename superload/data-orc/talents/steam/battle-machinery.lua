local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_EXPLOSIVE_STEAM_ENGINE",
	name = "Explosive Steam Engine",
	info = function(self, t)
		return ([[Throw a small, unstable steam engine on the battlefield that will go critical after 2 turns.
		It will then create an explosion of hot vapour in radius %d, burning all foes for %0.2f fire damage.
		Any bleeding foe caught in the flames will take 40%% more damage.
		Damage scales with your Steampower.
		#{italic}#Tick Tock Tick BOOM!#{normal}#]])
		:format(self:getTalentRadius(t), damDesc(self, DamageType.FIRE, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_LINGERING_CLOUD",
	name = "Lingering Cloud",
	info = function(self, t)
		return ([[Explosive Steam Engine vapour now lingers for 5 turns.
		Each turn, bleeding foes inside the cloud will take %0.2f fire damage.
		Any steamtech-using creature will also regenerate %d additional steam per turn while inside the cloud.
		Damage scales with your Steampower.
		#{italic}#Modern technology at the service of burnination!#{normal}#]])
		:format(damDesc(self, DamageType.FIRE, t.getDamage(self, t)), t.getRegen(self, t))
	end,}

registerTalentTranslation{
	id = "T_TREMOR_ENGINE",
	name = "Tremor Engine",
	info = function(self, t)
		return ([[Throw a tremor engine on the battlefield that will trigger after 2 turns.
		For 5 turns after triggering, it will constantly shake the ground and stun, pin, or disarm any creature in radius %d for %d turns.
		#{italic}#The ground is mere paper to you!#{normal}#]])
		:format(self:getTalentRadius(t), t.getDur(self, t))
	end,}


registerTalentTranslation{
	id = "T_SEISMIC_ACTIVITY",
	name = "Seismic Activity",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[On its last pulse, your Tremor Engine shakes violently, raising a volcano for %d turns.
		Each turn, the volcano will send out fiery boulders that deal %0.2f fire and %0.2f physical damage.
		Damage scales with your Steampower.
		#{italic}#All the fury of fire at your disposal!#{normal}#]])
		:format(t.getDur(self, t), damDesc(self, DamageType.FIRE, dam/2), damDesc(self, DamageType.PHYSICAL, dam/2))
	end,}

