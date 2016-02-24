local _M = loadPrevious(...)

------------------------------------------------------------------
-- Yetis' powers
------------------------------------------------------------------

registerTalentTranslation{
	id = "T_ALGID_RAGE",
	name = "Algid Rage",
	info = function(self, t)
		return ([[Your yeti is attuned to the cold climates.
		For 5 turns all damage you deal has %d%% chances to encase the target in an iceblock for 3 turns.
		While Algid Rage is up you easily pierce through iceblocks, reducing the damage they absorb by 50%%.
		The bonus will increase with your Willpower.]]):
		format(t.getPower(self, t))
	end,}

registerTalentTranslation{
	id = "T_THICK_FUR",
	name = "Thick Fur",
	info = function(self, t)
		return ([[Your yeti's fur acts like a shield, providing %d%% cold resistance, %d%% physical resistance and %d magical save.]]):
		format(t.getCResist(self, t), t.getPResist(self, t), t.getSave(self, t))
	end,}

registerTalentTranslation{
	id = "T_RESILIENT_BODY",
	name = "Resilient Body",
	info = function(self, t)
		return ([[Your yeti's body is very resilient to detrimental effects.
		Each time you are hit by a physical, magical, or mental detrimental effect your body reacts with a burst of healing.
		This effect heals for %d and can only occur up to 3 times per turn.
		It increases with your Constitution stat.]]):
		format(t.heal(self, t))
	end,}

registerTalentTranslation{
	id = "T_MINDWAVE",
	name = "Mindwave",
	info = function(self, t)
		return ([[You willingly fry a few parts of your yeti's brain to trigger a huge psionic blast in cone of radius %d.
		Any foes caught in the blast will suffer %0.2f mind damage and be confused (35%% power) for %d turns.
		The damage will increase with your Constitution and the apply power will be the highest of your mind, spell, or physical power.]]):
		format(t.radius, t.getDamage(self, t), t.getDur(self, t))
	end,}

------------------------------------------------------------------
-- Whitehooves' powers
------------------------------------------------------------------
registerTalentTranslation{
	id = "T_WHITEHOOVES",
	name = "Whitehooves",
	info = function(self, t)
		return ([[Improves your undead body, increasing Strength and Magic by %d.
		Each time you move you gain a charge (up to %d) of death momentum, increasing your movement speed by 20%%.
		Each turn spent not moving you loose a charge.]])
		:format(t.statBonus(self, t), self:getTalentLevelRaw(t) + (self.DM_Bonus or 0))
	end,}

registerTalentTranslation{
	id = "T_DEAD_HIDE",
	name = "Dead Hide",
	info = function(self, t)
		return ([[Your undead skin hardens under stress. Each charge of death momentum also increases all flat damage resistance by %d.]]):
		format(t.getFlatResist(self, t))
	end,}

registerTalentTranslation{
	id = "T_LIFELESS_RUSH",
	name = "Lifeless Rush",
	info = function(self, t)
		return ([[You summon your undead energies to instantly build up death momentum to its maximum possible charges.
		The effect will only start to decrease after %d turns.
		In addition, the death momentum effect also grants +%d%% to all damage per charge.]]):
		format(t.getDur(self, t), t.getDam(self, t))
	end,}

registerTalentTranslation{
	id = "T_ESSENCE_DRAIN",
	name = "Essence Drain",
	info = function(self, t)
		return ([[You send a wave of darkness at your foe, dealing %0.2f darkness damage.
		The darkness will drain a part of it's life essence (only works on living targets) to increases the duration before the next charge of death momentum is used by %d.
		Only usable when you have the death momentum effect.
		The damage scales with your Magic stat.]]):
		format(t.getDamage(self, t), t.getDur(self, t))
	end,}
