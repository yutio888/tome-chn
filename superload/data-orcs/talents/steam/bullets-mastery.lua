local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_OVERHEAT_BULLETS",
	name = "Overheat Bullets",
	info = function(self, t)
		return ([[By sending a stream of hot steam over your bullets you overheat them. For the next %d turns, each bullet will set the target ablaze, making it burn for %0.2f fire damage over 5 turns (most of your shooting talents fire two bullets at once).
		Damage will increase with Steampower.
		Only one bullet enhancement can be used at once.]]):
		format(t.getTurns(self, t), damDesc(self, DamageType.FIRE, t.getDam(self, t)))
	end,}

registerTalentTranslation{
	id = "T_SUPERCHARGE_BULLETS",
	name = "Supercharge Bullets",
	info = function(self, t)
		return ([[You are able to polish your bullets so well they can go through multiple targets for %d turns.
		This also improves their armour penetration by %d.
		Only one bullet enhancement can be used at once.]]):
		format(t.getTurns(self, t), t.getPower(self, t))
	end,}

registerTalentTranslation{
	id = "T_PERCUSSIVE_BULLETS",
	name = "Percussive Bullets",
	info = function(self, t)
		return ([[You swap your bullets for more massive ones for %d turns.
		When striking a creature, these bullets have a %d%% chance of knocking it back 3 tiles and a %d%% chance of stunning it for 3 turns.
		The chances to knockback and stun increase with your Steampower.
		Only one bullet enhancement can be used at once.]]):
		format(t.getTurns(self, t), t.getKBChance(self, t), t.getStunChance(self, t))
	end,}

registerTalentTranslation{
	id = "T_COMBUSTIVE_BULLETS",
	name = "Combustive Bullets",
	info = function(self, t)
		return ([[You coat your bullets with flammable materials, for the next %d turns each bullet will explode when it hits its target, dealing %0.2f fire damage to all foes within radius 2 (most of your shooting talents fire two bullets at once).
		Damage will increase with Steampower.
		Only one bullet enhancement can be used at once.]]):
		format(t.getTurns(self, t), damDesc(self, DamageType.FIRE, t.getDam(self, t)))
	end,}
