local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WORM_THAT_WALKS_LINK",
	name = "Worm that Walks Link",
	info = function(self, t) return ([[Link to the summoner.]]) end,
}

registerTalentTranslation{
	id = "T_WORM_THAT_WALKS",
	name = "Worm that Walks",
	info = function(self, t)
		return ([[You invoke a long standing pact with a fellow horror, a Worm That Walks, to help you in your travels.
		You can fully control, level, and equip it.
		Using this spell will ressurect your friendly horror if it died, giving it back %d%% life.
		Higher raw talent levels will give your horror more equipment slots:

		Level 1:  Mainhand, Offhand
		Level 2:  Body
		Level 3:  Belt
		Level 4:  Ring, Ring
		Level 5:  Ring, Ring, Trinket

		To change your horror's equipment and talents first transfer the equipment from your inventory then take control of it.]]):
		format(t.getPower(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WORM_THAT_STABS",
	name = "Foul Convergence", 
	info = function(self, t)
		return ([[You and your worm that walks both teleport to an enemy in range %d and make a melee attack for %d%% damage.
			Your Worm that Walks Blindside talent cooldown is reduced by %d.]])
		:format(10, t.getDamage(self, t) * 100, t.getBlindside(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHARED_INSANITY",
	name = "Shared Insanity",
	info = function(self, t)
		return ([[You establish a powerful mental link with your worm that walks.
		As long as you remain within radius 3 of your worm that walks each of you gains %d%% all resistance for 3 turns.
		Additionally, your worm that walks permanently gains an inscription slot every 2 raw talent levels (%d).]])
		:format(t.getResist(self, t), t.getInscriptions(self, t))
	end,
}
	
registerTalentTranslation{
	id = "T_TERRIBLE_SIGHT",
	name = "Terrible Sight",
	info = function(self, t)
		return ([[While within range 3 of your worm that walk you can project an aura of terror.
		At the sight of two maddening horrors fighting together all your foes in radius %d must make a physical save against your spellpower or be stunned for %d turns.

		Additionally your Shared Insanity effect will cause enemies in radius 3 to lose %d spell save and %d defense for 3 turns.]]):
		format(self:getTalentRange(t), t.getDur(self, t), t.getSave(self, t), t.getSave(self, t))
	end,
}

return _M
