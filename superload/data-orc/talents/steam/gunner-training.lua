local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STEAMGUN_MASTERY",
	name = "Steamgun Mastery",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		local reloads = t.ammo_mastery_reload(self, t)
		return ([[Increases Physical Power by %d and increases weapon damage by %d%% when using steamguns.
		Also, increases your reload rate by %d.]]):format(damage, inc * 100, reloads)
	end,}

registerTalentTranslation{
	id = "T_DOUBLE_SHOTS",
	name = "Double Shots",
	info = function(self, t)
		return ([[In an overpowering display of marksmanship, you fire your steamgun(s) twice in rapid succession.
Each shot (targeted separately) deals %d%% damage and stuns its target for %d turns.
		The stun chance increases with your Steampower.]]):format(100 * t.getMultiple(self, t), t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_UNCANNY_RELOAD",
	name = "Uncanny Reload",
	info = function(self, t)
		return ([[You focus on managing your steamgun ammo for %d turns.
		While the effect lasts your attacks do not consume shots.]])
		:format(t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_STATIC_SHOT",
	name = "Static Shot",
	info = function(self, t)
		return ([[You fire a special, electrically charged shot with your steamgun(s) at a spot within range.
		When each shot reaches its target, it bursts into electrified shrapnel within radius %d, which shocks each target hit and deals %d%% weapon damage as lightning.
		Shocked targets lose up to %d non-magical effects (for the first shot that hits).
		This talent does not use ammo.]])
		:format(self:getTalentRadius(t), 100 * t.getMultiple(self, t), t.getRemoveCount(self, t))
	end,}
