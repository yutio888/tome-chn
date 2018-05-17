local _M = loadPrevious(...)
local Object = require "mod.class.Object"

registerTalentTranslation{
	id = "T_MUTATED_HAND",
	name = "Mutated Hand",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		local allow_tcombat = t.canTentacleCombat(self, t)
		local tcombat = {combat=t.getTentacleCombat(self, t, true)}
		local tcombatdesc = Object:descCombat(self, tcombat, {}, "combat")
		return ([[Your left hand mutates into a disgusting mass of tentacles.
		When you have your offhand empty you automatically hit your target and those on the side whenever you hit with a basic attack.
		Also increases Physical Power by %d, and increases weapon damage by %d%% for your tentacles attacks.
		Each time you make an attack with your tentacle you gain %d insanity.
		You generate a low power psionic field around you when around #{italic}#'civilized people'#{normal}# that prevents them from seeing you for the horror you are.

		Your tentacle hand currently has these stats%s:
		%s]]):
		format(damage, 100*inc, t.getInsanityBonus(self, t), allow_tcombat and "" or ", #CRIMSON# but is currently disabled due to non-empty offhand#WHITE#", tostring(tcombatdesc))
	end,
}

registerTalentTranslation{
	id = "T_LASH_OUT",
	name = "Lash Out",
	info = function(self, t)
		return ([[Spin around, extending your weapon and damaging all targets around you for %d%% weapon damage while your tentacle hand extends and hits all targets in radius 3 for %d%% tentacle damage.
				
				If the mainhand attack hits at least one enemy you gain %d insanity.
				If the tentacle attack hits at least one enemy you gain %d insanity.
		
		#YELLOW_GREEN#When constricting:#WHITE# Your tentacle attack is centered around your constricted target (but not your weapon attack) and only in radius 1 but it also dazes anything hit for 5 turns.]]):
		format(100 * t.getDamage(self, t), 100 * t.getDamageTentacle(self, t), t.getMHInsanity(self, t), t.getTentacleInsanity(self, t))
	end,
}

registerTalentTranslation{
	id = "T_TENDRILS_ERUPTION",
	name = "Tendrils Eruption",
	info = function(self, t)
		return ([[You plant your tentacle hand in the ground where it splits up and extends to a target zone of radius %d.
		The zone will erupt with many black tendrils to hit all foes caught inside dealing %d%% tentacle damage.
		Any creature hit by the tentacle must save against spell or be numbed by the attack, reducing its damage by %d%% for 5 turns.

		If at least one enemy is hit you gain %d insanity.

		#YELLOW_GREEN#When constricting:#WHITE#The tendrils pummel your constricted target for %d%% tentacle damage and if adjacent you make an additional mainhand weapon attack.  Talent cooldown reduced to 10.]]):
		format(self:getTalentRadius(t), t.getDamageTentacle(self, t) * 100, t.getNumb(self, t), t.getInsanity(self, t), t.getDamageTentacle(self, t) * 1.5 * 100)
	end,
}

registerTalentTranslation{
	name = "Constrict", 
	id = "T_TENTACLE_CONSTRICT",
	info = function(self, t)
		return ([[You extend your tentacle to grab a distant target, pulling it to you.
		As long as Constrict stays active the target is bound by your tentacle, it can try to move away but each turn you pull it back in 1 tile.
		While constricting you can not use your tentacle to enhance your normal attacks but you deal %d%% tentacle damage each turn to your target.
		Enemies can resist the attempt to pull them but Constrict will always work for purposes of modifying your talents.
		Your other tentacle talents may act differently when used while constricting (check their descriptions).]]):
		format(t.getDamageTentacle(self, t) * 100)
	end,
}

return _M
