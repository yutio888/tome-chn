local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STEAMSAW_MASTERY",
	name = "Steamsaw Mastery",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[Increases Physical Power by %d and increases weapon damage by %d%% when using steamsaws.]])
		:format(damage, inc * 100)
	end,}

registerTalentTranslation{
	id = "T_OVERHEAT_SAWS",
	name = "Overheat Saws",
	info = function(self, t)
		return ([[Channel hot steam around your saws, burning foes you strike in melee for %0.2f fire damage over 3 turns (which can stack)!
		#{italic}#Hot, steamy maiming!#{normal}#]])
		:format(damDesc(self, DamageType.FIRE, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TEMPEST_OF_METAL",
	name = "Tempest of Metal",
	info = function(self, t)
		return ([[Continuously swing your steamsaws around you, dealing %d%% weapon damage to adjacent foes each turn.
		Your chaotic motions make it difficult for anything to hit you, granting %d%% chance to completely negate all damage.
		Damage avoidance chance increases with Steampower.
		#{italic}#Make the metal talk!#{normal}#]])
		:format(30, t.getEvasion(self, t))
	end,}

registerTalentTranslation{
	id = "T_OVERCHARGE_SAWS",
	name = "Overcharge Saws",
	info = function(self, t)
		return ([[You temporarily overcharge the saw motors, increasing the effective talent level of all saw talents by %d%% for %d turns.]])
		:format(t.getPower(self, t), t.getDur(self, t))
	end,}
