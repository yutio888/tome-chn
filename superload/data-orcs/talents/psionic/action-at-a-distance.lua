local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CONDENSATE",
	name = "Condensate",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Condensate hot steam around your foes in radius %d, burning them for %0.2f fire damage and applying the wet effect for 4 turns, halving their stun resistances.
		The damage will increase with your Mindpower.]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.FIRE, damage))
	end,}

registerTalentTranslation{
	id = "T_SOLIDIFY_AIR",
	name = "Solidify Air",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[You concentrate your will in a cone in front of you, condensing the air into a tangible, solid form.
		Any creatures caught inside take %0.2f physical damage.
		Any places with no creatures will be filled with solid air, blocking the way for %d turns.
		The damage will increase with your Mindpower.]]):
		format(damDesc(self, DamageType.PHYSICAL, damage), t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_SUPERCONDUCTION",
	name = "Superconduction",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Call a streak of lightning on your target, dealing %0.2f to %0.2f lightning damage.
		If it is wet the lightning propagates to all foes in radius %d, doing the same damage to each.
		All affected foes are seared for 4 turns, reducing their fire resistance by %d%% and and mind save by %d.
		The damage will increase with your Mindpower.]]):
		format(damDesc(self, DamageType.LIGHTNING, damage) / 3, damDesc(self, DamageType.LIGHTNING, damage), self:getTalentRadius(t), t.getSearing(self, t), t.getSearing(self, t))
	end,}

registerTalentTranslation{
	id = "T_NEGATIVE_BIOFEEDBACK",
	name = "Negative Biofeedback",
	info = function(self, t)
		return ([[Any time your deal damage with a psionic ability you incur a negative biofeedback in your foes, stacking up to %d times for 5 turns.
		Each stack reduces their physical save by %d, defense and armour by %d.
		This effect may only occur once per turn.]]):
		format(t.getNb(self, t), t.getSave(self, t), t.getPower(self, t))
	end,}
