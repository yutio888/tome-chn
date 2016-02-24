local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_AUTOMATED_CLOAK_TESSELLATION",
	name = "Automated Cloak Tessellation",
	info = function(self, t)
		return ([[You tessellate your cloak with small pieces of metal, providing %d damage reduction against all attacks.
		The myriad metal scraps also help against incoming projectiles, providing a %d%% chance of deflecting them to a nearby spot.]])
		:format(t.getArmor(self, t), t.getEvasion(self, t))
	end,}

registerTalentTranslation{
	id = "T_CLOAK_GESTURE",
	name = "Cloak Gesture",
	info = function(self, t)
		return ([[With a gesture of your cloak, you drop a small incendiary device in front of you, creating a wall of thick steam of %d length that burns creatures passing it for %0.2f fire damage and blocks sight for 5 turns.
		At level 5 the action is so perfect that your foes even lose track of you entirely.
		Damage increases with your steampower.]])
		:format(t.getLength(self, t), damDesc(self, DamageType.FIRE, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_EMBEDDED_RESTORATION_SYSTEMS",
	name = "Embedded Restoration Systems",
	info = function(self, t)
		return ([[Your cloak is lined with an automated health system that activate when no enemies are visible.
		When it triggers, you will be healed for %d life.
		At talent level 3, it will also remove one detrimental physical effect.
		The system can only trigger once every %d turns.]])
		:format(t.getHeal(self, t), t.getCD(self, t))
	end,}

registerTalentTranslation{
	id = "T_CLOAK",
	name = "Cloaking Device",
	info = function(self, t)
		return ([[Trigger an array of small mirrors to appear all over your cloak.
		The mirrors are positioned to reflect all light shining on you, granting %d stealth power for 10 turns.
		Stealth power increases with your steampower.]]):
		format(t.getStealth(self, t))
	end,}
