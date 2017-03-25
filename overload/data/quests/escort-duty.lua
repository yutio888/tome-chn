-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2017 Nicolas Casalini
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

local Talents = require("engine.interface.ActorTalents")
local Stats = require("engine.interface.ActorStats")
local NameGenerator = require("engine.NameGenerator")
local Astar = require("engine.Astar")

use_ui = "quest-escort"

--------------------------------------------------------------------------------
-- Quest data
--------------------------------------------------------------------------------
local name_rules = {
	male = {
		phonemesVocals = "a, e, i, o, u, y",
		phonemesConsonants = "b, c, ch, ck, cz, d, dh, f, g, gh, h, j, k, kh, l, m, n, p, ph, q, r, rh, s, sh, t, th, ts, tz, v, w, x, z, zh",
		syllablesStart = "Aer, Al, Am, An, Ar, Arm, Arth, B, Bal, Bar, Be, Bel, Ber, Bok, Bor, Bran, Breg, Bren, Brod, Cam, Chal, Cham, Ch, Cuth, Dag, Daim, Dair, Del, Dr, Dur, Duv, Ear, Elen, Er, Erel, Erem, Fal, Ful, Gal, G, Get, Gil, Gor, Grin, Gun, H, Hal, Han, Har, Hath, Hett, Hur, Iss, Khel, K, Kor, Lel, Lor, M, Mal, Man, Mard, N, Ol, Radh, Rag, Relg, Rh, Run, Sam, Tarr, T, Tor, Tul, Tur, Ul, Ulf, Unr, Ur, Urth, Yar, Z, Zan, Zer",
		syllablesMiddle = "de, do, dra, du, duna, ga, go, hara, kaltho, la, latha, le, ma, nari, ra, re, rego, ro, rodda, romi, rui, sa, to, ya, zila",
		syllablesEnd = "bar, bers, blek, chak, chik, dan, dar, das, dig, dil, din, dir, dor, dur, fang, fast, gar, gas, gen, gorn, grim, gund, had, hek, hell, hir, hor, kan, kath, khad, kor, lach, lar, ldil, ldir, leg, len, lin, mas, mnir, ndil, ndur, neg, nik, ntir, rab, rach, rain, rak, ran, rand, rath, rek, rig, rim, rin, rion, sin, sta, stir, sus, tar, thad, thel, tir, von, vor, yon, zor",
		rules = "$s$v$35m$10m$e",
	},
	female = {
		phonemesVocals = "a, e, i, o, u, y",
		syllablesStart = "Ad, Aer, Ar, Bel, Bet, Beth, Ce'N, Cyr, Eilin, El, Em, Emel, G, Gl, Glor, Is, Isl, Iv, Lay, Lis, May, Ner, Pol, Por, Sal, Sil, Vel, Vor, X, Xan, Xer, Yv, Zub",
		syllablesMiddle = "bre, da, dhe, ga, lda, le, lra, mi, ra, ri, ria, re, se, ya",
		syllablesEnd = "ba, beth, da, kira, laith, lle, ma, mina, mira, na, nn, nne, nor, ra, rin, ssra, ta, th, tha, thra, tira, tta, vea, vena, we, wen, wyn",
		rules = "$s$v$35m$10m$e",
	},
}

local possible_types = {
	{ name="lost warrior", random="male", chance=70,
		text = [[帮帮我！我在这地方迷路了，我有个朋友给我留下了一个传送门，不过我打了太多仗恐怕靠我自己是到不了那里了，你能帮我一下吗？]],
		actor = {
			type = "humanoid", subtype = "human", image = "player/higher_male.png",
			display = "@", color=colors.UMBER,
			name = "%s, 迷路的战士",
			desc = [[他看起来又累又饿，且身受重伤。]],
			autolevel = "warrior",
			ai = "escort_quest", ai_state = { talent_in=4, },
			stats = { str=18, dex=13, mag=5, con=15 },

			body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
			resolvers.equip{ {type="weapon", subtype="greatsword", autoreq=true} },
			resolvers.talents{ [Talents.T_STUNNING_BLOW]=1, },
			lite = 4,
			rank = 2,
			exp_worth = 1,
			antimagic_ok = true,

			max_life = 50, life_regen = 0,
			life_rating = 12,
			combat_armor = 3, combat_def = 3,
			inc_damage = {all=-50},

			reward_type = "warrior",
		},
	},
	{ name="injured seer", random="female", chance=70,
		text = [[帮帮我！我在这地方迷路了，我有个朋友给我留下了一个传送门，不过靠我自己是到不了那里了，你能帮我一下吗？]],
		actor = {
			name = "%s, 受伤的先知",
			type = "humanoid", subtype = "elf", female=true, image = "player/halfling_female.png",
			display = "@", color=colors.LIGHT_BLUE,
			desc = [[她看起来又累又饿，且身受重伤。]],
			autolevel = "caster",
			ai = "escort_quest", ai_state = { talent_in=4, },
			stats = { str=8, dex=7, mag=18, con=12 },

			body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
			resolvers.equip{ {type="weapon", subtype="staff", autoreq=true} },
			resolvers.talents{ [Talents.T_MANATHRUST]=1, },
			lite = 4,
			rank = 2,
			exp_worth = 1,

			max_life = 50, life_regen = 0,
			life_rating = 11,
			combat_armor = 3, combat_def = 3,
			inc_damage = {all=-50},

			reward_type = "divination",
		},
	},
	{ name="repented thief", random="male", chance=70,
		text = [[帮帮我！我在这地方迷路了，我有个朋友给我留下了一个传送门，不过我打了太多仗恐怕靠我自己是到不了那里了，你能帮我一下吗？]],
		actor = {
			name = "%s, 忏悔的盗贼",
			type = "humanoid", subtype = "halfling", image = "player/cornac_male.png",
			display = "@", color=colors.BLUE,
			desc = [[他看起来又累又饿，且身受重伤。]],
			autolevel = "rogue",
			ai = "escort_quest", ai_state = { talent_in=4, },
			stats = { str=8, dex=7, mag=18, con=12 },

			body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
			resolvers.equip{ {type="weapon", subtype="dagger", autoreq=true}, {type="weapon", subtype="dagger", autoreq=true} },
			resolvers.talents{ [Talents.T_DIRTY_FIGHTING]=1, },
			lite = 4,
			rank = 2,
			exp_worth = 1,
			antimagic_ok = true,

			max_life = 50, life_regen = 0,
			life_rating = 11,
			combat_armor = 3, combat_def = 3,
			inc_damage = {all=-50},

			reward_type = "survival",
		},
	},
	{ name="lone alchemist", random="male", chance=70,
		text = [[帮帮我！我在这地方迷路了，我有个朋友给我留下了一个传送门，不过我打了太多仗恐怕靠我自己是到不了那里了，你能帮我一下吗？]],
		actor = {
			name = "%s, 落单的炼金术师",
			type = "humanoid", subtype = "human", image = "player/shalore_male.png",
			display = "@", color=colors.AQUAMARINE,
			desc = [[他看起来又累又饿，且身受重伤。]],
			autolevel = "rogue",
			ai = "escort_quest", ai_state = { talent_in=4, },
			stats = { str=8, dex=7, mag=18, con=12 },

			body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
			resolvers.equip{ {type="weapon", subtype="staff", autoreq=true} },
			resolvers.talents{ [Talents.T_HEAT]=1, },
			lite = 4,
			rank = 2,
			exp_worth = 1,

			max_life = 50, life_regen = 0,
			life_rating = 11,
			combat_armor = 3, combat_def = 3,
			inc_damage = {all=-50},

			reward_type = "alchemy",
		},
	},
	{ name="lost sun paladin", random="female", chance=70,
		text = [[帮帮我！我在这地方迷路了，我有个朋友给我留下了一个传送门，不过我打了太多仗恐怕靠我自己是到不了那里了，你能帮我一下吗？]],
		actor = {
			name = "%s, 迷路的太阳骑士",
			type = "humanoid", subtype = "human", female=true, image = "player/higher_female.png",
			display = "@", color=colors.GOLD,
			desc = [[她看起来又累又饿，且身受重伤。]],
			autolevel = "warriormage",
			ai = "escort_quest", ai_state = { talent_in=4, },
			stats = { str=18, dex=7, mag=18, con=12 },

			body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
			resolvers.equip{ {type="weapon", subtype="mace", autoreq=true} },
			resolvers.talents{ [Talents.T_CHANT_OF_FORTRESS]=1, },
			lite = 4,
			rank = 2,
			exp_worth = 1,

			max_life = 50, life_regen = 0,
			life_rating = 12,
			combat_armor = 3, combat_def = 3,
			inc_damage = {all=-50},

			reward_type = "sun_paladin",
			sunwall_query = true,
		},
	},
	{ name="lost anorithil", random="female", chance=70,
		text = [[帮帮我！我在这地方迷路了，我有个朋友给我留下了一个传送门，不过我打了太多仗恐怕靠我自己是到不了那里了，你能帮我一下吗？]],
		actor = {
			name = "%s, 迷路的星月术士",
			type = "humanoid", subtype = "human", female=true, image = "player/higher_female.png",
			display = "@", color=colors.YELLOW,
			desc = [[她看起来又累又饿，且身受重伤。]],
			autolevel = "caster",
			ai = "escort_quest", ai_state = { talent_in=4, },
			stats = { str=8, dex=7, mag=18, con=12 },

			body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
			resolvers.equip{ {type="weapon", subtype="staff", autoreq=true} },
			resolvers.talents{ [Talents.T_HYMN_OF_PERSEVERANCE]=1, },
			lite = 4,
			rank = 2,
			exp_worth = 1,

			max_life = 50, life_regen = 0,
			life_rating = 11,
			combat_armor = 3, combat_def = 3,
			inc_damage = {all=-50},

			reward_type = "anorithil",
			sunwall_query = true,
		},
	},
	{ name="temporal explorer", random="player", portal="temporal portal", chance=30,
		text = [[呃……你是……另一个我吗？
好吧，我是对的，这已经不是我本来的时间线了！
帮帮我！我在这地方迷路了，我有个朋友给我留下了一个传送门，不过我打了太多仗恐怕靠我自己是到不了那里了，你能帮我……呃……你自己一下吗？]],
		actor = {
			name = "%s, 时空探索者",
			type = "humanoid", subtype = "human", female=true, image = "player/higher_female.png",
			display = "@", color=colors.YELLOW,
			desc = [[她看起来又累又饿，且身受重伤。她跟你是如此的相像，但完全不一样。好奇怪。]],
			autolevel = "caster",
			ai = "escort_quest", ai_state = { talent_in=4, },
			stats = { str=8, dex=7, mag=18, con=12 },

			body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
			resolvers.equip{ {type="weapon", subtype="staff", autoreq=true} },
			resolvers.talents{ [Talents.T_DUST_TO_DUST]=1, },
			lite = 4,
			rank = 2,
			exp_worth = 1,

			max_life = 50, life_regen = 0,
			life_rating = 11,
			combat_armor = 3, combat_def = 3,
			inc_damage = {all=-50},

			reward_type = "temporal",
		},
	},
	{ name="worried loremaster", random="female", chance=30,
		text = [[帮帮我！我在这地方迷路了，我有个朋友给我留下了一个传送门，不过我打了太多仗恐怕靠我自己是到不了那里了，你能帮我一下吗？]],
		actor = {
			name = "%s, 担忧的贤者",
			type = "humanoid", subtype = "human", female=true, image = "player/thalore_female.png",
			display = "@", color=colors.LIGHT_GREEN,
			desc = [[她看起来又累又饿，且身受重伤。]],
			autolevel = "wildcaster",
			ai = "escort_quest", ai_state = { talent_in=4, },
			stats = { str=8, dex=7, mag=18, con=12 },

			body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },
			resolvers.equip{ {type="weapon", subtype="staff", autoreq=true} },
			resolvers.talents{ [Talents.T_MIND_SEAR]=1, },
			lite = 4,
			rank = 2,
			exp_worth = 1,
			antimagic_ok = true,

			max_life = 50, life_regen = 0,
			life_rating = 10,
			combat_armor = 3, combat_def = 3,
			inc_damage = {all=-50},

			reward_type = "exotic",
		},
	},
}

--------------------------------------------------------------------------------
-- Quest code
--------------------------------------------------------------------------------

-- Random escort
id = "escort-duty-"..game.zone.short_name.."-"..game.level.level

kind = {}

name = ""
desc = function(self, who)
	local desc = {}
	if self:isStatus(engine.Quest.DONE) then
		desc[#desc+1] = "You successfully escorted the "..self.kind.name.." to the recall portal on level "..self.level_name.."."
		if self.reward_message then
			desc[#desc+1] = ("As a reward you %s."):format(self.reward_message)
		end
	elseif self:isStatus(engine.Quest.FAILED) then
		if self.abandoned then
			desc[#desc+1] = "You abandoned "..self.kind.name.." to death."
		else
			desc[#desc+1] = "You failed to protect the "..self.kind.name.." from death by "..(self.killing_npc or "???").."."
		end
	else
		desc[#desc+1] = "Escort the "..self.kind.name.." to the recall portal on level "..self.level_name.."."
	end
	return table.concat(desc, "\n")
end

on_status_change = function(self, who, status, sub)
	if status == self.FAILED then
		-- Remove the actor is we failed
		for uid, e in pairs(game.level.entities) do
			if e.quest_id and e.quest_id == self.id then
				game.party:removeMember(e, true)
				e:disappear()
				e:removed()
			end
		end
	end
end

local function getPortalSpot(npc, dist, min_dist)
	local astar = Astar.new(game.level.map, npc)
	local poss = {}
	dist = math.floor(dist)
	min_dist = math.floor(min_dist or 0)

	for i = npc.x - dist, npc.x + dist do
		for j = npc.y - dist, npc.y + dist do
			if game.level.map:isBound(i, j) and
			   core.fov.distance(npc.x, npc.y, i, j) <= dist and
			   core.fov.distance(npc.x, npc.y, i, j) >= min_dist and
			   game.level.map(i, j, engine.Map.TERRAIN) and not game.level.map(i, j, engine.Map.TERRAIN).change_level and
			   npc:canMove(i, j) then
				poss[#poss+1] = {i,j}
			end
		end
	end

	while #poss > 0 do
		local pos = rng.tableRemove(poss)
		if astar:calc(npc.x, npc.y, pos[1], pos[2]) then
			print("Placing portal at ", pos[1], pos[2])
			return pos[1], pos[2]
		end
	end
end

on_grant = function(self, who)
	local x, y = util.findFreeGrid(who.x, who.y, 10, true, {[engine.Map.ACTOR]=true})
	if not x then return true end

	self.on_grant = nil

	local hd = {"Quest:escort:assign", possible_types=possible_types}
	if self:triggerHook(hd) then possible_types = hd.possible_types end

	game.state.escorts_seen = game.state.escorts_seen or {}
	local escorts_seen = game.state.escorts_seen
	while true do
		self.kind = rng.table(possible_types)
		if not self.kind.unique or not escorts_seen[self.kind.name] then
			if rng.percent(self.kind.chance) then break end
		end
	end
	escorts_seen[self.kind.name] = (escorts_seen[self.kind.name] or 0) + 1

	if self.kind.random == "player" then
		self.kind.actor.name = self.kind.actor.name:format(game.player.name)
	else
		local ng = NameGenerator.new(name_rules[self.kind.random])
		self.kind.actor.name = self.kind.actor.name:format(ng:generate())
	end

	self.kind.actor.level_range = {game.player.level, game.player.level}
	self.kind.actor.faction = who.faction
	self.kind.actor.summoner = who
	self.kind.actor.quest_id = self.id
	self.kind.actor.no_inventory_access = true
	self.kind.actor.escort_quest = true
	self.kind.actor.remove_from_party_on_death = true
	self.kind.actor.on_die = function(self, who)
		if self.sunwall_query then game.state.found_sunwall_west_died = true end
		game.logPlayer(game.player, "#LIGHT_RED#%s is dead, quest failed!", self.name:capitalize())
		game.player:setQuestStatus(self.quest_id, engine.Quest.FAILED)
		game.player:hasQuest(self.quest_id).killing_npc = who and who.name or "something"
		if who.resolveSource and who:resolveSource().player then
			world:gainAchievement("ESCORT_KILL", game.player)
			game.player:registerEscorts("betrayed")
		else
			world:gainAchievement("ESCORT_LOST", game.player)
			game.player:registerEscorts("lost")
		end
	end

	-- Spawn actor
	local npc = mod.class.NPC.new(self.kind.actor)
	npc:resolve() npc:resolve(nil, true)
	npc.x, npc.y = x, y
	self.kind.actor = nil

	-- Spawn the portal, far enough from the escort
	local gx, gy = getPortalSpot(npc, 150, 10)
	if not gx then return true end
	local g = game.level.map(gx, gy, engine.Map.TERRAIN)
	g = g:cloneFull()
	g.__nice_tile_base = nil
	g.show_tooltip = true
	g.name = (self.kind.portal or "Recall Portal")..": "..npc.name
	g.display = '&'
	g.color_r = colors.VIOLET.r
	g.color_g = colors.VIOLET.g
	g.color_b = colors.VIOLET.b
	g.special_minimap = colors.VIOLET
	g.add_displays = g.add_displays or {}
	g.add_displays[#g.add_displays+1] = mod.class.Grid.new{image="terrain/maze_teleport.png"}
	g.notice = true
	g.always_remember = true
	g.escort_portal = true
	g:altered()
	g.on_move = function(self, x, y, who)
		if not who.escort_quest then return end
		game.player:setQuestStatus(who.quest_id, engine.Quest.DONE)
		local Chat = require "engine.Chat"
		Chat.new("escort-quest", who, game.player, {npc=who}):invoke()
		world:gainAchievement("ESCORT_SAVED", game.player)
		who:disappear()
		who:removed()
		game.party:removeMember(who, true)
	end
	g:removeAllMOs()

	g:resolve() g:resolve(nil, true)
	game.zone:addEntity(game.level, g, "terrain", gx, gy)
	npc.escort_target = {x=gx, y=gy}
	npc.x, npc.y = nil, nil
	game.zone:addEntity(game.level, npc, "actor", x, y)

	-- Setup quest
	self.level_name = game.level.level.." of "..game.zone.name
	self.name = "Escort: "..self.kind.name.." (level "..self.level_name..")"

	local Chat = require "engine.Chat"
	Chat.new("escort-quest-start", npc, game.player, {text=self.kind.text, npc=npc}):invoke()

	-- Check if we found sunpaladins/anorithils before going east
	if npc.sunwall_query then
		game.state.found_sunwall_west = true
	end
end
