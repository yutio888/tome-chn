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

newChat{ id="welcome",
	text = [[欢迎你 @playername@ ，光临我的商店。]],
	answers = {
		{"让我看看你的货物", action=function(npc, player)
			npc.store:loadup(game.level, game.zone)
			npc.store:interact(player)
		end},
		{"我在寻求军事训练。", jump="training"},
		{"抱歉，我必须得走了！"},
	}
}

newChat{ id="training",
	text = [[我的确可以为你提供军事训练（技巧/战斗训练系），你需要花费50金币，或者可以学习使用弓和投石索（射击天赋），花费8金币。]],
	answers = {
		{"请教我通用武器和护甲的使用方法。", action=function(npc, player)
			game.logPlayer(player, "The smith spends some time with you, teaching you the basics of armour and weapon usage.")
			player:incMoney(-50)
			player:learnTalentType("technique/combat-training", true)
			player.changed = true
		end, cond=function(npc, player)
			if player.money < 50 then return end
			if player:knowTalentType("technique/combat-training") then return end
			return true
		end},
		{"请教我使用弓和投石索。", action=function(npc, player)
			game.logPlayer(player, "The smith spends some time with you, teaching you the basics of bows and slings.")
			player:incMoney(-8)
			player:learnTalent(player.T_SHOOT, true, nil, {no_unlearn=true})
			player.changed = true
		end, cond=function(npc, player)
			if player.money < 8 then return end
			if player:knowTalent(player.T_SHOOT) then return end
			return true
		end},
		{"不用了，谢谢。"},
	}
}

return "welcome"
