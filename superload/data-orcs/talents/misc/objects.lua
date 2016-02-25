local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_OVERGROWTH",
	name = "Overgrowth",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local slow = t.getSlow(self, t)
		local pin = t.getPin(self, t)
		local radius = self:getTalentRadius(t)
		return ([[Instantly grow a moss circle of radius %d at target area.
		Each turn the moss deals %0.2f nature damage to each foe within its radius.
		This moss is very thick and sticky causing all foes passing through it have their movement speed reduced by %d%% and have a %d%% chance to be pinned to the ground for 4 turns.
		The moss lasts %d turns.
		Moss talents are instant but place all other moss talents on cooldown for 3 turns.
		The damage will increase with your Mindpower.]]):
		format(radius, damDesc(self, DamageType.NATURE, damage), slow, pin, duration)
	end,
}

registerTalentTranslation{
	id = "T_TALOSIS_CEASEFIRE",
	name = "Ceasefire",
	info = function(self, t)
		return ([[You fire an incredibly potent shot at an enemy, doing %d%% damage and dazing them for %d turns.
		The daze chance increases with your Steampower.]]):format(100 * self:combatTalentWeaponDamage(t, 1, 1.8), t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_GUN_SUREKILL",
	name = "Surekill",
	info = function(self, t)
		return ([[You fire an exceptionally lethal shot at an enemy, doing %d%% damage.
Damage dealt by this talent is increased by half your critical multiplier, if doing so would kill the target.]]):format(100 * self:combatTalentWeaponDamage(t, 1, 1.8))
	end,}

registerTalentTranslation{
	id = "T_ROCKET_SMASH",
	name = "Rocket Smash",
	info = function(self, t)
		return ([[Dash forward using rockets.
		If the spot is reached and occupied, you will perform a free melee attack against the target there and knock them back 4 spaces as well as anyone else they collide with.
		This attack does 180% weapon damage.
		You must dash from at least 2 tiles away.]])
	end,}

return _M