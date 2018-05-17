local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_CARRION_FEET",
	name = "Carrion Feet",
	info = function(self, t)
		return ([[Your feet start to continuously produce carrion worms that are constantly crushed as you walk, passively increasing movement speed by %d%%.
		You can also activate this talent to instantly destroy more worms, letting you jump in range %d to visible terrain.
		Upon landing you crush more worms, creating a radius 2 cone of gore; any creatures caught inside deals 70%% less damage for one turn.
		If at least 1 enemy is effected by the cone you gain an additional 20 insanity.]]):
		format(t.getPassiveSpeed(self, t)*100, self:getTalentRange(t))
	end,
}

registerTalentTranslation{
	name = "Horrific Evolution",
	id = "T_DECAYING_GUTS",
	info = function(self, t)
		return ([[Your mutations have enhanced your offense even farther.
		You gain %d Accuracy and %d Spellpower.
		The effects will increase with your Magic stat.]])
		:format(t.getAccuracy(self, t), t.getSpellpower(self, t))
	end,
}

registerTalentTranslation{
	name = "Overgrowth", 
	id = "T_CULTS_OVERGROWTH",
	info = function(self, t)
		return ([[You trigger a cascade of rapidly mutating cells in your body for %d turns.
		Your body grows much bigger, gaining 2 size categories, making you able to walk through walls and increasing all your damage by %d%% and all your resistances by %d%%.
		Each time you take a step your monstrous form causes a small quake destroying and rearranging nearby terrain.]]):
		format(t.getDur(self, t), t.getDam(self, t), t.getResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WRITHING_ONE",
	name = "Writhing One",
	info = function(self, t)
		return ([[At last you unlock the true power of your mutated body!
		You gain %d%% stun immunity, %d%% chances to ignore critical strikes and your darkness and blight damage are increased by %d%%.]]):
		format(t.getImmunities(self, t) * 100, t.getCritResist(self, t), t.getDam(self, t))
	end,
}

return _M
