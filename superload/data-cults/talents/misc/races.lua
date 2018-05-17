local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DREM_FRENZY",
	name = "Frenzy",
	info = function(self, t)
		return ([[Enter a killing frenzy for 3 turns.
		During the frenzy the first time you use a class talent it has no cooldown (but does if used twice).
		This does not work for inscriptions, talents that take no turn to use, or have fixed cooldowns.
		]]):
		format()
	end,
}

registerTalentTranslation{
	id = "T_SPIKESKIN",
	name = "Spikeskin",
	info = function(self, t)
		return ([[Your skin grows small spikes coated in dark blight.
		When you are hit in melee the attacker starts bleeding black blood for 5 turns that deals %0.2f darkness damage each turn. This effect may only happen once per turn.
		You are empowered by the sight of the black blood, for each bleeding creature in radius 2 you gain 5%% all resistances, limited to %d creatures.
		The damage will scale with your Magic stat.]]):
		format(damDesc(self, DamageType.DARKNESS, t.getDamage(self, t)), t.getNb(self, t))
	end,
}

registerTalentTranslation{
	id = "T_FACELESS",
	name = "Faceless",
	info = function(self, t)
		return ([[Your faceless visage is puzzling and emotionless, allowing you to more easily resist mind tricks.
		You gain %d mental save, %d%% confusion immunity.]]):
		format(t.getSave(self, t), t.getImmune(self, t))
	end,
}

registerTalentTranslation{
	id = "T_FROM_BELOW_IT_DEVOURS",
	name = "From Below It Devours",
	info = function(self, t)
		return ([[Your affinity with things that dwell deep beneath the surface allows you to summon a hungering mouth.
		The mouth has %d bonus life, lasts for %d turns, and deals no damage.
		Each turn the mouth will draw all creatures in radius 10 3 spaces towards itself and force them to target it.
		Its bonus life depends on your Constitution stat and talent level.  Many other stats will scale with level.]]):
		format(t.getLife(self, t), t.getTime(self, t))
	end,
}

registerTalentTranslation{
	id = "T_KROG_WRATH",
	name = "Wrath of the Wilds",
	info = function(self, t)
		return ([[You unleash the wrath of the wilds for 5 turns.
		When you deal damage to a creature while wrath is active you have %d%% chance (100%% for the first creature hit) to stun them for 3 turns.
		This effect is only checked once per creature per turn.
		Chance scales with your Constitution and apply power is the highest or your physical or mind power.]]):
		format(t.getChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_DRAKE-INFUSED_BLOOD",
	name = "Drake-Infused Blood",
	info = function(self, t)
		local damtype = self.drake_infused_blood_type or DamageType.FIRE
		local resist = t.getResist(self, t)
		local damage = t.getRetaliation(self, t)
		if damtype == DamageType.PHYSICAL then 
			resist = resist / 2
			damage = damage / 2
		end
		local damname = DamageType:get(damtype).text_color..DamageType:get(damtype).name.."#LAST#"
		return ([[Since ziguranth removed those filthy magic runes from your body you have needed an alternative form of power to sustain your body. Thanks to drake blood you have found that power.
		Your blood hardens yourself, passively increasing stun resistance by %d%%, %s resistance by %d%% and dealing %d %s damage on melee attacks.
		You can activate this talent to change which drake aspect to bring forth, altering the elemental type of the bonus.
		The resistance and damage scales with your Willpower.

		Changing your aspect requires combat experience, you may only do so after slaying 100 enemies (current %d).]]):
		format(t.getImmune(self, t), damname, resist, damDesc(self, damtype, damage), damname, self.krog_kills or 0)
	end,
}

registerTalentTranslation{
	id = "T_FUEL_PAIN",
	name = "Fuel Pain",
	info = function(self, t)
		return ([[Your body is used to pain. When you take a hit of 20%% or more of your max life one of your inscription is taken of cooldown.
		This effect has a cooldown of %d turns.]]):
		format(self:getTalentCooldown(t))
	end,
}

registerTalentTranslation{
	id = "T_WARBORN",
	name = "Warborn",
	info = function(self, t)
		return ([[You were created by ziguranth for one purpose only, to wage war on magic!
		For 5 turns all damage taken is reduced by %d%% and when you activate this talent your Wrath of the Wild is put off cooldown.
		When you learn this talent you become so strong you can dual-wield any kind of one handed weapons.]]):
		format(t.getResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_TAKE_A_BITE",
	name = "Take a Bite",
	info = function(self, t)
		return ([[You try to bite off your foe with your #{italic}#head#{normal}# for %d%% blight weapon damage.
		If the target falls under 20%% life you have %d%% chances to outright kill it (bosses are immune).
		Whenever you succesfully bite a foe you regenerate %0.1f life per turn for 5 turns.
		Instant kill chances and regeneration increase with your Constitution stat and weapon damage increases with the highest of your Strength, Dexterity or Magic stat.]]):
		format(t.getDam(self, t) * 100, t.getChance(self, t), t.getRegen(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ULTRA_INSTINCT",
	name = "Ultra Instinct",
	info = function(self, t)
		return ([[Without the distraction of #{bold}#thoughts#{normal}# or #{bold}#self#{normal}# your body reacts faster and better to aggressions.
		Increases global speed by %d%%.]]):
		format(t.getSpeed(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_CORRUPTING_INFLUENCE",
	name = "Corrupting Influence",
	info = function(self, t)
		return ([[The parasite corruption seeps into your body, strengthening it.
		Increases blight, darkness, temporal and acid resistances by %d%% but decreases nature and light resistances by %d%%.]]):
		format(t.getResist(self, t), t.getResist(self, t) / 3)
	end,
}

registerTalentTranslation{
	id = "T_HORROR_SHELL",
	name = "Horror Shell",
	info = function(self, t)
		return ([[Creates a shell around you, absorbing %d damage. Lasts for 10 turns.
		The total damage the shield can absorb increases with your Constitution.]]):
		format(t.getShield(self, t))
	end,
}
return _M
