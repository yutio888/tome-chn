local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MECHANICAL_ARMS",
	name = "Mechanical Arms",
	info = function(self, t)
		return ([[Using psionic forces you maintain in place on your back two giant horrific mechanical arms.
		Each turn they can automatically attack up to 2 foes within range 3 with a mindstar attack doing %d%% weapon damage.
		Creatures harassed by the mechanical arms have their damage reduced by %d%% for 5 turns.]]):
		format(t.getDam(self, t) * 100, t.getReduction(self, t))
	end,}

registerTalentTranslation{
	id = "T_LUCID_SHOT",
	name = "Lucid Shot",
	info = function(self, t)
		return ([[Fire a powerful shot at a foe doing %d%% weapon damage.
		If the creature, or any creatures in radius 3, was affected by a fear or nightmare effect it violently wakes up, shaking it off only to find itself disoriented, unable to discern friends from foes for %d turns.]])
		:format(100 * t.getDam(self, t), t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_PSY_WORM",
	name = "Psy Worm",
	info = function(self, t)
		return ([[Fire a psionic-enhanced shot at a foe doing %d%% mind weapon damage and infecting it with a psy worm for 8 turns.
		Each turn the worm will do %0.2f mind damage and restore %d psi to you, double if stunned or feared.
		Also each turn the worm has 25%% chances to spread to a nearby foe in radius 3.
		When a creature infected by Psy Worm dies it spreads to all enemies in a radius of 3.]])
		:format(100 * t.getDam(self, t), damDesc(self, DamageType.MIND, t.getWorm(self, t)), t.getPsi(self, t))
	end,}

registerTalentTranslation{
	id = "T_NO_HOPE",
	name = "No Hope",
	info = function(self, t)
		return ([[Entering the mind of your foe you manipulate it to make it loose hope of defeating you, reducing all its damage by 40%% for %d turns.]]):
		format(t.getDur(self, t))
	end,}
