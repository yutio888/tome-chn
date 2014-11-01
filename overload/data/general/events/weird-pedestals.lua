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

local function check(x, y)
	local list = {}
	for i = -1, 1 do for j = -1, 1 do
		if game.state:canEventGrid(level, x+i, y+j) then list[#list+1] = {x=x+i, y=y+j} end
	end end

	if #list < 3 then return false
	else return list end
end

local x, y = rng.range(3, level.map.w - 4), rng.range(3, level.map.h - 4)
local tries = 0
while not check(x, y) and tries < 500 do
	x, y = rng.range(3, level.map.w - 4), rng.range(3, level.map.h - 4)
	tries = tries + 1
end
if tries >= 500 then return false end

local grids = check(x, y)

for i = 1, 3 do
	local gr = rng.tableRemove(grids)
	local i, j = gr.x, gr.y

	local g = game.level.map(i, j, engine.Map.TERRAIN):cloneFull()
	g.name = "weird pedestal"
	g.display='&' g.color_r=255 g.color_g=255 g.color_b=255 g.notice = true
	g:removeAllMOs()
	if engine.Map.tiles.nicer_tiles then
		g.add_displays = g.add_displays or {}
		g.add_displays[#g.add_displays+1] = mod.class.Grid.new{image="terrain/pedestal_01.png", display_y=-1, display_h=2}
	end
	g:altered()
	g.grow = nil g.dig = nil
	g.x = i
	g.y = j
	g.special = true
	g.block_move = function(self, x, y, who, act, couldpass)
		if not who or not who.player or not act then return false end
		who:runStop("weird pedestal")
		if self.pedestal_activated then return false end
		require("engine.ui.Dialog"):yesnoPopup("Weird Pedestal", "Do you wish to inspect the pedestal?", function(ret) if ret then
			who:restInit(20, "inspecting", "inspected", function(cnt, max)
				if cnt > max then
					self.pedestal_activated = true
					self.block_move = nil
					self.autoexplore_ignore = true
					require("engine.ui.Dialog"):simplePopup("Weird Pedestal", "As you inspect it a shadow materializes near you, and suddenly it is no more a shadow!")

					local m = game.zone:makeEntity(game.level, "actor", {
						base_list=mod.class.NPC:loadList("/data/general/npcs/humanoid_random_boss.lua"),
						special_rarity="humanoid_random_boss",
						random_boss={
							nb_classes=1,
							rank=3, ai = "tactical",
							life_rating=function(v) return v * 1.3 + 2 end,
							loot_quality = "store",
							loot_quantity = 1,
							no_loot_randart = true,
							name_scheme = "#rng# the Invoker",
					}}, nil, true)
					local i, j = util.findFreeGrid(x, y, 5, true, {[engine.Map.ACTOR]=true})
					if i then
						game.level.map:particleEmitter(i, j, 1, "teleport")
						game.zone:addEntity(game.level, m, "actor", i, j)
						m.emote_random = {chance=30, "He shall come!", "You are dooooommmed!!", "He will consume all!", "My life for His!", "Die intruder!"}
						m.pedestal_x = self.x
						m.pedestal_y = self.y
						m.on_die = function(self)
							local g = game.level.map(self.pedestal_x, self.pedestal_y, engine.Map.TERRAIN)
							g:removeAllMOs()
							if g.add_displays then
								local ov = g.add_displays[#g.add_displays]
								ov.image = "terrain/pedestal_orb_0"..rng.range(1, 5)..".png"
							end
							game.level.map:updateMap(self.pedestal_x, self.pedestal_y)
							game.level.pedestal_events = (game.level.pedestal_events or 0) + 1
							game.logSeen(self, "%s's soul is absorbed by the pedestal. A glowing orb appears.", self.name:capitalize())

							if game.level.pedestal_events >= 3 then
								game.level.pedestal_events = 0							

								local m = game.zone:makeEntity(game.level, "actor", {
									base_list=mod.class.NPC:loadList{"/data/general/npcs/major-demon.lua", "/data/general/npcs/minor-demon.lua"},
									random_boss={
										nb_classes=2,
										rank=3.5, ai = "tactical",
										life_rating=function(v) return v * 2 + 5 end,
										loot_quantity = 0,
										no_loot_randart = true,
										name_scheme = "#rng# 末日行者",
										on_die = function(self) world:gainAchievement("EVENT_PEDESTALS", game:getPlayer(true)) end,
								}}, nil, true)

								local i, j = util.findFreeGrid(x, y, 5, true, {[engine.Map.ACTOR]=true})
								if i then
									game.level.map:particleEmitter(i, j, 1, "teleport")
									game.zone:addEntity(game.level, m, "actor", i, j)
									local o = game.zone:makeEntity(game.level, "object", {unique=true, not_properties={"lore"}}, nil, true)
									if not o then -- create artifact or randart
										o = game.state:generateRandart{lev=resolvers.current_level+10}
									end
									if o then
										game.zone:addEntity(game.level, o, "object")
										m:addObject(m.INVEN_INVEN, o)
									end
									require("engine.ui.Dialog"):simplePopup("Weird Pedestal", "You hear a terrible voice saying 'Their lives are mine! I am coming!'")
								end
							end
						end
					end
				end
			end)
		end end)
		return false
	end
	game.zone:addEntity(game.level, g, "terrain", i, j)
end

return true
