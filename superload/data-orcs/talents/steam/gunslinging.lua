local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STRAFE",
	name = "Strafe",
	info = function(self, t)
		local nb = t.getNb(self, t)
		return ([[You have learned to fire while moving.
		In one motion, you fire your double steamguns (100%% weapon damage, 1 tile range penalty) and may then move to an adjacent tile (unless pinned to the ground or immobilized).
		This talent can be activated for up to %d consecutive turns before it goes on cooldown, and takes time according to your steamtech speed or movement speed (if you move), whichever is slower.
		When Strafe ends you may instantly reload between %d and %d ammo (based on the number of strafes you performed and your ammo capacity).]]):
		format(nb, t.getReload(self, t, 1), t.getReload(self, t, nb + 1))
	end,}

registerTalentTranslation{
	id = "T_STARTLING_SHOT",
	name = "Startling Shot",
	info = function(self, t)
		return ([[You deliberately fire a missing shot at a target, startling it for 3 turns.
		If the target fails a mental save it instinctively recoils two steps back.
		The next shot that hits the startled creature will deal %d%% more damage.]])
		:format(100 * self:combatTalentWeaponDamage(t, 1.5, 3))
	end,}

registerTalentTranslation{
	id = "T_EVASIVE_SHOTS",
	name = "Evasive Shots",
	info = function(self, t)
		return ([[Using small engines to augment your reflexes you are able to automatically fire retaliatory shots at your foes doing %d%% weapon damage.
		Retaliation shots are fired when you evade/are missed by a melee or ranged attack.
		This can only happen once per turn and uses shots as normal.]])
		:format(100 * self:combatTalentWeaponDamage(t, 0.4, 1.5))
	end,}

registerTalentTranslation{
	id = "T_TRICK_SHOT",
	name = "Trick Shot",
	info = function(self, t)
		local main, ammo, off = self:hasDualArcheryWeapon("steamgun")
		local accy = main and ammo and self:combatAttackRanged(main.combat, ammo.combat) or 0
		local ricoaccy = 1-t.ricochetAccuracy(self, t)
		return ([[Your cunning and dexterity allow you to fire incredible trick shots that can hit multiple targets.
		You precisely aim your trick shot to ricochet amongst foes you can see so that whenever it hits something solid (creature or solid wall), it will bounce towards the next closest foe.
		It may ricochet up to %d times (or until it misses) within range 5 of your first target and will not target the same foe twice.
		Your shot deals %d%% weapon damage on its first strike, but loses %d%% damage and %d(%d%%) accuracy with each bounce.]]):
		format(t.getNb(self, t), 100 * t.damageMult(self, t), (1-t.ricochetDamage(self, t))*100, accy*ricoaccy, ricoaccy*100)
	end,}
return _M