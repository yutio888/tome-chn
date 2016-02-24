local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SLIP_AWAY",
	name = "Slip Away",
	info = function(self, t)
		return ([[Using small steam motors to enhance your movements, you are able to slip past up to %d foes in a line.
		After passing the targets, you will quickly run %d tiles away.]])
		:format(t.getRange(self, t), t.getAway(self, t))
	end,}

registerTalentTranslation{
	id = "T_AGILE_GUNNER",
	name = "Agile Gunner",
	info = function(self, t)
		local p = self:isTalentActive(t.id)
		local cur = 0
		if p then cur = math.min(p.nb_foes, t.getMax(self, t)) * 20 end
		return ([[The thrill of the hunt invigorates you. For each foe in radius %d around you, you gain 20%% movement speed (up to %d%%).
		Current bonus: %d%%.]])
		:format(self:getTalentRadius(t), t.getMax(self, t) * 20, cur)
	end,}

registerTalentTranslation{
	id = "T_AWESOME_TOSS",
	name = "Awesome Toss",
	info = function(self, t)
		return ([[In an awesome feat of agility and technological prowess, you toss both of your steamguns in the air, causing them to spin madly for 3 turns.
		Each turn, they will fire twice at random targets in range, dealing %d%% weapon damage.
		While the guns are airborne, you are disarmed and cannot attack.
		The spectacle is so distracting that your foes have a hard time concentrating on you, increasing all of your resistances by %d%%.]])
		:format(100 * t.getMultiple(self, t), t.getResist(self, t))
	end,}

registerTalentTranslation{
	id = "T_DAZZLING_JUMP",
	name = "Dazzling Jump",
	info = function(self, t)
		return ([[While your foes are distracted by your Awesome Toss, you use powerful steam motors to jump into the air and kick a target %d tiles away.
		The impact is so great that it ripples outwards, slowing all creatures in radius 3 by %d%% for 4 turns while the reaction force propels you %d tiles backwards.]])
		:format(t.getRange(self, t), t.getSlow(self, t), t.getAway(self, t))
	end,}
