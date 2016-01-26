-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2016 Nicolas Casalini
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
local Tooltip = require "engine.Tooltip"
local Map = require "engine.Map"

module(..., package.seeall, class.inherit(Tooltip))

tooltip_bound_y2 = function() return game.uiset.map_h_stop_tooltip end

--- Gets the tooltips at the given map coord
function _M:getTooltipAtMap(tmx, tmy, mx, my)
	if self.locked then return nil end
	local tt = {}
	local seen = game.level.map.seens(tmx, tmy)
	local remember = game.level.map.remembers(tmx, tmy)
	
	local check = function(check_type,t)
		local to_add = game.level.map:checkEntity(tmx, tmy, check_type, "tooltip", game.level.map.actor_player)
		if t == "trap" then
			to_add = getTooltipTrapCHN(to_add)
		elseif t == "actor" then
			to_add = getTooltipActorCHN(to_add)
		elseif t == "grid" then
			to_add = getTooltipGridCHN(to_add)
		end
		if to_add then 
			if type(to_add) == "string" then to_add = to_add:toTString() end
			if to_add.is_tstring then 
				tt[#tt+1] = to_add 
			else 
				table.append(tt, to_add) 
			end
		end
		return to_add
	end
	
	if seen or remember and not core.key.modState("ctrl") then
		check(Map.TRAP,"trap")
		if seen then check(Map.ACTOR,"actor") end
		check(Map.OBJECT)

		if seen then
			-- search for all projectiles (kludge! consider implementing like Objects)
				local to_add
				for uid, e in pairs(game.level.entities) do
					if e.__is_projectile and e.x == tmx and e.y == tmy then
						to_add = e:check("tooltip", tmx, tmy)
						to_add = getTooltipProjectileCHN(to_add)
						if to_add then 
							if type(to_add) == "string" then to_add = to_add:toTString() end
							if to_add.is_tstring then 
								tt[#tt+1] = to_add 
							else 
								table.append(tt, to_add) 
							end
						end
					end
				end
		end
		
		check(Map.TERRAIN,"grid")
	end
	
	if #tt > 0 then
		return tt
	end
	return nil
end
