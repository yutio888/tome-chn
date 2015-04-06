-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2015 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

--TODO: Ritch blade champion (!) Miniboss?
--TODO: Blood tree, uses flying skulls. TODO: Flying skulls.
--TODO: Golden ooze(item), mana ooze (inscriptions)
--TODO: Armor ooze (armor), blade ooze (weapons)
--TODO: Vitas ooze (health+), Muscle ooze (sta+)


-- Load all others
load("/data/general/npcs/all.lua")
load("/data/general/npcs/crystal.lua")
load("/data/general/npcs/bone-giant.lua")
load("/data/general/npcs/ritch.lua")
load("/data/general/npcs/ziguranth.lua")
load("/data/general/npcs/horror-corrupted.lua")

local Talents = require("engine.interface.ActorTalents")

--Base arena human
newEntity{ define_as = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	display = "@", color=colors.UMBER,

	combat = { dam=resolvers.rngavg(5,12), atk=2, apr=6, physspeed=2 },

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
	resolvers.drops{chance=100, nb=1, {type="money"} },
	resolvers.inscriptions(1, {}),
	infravision = 10,
	lite = 2,
	life_rating = 10, rank = 2, size_category = 3,
	open_door = true,
	autolevel = "warrior",
	stun_immune = 0.2,
	confusion_immune = 0.1,
	fear_immune = 0.1,
	ai = "tactical", ai_state = { ai_move = "move_complex", talent_in = 1 },
	stats = { str = 10, dex = 10, mag = 10, con = 10, cun = 10, wil = 10 },
	resolvers.talents{ [Talents.T_ARMOUR_TRAINING] = 4, },
	resolvers.equip{
		{type="armor", subtype="feet", autoreq=true},
	},
	resolvers.sustains_at_birth(),
}

--Minibosses
newEntity{ name = "skeletal rat",
	base = "BASE_NPC_RODENT",
	define_as = "SKELERAT",
	type = "undead",
	desc = [[The diminutive skeleton of a giant rat, charged with evil energies. Nobody understands the usefulness of undead rodents until several of them come after you.]],
	color = colors.GOLD,
	level_range = {3, 4},
	exp_worth = 2,
	rank = 3,
	max_life = resolvers.rngavg(30, 45),
	combat = { dam = 7, atk = 15, apr = 10 },
	stats = { str=8, dex=15, mag=1, con=5 },
	combat_def = 2,
	resolvers.talents{
		[Talents.T_SOUL_ROT]=1,
	},
	resolvers.sustains_at_birth(),
}

newEntity{ name = "homeless fighter",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	color = colors.BROWN,
	life_rating = 4,
	desc = "Will fight for a meal.",
	equipment = resolvers.equip{
		{ type="weapon", force_drop=true, autoreq = true },
		{ type="armor", force_drop=true, autoreq = true },
	},
	max_life = resolvers.rngavg(80,90),
	level_range = {2, 25}, exp_worth = 1,
	rarity = 0,
	combat_def = 1,
	resolvers.talents{
		[Talents.T_DIRTY_FIGHTING] = 1,
	}
}

newEntity{ name = "golden crystal",
	base = "BASE_NPC_CRYSTAL",
	define_as = "GOLDCRYSTAL",
	color=colors.GOLD, image = false,
	desc = "A formation of golden crystal. It emits a golden radiance equalling the sun itself.",
	level_range = {1, 99},
	exp_worth = 2,
	rank = 3,
	resolvers.drops{chance=100, nb=1, {type="jewelry", tome_drops="boss"}},
	max_life = resolvers.rngavg(12,34),
	resists = { [DamageType.LIGHT] = 100 },
	resolvers.talents{
		[Talents.T_SEARING_LIGHT]=1,
	},
	resolvers.sustains_at_birth(),
}

newEntity{ name = "master alchemist",
	define_as = "MASTERALCHEMIST",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	color=colors.ORANGE,

	life_rating = 8,

	stats = { str = 12, dex = 20, cun = 5, mag = 20, con = 10 },
	desc = [[Deadly fighters using explosive gems to attack.]],
	level_range = {15, nil}, exp_worth = 2,
	rarity = 10,
	rank = 3,
	max_life = 120,
	resolvers.inscriptions(3, {}),
	equipment = resolvers.equip{
		{type="weapon", subtype="staff", force_drop=true, tome_drops="boss", forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="cloth", force_drop=true, tome_drops="boss", forbid_power_source={antimagic=true}, autoreq=true},
	},
	resolvers.drops{chance=100, nb=1, {type="charm", subtype="wand", ego_chance=100}},
	autolevel = "dexmage",
	combat_def = 3,
	resolvers.talents{
		[Talents.T_SHOCKWAVE_BOMB]=3,
		[Talents.T_EXPLOSION_EXPERT]=3,
		[Talents.T_ALCHEMIST_PROTECTION]=5,
		[Talents.T_STAFF_MASTERY]=2,
		[Talents.T_FIRE_INFUSION]=3,
		[Talents.T_ACID_INFUSION]=3,
		[Talents.T_GEM_PORTAL]=2,
		[Talents.T_ELEMENTAL_BOLT]=2,
	},
	resolvers.generic(function(self)
		local t = self:getTalentFromId(self.T_CREATE_ALCHEMIST_GEMS)
		local gem = t.make_gem(self, t, "GEM_AGATE")
		self:wearObject(gem, true, false)
	end),
}

newEntity{ name = "multihued wyrmic",
	define_as = "MULTIHUEWYRMIC",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	color=colors.GOLD,
	female = true,
	shader = "quad_hue",
	resolvers.drops{chance=100, nb=3, {type="scroll"} },
	stats = { str = 20, dex = 20, mag = 20, con = 9, wil = 15 },
	desc = [[A powerful wyrmic with mastery over several elements.]],
	level_range = {20, nil}, exp_worth = 2,
	rarity = 10,
	rank = 3,
	instakill_immune = 1,
	stun_immune = 0.8,
	confusion_immune = 0.7,
	max_life = 180,
	resolvers.inscriptions(3, {}),
	resolvers.equip{
		{type="weapon", subtype="battleaxe", autoreq=true},
		{type="armor", subtype="cloak", autoreq=true},
	},
	combat_armor = 0, combat_def = 6,
	resolvers.talents{
		[Talents.T_LIGHTNING_SPEED] = 5,
		[Talents.T_ICE_CLAW] = 4,
		[Talents.T_WING_BUFFET] = 3,
		[Talents.T_ICY_SKIN] = 2,
		[Talents.T_TORNADO] = 1,
		[Talents.T_DEATH_DANCE] = 3,
		[Talents.T_RUSH] = 3,
		[Talents.T_WEAPON_COMBAT]=1,
		[Talents.T_WEAPONS_MASTERY]=1,
	},
}

newEntity{ name = "master slinger",
	define_as = "MASTERSLINGER",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "halfling",
	color=colors.GOLD,

	life_rating = 11,
	rank = 3,
	autolevel = "slinger",
	stats = { str=11, dex=15, cun = 15, mag=1, con=13 },
	desc = [[Expert slingers on hire by the arena. They are great at their jobs.]],
	level_range = {12, nil}, exp_worth = 2,
	rarity = 10,
	max_life = resolvers.rngavg(100,110),
	resolvers.equip{
		{type="weapon", subtype="sling", autoreq=true},
		{type="ammo", subtype="shot", autoreq=true},
		{type="armor", subtype="shield", autoreq=true},
	},
	resolvers.inscriptions(3, "infusion"),
	combat_armor = 1, combat_def = 4,
	resolvers.talents{
		[Talents.T_SHOOT]=1,
		[Talents.T_DISENGAGE]=2,
		[Talents.T_RAPID_SHOT]=3,
		[Talents.T_INERTIAL_SHOT]=3,
		[Talents.T_HEAVE]=3,
		[Talents.T_SHIELD_EXPERTISE]=1,
		[Talents.T_SLING_MASTERY]=1,
	},
}

newEntity{ name = "gladiator",
	define_as = "GLADIATOR",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	color=colors.GOLD,

	life_rating = 15,
	rank = 3,

	stats = { str=20, dex=10, mag=1, con=16 },
	desc = [[Mercenaries hired by the arena for the sole purpose of entertainment. They make a living beating people up.]],
	level_range = {7, nil}, exp_worth = 2,
	rarity = 10,
	max_life = resolvers.rngavg(80,100),
	resolvers.equip{
		{type="weapon", subtype="mace", autoreq=true},
		{type="armor", subtype="shield", autoreq=true},
		{type="armor", subtype="heavy", autoreq=true},
	},
	resolvers.drops{chance=100, nb=1, {type="weapon", force_drop=true, tome_drops="boss"}},
	combat_def = 4,
	resolvers.talents{
		[Talents.T_SHIELD_PUMMEL]=2,
		[Talents.T_RUSH]=1,
		[Talents.T_REPULSION]=2,
	},
}

newEntity{ name = "reaver",
	define_as = "REAVER",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	color=colors.GOLD,
	stats = { str = 20, dex = 20, mag = 20, con = 9, wil = 15 },
	desc = [[A warrior of death.]],
	level_range = {25, nil}, exp_worth = 2,
	rarity = 10,
	rank = 3,
	max_life = 150,
	resolvers.inscriptions(3, {}),
	resolvers.equip{
		{type="weapon", subtype="longsword", forbid_power_source={antimagic=true}, autoreq=true},
		{type="weapon", subtype="longsword", forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="heavy", forbid_power_source={antimagic=true}, autoreq=true},
	},
	autolevel = "warriormage",
	combat_def = 4,
	resolvers.talents{
		[Talents.T_DRAIN] = 4,
		[Talents.T_BONE_SPEAR] = 3,
		[Talents.T_BONE_GRAB] = 2,
		[Talents.T_BONE_SHIELD] = 2,
		[Talents.T_VIRULENT_DISEASE] = 2,
		[Talents.T_CORRUPTED_STRENGTH] = 2,
		[Talents.T_REND] = 2,
		[Talents.T_RUIN] = 2,
		[Talents.T_ACID_BLOOD] = 2,
		[Talents.T_WEAPON_COMBAT] = 2,

	},
}

newEntity{ name = "headless horror",
	base = "BASE_NPC_HORROR", define_as = "HEADLESSHORROR",
	color=colors.GOLD,
	desc ="A headless gangly humanoid with a large distended stomach. Was captured and tamed by the first master of the arena.",
	level_range = {30, nil}, exp_worth = 1,
	rarity = 3,
	rank = 3,
	autolevel = "warrior",
	ai = "dumb_talented_simple", ai_state = { ai_move="move_complex", talent_in=1, },
	combat = { dam=18, atk=18, apr=10, dammod={str=1} },
	combat = {damtype=DamageType.PHYSICAL},
	no_auto_resists = true,

	resolvers.talents{
		[Talents.T_MANA_CLASH]=4,
		[Talents.T_GRAB]=4,
	},

	on_added = function(self)
		local eyes = {}
		for i = 1, 3 do
			local x, y = util.findFreeGrid(self.x, self.y, 15, true, {[engine.Map.ACTOR]=true})
			if x and y then
				local m = game.zone:makeEntity(game.level, "actor", {properties={"is_eldritch_eye"}, special_rarity="_eldritch_eye_rarity"}, nil, true)
				if m then
					m.summoner = self
					game.zone:addEntity(game.level, m, "actor", x, y)
					eyes[m] = true

					local damtype = next(m.resists)
					self.resists[damtype] = 100
					self.resists.all = (self.resists.all or 0) + 30
				end
			end
		end
		self.eyes = eyes
	end,
	on_die = function(self, src)
		local nb = 0
		for eye, _ in pairs(self.eyes) do
			if not eye.dead then eye:die(src) nb = nb + 1 end
		end
		if nb > 0 then
			game.logSeen(self, "#AQUAMARINE#As %s falls all its eyes fall to the ground!", self.name)
		end
	end,
}


--Bosses
--TODO:Bosses must have a super mode for the royal crown mode.
newEntity{ name = "Ryal",
	base = "BASE_NPC_BONE_GIANT",
	color=colors.VIOLET,
	define_as = "ARENA_BOSS_RYAL",
	resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/undead_giant_ryal.png", display_h=2, display_y=-1}}},
	desc = "A gargantuan bone giant resembling a wingless wyrm. He is fully sentient and surprisingly fast.",
	rank = 4, unique = true,
	resolvers.equip{
		{type="weapon", subtype="trident", autoreq=true, forbid_power_source={antimagic=true}, special_rarity="trident_rarity"},
	},
	ai = "tactical", ai_state = { ai_move = "move_astar", talent_in = 1 },
	ai_tactic = resolvers.tactic("melee"),
	resolvers.inscriptions(4, {}),
	instakill_immune = 1,
	level_range = {9, nil}, exp_worth = 3,
	max_life = resolvers.rngavg(120,150),
	combat_armor = 0, combat_def = 10,
	melee_project = {[DamageType.BLIGHT]=resolvers.mbonus(15, 1)},
	resolvers.inscriptions(2, "rune"),
	autolevel = "warriormage",
	talent_cd_reduction={
		[Talents.T_KNOCKBACK] = 2,
	},
	resolvers.talents {
		[Talents.T_EXOTIC_WEAPONS_MASTERY]=1,
		[Talents.T_BONE_SHIELD]=2,
		[Talents.T_THROW_BONES]=1,
		[Talents.T_KNOCKBACK]=3,
		[Talents.T_BLINDING_SPEED]=1,
	},
	resolvers.sustains_at_birth(),
}

newEntity{ name = "Fryjia Loren",
	define_as = "ARENA_BOSS_FRYJIA",
	type = "humanoid", subtype = "human",
	display = "@",
	color=colors.VIOLET,
	desc = [[A young girl with skin pale as snow. She is small, but deadly in battle, unleashing a constant barrage of ice shards.]],
	level_range = {12, nil}, exp_worth = 3,
	rank = 4, unique = true,
	size_category = 2,
	female = true,
	max_life = 75, life_rating = 11,
	infravision = 10,
	stats = { str=10, dex=20, cun=10, mag=15, con=10, wil = 15 },
	resists={[DamageType.FIRE] = -100, [DamageType.COLD] = 60},

	instakill_immune = 1,
	stun_immune = 0.5,
	fear_immune = 1,

	open_door = true,

	autolevel = "dexmage",
	ai = "tactical", ai_state = { ai_move = "move_astar", talent_in = 1 },
	ai_tactic = resolvers.tactic("ranged"),
	resolvers.inscriptions(1, {"manasurge rune"}),
	resolvers.inscriptions(3, {"manasurge rune", "movement infusion", "wild infusion", "frozen spear rune"}),

	body = { INVEN = 1000, QS_MAINHAND = 1, QS_OFFHAND = 1, MAINHAND = 1, OFFHAND = 1, FINGER = 2, NECK = 1, LITE = 1, BODY = 1, HEAD = 1, CLOAK = 1, HANDS = 1, BELT = 1, FEET = 1, TOOL = 1, QUIVER = 1 },
	resolvers.equip{
		{type="weapon", subtype="dagger", forbid_power_source={antimagic=true}, autoreq=true},
		{type="weapon", subtype="dagger", forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="light", forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="light", forbid_power_source={antimagic=true}, autoreq=true}
	},
	talent_cd_reduction={
		[Talents.T_ICE_SHARDS] = 3,
		[Talents.T_LIGHTNING_SPEED] = 4,
		[Talents.T_DISENGAGE] = 5,
		[Talents.T_RUSH] = 7,
	},
	resolvers.talents{
		[Talents.T_DUAL_WEAPON_TRAINING] = 2,
		[Talents.T_DUAL_WEAPON_DEFENSE] = 1,
		[Talents.T_DUAL_STRIKE] = 1,
		[Talents.T_RUSH] = 4,
		[Talents.T_FLURRY] = 2,
		[Talents.T_MANAFLOW] = 3,
		[Talents.T_QUICK_RECOVERY] = 5,
		[Talents.T_DISENGAGE] = 5,
		[Talents.T_ICE_CLAW] = 4,
		[Talents.T_LIGHTNING_SPEED] = 5,
		[Talents.T_UTTERCOLD]=2,
		[Talents.T_TIDAL_WAVE]=2,
		[Talents.T_ICE_SHARDS]=3,
	},
	resolvers.sustains_at_birth(),
}

newEntity{ name = "Riala Shalarak",
	define_as = "ARENA_BOSS_RIALA",
	type = "humanoid", subtype = "human",
	display = "@",
	color=colors.VIOLET,
	desc = [[A strong female magician. Years of experience make her a dangerous combatant.]],
	level_range = {25, nil}, exp_worth = 3,
	rank = 4, unique = true,
	size_category = 3,
	female = true,
	max_life = 150, life_rating = 30,
	infravision = 10,
	stats = { str=15, dex=15, cun=20, mag=30, con=15, wil=15 },
	resists={[DamageType.FIRE] = 100, [DamageType.COLD] = -20},

	instakill_immune = 1,
	stun_immune = 0.5,
	fear_immune = 0.5,
	open_door = true,

	autolevel = "caster",
	ai = "tactical", ai_state = { ai_move = "move_astar", talent_in = 1 },
	ai_tactic = resolvers.tactic("ranged"),
	resolvers.inscriptions(3, {"manasurge rune", "manasurge rune", "regeneration infusion", "fire beam rune"}),

	summon = {{name = "wisp", number=3, hasxp=false}},

	body = { INVEN = 1000, QS_MAINHAND = 1, QS_OFFHAND = 1, MAINHAND = 1, OFFHAND = 1, FINGER = 2, NECK = 1, LITE = 1, BODY = 1, HEAD = 1, CLOAK = 1, HANDS = 1, BELT = 1, FEET = 1, TOOL = 1, QUIVER = 1 },
	resolvers.equip{
		{type="weapon", subtype="staff", forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="cloth", forbid_power_source={antimagic=true}, autoreq=true}
	},
	resolvers.talents{
		[Talents.T_FIREFLASH] = 2,
		[Talents.T_ILLUMINATE] = 5,
		[Talents.T_STRIKE] = 2,
		[Talents.T_SUMMON] = 1,
		[Talents.T_ELEMENTAL_BOLT] = 3,
		[Talents.T_PHASE_DOOR] = 3,
		[Talents.T_DISRUPTION_SHIELD] = 2,
		[Talents.T_STAFF_MASTERY] = 1,
		[Talents.T_DEFENSIVE_POSTURE] = 2,
	},
	resolvers.sustains_at_birth(),
}

newEntity{ name = "Valfren Loren",
	define_as = "ARENA_BOSS_VALFREN",
	type = "humanoid", subtype = "human",
	display = "@",
	color=colors.VIOLET,
	resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/humanoid_human_valfred_loren.png", display_h=2, display_y=-1}}},
	desc = [[A massive suit of armor with a massive axe containing a massively cursed person. He is cursed to fight eternally.]],
	level_range = {16, nil}, exp_worth = 3,
	rank = 4, unique = true,
	size_category = 4,
	female = false,
	max_life = 160, life_rating = 15,
	infravision = 0,
	stats = { str=25, dex=25, cun=5, mag=10, con=15, wil=35 },
	resists={[DamageType.DARKNESS] = 100, [DamageType.LIGHT] = -70},

	instakill_immune = 1,

	open_door = true,

	autolevel = "warrior",
	ai = "tactical", ai_state = { ai_move = "move_astar", talent_in = 1 },
	ai_tactic = resolvers.tactic("tank"),
	resolvers.inscriptions(3, {}),

	body = { INVEN = 1000, QS_MAINHAND = 1, QS_OFFHAND = 1, MAINHAND = 1, OFFHAND = 1, FINGER = 2, NECK = 1, LITE = 1, BODY = 1, HEAD = 1, CLOAK = 1, HANDS = 1, BELT = 1, FEET = 1, TOOL = 1, QUIVER = 1 },
	resolvers.equip{
		{type="weapon", subtype="battleaxe", autoreq=true, force_drop=true, tome_drops="boss"},
		{type="armor", subtype="massive", autoreq=true, force_drop=true, tome_drops="boss"}
	},
	resolvers.talents{
		[Talents.T_GLOOM] = 5,
		[Talents.T_BLINDSIDE] = 3,
		[Talents.T_SLASH] = 4,
		[Talents.T_SEETHE] = 5,
		[Talents.T_RAMPAGE] = 8,
		[Talents.T_BRUTALITY] = 3,
		[Talents.T_TENACITY] = 4,
		[Talents.T_RECKLESS_CHARGE] = 5,
		[Talents.T_ARMOUR_TRAINING] = 5,
		[Talents.T_WEAPON_COMBAT] = 2,
	},
	resolvers.sustains_at_birth(),
}

newEntity{ name = "Rej Arkatis",
	define_as = "ARENA_BOSS_MASTER_DEFAULT",
	type = "humanoid", subtype = "human",
	display = "@",
	color=colors.VIOLET,
	resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/humanoid_human_rej_arkatis.png", display_h=2, display_y=-1}}},
	desc = [[A Cornac fighter of respectable talent. He emerged from nowhere and became the true master of fighting.]],
	level_range = {1, nil}, exp_worth = 3,
	rank = 5, unique = true, lite = -5,
	size_category = 3,
	female = false,
	max_life = 180, life_rating = 20,
	infravision = 10,
	stats = { str=15, dex=20, cun=25, mag=20, con=15, wil=35 },
	resists={[DamageType.DARKNESS] = -20},
	no_drops = true,

	instakill_immune = 1,
	stun_immune = 0.7,
	fear_immune = 0.6,
	open_door = true,

	ai = "tactical", ai_state = { ai_move = "move_astar", talent_in = 1 },
	ai_tactic = resolvers.tactic("melee"),
	resolvers.inscriptions(4, {"manasurge rune", "movement infusion", "regeneration infusion", "fire beam rune"}),

	body = { INVEN = 1000, QS_MAINHAND = 1, QS_OFFHAND = 1, MAINHAND = 1, OFFHAND = 1, FINGER = 2, NECK = 1, LITE = 1, BODY = 1, HEAD = 1, CLOAK = 1, HANDS = 1, BELT = 1, FEET = 1, TOOL = 1, QUIVER = 1 },
	resolvers.equip{
		{type="weapon", subtype="dagger", autoreq=true, force_drop=true, forbid_power_source={antimagic=true}, tome_drops="boss"},
		{type="weapon", subtype="dagger", autoreq=true, force_drop=true, forbid_power_source={antimagic=true}, tome_drops="boss"},
		{type="armor", subtype="cloak", autoreq=true, force_drop=true, forbid_power_source={antimagic=true}, tome_drops="boss"},
	},
	autolevel = "rogue",
	combat_def = 2,
	resolvers.talents{
		[Talents.T_STEALTH]=5,
		[Talents.T_SHADOW_CUNNING]=4,
		[Talents.T_SHADOWSTEP]=3,
		[Talents.T_SHADOW_COMBAT]=3,
		[Talents.T_SHADOW_FEED]=2,
		[Talents.T_DEADLY_STRIKES]=2,
		[Talents.T_ILLUMINATE]=4,
		[Talents.T_PHASE_DOOR]=4,
		[Talents.T_HIDE_IN_PLAIN_SIGHT]=5,
		[Talents.T_STICKY_SMOKE]=3,
		[Talents.T_DISENGAGE]=5,
		[Talents.T_RUSH]=5,
		[Talents.T_WILLFUL_COMBAT]=3,
		[Talents.T_DUAL_WEAPON_TRAINING] = 5,
	},
	resolvers.sustains_at_birth(),
}

--Regular

newEntity{ name = "slinger",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	color=colors.UMBER,
	life_rating = 8, stats = { str = 7, dex = 10, cun = 10, mag = 1, con = 7 },
	desc = [[Ranged fighters coming to the arena looking for wealth and glory, just like you.]],
	level_range = {4, nil}, exp_worth = 1,
	rarity = 1,
	max_life = resolvers.rngavg(80,95),
	resolvers.equip{
		{type="weapon", subtype="sling", autoreq=true},
		{type="ammo", subtype="shot", autoreq=true},
	},
	autolevel = "slinger",
	ai_tactic = resolvers.tactic("ranged"),
	combat_def = 2,
	resolvers.talents{
		[Talents.T_SHOOT]=1,
		[Talents.T_DISENGAGE]=2,
		[Talents.T_RAPID_SHOT]=2
	},
}

newEntity{ name = "high slinger",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	color=colors.DARK_UMBER,
	life_rating = 8, stats = { str = 7, dex = 10, cun = 10, mag = 1, con = 7 },
	desc = [[Ranged fighters coming to the arena looking for wealth and glory, just like you.]],
	level_range = {4, nil}, exp_worth = 1,
	rarity = 1,
	max_life = resolvers.rngavg(80,95),
	resolvers.equip{
		{type="weapon", subtype="sling", autoreq=true},
		{type="ammo", subtype="shot", autoreq=true},
	},
	autolevel = "slinger", ai_tactic = resolvers.tactic("ranged"),
	combat_def = 2,
	resolvers.talents{
		[Talents.T_SHOOT]=1,
		[Talents.T_DISENGAGE]=3,
		[Talents.T_HEAVE]=1,
		[Talents.T_RAPID_SHOT]=4,
		[Talents.T_INERTIAL_SHOT]=2,
	},
}

newEntity{ name = "alchemist",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	color=colors.ORANGE,

	life_rating = 8,

	stats = { str = 7, dex = 11, cun = 1, mag = 11, con = 6 },
	desc = [[Deadly fighters using explosive gems to attack.]],
	level_range = {1, nil}, exp_worth = 1,
	rarity = 1,
	max_life = 60,
	equipment = resolvers.equip{
		{type="weapon", subtype="staff", forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="cloth", forbid_power_source={antimagic=true}, autoreq=true},
	},
	resolvers.drops{chance=40, {type="charm", subtype="wand", ego_chance=100}},
	autolevel = "dexmage", ai_tactic = resolvers.tactic("ranged"),
	combat_def = 2,
	resolvers.talents{
		[Talents.T_THROW_BOMB]=2,
		[Talents.T_ALCHEMIST_PROTECTION]=4,
		[Talents.T_LIGHTNING_INFUSION]=2,
		[Talents.T_ACID_INFUSION]=2,
		[Talents.T_FIRE_INFUSION]=2,
		[Talents.T_ELEMENTAL_BOLT]=1,
	},
	resolvers.generic(function(self)
		local t = self:getTalentFromId(self.T_CREATE_ALCHEMIST_GEMS)
		local gem = t.make_gem(self, t, "GEM_AGATE")
		self:wearObject(gem, true, false)
	end),
}

newEntity{ name = "blood mage",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	color=colors.CRIMSON,

	life_rating = 4,

	stats = { str = 7, dex = 11, cun = 1, mag = 11, con = 6 },
	desc = [[A man dressed in black robes. You feel weak as you hear his ominous chanting.]],
	level_range = {1, nil}, exp_worth = 1,
	rarity = 1,
	max_life = 40,
	equipment = resolvers.equip{
		{type="weapon", subtype="staff", forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="cloth", forbid_power_source={antimagic=true}, autoreq=true},
	},
	resolvers.drops{chance=40, {type="charm", subtype="wand", ego_chance=100}},
	autolevel = "caster", ai_tactic = resolvers.tactic("ranged"),
	resolvers.talents{
		[Talents.T_BLOOD_GRASP] = 4,
		[Talents.T_CURSE_OF_VULNERABILITY] = 2,
		[Talents.T_PHASE_DOOR] = 1,
	},
}

newEntity{ name = "hexer",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	color=colors.DARK_GREY,

	life_rating = 1,

	stats = { str = 7, dex = 11, cun = 1, mag = 15, con = 6 },
	desc = [[A man dressed in black robes. You feel a thousand curses being put on you.]],
	level_range = {1, nil}, exp_worth = 1,
	rarity = 1,
	max_life = 10,
	equipment = resolvers.equip{
		{type="weapon", subtype="staff", forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="cloth", forbid_power_source={antimagic=true}, autoreq=true},
	},
	resolvers.drops{chance=40, {type="charm", subtype="wand", ego_chance=100}},
	autolevel = "caster", ai_tactic = resolvers.tactic("ranged"),
	resolvers.talents{
		[Talents.T_BURNING_HEX]=3,
		[Talents.T_EMPATHIC_HEX]=1,
		[Talents.T_HYMN_OF_SHADOWS]=3,
		[Talents.T_SOUL_ROT]=3,
	},
}

newEntity{ name = "rogue",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	color=colors.DARK_BLUE,

	life_rating = 8,
	lite = -1,
	stats = { str = 7, dex = 10, cun = 28, mag = 1, con = 7 },
	desc = [[Stealthy fighters trying to achieve victory with trickery. Be careful or they will steal your sight!]],
	level_range = {1, nil}, exp_worth = 1,
	rarity = 1,
	max_life = 60,
	resolvers.equip{
		{type="weapon", subtype="dagger", autoreq=true},
		{type="weapon", subtype="dagger", autoreq=true},
		{type="armor", subtype="cloak", autoreq=true},
		{name="rough leather gloves", autoreq=true},
	},
	autolevel = "rogue", ai_tactic = resolvers.tactic("melee"),
	combat_def = 2,
	resolvers.talents{
		[Talents.T_STEALTH]=3,
		[Talents.T_HIDE_IN_PLAIN_SIGHT]=5,
		[Talents.T_STICKY_SMOKE]=2,
		[Talents.T_DISENGAGE]=1,
		[Talents.T_DUAL_WEAPON_TRAINING] = 1,
	},
}

newEntity{ name = "trickster",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	color=colors.PINK,
	female = true,

	life_rating = 8,
	lite = -1,
	stats = { str = 15, dex = 28, cun = 28, mag = 1, con = 7 },
	desc = [[Stealthy ranged fighters trying to achieve victory with trickery. Be careful or they will shoot your heart!]],
	level_range = {1, nil}, exp_worth = 1,
	rarity = 1,
	max_life = 60,
	resolvers.equip{
		{type="weapon", subtype="bow", autoreq=true},
		{type="armor", subtype="light", autoreq=true},
		{type="armor", subtype="cloak", autoreq=true},
	},
	autolevel = "rogue", ai_tactic = resolvers.tactic("archer"),
	combat_def = 2,
	resolvers.talents{
		[Talents.T_STEALTH]=4,
		[Talents.T_HIDE_IN_PLAIN_SIGHT]=5,
		[Talents.T_INERTIAL_SHOT] = 6,
		[Talents.T_WEAPON_COMBAT] = 2,
		[Talents.T_BOW_MASTERY] = 2,
		[Talents.T_DISENGAGE] = 5,
	},
	talent_cd_reduction={
		[Talents.T_STEALTH] = 7,
	},
	resolvers.sustains_at_birth(),
}

newEntity{ name = "shadowblade",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	color=colors.BLACK,

	life_rating = 10,
	lite = -2,
	stats = { str = 7, dex = 10, cun = 28, mag = 1, con = 7 },
	desc = [[Stealthy fighters trying to achieve victory with trickery. Be careful or they will steal your life!]],
	level_range = {1, nil}, exp_worth = 1,
	rarity = 1,
	max_life = 100,
	resolvers.equip{
		{type="weapon", subtype="dagger", forbid_power_source={antimagic=true}, autoreq=true},
		{type="weapon", subtype="dagger", forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="cloak", forbid_power_source={antimagic=true}, autoreq=true},
		{name="rough leather gloves", forbid_power_source={antimagic=true}, autoreq=true},
	},
	autolevel = "rogue", ai_tactic = resolvers.tactic("melee"),
	combat_def = 2,
	resolvers.talents{
		[Talents.T_STEALTH]=4,
		[Talents.T_SHADOW_CUNNING]=3,
		[Talents.T_SHADOWSTEP]=1,
		[Talents.T_SHADOW_COMBAT]=2,
		[Talents.T_ILLUMINATE]=3,
		[Talents.T_HIDE_IN_PLAIN_SIGHT]=5,
		[Talents.T_DISENGAGE]=2,
		[Talents.T_DUAL_WEAPON_TRAINING] = 3,
	},
}

newEntity{ name = "fire wyrmic",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	color=colors.RED,
	resolvers.drops{chance=30, nb=1, {type="scroll"}},
	stats = { str = 10, dex = 10, mag = 10, con = 9, wil = 15},
	desc = [[A fire wyrmic aspiring to win the tournament. He comes paired with an ice wyrmic.]],
	level_range = {1, nil}, exp_worth = 1, autolevel = "wyrmic",
	rarity = 1,
	max_life = resolvers.rngavg(90,105),
	resolvers.equip{
		{type="weapon", subtype="battleaxe", autoreq=true},
		{type="armor", subtype="cloak", autoreq=true},
	},
	combat_armor = 1, combat_def = 4,
	resolvers.talents{
		[Talents.T_BELLOWING_ROAR] = 1,
		[Talents.T_WING_BUFFET] = 2,
		[Talents.T_DEVOURING_FLAME] = 1,
		[Talents.T_DEATH_DANCE] = 2,
		[Talents.T_WEAPONS_MASTERY]=1,
	},
}

newEntity{ name = "ice wyrmic",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	color=colors.BLUE,
	resolvers.drops{chance=30, nb=1, {type="scroll"}},
	stats = { str = 10, dex = 10, mag = 10, con = 9, wil = 15},
	desc = [[An ice wyrmic aspiring to win the tournament. He comes paired with a fire wyrmic.]],
	level_range = {1, nil}, exp_worth = 1, autolevel = "wyrmic",
	rarity = 1,
	female = true,
	max_life = resolvers.rngavg(90,105),
	resolvers.equip{
		{type="weapon", subtype="battleaxe", autoreq=true},
		{type="armor", subtype="cloak", autoreq=true},
	},
	combat_armor = 1, combat_def = 4,
	resolvers.talents{
		[Talents.T_ICE_CLAW] = 3,
		[Talents.T_ICY_SKIN] = 3,
		[Talents.T_ICE_WALL] = 2,
		[Talents.T_RUSH] = 2,
		[Talents.T_WEAPON_COMBAT]=2,
	},
}

newEntity{ name = "sand wyrmic",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	color = {r = 204, g = 255, b = 95},
	resolvers.drops{chance=30, nb=1, {type="scroll"}},
	stats = { str = 10, dex = 10, mag = 10, con = 9, wil = 15},
	desc = [[A sand wyrmic aspiring to win the tournament. He comes paired with a storm wyrmic.]],
	level_range = {1, nil}, exp_worth = 1, autolevel = "wyrmic",
	rarity = 1,
	max_life = resolvers.rngavg(90,105),

	make_escort = {
		{name="storm wyrmic", number=1},
	},
	resolvers.equip{
		{type="weapon", subtype="battleaxe", autoreq=true},
		{type="armor", subtype="cloak", autoreq=true},
	},
	combat_armor = 1, combat_def = 4,
	resolvers.talents{
		[Talents.T_SAND_BREATH] = 2,
		[Talents.T_NATURE_TOUCH] = 2,
		[Talents.T_DEATH_DANCE] = 2,
		[Talents.T_WEAPONS_MASTERY]=1,
	},
}

newEntity{ name = "storm wyrmic",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	color=colors.WHITE,
	resolvers.drops{chance=30, nb=1, {type="scroll"}},
	stats = { str = 10, dex = 10, mag = 10, con = 9, wil = 15},
	desc = [[A storm wyrmic aspiring to win the tournament. He comes paired with a sand wyrmic.]],
	level_range = {1, nil}, exp_worth = 1, autolevel = "wyrmic",
	rarity = 1,
	female = true,
	max_life = resolvers.rngavg(90,105),

	resolvers.equip{
		{type="weapon", subtype="battleaxe", autoreq=true},
		{type="armor", subtype="cloak", autoreq=true},
	},
	combat_armor = 1, combat_def = 4,
	resolvers.talents{
		[Talents.T_LIGHTNING_SPEED] = 4,
		[Talents.T_STATIC_FIELD] = 2,
		[Talents.T_TORNADO] = 1,
		[Talents.T_DISENGAGE] = 3,
		[Talents.T_WEAPON_COMBAT]=2,
	},
}

newEntity{ name = "high gladiator",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	color=colors.DARK_RED,

	life_rating = 11,

	stats = { str=15, dex=15, mag=1, con=15, wil=20 },
	desc = [[Mercenaries hired by the arena for the sole purpose of entertainment. They make a living beating people up.]],
	level_range = {14, nil}, exp_worth = 1,
	rarity = 10,
	max_life = 90,
	resolvers.equip{
		{type="weapon", subtype="mace", autoreq=true},
		{type="armor", subtype="shield", autoreq=true},
		{type="armor", subtype="heavy", autoreq=true},
	},
	autolevel = "warrior",
	resolvers.drops{chance=50, nb=1, {type="weapon", ego_chance=20}},
	combat_def = 3,
	resolvers.talents{
		[Talents.T_SHIELD_PUMMEL]=2,
		[Talents.T_RUSH]=2,
		[Talents.T_DISENGAGE]=2,
		[Talents.T_REPULSION]=2,
		[Talents.T_OVERPOWER]=2,
		[Talents.T_WEAPONS_MASTERY]=1,
	},
}

newEntity{ name = "great gladiator",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	color=colors.VERY_DARK_RED,
	resolvers.nice_tile{image="invis.png", add_mos = {{image="npc/humanoid_human_great_gladiator.png", display_h=2, display_y=-1}}},

	life_rating = 12,

	stats = { str=20, dex=20, mag=5, con=15, wil=25 },
	desc = [[Mercenaries hired by the arena for the sole purpose of entertainment. They make a living beating people up.]],
	level_range = {19, nil}, exp_worth = 2,
	rarity = 10,
	max_life = 120,
	resolvers.equip{
		{type="weapon", subtype="trident", autoreq=true, special_rarity="trident_rarity"},
		{type="armor", subtype="heavy", autoreq=true},
	},
	autolevel = "warrior",
	resolvers.drops{chance=75, nb=1, {type="weapon", ego_chance=40}},
	combat_def = 4,
	resolvers.talents{
		[Talents.T_RUSH]=5,
		[Talents.T_EXOTIC_WEAPONS_MASTERY]=1,
		[Talents.T_JUGGERNAUT]=3,
		[Talents.T_DEATH_DANCE]=3,
		[Talents.T_BATTLE_CRY]=2,
		[Talents.T_WEAPONS_MASTERY]=1,
		[Talents.T_WEAPON_COMBAT]=1,
	},
}

newEntity{ name = "martyr",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human",
	color=colors.SALMON,
	life_rating = 12,
	positive_regen = 2,
	stats = { str=15, dex=15, mag=20, con=10, wil=15 },
	desc = [[A devout soldier.]],
	level_range = {15, nil}, exp_worth = 2,
	rarity = 10,
	max_life = 200,
	resolvers.equip{
		{type="weapon", subtype="longsword", ego_chance=10, forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="shield", ego_chance=30, forbid_power_source={antimagic=true}, autoreq=true},
	},
	resists = { [DamageType.LIGHT] = 90 },
	autolevel = "caster",
	combat_def = 4,
	resolvers.talents{
		[Talents.T_MARTYRDOM]=2,
		[Talents.T_RUSH]=2,
		[Talents.T_CHANT_OF_FORTRESS]=3,
		[Talents.T_RETRIBUTION]=1,
		[Talents.T_WEAPONS_MASTERY]=1,
		[Talents.T_SHIELD_EXPERTISE]=2,
		[Talents.T_CIRCLE_OF_BLAZING_LIGHT]=2,
	},
	resolvers.sustains_at_birth(),
}

newEntity{ name = "anorithil",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "elf",
	color=colors.GREY,
	life_rating = 12,

	stats = { str=10, dex=10, mag=30, con=10, wil=15 },
	desc = [[Warriors from afar. They use the power of light and darkness against you!]],
	level_range = {15, nil}, exp_worth = 2,
	rarity = 10,
	max_life = 120,
	resolvers.equip{
		{type="weapon", subtype="staff", ego_chance=30, forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="cloth", ego_chance=30, forbid_power_source={antimagic=true}, autoreq=true},
	},
	autolevel = "caster", ai_tactic = resolvers.tactic("ranged"),
	resolvers.drops{chance=50, nb=1, {type="weapon", subtype="staff", force_drop=true, tome_drops="boss"}},
	combat_def = 4,
	resolvers.talents{
		[Talents.T_CIRCLE_OF_SHIFTING_SHADOWS]=2,
		[Talents.T_CIRCLE_OF_BLAZING_LIGHT]=2,
		[Talents.T_TWILIGHT]=2,
		[Talents.T_SEARING_LIGHT]=2,
		[Talents.T_MOONLIGHT_RAY]=1,
		[Talents.T_HYMN_OF_SHADOWS]=2,
		[Talents.T_CHANT_OF_FORTRESS]=2,
	},
}

newEntity{ name = "sun paladin",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "human", image = "npc/humanoid_human_human_sun_paladin.png",
	color=colors.LIGHT_UMBER,
	life_rating = 12,

	stats = { str=20, dex=20, mag=15, con=10, wil=15 },
	desc = [[Warriors from afar. They wield the power of light, and a mean sword.]],
	level_range = {15, nil}, exp_worth = 2,
	rarity = 10,
	max_life = 150,
	resolvers.equip{
		{type="weapon", subtype="longsword", ego_chance=30, forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="massive", forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="shield", ego_chance=30, forbid_power_source={antimagic=true}, autoreq=true},
	},
	resolvers.drops{chance=50, nb=1, {type="weapon", subtype="staff", force_drop=true, tome_drops="boss"}},
	combat_def = 4,
	autolevel = "warriormage", ai_tactic = resolvers.tactic("tank"),
	resolvers.talents{
		[Talents.T_CHANT_OF_FORTITUDE]=3,
		[Talents.T_WEAPON_OF_LIGHT]=2,
		[Talents.T_WAVE_OF_POWER]=2,
		[Talents.T_CRUSADE]=3,
		[Talents.T_SHIELD_OF_LIGHT]=1,
		[Talents.T_BRANDISH]=1,
		[Talents.T_ARMOUR_TRAINING]=2,
		[Talents.T_WEAPON_COMBAT]=2,
	},
}

newEntity{ name = "star crusader",
	base = "BASE_NPC_ARENA1",
	type = "humanoid", subtype = "elf",
	color=colors.GOLD,
	life_rating = 10,

	stats = { str=25, dex=25, mag=25, con=8, wil=25 },
	desc = [[Warriors from afar. They wield the power of light, and a mean sword. Darkness, too.]],
	level_range = {20, nil}, exp_worth = 2,
	rarity = 10,
	max_life = 150,
	stun_immune = 0.9,
	fear_immune = 1,
	stun_immune = 0.2,
	confusion_immune = 0.4,
	resolvers.equip{
		{type="weapon", subtype="longsword", ego_chance=30, forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="massive", forbid_power_source={antimagic=true}, autoreq=true},
		{type="armor", subtype="shield", ego_chance=50, forbid_power_source={antimagic=true}, autoreq=true},
	},
	resists = { [DamageType.LIGHT] = 95 ,[DamageType.DARKNESS] = 95 },
	resolvers.drops{ chance=50, nb=1, {type="weapon", subtype="staff", force_drop=true, tome_drops="boss"} },
	combat_def = 4,
	autolevel = "warriormage", ai_tactic = resolvers.tactic("melee"),
	resolvers.talents{
		[Talents.T_CIRCLE_OF_SHIFTING_SHADOWS]=2,
		[Talents.T_CIRCLE_OF_BLAZING_LIGHT]=2,
		[Talents.T_TWILIGHT]=2,
		[Talents.T_SEARING_LIGHT]=2,
		[Talents.T_MOONLIGHT_RAY]=1,
		[Talents.T_HYMN_OF_SHADOWS]=2,
		[Talents.T_CHANT_OF_FORTRESS]=2,
		[Talents.T_WEAPON_OF_LIGHT]=2,
		[Talents.T_CRUSADE]=3,
		[Talents.T_BRANDISH]=1,
		[Talents.T_RETRIBUTION]=1,
		[Talents.T_ARMOUR_TRAINING]=1,
		[Talents.T_WEAPON_COMBAT]=1,
		[Talents.T_WEAPONS_MASTERY]=1,
	},
}