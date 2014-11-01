-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2014 Nicolas Casalini
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

load("/data/general/grids/basic.lua")
load("/data/general/grids/water.lua")
load("/data/general/grids/forest.lua")
load("/data/general/grids/lava.lua")
load("/data/general/grids/cave.lua")

newEntity{
	define_as = "FAR_EAST_PORTAL",
	name = "Farportal: the Far East",
	display = '&', color_r=255, color_g=0, color_b=220, back_color=colors.VIOLET, image = "terrain/marble_floor.png",
	notice = true,
	always_remember = true,
	show_tooltip = true,
	desc = [[A farportal is a way to travel incredible distances in the blink of an eye. They usually require an external item to use. You have no idea if it is even two-way.
This one seems to go to the Far East.]],

	orb_portal = {
		change_level = 1,
		change_zone = "wilderness",
		change_wilderness = {
			spot = {type="farportal-end", subtype="fareast"},
		},
		message = "#VIOLET#You enter the swirling portal and in the blink of an eye you set foot on the Far East, with no trace of the portal...",
		on_use = function(self, who)
		end,
	},
}
newEntity{ base = "FAR_EAST_PORTAL", define_as = "CFAR_EAST_PORTAL",
	image = "terrain/marble_floor.png",
	add_displays = {class.new{image="terrain/farportal-base.png", display_x=-1, display_y=-1, display_w=3, display_h=3}},
	on_added = function(self, level, x, y)
		level.map:particleEmitter(x, y, 3, "farportal_vortex")
		level.map:particleEmitter(x, y, 3, "farportal_lightning")
		level.map:particleEmitter(x, y, 3, "farportal_lightning")
		level.map:particleEmitter(y, y, 3, "farportal_lightning")
	end,
}

newEntity{
	define_as = "WEST_PORTAL",
	name = "Farportal: Iron Throne",
	display = '&', color_r=255, color_g=0, color_b=220, back_color=colors.VIOLET, image = "terrain/marble_floor.png",
	notice = true,
	always_remember = true,
	show_tooltip = true,
	desc = [[A farportal is a way to travel incredible distances in the blink of an eye. They usually require an external item to use. You have no idea if it is even two-way.
This one seems to go to the Iron Throne in the West.]],

	orb_portal = {
		change_level = 1,
		change_zone = "wilderness",
		change_wilderness = {
			spot = {type="farportal-end", subtype="iron-throne"},
		},
		message = "#VIOLET#You enter the swirling portal and in the blink of an eye you set foot on the slopes of the Iron Throne, with no trace of the portal...",
		on_use = function(self, who)
		end,
	},
}
newEntity{ base = "WEST_PORTAL", define_as = "CWEST_PORTAL",
	image = "terrain/marble_floor.png",
	add_displays = {class.new{image="terrain/farportal-base.png", display_x=-1, display_y=-1, display_w=3, display_h=3}},
	on_added = function(self, level, x, y)
		level.map:particleEmitter(x, y, 3, "farportal_vortex")
		level.map:particleEmitter(x, y, 3, "farportal_lightning")
		level.map:particleEmitter(x, y, 3, "farportal_lightning")
		level.map:particleEmitter(x, y, 3, "farportal_lightning")
	end,
}

newEntity{
	define_as = "VOID_PORTAL",
	name = "Farportal: the Void",
	display = '&', color=colors.DARK_GREY, back_color=colors.VIOLET, image = "terrain/marble_floor.png",
	notice = true,
	always_remember = true,
	show_tooltip = true,
	desc = [[A farportal is a way to travel incredible distances in the blink of an eye. They usually require an external item to use. You have no idea if it is even two-way.
This one seems to go to an unknown place, seemingly out of this world. You dare not use it.]],
}
newEntity{ base = "VOID_PORTAL", define_as = "CVOID_PORTAL",
	image = "terrain/marble_floor.png",
	add_displays = {class.new{image="terrain/farportal-base.png", display_x=-1, display_y=-1, display_w=3, display_h=3}},
	on_added = function(self, level, x, y)
		level.map:particleEmitter(x, y, 3, "farportal_vortex", {vortex="shockbolt/terrain/farportal-void-vortex"})
		level.map:particleEmitter(x, y, 3, "farportal_lightning")
		level.map:particleEmitter(x, y, 3, "farportal_lightning")
		level.map:particleEmitter(y, y, 3, "farportal_lightning")
	end,
}

local invocation_close = function(self, who)
	if not who:hasQuest("high-peak") or who:hasQuest("high-peak"):isEnded() then return end
	-- Remove the level spot
	local spot = game.level:pickSpot{type="portal", subtype=self.summon}
	if not spot then return end
	game.logPlayer(who, "#LIGHT_BLUE#You use the orb on the portal, shutting it down easily.")
	for i = 1, #game.level.spots do if game.level.spots[i] == spot then table.remove(game.level.spots, i) break end end
	local g = game.level.map(spot.x, spot.y, engine.Map.TERRAIN)
	g.name = g.name .. " (disabled)"
	g.color_r = colors.WHITE.r
	g.color_g = colors.WHITE.g
	g.color_b = colors.WHITE.b
	g:removeAllMOs()
	game.level.map:updateMap(spot.x, spot.y)
	who:setQuestStatus("high-peak", engine.Quest.COMPLETED, "closed-portal-"..self.summon)
end

newEntity{
	define_as = "ORB_UNDEATH",
	name = "Invocation Portal: Undeath", image = "terrain/marble_floor.png", add_mos = {{image="terrain/demon_portal4.png"}},
	display = '&', color=colors.GREY, back_color=colors.PURPLE,
	notice = true,
	always_remember = true,
	show_tooltip = true,
	desc = [[An invocation portal, perpetually summoning beings through it.]],
	orb_command = {
		summon = "undead",
		special = invocation_close,
	},
}

newEntity{
	define_as = "ORB_ELEMENTS",
	name = "Invocation Portal: Elements", image = "terrain/marble_floor.png", add_mos = {{image="terrain/demon_portal4.png"}},
	display = '&', color=colors.LIGHT_RED, back_color=colors.PURPLE,
	notice = true,
	always_remember = true,
	show_tooltip = true,
	desc = [[An invocation portal, perpetually summoning beings through it.]],
	orb_command = {
		summon = "elemental",
		special = invocation_close,
	},
}

newEntity{
	define_as = "ORB_DRAGON",
	name = "Invocation Portal: Dragons", image = "terrain/marble_floor.png", add_mos = {{image="terrain/demon_portal4.png"}},
	display = '&', color=colors.LIGHT_BLUE, back_color=colors.PURPLE,
	notice = true,
	always_remember = true,
	show_tooltip = true,
	desc = [[An invocation portal, perpetually summoning beings through it.]],
	orb_command = {
		summon = "dragon",
		special = invocation_close,
	},
}

newEntity{
	define_as = "ORB_DESTRUCTION",
	name = "Invocation Portal: Destruction",  image = "terrain/marble_floor.png", add_mos = {{image="terrain/demon_portal4.png"}},
	display = '&', color=colors.WHITE, back_color=colors.PURPLE,
	notice = true,
	always_remember = true,
	show_tooltip = true,
	desc = [[An invocation portal, perpetually summoning beings through it.]],
	orb_command = {
		summon = "demon",
		special = invocation_close,
	},
}

newEntity{
	define_as = "PORTAL_BOSS",
	name = "Portal: The Sanctum", image = "terrain/marble_floor.png", add_mos = {{image="terrain/demon_portal4.png"}},
	display = '&', color=colors.LIGHT_BLUE, back_color=colors.PURPLE,
	notice = true,
	always_remember = true,
	show_tooltip = true,
	desc = [[This portal seems to connect to another part of this level.]],
	change_level_check = function() game.bignews:say(60, "#GOLD#这个传送门似乎需要多元水晶球来激活。") return true end,
	change_level = 1,
	orb_portal = {
		nothing = true,
		message = "#VIOLET#You enter the swirling portal and appear in a large room with other portals and the two wizards.",
		on_use = function()
			game:changeLevel(11, nil, {direct_switch=true}) -- Special level, can not get to it any other way
			if game.player:hasQuest("high-peak"):isCompleted("sanctum-chat") then return end
			local Chat = require "engine.Chat"
			local chat = Chat.new("sorcerer-fight", {name="Elandar"}, game.player)
			chat:invoke()
			game.player:hasQuest("high-peak"):setStatus(engine.Quest.COMPLETED, "sanctum-chat")
			game.player:hasQuest("high-peak"):start_end_combat()
		end,
	},
}

newEntity{
	define_as = "HIGH_PEAK_UP", image = "terrain/marble_floor.png", add_mos = {{image = "terrain/stair_up.png"}},
	name = "next level",
	display = '>', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = 1,
}

newEntity{
	define_as = "CAVE_HIGH_PEAK_UP", image = "terrain/cave/cave_floor_1_01.png", add_displays = {class.new{image="terrain/cave/cave_stairs_up_2_01.png"}},
	name = "next level",
	display = '>', color_r=255, color_g=255, color_b=0,
	notice = true,
	always_remember = true,
	change_level = 1,
}
