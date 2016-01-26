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

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*一个高大的男人，全身像星星一样闪耀着光芒，在你面前出现了。*#WHITE#
你把它们都摧毁了？真抱歉我们刚见面时候我对你有点刻薄，不过修复时间实在太紧迫了。
我不能留在这里，我还有很多事情要做。带上这个，它也许会对你有帮助。
#LIGHT_GREEN#*你刚想回答，他就又消失了。面前出现一道时空裂缝，希望是通往马基埃亚尔的……*#WHITE#]],
	answers = {
		{"好吧。。。", action = function(npc, player) game:onLevelLoad("temporal-rift-4", function()
			local o = game.zone:makeEntityByName(game.level, "object", "RUNE_RIFT")
			if o then
				o:identify(true)
				game.zone:addEntity(game.level, o, "object")
				game.player:addObject(game.player.INVEN_INVEN, o)
				game.log("The temporal warden gives you: %s.", o:getName{do_color=true})
			end

			game:setAllowedBuild("chronomancer")
			game:setAllowedBuild("chronomancer_temporal_warden", true)

			local g = game.zone:makeEntityByName(game.level, "terrain", "RIFT")
			g.change_level = 3
			g.change_zone = "daikara"
			local oe = game.level.map(game.player.x, game.player.y, engine.Map.TERRAIN)
			if oe:attr("temporary") and oe.old_feat then 
				oe.old_feat = g
			else
				game.zone:addEntity(game.level, g, "terrain", game.player.x, game.player.y)
			end
		end) end},
	}
}

return "welcome"
