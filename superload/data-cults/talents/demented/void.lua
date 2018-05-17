local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_VOID_STARS",
	name = "Void Stars",
	info = function(self, t)
		local power = t.getReduction(self,t)*100
		local regen = t.getRegen(self,t)
		return ([[Conjure void stars that orbit you, defending you from incoming attacks. Each time an attack deals more than 10%% of your maximum life, a star will be consumed to reduce the damage taken by %d%%, of which 40%% will be dealt to you as entropic backlash.
		You regenerate 1 star every %d turns, stacking up to 4 times.
		This talent will only function in light armor.]]):
		format(power, regen)
	end,
}

registerTalentTranslation{
	id = "T_NULLMAIL",
	name = "Nullmail",
	info = function(self, t)
		local armor = t.getArmor(self, t)
		local power = t.getAbsorb(self, t)
		return ([[Reinforce your armor with countless tiny void stars, increasing armor by %d.
Each time your void stars are fully depleted, you gain a shield absorbing the next %d damage taken within 4 turns. This shield cannot trigger again until your void stars are fully restored.]]):
		format(armor, power)
	end,
}

registerTalentTranslation{
	id = "T_BLACK_MONOLITH",
	name = "Black Monolith",
	info = function(self, t)
		return ([[Consuming a void star, you use it to summon a void monolith at the targeted location for %d turns. The monolith is very durable, and while immobile it will attempt to daze enemies within radius %d for 2 turns every half a turn using your spellpower.
			The monolith will gain %d life rating and %d%% all resist based on your Magic stat.]]):
		format(t.getDur(self, t), self:getTalentRadius(t), t.getLifeRating(self, t), t.getResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ESSENCE_REAVE",
	name = "Essence Reave",
	info = function(self, t)
		local damage = t.getDamage(self, t)/2
		local nb = t.getNb(self,t)
		return ([[You rend the very essence of the target, drawing on their life and converting it to void stars. The target takes %0.2f darkness and %0.2f temporal damage, and you gain %d void star(s).
		The damage will increase with your Spellpower.]]):
		format(damDesc(self, DamageType.DARKNESS, (damage)), damDesc(self, DamageType.TEMPORAL, (damage)), nb)
	end,
}
return _M
