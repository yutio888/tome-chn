local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MASSIVE_PHYSIQUE",
	name = "Massive Physique",
	info = function(self, t)
		return ([[Working iron has honed your body into an amazing shape, granting %d strength and constitution.
		At talent level 5, you are so incredibly built that you gain one size category.]])
		:format(2 * self:getTalentLevel(t))
	end,}

registerTalentTranslation{
	id = "T_ENDLESS_ENDURANCE",
	name = "Endless Endurance",
	info = function(self, t)
		return ([[Working long hours at a forge has made you incredibly slow to tire and given you endless vitality.
		Your healing factor is increased by %d%% and your life regeneration by %0.2f.
		Stopping you is nearly impossible; your pinning resistance is increased by %d%%.]])
		:format(self:getTalentLevel(t) * 2, self:getTalentLevel(t), self:getTalentLevel(t) * 15)
	end,}

registerTalentTranslation{
	id = "T_LIFE_IN_THE_FLAMES",
	name = "Life in the Flames",
	info = function(self, t)
		return ([[Slaving for many years at the forge has made you more resilient to physical pain and fire burns.
		Your fire resistance is increased by %d%% and your physical resistance by %d%%.
		At talent level 5, you are so accustomed to the flames that you become immune to the fireburn effect.]])
		:format(self:getTalentLevel(t) * 5, self:getTalentLevel(t) * 3)
	end,}

registerTalentTranslation{
	id = "T_CRAFTS_EYE",
	name = "Craftsman's Eye",
	info = function(self, t)
		return ([[You can easily see the weak points in your enemy's defenses. After all, you know to look for the same flaws in your own work.
		This grants %d armour penetration and %d%% critical strike multiplier.
		At talent level 5, you can also fight stealthed and invisible creatures without penalty.]])
		:format(self:getTalentLevel(t) * 4, self:getTalentLevel(t) * 5)
	end,}
