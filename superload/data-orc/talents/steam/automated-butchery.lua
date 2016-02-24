local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CONTINUOUS_BUTCHERY",
	name = "Continuous Butchery",
	info = function(self, t)
		return ([[You attune your saws to a specific target for 5 turns.
		Each time you strike this target all damage done with steamsaws (including by other talents) is increased by +%d%%.
		If you strike any other foe the bonus ends.
		#{italic}#Metal your foes to death!#{normal}#]]):
		format(t.getInc(self, t))
	end,}

registerTalentTranslation{
	id = "T_EXPLOSIVE_SAW",
	name = "Explosive Saw",
	info = function(self, t)
		return ([[You send a saw mounted on an automated steam propulsor to assault a foe, dealing %0.2f physical damage each turn for 4 turns and silencing it.
		At the end of the duration, the saw explodes for %0.2f fire damage and flies back, pulling the target up to %d tiles towards you.
		The damage will increase with your Steampower.]]):
		format(damDesc(self, DamageType.PHYSICAL, t.getDamP(self, t)), damDesc(self, DamageType.FIRE, t.getDamF(self, t)), t.range(self, t))
	end,}

registerTalentTranslation{
	id = "T_MOW_DOWN",
	name = "Mow Down",
	info = function(self, t)
		return ([[When you kill a foe with a melee strike you quickly throw some of their remains in your steam engine, instantly regenerating %d steam.
		When you deal a critical melee strike you also have a %d%% chance to cut a part of your foe and use it in your steam engine.
		When either of those happens this strikes fear in all foes in radius 4 of the victim, brainlocking them for %d turns.
		#{italic}#To the meat grinder!#{normal}#]]):
		format(t.getRegen(self, t), t.getChance(self, t), t.getDur(self, t))
	end,}


registerTalentTranslation{
	id = "T_TECH_OVERLOAD",
	name = "Tech Overload",
	info = function(self, t)
		local inc = t.getIncrease(self, t)
		local talentcount = t.getTalentCount(self, t)
		local maxlevel = t.getMaxLevel(self, t)
		return ([[You override all security measures of your tinkers, allowing you to reset the cooldown of %d of most of your steamtech talents of tier %d or less and instantly increases your steam level by %d%% of the maximum.
		In addition for 6 turns your maximum steam capacity is doubled, but steam regeneration is halved.
		#{italic}#Master of Tech, Master of Death!#{normal}#]]):
		format(talentcount, maxlevel, inc)
	end,}

