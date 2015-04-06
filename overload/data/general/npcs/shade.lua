-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011, 2012, 2013 Nicolas Casalini
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

-- Shades are very special, they are not monsters on their own, they are shades of some other monster

newEntity{
	define_as = "BASE_NPC_SHADE",
	type = "undead", subtype = "shade",
	display = "G", color=colors.DARK_GREY,
	blood_color = colors.GREY,
	power_source = {}, -- means forbid randelites

	resolvers.generic(function(e)
		local base = game.zone:makeEntity(game.level, "actor", e.shade_filter, nil , true)
		while base.unique do base = game.zone:makeEntity(game.level, "actor", e.shade_filter, nil , true) end

		base.color_r = e.color_r
		base.color_g = e.color_g
		base.color_b = e.color_b
		base.desc = e.desc

		e:replaceWith(base)

		-- Make the shade nasty
		e.name = "影之 "..e.name
		e.can_pass = {pass_wall=70}
		e.undead = 1
		e.no_breath = 1
		e.stone_immune = 1
		e.confusion_immune = 1
		e.fear_immune = 1
		e.teleport_immune = 1
		e.disease_immune = 1
		e.poison_immune = 1
		e.cut_immune = 1
		e.stun_immune = 1
		e.blind_immune = 1
		e.see_invisible = 80
		e.max_life = e.max_life * 0.50
		e.life = e.max_life
		e.resists.all = 20
		e.lite = nil

		-- AI
		e.ai_state.sense_radius = 6
		e.ai_state.ai_target = "target_simple_or_player_radius"

		-- No escorts
		e.make_escort = nil

		-- Remove some talents
		local tids = {}
		for tid, _ in pairs(e.talents) do tids[#tids+1] = tid end
		local nb = math.floor(#tids / 4)
		for i = 1, nb do
			local tid = rng.tableRemove(tids)
			e.talents[tid] = nil
		end

		-- Summon shady friends (if possible)
		e.summon = { {type="undead", subtype="shade", number=1, hasxp=false}, }

		-- Give some talents
		local rtals = {
			{tid=e.T_SUMMON, level=1},
			{tid=e.T_WILLFUL_STRIKE, level=5},
			{tid=e.T_REPROACH, level=5},
			{tid=e.T_FEED_STRENGTHS, level=4},
			{tid=e.T_FEED_POWER, level=4},
		}
		for i = 1, 3 do
			local t = rng.tableRemove(rtals)
			e.talents[t.tid] = t.level
		end
		e:incStat("wil", 25)
	end),
}

newEntity{ base = "BASE_NPC_SHADE",
	rarity = 1, level_range = {30, nil},
	desc = [[通过一些可怕的秘法，这只生物的影子被剥离出了它原本的身体并获得了亡灵之躯。]],
	shade_filter = {type="animal", special_rarity="shade_rarity"},
}

newEntity{ base = "BASE_NPC_SHADE",
	rarity = 1, level_range = {30, nil},
	desc = [[通过一些可怕的秘法，这只生物的影子被剥离出了它原本的身体并获得了亡灵之躯。]],
	shade_filter = {type="humanoid", special_rarity="shade_rarity"},
}

newEntity{ base = "BASE_NPC_SHADE",
	rarity = 1, level_range = {30, nil},
	desc = [[通过一些可怕的秘法，这只生物的影子被剥离出了它原本的身体并获得了亡灵之躯。]],
	shade_filter = {type="giant", special_rarity="shade_rarity"},
}
