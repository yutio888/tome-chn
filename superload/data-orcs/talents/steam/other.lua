local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GLOBAL_MEDICAL_CD",
	name = "Medical Injector",
	info = function(self, t)
		return ""
	end,}

registerTalentTranslation{
	id = "T_MEDICAL_URGENCY_VEST",
	name = "Medical Urgency Vest",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[The medical urgency vest allows using therapeutics with %d%% efficiency and cooldown mod of %d%%.]])
		:format(data.power + data.inc_stat, data.cooldown_mod)
	end,}

registerTalentTranslation{
	id = "T_LIFE_SUPPORT",
	name = "Life Support",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[The life support suit allows using therapeutics with %d%% efficiency and cooldown mod of %d%%.]])
		:format(data.power + data.inc_stat, data.cooldown_mod)
	end,}

registerTalentTranslation{
	id = "T_CREATE_TINKER",
	name = "制造附着物",
	info = function(self, t)
		return ([[允许你制造附着物。]])
	end,}
--
--registerTalentTranslation{
--	id = "T_WEAPON_AUTOMATON_ONE_HANDED",
--	name = "Weapon Automaton: One Handed",
--	info = function(self, t)
--		return ([[Deploy a Weapon Automaton based on a selected one handed melee item.  The Automaton will wield the selected weapon and drop it when it times out or is destroyed.  Aside from the weapon selected, the Automaton will scale off Tinker talent levels, your own stats, and other things that will be described in this tooltip at some point.  
--		]]):format()
--	end,}

registerTalentTranslation{
	id = "T_TINKER_HAND_CANNON",
	name = "Hand Cannon",
	info = function(self, t)
		return ([[Fires your ammo at an enemy in range %d for %d%% weapon damage.  If this tinker is made of voratun you will fire an additional shot.
			This shot is a ranged melee attack but will use the ranged procs of your ammo as well.]]):
		format(self:getTalentRange(t), t.getDamage(self, t)*100)
	end,}

registerTalentTranslation{
	id = "T_TINKER_FATAL_ATTRACTOR",
	name = "Fatal Attractor",
	info = function(self, t)
		return ([[Quickly create a psionic-enhanced metal contraption that lures all your foes to it and reflects %d%% of the damage it takes to its attackers.
		The contraption will have %d life and last 5 turns.
		Damage, life, resists, and armor scale with your Steampower.]]):
		format(t.getReflection(self, t), t.getHP(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_ROCKET_BOOTS",
	name = "Rocket Boots", 
	info = function(self, t)
		return ([[Activate the rocket boots, firing huge flames from your boots increasing your movement speed by %d%%.
		Each movement will leave a trail of flames doing %0.2f fire damage for 4 turns.
		Doing any other actions will break the effect.
		#{italic}#Burninate them all!#{normal}#]]):
		format(100 * (0.5 + self:getTalentLevel(t) / 2), damDesc(self, DamageType.FIRE, t.getDam(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_IRON_GRIP",
	name = "Iron Grip", 
	info = function(self, t)
		return ([[Activate the pistons to crush your target for %d turns and dealing %d%% unarmed melee damage.
		While the target is held it can not move and its armour and defense are reduced by %d.
		#{italic}#Crush their bones!#{normal}#]]):
		format(t.getDur(self, t), self:combatTalentWeaponDamage(t, 1.2, 2.1) * 100, t.getReduc(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_SPRING_GRAPPLE",
	name = "Spring Grapple",
	info = function(self, t)
		return ([[Grab the target and pull them towards you, striking for %d%% unarmed melee damage, and if you hit, pinning them for %d turns.]]):
		format(self:combatTalentWeaponDamage(t, 0.8, 1.8) * 100, t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_TOXIC_CANNISTER_LAUNCHER",
	name = "Toxic Cannister Launcher", 
	info = function(self, t)
		return ([[Launch a cannister filled with toxic gas at a location.
		Every 2 turns the cannister emits a poison cloud of radius 3 around it each turn.
		The poison does %0.2f nature damage over 5 turns.
		The cannister has %d life and lasts 8 turns. When it ends or is destroyed a last cloud is created.
		Damage, life, resists, and armor scale with your Steampower.
		Damage and penetration are inherited from the creator.]]):
		format(damDesc(self, DamageType.NATURE, t.getDam(self, t)), t.getHP(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_POWERED_ARMOUR",
	name = "Steam Powered Armour",
	info = function(self, t)
		return ([[Activate the armour's active defense system.
		A flow of electricity covers your armour to attenuate the force of energy attacks while small steam engines move key pieces of the armour to attenuate physical attacks.
		All damage except mind damage is reduced by a flat %d.
		In addition the electric power of the armour sometimes leaks, each turn there is a 50%% chance to produce a electrical arc toward a foe, dealing %0.2f to %0.2f lightning damage to all foes in radius 1.
		The effects increase with your Steampower.]]):
		format(t.getRes(self, t), t.getDam(self, t) / 3, t.getDam(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_VIRAL_NEEDLEGUN",
	name = "Viral Needlegun",
	info = function(self, t)
		return ([[You fire a cone of blighted needles, hitting everything in a frontal cone of radius %d for %0.2f physical damage.
		Each creature hit has a %d%% chance of being infected by a random disease, doing %0.2f blight damage and reducing either Constitution, Strength or Dexterity by %d for 20 turns.
		The damage and disease effects increase with your Steampower.]]):format(self:getTalentRadius(t), damDesc(self, DamageType.PHYSICAL, t.damage(self, t)), t.diseaseChance(self, t), damDesc(self, DamageType.BLIGHT, t.diseaseDamage(self, t)), t.diseaseStat(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_SAND_SHREDDER",
	name = "Sand Shredder",
	info = function(self, t)
		return ([[You shred pieces of sandwalls. Brrrmmm!.]])
	end,}

registerTalentTranslation{
	id = "T_FLAMETHROWER",
	name = "Flamethrower",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[Throw a cone of flame with radius %d
		The damage will increase with your Steampower.]]):
		format(radius, damDesc(self, DamageType.FIRE, damage))
	end,}

registerTalentTranslation{
	id = "T_MASS_REPAIR",
	name = "Mass Repair",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		local radius = self:getTalentRadius(t)
		return ([[Throw a cone of healing with radius %d, healing other mechanical creatures (steam spiders) for %d.
		The healing will increase with your Steampower.]]):
		format(radius, heal)
--		format(radius, damDesc(self, DamageType.FIRE, damage))
	end,}

registerTalentTranslation{
	id = "T_TINKER_ARCANE_DISRUPTION_WAVE",
	name = "Arcane Disruption Wave",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		return ([[Let out a technopsionic wave that silences for %d turns all those affected in a radius of %d, including the user.
		The silence chance will increase with your Steampower.]]):
		format(t.getduration(self,t), rad)
	end,}

registerTalentTranslation{
	id = "T_TINKER_YEEK_WILL",
	name = "Mind Crush",
	info = function(self, t)
		return ([[Shatters the mind of your victim, giving you full control over its actions for 6 turns.
		When the effect ends, you pull out your mind and the victim's body collapses, dead.
		This effect does not work on rares, bosses, or undead.
		.]]):format()
	end,}

registerTalentTranslation{
	id = "T_TINKER_SHOCKING_TOUCH",
	name = "Shocking Touch",
	info = function(self, t)
		return ([[Touch a creature to release a nasty electrical charge into them, doing %0.2f lightning damage.
		If this tinker is above tier 1, the electricity can arc to another target up to 2 tiles away.
		The number of enemies hit is at most the tinker tier.
		The damage increases with your Steampower.]]):format(damDesc(self, DamageType.LIGHTNING, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_FLASH_POWDER",
	name = "Flash Powder",
	info = function(self, t)
		return ([[Throw a handful of dust that rapidly oxidises, releasing a blinding light.
		Creatures in a cone of radius %d are blinded for %d turns.
		The blindness effect is applied with your Steampower.]]):format(self:getTalentRadius(t), t.duration(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_ITCHING_POWDER",
	name = "Itching Powder",
	info = function(self, t)
		return ([[Throw a handful of dust that is very itchy to touch.
		Creatures in a cone of radius %d are itchy for %d turns, causing them to fail talents %d%% of the time.
		The itchiness effect is applied with your Steampower.]]):format(self:getTalentRadius(t), t.duration(self, t), t.failChance(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_THUNDER_GRENADE",
	name = "Thunder Grenade",
	info = function(self, t)
		return ([[Throw a grenade at your foes, dealing %0.2f physical damage in radius %d.
		Creatures hit will also be stunned for %d turns.
		The stun effect is applied with your Steampower.]]):format(t.getDamage(self, t), self:getTalentRadius(t), t.duration(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_PROJECT_SAW",
	name = "Project Saw",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[You activate hidden springs to project a saw towards your foes.
		Any creature caught in the beam takes %0.2f physical damage and bleeds for half more in 5 turns.
		The damage increases with your Steampower.]]):format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_VOLTAIC_BOLT",
	name = "Voltaic Bolt",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[Fires a bolt of lightning, doing %0.2f lightning damage.
		The damage will increase with your Steampower.]]):
		format(damDesc(self, DamageType.LIGHTNING, damage))
	end,}

registerTalentTranslation{
	id = "T_TINKER_VOLTAIC_SENTRY",
	name = "Voltaic Sentry",
	info = function(self, t)
		return ([[Place an electrically charged sentry device at a location.
		Every turn it will fire a bolt of electricity at a nearby enemy.
		The bolts do %0.2f lightning damage.
		The sentry has %d life and lasts 8 turns.
		Damage, life, resists, and armor scale with your Steampower.
		Damage and penetration are inherited from the creator.]]):
		format(damDesc(self, DamageType.LIGHTNING, t.getDam(self, t)), t.getHP(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_EXPLOSIVE_SHELL",
	name = "Explosive Shell",
	info = function(self, t)
		return ([[You fire a special explosive shot with your steamgun(s) at a spot within range.
		When each shot reaches its target, it does normal steamgun damage and explodes within radius %d, which does %0.2f physical damage.
		This talent does not use ammo as it is the ammo.]])
		:format(self:getTalentRadius(t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_FLARE_SHELL",
	name = "Flare Shell",
	info = function(self, t)
		return ([[You fire a special explosive shot with your steamgun(s) at a spot within range.
		When each shot reaches its target, it does normal steamgun damage and explodes within radius %d, which lights up the area and blinds for %d turns.
		This talent does not use ammo as it is the ammo.]])
		:format(self:getTalentRadius(t), t.duration(self, t))
	end,
	}

registerTalentTranslation{
	id = "T_TINKER_INCENDIARY_SHELL",
	name = "Incendiary Shell",
	info = function(self, t)
		return ([[You fire a special explosive shot with your steamgun(s) at a spot within range.
		When each shot reaches its target, it does normal steamgun damage and releases %d explosive charges in a radius of 2.
		These charges will shortly explode for %0.2f fire damage in a radius of 1.
		This talent does not use ammo as it is the ammo.]])
		:format(math.floor(self:getTalentLevel(t)), damDesc(self, DamageType.FIRE, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_SOLID_SHELL",
	name = "Solid Shell",
	info = function(self, t)
		return ([[You fire a special solid shot with your steamgun(s) at a target for %d%% physical weapon damage.
		The weight of the shot will knock the target back %d tiles.
		This talent does not use ammo as it is the ammo.]])
		:format(100*t.getMultiple(self, t), t.knockback(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_IMPALER_SHELL",
	name = "Impaler Shell", 
	info = function(self, t)
		return ([[You fire a special stake shot with your steamgun(s) at a target for %d%% physical weapon damage.
		The weight of the shot will knock the target back 2 tiles and they will be pinned for %d turns.
		This talent does not use ammo as it is the ammo.]])
		:format(100*t.getMultiple(self, t), t.duration(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_SAW_SHELL",
	name = "Saw Shell",
	info = function(self, t)
		return ([[You fire a special steamsaw shot with your steamgun(s) at a target for %d%% physical weapon damage.
		The steamsaw will cut into the target, doing %d%% physical weapon damage over 5 turns.
		This talent does not use ammo as it is the ammo.]])
		:format(100*t.getMultiple(self, t), 50*t.getMultiple(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_HOOK_SHELL",
	name = "Hook Shell",
	info = function(self, t)
		return ([[You fire a special hook shot with your steamgun(s) at a target creature or location.
		If you target a creature, they are pulled up to %d tiles towards you.
		If you target an empty tile, you are pulled up to %d tiles towards it.
		This talent does not use ammo as it is the ammo.]])
		:format(t.distance(self, t), t.distance(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_MAGNETIC_SHELL",
	name = "Magnetic Shell",
	info = function(self, t)
		return ([[You fire a special magnetic shot with your steamgun(s) at a target for normal weapon damage.
		The shot will magnetise the target for %d turns. This lowers their defense and increases fatigue by %d.
		This talent does not use ammo as it is the ammo.
		Effect strength scales with Steampower.]])
		:format(t.duration(self, t), t.getPower(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_VOLTAIC_SHELL",
	name = "Voltaic Shell",
	info = function(self, t)
		return ([[You fire a special voltaic shot with your steamgun(s) at a target for 100%% weapon damage as lightning.
		The shot will release powerful electrical currents at up to %d nearby enemies. 
		Each bolt does %0.2f lightning damage.
		This talent does not use ammo as it is the ammo.
		Bolt damage scales with Steampower.]])
		:format(math.floor(self:getTalentLevel(t)), damDesc(self, DamageType.LIGHTNING, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_ANTIMAGIC_SHELL",
	name = "Antimagic Shell",
	info = function(self, t)
		return ([[You fire a special antimagic shot with your steamgun(s) at a target for 100%% normal weapon damage.
		The shot will release antimagic sap on the target, doing %0.2f arcane resource burn damage.
		This talent does not use ammo as it is the ammo.
		Sap damage scales with Steampower.]])
		:format(damDesc(self, DamageType.ARCANE, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_BOTANICAL_SHELL",
	name = "Botanical Shell",
	info = function(self, t)
		return ([[You fire a special botanical shot with your steamgun(s) at a target for 100%% weapon damage as nature.
		The shot will release spores which grow into Nourishing Moss in a radius of %d for %d turns.
		Each turn the moss deals %0.2f nature damage to each foe within its radius.
		This moss has vampiric properties and heals the user for %d%% of the damage done.
		This talent does not use ammo as it is the ammo.
		Moss damage scales with Steampower.]])
		:format(self:getTalentRadius(t), t.getDuration(self, t), damDesc(self, DamageType.NATURE, t.getDamage(self, t)), t.getHeal(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_CORROSIVE_SHELL",
	name = "Corrosive Shell",
	info = function(self, t)
		return ([[You fire a special corrosive shot with your steamgun(s) at a target for %d%% weapon damage as acid.
		The acid released by the shot will also corrode the target, reducing its accuracy, defense and armour by %d.
		This talent does not use ammo as it is the ammo.
		Corrosion strength scales with Steampower.]])
		:format(100*t.getMultiple(self, t), t.getPower(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_TOXIC_SHELL",
	name = "Toxic Shell",
	info = function(self, t)
		return ([[You fire a special toxic shot with your steamgun(s) at a target for 100%% weapon damage as blight.
		The shot will release heavy metals into the target, inflicting %0.2f blight damage per turn and reducing their global speed by %d%% for %d turns.
		This talent does not use ammo as it is the ammo.
		Toxin strength scales with Steampower.]])
		:format(damDesc(self, DamageType.BLIGHT, t.getPower(self, t)), t.getPower(self, t)-10, t.duration(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_MOSS_TREAD",
	name = "Moss Tread",
	info = function(self, t)
		local dur = t.getDuration(self, t)
		local dam = t.getDamage(self, t)
		return ([[For %d turns, you lay down Grasping Moss where you walk or stand.
		The moss is placed automatically every step and lasts %d turns.
		Each turn the moss deals %0.2f nature damage to each foe standing on it.
		This moss is very thick and sticky causing all foes passing through it have their movement speed reduced by %d%% and have a %d%% chance to be pinned to the ground for 4 turns.
		The damage scales with your Steampower.]]):
		format(dur*2, dur, damDesc(self, DamageType.NATURE, dam), t.getSlow(self, t), t.getPin(self, t))
	end,}
return _M