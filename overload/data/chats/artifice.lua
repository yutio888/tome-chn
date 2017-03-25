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
	local answers = {{"[Cancel]"}}
	local tool_ids = tool_ids or player.main_env.artifice_tool_tids
	player.artifice_tools = player.artifice_tools or {}
	
	for tid, m_tid in pairs(tool_ids) do
		local t = player:getTalentFromId(tid)
		if t then

			local tool_level = player:getTalentLevelRaw(t)
			local equip_tool = function(npc, player) -- equip a tool
				if tool_level == chat_level then -- already selected and up to date
					game.log("#CADET_BLUE#%s 已经在等级 %d被装备了.", t.name, tool_level)
					player:talentDialogReturn()
					return
				end
				-- unlearn the previous talent
				player:unlearnTalentFull(player.artifice_tools[chat_tid])
				-- (re)learn the talent
				player:unlearnTalentFull(tid)
				player:learnTalent(tid, true, chat_level, {no_unlearn=true})
				-- clear other tool slots
				for slot, tool_id in pairs(player.artifice_tools) do
					if tool_id == tid then player.artifice_tools[slot] = nil end
				end
				player.artifice_tools[chat_tid] = tid

				-- start talent cooldowns and use energy
				player:startTalentCooldown(tid)
				if player:getTalentFromId(m_tid) then player:startTalentCooldown(m_tid) end
				game.log("#CADET_BLUE#在 %s 上装备了 %s (等级 %d).", t.name, chat_talent.name, chat_level)
				player:talentDialogReturn(tid, m_tid)
			end
			local txt, slot
			-- check for an existing slot
			for slot_id, tool_id in pairs(player.artifice_tools) do
				if tool_id == tid then slot = slot_id break end
			end
			if slot then
				txt = ("[%s装备 %s%s#LAST#]"):format(slot==chat_tid and "#YELLOW#" or "", t.name, slot and (" (%s)"):format(player:getTalentFromId(slot).name) or "")
			else
				txt = ("[装备 %s]"):format(t.name)
			end

			answers[#answers+1] = {txt,
				action=equip_tool,
				on_select=function(npc, player)
					local display_level
					display_level = chat_level - tool_level
					game.tooltip_x, game.tooltip_y = 1, 1

					-- set up tooltip
					local text = tstring{}
					if display_level ~= 0 and player:knowTalent(t) then
						local diff = function(i2, i1, res)
							if i2 > i1 then
								res:add({"color", "LIGHT_GREEN"}, i1, {"color", "LAST"}, " [->", {"color", "YELLOW_GREEN"}, i2, {"color", "LAST"}, "]")
							elseif i2 < i1 then
								res:add({"color", "LIGHT_GREEN"}, i1, {"color", "LAST"}, " [->", {"color", "LIGHT_RED"}, i2, {"color", "LAST"}, "]")
							end
						end
						text:merge(player:getTalentFullDescription(t, display_level, nil):diffWith(player:getTalentFullDescription(t, 0, nil), diff))
					else
						text = player:getTalentFullDescription(t, nil, {force_level=chat_level})
					end
					game:tooltipDisplayAtMap(game.w, game.h, "#GOLD#"..t.name.."#LAST#\n"..tostring(text))
				end,
			}
		end
	end

	return answers
end

newChat{ id="welcome",
	text = ([[装备哪件工具在#YELLOW#%s#LAST#上?]]):format(chat_talent.name),
	answers = generate_tools(),
}

return "welcome"
