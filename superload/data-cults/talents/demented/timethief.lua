local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ACCELERATE",
	name = "Accelerate",
	info = function(self, t)
		local dur = t.getDuration(self, t)
		local speed = t.getSpeed(self, t)
		return ([[Distorting spacetime around yourself, you reduce the movement speed of all enemies in radius 7 by 50%% for %d turns.
You use the siphoned speed to grant yourself incredible quickness for 1 turn, increasing movement speed by %d%%, increased by a further %d%% for each enemy slowed, to a maximum of 4.
Any actions other than movement will cancel the effect.]]):
		format(dur, speed, speed/8)
	end,
}

registerTalentTranslation{
	id = "T_SWITCH",
	name = "Switch",
	info = function(self, t)
		local nb = t.getNb(self,t)
		local dur = t.getDuration(self,t)
		return ([[Release a surge of entropy, cleansing yourself of afflictions while draining the energy from others. All enemies in range 10 will have the duration of %d beneficial effects reduced by %d turns, while you will have an equal number of detrimental effects reduced by the same duration.]]):
		format(nb, dur)
	end,
}

registerTalentTranslation{
	id = "T_SUSPEND",
	name = "Suspend",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local dur = t.getDuration(self,t)
		return ([[You and all enemies within radius %d will be frozen in time for %d turns, preventing you from taking any action but preventing any damage taken.
For yourself, negative effects and cooldowns will decrease in duration, while beneficial effects will remain at their current duration.
For enemies, negative effects and cooldowns will not decrease, while beneficial effects decrease in duration.]]):format(rad, dur)
	end,
}

registerTalentTranslation{
	id = "T_SPLIT",
	name = "Split",
	info = function(self, t)
		local dur = t.getDuration(self, t)
		local power = t.getPower(self,t)
		local res = 80 - power
		local dam = 40 + power
		local life = 20 + power
		return ([[The target enemy will be partially removed from the normal flow of time for %d turns, inhibiting their ability to interact with the world. All damage taken will be reduced by %d%%, while all damage dealt will be reduced by %d%%.
While active, you form the frayed threads of their timeline into a temporal clone of them for the same duration, which assists you in combat. This clone is identical, but has %d%% reduced life and deals %d%% damage.]]):
		format(dur, res, dam, life, dam)
	end,
}
return _M
