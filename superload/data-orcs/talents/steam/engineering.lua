local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_EMERGENCY_STEAM_PURGE",
	name = "Emergency Steam Purge",
	info = function(self, t)
		return ([[You open all steam valves at once, releasing a radius %d wave of superheated steam around yourself which deals %0.2f fire damage.
		If you had at least 50 steam, the vapours will be so hot that they can burn sensory organs, blinding affected creatures for %d turns.
		The effects scale with your current steam value; at 1 steam they are only 15%% as effective as at 100 (current factor %d%%).]])
		:format(self:getTalentRadius(t), damDesc(self, DamageType.FIRE, t.getDamage(self, t)), t.getDur(self, t), t.getFactor(self, t) * 100)
	end,}

registerTalentTranslation{
	id = "T_INNOVATION",
	name = "Innovation",
	info = function(self, t)
		return ([[Your knowledge of physical laws allows you to use and improve equipment in ways their creators never dreamed.
		Increases all stats, saves, armour, and defense bonuses by %d%% on equipment that is crafted by a master or powered by steamtech.]])
		:format(t.getFactor(self, t))
	end,}

registerTalentTranslation{
	id = "T_SUPERCHARGE_TINKERS",
	name = "Supercharge Tinkers",
	info = function(self, t)
		return ([[Using a huge amount of steam, you temporarily supercharge your tinkers and other steam-powered talents.
		For %d turns, you gain %d steampower and %d%% steamtech critical chance.]])
		:format(t.getDur(self, t), t.getBoost(self, t))
	end,}

registerTalentTranslation{
	id = "T_LAST_ENGINEER_STANDING",
	name = "Last Engineer Standing",
	info = function(self, t)
		return ([[Sometimes, being a master tinker requires taking risks; yours are more calculated than others.
		Gain %d cunning, %d physical save, %d%% resistance to self-inflicted damage, and %d%% chance to avoid being critically hit.]])
		:format(self:getTalentLevel(t) * 2, t.physSave(self, t), t.selfResist(self, t), t.critResist(self, t))
	end,}
return _M