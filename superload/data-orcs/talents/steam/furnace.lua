local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FURNACE",
	name = "Furnace",
	info = function(self, t)
		local damageinc = t.getFireDamageIncrease(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		return ([[You add a portable furnace to your steam generators.
		While it is active your fire and physical damage increases by %d%% and your fire and physical resistance penetration by %d%%.
		#{italic}#Burninate all with awesome Steam power!#{normal}#
		]]):
		format(damageinc, damageinc, ressistpen, ressistpen)
	end,}

registerTalentTranslation{
	id = "T_MOLTEN_METAL",
	name = "Molten Metal",
	info = function(self, t)
		local reduction = 1
		local mp = self:hasEffect(self.EFF_FURNACE_MOLTEN_POINT)
		if mp then reduction = 0.75 ^ mp.stacks end
		return ([[Your armour is so hot from the furnace it dissipates parts of all energy based attacks against you.
		All non physical, non mind damage is reduced by %d (current %d).
		Each turn this happens you gain a molten point (up to 10), decreasing the efficiency of the reduction by 25%%.
		Molten points are removed upon running or resting.
		#{italic}#Hot liquid metal, the fun!#{normal}#
		]]):format(t.getResist(self, t), t.getResist(self, t) * reduction)
	end,}


registerTalentTranslation{
	id = "T_FURNACE_VENT",
	name = "Furnace Vent",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local mp = self:hasEffect(self.EFF_FURNACE_MOLTEN_POINT)
		local stacks = mp and mp.stacks or 0
		return ([[Open the vents on your furnace, creating a conic blast dealing up to %0.2f fire damage at 10 molten points (currently %0.2f).
		All molten points are consumed.
		The damage will increase with your Steampower.
		#{italic}#By fire be purged!#{normal}#
		]]):
		format(damDesc(self, DamageType.FIRE, damage), damDesc(self, DamageType.FIRE, damage) * stacks / 10)
	end,}

registerTalentTranslation{
	id = "T_MELTING_POINT",
	name = "Melting Point",
	info = function(self, t)
		return ([[When you reach 10 molten points your armour overheats, reaching temperatures so high that they cauterize up to %d detrimental physical effects on you.
		A special medical injector injects you with a fire immunity serum at that precise moment to make you immune to the burning effect.
		When this happens all molten points are consumed and trigger a Furnace Vent at the creature that triggered the last molten point.
		This effect drains 15 steam when triggered, and will not trigger if steam is too low.
		#{italic}#It's only a flesh burn!#{normal}#
		]]):
		format(t.getNb(self, t))
	end,}
return _M