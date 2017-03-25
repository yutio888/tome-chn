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

local function evil(npc, player)
	engine.Faction:setFactionReaction(player.faction, npc.faction, 100, true)
	player:setQuestStatus("lost-merchant", engine.Quest.COMPLETED, "evil")
	player:setQuestStatus("lost-merchant", engine.Quest.COMPLETED)
	world:gainAchievement("LOST_MERCHANT_EVIL", player)
	game:setAllowedBuild("rogue_poisons", true)
	local p = game.party:findMember{main=true}
	if p.descriptor.subclass == "Rogue"  then
		if p:knowTalentType("cunning/poisons") == nil then
			p:learnTalentType("cunning/poisons", true)
			p:setTalentTypeMastery("cunning/poisons", 1.3)
		end
	end
	if p:knowTalentType("cunning/trapping") then
		game.log("#LIGHT_GREEN#你和强盗首领进行了深入的讨论, 交流了刺客技艺与一些陷阱技巧。")
		game.state:unlockTalent(player.T_AMBUSH_TRAP, player)
	end

	game:changeLevel(1, "wilderness")
	game.log("As you depart the assassin lord says: 'And do not forget, I own you now.'")
end

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*在你面前站着一个穿着黑衣服的凶恶男人。*#WHITE#
啊，一个入侵者……我该怎么处置你呢？你为什么杀我的人？]],
	answers = {
		{"我听到了哭喊声……然后你的人挡了我的道。这里发生了什么事？", jump="what"},
		{"我以为这里可能有财宝。", jump="greed"},
		{"抱歉，我得走了！", jump="hostile"},
	}
}

newChat{ id="hostile",
	text = [[哦，恐怕你哪儿都不能去，给我杀了他！]],
	answers = {
		{"[攻击]", action=function(npc, player) engine.Faction:setFactionReaction(player.faction, npc.faction, -100, true) end},
		{"等一下！也许我们有什么其他的解决办法。你看上去像一个通情达理的人。", jump="offer"},
	}
}

newChat{ id="what",
	text = [[哦，你以为在你攻击我之前我会告诉你我的计划吗？抓住这个入侵者！]],
	answers = {
		{"[攻击]", action=function(npc, player) engine.Faction:setFactionReaction(player.faction, npc.faction, -100, true) end},
		{"等一下！也许我们有什么其他的解决办法。你看上去像一个通情达理的人。", jump="offer"},
	}
}
newChat{ id="greed",
	text = [[恐怕今天你不太走运，那个商人是我们的了……还有你也是！抓住这个入侵者！！]],
	answers = {
		{"[攻击]", action=function(npc, player) engine.Faction:setFactionReaction(player.faction, npc.faction, -100, true) end},
		{"等一下！也许我们有什么其他的解决办法。你看上去像一个通情达理的人。", jump="offer"},
	}
}

newChat{ id="offer",
	text = [[好吧，我需要人来帮我顶替你杀掉的那个人的位置，你看上去挺强壮，也许你能替我服务。
你得帮我做点脏活，然后你就跟定我了，不过，如果你的实力有你看上去那么强劲的话，你也能在冒险过程中得到你的好处。
不要试图和我对抗，那……可不明智。]],
	answers = {
		{"好吧，至少比死在这里好。", action=evil},
		{"有钱赚？我加入！", action=evil},
		{"放走那个商人，让我们离开这里，要不然你就去死吧！", action=function(npc, player) engine.Faction:setFactionReaction(player.faction, npc.faction, -100, true) end},
	}
}

return "welcome"
