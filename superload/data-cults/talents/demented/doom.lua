local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_PROPHECY",
	name = "Prophecy",
	info = function(self, t)
		local mcd = t.getMadnessCooldown(self,t)*100
		local rdam = t.getRuinDamage(self,t)
		local tchance = t.getTreasonChance(self,t)
		--local tdam = t.getTreasonDamage(self,t)
		return ([[By bringing the forces of entropy to bear on a target, you prophesize their inevitable doom. Each point in this talent unlocks additional prophecies. A target can only be affected by a single prophecy at a time.
Level 1: Prophecy of Madness. Increases talent cooldowns by %d%%.
Level 3: Prophecy of Ruin. Deals %d damage on falling below 75%%, 50%% or 25%% of maximum life.
Level 5: Prophecy of Treason: %d%% chance each turn to attack an ally or themselves.]]):
		format(mcd, rdam, tchance)
	end,
}

-- These may need to be implemented differently to avoid talent level scaling bugs
registerTalentTranslation{
	id = "T_PROPHECY_OF_MADNESS",
	name = "Prophecy of Madness",
	info = function(self, t)
		local cd = t.getCooldown(self,t)*100
		return ([[Utter a prophecy of the impending madness of your target, increasing the cooldown of all their talents by %d%% for 6 turns.
		A target can only be affected by a single prophecy at a time.]]):format(cd)
	end,
}

registerTalentTranslation{
	id = "T_PROPHECY_OF_RUIN",
	name = "Prophecy of Ruin",
	info = function(self, t)
		local dam = t.getDamage(self,t)
		return ([[Utter a prophecy of the impending demise of your target that lasts 6 turns.
		Each time their life falls below 75%%, 50%% or 25%% of maximum the power of the prophecy will echo outwards, inflicting %d darkness damage to them.
		A target can only be affected by a single prophecy at a time.
		The damage increase will increase with your Spellpower.]]):format(dam)
	end,
}

registerTalentTranslation{
	id = "T_PROPHECY_OF_TREASON",
	name = "Prophecy of Treason",
	info = function(self, t)
		local chance = t.getChance(self,t)
		return ([[Utter a prophecy of the impending treachery of your target. For the next 6 turns, they will have a %d%% each turn to waste their turn attempting to attack an adjacent creature for 10%% weapon damage, or even themself if no creature is present.
		A target can only be affected by a single prophecy at a time.]]):format(chance)
	end,
}

registerTalentTranslation{
	id = "T_GRAND_ORATION",
	name = "Grand Oration",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local talent = self:isTalentActive(t.id) and self:getTalentFromId(self:isTalentActive(t.id).talent).name or "None"		
		return ([[You speak a chosen prophecy to the masses. When applying this prophecy, it will spread to all targets in radius %d.
		A prophecy can only be affected by one of Grand Oration, Twofold Curse or Revelation.
		
		Current prophecy: %s]]):
		format(rad, talent)
	end,
}

registerTalentTranslation{
	id = "T_TWOFOLD_CURSE",
	name = "Twofold Curse",
	info = function(self, t)
		local talent = self:isTalentActive(t.id) and self:getTalentFromId(self:isTalentActive(t.id).talent).name or "None"		
		return ([[Weave your chosen prophecy into your speech, dooming your foe twice over. The chosen prophecy will apply instantly to your primary target whenever you cast any other prophecy at talent level %d.
		A prophecy can only be affected by one of Grand Oration, Twofold Curse or Revelation.
		
		Current prophecy: %s]]):
		format(self:getTalentLevel(t), talent)
	end,
}

registerTalentTranslation{
	id = "T_REVELATION",
	name = "Revelation",
	info = function(self, t)
		local madness = t.getMadness(self,t)
		local ruin = t.getRuin(self,t)
		local treason = t.getTreason(self,t)
		local talent = self:isTalentActive(t.id) and self:getTalentFromId(self:isTalentActive(t.id).talent).name or "None"
		return ([[As you speak the chosen prophecy, whispers from the void guide you in how to bring about the downfall of your foe. The chosen prophecy will grant you one of the following effects for 10 turns.
		Prophecy of Madness. Each time the target uses a talent, one of your talents on cooldown has it’s cooldown reduced by %d turns.
		Prophecy of Ruin. Each time the target takes damage, you are healed for %d%% of the damage dealt.
		Prophecy of Treason: %d%% of all damage you take is redirected to a random target affected by the damage link.
		A prophecy can only be affected by one of Grand Oration, Twofold Curse or Revelation.
	
		Current prophecy: %s]]):
		format(madness, ruin, treason, talent)
	end,
}

return _M
