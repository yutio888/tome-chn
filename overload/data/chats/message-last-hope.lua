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
	text = [[终于见到你了， @playername@。我是最后的希望国王托拉克派来给你送信的。
我追随你的足迹找到你，令人印象深刻！很荣幸你是站在我们这一边的。
不聊了，信我已送到，我必须得走了。
#LIGHT_GREEN#他递给你一个密封的卷轴，然后消失在阴影中。#LAST#]],
	answers = {
		{"感谢你的勇气。", action=function(npc, player)
			local o, item, inven_id = npc:findInAllInventories("Sealed Scroll of Last Hope")
			if o then
				npc:removeObject(inven_id, item, true)
				player:addObject(player.INVEN_INVEN, o)
				player:sortInven()
				game.logPlayer(player, "The herald gives you %s.", o:getName{do_color=true})
			end

			if game.level:hasEntity(npc) then game.level:removeEntity(npc) end
		end},
	}
}

return "welcome"
