local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CELESTIAL_ACCELERATION",
	name = "Celestial Acceleration",
	info = function(self, t)
		local posFactor = t.getPosFactor(self, t)
		local negFactor = t.getNegFactor(self, t)
		local cap = t.getCap(self, t)
		return ([[Increases your movement speed by %0.2f%% per percent of positive energy and your casting speed by %0.2f%% per percent of negative energy, up to a maximum of %0.2f%% at 80%%. Sustained energy still counts toward the maximum.]]):
		format(posFactor * 100, negFactor * 100, cap * 100)
	end,}

registerTalentTranslation{
	id = "T_POLARIZATION",
	name = "Polarization",
	info = function(self, t)
		local regeneration = t.getRegen(self, t)
		local positive_rest = (self:attr("positive_at_rest") or 0)/100*self:getMaxPositive()
		local negative_rest = (self:attr("negative_at_rest") or 0)/100*self:getMaxNegative()
		return ([[Whichever of your positive and negative energies is a higher percentage regenerates towards its max instead of its normal resting value (%d positive, %d negative). Your negative and positive regeneration/degeneration rates are increased to %0.2f.]]):
		format(positive_rest, negative_rest, regeneration)
	end,}

registerTalentTranslation{
	id = "T_MAGNETIC_INVERSION",
	name = "Magnetic Inversion",
	info = function(self, t)
		return ([[Swap your current positive and negative energy levels. This spell takes no time to cast.]])
	end,}

registerTalentTranslation{
	id = "T_PLASMA_BOLT",
	name = "Plasma Bolt",
	info = function(self, t)
		local dam = t.getRawDam(self, t)
		local negpart = t.getNegPart(self, t)
		local radius = self:getTalentRadius(t)
		local slow = 100 * t.getSlow(self, t)
		return ([[Fires out a bolt of pure energy, dealing %0.2f light and %0.2f darkness damage in a radius of %d, and slowing targets hit. Their movement is reduced by %d%% and attacking, casting and mind attacks by %d%%. The bolt will attune to your current positive and negative energy amounts.]]):
		format(damDesc(self, DamageType.LIGHT, dam * (1 - negpart)), damDesc(self, DamageType.DARKNESS, dam * negpart), radius, slow * negpart, slow * 0.6 * (1 - negpart))
	end,}