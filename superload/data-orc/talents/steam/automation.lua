local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_PULSE_DETONATOR",
	name = "Pulse Detonator",
	info = function(self, t)
		return ([[Sends a pulse detonator to the target. Upon arrival it explodes in radius 4 cone, dealing %0.2f physical damage, knocking back foes by 3 and dazing them for %d turns.
		Damage increases with your steampower.]]):
		format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_FLYING_GRAPPLE",
	name = "Flying Grapple",
	info = function(self, t)
		return ([[You send a small steam-powered flying grapple to a target. The drone is homing so if the target moves it will follow.
		When it reaches its target it deploys grapples in all directions around it in radius 4.
		The grapples latch onto any foes and pull them toward the target. If they are stopped by a creature (or the target) both them and the creature take %0.2f physical damage.
		]]):format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,}


registerTalentTranslation{
	id = "T_NET_PROJECTOR",
	name = "Net Projector",
	info = function(self, t)
		return ([[Sends a lightly electrified net of radius 2 toward a target, all creatures caught inside will be pinned in place for 5 turns.
		While the electricity is not enough to do damage it does shock their body, reducing all resistances by %d%%.]]):
		format(t.getResist(self, t))
	end,}

registerTalentTranslation{
	id = "T_SAWFIELD",
	name = "Sawfield",
	info = function(self, t)
		return ([[For 4 turns many small saws circle around the target in radius %d, making any creature caught inside bleed for %0.2f physical damage.
		Damage increases with your steampower.]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,}
