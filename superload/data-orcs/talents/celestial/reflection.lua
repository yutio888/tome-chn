local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DIFFRACTION_PULSE",
	name = "Diffraction Pulse",
	info = function(self, t)
		return ([[Create a distortion at the target tile, knocking back all projectiles and changing their direction to face away if possible.]])
	end,}

registerTalentTranslation{
	id = "T_MIRROR_WALL",
	name = "Mirror Wall",
	info = function(self, t)
		local halflength = t.getHalflength(self, t)
		local duration = t.getDuration(self, t)
		return([[Creates a wall %d units long for %d turns, reflecting all projectiles that hit it and blocking sight.]]):
		format(halflength * 2 + 1, duration)
	end,}

registerTalentTranslation{
	id = "T_SPATIAL_PRISM",
	name = "Spatial Prism",
	info = function(self, t)
		return([[Target a projectile in mid-flight to clone it and target that projectile independently. You gain ownership over the new projectile.]])
	end,}

registerTalentTranslation{
	id = "T_MIRROR_SELF",
	name = "Mirror Self",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDam(self, t)
		local health = t.getHealth(self, t)
		return([[Summons a clone for %d turns which casts all the spells you cast, dealing %d%% damage and having %d%% health. Additionally, all light damage the clone deals becomes darkness damage and all darkness damage becomes light damage.]]):
		format(duration, damage * 100, health * 100)
	end,}