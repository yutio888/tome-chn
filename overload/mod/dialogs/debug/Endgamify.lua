-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2019 Nicolas Casalini
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

require "engine.class"
require "engine.ui.Dialog"
local List = require "engine.ui.List"
local GetQuantity = require "engine.dialogs.GetQuantity"

module(..., package.seeall, class.make)

function _M:run()
	local NPC = require "mod.class.NPC"
	local Chat = require "engine.Chat"
	if game.player.endgamified then return end
	game.player.endgamified = true
	game.player.unused_generics = game.player.unused_generics + 2  -- Derth quest
	game.player:learnTalent(game.player.T_RELENTLESS_PURSUIT, 1)
	game.player:forceLevelup(50)
	game.player.money = 999999

	self:makeEndgameItems()
	self:makeEndgameFixed()

	game.state:goneEast()
	game.player:grantQuest("lost-merchant")
	game.player:setQuestStatus("lost-merchant", engine.Quest.COMPLETED, "saved")

	-- Change the zone name each iteration so the quest id is different
	local old_name = game.zone.short_name
	for i = 1,5 do
		game.zone.short_name = game.zone.short_name..i
		game.player:grantQuest("escort-duty")
		for _, e in pairs(game.level.entities) do
			if e.quest_id then
				-- Make giving the reward their first action so it happens after the dialogs are closed
				e.act = function(self)
					self.on_die = nil
					game.player:setQuestStatus(self.quest_id, engine.Quest.DONE)
					local Chat = require "engine.Chat"
					Chat.new("escort-quest", self, game.player, {npc=self}):invoke()
					self:disappear()
					self:removed()
					game.party:removeMember(self, true)
				end
			end
		end
		game.zone.short_name = old_name
	end
end

-- {Rares, Randarts}
local endgame_items = {
	["voratun helm"] = {10,3},
	["voratun gauntlets"] = {5,2},
	["drakeskin leather gloves"] = {5,2},
	["voratun ring"] = {10,3},
	["voratun amulet"] = {5,2},
	["voratun mail armour"] = {5,4},
	["voratun plate armour"] = {5,4},
	["elven-silk wizard hat"] = {10,3},
	["elven-silk cloak"] = {10,3},
	["dragonbone totem"] = {5,2},
	["voratun torque"] = {5,2},
	["dragonbone wand"] = {5,2},
	["drakeskin leather cap"] = {10,3},
	["voratun pickaxe"] = {5,2},
	["dwarven lantern"] = {5,2},
	["pair of drakeskin leather boots"] = {10,3},
	["pair of voratun boots"] = {10,3},
	["drakeskin leather belt"] = {10,3},
}

local endgame_class_items = {
	["Anorithil"] = {["dragonbone staff"] = {10,3}, ["elven-silk robe"] = {5,4},},
	["Sun Paladin"] = {	["voratun longsword"] = {10,3},	["voratun greatsword"] = {10,3}, ["voratun shield"] = {10,3} },	
		
	["Cursed"] = {	["voratun longsword"] = {10,3}, ["voratun greatsword"] = {10,3}, ["living mindstar"] = {10,3}},	
	["Doomed"] = {["living mindstar"] = {10,3}},	
	
	["Temporal Warden"] = {["voratun longsword"] = {10,3}, ["voratun dagger"] = {10,3}, ["quiver of dragonbone arrows"] = {10,3}, ["dragonbone longbow"] = {10,3},},
	["Paradox Mage"] = {["dragonbone staff"] = {10,3}, ["elven-silk robe"] = {5,4},},

	["Corruptor"] = {["dragonbone staff"] = {10,3}, ["elven-silk robe"] = {5,4},},
	["Reaver"] = {["dragonbone staff"] = {10,3}, ["elven-silk robe"] = {5,4}, ["voratun longsword"] = {10,3},},

	["Alchemist"] = {["dragonbone staff"] = {10,3}, ["elven-silk robe"] = {5,4},},
	["Archmage"] = {["dragonbone staff"] = {10,3}, ["elven-silk robe"] = {5,4},},
	["Necromancer"] = {["dragonbone staff"] = {10,3}, ["elven-silk robe"] = {5,4},},

	["Mindslayer"] = {["voratun greatsword"] = {10,3}, ["living mindstar"] = {10,3}},
	["Solipsist"] = {["living mindstar"] = {10,3}},

	["Rogue"] = {["voratun longsword"] = {10,3}, ["voratun dagger"] = {10,3}, ["drakeskin leather armour"] = {5,4},},
	["Shadowblade"] = {["voratun longsword"] = {10,3}, ["voratun dagger"] = {10,3}, ["drakeskin leather armour"] = {5,4}, },
	["Skirmisher"] = {["pouch of voratun shots"] = {10,3}, ["drakeskin leather sling"] = {10,3}, ["drakeskin leather armour"] = {5,4},},
	["Marauder"] = {["voratun longsword"] = {10,3}, ["drakeskin leather armour"] = {5,4}, ["voratun dagger"] = {10,3}},

	["Arcane Blade"] = {["dragonbone staff"] = {10,3}, ["voratun longsword"] = {10,3}, ["voratun greatsword"] = {10,3}, ["voratun shield"] = {10,3}, ["voratun dagger"] = {10,3}},
	["Brawler"] = {["drakeskin leather armour"] = {5,4}, },
	["Bulwark"] = {["voratun longsword"] = {10,3}, ["voratun shield"] = {10,3}},
	["Berserker"] = {["voratun greatsword"] = {10,3}},
	["Archer"] = {["quiver of dragonbone arrows"] = {10,3}, ["pouch of voratun shots"] = {10,3}, ["dragonbone longbow"] = {10,3}, ["drakeskin leather sling"] = {10,3}, ["drakeskin leather armour"] = {5,4}, },

	["Summoner"] = {["living mindstar"] = {10,3}},
	["Oozemancer"] = {["living mindstar"] = {10,3}},
	["Wyrmic"] = {["voratun longsword"] = {10,3}, ["voratun greatsword"] = {10,3}, ["voratun shield"] = {10,3}, ["living mindstar"] = {10,3}},
	["Stone Warden"] = {["voratun shield"] = {10,3}},

	["Other"] = {
			["dragonbone staff"] = {10,3}, ["voratun longsword"] = {10,3}, ["dragonbone longbow"] = {10,3}, ["pouch of voratun shots"] = {10,3}, ["drakeskin leather armour"] = {5,4},
			["drakeskin leather sling"] = {10,3}, ["voratun greatsword"] = {10,3}, ["voratun shield"] = {10,3}, ["living mindstar"] = {10,3}, ["voratun dagger"] = {10,3}, 
			["quiver of dragonbone arrows"] = {10,3},
		},  -- We don't know what we want, so create everything
}

-- Fixedarts from quests or things that we can assume experienced players almost always get
local endgame_fixed_artifacts= {"ORB_ELEMENTS", "ORB_UNDEATH", "ORB_DESTRUCTION", "ORB_DRAGON", "RUNE_DISSIPATION", "INFUSION_WILD_GROWTH", "TAINT_PURGING", "RING_OF_BLOOD", "ELIXIR_FOUNDATIONS",
								"SANDQUEEN_HEART", "PUTRESCENT_POTION", "ELIXIR_FOCUS", "MUMMIFIED_EGGSAC", "ORB_MANY_WAYS", "ROD_SPYDRIC_POISON" }
function _M:makeEndgameItems(class, ilvl, filter)
	local class_name = game.player.descriptor.subclass
	local items = table.merge(table.clone(endgame_items), table.clone(endgame_class_items[class_name] or endgame_class_items["Other"]))
	for base, amounts in pairs(items) do
		table.print(amounts)
		for i = 1, amounts[2] do
			local base_object = game.zone:makeEntity(game.level, "object", {name=base, ignore_material_restriction=true, ego_filter={keep_egos=true, ego_chance=-1000}}, nil, true)

			local filter = {base=base_object, material_level = 5, lev=60}
			local item = game.state:generateRandart(filter)
			item.__transmo = true		
			item:identify(true)
			game.zone:addEntity(game.level, item, "object")
			game.player:addObject(game.player:getInven("INVEN"), item)
		end
		-- Create rares
		for i = 1, amounts[1] do
			local base_object = game.zone:makeEntity(game.level, "object", {name=base, ignore_material_restriction=true, ego_filter={keep_egos=true, ego_chance=-1000}}, nil, true)
			local filter = {base=base_object, lev=60, egos=1, material_level = 5, greater_egos_bias = 0, power_points_factor = 3, nb_powers_add = 2, }
			local item = game.state:generateRandart(filter)
			item.unique, item.randart, item.rare = nil, nil, true
			item.__transmo = true		
			item:identify(true)
			game.zone:addEntity(game.level, item, "object")
			game.player:addObject(game.player:getInven("INVEN"), item)
		end

	end
	return 
end

function _M:makeEndgameFixed()
	local Object = require "mod.class.Object"

	local old_list = game.zone.object_list
	local obj_list = table.clone(game.zone.object_list, true)
	obj_list.ignore_loaded = true

	-- protected load of objects from a file
	local function load_file(file, obj_list)
		local ok, ret = xpcall(function()
			Object:loadList(file, false, obj_list, nil, obj_list.__loaded_files)
			end, debug.traceback)
		if not ok then
			game.log("#ORANGE# Create Object: Unable to load all objects from file %s:#GREY#\n %s", file, ret)
		end
	end
	-- load all objects from a base directory
	local function load_objects(base)
		local file
		file = base.."/general/objects/objects.lua"
		if fs.exists(file) then load_file(file, obj_list) end

		file = base.."/general/objects/world-artifacts.lua"
		if fs.exists(file) then load_file(file, obj_list) end

		file = base.."/general/objects/boss-artifacts.lua"
		if fs.exists(file) then load_file(file, obj_list) end

		file = base.."/general/objects/quest-artifacts.lua"
		if fs.exists(file) then load_file(file, obj_list) end
		
		file = base.."/general/objects/brotherhood-artifacts.lua"
		if fs.exists(file) then load_file(file, obj_list) end

		if fs.exists(file) then load_file(file, obj_list) end
		for i, dir in ipairs(fs.list(base.."/zones/")) do
			file = base.."/zones/"..dir.."/objects.lua"
			if dir ~= game.zone.short_name and fs.exists(file) and not dir:find("infinite%-dungeon") and not dir:find("noxious%-caldera") then
				load_file(file, obj_list)
			end
		end
	end
	
	-- load base global and zone objects
	load_objects("/data", "")

	-- load all objects defined by addons (in standard directories)
	for i, dir in ipairs(fs.list("/")) do
		local _, _, addon = dir:find("^data%-(.+)$")
		if addon then
			load_objects("/"..dir)
		end
	end
	game.zone.object_list = obj_list
	for _, name in pairs(endgame_fixed_artifacts) do
			local o = game.zone:makeEntityByName(game.level, "object", name)
			if not o then game.log("Failed to generate "..name) break end
			o:identify(true)
			game.zone:addEntity(game.level, o, "object")
			game.player:addObject(game.player:getInven("INVEN"), o)
	end
	game.zone.object_list = old_list
end
