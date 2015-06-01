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

local p = game.party:findMember{main=true}
if p:attr("forbid_arcane") and not npc.antimagic_ok then

newChat{ id="welcome",
	text = text,
	answers =
	{
		{"#LIGHT_GREEN#[假装帮忙，现在是你使用伊格兰斯的能力破坏传送门的时候了。@npcname@ 将会被送到伊格接受他应有的“待遇”。]#WHITE#\n带路，我会保护你的。", action=function(npc, player)
			player:hasQuest(npc.quest_id).to_zigur = true
			npc.ai_state.tactic_leash = 100
			game.party:addMember(npc, {
				control="order",
				type="escort",
				title="Escort",
				orders = {escort_portal=true, escort_rest=true},
			})
		end},
		{"走开，我不会帮助肮脏的奥术魔法信徒！", action=function(npc, player)
			game.player:registerEscorts("lost")
			npc:disappear()
			npc:removed()
			player:hasQuest(npc.quest_id).abandoned = true
			player:setQuestStatus(npc.quest_id, engine.Quest.FAILED)
		end},
	},
}

else

if not npc.antimagic_ok and profile.mod.allow_build.birth_zigur_sacrifice and not p:attr("has_arcane_knowledge") then

newChat{ id="welcome",
	text = text,
	answers =
	{
		{"带路，我会保护你。", action=function(npc, player)
			npc.ai_state.tactic_leash = 100
			game.party:addMember(npc, {
				control="order",
				type="escort",
				title="Escort",
				orders = {escort_portal=true, escort_rest=true},
			})
		end},
		{"#LIGHT_GREEN#[假装帮忙，制造一个传送门将 @npcname@ 传送至伊格，他会得到“妥善”处置。]#WHITE#\n带路，我会保护你。", action=function(npc, player)
			player:hasQuest(npc.quest_id).to_zigur = true
			npc.ai_state.tactic_leash = 100
			game.party:addMember(npc, {
				control="order",
				type="escort",
				title="Escort",
				orders = {escort_portal=true, escort_rest=true},
			})
		end},
		{"走开，我可没有义务帮助弱者。", action=function(npc, player)
			game.player:registerEscorts("lost")
			npc:disappear()
			npc:removed()
			player:hasQuest(npc.quest_id).abandoned = true
			player:setQuestStatus(npc.quest_id, engine.Quest.FAILED)
		end},
	},
}

else

newChat{ id="welcome",
	text = text,
	answers =
	{
		{"带路，我会保护你的。", action=function(npc, player)
			npc.ai_state.tactic_leash = 100
			game.party:addMember(npc, {
				control="order",
				type="escort",
				title="Escort",
				orders = {escort_portal=true, escort_rest=true},
			})
		end},
		{"走开，我没有义务照顾弱者。", action=function(npc, player)
			game.player:registerEscorts("lost")
			npc:disappear()
			npc:removed()
			player:hasQuest(npc.quest_id).abandoned = true
			player:setQuestStatus(npc.quest_id, engine.Quest.FAILED)
		end},
	},
}

end

end

return "welcome"
