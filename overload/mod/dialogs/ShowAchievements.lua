-- TE4 - T-Engine 4
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
local Tiles = require "engine.Tiles"
local ShowAchievements = require "engine.dialogs.ShowAchievements"

module(..., package.seeall, class.inherit(ShowAchievements))

function _M:generateList(kind)
	local tiles = Tiles.new(16, 16, nil, nil, true)
	local cache = {}

	-- Makes up the list
	local list = {}
	local i = 0
	local function handle(id, data)
		local a = world:getAchievementFromId(id)
		local color = nil
		if self.player and self.player.achievements and self.player.achievements[id] then
			color = colors.simple(colors.LIGHT_GREEN)
		end
		local img = a.image or "trophy_gold.png"
		local tex = cache[img]
		if not tex then
			local image = tiles:loadImage(img)
			if image then
				tex = {image:glTexture()}
				cache[img] = tex
			end
		end
		if not data.notdone or a.show then
			local ACHN = require "data-chn123.achievements"
			local name = ACHN:getName(a.name)
			local category = ACHN:getCategory(a.category)
			local desc = ACHN:getDesc(a.name, a.desc)
			if a.show == "full" or not data.notdone then
				list[#list+1] = { name=name, color=color, desc=desc, category=category or "--", when=data.when, who=data.who, order=a.order, id=id, tex=tex, a=a }
			elseif a.show == "none" then
				list[#list+1] = { name="???", color=color, desc="-- 未知 --", category=category or "--", when=data.when, who=data.who, order=a.order, id=id, tex=tex, a=a }
			elseif a.show == "name" then
				list[#list+1] = { name=name, color=color, desc="-- 未知 --", category=category or "--", when=data.when, who=data.who, order=a.order, id=id, tex=tex, a=a }
			else
				list[#list+1] = { name=name, color=color, desc=desc, category=category or "--", when=data.when, who=data.who, order=a.order, id=id, tex=tex, a=a }
			end
			i = i + 1
		end
	end
	if kind == "self" and self.player and self.player.achievements then
		for id, data in pairs(self.player.achievements) do handle(id, world.achieved[id] or {notdone=true, when="--", who="--"}) end
	elseif kind == "main" then
		for id, data in pairs(world.achieved) do
			local a = world.achiev_defs[id]
			if a.no_difficulty_duplicate or ((a.difficulty or a.permadeath) and (not a.difficulty or a.difficulty == game.difficulty) and (not a.permadeath or a.permadeath == game.permadeath)) then
				handle(id, data or {notdone=true, when="--", who="--"})
			end
		end
	elseif kind == "all" then
		for _, a in ipairs(world.achiev_defs) do
			if a.no_difficulty_duplicate or not (a.difficulty or a.permadeath) or ((not a.difficulty or a.difficulty == game.difficulty) and (not a.permadeath or a.permadeath == game.permadeath)) then
				handle(a.id, world.achieved[a.id] or {notdone=true, when="--", who="--"})
			end
		end
	end
	table.sort(list, function(a, b) return a.name < b.name end)
	self.list = list
end
