




















	name = "Telekinetic Assault"
	info= function(self, t)
		return ([[Assault your target with all weapons, dealing two strikes with your telekinetically-wielded weapon for %d%% damage followed by an attack with your physical weapon for %d%% damage. 
		This physical weapon attack uses your Willpower and Cunning instead of Strength and Dexterity to determine Accuracy and damage.
		Any active Aura damage bonusses will extend to your main weapons for this attack.]]):
		format(100 * self:combatTalentWeaponDamage(t, 1.2, 1.9), 100 * self:combatTalentWeaponDamage(t, 1.5, 2.5))
	end

