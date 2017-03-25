-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2017 Nicolas Casalini
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
chat_talent = player:getTalentFromId(chat_tid)
chat_level = player:getTalentLevelRaw(chat_tid)
local function generate_tools()
	local answers = {{"Cancel"}}
	for tid, m_tid in pairs(tool_ids) do
		local t = player:getTalentFromId(tid)
		local m_t = player:getTalentFromId(m_tid)
		if m_t then
			local master_talent = function(npc, player)
				local old_mastery_level = player:getTalentLevelRaw(m_tid)
				if old_mastery_level == chat_level then -- already selected and up to date
					game.log("#CADET_BLUE#%s 已经强化过了.", t.name)
					return 
				end
				-- unlearn mastery talent(s)
				for tid, m_tid in pairs(tool_ids) do
					if player:knowTalent(m_tid) then player:unlearnTalentFull(m_tid) end
				end
				
				player:learnTalent(m_tid, true, chat_level, {no_unlearn=true})
				player.artifice_tools_mastery = tid
				
				-- start talent cooldowns
				if old_mastery_level == 0 then
					player:startTalentCooldown(tid) player:startTalentCooldown(m_tid)
					game.log("#LIGHT_BLUE# 你强化了 %s.", t.name)
					player:talentDialogReturn(m_tid)
				end
			end
			answers[#answers+1] = {("%s[%s -- 强化: %s]#LAST#"):format(player.artifice_tools_mastery == tid and "#YELLOW#" or "", t.name, m_t.name),
				action=master_talent,
				on_select=function(npc, player)
					local mastery = nil
					game.tooltip_x, game.tooltip_y = 1, 1
					game:tooltipDisplayAtMap(game.w, game.h, "#GOLD#"..m_t.name.."#LAST#\n"..tostring(player:getTalentFullDescription(m_t, nil, {force_level=chat_level}, mastery)))
				end,
			}
		end
	end
	return answers
end

newChat{ id="welcome",
	text = [[强化哪件工具?]],
	answers = generate_tools(),
}

return "welcome"
