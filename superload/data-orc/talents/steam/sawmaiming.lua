local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TO_THE_ARMS",
	name = "To The Arms",
	info = function(self, t)
		return ([[Hits the target on the arms with one rotating saw doing %d%% damage and trying to maim it for %d turns.
		Maimed foes deal %d%% less damage.
		The chance improves with your Physical power.
		#{italic}#Cutting your foes has never been so simple!#{normal}#]]):
		format(100 * self:combatTalentWeaponDamage(t, 1, 1.6), t.getDuration(self, t), t.getMaim(self, t))
	end,}

registerTalentTranslation{
	id = "T_BLOODSTREAM",
	name = "Bloodstream",
	info = function(self, t)
		return ([[You "gently" slam your saws into the wounds of a creature, dealing %d%% weapon damage and deepening the wounds.
		All bleeding wounds durations are increased by %d turns and the damage by %d%% (this may be done only once per bleeding effect).
		When this happens a gush of blood is projected in a narrow cone of radius 4, dealing %0.2f physical damage to all creatures.
		The power and damage improves with your Steampower.
		#{italic}#The marvels of technology, now at the service of true butchery!#{normal}#]]):
		format(self:combatTalentWeaponDamage(t, 0.3, 1.1) * 100, t.getDuration(self, t), t.getDamageInc(self, t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_SPINAL_BREAK",
	name = "Spinal Break",
	info = function(self, t)
		return ([[You try to sever the spine of your foe, reducing its global speed by %d%% for 4 turns and dealing %d%% weapon damage.
		The power of the blow also removes up to %d physical effects.
		If your talent level is at least 3 %d physical or magical sustains are also removed.
		#{italic}#Break them, grind them, mow them down!#{normal}#]]):
		format(t.getSlow(self, t) * 100, self:combatTalentWeaponDamage(t, 0.6, 1.5) * 100, t.getRemoveCount(self, t), t.getRemoveCount(self, t))
	end,}


registerTalentTranslation{
	id = "T_GORESPLOSION",
	name = "Goresplosion",
	info = function(self, t)
		return ([[When you kill a foe you place small explosives with shrapnels inside its body, making it explode in radius %d.
		Any foes hit will bleed for %0.2f damage per turn for 6 turns. The shrapnels also damage the vocal cords (or related organ), silencing them for %d turns.
		#{italic}#Use the finest of wartech now: shrapnels. For blood and mayhem!#{normal}#]]):
		format(self:getTalentRange(t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t) / 6), t.getDuration(self, t))
	end,}

