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

-----------------------------------------------------------
-- Non-yeek version
-----------------------------------------------------------

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*在你面前站着一个和半身人一样高的生物，拥有白色的毛发和不成比例的脑袋。
你同时注意到他不是用手在握持一把长剑，而是把剑漂浮在空中，像是受他的意志控制一样。*#WHITE#
你为什么救我，陌生人？你不是维网的人。]],
	answers = {
		{"好吧，你看上去似乎需要帮助。", jump="kindness"},
		{"那我自己也能割破你的喉咙！", action=function(npc, player) npc:checkAngered(player, false, -200) end},
	}
}

newChat{ id="kindness",
	text = [[#LIGHT_GREEN#*大剑在空中后退了些，显得不那么有敌意。他好像很吃惊。*#WHITE#
那么我代表维网感谢你。]],
	answers = {
		{"维网是什么东西，你是谁？", jump="what"},
	}
}

newChat{ id="what",
	text = [[维网是启迪、和平和守护，我是一个夺心魔。我穿过通道来到这个和我们的世界隔绝了几千年的世界来探险。]],
	answers = {
		{"你能告诉我更多有关维网的事么？", jump="way", action=function(npc, player)
			game.party:reward("Select the party member to receive the mental shield:", function(player)
				player.combat_mentalresist = player.combat_mentalresist + 15
				player:attr("confusion_immune", 0.10)
			end)
			game.logPlayer(player, "The contact with the Wayist mind has improved your mental shields. (+15 mental save, +10%% confusion resistance)")
		end},
--		{"那你想一个人在这个世界上闯荡？", jump="done"},
	}
}

newChat{ id="done",
	text = [[我不是一个人，我拥有维网。]],
	answers = {
		{"那么，再见。", action=function(npc, player) npc:disappear() end},
	}
}

newChat{ id="way",
	text = [[不行，不过我可以让你看一下。
#LIGHT_GREEN#*他靠向你，你的精神突然充满和平和幸福的感觉。*#WHITE#
这就是维网。]],
	answers = {
		{"谢谢你让我看到这些，再见吧，我的朋友。", action=function(npc, player)
			npc:disappear()
			game:setAllowedBuild("yeek", true)
		end},
	}
}

-----------------------------------------------------------
-- Yeek version
-----------------------------------------------------------

newChat{ id="yeek-welcome",
	text = [[感谢维网，这个……东西……差点杀了我。]],
	answers = {
		{"维网指引我来搜查这个通道。", jump="explore"},
	}
}

newChat{ id="explore",
	text = [[是的我也是，我们应该分头去探索这个大陆。]],
	answers = {
		{"再见，维网和我们同在。", action=function()
			game:setAllowedBuild("psionic")
			game:setAllowedBuild("psionic_mindslayer", true)
		end},
	}
}

return (game.party:findMember{main=true}.descriptor.race == "Yeek") and "yeek-welcome" or "welcome"
