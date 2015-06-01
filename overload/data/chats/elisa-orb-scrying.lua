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

-- Check for unidentified stuff
local function can_auto_id(npc, player)
	for inven_id, inven in pairs(player.inven) do
		for item, o in ipairs(inven) do
			if not o:isIdentified() then return true end
		end
	end
end
local function can_not_auto_id(npc, player)
	return not can_auto_id(npc, player)
end

local function auto_id(header, footer, done)
	return function(npc, player)
		local list = {}
		for inven_id, inven in pairs(player.inven) do
			for item, o in ipairs(inven) do
				if not o:isIdentified() then
					o:identify(true)
					list[#list+1] = o:getName{do_color=true}
				end
			end
		end

		-- Create the chat
		newChat{ id="id_list",
			text = header..table.concat(list, "\n")..footer,
			answers = { {done} }
		}

		-- Switch to that chat
		return "id_list"
	end
end

----------------------------------------------------------------------
-- Yeek version
----------------------------------------------------------------------
if version == "yeek" then

newChat{ id="welcome",
	text = [[你专注你的意志与维网取得链接，使信息传输进来。]],
	answers = {
		{"[图像和知识传输了进来。]", cond=can_auto_id,
			action=auto_id("", "", "[你用精神意志传达对维网的谢意。]")
		},
		{"[你没有获得任何信息。]", cond=can_not_auto_id},
	}
}
return "welcome"

----------------------------------------------------------------------
-- Undead version
----------------------------------------------------------------------
elseif version == "undead" then

newChat{ id="welcome",
	text = [[你停了下来，开始回忆过去。]],
	answers = {
		{"[图像和知识涌现了出来。]", cond=can_auto_id,
			action=auto_id("", "", "[完成]")
		},
		{"[你没发现什么新东西。]", cond=can_not_auto_id},
	}
}
return "welcome"

----------------------------------------------------------------------
-- Elisa version
----------------------------------------------------------------------
else

newChat{ id="welcome",
	text = [[啊，你好 @playername@ ，有什么新东西给我看么？]],
	answers = {
		{"是的，埃莉萨，你能帮我看看这个物品么？[给她看看水晶球无法辨识的物品。]", cond=can_auto_id,
			action=auto_id("让我看看你搞到了什么……\n", "\n\n好极了，@playername@ ！", "谢谢你，埃莉萨！")
		},
		{"呃，没有……抱歉，我只想听听你甜美的声音。", jump="friend"},
		{"没事，抱歉！"},
	}
}

newChat{ id="friend",
	text = [[#LIGHT_GREEN#*你听到捂着嘴巴咯咯笑的声音*#WHITE#
呵，你实在#{bold}#太……#{normal}# 可爱了！]],
	answers = {
		{"再见，埃莉萨！"},
	}
}
return "welcome"

end
