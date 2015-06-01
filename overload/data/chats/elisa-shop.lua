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

local function auto_id(npc, player)
	local list = {}
	local do_quest = false
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
		text = [[让我们看看你找到了什么好东西……
]]..table.concat(list, "\n")..[[

真是不错， @playername@!]],
		answers = {
			{"谢谢你，埃莉萨！", jump=do_quest and "quest" or nil},
		}
	}

	-- Switch to that chat
	return "id_list"
end

newChat{ id="welcome",
	text = [[你好朋友，我能帮你什么忙么？]],
	answers = {
		{"你能帮我看看这些物品么？[将未辨识的物品给她看。]", cond=can_auto_id, action=auto_id},
		{"没事，再见。"},
	}
}

newChat{ id="quest",
	text = [[等等， @playername@，你看上去像一个冒险家。也许你能帮助另外一个人。
你看，我#{bold}#热爱#{normal}#学习新的手稿和搜集拥有古老力量的物品。不过我自己并不是一个真正的冒险家，而且我如果出去冒险的话肯定会被杀掉。
所以拿着这个水晶球吧， (#LIGHT_GREEN#*她给了你一个辨识水晶*#WHITE#)。你可以在世界的任何一个角落用这个水晶球和我联络。要是你发现什么闪闪发光的好东西，你就可以随时随地给我看了！
我可以看到有趣的东西，而你又能知道你所获得的是什么装备，一举两得！听上去应该不错吧？
而且，你只要携带着它，它也会帮你辨认普通物品。]],
	answers = {
		{"哇～太好了，埃莉萨，这可太棒了！", action=function(npc, player)
			player:setQuestStatus("first-artifact", engine.Quest.COMPLETED)

			local orb = game.zone:makeEntityByName(game.level, "object", "ORB_SCRYING")
			if orb then player:addObject(player:getInven("INVEN"), orb) orb:added() orb:identify(true) end
		end},
	}
}

return "welcome"
